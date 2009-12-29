
$j = jQuery.noConflict();

$j(document).ready(function(){
  init_sortable_menu();
});


function init_sortable_menu(){
  var $menu = $j('#menu');

  if($menu.length == 0){ return }

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