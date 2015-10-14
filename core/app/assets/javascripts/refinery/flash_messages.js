$(document).on('content-ready', function (e, element) {
  $(element).find('#flash_container').on('click', '#flash_close', function(e) {
    $('#flash').hide();
    e.preventDefault();
  });
  $(element).find('#flash.flash_message').prependTo('#records');
});
