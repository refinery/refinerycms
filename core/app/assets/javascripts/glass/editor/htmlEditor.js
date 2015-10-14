// #############################################################
// # HTML editor (actually manipulate the html)                #
// #############################################################
function GlassHtmlEditor($elem) {
  var this_editor = this;
  this.h = {'elem': $elem, 'control_stack': []};

  this.element = function() {
    return this.h.elem;
  };

  this.curModule = function() {
    return this.h.cur_module;
  };

  this.isCurModule = function($module) {
    var $cur_module = this_editor.curModule();
    return $cur_module && $cur_module.element()[0] == $module.element()[0];
  };

  this.setCurModule = function($module) {
    if (!this.isCurModule($module)) {
      this.h.cur_module = $module;
      $('.selected-module').removeClass('selected-module');
      $module.element().addClass('selected-module');
      this.removeGlassControl();
    }
  };

  this.focus = function() {
    var this_editor = this;
    $.each(this_editor.modules(), function (i, $module) {
      if (!$module.element().hasClass('glass-no-edit')) {
        this_editor.triggerChangeFocus($module.element(), null);
        $module.focus();
        return false;
      }
    });
  };

  this.attachControl = function(key, $module) {
    $module = (typeof $module === 'undefined') ? this.curModule() : $module;

    var $control;
    switch(key) {
      case 'module-switcher':
        var $switcher = $('#glass-module-switcher');
        if ($switcher.length < 1) {
          $switcher = $('#glass-module-switcher-template').clone().attr('id', 'glass-module-switcher');
        }
        $control = $switcher.glassHtmlControl();
        break;
      case 'choose-module':
        $control = $('#glass-choose-module').glassHtmlControl();
        break;
      case 'settings-vid':
        $control = $('#glass-module-settings-vid').glassHtmlControl();
        break;
      case 'delete-btn':
        $control = $('#glass-parking .delete-module').clone().glassHtmlControl();
        break;
      case 'link-items-btn':
        $control = $('#glass-parking .link-items').clone().glassHtmlControl();
        break;
      case 'click-pads':
        $control = $('#glass-parking .click-pads').clone().glassHtmlControl();
        break;
      case 'module-layout':
        $control = $('#glass-parking .module-layout').clone().glassHtmlControl();
        break;
      default:
        $control = null;
    }

    var stack = this.h.control_stack;

    $control.attachToModule($module);

    if (key == 'choose-module' || key == 'settings-vid') {
      this.curModule().element().hide();
      // We have a stack for modules that replace the content
      if (stack.length > 0) {
        stack[stack.length - 1].element().hide();
      }
      stack.push($control);
    }
  };

  this.closeCurControl = function() {
    var stack = this.h.control_stack;

    if (stack.length > 0) {
      var $control = stack.pop();

      if (stack.length == 0) {
        $control.bringBackModule();
      }
      else {
        stack[stack.length - 1].element().fadeIn();
      }

      $control.detatchFromModule();
    }

    return (stack.length > 0);
  };

  this.removeGlassControl = function() {
    this.h.elem.find('.glass-control.singleton').each(function () {
      var $control = $(this).glassHtmlControl();
      $control.bringBackModule();
      $control.detatchFromModule();
    });
    this.h.control_stack = [];
  };

  function formatElement($elem) {
    $elem.find('*').each(function () {
      formatElement($(this));
    });
    // $(this).attr('style', '');
    $(this).replaceWith('<p>' + $(this).text() + '</p>');
    result = $elem.html();
  }

  function formatHtml(html) {
    var $blob = $('<div>' + html + '</div>');
    return formatElement($blob);
  }

  this.exportHtml = function() {
    var $wrapper = this.h.elem.clone();

    // Remove all editor control modules
    $wrapper.find('.glass-control').remove(); // All the delete btns and stuff

    // Ensure no contenteditable or style overrides get out to front of site
    $wrapper.find('[contenteditable=true]').removeAttr('contenteditable');
    $wrapper.find(':not(.glass-no-edit *)').removeAttr('style');

    // Unwrap <div>'s that accidentally get nested or pasted
    $wrapper.find('div').each(function () {
      if (!$(this).hasClass('glass-no-edit') && $(this).parents('.glass-no-edit').length == 0) {
        $(this).children().unwrap();
      }
    });

    // Ensure all highest level elements are within our set,  make them into <p>'s if not
    $wrapper.children(':not(p, ul, ol, h1, h2, h3, h4, h5, h6, blockquote, .glass-no-edit)').each(function () {
      $('<p></p>').html($(this).html()).insertAfter($(this));
      $(this).remove();
    });

    // Same thing with text nodes, make them into <p>'s (nodeType 3 is text)
    $wrapper.contents().filter(function() { return (this.nodeType === 3 && /\S/.test(this.textContent)); }).wrap("<p></p>");

    // Get rid of unwanted tags that may have been pasted in
    $wrapper.children('p').find('font, span').each(function () {
      $(this).replaceWith(this.childNodes);
    });

    // Remove whitespace and html comments (should be stripped on paste, here to sanitize)
    return $wrapper.html().replace(/<!--[\s\S]*?-->/gm,"").trim();
  };

  this.getCurFocusModule = function() {
    var focus_elem = window.getSelection().focusNode;
    if (!focus_elem) { return null; }
    if (!this.isaModule($(focus_elem)) && $(focus_elem).prop("tagName") != 'P') {
      focus_elem = focus_elem.parentNode;
    }

    return this.parentModule($(focus_elem));
  };

  this.newModule = function(module_id, before_after, $module) {
    var $new_html = $module.newModuleHtml(module_id);
    if (before_after == 'before') {
      $new_html.insertBefore($module.element());
    }
    else {
      $new_html.insertAfter($module.element());
    }
    this.removeGlassControl();                   // Reset state
    var $new_module = this.triggerChangeFocus($new_html, null); // Creates a module & initializes it
    $new_module.focus();
    return $new_module;
  };

  // Get the parent module for an element, the module may be based off the element directly (not a parent)
  this.parentModule = function($elem) {
    var $parent_module = null;
    if ($elem.hasClass('glass-control') ||
        $elem.parents('.glass-control').length > 0 ||
        $elem.parents('.glass-edit-html').length == 0)
    {
      // It is within a control section, is a module group, or is outside of the editor "chunk"
      return null;
    }

    var $parent_elem = $elem;

    if (!$parent_elem.parent().hasClass('glass-edit-html') && !$parent_elem.parent().hasClass('glass-module-group')) {
      $parent_elem = $elem.parents('.glass-module-group > *');
      if ($parent_elem.length < 1) {
        $parent_elem = $elem.parents('.glass-edit-html > *');
      }
    }

    if ($parent_elem) {
      $parent_module = $parent_elem.glassHtmlModule(this);
    }

    return $parent_module;
  };

  this.modules = function() {
    var modules = [];
    this.h.elem.children().each(function () {
      if (!$(this).hasClass('glass-control')) {
        var $module = $(this).glassHtmlModule(this_editor);
        modules.push($module);
        if ($module.isaGroup()) {
          $.each($module.subModules(), function (i, $submodule) {
            modules.push($submodule);
          });
        }
      }
    });
    return modules;
  };

  this.isaModule = function($elem) {
    // TODO: this is broken!
    return $elem.glassIsaModule();
  };

  this.triggerChangeFocus = function ($elem, e) {
    var $module = $elem ? this.parentModule($elem) : this.getCurFocusModule();

    if (!$module) {
      return;
    }

    var newly_empty = false;
    var $cur_elem = $module.element();

    if (!this.isCurModule($module)) {
      this.setCurModule($module);

      if (!$cur_elem.text().trim()) { // Switching to an empty element
        newly_empty = true;
      }
    }

    if (e && (e.which == 8 || e.which == 46 || e.which == 13) && !$cur_elem.text().trim()) { // Just became empty (backspace or enter)
      newly_empty = true;
    }

    if (!$cur_elem.hasClass('glass-no-edit') && newly_empty) {
      $cur_elem.addClass('empty');
      this.attachControl('module-switcher');
    }
    else if ($cur_elem.hasClass('empty') && $cur_elem.text().trim()) { // Not empty (but has the empty class)
      $cur_elem.removeClass('empty');
      this.removeGlassControl();
    }

    if (!$cur_elem.attr('contenteditable')) {
      $cur_elem.attr('contenteditable', true);
    }

    return $module;
  };


  // Initialization
  // ##########################################
  this.h.elem.attr('contenteditable', true);

  // modules() initializes them as well as returns them
  $.each(this.modules(), function (i, $module) {
    this_editor.triggerChangeFocus($module.element(), null);

    $module.resetControl();

    var $prev_module = $module.prev_module();
    if ($prev_module && $prev_module.isGroupable()) {
      $prev_module.resetLinkButtons();
    }
  });

  this.h.elem.mouseup(function(e) {
    this_editor.triggerChangeFocus(null, e);
  });

  this.h.elem.keyup(function(e) {
    this_editor.triggerChangeFocus(null, e);
  });

  $(document).on('new-p', function () {
    this_editor.triggerChangeFocus(null, null);
  });

  $(document).on('image-uploaded', function (e, img_src) {
    var $img = this_editor.h.elem.find('.cur-uploading-img');
    if ($img.length > 0) {
      $img.attr('src', img_src);

      $img.removeClass('cur-uploading-img');
    }
  });

  grande.bind(document.querySelectorAll(".glass-edit-html"));

  // return {
  //   formatHtml: formatHtml
  // };
  return this;
}
