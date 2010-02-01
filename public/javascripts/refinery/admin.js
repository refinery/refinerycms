$j(document).ready(function(){

  init_flash_messages();
  init_sortable_menu();
  init_submit_continue();
  init_modal_dialogs();
  init_tooltips();

  // focus first field in an admin form.
  $j('form input[type=text]:first').focus();
});

init_flash_messages = function(){
  $j('#flash').fadeIn(550);
  $j('#flash_close').click(function(e) {
     $j('#flash').fadeOut({duration: 330});
     e.preventDefault();
  });
}

init_modal_dialogs = function(){
  $j('a[href*="dialog=true"]').each(function(i, anchor)
  {
    $j.each(['modal=true', 'width=928', 'height=473', 'titlebar=true', 'draggable=true'], function(index, feature)
    {
      if (anchor.href.indexOf(feature.split('=')[0] + '=') == -1)
      {
        anchor.href += "&" + feature;
      }
    });

    tb_init(anchor);
  });
}

init_sortable_menu = function(){
  var $menu = $j('#menu');

  if($menu.length == 0){return}

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

  $menu.find('#menu_reorder').click(function(e){
    e.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 0.2);
    $menu.find('.tab a').click(function(ev){
      ev.preventDefault();
    });

    $menu.sortable('enable');
  });

  $menu.find('#menu_reorder_done').click(function(e){
    e.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 1);
    $menu.find('.tab a').unbind('click');

    $menu.sortable('disable');
  });
}

init_submit_continue = function(){
  $j('#submit_continue_button').click(function(e) {
    // ensure wymeditors are up to date.
    if ($j(this).hasClass('wymupdate')) {
      $j.each(WYMeditor.INSTANCES, function(index, wym)
      {
        wym.update();
      });
    }

    $j('#continue_editing').val(true);
    $j('#flash').fadeOut(250)

    $j('.fieldWithErrors').removeClass('fieldWithErrors').addClass('field');
    $j('#flash_container .errorExplanation').remove();

    $j.post(this.form.action, this.form.serialize(), function(data) {
      if ((flash_container = $j('#flash_container')).length > 0) {
        flash_container.html(data);

        $j('#flash').css('width', 'auto').fadeIn(550);

        $j('.errorExplanation').not($j('#flash_container .errorExplanation')).remove();

        $j.each($j('#fieldsWithErrors').val().split(','), function() {
          $j("#" + this).wrap("<div class='fieldWithErrors' />");
        });

        $j('.fieldWithErrors:first :input:first').focus();

        $j('#continue_editing').val(false);
      }
    });

    e.preventDefault();
  });
}

init_tooltips = function(args){
  if (typeof(Tooltip) != "undefined") {
    $j($j(args != null ? args : 'a[title], #image_grid img[title]')).each(function(index, element)
    {
      new Tooltip(element, {mouseFollow:false, delay: 0, opacity: 1, appearDuration:0, hideDuration: 0, rounded: false});
    });
  }
}

