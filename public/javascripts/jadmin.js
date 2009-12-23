
$j(document).ready(function(){
  init_sortable_menu();
});


function init_sortable_menu(){
  var $menu = $j('#menu');

  $menu.sortable({
    axis: 'x',
    cursor: 'crosshair',
    items: '.tab',
    update: function(){
      var ser   = $menu.sortable('serialize', {key: 'menu[]'}),
          token = escape($j('#admin_menu_reorder_authenticity_token').val());
          
      $j.get('/admin/update_menu_positions?' + ser, {authenticity_token: token});
    }
  });
  //Initial status disabled
  $menu.sortable('disable');

  $menu.find('#menu_reorder').click(function(ev){
    ev.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 0.5);
    $menu.find('.tab a').click(function(ev){
      ev.preventDefault();
    });

    $menu.sortable('enable');
  });

  $menu.find('#menu_reorder_done').click(function(ev){
    ev.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 1);
    $menu.find('.tab a').unbind('click');

    $menu.sortable('disable');
  });
}