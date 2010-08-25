onOpenDialog = function(dialog) {
  (dialog = $('.ui-dialog')).corner('6px')
                            .find('.ui-dialog-titlebar').corner('1px top')
  if (dialog.height() < $(window).height()) {
    $(document.body).addClass('hide-overflow');
  }
}

onCloseDialog = function(dialog) {
  $(document.body).removeClass('hide-overflow');
}

var wymeditor_inputs = [];
var wymeditors_loaded = 0;
// supply custom_wymeditor_boot_options if you want to override anything here.
if (typeof(custom_wymeditor_boot_options) == "undefined") { custom_wymeditor_boot_options = {}; }
var form_actions =
"<div id='dialog-form-actions' class='form-actions'>"
  + "<div class='form-actions-left'>"
    + "<input id='submit_button' class='wym_submit button' type='submit' value='{Insert}' class='button' />"
    + "<a href='' class='wym_cancel close_dialog button'>{Cancel}</a>"
  + "</div>"
+ "</div>";
var wymeditor_boot_options = $.extend({
  skin: 'refinery'
  , basePath: "/"
  , wymPath: "/javascripts/wymeditor/jquery.refinery.wymeditor.js"
  , cssSkinPath: "/stylesheets/wymeditor/skins/"
  , jsSkinPath: "/javascripts/wymeditor/skins/"
  , langPath: "/javascripts/wymeditor/lang/"
  , iframeBasePath: '/'
  , classesItems: [
    {name: 'text-align', rules:['left', 'center', 'right', 'justify'], join: '-'}
    , {name: 'image-align', rules:['left', 'right'], join: '-'}
    , {name: 'font-size', rules:['small', 'normal', 'large'], join: '-'}
  ]

  , containersItems: [
    {'name': 'h1', 'title':'Heading_1', 'css':'wym_containers_h1'}
    , {'name': 'h2', 'title':'Heading_2', 'css':'wym_containers_h2'}
    , {'name': 'h3', 'title':'Heading_3', 'css':'wym_containers_h3'}
    , {'name': 'p', 'title':'Paragraph', 'css':'wym_containers_p'}
  ]
  , toolsItems: [
    {'name': 'Bold', 'title': 'Bold', 'css': 'wym_tools_strong'}
    ,{'name': 'Italic', 'title': 'Emphasis', 'css': 'wym_tools_emphasis'}
    ,{'name': 'InsertOrderedList', 'title': 'Ordered_List', 'css': 'wym_tools_ordered_list'}
    ,{'name': 'InsertUnorderedList', 'title': 'Unordered_List', 'css': 'wym_tools_unordered_list'}
    /*,{'name': 'Indent', 'title': 'Indent', 'css': 'wym_tools_indent'}
    ,{'name': 'Outdent', 'title': 'Outdent', 'css': 'wym_tools_outdent'}
    ,{'name': 'Undo', 'title': 'Undo', 'css': 'wym_tools_undo'}
    ,{'name': 'Redo', 'title': 'Redo', 'css': 'wym_tools_redo'}*/
    ,{'name': 'CreateLink', 'title': 'Link', 'css': 'wym_tools_link'}
    ,{'name': 'Unlink', 'title': 'Unlink', 'css': 'wym_tools_unlink'}
    ,{'name': 'InsertImage', 'title': 'Image', 'css': 'wym_tools_image'}
    ,{'name': 'InsertTable', 'title': 'Table', 'css': 'wym_tools_table'}
    //,{'name': 'Paste', 'title': 'Paste_From_Word', 'css': 'wym_tools_paste'}
    ,{'name': 'ToggleHtml', 'title': 'HTML', 'css': 'wym_tools_html'}
  ]

  ,toolsHtml: "<ul class='wym_tools wym_section wym_buttons'>" + WYMeditor.TOOLS_ITEMS + WYMeditor.CLASSES + "</ul>"

  ,toolsItemHtml:
    "<li class='" + WYMeditor.TOOL_CLASS + "'>"
      + "<a href='#' name='" + WYMeditor.TOOL_NAME + "' title='" + WYMeditor.TOOL_TITLE + "'>"
        + WYMeditor.TOOL_TITLE
      + "</a>"
    + "</li>"

  , classesHtml: "<li class='wym_tools_class'>"
                 + "<a href='#' name='" + WYMeditor.APPLY_CLASS + "' title='"+ titleize(WYMeditor.APPLY_CLASS) +"'></a>"
                 + "<ul class='wym_classes wym_classes_hidden'>" + WYMeditor.CLASSES_ITEMS + "</ul>"
                + "</li>"

  , classesItemHtml: "<li><a href='#' name='"+ WYMeditor.CLASS_NAME + "'>"+ WYMeditor.CLASS_TITLE+ "</a></li>"
  , classesItemHtmlMultiple: "<li class='wym_tools_class_multiple_rules'>"
                              + "<span>" + WYMeditor.CLASS_TITLE + "</span>"
                              + "<ul>{classesItemHtml}</ul>"
                            +"</li>"

  , containersHtml: "<ul class='wym_containers wym_section'>" + WYMeditor.CONTAINERS_ITEMS + "</ul>"

  , containersItemHtml:
      "<li class='" + WYMeditor.CONTAINER_CLASS + "'>"
        + "<a href='#' name='" + WYMeditor.CONTAINER_NAME + "' title='" + WYMeditor.CONTAINER_TITLE + "'></a>"
      + "</li>"

  , boxHtml:
  "<div class='wym_box'>"
    + "<div class='wym_area_top clearfix'>"
      + WYMeditor.CONTAINERS
      + WYMeditor.TOOLS
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
        + form_actions
      + "</form>"
    + "</div>"

  , dialogPasteHtml:
    "<div class='wym_dialog wym_dialog_paste'>"
      + "<form>"
        + "<input type='hidden' id='wym_dialog_type' class='wym_dialog_type' value='" + WYMeditor.DIALOG_PASTE + "' />"
        + "<div class='field'>"
          + "<textarea class='wym_text' rows='10' cols='50'></textarea>"
        + "</div>"
        + form_actions
      + "</form>"
    + "</div>"

  , dialogPath: "/refinery/dialogs/"
  , dialogFeatures: {
      width: 866
    , height: 455
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
    , open: onOpenDialog
    , close: onCloseDialog
  }
  , dialogInlineFeatures: {
      width: 600
    , height: 485
    , modal: true
    , draggable: true
    , resizable: false
    , autoOpen: true
    , open: onOpenDialog
    , close: onCloseDialog
  }

  , dialogId: 'editor_dialog'

  , dialogHtml:
    "<!DOCTYPE html>"
    + "<html dir='" + WYMeditor.DIRECTION + "'>"
      + "<head>"
        + "<link rel='stylesheet' type='text/css' media='screen' href='" + WYMeditor.CSS_PATH + "' />"
        + "<title>" + WYMeditor.DIALOG_TITLE + "</title>"
        + "<script type='text/javascript' src='" + WYMeditor.JQUERY_PATH + "'></script>"
        + "<script type='text/javascript' src='" + WYMeditor.WYM_PATH + "'></script>"
      + "</head>"
      + "<body>"
        + "<div id='page'>" + WYMeditor.DIALOG_BODY + "</div>"
      + "</body>"
    + "</html>"
  , postInit: function(wym)
  {
    // register loaded
    wymeditors_loaded += 1;

    // fire loaded if all editors loaded
    if(WYMeditor.INSTANCES.length == wymeditors_loaded){
      $('.wym_loading_overlay').remove();
      WYMeditor.loaded();
    }

    $('.field.hide-overflow').removeClass('hide-overflow').css('height', 'auto');
  }
  , lang: (typeof(I18n.locale) != "undefined" ? I18n.locale : 'en')
}, custom_wymeditor_boot_options);

// custom function added by us to hook into when all wymeditor instances on the page have finally loaded:
WYMeditor.loaded = function(){};

$(function()
{
  wymeditor_inputs = $('.wymeditor');
  wymeditor_inputs.each(function(input) {
    if ((containing_field = $(this).parents('.field')).get(0).style.height == '') {
      containing_field.addClass('hide-overflow')
                      .css('height', $(this).outerHeight() - containing_field.offset().top + $(this).offset().top + 45);
    }
    $(this).hide();
  });

  wymeditor_inputs.wymeditor(wymeditor_boot_options);
});
