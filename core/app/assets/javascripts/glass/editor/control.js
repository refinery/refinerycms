// #############################################################
// # Control - actions on a module (change type, delete...)    #
// #############################################################
function GlassControl($elem) {
  var this_control = this;
  this.c = {'elem': $elem};

  this.attachToModule = function(module) {
    var $direct_controls = module.element().children('.glass-control');
    var $this_type = $direct_controls.add($direct_controls.children('.glass-control')).filter('[data-glass-id="' + this.glass_id() + '"]');
    if ($this_type.length > 0) { // already have a control of this type
      GlassControl.call_cbs(this.glass_id(), 'reset-state', [$this_type.first().glassHtmlControl()]);
      return;
    }

    var $element = this.element();
    $element.fadeIn();
    if (this.glass_id() == 'module-switcher') {
      $element.insertBefore(module.element());
    }
    else if ($element.hasClass('append')) {
      $element.appendTo(module.element());
    }
    else if ($element.hasClass('after-module') || $element.hasClass('replace-module')) {
      // replace is mainly handled by the editor, it keeps a stack
      $element.insertAfter(module.element());
    }

    this.c.module = module;

    GlassControl.call_cbs(this.glass_id(), 'attach', [this]);

    this.focus();
  }

  this.element = function() {
    return this.c.elem;
  };

  this.module = function() {
    return this.c.module;
  };

  this.editor = function() {
    return this.module() ? this.module().editor() : null;
  };

  this.glass_id = function() {
    var glass_id = this.element().data('glass-id');
    var html_id = this.element().attr('id');
    if (!glass_id && !html_id) { console.warn("ERROR: GlassControl element has no data-glass-id or html id"); html_id = 'unknown'; }
    return glass_id ? glass_id : html_id.replace('glass-module-', '');
  };

  this.detatchFromModule = function() {
    if (this.module()) {
      this.module().debug('Detaching ' + this.glass_id());
    }

    this.c.module = null;
    if (this.element().hasClass('singleton')) {
      this.element().appendTo('#glass-parking');
      this.element().removeClass('glass-close rotate-45');
    }
    else {
      this.element().remove();
    }
  };

  this.bringBackModule = function() {
    if (this.module()) {
      this.module().element().fadeIn();
    }
  };

  this.initModule = function($module_html) {
    return $module_html.glassHtmlModule(this_control.module().editor());
  }

  this.focus = function() {
    var $autofocus = this.element().find('.glass-autofocus').first();
    if ($autofocus) {
      $autofocus.focus();
    }
  };

  if (this.element().attr('id') == 'glass-module-module-switcher') {
    this.element().click(function (e) {
      e.preventDefault();
      var editor = this_control.module().editor();

      if ($(this).hasClass('glass-close')) {
        if (!editor.closeCurControl()) {
          $(this).removeClass('glass-close rotate-45');
        }
      }
      else {
        $(this).addClass('glass-close rotate-45');
        editor.attachControl('choose-module');
      }
    });
  }

  this.element().find('[data-insert-module-template]').click(function (e) {
    e.preventDefault();
    var $new_module = this_control.replaceModule($(this).data('insert-module-template'));
    this_control.autoSave($new_module.element());
  });

  this.element().find('[data-choose-control]').click(function (e) {
    e.preventDefault();
    this_control.module().editor().attachControl($(this).data('choose-control'));
  });

  if (this.element().hasClass('module-layout')) {
    this.element().find('button').click(function (e) {
      var $elem = this_control.module().element();
      $elem.removeClass("inline-module-lg inline-module-fw inline-module-md");
      $elem.addClass($(this).data('layout-class'));
    });
  }

  var selectedText;

  if (this.element().hasClass('click-pads')) {
    this.element().find('.click-pad').click(function (e) {
      var module   = this_control.module();
      var before = $(this).hasClass('top') || $(this).hasClass('left');
      var before_or_after = before ? 'before'                 : 'after';
      var $sibling_elem   = before ? module.element().prev() : module.element().next();
      var $sibling;

      if ($sibling_elem.length == 0 || $sibling_elem.hasClass('glass-no-edit') || $sibling_elem.hasClass('glass-control')) {
        $sibling = module.editor().newModule('p', before_or_after, module);
        $sibling_elem = $sibling.element();
      }
      else {
        $sibling = module.editor().parentModule($sibling_elem);
      }

      $sibling.focus();
    });
  }

  this.replaceModule = function(module_key) {
    var $cur_module = this_control.module();
    var $new_module = $cur_module.editor().newModule(module_key, 'after', $cur_module);
    $cur_module.remove();
    var $new_p = $new_module.editor().newModule('p', 'after', $new_module);
    return $new_module;
  };

  this.autoSave = function($elem) {
    CanvasForms.triggerAutoSave(GlassContentEditing.getFormForElement($elem), $elem);
  }

  this.element().find('#glass-add-vid-form').submit(function (e) {
    e.preventDefault();
    var $new_module = this_control.replaceModule('vid');
    var $input_elem = this_control.element().find('.url-input');
    var vid_link = $input_elem.val();
    $input_elem.val('');
    $new_module.element().attr('data-video-link', vid_link); // Save for later use if needed (to edit??)
    var embed_url = GlassControl.vidUrlToEmbed(vid_link);
    $new_module.element().find('iframe').attr('src', embed_url);
    this_control.autoSave($new_module.element());
  });

  this.glassConstructor(GlassControl);
};

