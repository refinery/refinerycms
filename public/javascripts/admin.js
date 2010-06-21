if (!wymeditorClassesItems) var wymeditorClassesItems = [];
if (!wymeditorContainersItems) var wymeditorContainersItems = [];

// Use this to customize the 'Apply Styles' drop-down menu in WYMeditor
wymeditorClassesItems = $.extend([
    {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
 ,  {name: 'image-align', rules:['left', 'right'], join: '-'}
 ,  {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
], wymeditorClassesItems);

// Use this to customize the container element buttons on the WYMeditor toolbar
wymeditorContainersItems = $.extend([
  {'name': 'h1', 'title':'Heading_1', 'css':'wym_containers_h1'}
  , {'name': 'h2', 'title':'Heading_2', 'css':'wym_containers_h2'}
  , {'name': 'h3', 'title':'Heading_3', 'css':'wym_containers_h3'}
  , {'name': 'p', 'title':'Paragraph', 'css':'wym_containers_p'}
], wymeditorContainersItems);
