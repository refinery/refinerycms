/**
 * Methods involving Semantic-UI modals
 * @author Jkrump
 * @created 12-06-2014
 * @updated 04-20-2015
 */
var GlassModals = (function ($) {

  $(document).on('content-ready', function (e, element) {
    $(element).find('.btn-modal-cancel').unbind('click').click(function(e){
      e.preventDefault();
      var $modal = $(this).closest('.modal');
      $modal.modal('hide');
    });
    $(element).find('.open-modal').each(function () {
      $(this).click(function (e) {
        e.preventDefault();
        openBtnClickHandler($(this), undefined);
      });
    });
  });

  /**
   * Sets listeners for the open modal btn.
   * @param $openBtn - DOM Object
   * @param successCallback - Method to call on completion of something (typically a form being submitted)
   */
  function setOpenBtnListeners($openBtn, successCallback){
    $openBtn.unbind('click').click(function(e){
      e.preventDefault();
      openBtnClickHandler($openBtn, successCallback);
    });
  }

  /**
   * Handler for open modal btn being clicked.
   *
   * @param $openBtn         <DOM Object> - The button that was clicked
   * @param successCallback  <function>   - A method to call once a form in the modal has been successfully submitted.
   */
  function openBtnClickHandler($openBtn, successCallback){
    // The openBtn must have a data attribute that specifies the
    // selector for the modal that it should trigger: ex: '#create-author-modal'
    var modalSelector = $openBtn.data('modal-selector');
    var $modal        = modalSelector ? $(modalSelector) : $('#sub-form-modal');
    var $modalContent = $modal.find('.description');
    var url           = $openBtn.attr('href') !== undefined ? $openBtn.attr('href') : $openBtn.attr('data-url');
    var formSelector  = ' ' + ($openBtn.attr('data-form-selector') || 'form');
    var updateOnClose = $openBtn.data('update-on-close');
    var modalTitle    = $openBtn.data('modal-title')      ? $openBtn.data('modal-title')      : $openBtn.text();
    var submitBtnTxt  = $openBtn.data('modal-submit-btn') ? $openBtn.data('modal-submit-btn') : 'Submit';

    // Check if this modal will be displaying a form.
    //
    if($modal.hasClass('confirm')){
      // Modal has a form and it is a two step submission process.
      var $finalConfirmButton = $modal.find('.btn-confirm');
      var $previousConfirmButton = $modal.find('.btn-previous-confirm');

      if($previousConfirmButton.length > 0){
        $modal.modal({closable: false});
        $previousConfirmButton.unbind('click').click(function(e){
          e.preventDefault();
          if(successCallback !== undefined){
            successCallback();
          }
        });
        $finalConfirmButton.unbind('click').click(function(){
          $modal.modal('hide');
        });
      } else if($finalConfirmButton.length > 0){
        $finalConfirmButton.unbind('click').click(function(e){
          e.preventDefault();
          if(successCallback !== undefined){
            successCallback();
          }
        });
      }

      $modal.modal('show');
    } else if($modalContent.find('#form-wrapper').length === 0){
      if(url === undefined){
        console.warn('URL undefined for form');
        return 1;
      }

      loadAndDisplayFormModal(url, formSelector, $modalContent, $modal, successCallback, updateOnClose, {modalTitle: modalTitle, submitBtnTxt: submitBtnTxt});
    } else {
      // If the modal already has a form in it, then just re-show the modal.
      $modal.modal('show');
    }
    $('#sidebar-right').sidebar('hide');
    $('#sidebar-left').sidebar('hide');
  }

  /**
   * Loads a form from some URL into a modal and displays it.
   *
   * @param formSourceUrl    <String>     - The url that points to the view that contains the form to display.
   * @param formSourceSelector <String>   - The selector for the form
   * @param $modalContent    <DOM Object> - The content in the main body of the modal
   * @param $modal           <DOM Object> - The modal that will display and contain the form.
   * @param successCallback  <function>   - A method to call upon form successfully being submitted.
   * @param updateOnSuccess  <String>     - Selector for what part of the page to refresh (via ajax) on success
   * @param contentParams    <Hash>       - Content for the modal like submit btn text and modal title
   */
  function loadAndDisplayFormModal(formSourceUrl, formSourceSelector, $modalContent, $modal, successCallback, updateOnSuccess, contentParams){
    var $saveBtn        = $modal.find('.btn-submit-modal');
    var $removeImageBtn = null;

    formSourceUrl = (formSourceSelector === '') || (formSourceSelector === undefined) ? formSourceUrl : formSourceUrl+formSourceSelector;

    $modalContent.load(formSourceUrl, function(){
      $(document).trigger('content-ready', $modalContent);

      $saveBtn.unbind().click(function(e){
        var saveBtnHtml = $saveBtn.html();
        $saveBtn.html('<i class="ui active inline inverted xs loader"></i> Sending');
        $saveBtn.attr('disabled', 'disabled');

        e.preventDefault();
        var $form = $modal.find('form');
        var $rightSidebar = $('#sidebar-right');
        $form.submit();

        // Listen for 'form-submit-success' event fired from
        // CanvasForms after success.
        $form.on('form-submit-success', function(e, response, statusText, xhr, element) {
          // Remove form (Simple solution atm to remove image)
          $saveBtn.html(saveBtnHtml);
          $saveBtn.removeAttr('disabled');
          if(successCallback !== undefined){
            successCallback();
          }
          if(! $saveBtn.hasClass('positive')){
            $modal.modal('hide');
          }
          if(updateOnSuccess){
            CanvasForms.ajaxUpdateContent(updateOnSuccess);
          }

          $modalContent.find('#form-wrapper').remove();
          // reopen the right sidebar
          if($rightSidebar.length > 0){
            $rightSidebar.sidebar('show');
          }
        });
      });
      $modal.find('.header'          ).html(contentParams['modalTitle']);
      $modal.find('.btn-submit-modal').html(contentParams['submitBtnTxt']);
      $modal.modal('show');
    });
  }
  return {
    setOpenBtnListeners: setOpenBtnListeners
  };
})(jQuery);
