var wymeditor_inputs = [];
var wymeditors_loaded = 0;
// supply custom_wymeditor_boot_options if you want to override anything here.
if (typeof(custom_wymeditor_boot_options) == "undefined") { custom_wymeditor_boot_options = {}; }
var wymeditor_boot_options = $.extend({
  skin: 'refinery'
  , basePath: "/javascripts/wymeditor/"
  , wymPath: "/javascripts/wymeditor/jquery.refinery.wymeditor.js"
  , cssSkinPath: "/stylesheets/wymeditor/skins/"
  , jsSkinPath: "/javascripts/wymeditor/skins/"
  , langPath: "/javascripts/wymeditor/lang/"
  , iframeBasePath: '/'
  , toolsItems: [
    {'name': 'Bold', 'title': 'Bold', 'css': 'wym_tools_strong'}
    ,{'name': 'Italic', 'title': 'Emphasis', 'css': 'wym_tools_emphasis'}
    ,{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'}
    ,{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'}
    ,{'name': 'CreateLink', 'title': 'Link', 'css': 'wym_tools_link'}
    ,{'name': 'Unlink', 'title': 'Unlink', 'css': 'wym_tools_unlink'}
    ,{'name': 'InsertImage', 'title': 'Image', 'css': 'wym_tools_image'}
    ,{'name': 'InsertTable', 'title': 'Table', 'css': 'wym_tools_table'}
    ,{'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'}
    ,{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'}
  ]

  ,toolsHtml: "<ul class='wym_tools wym_section'>" + WYMeditor.TOOLS_ITEMS + WYMeditor.CLASSES + "</ul>"

  ,toolsItemHtml:
    "<li class='" + WYMeditor.TOOL_CLASS + "'>"
      + "<a href='#' name='" + WYMeditor.TOOL_NAME + "' title='" + WYMeditor.TOOL_TITLE + "'>"  + WYMeditor.TOOL_TITLE  + "</a>"
    + "</li>"

  //containersItems will be appended after tools in postInit.
  , containersItems: [
    {'name': 'h1', 'title':'Heading_1', 'css':'wym_containers_h1'}
    ,{'name': 'h2', 'title':'Heading_2', 'css':'wym_containers_h2'}
    ,{'name': 'h3', 'title':'Heading_3', 'css':'wym_containers_h3'}
    ,{'name': 'p', 'title':'Paragraph', 'css':'wym_containers_p'}
  ]

  , classesHtml: "<li class='wym_tools_class'><a href='#' name='" + WYMeditor.APPLY_CLASS + "' title='"+ titleize(WYMeditor.APPLY_CLASS) +"'></a><ul class='wym_classes wym_classes_hidden'>" + WYMeditor.CLASSES_ITEMS + "</ul></li>"

  , classesItemHtml: "<li><a href='#' name='"+ WYMeditor.CLASS_NAME + "'>"+ WYMeditor.CLASS_TITLE+ "</a></li>"
  , classesItemHtmlMultiple: "<li class='wym_tools_class_multiple_rules'><span>" + WYMeditor.CLASS_TITLE + "</span><ul>{classesItemHtml}</ul></li>"

  , classesItems: wymeditorClassesItems

  , containersHtml: "<ul class='wym_containers wym_section'>" + WYMeditor.CONTAINERS_ITEMS + "</ul>"

  , containersItemHtml:
      "<li class='" + WYMeditor.CONTAINER_CLASS + "'>"
        + "<a href='#' name='" + WYMeditor.CONTAINER_NAME + "' title='" + WYMeditor.CONTAINER_TITLE + "'></a>"
      + "</li>"

  , boxHtml:
  "<div class='wym_box'>"
    + "<div class='wym_area_top'>"
      + WYMeditor.TOOLS
      + WYMeditor.CONTAINERS
    + "</div>"
    + "<div class='wym_area_main'>"
      + WYMeditor.HTML
      + WYMeditor.IFRAME
      + WYMeditor.STATUS
    + "</div>"
  + "</div>"

  , iframeHtml:
    "<div class='wym_iframe wym_section'>"
     + "<iframe id='WYMeditor_" + WYMeditor.INDEX + "' src='" + WYMeditor.IFRAME_BASE_PATH + "wymiframe' frameborder='0'"
      + " onload='this.contentWindow.parent.WYMeditor.INSTANCES[" + WYMeditor.INDEX + "].initIframe(this);'></iframe>"
    +"</div>"

  , dialogImageHtml: ""

  , dialogLinkHtml: ""

  , dialogTableHtml:
    "<div class='wym_dialog wym_dialog_table'>"
    + "<form>"
      + "<input type='hidden' id='wym_dialog_type' class='wym_dialog_type' value='"+ WYMeditor.DIALOG_TABLE + "' />"
    + "<div class='field'>"
      + "<label for='wym_caption'>{Caption}</label>"
          + "<input type='text' id='wym_caption' class='wym_caption' value='' size='40' />"
        + "</div>"
        + "<div class='field'>"
          + "<label for='wym_rows'>{Number_Of_Rows}</label>"
          + "<input type='text' id='wym_rows' class='wym_rows' value='3' size='3' />"
        + "</div>"
        + "<div class='field'>"
          + "<label for='wym_cols'>{Number_Of_Cols}</label>"
          + "<input type='text' id='wym_cols' class='wym_cols' value='2' size='3' />"
        + "</div>"
        + "<div id='dialog-form-actions' class='form-actions'>"
          + "<input class='wym_submit' type='button' value='{Insert}' />"
          + " or "
          + "<a href='' class='wym_cancel close_dialog'>{Cancel}</a>"
        + "</div>"
      + "</form>"
    + "</div>"

  , dialogPasteHtml:
    "<div class='wym_dialog wym_dialog_paste'>"
      + "<form>"
        + "<input type='hidden' id='wym_dialog_type' class='wym_dialog_type' value='" + WYMeditor.DIALOG_PASTE + "' />"
        + "<div class='field'>"
          + "<textarea class='wym_text' rows='10' cols='50'></textarea>"
        + "</div>"
        + "<div id='dialog-form-actions' class='form-actions'>"
          + "<input class='wym_submit' type='button' value='{Insert}' />"
          + " or "
          + "<a href='' class='wym_cancel close_dialog'>{Cancel}</a>"
        + "</div>"
      + "</form>"
    + "</div>"

  , dialogPath: "/admin/dialogs/"
  , dialogFeatures: {
      width: 958
    , height: 570
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
  }
  , dialogInlineFeatures: {
      width: 600
    , height: 530
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
  }

  , dialogId: 'editor_dialog'

  , dialogHtml:
    "<!DOCTYPE html PUBLIC '-//W3C//DTD XHTML 1.0 Strict//EN' 'http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd'>"
    + "<html dir='" + WYMeditor.DIRECTION + "'>"
      + "<head>"
        + "<link rel='stylesheet' type='text/css' media='screen' href='" + WYMeditor.CSS_PATH + "' />"
        + "<title>" + WYMeditor.DIALOG_TITLE + "</title>"
        + "<script type='text/javascript' src='" + WYMeditor.JQUERY_PATH + "'></script>"
        + "<script type='text/javascript' src='" + WYMeditor.WYM_PATH + "'></script>"
      + "</head>"
    + "<div id='page'>" + WYMeditor.DIALOG_BODY + "</div>"
    + "</html>"

  , postInit: function(wym)
  {
    wym._iframe.style.height = wym._element.height() + "px";
    wymeditors_loaded += 1;
    if(WYMeditor.INSTANCES.length == wymeditors_loaded){
      WYMeditor.loaded();
    }
  }
}, custom_wymeditor_boot_options);

// custom function added by us to hook into when all wymeditor instances on the page have finally loaded:
WYMeditor.loaded = function(){};

$(function()
{
  wymeditor_inputs = $('.wymeditor');
  wymeditor_inputs.hide();
  wymeditor_inputs.wymeditor(wymeditor_boot_options);
  $('.wym_iframe iframe').each(function(index, wym) {
    // adjust for border width.
    $(wym).css({'height':$(wym).parent().height()-2, 'width':$(wym).parent().width()-2});
  });
});