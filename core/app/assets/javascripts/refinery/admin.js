var shiftHeld = false;
var initialLoad = true;
$(document).ready(function(){
  init_interface();
  init_sortable_menu();
  init_submit_continue();
  init_modal_dialogs();
  init_tooltips();
  init_ajaxy_pagination();
});

if(typeof(window.onpopstate) == "object"){
  $(window).bind('popstate', function(e) {
    // this fires on initial page load too which we don't need.
    if(!initialLoad) {
      $(document).paginateTo((location.pathname + location.href.split(location.pathname)[1]));
    }
    initialLoad = false;
  });
}

$.fn.paginateTo = function(stateUrl) {
  // Grab the url, ensuring not to cache.
  $.ajax({
    url: stateUrl,
    cache: false,
    success: function(data) {
      $('.pagination_container').slideTo(data);

      // remove caching _ argument.
      $('.pagination_container .pagination a').each(function(i, a){
        $(this).attr('href', $(this).attr('href').replace(/\?\_\=[^&]+&/, '?'));
      })
    },
    failure: function(data) {
      window.location = popstate_location;
    }
  });
}

$.fn.slideTo = function(response) {
  $(this).html(response);
  $(this).applyMinimumHeightFromChildren();
  $(this).find('.pagination_frame').removeClass('frame_right').addClass('frame_center');
  init_modal_dialogs();
  init_tooltips();
  return $(this);
}

$.fn.applyMinimumHeightFromChildren = function() {
  child_heights = 0;
  $(this).children().each(function(i, child){
    child_heights += $(child).height();
    $.each(['marginTop', 'marginBottom', 'paddingTop', 'paddingBottom'], function(i, attr) {
      child_heights += (parseInt($(child).css(attr)) || 0);
    });
  });
  $(this).css('min-height', child_heights);
  return $(this);
}

init_modal_dialogs = function(){
  $('a[href*="dialog=true"]').not('#dialog_container a').each(function(i, anchor) {
    $(anchor).data({
      'dialog-width': parseInt($($(anchor).attr('href').match("width=([0-9]*)")).last().get(0), 10)||928
      , 'dialog-height': parseInt($($(anchor).attr('href').match("height=([0-9]*)")).last().get(0), 10)||473
      , 'dialog-title': ($(anchor).attr('title') || $(anchor).attr('name') || $(anchor).html() || null)
    }).attr('href', $(anchor).attr('href').replace(/(\&(amp\;)?)?dialog\=true/, '')
                                          .replace(/(\&(amp\;)?)?width\=\d+/, '')
                                          .replace(/(\&(amp\;)?)?height\=\d+/, '')
                                          .replace(/(\?&(amp\;)?)/, '?')
                                          .replace(/\?$/, ''))
    .click(function(e){
      $anchor = $(this);
      iframe_src = (iframe_src = $anchor.attr('href'))
                   + (iframe_src.indexOf('?') > -1 ? '&' : '?')
                   + 'app_dialog=true&dialog=true';

      iframe = $("<iframe id='dialog_iframe' frameborder='0' marginheight='0' marginwidth='0' border='0'></iframe>");
      if(!$.browser.msie) { iframe.corner('8px'); }
      iframe.dialog({
        title: $anchor.data('dialog-title')
        , modal: true
        , resizable: false
        , autoOpen: true
        , width: $anchor.data('dialog-width')
        , height: $anchor.data('dialog-height')
        , open: onOpenDialog
        , close: onCloseDialog
      });

      iframe.attr('src', iframe_src);
      e.preventDefault();
    });
  });
};

trigger_reordering = function(e, enable) {
  e.preventDefault();
  $('#menu_reorder, #menu_reorder_done').toggle();
  $('#site_bar, #content').fadeTo(500, enable ? 0.35 : 1);

  if(enable) {
    $menu.find('.tab a').click(function(ev){
      ev.preventDefault();
    });
  } else {
    $menu.find('.tab a').unbind('click');
  }

  $menu.sortable(enable ? 'enable' : 'disable');
};

