// #############################################################
// # Module - a paragraph, heading, img, video...              #
// #############################################################
function GlassModule($elem, $editor) {
  var this_module = this;
  this.m = {'elem': $elem, 'editor': $editor};

  this.focus = function() {
    if (this.m.elem.prop("tagName") == 'P') {
      //this.m.elem.focus();
      window.getSelection().removeAllRanges();
      var range = document.createRange();
      range.setStart(this.m.elem[0], 0);
      range.setEnd(this.m.elem[0], 0);
      window.getSelection().addRange(range);

      var elemPos = this.m.elem.offset().top + parseInt(this.m.elem.height() / 2);
      if (elemPos < $(window).scrollTop() || elemPos > $(window).scrollTop() + $(window).height()) {
        scrollTo(this.m.elem);
      }
    }
    //this.m.editor.setCurModule(this);
  };

  this.element = function() {
    return this.m.elem;
  };

  this.remove = function() {
    this.m.editor.removeGlassControl();
    this.m.elem.remove();
  };

  this.editor = function() {
    return this.m.editor;
  };

  this.newModuleHtml = function(module_id) {
    var $module_html = $('#glass-parking #' + module_id + '-template');
    if ($module_html.length > 0) {
      $module_html = $module_html.first().clone();
      $module_html.removeAttr('id'); //The id only stays on the one in the parking
    }
    else if (module_id == 'glass-module-p') {
      $module_html = $('<p><br></p>');
    }
    return $module_html;
  };

  this.isGroupable = function() {
    var type = this.module_type();
    return type == 'module-group' || type == 'img-module';
  };

  this.isWidenable = function() {
    var type = this.module_type();
    return !this.inaGroup() && (type == 'module-group' || type == 'img-module' || type == 'vid-module');
  };

  this.attachControl = function(key) {
    var key2selector = {
      'link-items-btn': '.glass-control.link-items',
      'module-layout': '.glass-control.module-layout',
    };

    if ((key in key2selector) && this.element().children(key2selector[key]).length > 0) {
      return null;
    }

    this.editor().attachControl(key, this);
  };

  this.resetModuleLayoutButtons = function() {
    if (this.isWidenable()) {
      this.attachControl('module-layout');
    }
    else {
      // TODO: is there a better way to detachControl?
      this.element().children('.glass-control.module-layout').remove();
    }
  };

  this.resetLinkButtons = function() {
    this.resetModuleLayoutButtons();

    if (this.isGroupable() && this.next_module() && this.next_module().isGroupable()) {
      this.attachControl('link-items-btn');
    }
    else {
      // TODO: is there a better way to detachControl?
      this.element().children('.glass-control.link-items').remove();
    }

    if (this.isaGroup()) {
      $.each(this.subModules(), function(i, $val) {
        $val.resetLinkButtons();
      });
    }
    else {
      var $link_btn = this.element().find('.glass-control.link-items');
      if ($link_btn.length == 1) {
        if (this.inaGroup() && $link_btn.hasClass('link')) {
          $link_btn.removeClass('link').addClass('unlink');
          $link_btn.find('.gcicon').removeClass('gcicon-link').addClass('gcicon-unlink');
        }
        else if (!this.inaGroup() && $link_btn.hasClass('unlink')) {
          $link_btn.removeClass('unlink').addClass('link');
          $link_btn.find('.gcicon').removeClass('gcicon-unlink').addClass('gcicon-link');
        }
      }
    }
  };

  this.module_type = function() {
    var module_type = 'unknown';
    if (this.element().hasClass('glass-module-group')) {
      module_type = 'module-group';
    }
    else if (this.element().hasClass('inline-editable-image-container')) {
      module_type = 'img-module';
    }
    else if (this.element().hasClass('video-wrapper')) {
      module_type = 'vid-module';
    }
    return module_type;
  };

  this.sibling_module = function(direction) {
    var $sibling = this.element();
    var i = 0;

    do {
      $sibling = direction > 0 ? $sibling.next() : $sibling.prev();
    } while (i++ < 5 && !this.editor().isaModule($sibling));

    return this.editor().parentModule($sibling);
  };

  this.prev_module = function() {
    return this.sibling_module(-1);
  };

  this.next_module = function() {
    return this.sibling_module(1);
  };

  this.isaGroup = function() {
    return this.module_type() == 'module-group';
  };

  this.subModules = function() {
    var children = [];
    this.element().children().each(function () {
      var $module = this_module.editor().parentModule($(this));
      if ($module) {
        children.push($module);
      }
    });
    return children;
  };

  this.unGroup = function() {
    var children = [];
    if (this.isaGroup()) {
      children = this.subModules();
      this.element().children().unwrap();
    }
    return children;
  };

  this.inaGroup = function() {
    return this.element().parents('.glass-module-group').length > 0;
  };

  this.getGroup = function() {
    var $parent_module;
    $parent_module = this.editor().parentModule(this.element().parent());
    return ($parent_module && $parent_module.isaGroup()) ? $parent_module : null;
  };

  var flexValueStyles = function(val) {
    return ['-webkit-box-flex: ', val, ';',
            '-webkit-flex: ', val, ';',
            '-ms-flex: ', val, ';',
            'flex: ', val, ';'].join('');
  };

  this.adjustGroupImages = function () {
    this.element().children().each(function () {
      var $img = $(this).find('img').first();
      $(this).attr('style', flexValueStyles(1.0 * $img.width() / $img.height()));
    });
  };


  // Initialization
  // ##########################################
  //this.focus();

  GlassContentEditing.filterPasteEvents(this.m.elem[0]);

  if (this.element().find('img, iframe').length > 0 || this.element().hasClass('glass-no-edit')) {
    this.element().attr('contenteditable', false);
    if (!this.isaGroup()) {
      this.attachControl('delete-btn');
    }
    this.attachControl('click-pads');
  }

  var $prev_module = this.prev_module();
  if ($prev_module && $prev_module.isGroupable()) {
    $prev_module.resetLinkButtons();
  }
  this.resetLinkButtons();
}
