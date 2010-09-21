var shiftHeld = false;
$(document).ready(function(){
  init_interface();
  init_sortable_menu();
  init_submit_continue();
  init_modal_dialogs();
  init_tooltips();
});

init_interface = function() {
  if (parent && parent.document.location.href != document.location.href) {
    $('body#dialog_container.dialog').addClass('iframed');
  }
  $('input:submit:not(.button)').addClass('button');

  $('.button, #editor_switch a').corner('6px');
  $('#editor_switch a').appendTo($('<span></span>').prependTo('#editor_switch').corner('6px'));
  $('#page_container, .wym_box').corner('5px bottom');
  $('.wym_box').corner('5px tr');
  $('.field > .wym_box').corner('5px tl');
  $('.wym_iframe iframe').corner('2px');
  $('.form-actions:not(".form-actions-dialog")').corner('5px');
  $('#recent_activity li a, #recent_inquiries li a').each(function(i, a) {
    $(this).textTruncate({
      width: $(this).width()
      , tooltip: false
    });
  });

  // make sure that users can tab to wymeditor fields and add an overlay while loading.
  $('textarea.wymeditor').each(function() {
    textarea = $(this);
    if ((instance = WYMeditor.INSTANCES[$((textarea.next('.wym_box').find('iframe').attr('id')||'').split('_')).last().get(0)]) != null) {
      if ((next = textarea.parent().next()) != null && next.length > 0) {
        next.find('input, textarea').keydown($.proxy(function(e) {
          shiftHeld = e.shiftKey;
          if (shiftHeld && e.keyCode == $.ui.keyCode.TAB) {
            this._iframe.contentWindow.focus();
            e.preventDefault();
          }
        }, instance)).keyup(function(e) {
          shiftHeld = false;
        });
      }
      if ((prev = textarea.parent().prev()) != null && prev.length > 0) {
        prev.find('input, textarea').keydown($.proxy(function(e) {
          if (e.keyCode == $.ui.keyCode.TAB) {
            this._iframe.contentWindow.focus();
            e.preventDefault();
          }
        }, instance));
      }
    }
  });

  // ensure that the menu isn't wider than the page_container or else it looks silly to round that corner.
  if (($menu = $('#menu')).length > 0) {
    $menu.jcarousel({
      vertical: false
      , scroll: 1
      , buttonNextHTML: "<img src='/images/refinery/carousel-right.png' alt='down' height='15' width='10' />"
      , buttonPrevHTML: "<img src='/images/refinery/carousel-left.png' alt='up' height='15' width='10' />"
      , listTag: $menu.get(0).tagName.toLowerCase()
      , itemTag: $menu.children(':first').get(0).tagName.toLowerCase()
    });

    if ($menu.outerWidth() < $('#page_container').outerWidth()) {
      $("#page_container:not('.login #page_container')").corner('5px tr');
    } else {
      $("#page_container:not('.login #page_container')").uncorner();
    }
  }

  $('#current_locale li a').click(function(e) {
    $('#current_locale li a span').each(function(span){
      $(this).css('display', $(this).css('display') == 'none' ? '' : 'none');
    });
    $('#other_locales').animate({opacity: 'toggle', height: 'toggle'}, 250);
    e.preventDefault();
  });
}

init_modal_dialogs = function(){
  $('a[href*="dialog=true"]').not('#dialog_container a').each(function(i, anchor) {
    $(anchor).data({
      'dialog-width': parseInt($($(anchor).attr('href').match("width=([0-9]*)")).last().get(0))||928
      , 'dialog-height': parseInt($($(anchor).attr('href').match("height=([0-9]*)")).last().get(0))||473
      , 'dialog-title': ($(anchor).attr('title') || $(anchor).attr('name') || $(anchor).html() || null)
    }).attr('href', $(anchor).attr('href').replace(/(\&(amp\;)?)?dialog\=true/, '')
                                          .replace(/(\&(amp\;)?)?width\=\d+/, '')
                                          .replace(/(\&(amp\;)?)?height\=\d+/, '')
                                          .replace(/(\?&(amp\;)?)/, '?')
                                          .replace(/\?$/, ''))
    .click(function(e){
      $anchor = $(this);
      iframe_src = (iframe_src = $anchor.attr('href'))
                   + (iframe_src.indexOf('?') > -1 ? '&amp;' : '?')
                   + 'app_dialog=true&amp;dialog=true';

      iframe = $("<iframe id='dialog_iframe' src='" + iframe_src + "'></iframe>").corner('8px');
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
      if ($.browser.msie) {
        iframe.css({'margin':'-2px 2px 2px -2px'});
      }
      if(parseInt($anchor.data('dialog-height')) < $(window).height()) {
        $(document.body).addClass('hide-overflow');
      }
      e.preventDefault();
    });
  });
}