submit_and_continue = function(e, redirect_to) {
  // ensure wymeditors are up to date.
  if ($(this).hasClass('wymupdate')) {
    $.each(WYMeditor.INSTANCES, function(index, wym)
    {
      wym.update();
    });
  }

  $('#continue_editing').val(true);
  $('#flash').fadeOut(250);

  $('.fieldWithErrors').removeClass('fieldWithErrors').addClass('field');
  $('#flash_container .errorExplanation').remove();

  $.post($('#continue_editing').get(0).form.action, $($('#continue_editing').get(0).form).serialize(), function(data) {
    if (($flash_container = $('#flash_container')).length > 0) {
      $flash_container.html(data);

      $('#flash').css({'width': 'auto', 'visibility': null}).fadeIn(550);

      $('.errorExplanation').not($('#flash_container .errorExplanation')).remove();

      if ((error_fields = $('#fieldsWithErrors').val()) != null) {
        $.each(error_fields.split(','), function() {
          $("#" + this).wrap("<div class='fieldWithErrors' />");
        });
      } else if (redirect_to) {
        window.location = redirect_to;
      }

      $('.fieldWithErrors:first :input:first').focus();

      $('#continue_editing').val(false);

      init_flash_messages();
    }
  });

  e.preventDefault();
};

init_tooltips = function(args){
  $($(args != null ? args : 'a[title], span[title], #image_grid img[title], *[tooltip]')).not('.no-tooltip').each(function(index, element)
  {
    // create tooltip on hover and destroy it on hoveroff.
    $(element).hover(function(e) {
      if (e.type == 'mouseenter' || e.type == 'mouseover') {
        $(this).oneTime(350, 'tooltip', $.proxy(function() {
          $('.tooltip').remove();
          tooltip = $("<div class='tooltip'><div><span></span></div></div>").appendTo('#tooltip_container');
          tooltip.find("span").html($(this).attr('tooltip'));
          if(!$.browser.msie) {
            tooltip.corner('6px').find('span').corner('6px');
          }

          tooltip_nib_image = $.browser.msie ? 'tooltip-nib.gif' : 'tooltip-nib.png';
          nib = $("<img src='/assets/refinery/"+tooltip_nib_image+"' class='tooltip-nib'/>").appendTo('#tooltip_container');

          tooltip.css({
            'opacity': 0
            , 'maxWidth': '300px'
          });
          required_left_offset = $(this).offset().left - (tooltip.outerWidth() / 2) + ($(this).outerWidth() / 2);
          tooltip.css('left', (required_left_offset > 0 ? required_left_offset : 0));

          var tooltip_offset = tooltip.offset();
          var tooltip_outer_width = tooltip.outerWidth();
          if (tooltip_offset && (tooltip_offset.left + tooltip_outer_width) > (window_width = $(window).width())) {
            tooltip.css('left', window_width - tooltip_outer_width);
          }

          tooltip.css({
            'top': $(this).offset().top - tooltip.outerHeight() - 10
          });

          nib.css({
            'opacity': 0
          });

          if (tooltip_offset = tooltip.offset()) {
            nib.css({
              'left': $(this).offset().left + ($(this).outerWidth() / 2) - 5
              , 'top': tooltip_offset.top + tooltip.height()
            });
          }

          try {
            tooltip.animate({
              top: tooltip_offset.top - 10
              , opacity: 1
            }, 200, 'swing');
            nib.animate({
              top: nib.offset().top - 10
              , opacity: 1
            }, 200);
          } catch(e) {
            tooltip.show();
            nib.show();
          }
        }, $(this)));
      } else if (e.type == 'mouseleave' || e.type == 'mouseout') {
        $(this).stopTime('tooltip');
        if ((tt_offset = (tooltip = $('.tooltip')).css('z-index', '-1').offset()) == null) {
          tt_offset = {'top':0,'left':0};
        }
        tooltip.animate({
          top: tt_offset.top - 20
          , opacity: 0
        }, 125, 'swing', function(){
          $(this).remove();
        });
        if ((nib_offset = (nib = $('.tooltip-nib')).offset()) == null) {
          nib_offset = {'top':0,'left':0};
        }
        nib.animate({
          top: nib_offset.top - 20
          , opacity: 0
        }, 125, 'swing', function(){
          $(this).remove();
        });
      }
    }).click(function(e) {
      $(this).stopTime('tooltip');
    });

    if ($(element).attr('tooltip') == null) {
      $(element).attr('tooltip', $(element).attr('title'));
    }
    // wipe clean the title on any children too.
    $elements = $(element).add($(element).children('img')).removeAttr('title');
    // if we're unlucky and in Internet Explorer then we have to say goodbye to 'alt', too.
    if ($.browser.msie){$elements.removeAttr('alt');}
  });
};

