/**
 * A module for handling methods relating to an inline datetimepicker which is inside a wrapper
 * and behaves somewhat like a modal.
 * Note: To see documentation for the datetimepicker used visit: http://eonasdan.github.io/bootstrap-datetimepicker
 *       For documentation of moment.js visit: http://momentjs.com/docs
 * @author Joseph Krump
 * @param  {Jquery} $)
 * @return {Object} - An object containing any of the publicly accessible methods of this module.
 */
var DatePickerWrapper = (function($){
  $(document).on('content-ready', function (e, element) {
    // Add PST timezone
    // moment.tz.add('PST|PST PDT|80 70|0101|1Lzm0 1zb0 Op0');

    $(element).find('.datepicker-opener').each(function () {
      initDatePicker($(this));
    });

    // A separate (simple) time picker that is optionally used within the datepicker
    $(element).find('input.format-as-time').change(function (e) {
      inputFieldChanged(this);
    });
  });

  /**
   * Create a single datepicker to be used in a modal
   * @return {undefined}
   */
  var initDatePicker = function($btn) {
    var $wrapper = $btn.parent().find('.datepicker-wrapper');
    var $dpElement = $wrapper.find('.inline-dp-root');
    var $ioElem = $($btn.data('io-selector'));
    var dateOnly = $btn.hasClass('date-only');
    var btnFormat = $btn.data('btn-format') || ('MMM. D, YYYY' + (dateOnly ? '' : ' h:mm A'));
    var useBrowserTimezone = $btn.hasClass('use-browser-timezone');
    var configInitialDate = $btn.data('initial-date');
    // callback = $btn.data('on-date-change'); // needs to happen later for setting it late

    var dpOptions = {
      format: 'MM/DD/YYYY',
      inline: true,
      sideBySide: true, // set to false if you want to time picker to be accessible in toolbar.
    };

    if ($btn.data('disabled-weekdays')) { dpOptions['daysOfWeekDisabled'] = $btn.data('disabled-weekdays'); }
    if ($btn.data('view-mode')        ) { dpOptions['viewMode']           = $btn.data('view-mode');         }

    dpOptions['icons'] = {
      time: 'icon icon-clock',
      date: 'icon icon-calendar',
      up: 'icon icon-up',
      down: 'icon icon-down',
      previous: 'icon icon-left',
      next: 'icon icon-right',
      today: 'icon icon-crosshair',
      clear: 'icon icon-trash',
      close: 'icon icon-cancel'
    };

    var $timeField = $wrapper.find('.time_field');
    dateOnly ? $timeField.addClass('hidden-xs-up') : $timeField.removeClass('hidden-xs-up');

    var $dp;

    if($dpElement.length === 0){
      console.warn("Datepicker error - root node not found");
      return null;
    }

    $dpElement.datetimepicker(dpOptions);

    $dp = $dpElement.data('DateTimePicker');

    /**
     * Handles the datepicker's value changing.
     * @param  {Event} e - the dp.change event. Contains date and oldDate
     * @return {undefined}
     */
    var dpDateChanged = function(e) {
      var format      = e.data.format;
      var $inputField = $wrapper.find('input.' + (format === 'LT' ? 'time' : 'date') + '-only');

      $inputField.val(e.date.format(format));
    };

    $dpElement.on('dp.change', {format: 'MM/DD/YYYY'}, dpDateChanged);
    $dpElement.on('dp.change', {format: 'LT'},         dpDateChanged);

    // Prefer an already saved date ($ioElem), then a configured one, the wrapper is a last resort (for the timezone)
    var initialDateStr = $ioElem.val() ? $ioElem.val() : (configInitialDate ? configInitialDate : $wrapper.data('initial-date'));
    var initialDate = moment(initialDateStr, moment.ISO_8601);
    if (!useBrowserTimezone) {
      // '.utcOffset()' of the DB value allows us to use the server's time zone instead of the browser's
      initialDate.utcOffset(initialDateStr);
    }
    $dp.date(initialDate);

    /**
     * Toggles the visiblity of the dp
     * @param  {Event} e - The click event on the button that toggled the visiblity
     * @return undefined
     */
    var toggleVisibility = function(e) {
      e.preventDefault();

      $btn.addClass('toggled');
      $wrapper.toggleClass('active');

      if (!$wrapper.hasClass('active')) {
        saveDate();
      }
    };

    /**
     * Save the chosen datetime - the datepicker is closing
     * @return undefined
     */
    var saveDate = function (e) {
      if($dp !== undefined){
        var callback = $btn.data('on-date-change');
        if (callback) {
          callback($dp.date());
        }

        if (btnFormat != 'manual') {
          var $to_replace = $btn.find('.update-date');
          if ($to_replace.length == 0) {
            $to_replace = $btn;
          }
          $to_replace.html($dp.date().format(btnFormat));
        }

        $ioElem.val(dateOnly ? $dp.date().format('YYYY-MM-DD') : $dp.date().toISOString());
      }
    };

    // When either the close button or the button that opens the datepicker are clicked,
    // Toggle the visiblity of the corresponding datetimepicker.
    //
    $wrapper.find('.close-dp').click(toggleVisibility);
    $btn.click(toggleVisibility);

    // NOTE: TEMPORARILY REMOVED. THIS WOULD SWITCH BETWEEN THE DATEPICKER AND THE TIME
    //       PICKER DEPENDING ON WHAT INPUT IS IN FOCUS - JK
    // $('.datepicker-fields input[type=text]').focus(function(e){
    //   e.preventDefault();

    //   if($dp.format() === 'MM/DD/YYYY' && $(this).hasClass('format-as-time')){
    //     $dp.hide().format('LT').show();
    //   } else if($dp.format() === 'LT' && $(this).hasClass('date-only')) {
    //     $dp.hide().format('MM/DD/YYYY').show();
    //   }
    // });

    $wrapper.find('input.date-only').change(function(e){
      inputFieldChanged(this);
    });
  };

  /**
   * [inputFieldChanged description]
   * @param  {[type]} inputField [description]
   * @return {[type]}            [description]
   */
  var inputFieldChanged = function(inputField) {

    var $inputField = $(inputField);
    var inputfieldFormat = $inputField.hasClass('format-as-time') ? 'LT' : 'MM/DD/YYYY';

    // get the number of integers in the string.
    var intsCount = $inputField.val().replace(/[^0-9]/g,"").length;
    var originalFormat = inputfieldFormat;
    // The format used for Time as 'HH:MM am/pm' is LT
    var isTime = originalFormat === 'LT' ? true : false;

    inputfieldFormat = setDateFormat(inputfieldFormat, intsCount);
    var newMomentObject = moment($inputField.val(), inputfieldFormat);

    var $wrapper = $inputField.parents('.datepicker-wrapper');
    var $dp = ($wrapper.length > 0) ? $wrapper.find('.inline-dp-root').data('DateTimePicker') : undefined;

    // Based on whether the momentObject is valid or not (using moment.js .isValid()), add, or remove the 'has-error'
    // class and change the value in the input field and for the datetimepicker.
    if(newMomentObject.isValid()){
      if($dp !== undefined) {
        setDateTimePickerDateTime($dp, isTime, newMomentObject);
      }
      // If there were any error classes added to this input field's parent  then remove them.
      $inputField.parent().removeClass('has-error');
      // Set the input field's value to the formatted value.
      $inputField.val(newMomentObject.format(originalFormat));
    } else {

      resetToDefault($inputField, $dp);
      // If validation failed then add the 'has-error' class to the input field's parent
      // Note: 'has-error' is a bootstrap class.
      $inputField.parent().addClass('has-error');
    }
  };

  /**
   * Method for resetting a specific part of the datepicker to it's default value
   * @param {Object} $inputField - The specific field (date or time) to reset
   * @param {DatePicker} $dp     - The current datetimepicker
   */
  function resetToDefault($inputField, $dp){
    var inputfieldFormat = $inputField.hasClass('format-as-time') ? 'LT' : 'MM/DD/YYYY';
    var isTime = inputfieldFormat === 'LT' ? true : false;
    var newMoment;

    if(isTime){
      newMoment = moment('10:00 AM', 'H:mm A');
      $inputField.val(newMoment.format('H:mm A'));
      setDateTimePickerDateTime($dp, isTime, newMoment);
    } else {
      newMoment = moment();
      $inputField.val(newMoment.format(inputfieldFormat));
      setDateTimePickerDateTime($dp, isTime, newMoment);
    }
  }

  /**
   * Resets the values of the dp's input fields while
   * still preserving the date store for the dp so if
   * opened again, the user can continue where they left off.
   * @param  {Object} $wrapper - The DOM element that contains the datepicker wrapper
   * @return undefined
   */
  function resetDP($btn){
    var $wrapper = $btn.parent().find('.datepicker-wrapper');
    $wrapper.find('input[type=text]').each(function(){
      $(this).val(''); // reset the value in the input fields
    });

    var $ioElem  = $($btn.data('io-selector'));
    $ioElem.val('');
  }

  function setDateTimePickerDateTime($dp, isTime, newMomentObject){
    if($dp !== undefined){
      var currentDate = $dp.date();

      // Set the appropriate values to update the current moment object that is used to keep track of
      // the datetimepicker widget's datetime.
      if(isTime){
        currentDate.hour(newMomentObject.hour()).minute(newMomentObject.minute());
      } else {
        currentDate.year(newMomentObject.year()).month(newMomentObject.month()).date(newMomentObject.date());
      }

      // Set the datetimepicker to be the moment that was set.
      $dp.date(currentDate);
      return currentDate;
    }
  }

  /**
   * Sets the correct datepicker format to use based on the number of
   * ints in the string that was entered.
   * @param {string} inputfieldFormat - The string that was entered into a date text field.
   * @param {int} intsCount - The number of integers persent in the date string that was entered.
   * @return {string} - a string containing the date format to use.
   */
  function setDateFormat(inputfieldFormat, intsCount){
    if(inputfieldFormat === 'MM/DD/YYYY' && intsCount <= 7){
      inputfieldFormat = 'MM/DD/YY';
    }
    return inputfieldFormat;
  }

  // Return API for other modules
  return {
    reset: resetDP
  };
})(jQuery);