init_sortable_menu = function(){
  var $menu = $('#menu');

  if($menu.length == 0){return}

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
}

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
}

init_submit_continue = function(){
  $('#submit_continue_button').click(submit_and_continue);

  $('form').change(function(e) {
    $(this).attr('data-changes-made', true);
  });

  if ((continue_editing_button = $('#continue_editing')).length > 0 && continue_editing_button.attr('rel') != 'no-prompt') {
    $('#editor_switch a').click(function(e) {
      if ($('form[data-changes-made]').length > 0) {
        if (!confirm("Any changes you've made will be lost. Are you sure you want to continue without saving?")) {
          e.preventDefault();
        }
      }
    });
  }
}

submit_and_continue = function(e, redirect_to) {
  // ensure wymeditors are up to date.
  if ($(this).hasClass('wymupdate')) {
    $.each(WYMeditor.INSTANCES, function(index, wym)
    {
      wym.update();
    });
  }

  $('#continue_editing').val(true);
  $('#flash').fadeOut(250)

  $('.fieldWithErrors').removeClass('fieldWithErrors').addClass('field');
  $('#flash_container .errorExplanation').remove();

  $.post($('#continue_editing').get(0).form.action, $($('#continue_editing').get(0).form).serialize(), function(data) {
    if (($flash_container = $('#flash_container')).length > 0) {
      $flash_container.html(data);

      $('#flash').css('width', 'auto').fadeIn(550);

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
}

init_tooltips = function(args){
  $($(args != null ? args : 'a[title], span[title], #image_grid img[title], *[tooltip]')).not('.no-tooltip').each(function(index, element)
  {
    // create tooltip on hover and destroy it on hoveroff.
    $(element).hover(function(e) {
      $(this).oneTime(350, 'tooltip', $.proxy(function() {
        $('.tooltip').remove();
        tooltip = $("<div class='tooltip'><div><span></span></div></div>").corner('6px').appendTo('#tooltip_container');
        tooltip.find("span").html($(this).attr('tooltip')).corner('6px');

        nib = $("<img src='/images/refinery/tooltip-nib.png' class='tooltip-nib'/>").appendTo('#tooltip_container');

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
          'top': $(this).offset().top - tooltip.outerHeight() - 2
        })

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

    }, function(e) {
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
    }).click(function(e) {
      $(this).stopTime('tooltip');
    });
    if ($(element).attr('tooltip') == null) {
      $(element).attr('tooltip', $(element).attr('title'));
    }
    // wipe clean the title on any children too.
    $(element).add($(element).children('img')).removeAttr('title');
  });
}

var link_dialog = {
  init: function(test_url, test_email){
    this.test_url = test_url;
    this.test_email = test_email;
    this.init_tabs();
    this.init_resources_submit();
    this.init_close();
    this.page_tab();
    this.web_tab();
    this.email_tab();
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
    $('.form-actions-dialog #cancel_button').click(close_dialog);

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
    $('#web_address_text').bind('paste change',function(){
      var prefix = '#web_address_',
          icon = '';

      $(prefix + 'test_loader').show();
      $(prefix + 'test_result').hide();
      $(prefix + 'test_result').removeClass('success_icon').removeClass('failure_icon');

      $.getJSON(link_dialog.test_url, {url: this.value}, function(data){
        if(data.result == 'success'){
          icon = 'success_icon';
        }else{
          icon = 'failure_icon';
        }

        $(prefix + 'test_result').addClass(icon).show();
        $(prefix + 'test_loader').hide();
      });

      link_dialog.update_parent( $(prefix + 'text').val(),
                                 $(prefix + 'text').val(),
                                 ($(prefix + 'target_blank').checked ? "_blank" : "")
                               );
    });

    $('#web_address_target_blank').click(function(){
      parent.document.getElementById('wym_target').value = this.checked ? "_blank" : "";
    });

  },

  email_tab: function() {
    $('#email_address_text, #email_default_subject_text, #email_default_body_text').change(function(e){
      var default_subject = $('#email_default_subject_text').val(),
          default_body = $('#email_default_body_text').val(),
          mailto = "mailto:" + $('#email_address_text').val(),
          modifier = "?",
          icon = '';

      $('#email_address_test_loader').show();
      $('#email_address_test_result').hide();
      $('#email_address_test_result').removeClass('success_icon').removeClass('failure_icon');

      $.getJSON(link_dialog.test_email, {email: mailto}, function(data){
        if(data.result == 'success'){
          icon = 'success_icon';
        }else{
          icon = 'failure_icon';
        }

        $('#email_address_test_result').addClass(icon).show();
        $('#email_address_test_loader').hide();
      });

      if(default_subject.length > 0){
        mailto += modifier + "subject=" + default_subject;
        modifier = "&";
      }

      if(default_body.length > 0){
        mailto += modifier + "body=" + default_body;
        modifier = "&";
      }

      link_dialog.update_parent(mailto, mailto.replace('mailto:', ''));
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
}

var page_options = {
  init: function(enable_parts, new_part_url, del_part_url){
    // set the page tabs up, but ensure that all tabs are shown so that when wymeditor loads it has a proper height.
    // also disable page overflow so that scrollbars don't appear while the page is loading.
    $(document.body).addClass('hide-overflow');
    page_options.tabs = $('#page-tabs');
    page_options.tabs.tabs({tabTemplate: '<li><a href="#{href}">#{label}</a></li>'})
    page_options.tabs.find(' > ul li a').corner('top 5px');

    part_shown = $('#page-tabs .page_part.field').not('.ui-tabs-hide');
    $('#page-tabs .page_part.field').removeClass('ui-tabs-hide');

    this.enable_parts = enable_parts;
    this.new_part_url = new_part_url;
    this.del_part_url = del_part_url;
    this.show_options();
    this.title_type();

    // Hook into the loaded function. This will be called when WYMeditor has done its thing.
    WYMeditor.loaded = function(){
      // hide the tabs that are supposed to be hidden and re-enable overflow.
      $(document.body).removeClass('hide-overflow');
      $('#page-tabs .page_part.field').not(part_shown).addClass('ui-tabs-hide');
      $('#page-tabs > ul li a').corner('top 5px');
    }

    if(this.enable_parts){
      this.page_part_dialog();
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

  title_type: function(){
    $("input[name=page\[custom_title_type\]]").change(function(){
      $('#custom_title_text, #custom_title_image').hide();
      $('#custom_title_' + this.value).show();
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

        if ($('#part_' + tab_title).size() == 0) {
          $.get(page_options.new_part_url,
            {
              title: part_title
              , part_index: $('#new_page_part_index').val()
              , body: ''
            }
            , function(data, status){
              $('#submit_continue_button').remove();
              // Add a new tab for the new content section.
              $(data).appendTo('#page_part_editors');
              page_options.tabs.tabs('add', '#page_part_new_' + $('#new_page_part_index').val(), part_title);
              page_options.tabs.tabs('select', $('#new_page_part_index').val());

              // turn the new textarea into a wymeditor.
              $('#page_parts_attributes_' + $('#new_page_part_index').val() + "_body").wymeditor(wymeditor_boot_options);

              // hook into wymedtior to instruct it to select this new tab again once it has loaded.
              WYMeditor.loaded = function() {
                page_options.tabs.tabs('select', $('#new_page_part_index').val());
                WYMeditor.loaded = function(){}; // kill it again.
              }

              // Wipe the title and increment the index counter by one.
              $('#new_page_part_index').val(parseInt($('#new_page_part_index').val()) + 1);
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

      if(confirm("This will remove the content section '" + $('#page_parts .ui-tabs-selected a').html() + "' immediately even if you don't save this page, are you sure?")) {
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

}

var image_dialog = {
  callback: null

  , init: function(callback){
    this.callback = callback;
    this.init_tabs();
    this.init_select();
    this.init_actions();
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
      var imageThumbnailSize = $('#existing_image_size_area li.selected a').attr('data-size');
      var resize = $("#wants_to_resize_image").is(':checked');

      var url = '/refinery/images/'+imageId+'/url';
      if (resize) {
        url += '?size='+imageThumbnailSize;
      }

      var data;
      $.ajax({
        async: false,
        url: url,
        success: function (result, status, xhr) {
          if (result.error) {
            if (console && console.log) {
               console.log("Something went wrong with the image insertion!");
               console.log(result);
             }
           } else {
             data = result;
           }
         },
         error: function(xhr, txt, status) {
           if (console && console.log) {
             console.log("Something went wrong with the image insertion!");
             console.log(xhr);
             console.log(txt);
             console.log(status);
           }
         }
       });

      if (parent) {
        if ((wym_src = parent.document.getElementById('wym_src')) != null) {
          wym_src.value = data.url
        }
        if ((wym_title = parent.document.getElementById('wym_title')) != null) {
          wym_title.value = $(img).attr('title');
        }
        if ((wym_alt = parent.document.getElementById('wym_alt')) != null) {
          wym_alt.value = $(img).attr('alt');
        }
        if ((wym_size = parent.document.getElementById('wym_size')) != null) {
          wym_size.value = imageThumbnailSize.replace(/[<>=]/g, '');
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
    $('#existing_image_area .form-actions-dialog #submit_button').click($.proxy(_this.submit_image_choice, _this));
    $('.form-actions-dialog #cancel_button').click($.proxy(close_dialog, _this));
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

    if (parent && parent.document.location.href != document.location.href
        && parent.document.getElementById('wym_dialog_submit') != null) {
      $('#existing_image_area .form-actions input#submit_button').click($.proxy(function(e) {
        e.preventDefault();
        $(this.document.getElementById('wym_dialog_submit')).click();
      }, parent));
      $('#existing_image_area .form-actions a.close_dialog').click(close_dialog);
    }
  }
}

var list_reorder = {
  init: function() {
    $('#reorder_action').click(list_reorder.enable_reordering);
    $('#reorder_action_done').click(list_reorder.disable_reordering);
    list_reorder.sortable_list.nestedSortable({
      disableNesting: 'no-nest',
      forcePlaceholderSize: true,
      handle: 'div',
      items: 'li',
      opacity: .6,
      placeholder: 'placeholder',
      tabSize: 25,
      tolerance: 'pointer',
      toleranceElement: '> div',
      disabled: true,
      start: function () {
      },
      change: function () {
        list_reorder.reset_branch_classes(this);
      },
      stop: function () {
        list_reorder.reset_branch_classes(this);
      }
    });
    list_reorder.reset_branch_classes(list_reorder.sortable_list);
  }

  ,reset_branch_classes: function (ul) {
    $("li.ui-sortable-helper", this).removeClass("record").removeClass("branch_start").removeClass("branch_end");
    $("li", ul).removeClass("branch_start").removeClass("branch_end");

    $("> li:first", ul).addClass("branch_start")
    $("> li:last", ul).addClass("branch_end")

    var nested_ul = $("ul", ul);
    $("> li:last", nested_ul).addClass("branch_end");
  }

  ,enable_reordering: function(e) {
    if(e) { e.preventDefault(); }
    $('#sortable_list').addClass("reordering");

    $('#sortable_list .actions, #site_bar, header > *:not(script)').fadeTo(500, 0.3);
    $('#actions *:not("#reorder_action_done, #reorder_action")').not($('#reorder_action_done').parents('li, ul')).fadeTo(500, 0.55);

    list_reorder.sortable_list.nestedSortable("enable");
    $('#reorder_action').hide();
    $('#reorder_action_done').show();
  }

  , disable_reordering: function(e) {
    if($('#reorder_action_done').hasClass('loading')){
      return false;
    }
    if(e) { e.preventDefault(); }
    $('#reorder_action_done').addClass('loading');
    list_reorder.sortable_list.nestedSortable("disable");

    $('#sortable_list').removeClass("reordering");

    if (list_reorder.update_url != null) {

      var serialized = list_reorder.sortable_list.serializelist();

      $.post(list_reorder.update_url, serialized, function(data) {
        list_reorder.restore_controls(e);
      });
    } else {
      list_reorder.restore_controls(e);
    }
  }

  , restore_controls: function(e) {
    if (list_reorder.tree && !$.browser.msie) {
      list_reorder.sortable_list.add(list_reorder.sortable_list.find('ul, li')).draggable('destroy');
    } else {
      $(list_reorder.sortable_list).sortable('destroy');
    }
    $(list_reorder.sortable_list).removeClass('reordering, ui-sortable');

    $('#sortable_list .actions, #site_bar, header > *:not(script)').fadeTo(250, 1);
    $('#actions *:not("#reorder_action_done, #reorder_action")').not($('#reorder_action_done').parents('li, ul')).fadeTo(250, 1, function() {
      $('#reorder_action_done').hide().removeClass('loading');
      $('#reorder_action').show();
    });
  }
}

var image_picker = {
  options: {
    selected: '',
    thumbnail: 'dialog_thumb',
    field: '#image',
    image_display: '#current_picked_image',
    no_image_message: '#no_picked_image_selected',
    image_container: '#current_image_container',
    remove_image_button: '#remove_picked_image',
    image_toggler: null
  }

  , init: function(new_options){
    this.options = $.extend(this.options, new_options);
    $(this.options.remove_image_button).click($.proxy(this.remove_image, this));
    $(this.options.image_toggler).click($.proxy(this.toggle_image, this));
  }

  , remove_image: function(e) {
    e.preventDefault();
    $(this.options.image_display).removeClass('brown_border')
                              .attr({'src': '', 'width': '', 'height': ''})
                              .css({'width': 'auto', 'height': 'auto'})
                              .hide();
    $(this.options.field).val('');
    $(this.options.no_image_message).show();
    $(this.options.remove_image_button).hide();
    $(this).hide();
  }

  , toggle_image: function(e) {
    $(this.options.image_toggler).html(($(this.options.image_toggler).html() == 'Show' ? 'Hide' : 'Show'));
    $(this.options.image_container).toggle();
    e.preventDefault();
  }

  , changed: function(image) {
    $(this.options.field).val(image.id.replace("image_", ""));

    $.ajax({
      async: false,
      url: '/refinery/images/'+$(image).attr('data-id')+'/url?size='+this.options.thumbnail,
      success: function (result, status, xhr) {
        if (result.error) {
          if (console && console.log) {
             console.log("Something went wrong with the image insertion!");
             console.log(result);
           }
         } else {
           image.src = result.url;
         }
       },
       error: function(xhr, txt, status) {
         if (console && console.log) {
           console.log("Something went wrong with the image insertion!");
           console.log(xhr);
           console.log(txt);
           console.log(status);
         }
       }
    });

    current_image = $(this.options.image_display);
    current_image.replaceWith($("<img src='"+image.src+"?"+Math.floor(Math.random() * 1000000000)+"' id='"+current_image.attr('id')+"' class='brown_border' />"));

    $(this.options.remove_image_button).show();
    $(this.options.no_image_message).hide();
  }
}

var resource_picker = {
  callback: null

  , init: function(callback) {
    this.callback = callback;
  }
}

close_dialog = function(e) {
  if (parent
      && parent.document.location.href != document.location.href
      && $.isFunction(parent.$))
  {
    $(parent.document.body).removeClass('hide-overflow');
    parent.$('.ui-dialog').dialog('close').remove();
  } else {
    $(document.body).removeClass('hide-overflow');
    $('.ui-dialog').dialog('close').remove();
  }

  e.preventDefault();
}

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
}