var link_tester = {
  initialised: false
  , init: function(test_url, test_email) {

    if (!this.initialised) {
      this.test_url = test_url;
      this.test_email = test_email;
      this.initialised = true;
    }
  },

  email: function(value, callback) {
    if (value != "") {
      $.getJSON(link_tester.test_email, {email: value}, function(data){
        callback(data.result == 'success');
      });
    }
  },

  url: function(value, callback) {
    if (value != "") {
      $.getJSON(link_tester.test_url, {'url': value}, function(data){
        callback(data.result == 'success');
      });
    }
  },

  validate_textbox: function(validation_method, textbox_id, callback) {
    var icon = '';
    var loader_img = $("<img id='" + textbox_id.replace('#','') + "_test_loader' src='/assets/refinery/ajax-loader.gif' alt='Testing...' style='display: none;'/>");
    var result_span = $("<span id='" + textbox_id.replace('#','') + "_test_result'></span>");

    loader_img.insertAfter($(textbox_id));
    result_span.insertAfter(loader_img);

    $(textbox_id).bind('paste blur',function(){
      $(textbox_id).stop(true); // Clear the current queue; if we weren't checking yet, cancel it.
      $(textbox_id + '_test_loader').hide();
      $(textbox_id + '_test_result').hide();
      $(textbox_id + '_test_result').removeClass('success_icon').removeClass('failure_icon');

      if (this.value != "" && this.value[0] != "/") {
        // Wait 300ms before checking.
        $(textbox_id).delay(300).queue(function () {
          $(textbox_id + '_test_loader').show();
          $(textbox_id + '_test_result').hide();
          $(textbox_id + '_test_result').removeClass('success_icon').removeClass('failure_icon');

          validation_method(this.value, function (success) {
            if (success) {
              icon = 'success_icon';
            }else{
              icon = 'failure_icon';
            }
            $(textbox_id + '_test_result').addClass(icon).show();
            $(textbox_id + '_test_loader').hide();
          });

          if (callback) { callback($(textbox_id)); }

          $(this).dequeue();
        }); // queue
      }
    }); // bind
  },

  validate_url_textbox: function(textbox_id, callback) {
    link_tester.validate_textbox(link_tester.url, textbox_id, callback);
  },

  validate_email_textbox: function(textbox_id, callback) {
    link_tester.validate_textbox(link_tester.email, textbox_id, callback);
  }

};

