init_sortable_menu = function(){
  var $menu = $('#menu');

  if($menu.length === 0){return;}

  $menu.sortable({
    axis: 'x',
    cursor: 'crosshair',
    connectWith: '.nested',
    update: function(){
      $.post('/refinery/update_menu_positions', $menu.sortable('serialize', {
                key: 'menu[]'
                , expression: /plugin_([\w]*)$/
              }));
    }
  }).tabs();
  //Initial status disabled
  $menu.sortable('disable');

  $menu.find('#menu_reorder').click(function(e){
    trigger_reordering(e, true);
  });

  $menu.find('#menu_reorder_done').click(function(e){
    trigger_reordering(e, false);
  });

  $menu.find('> a').corner('top 5px');
};
