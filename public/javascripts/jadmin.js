
$j = jQuery.noConflict();

$j(document).ready(function(){
  //init_sortable_menu();
});


function init_sortable_menu(){
  var $menu = $j('#menu');

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