var link_dialog = {
  initialised: false
  , init: function(){

    if (!this.initialised) {
      this.init_tabs();
      this.init_resources_submit();
      this.init_close();
      this.page_tab();
      this.web_tab();
      this.email_tab();
      this.initialised = true;
    }
  },

  init_tabs: function(){
    var radios = $('#dialog_menu_left input:radio');
    var selected = radios.parent().filter(".selected_radio").find('input:radio').first() || radios.first();

    radios.click(function(){
      link_dialog.switch_area($(this));
    });

    selected.attr('checked', 'true');
    link_dialog.switch_area(selected);
  },

  init_resources_submit: function(){
    $('#existing_resource_area .form-actions-dialog #submit_button').click(function(e){
      e.preventDefault();
      if((resource_selected = $('#existing_resource_area_content ul li.linked a')).length > 0) {
        resourceUrl = parseURL(resource_selected.attr('href'));
        relevant_href = resourceUrl.pathname;

        // Add any alternate resource stores that need a absolute URL in the regex below
        if(resourceUrl.hostname.match(/s3.amazonaws.com/)) {
          relevant_href = resourceUrl.protocol + '//' + resourceUrl.host + relevant_href;
        }

        if (typeof(resource_picker.callback) == "function") {
          resource_picker.callback({
            id: resource_selected.attr('id').replace("resource_", "")
            , href: relevant_href
            , html: resource_selected.html()
          });
        }
      }
    });

    $('.form-actions-dialog #cancel_button').trigger('click');
  },

  init_close: function(){
    $('.form-actions-dialog #cancel_button').not('.wym_iframe_body .form-actions-dialog #cancel_button').click(close_dialog);

    if (parent
        && parent.document.location.href != document.location.href
        && parent.document.getElementById('wym_dialog_submit') != null) {
      $('#dialog_container .form-actions input#submit_button').click(function(e) {
        e.preventDefault();
        $(parent.document.getElementById('wym_dialog_submit')).click();
      });
      $('#dialog_container .form-actions a.close_dialog').click(close_dialog);
    }
  },

  switch_area: function(area){
    $('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $(area).parent().addClass('selected_radio');
    $('#dialog_main .dialog_area').hide();
    $('#' + $(area).val() + '_area').show();
  },

  //Same for resources tab
  page_tab: function(){
    $('.link_list li').click(function(e){
      e.preventDefault();

      $('.link_list li.linked').removeClass('linked');
      $(this).addClass('linked');

      var link = $(this).children('a.page_link').get(0);
      var port = (window.location.port.length > 0 ? (":" + window.location.port) : "");
      var url = link.href.replace(window.location.protocol + "//" + window.location.hostname + port, "");

      link_dialog.update_parent(url, link.rel.replace(/\ ?<em>.+?<\/em>/, ''));
    });
  },

  web_tab: function(){
    link_tester.validate_url_textbox("#web_address_text", function(){});

    $('#web_address_text, #web_address_target_blank').change(function(){
      link_dialog.update_parent( $('#web_address_text').val(),
                                 $('#web_address_text').val(),
                                 $('#web_address_target_blank').get(0).checked ? "_blank" : ""
      );
    });
  },

  email_tab: function() {
    link_tester.validate_email_textbox("#email_address_text", function(){});

    $('#email_address_text, #email_default_subject_text, #email_default_body_text').change(function(e){
      var default_subject = $('#email_default_subject_text').val(),
          default_body = $('#email_default_body_text').val(),
          mailto = "mailto:" + $('#email_address_text').val(),
          modifier = "?",
          additional = "";

      if(default_subject.length > 0){
        additional += modifier + "subject=" + default_subject;
        modifier = "&";
      }

      if(default_body.length > 0){
        additional += modifier + "body=" + default_body;
        modifier = "&";
      }

      link_dialog.update_parent(mailto + additional, mailto.replace('mailto:', ''));
    });
  },

  update_parent: function(url, title, target) {
    if (parent != null) {
      if ((wym_href = parent.document.getElementById('wym_href')) != null) {
        wym_href.value = url;
      }
      if ((wym_title = parent.document.getElementById('wym_title')) != null) {
        wym_title.value = title;
      }
      if ((wym_target = parent.document.getElementById('wym_target')) != null) {
        wym_target.value = target || "";
      }
    }
  }
};

var page_options = {
  initialised: false
  , init: function(enable_parts, new_part_url, del_part_url){

    if (!this.initialised) {
      // set the page tabs up, but ensure that all tabs are shown so that when wymeditor loads it has a proper height.
      page_options.tabs = $('#page-tabs');
      page_options.tabs.tabs({tabTemplate: '<li><a href="#{href}">#{label}</a></li>'});
      page_options.tabs.find(' > ul li a').corner('top 5px');

      part_shown = $('#page-tabs .page_part.field').not('.ui-tabs-hide');
      $('#page-tabs .page_part.field').removeClass('ui-tabs-hide');

      this.enable_parts = enable_parts;
      this.new_part_url = new_part_url;
      this.del_part_url = del_part_url;
      this.show_options();

      $(document).ready($.proxy(function(){
        // hide the tabs that are supposed to be hidden.
        $('#page-tabs .page_part.field').not(this).addClass('ui-tabs-hide');
        $('#page-tabs > ul li a').corner('top 5px');
      }, part_shown));

      if(this.enable_parts){
        this.page_part_dialog();
      }
      this.initialised = true;
    }
  },

  show_options: function(){
    $('#toggle_advanced_options').click(function(e){
      e.preventDefault();
      $('#more_options').animate({opacity: 'toggle', height: 'toggle'}, 250);

      $('html,body').animate({
        scrollTop: $('#toggle_advanced_options').parent().offset().top
      }, 250);
    });
  },

  page_part_dialog: function(){
    $('#new_page_part_dialog').dialog({
      title: 'Create Content Section',
      modal: true,
      resizable: false,
      autoOpen: false,
      width: 600,
      height: 200
    });

    $('#add_page_part').click(function(e){
      e.preventDefault();
      $('#new_page_part_dialog').dialog('open');
    });

    $('#new_page_part_save').click(function(e){
      e.preventDefault();

      var part_title = $('#new_page_part_title').val();

      if(part_title.length > 0){
        var tab_title = part_title.toLowerCase().replace(" ", "_");

        if ($('#part_' + tab_title).size() === 0) {
          $.get(page_options.new_part_url, {
              title: part_title
              , part_index: $('#new_page_part_index').val()
              , body: ''
            }, function(data, status){
              $('#submit_continue_button').remove();
              // Add a new tab for the new content section.
              $('#page_part_editors').append(data);
              page_options.tabs.tabs('add', '#page_part_new_' + $('#new_page_part_index').val(), part_title);
              page_options.tabs.tabs('select', $('#new_page_part_index').val());

              // hook into wymeditor to instruct it to select this new tab again once it has loaded.
              WYMeditor.onload_functions.push(function() {
                page_options.tabs.tabs('select', $('#new_page_part_index').val());
              });

              // turn the new textarea into a wymeditor.
              $('#page_part_new_' + $('#new_page_part_index').val()).appendTo('#page_part_editors')
              WYMeditor.init();

              // Wipe the title and increment the index counter by one.
              $('#new_page_part_index').val(parseInt($('#new_page_part_index').val(), 10) + 1);
              $('#new_page_part_title').val('');

              page_options.tabs.find('> ul li a').corner('top 5px');

              $('#new_page_part_dialog').dialog('close');
            }
          );
        }else{
          alert("A content section with that title already exists, please choose another.");
        }
      }else{
        alert("You have not entered a title for the content section, please enter one.");
      }
    });

    $('#new_page_part_cancel').click(function(e){
      e.preventDefault();
      $('#new_page_part_dialog').dialog('close');
      $('#new_page_part_title').val('');
    });

    $('#delete_page_part').click(function(e){
      e.preventDefault();

      if(confirm("This will remove the content section '" + $('#page_parts .ui-tabs-selected a').text() + "' immediately even if you don't save this page, are you sure?")) {
        var tabId = page_options.tabs.tabs('option', 'selected');
        $.ajax({
          url: page_options.del_part_url + '/' + $('#page_parts_attributes_' + tabId + '_id').val(),
          type: 'DELETE'
        });
        page_options.tabs.tabs('remove', tabId);
        $('#page_parts_attributes_' + tabId + '_id').remove();
        $('#submit_continue_button').remove();
      }

    });

  }

};

var image_dialog = {
  initialised: false
  , callback: null

  , init: function(callback){

    if (!this.initialised) {
      this.callback = callback;
      this.init_tabs();
      this.init_select();
      this.init_actions();
      this.initialised = true;
    }
    return this;
  }

  , init_tabs: function(){
    var radios = $('#dialog_menu_left input:radio');
    var selected = radios.parent().filter(".selected_radio").find('input:radio').first() || radios.first();

    radios.click(function(){
      link_dialog.switch_area($(this));
    });

    selected.attr('checked', 'true');
    link_dialog.switch_area(selected);
  }

  , switch_area: function(radio){
    $('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $(radio).parent().addClass('selected_radio');
    $('#dialog_main .dialog_area').hide();
    $('#' + radio.value + '_area').show();
  }

  , init_select: function(){
    $('#existing_image_area_content ul li img').click(function(){
        image_dialog.set_image(this);
    });
    //Select any currently selected, just uploaded...
    if ((selected_img = $('#existing_image_area_content ul li.selected img')).length > 0) {
      image_dialog.set_image(selected_img.first());
    }
  }

  , set_image: function(img){
    if ($(img).length > 0) {
      $('#existing_image_area_content ul li.selected').removeClass('selected');

      $(img).parent().addClass('selected');
      var imageId = $(img).attr('data-id');
      var geometry = $('#existing_image_size_area li.selected a').attr('data-geometry');
      var size = $('#existing_image_size_area li.selected a').attr('data-size');
      var resize = $("#wants_to_resize_image").is(':checked');

      image_url = resize ? $(img).attr('data-' + size) : $(img).attr('data-original');

      if (parent) {
        if ((wym_src = parent.document.getElementById('wym_src')) != null) {
          wym_src.value = image_url;
        }
        if ((wym_title = parent.document.getElementById('wym_title')) != null) {
          wym_title.value = $(img).attr('title');
        }
        if ((wym_alt = parent.document.getElementById('wym_alt')) != null) {
          wym_alt.value = $(img).attr('alt');
        }
        if ((wym_size = parent.document.getElementById('wym_size')) != null
            && typeof(geometry) != 'undefined') {
          wym_size.value = geometry.replace(/[<>=]/g, '');
        }
      }
    }
  }

  , submit_image_choice: function(e) {
    e.preventDefault();
    if((img_selected = $('#existing_image_area_content ul li.selected img').get(0)) && $.isFunction(this.callback))
    {
      this.callback(img_selected);
    }

    close_dialog(e);
  }

  , init_actions: function(){
    var _this = this;
    // get submit buttons not inside a wymeditor iframe
    $('#existing_image_area .form-actions-dialog #submit_button')
      .not('.wym_iframe_body #existing_image_area .form-actions-dialog #submit_button')
      .click($.proxy(_this.submit_image_choice, _this));

    // get cancel buttons not inside a wymeditor iframe
    $('.form-actions-dialog #cancel_button')
      .not('.wym_iframe_body .form-actions-dialog #cancel_button')
      .click($.proxy(close_dialog, _this));

    $('#existing_image_size_area ul li a').click(function(e) {
      $('#existing_image_size_area ul li').removeClass('selected');
      $(this).parent().addClass('selected');
      $('#existing_image_size_area #wants_to_resize_image').attr('checked', 'checked');
      image_dialog.set_image($('#existing_image_area_content ul li.selected img'));
      e.preventDefault();
    });

    $('#existing_image_size_area #wants_to_resize_image').change(function(){
      if($(this).is(":checked")) {
        $('#existing_image_size_area ul li:first a').click();
      } else {
        $('#existing_image_size_area ul li').removeClass('selected');
        image_dialog.set_image($('#existing_image_area_content ul li.selected img'));
      }
    });

    image_area = $('#existing_image_area').not('#wym_iframe_body #existing_image_area');
    image_area.find('.form-actions input#submit_button').click($.proxy(function(e) {
      e.preventDefault();
      $(this.document.getElementById('wym_dialog_submit')).click();
    }, parent));
    image_area.find('.form-actions a.close_dialog').click(close_dialog);
  }
};

var list_reorder = {
  initialised: false
  , init: function() {

    if (!this.initialised) {
      $('#reorder_action').click(list_reorder.enable_reordering);
      $('#reorder_action_done').click(list_reorder.disable_reordering);
      if(list_reorder.tree === false) {
        list_reorder.sortable_list.find('li').addClass('no-nest');
      }
      list_reorder.sortable_list.nestedSortable({
        listType: 'ul',
        disableNesting: 'no-nest',
        forcePlaceholderSize: true,
        handle: list_reorder.tree ? 'div' : null,
        items: 'li',
        opacity: .6,
        placeholder: 'placeholder',
        tabSize: 25,
        tolerance: 'pointer',
        toleranceElement: list_reorder.tree ? '> div' : null,
        disabled: true,
        start: function () {
        },
        change: function () {
          if (list_reorder.tree) {
            list_reorder.reset_branch_classes(this);
          }
        },
        stop: function () {
          if (list_reorder.tree) {
            list_reorder.reset_branch_classes(this);
          } else {
            list_reorder.reset_on_off_classes(this);
          }
        }
      });
      if (list_reorder.tree) {
        list_reorder.reset_branch_classes(list_reorder.sortable_list);
      } else {
        list_reorder.reset_on_off_classes(list_reorder.sortable_list);
      }
      this.initialised = true;
    }
  }
  , reset_on_off_classes: function(ul) {
    $("> li", ul).each(function(i, li) {
      $(li).removeClass('on off on-hover').addClass(i % 2 === 0 ? 'on' : 'off');
    });
  }

  , reset_branch_classes: function (ul) {
    $("li.ui-sortable-helper", this).removeClass("record").removeClass("branch_start").removeClass("branch_end");
    $("li", ul).removeClass("branch_start").removeClass("branch_end");

    $("> li:first", ul).addClass("branch_start");
    $("> li:last", ul).addClass("branch_end");

    var nested_ul = $("ul", ul);
    $("> li:last", nested_ul).addClass("branch_end");
  }

  ,enable_reordering: function(e) {
    if(e) { e.preventDefault(); }

    $('#sortable_list, .sortable_list').addClass("reordering");
    $('#sortable_list .actions, .sortable_list .actions, #site_bar, header > *:not(script)').fadeTo(500, 0.3);
    $('#actions *:not("#reorder_action_done, #reorder_action")').not($('#reorder_action_done').parents('li, ul, div')).fadeTo(500, 0.55);

    list_reorder.sortable_list.nestedSortable("enable");

    $('#reorder_action').hide();
    $('#reorder_action_done').show();
  }

  , disable_reordering: function(e) {
    if(e) { e.preventDefault(); }

    if($('#reorder_action_done').hasClass('loading')) { return false; }
    $('#reorder_action_done').addClass('loading');

    list_reorder.sortable_list.nestedSortable("disable");

    $('#sortable_list, .sortable_list').removeClass("reordering");

    if (list_reorder.update_url !== null) {
      var serialized = list_reorder.sortable_list.serializelist();

      $.post(list_reorder.update_url, serialized, function(data) {
        list_reorder.restore_controls(e);
      });
    } else {
      list_reorder.restore_controls(e);
    }
  }

  , restore_controls: function(e) {
    $(list_reorder.sortable_list).removeClass('reordering');

    $('#sortable_list .actions, .sortable_list .actions, #site_bar, header > *:not(script)').fadeTo(250, 1);
    $('#actions *:not("#reorder_action_done, #reorder_action")').not($('#reorder_action_done').parents('li, ul, div')).fadeTo(250, 1, function() {
      $('#reorder_action_done').hide().removeClass('loading');
      $('#reorder_action').show();
    });
  }
};

var image_picker = {
  initialised: false
  , options: {
    selected: ''
    , thumbnail: 'medium'
    , field: '#image'
    , image_display: '.current_picked_image'
    , no_image_message: '.no_picked_image_selected'
    , image_container: '.current_image_container'
    , remove_image_button: '.remove_picked_image'
    , picker_container: '.image_picker_container'
    , image_link: '.current_image_link'
    , image_toggler: null
  }

  , init: function(new_options){

    if (!this.initialised) {
      this.options = $.extend(this.options, new_options);
      $(this.options.picker_container).find(this.options.remove_image_button)
        .click($.proxy(this.remove_image, {container: this.options.picker_container, picker: this}));
      $(this.options.picker_container).find(this.options.image_toggler)
        .click($.proxy(this.toggle_image, {container: this.options.picker_container, picker: this}));

      this.initialised = true;
    }

    return this;
  }

  , remove_image: function(e) {
    e.preventDefault();

    $(this.container).find(this.picker.options.image_display)
      .removeClass('brown_border')
      .attr({'src': '', 'width': '', 'height': ''})
      .css({'width': 'auto', 'height': 'auto'})
      .hide();
    $(this.container).find(this.picker.options.field).val('');
    $(this.container).find(this.picker.options.no_image_message).show();
    $(this.container).find(this.picker.options.remove_image_button).hide();
  }

  , toggle_image: function(e) {
    $(this.container).find(this.options.image_toggler).html(
      ($(this.container).find(options.image_toggler).html() == 'Show' ? 'Hide' : 'Show')
    );
    $(this.container).find(this.options.image_container).toggle();
    e.preventDefault();
  }

  , changed: function(e) {
    $(this.container).find(this.picker.options.field).val(
      this.image.id.replace("image_", "")
    );

    var size = this.picker.options.thumbnail || 'original';
    this.image.src = $(this.image).attr('data-' + size);
    current_image = $(this.container).find(this.picker.options.image_display);
    current_image.replaceWith(
      $("<img src='"+this.image.src+"?"+Math.floor(Math.random() * 100000)+"' id='"+current_image.attr('id')+"' class='"+this.picker.options.image_display.replace(/^./, '')+" brown_border' />")
    );

    $(this.container).find(this.picker.options.remove_image_button).show();
    $(this.container).find(this.picker.options.no_image_message).hide();
  }
};

var resource_picker = {
  initialised: false
  , callback: null

  , init: function(callback) {

    if (!this.initialised) {
      this.callback = callback;
      this.initialised = true;
    }
  }
};

close_dialog = function(e) {
  if (iframed())
  {
    the_body = $(parent.document.body);
    the_dialog = parent.$('.ui-dialog-content');
  } else {
    the_body = $(document.body).removeClass('hide-overflow');
    the_dialog = $('.ui-dialog-content');
    the_dialog.filter(':data(dialog)').dialog('close');
    the_dialog.remove();
  }

  // if there's a wymeditor involved don't try to close the dialog as wymeditor will.
  if (!$(document.body).hasClass('wym_iframe_body')) {
    the_body.removeClass('hide-overflow');
    the_dialog.filter(':data(dialog)').dialog('close');
    the_dialog.remove();
    e.preventDefault();
  }
};

//parse a URL to form an object of properties
parseURL = function(url)
{
  //save the unmodified url to href property
  //so that the object we get back contains
  //all the same properties as the built-in location object
  var loc = { 'href' : url };

  //split the URL by single-slashes to get the component parts
  var parts = url.replace('//', '/').split('/');

  //store the protocol and host
  loc.protocol = parts[0];
  loc.host = parts[1];

  //extract any port number from the host
  //from which we derive the port and hostname
  parts[1] = parts[1].split(':');
  loc.hostname = parts[1][0];
  loc.port = parts[1].length > 1 ? parts[1][1] : '';

  //splice and join the remainder to get the pathname
  parts.splice(0, 2);
  // ensure we don't destroy absolute urls like /system/images/whatever.jpg
  loc.pathname = (loc.href[0] == '/' ? ("/" + loc.host) : '');
  loc.pathname += '/' + parts.join('/');

  //extract any hash and remove from the pathname
  loc.pathname = loc.pathname.split('#');
  loc.hash = loc.pathname.length > 1 ? '#' + loc.pathname[1] : '';
  loc.pathname = loc.pathname[0];

  //extract any search query and remove from the pathname
  loc.pathname = loc.pathname.split('?');
  loc.search = loc.pathname.length > 1 ? '?' + loc.pathname[1] : '';
  loc.pathname = loc.pathname[0];

  var options = url.split('?')[1];
  loc.options = options;

  //return the final object
  return loc;
};

iframed = function() {
  return (parent && parent.document && parent.document.location.href != document.location.href && $.isFunction(parent.$));
};
