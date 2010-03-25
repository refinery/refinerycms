if (!wymeditorClassesItems) {
  var wymeditorClassesItems = [];
}

wymeditorClassesItems = $.extend([
    {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
 ,  {name: 'image-align', rules:['left', 'right'], join: '-'}
 ,  {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
], wymeditorClassesItems);