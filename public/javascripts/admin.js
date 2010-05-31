if (!wymeditorClassesItems) {
  var wymeditorClassesItems = [];
}

wymeditorClassesItems = $.extend([
    {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
 ,  {name: 'image-align', rules:['left', 'right'], join: '-'}
 ,  {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
], wymeditorClassesItems);

onOpenDialog = function(dialog) {
  $('.ui-dialog').corner('6px').find('.ui-dialog-titlebar').corner('1px top');
  $(document.body).addClass('hide-overflow');
}

onCloseDialog = function(dialog) {
  $(document.body).removeClass('hide-overflow');
}