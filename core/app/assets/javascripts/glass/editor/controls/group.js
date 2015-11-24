GlassControl.on('link-items-btn', 'init', function(this_control) {
  this_control.element().click(function (e) {
    e.preventDefault();
    var this_module = this_control.module();
    var prev_module = this_module.prev_module();
    var group;

    if (prev_module) {
      if ($(this).hasClass('link')) {
        if (this_module.isaGroup()) {
          group = this_module;
          group.element().prepend( prev_module.element());
        }
        else if (prev_module.isaGroup()) {
          group = prev_module;
          group.element().append(this_module.element());
        }
        else { // Could check here that neither are in a group already.  That would be bad.
          group = this_module.editor().newModule('group', 'after', this_module);
          group.element().prepend(prev_module.element());
          group.element().append( this_module.element());
        }
        group.adjustGroupImages();
        group.resetControl();

        var children = group.subModules();
        $.each(children, function (i, val) {
          val.resetControl();
        });
      }
      else if ($(this).hasClass('unlink')) {
        group = this_module.isaGroup() ? this_module : this_module.getGroup();

        if (group) {
          var children = group.unGroup();
          $.each(children, function (i, val) {
            val.resetControl();
          });
        }
      }
    }
  });
});

GlassControl.on('link-items-btn', 'reset-state', function(this_control) {
  // Change 'link' icon into 'unlink' icon or vice versa
  var $link_btn = this_control.element();
  if (this_control.module().inaGroup() && $link_btn.hasClass('link')) {
    $link_btn.removeClass('link').addClass('unlink');
    $link_btn.find('.icon').removeClass('icon-link').addClass('icon-unlink');
  }
  else if (!this_control.module().inaGroup() && $link_btn.hasClass('unlink')) {
    $link_btn.removeClass('unlink').addClass('link');
    $link_btn.find('.icon').removeClass('icon-unlink').addClass('icon-link');
  }
});

GlassModule.on('*', 'post-init', function(this_module) {
  var siblings = [];
  var $next = this_module.element().next();
  if ($next.length > 0 && this_module.editor().isaModule($next)) {
    siblings.push(this_module.next_module());
  }

  var $prev = this_module.element().prev();
  if ($prev.length > 0 && this_module.editor().isaModule($prev)) {
    siblings.push(this_module.prev_module());
  }

  $.each(siblings, function (i, sibling) {
    if (this_module.isGroupable() && sibling && sibling.isGroupable()) {
      sibling.resetLinkButtons();
    }
  });
});
