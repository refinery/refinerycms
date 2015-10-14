// #############################################################
// # Control - actions on a module (change type, delete...)    #
// #############################################################
function GlassControl($elem) {
  var this_control = this;
  this.c = {'elem': $elem};

  this.attachToModule = function($module) {
    var $element = this.element();
    $element.fadeIn();
    if ($element.hasClass('append')) {
      $element.appendTo($module.element());
    }
    else {
      $element.insertBefore($module.element());
    }

    if ($element.hasClass('click-pads')) {
      var sp_bottom = parseInt($module.element().css("margin-bottom" ).replace("px", ""));
      //sp_bottom    += parseInt($module.element().css("padding-bottom").replace("px", ""));
      if (sp_bottom < 20) {
        sp_bottom = 20;
      }
      $element.find('.click-pad.bottom').css('height',       sp_bottom + 'px');
      $element.find('.click-pad.bottom').css('bottom', '-' + sp_bottom + 'px');

      var sp_top = parseInt($module.element().css("margin-top" ).replace("px", ""));
      //sp_top    += parseInt($module.element().css("padding-top").replace("px", ""));
      if (sp_top < 20) {
        sp_top = 20;
      }
      $element.find('.click-pad.top').css('height',    sp_top + 'px');
      $element.find('.click-pad.top').css('top', '-' + sp_top + 'px');
    }

    this.c.module = $module;
    this.focus();
  }

  this.element = function() {
    return this.c.elem;
  };

  this.module = function() {
    return this.c.module;
  };

  this.detatchFromModule = function() {
    this.element().hide();
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

  this.focus = function() {
    var $autofocus = this.element().find('.glass-autofocus').first();
    if ($autofocus) {
      $autofocus.focus();
    }
  };

  if (this.element().attr('id') == 'glass-module-switcher') {
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

  this.element().find('#glass-choose-module-vid').click(function (e) {
    e.preventDefault();
    this_control.module().editor().attachControl('settings-vid');
  });

  this.element().find('#glass-choose-module-img').click(function (e) {
    e.preventDefault();
    GlassImageUploader.openFileInput();
  });

  if (this.element().attr('id') == 'glass-choose-module') {
    $(document).on('image-preview', function (e, params) {

      var $cur_module = this_control.module();
      if ($cur_module) {
        var $new_module = $cur_module.editor().newModule('glass-module-img', 'after', $cur_module);
        var $image_element = $new_module.element().find('img');

        $image_element.addClass('cur-uploading-img');
        $cur_module.remove();

        var $next_module = $new_module.next_module();
        if (!($next_module && $next_module.isGroupable())) {
          // Add a <p> unless another image directly follows (user may want to link them)
          var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
          // FIXME - this doesn't seem to want to focus()
          // FIXME: $new_p.element().attr('contenteditable', true);
          // FIXME: $new_p.element().focus();
        }

        var $prev_module = $new_module.prev_module();
        if ($prev_module && $prev_module.isGroupable()) {
          $prev_module.resetLinkButtons();
        }
      }
    });
  }

  if (this.element().hasClass('delete-module')) {
    this.element().click(function (e) {
      e.preventDefault();
      this_control.module().element().fadeOut(500, function() {
        this_control.module().remove();
      });
    });
  }

  if (this.element().hasClass('link-items')) {
    this.element().click(function (e) {
      e.preventDefault();
      var $this_module = this_control.module();
      var $next_module = $this_module.next_module();
      var $group;

      if ($next_module) {
        if ($(this).hasClass('link')) {
          if ($this_module.isaGroup()) {
            $group = $this_module;
            $group.element().append( $next_module.element());
          }
          else if ($next_module.isaGroup()) {
            $group = $next_module;
            $group.element().prepend($this_module.element());
          }
          else { // Could check here that neither are in a group already.  That would be bad.
            $group = $this_module.editor().newModule('glass-module-group', 'after', $this_module);
            $group.element().append( $next_module.element());
            $group.element().prepend($this_module.element());
          }
          $group.adjustGroupImages();
          $group.resetControl();

          var $children = $group.subModules();
          $.each($children, function (i, $val) {
            $val.resetControl();
          });
        }
        else if ($(this).hasClass('unlink')) {
          $group = $this_module.isaGroup() ? $this_module : $this_module.getGroup();

          if ($group) {
            var $children = $group.unGroup();
            $.each($children, function (i, $val) {
              $val.resetControl();
            });
          }
        }
      }
    });
  }

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
      var $module   = this_control.module();
      var before = $(this).hasClass('top') || $(this).hasClass('left');
      var before_or_after = before ? 'before'                 : 'after';
      var $sibling_elem   = before ? $module.element().prev() : $module.element().next();
      var $sibling;

      if ($sibling_elem.length == 0 || $sibling_elem.hasClass('glass-no-edit') || $sibling_elem.hasClass('glass-control')) {
        $sibling = $module.editor().newModule('glass-module-p', before_or_after, $module);
        $sibling_elem = $sibling.element();
      }
      else {
        $sibling = $module.editor().parentModule($sibling_elem);
      }

      $sibling.focus();
    });
  }

  this.element().find('#glass-add-vid-form').submit(function (e) {
    e.preventDefault();
    var $cur_module = this_control.module();
    var $new_module = $cur_module.editor().newModule('glass-module-vid', 'after', $cur_module);
    $cur_module.element().remove();
    var $input_elem = this_control.element().find('.url-input');
    var vid_link = $input_elem.val();
    $input_elem.val('');
    $new_module.element().attr('data-video-link', vid_link); // Save for later use if needed (to edit??)
    var embed_url = GlassControl.vidUrlToEmbed(vid_link);
    $new_module.element().find('iframe').attr('src', embed_url);
    var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
  });

  this.element().find('#glass-choose-custom').click(function (e) {
    e.preventDefault();
    var $cur_module = this_control.module();
    var $new_module = $cur_module.editor().newModule('glass-module-custom', 'after', $cur_module);
    $cur_module.element().remove();
    var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
  });
}

GlassControl.key2selector = {
  'link-items-btn': '.glass-control.link-items',
  'module-layout': '.glass-control.module-layout',
};

GlassControl.vidUrlToEmbed = function(vid_link, color) {
  color = typeof color !== 'undefined' ? color : "8d69bf";

  var embed_url = vid_link; // The default, will be changed below
  var matches = vid_link.match(/(vimeo|youtube).com\/(.+)$/);

  if (matches && vid_link.search(/(?:youtube.+embed|player\.vimeo)/) == -1) {
    var vid_host = matches[1];
    var vid_path = matches[2];
    var vid_host_meta = {
      'youtube': ["//www.youtube.com/embed/",  "",                /[\?\&]v=(\w+)/],
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
