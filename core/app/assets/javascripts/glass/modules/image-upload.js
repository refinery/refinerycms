var GlassImageUploader = (function ($) {

  var $CURRENT_IMAGE_CONTAINER, $UPLOAD_PREVIEW_CONTAINER, $UPLOAD_PREVIEW_CONTAINERS;

  $(document).on('content-ready', function (e, element) {
    imageListeners(element);
    fileUploaderListener(element);
    uploadImageHandler(element);
    imageDeleteListener(element);
  });

  function imageListeners(element) {
    // Click listener for upload button
    $(element).find('.image-upload-btn').unbind('click').click(function (e) {
      e.preventDefault();
      $UPLOAD_PREVIEW_CONTAINER  = $(this).parents('.upload-preview-container');
      $UPLOAD_PREVIEW_CONTAINERS = $('.upload-preview-container[data-field-name=' + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      $CURRENT_IMAGE_CONTAINER   = $('.image-upload-container[data-field-name='   + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      openFileInput();
    });

    // Click listener for edit button
    $(element).find('.btn-edit-img').unbind('click').click(function (e) {
      e.preventDefault();
      $UPLOAD_PREVIEW_CONTAINER  = $(this).parents('.upload-preview-container');
      $UPLOAD_PREVIEW_CONTAINERS = $('.upload-preview-container[data-field-name=' + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      $CURRENT_IMAGE_CONTAINER   = $('.image-upload-container[data-field-name=' + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      openCropModal();
    });
  }

  function openFileInput() {
    var imageInputField = $('#refinery-image-input');
    imageInputField.click();
  }

  function fileUploaderListener(element) {
    var maxFileSizeBytes = (5242880 * 20);

    $(element).find('#refinery-image-input').change(function (e) {
      if (typeof FileReader == "undefined") return true;
      var isImage = true;
      var name = $(this).attr('name');
      var files = e.target.files;

      for (var i = 0, file; file = files[i]; i++) {
        if (file.type.match('image.*')) {
          if (file.size >= maxFileSizeBytes){

            CanvasForms.insertErrors($('#image-upload-form'), {
              image: ['Image is too large. Max size is 100 mb']
            }, true);

            isImage = false;
            return true;
          }
        } else {
          CanvasForms.insertErrors($('#image-upload-form'), {image: ['You may only upload an image here.']}, true);
          isImage = false;
          return true;
        }
      }

      if (isImage) {
        CanvasForms.resetState();
        if($UPLOAD_PREVIEW_CONTAINERS !== undefined){
          $UPLOAD_PREVIEW_CONTAINERS.find('.file-preview').fadeOut(200);
        }
        $('#submit-image-btn').click();
      }
    });
  }

  function setPreviewDiv() {

    $(document).trigger('image-preview');

    if($UPLOAD_PREVIEW_CONTAINERS !== undefined){
      var $previewDivs = $UPLOAD_PREVIEW_CONTAINERS.find('.file-preview');
      $previewDivs.fadeIn(500);
    }

    if($UPLOAD_PREVIEW_CONTAINER === undefined){
      $UPLOAD_PREVIEW_CONTAINER = $('.inline-editable-image-container');
      $UPLOAD_PREVIEW_CONTAINERS = $UPLOAD_PREVIEW_CONTAINER;
    }
    resetProgressBar();

    if($UPLOAD_PREVIEW_CONTAINER.length > 0 && $UPLOAD_PREVIEW_CONTAINERS !== undefined){

      var $currentImage = $('img.cur-uploading-img');

      if($currentImage.length > 0){
        $currentImage.siblings('.progress-box').show();
      } else {
        $UPLOAD_PREVIEW_CONTAINER.find('.progress-box').show();
      }
    }
  }

  function afterSuccess(imageUrl){

  }

  function uploadImageHandler(element) {
    var $imageForm = $(element).find('#image-upload-form');
    var defaultOptions = {
        beforeSubmit: setPreviewDiv,
        success: handleSuccess,
        error: handleError,
        uploadProgress: onProgress,
        forceSync: true,
        resetForm: true
      };

    $imageForm.submit(function (e) {
      $(this).ajaxSubmit(defaultOptions);
      return false;
    });
  }

  function handleError(response) {
    console.warn(response);
    $UPLOAD_PREVIEW_CONTAINERS.find('.progress-box').hide();

     CanvasForms.insertErrors($('#image-upload-form'), response.responseJSON.errors, true);
  }

  function handleSuccess(response) {

    if($CURRENT_IMAGE_CONTAINER !== undefined){
      var imageIdField = $CURRENT_IMAGE_CONTAINER.find('.image-id-field');

      if (imageIdField.length > 0) {
        imageIdField.val(response.image_id)
      }
    }

    if($UPLOAD_PREVIEW_CONTAINERS !== undefined) {

      var newBtnText = 'Replace Image';
      var $deleteBtns = $UPLOAD_PREVIEW_CONTAINERS.find('.image-delete-btn');
      var $uploadBtns = $UPLOAD_PREVIEW_CONTAINERS.find('.image-upload-btn');
      var $previewDiv = $UPLOAD_PREVIEW_CONTAINERS.find('.file-preview');

      $(document).trigger('image-uploaded', response.url);

      // Preload image
      $('<img/>').attr('src', response.url).load(function() {
        $(this).remove(); // prevent memory leaks as @benweet suggested
        $previewDiv.css('background-image', 'url(' + response.url + ')');
        
        if ($deleteBtns.length > 0){
          $deleteBtns.attr('data-path', '/admin/images/' + response.image_id);
          $deleteBtns.fadeIn(500);
        }

        if($uploadBtns.length > 0){
          $uploadBtns.text(newBtnText);
        }

        $('.progress-box').fadeOut(1000);
        CanvasForms.resetState();
        afterSuccess(response.url);
      });
    }
  }

  function onProgress(eventFired, position, total, percentComplete) {
    updateProgressBar(percentComplete);
  }

  function updateProgressBar(percentComplete) {
    var $statusText;
    var $progressBar = $('.progress-bar');

    if($UPLOAD_PREVIEW_CONTAINERS === undefined){
      $statusText = $('.glass-control').find('.status-text');
    } else {
      $statusText = $UPLOAD_PREVIEW_CONTAINERS.find('.status-text');
    }

    $statusText.html(percentComplete + '%');
    
    $progressBar.width(percentComplete + '%').attr('aria-valuenow', percentComplete);  
    if(percentComplete === 100){
      setTimeout(function(){
        $progressBar.replaceWith(processingProgressBar());
        $statusText.css('margin-left', '-30px').html('Processing...');
      }, 500);
    }
  }

  function processingProgressBar(){
    return [
      '<div class="progress-bar progress-bar-success progress-bar-striped active" role="progressbar" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100" style="width: 100%">',
      '</div>'].join('');
  }

  function imageDeleteListener(element) {
    $(element).find('.image-delete-btn').unbind('click').click(function (e) {
      e.preventDefault();
      $UPLOAD_PREVIEW_CONTAINER  = $(this).parents('.upload-preview-container');
      $UPLOAD_PREVIEW_CONTAINERS = $('.upload-preview-container[data-field-name=' + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      $CURRENT_IMAGE_CONTAINER   = $('.image-upload-container[data-field-name='   + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
      handleImageDelete($(this));
    });
  }

  function handleImageDelete($btn) {
    handleDeleteSuccess();
    //
    // This code below actually deletes the image...   BUT   this introduces a slight permissions problem.  Users can delete other users images
    //
    //$UPLOAD_PREVIEW_CONTAINER = $btn.parents('.upload-preview-container');
    //$CURRENT_IMAGE_CONTAINER = $('.image-upload-container[data-field-name=' + $UPLOAD_PREVIEW_CONTAINER.attr('data-field-name') +']');
    //$.ajax({
    //  type: 'DELETE',
    //  url: $btn.attr('data-path'),
    //  data: {'authenticity_token': $('#auth_token').val()},
    //  success: handleDeleteSuccess,
    //  error: handleDeleteError
    //});
  }

  function resetImageUpload() {
    var addBtnText = 'Upload an Image';
    $CURRENT_IMAGE_CONTAINER.find('.image-id-field').val(null);
    $UPLOAD_PREVIEW_CONTAINERS.find('.file-preview').fadeOut(500).removeAttr('style');
    $UPLOAD_PREVIEW_CONTAINERS.find('.image-upload-btn').text(addBtnText);
    $UPLOAD_PREVIEW_CONTAINERS.find('.image-delete-btn').fadeOut(500)
  }

  function handleDeleteSuccess(response) {
    resetImageUpload();
  }

  function handleDeleteError(response) {
    // TODO: Do something here.
  }

  function resetProgressBar() {
    var statusText   = $UPLOAD_PREVIEW_CONTAINERS.find('.status-text');

    if($UPLOAD_PREVIEW_CONTAINERS !== undefined){
      $('.progress-bar').removeClass('progress-bar-striped active');
      statusText.css('margin-left', '-15px');

      updateProgressBar(1);
    }
  }

  function openCropModal() {
    $('#modal-edit-image').modal('show');
  }

  // Return API for other modules
  return {
    imageListeners: imageListeners,
    fileUploaderListener: fileUploaderListener,
    uploadImageHandler: uploadImageHandler,
    openFileInput: openFileInput
  };
})(jQuery);
