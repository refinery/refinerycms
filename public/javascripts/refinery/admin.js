$(document).ready(function(){

  init_flash_messages();
  init_delete_confirmations();
  init_sortable_menu();
  init_submit_continue();
  init_modal_dialogs();
  init_tooltips();

  // focus first field in an admin form.
  $('form input[type=text]:first').focus();
});

init_delete_confirmations = function() {
  $('a.confirm-delete').click(function(e) {
    if (confirm("Are you sure you want to " + (t=($(this).attr('title') || $(this).attr('tooltip')))[0].toLowerCase() + t.substring(1) + "?")) {
      $("<form method='POST' action='" + $(this).attr('href') + "'></form>")
        .append("<input type='hidden' name='_method' value='delete' />")
        .append("<input type='hidden' name='authenticity_token' value='" + $('#admin_authenticity_token').val() + "'/>")
        .appendTo('body').submit();
    }
    e.preventDefault();
  });
}

init_flash_messages = function(){
  $('#flash').fadeIn(550);
  $('#flash_close').click(function(e) {
     $('#flash').fadeOut({duration: 330});
     e.preventDefault();
  });
}

init_modal_dialogs = function(){
  $('a[href*="dialog=true"]').not('#dialog_container a').each(function(i, anchor)
  {
    $(anchor).click(function(e){
      iframe = $("<iframe id='dialog_iframe' src='" + $(this).attr('href') + "&amp;app_dialog=true" + "'></iframe>");
      iframe.dialog({
        title: $(anchor).attr('title') || $(anchor).attr('name') || $(anchor).html() || null,
        modal: true,
        resizable: false,
        autoOpen: true,
        width: (parseInt($(anchor.href.match("width=([0-9]*)")).last().get(0))||928),
        height: (parseInt($(anchor.href.match("height=([0-9]*)")).last().get(0))||473)/*,
        beforeclose: function(){
          $(document.body).removeClass('hide-overflow');
        }*/
      });
      if ($.browser.msie) {
        iframe.css({'margin':'-2px 2px 2px -2px'});
      }
      //$(document.body).addClass('hide-overflow');
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
    items: '.tab',
    update: function(){
      var ser   = $menu.sortable('serialize', {key: 'menu[]'}),
          token = escape($('#admin_authenticity_token').val());

      $.get('/admin/update_menu_positions?' + ser, {authenticity_token: token});
    }
  });
  //Initial status disabled
  $menu.sortable('disable');

  $menu.find('#menu_reorder').click(function(e){
    e.preventDefault();
    $('#menu_reorder, #menu_reorder_done').toggle();
    $('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 0.2);
    $menu.find('.tab a').click(function(ev){
      ev.preventDefault();
    });

    $menu.sortable('enable');
  });

  $menu.find('#menu_reorder_done').click(function(e){
    e.preventDefault();
    $('#menu_reorder, #menu_reorder_done').toggle();
    $('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 1);
    $menu.find('.tab a').unbind('click');

    $menu.sortable('disable');
  });
}

init_submit_continue = function(){
  $('#submit_continue_button').click(function(e) {
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

    $.post(this.form.action, $(this.form).serialize(), function(data) {
      if ((flash_container = $('#flash_container')).length > 0) {
        flash_container.html(data);

        $('#flash').css('width', 'auto').fadeIn(550);

        $('.errorExplanation').not($('#flash_container .errorExplanation')).remove();

        if ((error_fields = $('#fieldsWithErrors').val()) != null) {
          $.each(error_fields.split(','), function() {
            $("#" + this).wrap("<div class='fieldWithErrors' />");
          });
        }

        $('.fieldWithErrors:first :input:first').focus();

        $('#continue_editing').val(false);
      }
    });

    e.preventDefault();
  });
}

init_tooltips = function(args){
  $($(args != null ? args : 'a[title], span[title], #image_grid img[title], *[tooltip]')).each(function(index, element)
  {
    // create tooltip on hover and destroy it on hoveroff.
    $(element).hover(function(e) {
      tooltip = $("<div class='tooltip'></div>").html($(this).attr('tooltip')).appendTo($('#tooltip_container'));
      tooltip.css({
          'left': ((left = $(this).offset().left - (tooltip.outerWidth() / 2) + ($(this).outerWidth() / 2)) >= 0 ? left : 0)
        , 'top': $(this).offset().top - tooltip.outerHeight() - 6
      }).show();
    }, function(e) {
      $('.tooltip').remove();
    });
    if ($(element).attr('tooltip') == null) {
      $(element).attr({'tooltip': $(element).attr('title'), 'title': ''});
    }
    // wipe clean the title on any children too.
    $(element).children('img').attr('title', '')
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
    $('#dialog-form-actions #submit_button').click(function(e){
      e.preventDefault();
      if((resource_selected = $('#existing_resource_area_content ul li.linked a')).length > 0) {
        resourceUrl = parseURL(resource_selected.attr('href'));
        relevant_href = resourceUrl.pathname;
        if (resourceUrl.protocol == "" && resourceUrl.hostname == "system") {
          relevant_href = "/system" + relevant_href;
        }

        // Add any alternate resource stores that need a absolute URL in the regex below
        if( resourceUrl.hostname.match(/s3.amazonaws.com/) ) {
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

      if(parent && typeof(parent.tb_remove) == "function"){
        parent.tb_remove();
      }
    });

    $('#dialog-form-actions #cancel_button').click(function(e){
      e.preventDefault();
      parent.tb_remove();
    });
  },

  init_close: function(){
    $('#dialog-form-actions #cancel_button').click(function(e){
      if (parent && typeof(parent.$) == "function") {
    //    parent.$(document.body).removeClass('hide-overflow');
        parent.$('.ui-dialog').dialog('close').remove();
      } else {
        $('.ui-dialog').dialog('close').remove();
    //    $(document.body).removeClass('hide-overflow');
      }
    });
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
    $('#web_address_text').change(function(){
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
    page_options.tabs = $('#page-tabs').tabs({tabTemplate: '<li><a href="#{href}">#{label}</a></li>'});
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
    }

    if(this.enable_parts){
      this.page_part_dialog();
    }
  },

  show_options: function(){
    $('#toggle_advanced_options').click(function(e){
      e.preventDefault();
      $('#more_options').toggle();
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
      width: 600
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
              // Add a new tab for the new content section.
              $('#page_part_editors').append(data);
              page_options.tabs.tabs('add', '#page_part_new_' + $('#new_page_part_index').val(), part_title);
              page_options.tabs.tabs('select', '#page_part_new_' + $('#new_page_part_index').val());

              // turn the new textarea into a wymeditor.
              $('#page_parts_attributes_' + $('#new_page_part_index').val() + "_body").wymeditor(wymeditor_boot_options);

              // Wipe the title and increment the index counter by one.
              $('#new_page_part_index').val(parseInt($('#new_page_part_index').val()) + 1);
              $('#new_page_part_title').val('');

              $('#page-tabs').tabs();
            }
          );
        }else{
          alert("A content section with that title already exists, please choose another.");
        }
      }else{
        alert("You have not entered a title for the content section, please enter one.");
      }


      $('#new_page_part_dialog').dialog('close');
    });

    $('#new_page_part_cancel').click(function(e){
      e.preventDefault();
      $('#new_page_part_dialog').dialog('close');
      $('#new_page_part_title').val('');
    });

    $('#delete_page_part').click(function(e){
      e.preventDefault();
      var stab_id = page_options.tabs.tabs('option', 'selected');
      var part_id = $('#page_parts_attributes_' + stab_id + '_id').val();
      //console.log('stab_id: ' + stab_id + ' part_id: ' + part_id);

      var result = confirm("This will remove the content section '" + $('#page_parts .ui-tabs-selected a').html() + "' and erase all content that has been entered into it even if you don't save the page, are you sure?");
      if(part_id && result) {
        $.ajax({
          url: page_options.del_part_url + '/' + part_id,
          type: 'DELETE'
        });
        page_options.tabs.tabs('remove', stab_id);
        //WYMeditor.loaded();
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
    if ((selected_image = $('#existing_image_area_content ul li.selected img')).length > 0) {
      image_dialog.set_image(selected_image.first());
    }
  }

  , set_image: function(img){
    if ($(img).length > 0) {
      $('#existing_image_area_content ul li.selected').removeClass('selected');

      $(img).parent().addClass('selected');
      var imageUrl = parseURL($(img).attr('src'));
      var relevant_src = imageUrl.pathname.replace('_dialog_thumb', '');
      if (imageUrl.protocol == "" && imageUrl.hostname == "system") {
        relevant_src = "/system" + relevant_src;
      }

      if(imageUrl.hostname.match(/s3.amazonaws.com/)){
        relevant_src = imageUrl.protocol + '//' + imageUrl.host + relevant_src;
      }

      if (parent) {
        if ((wym_src = parent.document.getElementById('wym_src')) != null) {
          wym_src.value = relevant_src;
        }
        if ((wym_title = parent.document.getElementById('wym_title')) != null) {
          wym_title.value = $(img).attr('title');
        }
        if ((wym_alt = parent.document.getElementById('wym_alt')) != null) {
          wym_alt.value = $(img).attr('alt');
        }
      }
    }
  }

  , submit_image_choice: function(e) {
    e.preventDefault();
    if((img_selected = $('#existing_image_area_content ul li.selected img').get(0)) && typeof(this.callback) == "function") {
      this.callback(img_selected);
    }

    this.close_dialog(e);
  }

  , close_dialog: function(e) {
    if (parent && typeof(parent.$) == "function") {
//      parent.parent.$(document.body).removeClass('hide-overflow');
      parent.$('.ui-dialog').dialog('close').remove();
    } else {
      $('.ui-dialog').dialog('close').remove();
//      $(document.body).removeClass('hide-overflow');
    }

    e.preventDefault();
  }

  , init_actions: function(){
    var _this = this;
    $('#dialog-form-actions #submit_button').click($.proxy(_this.submit_image_choice, _this));
    $('#dialog-form-actions #cancel_button').click($.proxy(_this.close_dialog, _this));
  }
}

var list_reorder = {
  init: function() {
    $('#reorder_action').click(list_reorder.enable_reordering);
    $('#reorder_action_done').click(list_reorder.disable_reordering);
  }

  , enable_reordering: function(e) {
    if(e) { e.preventDefault(); }

    list_reorder.sortable_list.find('li').each(function(index, li) {
      if ($('ul', li).length) { return; }
      $("<ul></ul>").appendTo(li);
    });

    list_reorder.sortable_list.add(list_reorder.sortable_list.find('ul')).sortable({
      'connectWith': $(list_reorder.sortable_list.find('ul'))
			, 'tolerance': 'pointer'
			, 'placeholder': 'placeholder'
			, 'cursor': 'drag'
			, 'items': 'li'
			, 'axis': 'y'
    });

    $('#reorder_action').hide();
    $('#reorder_action_done').show();
  }

  , parse_branch: function(indexes, li) {
    branch = "&sortable_list";
    $.each(indexes, function(i, index) {
      branch += "[" + index + "]";
    });
    branch += "[id]=" + $($(li).attr('id').split('_')).last().get(0);

    // parse any children branches too.
    $(li).find('> li[id], > ul li[id]').each(function(i, child) {
      current_indexes = $.merge($.merge([], indexes), [i]);
      branch += list_reorder.parse_branch(current_indexes, child);
    });

    return branch;
  }

  , disable_reordering: function(e) {
    if(e) { e.preventDefault(); }

    if (list_reorder.update_url != null) {
      serialized = "";
  	  list_reorder.sortable_list.find('> li[id]').each(function(index, li) {
        if (list_reorder.tree) {
  	      serialized += list_reorder.parse_branch([index], li);
        }
        else {
          serialized += "&sortable_list[]=" + $($(li).attr('id').split('_')).last().get(0);
        }
  	  });
  	  serialized += "&tree=" + list_reorder.tree + "&authenticity_token=" + encodeURIComponent($('#reorder_authenticity_token').val() + "&continue_reordering=false");

      $.post(list_reorder.update_url, serialized, function(data) {
        $(list_reorder.sortable_list.get(0)).html(data);

        $(list_reorder.sortable_list).removeClass('reordering').sortable('destroy');

        $('#reorder_action_done').hide();
        $('#reorder_action').show();
      });
    } else {
      $(list_reorder.sortable_list).removeClass('reordering').sortable('destroy');

      $('#reorder_action_done').hide();
      $('#reorder_action').show();
    }
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

    image.src = image.src.replace('_dialog_thumb', '_' + this.options.thumbnail).replace(/\?\d*/, '');

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
	loc.pathname = '/' + parts.join('/');

	//extract any hash and remove from the pathname
	loc.pathname = loc.pathname.split('#');
	loc.hash = loc.pathname.length > 1 ? '#' + loc.pathname[1] : '';
	loc.pathname = loc.pathname[0];

	//extract any search query and remove from the pathname
	loc.pathname = loc.pathname.split('?');
	loc.search = loc.pathname.length > 1 ? '?' + loc.pathname[1] : '';
	loc.pathname = loc.pathname[0];

	//return the final object
	return loc;
}