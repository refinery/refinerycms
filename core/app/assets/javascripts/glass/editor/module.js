// #############################################################
// # Module - a paragraph, heading, img, video...              #
// #############################################################
function GlassModule($elem, $editor, do_construction) {
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
        GlassScroll.scrollTo(this.m.elem);
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

  this.isGroupable = function() {
    var type = this.module_type();
    return type == 'group' || type == 'img';
  };

  //Could be what is breaking tabbing in mozilla
  this.attachControl = function(key) {
    this.editor().attachControl(key, this);
  };

  this.detatchControl = function(key) {
    this.element().find('[data-glass-id="' + key + '"]').each(function () {
      $(this).glassHtmlControl().detatchFromModule();
      // just this instead??   $(this).remove();
    });
  };

  this.detatchAllControl = function() {
    this.element().children('.glass-control.replace-module').each(function () {
      var $control = $(this).glassHtmlControl();
      $control.bringBackModule();
      $control.detatchFromModule();
    });

    // Big hammer.  I'm not confident in getting the GlassControl from the element yet :(
    this.element().children('.glass-control').remove();
  };

  this.resetControl = function() {
    this.resetClickPads();
    this.resetDeleteBtn();
    this.resetModuleLayoutButtons();
    this.resetLinkButtons();

    if (this.isaGroup()) {
      $.each(this.subModules(), function(i, module) {
        module.resetLinkButtons();
      });
    }
  };

  this.isClickpadable = function() {
    return !(this.inaGroup() || this.element().hasClass('no-click-pads') || GlassModule.modules_without_clickpads[this.glass_id()]);
  };

  this.resetClickPads = function() {
    this.isClickpadable() ? this.attachControl('click-pads') : this.detatchControl('click-pads');
  };

  this.isDeletable = function() {
    return this.element().hasClass('deletable') || GlassModule.deletable_modules[this.glass_id()];
  };

  this.resetDeleteBtn = function() {
    this.isDeletable() ? this.attachControl('delete-btn') : this.detatchControl('delete-btn');
  };

  this.resetModuleLayoutButtons = function() {
    var type = this.module_type();
    var doLayoutButtons = !this.inaGroup() && (type == 'group' || type == 'img' || type == 'vid');
    doLayoutButtons ? this.attachControl('module-layout') : this.detatchControl('module-layout');
  };

  this.resetLinkButtons = function() {
    var doLinkButtons = this.isGroupable() && this.prev_module() && this.prev_module().isGroupable();
    doLinkButtons ? this.attachControl('link-items-btn') : this.detatchControl('link-items-btn');
  };

  this.module_type = function() {
    var module_type = this.element().data('glass-id');

    if (!module_type) {
      if (this.element().hasClass('glass-module-group')) {
        module_type = 'group';
      }
      else if (this.element().hasClass('inline-editable-image-container')) {
        module_type = 'img';
      }
      else if (this.element().hasClass('video-module')) {
        module_type = 'vid';
      }
      else if (this.element().hasClass('custom-html')) {
        module_type = 'custom-html';
      }
      else if (this.element().prop('nodeName') == 'DIV') {
        console.warn("ERROR: div in html content has no glass_id");
        module_type = 'unknown';
      }
      else {
        module_type = 'basic';
      }
    }

    return module_type;
  };

  this.glass_id = function() {
    return this.module_type();
  };

  this.initModule = function($module_html) {
    return $module_html.glassHtmlModule(this_module.editor());
  }

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
    return this.module_type() == 'group';
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
      this.detatchAllControl();
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
    return ['-webkit-box-flex: ', val, '; ',
            '-webkit-flex: ', val, '; ',
            '-ms-flex: ', val, '; ',
            'flex: ', val, ';'].join('');
  };

  this.adjustGroupImages = function () {
    this.element().children().each(function () {
      var w_h_ratio = 386 / 686;
      var $img = $(this).find('img');
      if ($img.length > 0) {
        w_h_ratio = $img.first().width() / $img.first().height();
      }
      $(this).attr('style', flexValueStyles(1.0 * w_h_ratio));
    });
  };


  // Initialization
  // ##########################################
  //this.focus();
  this.debug('Init module "' + this.glass_id() + '"');
  GlassContentEditing.filterPasteEvents(this.m.elem[0]);

  var $this_elem = this.element();
  if ($this_elem.find('img, iframe').length > 0) {
    $this_elem.attr('contenteditable', false); // legacy ones may not have .glass-no-edit
  }

  if (do_construction === undefined || do_construction) {
    this.glassConstructor(GlassModule);
  }

  return this;
}

GlassModuleBase.extend(GlassModule, GlassModuleBase);

GlassModule.deletable_modules = {
  'img':         true,
  'vid':         true,
  'custom-html': true
};

GlassModule.modules_without_clickpads = {
  'basic': true,
};

GlassModule.newModuleHtml = function(glass_id) {
  var $module_html = $('#glass-parking #glass-module-' + glass_id + '-template');
  if ($module_html.length > 0) {
    $module_html = $module_html.first().clone();
    $module_html.removeAttr('id'); //The id only stays on the one in the parking
    $module_html.attr('data-glass-id', glass_id);
  }
  else if (glass_id == 'p') {
    $module_html = $('<p></p>');
  }
  return $module_html;
};