GlassModuleBase.extend(GlassControl,  GlassModuleBase);

GlassControl.key2selector = {
  'link-items-btn': '.glass-control.link-items',
  'module-layout': '.glass-control.module-layout',
};

GlassControl.newControl = function(glass_id) {
  var html_id = 'glass-module-' + glass_id;
  var $elem = $('#' + html_id);
  var $tmpl = $('#glass-parking #' + html_id + '-template');
  if ($elem.length == 0 && $tmpl.length > 0) {
    $elem = $tmpl.clone();
    $elem.hasClass('singleton') ? $elem.attr('id', html_id) : $elem.removeAttr('id');
    $elem.attr('data-glass-id', glass_id);
  }
  $control = $elem.length > 0 ? $elem.first().glassHtmlControl() : null;

  return $elem.length > 0 ? $elem.glassHtmlControl() : null;
}

GlassControl.vidUrlToEmbed = function(vid_link, color) {
  color = typeof color !== 'undefined' ? color : "8d69bf";

  var embed_url = vid_link; // The default, will be changed below
  var matches = vid_link.match(/(vimeo|youtube).com\/(.+)$/);

  if (matches && vid_link.search(/(?:youtube.+embed|player\.vimeo)/) == -1) {
    var vid_host = matches[1];
    var vid_path = matches[2];
    var vid_host_meta = {
      'youtube': ["//www.youtube.com/embed/",  "",                /[\?\&]v=([a-zA-Z0-9_-]{8,14})/],
      'vimeo'  : ["//player.vimeo.com/video/", "?color=" + color, /^(\w+)/],
    };
    var matches2 = vid_path.match(vid_host_meta[vid_host][2]);
    if (matches2) {
      embed_url = vid_host_meta[vid_host][0] + matches2[1] + vid_host_meta[vid_host][1];
    }
  }
  else if (vid_link.search(/^\/\//) == -1) {
    embed_url = "//" + vid_link.replace(/^https?:\/\//, '');
  }

  return embed_url;
};

function urlDomainAndPath(url) {
  return /https?:\/\/([^\/]+)(\/.+)$/.exec(url);
}

function externalDomain(url) {
  var match = urlDomainAndPath(url);
  return !(match && match[1] && match[1] == window.location.hostname);
}

GlassControl.isExternalUrl = function(url) {
  var single_slash = (url.charAt(0) == '/' && url.charAt(1) != '/');
  return !single_slash && externalDomain(url);
};

GlassControl.simplifyUrl = function(url) {
  var match = urlDomainAndPath(url);

  // if url has same domain as current, just simplify to insert the path
  return (match && match[2] && !externalDomain(url)) ? match[2] : null;
};
