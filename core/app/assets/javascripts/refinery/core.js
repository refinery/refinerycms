$(document).ready(function(){
  // focus first field in an admin form.
  $('form input[type=text]:first').focus();

  init_flash_messages();
});

init_flash_messages = function(){
  $('#flash').css({
    'opacity': 0
    , 'visibility':'visible'
  }).animate({'opacity': '1'}, 550);
  $('#flash_close').on('click', function(e) {
    try {
      $('#flash').animate({
         'opacity': 0,
         'visibility': 'hidden'
      }, 330, function() {
        $('#flash').hide();
      });
    } catch(ex) {
      $('#flash').hide();
    }
    e.preventDefault();
  });
  $('#flash.flash_message').prependTo('#records');
};