var link_dialog = {
  init: function(test_url, test_email){
    this.test_url = test_url;
    this.test_email = test_email;
    this.init_tabs();
    this.init_close();
    this.page_tab();
    this.web_tab();
    this.email_tab();
  },

  init_tabs: function(){
    var radios = $j('#dialog_menu_left input:radio');
    var selected = radios.parent().filter(".selected_radio").find('input:radio').first() || radios.first();

    radios.click(function(){
      link_dialog.switch_area($j(this));
    });

    selected.attr('checked', 'true');
    link_dialog.switch_area(selected);
  },

  init_close: function(){
    $j('#TB_title .close_dialog', '#dialog_container .close_dialog').click(function(e) {
      e.preventDefault();

      // if we're in a frame
      if(parent && typeof(parent.tb_remove) == "function"){
        parent.tb_remove();
      } // if we're not in a frame
      else if(typeof(tb_remove) == 'function'){
        tb_remove();
      }
    });
  },

  switch_area: function(area){
    $j('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $j(area).parent().addClass('selected_radio');
    $j('#dialog_main .dialog_area').hide();
    $j('#' + $j(area).val() + '_area').show();
  },

  //Same for resources tab
  page_tab: function(){
    $j('.link_list li').click(function(e){
      e.preventDefault();

      remove_linked_class();
      $j(this).addClass('linked');

      function remove_linked_class(){
        $j('.link_list li.linked').removeClass('linked');
      }

      var link = $j(this).children('a.page_link').get(0);
      var port = (window.location.port.length > 0 ? (":" + window.location.port) : "");
      var url = link.href.replace(window.location.protocol + "//" + window.location.hostname + port, "");

      link_dialog.update_parent(url, link.rel);
    });
  },

  web_tab: function(){
    $j('#web_address_text').change(function(){
      var prefix = '#web_address_',
          icon = '';

      $j(prefix + 'test_loader').show();
      $j(prefix + 'test_result').hide();
      $j(prefix + 'test_result').removeClass('success_icon').removeClass('failure_icon');

      $j.getJSON(link_dialog.test_url, {url: this.value}, function(data){
        if(data.result == 'success'){
          icon = 'success_icon';
        }else{
          icon = 'failure_icon';
        }

        $j(prefix + 'test_result').addClass(icon).show();
        $j(prefix + 'test_loader').hide();
      });

      link_dialog.update_parent( $j(prefix + 'text').val(),
                                 $j(prefix + 'text').val(),
                                 ($j(prefix + 'target_blank').checked ? "_blank" : "")
                               );
    });

    $j('#web_address_target_blank').click(function(){
      parent.document.getElementById('wym_target').value = this.checked ? "_blank" : "";
    });

  },

  email_tab: function(){
    $j('#email_address_text, #email_default_subject_text, #email_default_body_text').change(function(e){
      var default_subject = $j('#email_default_subject_text').val(),
          default_body = $j('#email_default_body_text').val(),
          mailto = "mailto:" + $j('#email_address_text').val(),
          modifier = "?",
          icon = '';

      $j('#email_address_test_loader').show();
      $j('#email_address_test_result').hide();
      $j('#email_address_test_result').removeClass('success_icon').removeClass('failure_icon');

      $j.getJSON(link_dialog.test_email, {email: mailto}, function(data){
        if(data.result == 'success'){
          icon = 'success_icon';
        }else{
          icon = 'failure_icon';
        }

        $j('#email_address_test_result').addClass(icon).show();
        $j('#email_address_test_loader').hide();
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

  update_parent: function(url, title, target){
      parent.document.getElementById('wym_href').value = url;
      parent.document.getElementById('wym_title').value = title;
      parent.document.getElementById('wym_target').value = target || '';
  }
}


var page_options = {
  init: function(enable_parts, new_part_url, del_part_url){
    this.enable_parts = enable_parts;
    this.new_part_url = new_part_url;
    this.del_part_url = del_part_url;
    this.show_options();
    this.title_type();

    // Hook into the loaded function. This will be called when WYMeditor has done its thing.
    WYMeditor.loaded = function(){
      page_options.tabs = $j('#page-tabs').tabs();
    }

    if(this.enable_parts){
      this.page_part_dialog();
    }
  },

  show_options: function(){
    $j('#toggle_advanced_options').click(function(e){
      e.preventDefault();
      $j('#more_options').toggle();
    });
  },

  title_type: function(){
    $j("input[name=page\[custom_title_type\]]").change(function(){
      $j('#custom_title_text, #custom_title_image').hide();
      $j('#custom_title_' + this.value).show();
    });
  },

  page_part_dialog: function(){
    $j('#new_page_part_dialog').dialog({
      title: 'Create Content Section',
      modal: true,
      resizable: false,
      autoOpen: false
    });

    $j('#add_page_part').click(function(e){
      e.preventDefault();
      $j('#new_page_part_dialog').dialog('open');
    });

    $j('#new_page_part_save').click(function(e){
      e.preventDefault();

      var part_title = $j('#new_page_part_title').val();

      if(part_title.length > 0){
        var tab_title = part_title.toLowerCase().gsub(" ", "_");

        if ($j('#part_' + tab_title).size() == 0){
          $j.get(page_options.new_part_url,
            {title: tab_title, part_index: $j('#new_page_part_index').val(), body: ''},
            function(data, status){
              // Add a new tab for the new content section.
              $j('#page_part_editors').append(data);
              page_options.tabs.tabs('add', '#part_' + tab_title, part_title);
              page_options.tabs.tabs('select', '#part_' + tab_title);
              // turn the new textarea into a wymeditor.
              $j('#page_parts_attributes_' + $j('#new_page_part_index').val() + "_body").wymeditor(wymeditor_boot_options);
              // Wipe the title and increment the index counter by one.
              $j('#new_page_part_index').val(parseInt($j('#new_page_part_index').val()) + 1);
              $j('#new_page_part_title').val('');
            }
          );
        }else{
          alert("A content section with that title already exists, please choose another.");
        }
      }else{
        alert("You have not entered a title for the content section, please enter one.");
      }


      $j('#new_page_part_dialog').dialog('close');
    });

    $j('#new_page_part_cancel').click(function(e){
      e.preventDefault();
      $j('#new_page_part_dialog').dialog('close');
      $j('#new_page_part_title').val('');
    });

    $j('#delete_page_part').click(function(e){
      e.preventDefault();
      var stab_id = page_options.tabs.tabs('option', 'selected');
      var part_id = $j('#page_parts_attributes_' + stab_id + '_id').val();
      //console.log('stab_id: ' + stab_id + ' part_id: ' + part_id);

      var result = confirm("This will remove the content section '" + $j('#page_parts .ui-tabs-selected a').html() + "' when the page is saved and erase all content that has been entered into it, Are you sure?");
      if(part_id && result){
        $j.ajax({
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
  init: function(){
    this.init_tabs();
    this.init_select();
    this.init_submit();
  },

  init_tabs: function(){
    var radios = $j('#dialog_menu_left input:radio');
    var selected = radios.parent().filter(".selected_radio").find('input:radio').first() || radios.first();

    radios.click(function(){
      link_dialog.switch_area($j(this));
    });

    selected.attr('checked', 'true');
    link_dialog.switch_area(selected);
  },

  switch_area: function(radio){
    $j('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $j(radio).parent().addClass('selected_radio');
    $j('#dialog_main .dialog_area').hide();
    $j('#' + radio.value + '_area').show();
  },

  init_select: function(){
    $j('#existing_image_area_content ul li img').click(function(){
        image_dialog.set_image(this);
    });
    //Select any currently selected, just uploaded...
    if ((selected_image = $j('#existing_image_area_content ul li.selected img')).length > 0) {
      image_dialog.set_image(selected_image.first());
    }
  },

  set_image: function(img){
    if ($j(img).length > 0) {
      $j('#existing_image_area_content ul li.selected').removeClass('selected');

      $j(img).parent().addClass('selected');
      var imageUrl = parseURL($j(img).attr('src'));
      var relevant_src = imageUrl.pathname.replace('_dialog_thumb', '');
      if (imageUrl.protocol == "" && imageUrl.hostname == "system") {
        relevant_src = "/system" + relevant_src;
      }

      if(imageUrl.hostname.match(/s3.amazonaws.com/)){
        relevant_src = imageUrl.protocol + '//' + imageUrl.host + relevant_src;
      }

      try {
        parent.document.getElementById('wym_src').value = relevant_src;
        parent.document.getElementById('wym_title').value = img.title;
        parent.document.getElementById('wym_alt').value = img.alt;
      }
      catch(e){}
    }
  },

  init_submit: function(){
    $j('#dialog-form-actions #submit_button').click(function(e){
      e.preventDefault();
      var img_selected = $j('#existing_image_area_content ul li.selected img').get(0);

      if(img_selected){
        parent.image_picker.changed(img_selected);
      }

      self.parent.tb_remove();
    });

    $j('#dialog-form-actions #cancel_button').click(function(e){
      e.preventDefault();
      parent.tb_remove();
    });
  }
}


  var list_reorder = {
    init: function(){
      this.reordering_button_enabled = true;
      this.sortable_list = $j(this.sortable_list);

      $j('#reorder_action').click(list_reorder.enable_reordering);
      $j('#reorder_action_done').click(list_reorder.disable_reordering);
    },

    enable_reordering: function(e){
      if(e){
        e.preventDefault();
      }

      var nest_id = 0;
      $j(list_reorder.sortable_list).find('li').each(function(index, li) {
        if ($j('ul', li).length) { return; }
        $j('<ul></ul>').appendTo(li);
      });

      $j(list_reorder.sortable_list, list_reorder.sortable_list + ' ul').sortable({
        'connectWith':$j(list_reorder.sortable_list, list_reorder.sortable_list + ' ul')
  			, 'tolerance': 'pointer'
  			, 'placeholder': 'placeholder'
  			, 'cursor': 'drag'
  			, 'items': 'li'
  			,	update: function(e, ui) {
  			  to_post = "";
  			  $j(list_reorder.sortable_list).find('>li').each(function(index, li) {
  			    if (index > 0) { to_post += "&amp;"; }
  			    to_post += "sortable_list[" + index + "][id]=" + $j($j(li).attr('id').split('_')).last().get(0);
  			    li.find('> li, > ul li').each(function(i, child) {
  			      to_post += "&amp;sortable_list[" + index + "][" + i + "][id]=" + $j($j(child).attr('id').split('_')).last().get(0);
  			    });
  			  });
console.log(to_post);
          // this needs to be written correctly
          if (1 == 2) {
  			    $j.post(list_reorder.update_url, to_post); 
			    }

  			}
      });

      /*
      list_reorder.sortable_list.find('ul.nested').each(function(){
        this.id = this.id.length > 0 ? this.id : 'nested_" + nest_id++;
        Sortable.create(this.id,{
          constraint: list_reorder.tree ? "false" : "'vertical'",
          hoverclass: 'hover',
          scroll: window,
          tree: list_reorder.tree
        });
      });

      Sortable.create(list_reorder.sortable_list.get(0), {
        constraint: list_reorder.tree ? 'false' : 'vertical',
        hoverclass: 'hover',
        scroll: window,
        tree: list_reorder.tree,
        onUpdate:function(){
          list_reorder.reordering_button_enabled = false;
          $j.post(list_reorder.update_url,
                  Sortable.serialize(list_reorder.sortable_list.get(0)) + '&tree=' + list_reorder.tree + '&authenticity_token=' + encodeURIComponent($j('#reorder_authenticity_token').val()),
                  function(data){
                    $j(list_reorder.sortable_list.get(0)).html(data);
                    list_reorder.reordering_button_enabled = true;
                  });
        }
      });
      */
      $j('#reorder_action').hide();
      $j('#reorder_action_done').show();
    },

    disable_reordering: function(e){
      if(e){
        e.preventDefault();
      }

      if(list_reorder.reordering_button_enabled){
        list_reorder.sortable_list.removeClass('reordering');

        $j(list_reorder.sortable_list).sortable('destroy');

        $j('#reorder_action_done').hide();
        $j('#reorder_action').show();
      }
    }
  }

var image_picker = {
  selected: '',
  thumbnail: '',
  toggle_image_display: false,

  init: function(){
    $j('#remove_picked_image').click(function(e){
      e.preventDefault();
      $j('#current_picked_image').removeClass('brown_border')
                                 .attr('src', '')
                                 .attr('width', '').attr('height','')
                                 .css('width', 'auto').css('height','auto')
                                 .hide();
      $j('#custom_title_field').val('');
      $j('#no_picked_image_selected').show();
      $j(this).hide();
    });

    if(this.toggle_image_display){
      $j('#current_image_toggler').click(function(e){
        $j(this).html(($j(this).html() == 'Show' ? 'Hide' : 'Show'));
        $j("#current_image_container").toggle();
        e.preventDefault();
      });
    }

  },

  changed: function(image){
    var current_img = $j('#current_picked_image');
    $j('#custom_title_field').val(image.id.replace("image_", ""));

    if(this.thumbnail != ''){
      image.src = image.src.replace('_dialog_thumb', this.thumbnail);
    }
    current_img.attr('src', image.src)
    current_img.addClass('brown_border').show();
    $j('#remove_picked_image').show();
    $j('#no_picked_image_selected').hide();
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