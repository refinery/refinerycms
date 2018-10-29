window.onload = function () {
  'use strict';

  const image = document.getElementById('crop');
  const ratios = document.getElementById('ratios');
  const defaultAspectRatio = ratios.querySelector('button').getAttribute('data-value');
  const submitCropSubmit = document.getElementById('save_crop');
  let selectedCropRatio, cropWidth, cropHeight;

  let options = {
    aspectRatio: defaultAspectRatio,
    crop: function (e) {
      let data = e.detail;
      cropWidth = data.width;
      cropHeight = data.height;
    },
    zoomOnWheel: false
  };

  let cropper = new Cropper(image, options);

  // Toggle aspect ratio after initialization
  ratios.querySelectorAll('button').forEach(function(ratioButton) {
    ratioButton.addEventListener('click', function() {
      options.aspectRatio = ratioButton.getAttribute('data-value');
      selectedCropRatio = ratioButton.getAttribute('data-ratio');

      cropper.destroy();
      cropper = new Cropper(image, options);
    });
  });

  submitCropSubmit.addEventListener('click', function(e) {
    e.preventDefault();

    const filename = image.getAttribute('data-filename');
    const mimeType = image.getAttribute('data-mime-type');

    const imageId = image.getAttribute('data-image-id');
    const form = document.getElementById('crop_image_'+imageId);
    const actionUrl = form.getAttribute('action');

    cropper.getCroppedCanvas().toBlob(function(blob) {
      let formData = new FormData(form);

      formData.append('image', blob, filename);
      formData.append('ratio', selectedCropRatio);
      formData.append('height', cropHeight);
      formData.append('width', cropWidth);

      ajaxPostNewCrop(formData, actionUrl);
    }, mimeType);
  });

  function ajaxPostNewCrop(formData, actionUrl) {
    let xhr = new XMLHttpRequest();

    xhr.open('PATCH', actionUrl, true);
    xhr.send(formData);
    xhr.onreadystatechange = function() {
      if (xhr.readyState === 4) {
        if (xhr.status === 200) {
          const response = JSON.parse(xhr.responseText);
          appendNewCropInList(response.crop, 'crop-list');
        }
      }
    };
  }

  function appendNewCropInList(newCrop, listId) {
    initCropList(listId);

    let child = document.createElement('div');
    child.innerHTML = newCrop;
    child = child.firstChild;

    return document.getElementById(listId).appendChild(child);
  }

  function initCropList(listId){
    let cropsId = document.getElementById('crops');
    let cropListId = document.getElementById(listId);

    if(cropListId == null) {
      cropListId = document.createElement('ul');
      cropListId.setAttribute("id", listId);
      cropListId.setAttribute("class", "clearfix");
      cropsId.appendChild(cropListId);
    }

    hideNoCropsYetText();
  }

  function hideNoCropsYetText(){
    const noCropsYetText = document.getElementById('no-crops-yet');

    if(noCropsYetText !== null && noCropsYetText.style.display != 'none')  {
      noCropsYetText.style.display = 'none';
    }
  }
};
