GlassModule.on('*', 'init', function(this_module) {
  var links_within = [];
  var $this_elem = this_module.element();

  if ($this_elem.hasClass('glass-no-edit')) {
    $this_elem.find('.glass-editable').each(function () {
      $(this).attr('contenteditable', true);
      links_within.push($(this));
    });
  }
  else if ($this_elem.is('a')) {
    $this_elem.attr('contenteditable', false);
    $this_elem.click(function (e) {
      e.preventDefault();
      this_module.attachControl('link-editor');
    });
  }
  else {
    links_within.push($this_elem);
  }

  setTimeout(function(){
    $.each(links_within, function (i, $elem) {
      if ($elem.is('a')) {
        $elem.glassHtmlModule(this_module.editor());
      }
      else {
        $elem.find('a').each(function () {
          $(this).glassHtmlModule(this_module.editor());
        });
      }
    });
  }, 400);
});

GlassControl.on('link-editor', 'pre-init', function(this_control) {
  this_control.delete_link = function () {
    var text = this_control.element().find('input#link-text').val();
    this_control.module().element().before(text);
    this_control.module().remove();
  };
});

GlassControl.on('link-editor', 'init', function(this_control) {
  var $link_editor = this_control.element();

  $link_editor.find('form').submit(function (e) {
    e.preventDefault();

    var url         = this_control.element().find('input#url').val();
    var text        = this_control.element().find('input#link-text').val();
    var extern      = GlassControl.isExternalUrl(url);
    var resource_id = this_control.element().find('input#resource-id').val();
    var $link       = this_control.module().element();

    if (!url || !text) {
      this_control.delete_link();
    }
    else {
      if (!$link.is('a')) { console.log("ERROR: link form was attached to something other than an link"); return; }
      if (url.search("@") > 0 && url.search("mailto") == -1) {
        url = "mailto:" + url;
      }
      $link.attr('href', url);
      $link.html(text);
      $link.attr('contenteditable', false);
      resource_id ? $link.attr('data-resource-id', resource_id) : $link.removeAttr('data-resource-id');
      extern      ? $link.attr('target', '_blank')              : $link.removeAttr('target');
    }

    this_control.autoSave(this_control.element());
    this_control.detatchFromModule();
  });

  $link_editor.find('.close, .delete').click(function (e) {
    e.preventDefault();
    if ($(this).hasClass('delete') || !this_control.module().element().attr('href')) {
      this_control.delete_link();
    }
    this_control.autoSave(this_control.element());
    this_control.detatchFromModule();
  });

  $link_editor.find('input#url').change(function (e) {
    this_control.element().find('input#is-external').prop('checked', GlassControl.isExternalUrl($(this).val()));

    var simplified_url = GlassControl.simplifyUrl($(this).val());
    if (simplified_url) {
      this_control.element().find('input#url').val(simplified_url);
    }
  });

  var $upload_btn = $link_editor.find('#resource-upload-btn');
  $upload_btn.click(function (e) {
    e.preventDefault();
    var $form = $('#resource-upload-form');
    $form.data('triggerer', $(this));
    $form.find('input[type="file"]').click();
    $link_editor.find(".progress").val(0);
  });

  $upload_btn.data('on-progress', function(eventFired, position, total, percentComplete) {
    var $progress_bar = $link_editor.find(".progress");
    $progress_bar.removeClass('hidden-xs-up');
    $progress_bar.val(percentComplete);
    if (percentComplete >= 100) {
      $progress_bar.addClass('progress-striped');
    }
  });

  $upload_btn.data('on-success', function(response) {
    $link_editor.find(".progress").addClass('hidden-xs-up');
    $link_editor.find('input#url').val(response.url);
    $link_editor.find('input#resource-id').val(response.resource_id);
    $link_editor.find('input#is-external').prop('checked', false);

    var $error_div = $link_editor.find(".errorExplanation");
    if ($error_div.length > 0) {
      $error_div.removeClass('active');
      $error_div.html('');
    }
  });

  $upload_btn.data('on-error', function(response_text) {
    var $error_div = $link_editor.find(".errorExplanation");
    if ($error_div.length > 0) {
      $error_div.html("<p>" + response_text + "</p>")
      $error_div.addClass('active');
    }
  });
});

GlassControl.on('link-editor', 'attach', function(this_control) {
  var module = this_control.module();
  this_control.element().find('input#url').val( module.element().attr('href'));
  this_control.element().find('input#link-text').val(module.element().html());
  var extern = module.element().attr('target') == '_blank';
  this_control.element().find('input#is-external').prop('checked', extern);
});
