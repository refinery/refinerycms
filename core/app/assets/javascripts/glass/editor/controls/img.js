GlassControl.on('choose-module', 'init', function(this_control) {
  var $upload_btn = this_control.element().find('#glass-choose-module-img');
  if ($upload_btn.length > 0) {
    $upload_btn.click(function (e) {
      e.preventDefault();

      var cur_module = this_control.module();
      var new_module = cur_module.editor().newModule('img', 'after', cur_module);
      this_control.attachToModule(new_module);
      cur_module.remove();

      GlassUploader.openFileInput('#img-upload-form', $(this));
      new_module.element().find('.progress').val(0);

      GlassUploader.handleProgressUpdates($upload_btn, new_module.element().find('.progress'));
    });
  }
});

GlassControl.on('choose-module', 'attach', function(this_control) {
  var $upload_btn = this_control.element().find('#glass-choose-module-img');
  var module = this_control.module();  // Its weird, this fails inside the 'on-success' callback
  if ($upload_btn.length > 0) {
    $upload_btn.data('on-success', function(response) {
      module.element().find('.progress').addClass('hidden-xs-up');

      var $img = module.element().find('img');
      $img.attr('src', response.url);
      $img.attr('data-image-id', response.image_id);
      this_control.autoSave(module.element());
      this_control.detatchFromModule();

      var next_module = module.next_module();
      if (!(next_module && next_module.isGroupable())) {
        // Add a <p> unless another image directly follows (user may want to link them)
        var $new_p = module.editor().newModule('p', 'after', module);
        // FIXME - this doesn't seem to want to focus()
        // FIXME: $new_p.element().attr('contenteditable', true);
        // FIXME: $new_p.element().focus();
      }

      var next_module = module.next_module();
      if (next_module && next_module.isGroupable()) {
        next_module.resetLinkButtons();
      }

      module.resetLinkButtons();

      // TODO
      // var $error_div = this_control.element().find(".errorExplanation");
      // if ($error_div.length > 0) {
      //   $error_div.removeClass('active');
      //   $error_div.html('');
      // }
    });

    $upload_btn.data('on-error', function(response_text) {
      // TODO
      // var $error_div = this_control.element().find(".errorExplanation");
      // if ($error_div.length > 0) {
      //   $error_div.html("<p>" + response_text + "</p>")
      //   $error_div.addClass('active');
      // }
    });
  }
});
