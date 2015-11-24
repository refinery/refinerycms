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
      setOpenBtnListeners($(this), undefined);
    });
  });

  /**
   * Sets listeners for the open modal btn.
   * @param $openBtn - DOM Object
   * @param successCallback - Method to call on completion of something (typically a form being submitted)
   */
  function setOpenBtnListeners($openBtn, successCallback){
    $openBtn.click(function(e) {
      e.preventDefault(); // Stops this from submitting a form if it is in one
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

    /** FIXME: create hideAllSidebars() in menus.js
    $('#sidebar-right').sidebar('hide');
    $('#sidebar-left').sidebar('hide');
    */
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
    formSourceUrl = (formSourceSelector === '') || (formSourceSelector === undefined) ? formSourceUrl : formSourceUrl+formSourceSelector;

    $modalContent.load(formSourceUrl, function(){
      $(document).trigger('content-ready', $modalContent);

      var $form = $modal.find('form');
      var $saveBtn = $modal.find('.btn-submit-modal');
      var saveBtnHtml = $saveBtn.html();

      $modal.find('.header'          ).html(contentParams['modalTitle']);
      $modal.find('.btn-submit-modal').html(contentParams['submitBtnTxt']);
      $modal.modal('show');

      $saveBtn.unbind().click(function(e){
        $saveBtn.html('<i class="active inline xs loader"></i> Sending');
        $saveBtn.attr('disabled', 'disabled');
        $form.trigger('form-before-submit');
        $form.submit();
      });

      $form.data('on-complete-callback', function(response) {
        // Remove form (Simple solution atm to remove image)

        $saveBtn.html(saveBtnHtml);
        $saveBtn.removeAttr('disabled');

        if(successCallback !== undefined){
          successCallback(response);
        }

        if(updateOnSuccess){
          CanvasForms.ajaxUpdateContent(updateOnSuccess);
        }

        $modalContent.find('#form-wrapper').remove();
        $modal.modal('hide');

        // reopen the right sidebar
        var $rightSidebar = $('#sidebar-right');
        if($rightSidebar.length > 0){
          $rightSidebar.sidebar('show');
        }

        return false;
      });
    });
  }
  return {
    setOpenBtnListeners: setOpenBtnListeners,
    openBtnClickHandler: openBtnClickHandler
  };
})(jQuery);
