$j = jQuery.noConflict();

$j(document).ready(function(){
  $j('#flash').fadeIn(550);

  init_sortable_menu();
  init_submit_continue();
  init_modal_dialogs();
  init_tooltips();

  // focus first field in an admin form.
  jQuery('form input[type=text]:first').focus();
});

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

  $menu.find('#menu_reorder').click(function(ev){
    ev.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 0.5);
    $menu.find('.tab a').click(function(ev){
      ev.preventDefault();
    });

    $menu.sortable('enable');
  });

  $menu.find('#menu_reorder_done').click(function(ev){
    ev.preventDefault();
    $j('#menu_reorder, #menu_reorder_done').toggle();
    $j('#header >*:not(#menu, script), #content, #logout').fadeTo(500, 1);
    $menu.find('.tab a').unbind('click');

    $menu.sortable('disable');
  });
}

init_submit_continue = function(){
  $j('#submit_continue_button').bind('click', function(e) {
    // ensure wymeditors are up to date.
    if ($j(this).hasClass('wymupdate')) {
      WYMeditor.INSTANCES.each(function(wym)
      {
        wym.update();
      });
    }

    $j('#continue_editing').val(true);
    $j('#flash').fadeOut(250)

    jQuery.post(this.form.action, this.form.serialize(), function(data) {
      if ((flash_container = $('flash_container')) != null) {
        flash_container.update(data);

        $j('#flash').css('width', 'auto').fadeIn(550);

        $j('.errorExplanation').each(function(i, node) {
          if (node.parentNode.id != 'flash_container') {
            node.remove();
          }
        });

        $j('.fieldWithErrors').each(function(i, field) {
          field.removeClassName('fieldWithErrors').addClassName('field');
        });

        $j('#continue_editing').val(false);

        $j('.fieldWithErrors:first :input:first').focus();
      }
    });

    e.preventDefault();
  });
}

init_tooltips = function(){
  $j($j(args != null ? args : 'a[title], #image_grid img[title]')).each(function(index, element)
  {
    new Tooltip(element, {mouseFollow:false, delay: 0, opacity: 1, appearDuration:0, hideDuration: 0, rounded: false});
  });
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
    var selected = radios.filter('.selected_radio')[0] || radios[0];

    radios.each(function(){
      $j(this).click(function(){
        link_dialog.switch_area(this);
      });
    });

    selected.checked = true;
    link_dialog.switch_area(selected);
  },

  init_close: function(){
    $j('#TB_title .close_dialog', '#dialog_container .close_dialog').each(function(){
      $j(this).click(function(ev){
        ev.preventDefault();

        if(parent && typeof(parent.tb_remove) == "function"){
          parent.tb_remove();
        }
        else if(typeof(tb_remove) == 'function'){
          tb_remove();
        }
      });
    });
  },

  switch_area: function(area){
    $j('#dialog_menu_left .selected_radio').each(function(){
      $j(this).removeClass('selected_radio');
    });

    $j(area).parent().addClass('selected_radio');

    $j('#dialog_main .dialog_area').each(function(){
      $j(this).hide();
    });

    $j('#' + area.value + '_area').show();
  },

  //Same for resources tab
  page_tab: function(){
    $j('.link_list li').click(function(ev){
      ev.preventDefault();

      remove_linked_class();
      $j(this).addClass('linked');

      function remove_linked_class(){
        $j('.link_list li.linked').each(function(){
          $j(this).removeClass('linked');
        });
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
    $j('#email_address_text, #email_default_subject_text, #email_default_body_text').each(function(){
      $j(this).change(function(){
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

        link_dialog.update_parent(mailto, mailto.replace('mailto:', ''))
      });
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
    $j('#toggle_advanced_options').click(function(ev){
      ev.preventDefault();
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

    $j('#add_page_part').click(function(ev){
      ev.preventDefault();
      $j('#new_page_part_dialog').dialog('open');
    });

    $j('#new_page_part_save').click(function(ev){
      ev.preventDefault();

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

    $j('#new_page_part_cancel').click(function(ev){
      ev.preventDefault();
      $j('#new_page_part_dialog').dialog('close');
      $j('#new_page_part_title').val('');
    });

    $j('#delete_page_part').click(function(ev){
      ev.preventDefault();
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
    var selected = radios.filter('.selected_radio')[0] || radios[0];

    radios.click(function(){
        image_dialog.switch_area(this);
    });

    selected.checked = true;
    image_dialog.switch_area(selected);
  },

  switch_area: function(area){
    $j('#dialog_menu_left .selected_radio').removeClass('selected_radio');
    $j(area).parent().addClass('selected_radio');
    $j('#dialog_main .dialog_area').hide();
    $j('#' + area.value + '_area').show();
  },

  init_select: function(){
    $j('#existing_image_area_content ul li img').click(function(){
        image_dialog.set_image(this);
    });
    //Select any currently selected, just uploaded...
    $j('#existing_image_area_content ul li.selected img').each(function(){
      image_dialog.set_image(this);
    });
  },

  set_image: function(img){
    $j('#existing_image_area_content ul li.selected').removeClass('selected');

    $j(img).parent().addClass('selected');
    var imageUrl = parseURL(img.src);
    var relevant_src = imageUrl.pathname.replace('_dialog_thumb', '');

    if(imageUrl.hostname.match(/s3.amazonaws.com/)){
      relevant_src = imageUrl.protocol + '//' + imageUrl.host + relevant_src;
    }

    try {
      parent.document.getElementById('wym_src').value = relevant_src;
      parent.document.getElementById('wym_title').value = img.title;
      parent.document.getElementById('wym_alt').value = img.alt;
    }
    catch(e){}
  },

  init_submit: function(){
    $j('#dialog-form-actions #submit_button').click(function(ev){
      ev.preventDefault();
      var img_selected = $j('#existing_image_area_content ul li.selected img').get(0);

      if(img_selected){
        parent.image_picker.changed(img_selected);
      }

      self.parent.tb_remove();
    });

    $j('#dialog-form-actions #cancel_button').click(function(ev){
      ev.preventDefault();
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

    enable_reordering: function(ev){
      if(ev){
        ev.preventDefault();
      }

      var nest_id = 0;
      list_reorder.sortable_list.addClass('reordering');
      list_reorder.sortable_list.find('ul.nested').each(function(){
        this.id = this.id.length > 0 ? this.id : "nested_" + nest_id++;
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

      $j('#reorder_action').hide();
      $j('#reorder_action_done').show();
    },

    disable_reordering: function(ev){
      if(ev){
        ev.preventDefault();
      }

      if(list_reorder.reordering_button_enabled){
        list_reorder.sortable_list.removeClass('reordering');

        Sortable.destroy(list_reorder.sortable_list.get(0));

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
    $j('#remove_picked_image').click(function(ev){
      ev.preventDefault();
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