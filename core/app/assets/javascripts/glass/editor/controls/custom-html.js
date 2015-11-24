GlassControl.on('custom-html-form', 'init', function(this_control) {
  this_control.element().find('form').submit(function (e) {
    e.preventDefault();

    var $new_module_elem = GlassModule.newModuleHtml('custom-html');
    $new_module_elem.html(this_control.element().find('.html-input').val()); // before module init, or this will overwrite control html too
    var cur_module = this_control.module();
    $new_module_elem.insertBefore(cur_module.element());
    var new_module = this_control.initModule($new_module_elem);
    new_module.resetControl(); // this makes the delete btn appear - vid isn't having this issue though!
    this_control.detatchFromModule();
    cur_module.remove();
    this_control.autoSave(new_module.element());
  });
});

GlassControl.on('custom-html-form', 'attach', function(this_control) {
  var $html_input = this_control.element().find('.html-input');

  if (this_control.module().glass_id() == 'custom-html') {
    var $elem = this_control.module().element();
    $elem.find('.glass-control').remove();
    $html_input.val($elem.html());
  }
  else {
    $html_input.val('');
  }

  this_control.module().element().hide();
});


GlassModule.on('custom-html', 'init', function(this_module) {
  // console.log("FIXME: init custom html");
  this_module.attachControl('custom-html-edit-btn');
});

GlassControl.on('custom-html-edit-btn', 'init', function(this_control) {
  // console.log("FIXME: init edit btn");
  this_control.element().click(function (e) {
    this_control.module().attachControl('custom-html-form');
  });
});
