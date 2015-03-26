/**
 * Created by jkrump on 14/01/15.
 */
var GlassContentEditing = (function ($) {

  var needToConfirm = false;

  $(document).on('content-ready', function (e, element) {
    var $pagePreview = $(element).find('#page-preview');
    if($pagePreview.length > 0){
      needToConfirm = true;

      window.onbeforeunload = checkAbilityToLeave;

      $(document).on('allow-page-unload', function(e, params){

        setNeedToConfirm(params.value);
      });

      removeShareThisClasses();
    }
  });

  $.fn.extend({
    // A classChunk is an editable block that will be saved to the DB
    glassChunk: function () {
      var chunk = this.data('glass-chunk');
      if (!chunk) {
        chunk = new GlassChunk(this);
        this.data('glass-chunk', chunk);
      }
      return chunk;
    },
    // A glassHtmlEditor is a block of editable html (with modules)
    glassHtmlEditor: function () {
      var html = this.data('glass-html');
      if (!html) {
        html = new GlassHtmlEditor(this);
        this.data('glass-html', html);
      }
      return html;
    },
    // A glassModule is a piece within a glassHtmlEditor block
    glassHtmlModule: function ($glass_html_editor) {
      var module = this.data('glass-module');
      if (!module) {
        module = new GlassModule(this, $glass_html_editor);
        this.data('glass-module', module);
      }
      return module;
    },
    glassIsaModule: function () {
      return this.data('glass-module') ? true : false;
    },
    // A glassControl is an action (or set of actions) to be made on a module
    glassHtmlControl: function () {
      var control = this.data('glass-control');
      if (!control) {
        control = new GlassControl(this);
        this.data('glass-control', control);
      }
      return control;
    }
  });

  /**
   * Returns message to display
   * @returns {string}
   */
  function checkAbilityToLeave(){
    if (needToConfirm) {
      return 'You are currently editing site content. Any changes you\'ve made will be lost if you leave this page now. Use the "Publish / Save" menu to save first.';
    }
  }

  /**
   *
   * @param {boolean} value
   */
  function setNeedToConfirm(value){
    needToConfirm = value;
  }

  // JQuery seems to get in the way here.. need to add event to raw DOM element
  function filterPasteEvents(element) {
    element.addEventListener("paste", function (e) {
      e.preventDefault();

      if (e && e.clipboardData && e.clipboardData.getData) {
        var text = e.clipboardData.getData("text/plain").replace(/<!--[\s\S]*?-->/gm,"");
        document.execCommand("insertHTML", false, text);
      }
      else {
        alert("Sorry, you will need a different browser in order to paste content"); // FIXME
      }
    });
  }

  function removeShareThisClasses(){
    var buttonClasses = ['addthis_button_facebook', 'addthis_button_twitter', 'addthis_button_google_plusone_share', 'addthis_button_email'];
    var $element;

    for(var i in buttonClasses){
      $element = $('#page-preview').find('.'+ buttonClasses[i]);
      if($element.length > 0){
        $element.removeClass(buttonClasses[i]);
      }
    }
  }

  // #############################################################
  // # Save & Retrieve to DB (via hidden form)                   #
  // #############################################################

  function GlassChunk($elem) {
    this.ch = {'elem': $elem};

    // Return the glass editing options (default is 'text', like a fancy <input type="text">)
    this.options = function() {
      if (!this.ch.options) {
        var opt_str = this.ch.elem.attr('data-glass-options');
        this.ch.options = $.extend({'type': 'text'}, opt_str ? JSON.parse(opt_str) : {});
      }
      return this.ch.options;
    };

    this.option = function(key) {
      return (key in this.options()) ? this.options()[key] : null;
    };

    this.getFormElement = function() {
      if (!this.ch.form_elem) {
        this.ch.form_elem = this.option('form_id') ? $('#' + this.option('form_id')) : null;
      }
      if (!this.ch.form_elem || this.ch.form_elem.length < 1) {
        this.ch.form_elem = null;
        console.log("WARNING: editable field couldn't find form element: #" + this.option('form_id'));
        console.log("WARNING: suggestion, you might need to add page parts to config/initializers/refinery/pages.rb");
      }
      return this.ch.form_elem;
    };

    this.getForm = function() {
      var $form_elem = this.getFormElement();
      return $form_elem ? $form_elem.parents('form') : null;
    };

    this.setFormValFromHtml = function() {
      var $form_elem = this.getFormElement();
      if ($form_elem) {
        if (this.option('type') == 'text') {
          $form_elem.val(this.ch.elem.text());
        }
        else if (this.option('type') == 'html') {
          $form_elem.val(this.ch.editor.formatHtml());
        }
      }
    };

    this.element = function() {
      return this.ch.elem;
    };

    this.syncContentChanges = function() {
      var this_chunk = this;
      var form_id    = this_chunk.option('form_id');
      var slugify    = this_chunk.option('slugify');
      var slugify_if = this_chunk.option('slugify_if');

      if (form_id) {
        // Syncronize all elements with this form_id (e.g. title on the page and sidebar)
        this_chunk.element().keyup(function (e) {
          $(document).trigger('content-changed/' + form_id, [this_chunk.element()]);
        });
        $(document).on('content-changed/' + form_id, function (e, $element) {
          if ($element != this_chunk.element()) {
            this_chunk.element().html($element.html());
          }
        });
      }

      if (slugify) {
        var $slugify_if = slugify_if ? $("#" + slugify_if) : null;

        // Update a based on a different field (slugify that other field)
        $(document).on('content-changed/' + slugify, function (e, $element) {
          if ($slugify_if.length > 0 && $slugify_if.is(':checked') && $element != this_chunk.element()) {
            this_chunk.element().html($element.text().trim().toLowerCase().replace(/[^\w ]+/g,'').replace(/ +/g,'-'));
          }

          if ($slugify_if.length > 0) {
            this_chunk.element().keyup(function (e) {
              $slugify_if.prop("checked", false);
            });
          }
        });
      }
    };

    this.makeEditable = function() {
      if (this.option('type') == 'text') {
        this.ch.elem.attr('contenteditable', true);
        filterPasteEvents(this.ch.elem[0]);
        this.syncContentChanges();
      }
      else if (this.option('type') == 'html') {
        this.ch.editor = this.ch.elem.glassHtmlEditor();
      }
    };

    this.focus = function() {
      if (this.option('type') == 'text') {
        this.ch.elem.focus();
      }
      else if (this.option('type') == 'html') {
        this.ch.editor.focus();
      }
    };

    this.tabTo = function(next_chunk) {
      var ch_type = this.option('type');
      this.ch.elem.keydown(function(e) {
        if ((e && e.which == 9) || (ch_type == 'text' && e && e.which == 13)) { // TAB or ENTER key - go to next editable
          e.preventDefault();
          next_chunk.focus();
          return false;
        }
      });
    };
  }

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
        case 'click-pads':
          $control = $('#glass-parking .click-pads').clone().glassHtmlControl();
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

    this.formatHtml = function() {
      // Remove all editor control modules
      this.removeGlassControl();
      this.h.elem.find('.glass-control').remove(); // All the delete btns and stuff

      // Ensure no contenteditable or style overrides get out to front of site
      this.h.elem.find('[contenteditable=true]').removeAttr('contenteditable');
      this.h.elem.find().removeAttr('style');

      // Sometimes <br>'s or <div>'s or <span>'s get in somehow.  Remove them cleanly
      this.h.elem.find('div').not('.glass-no-edit').children().unwrap();
      this.h.elem.children(':not(p, ul, ol, h1, h2, h3, h4, h5, h6, .glass-no-edit)').each(function () {
        $('<p></p>').html($(this).html()).insertAfter($(this));
        $(this).remove();
      });

      // Sometimes text goes directly in the div.  Wrap it in a <p>. (nodeType 3 is text)
      this.h.elem.contents().filter(function() { return (this.nodeType === 3 && /\S/.test(this.textContent)); }).wrap("<p></p>");

      // Remove whitespace and html comments (should be stripped on paste, here to sanitize)
      return this.h.elem.html().replace(/<!--[\s\S]*?-->/gm,"").trim();
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

    this.parentModule = function($elem) {
      var $parent_module = null;
      if ($elem.hasClass('glass-control') || $elem.parents('.glass-control').length > 0 || $elem.parents('.glass-edit-html').length == 0) {
        // It is within a control section, or is outside of the editor "chunk"
        return null;
      }

      var $parent_elem = $elem.parent().hasClass('glass-edit-html') ? $elem : $elem.parents('.glass-edit-html > *');

      if ($parent_elem) {
        $parent_module = $parent_elem.glassHtmlModule(this);
      }

      return $parent_module;
    };

    this.modules = function() {
      var modules = [];
      this.h.elem.children().each(function () {
        //if ($(this).parents('.glass-no-edit').length == 0) {
        if (!$(this).hasClass('glass-control')) {
          modules.push($(this).glassHtmlModule(this_editor));
        }
      });
      return modules;
    };

    this.isaModule = function($elem) {
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

      if (newly_empty) {
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
  }

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
        $module_html = $module_html.clone();
        $module_html.removeAttr('id'); //The id only stays on the one in the parking
      }
      else if (module_id == 'glass-module-p') {
        $module_html = $('<p><br></p>');
      }
      return $module_html;
    };

    // Initialization
    // ##########################################
    //this.focus();

    filterPasteEvents(this.m.elem[0]);

    if (this.element().find('img, iframe').length > 0 || this.element().hasClass('glass-no-edit')) {
      this.element().attr('contenteditable', false);
      this.editor().attachControl('delete-btn', this);
      this.editor().attachControl('click-pads', this);
    }
  }

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
          var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
          // FIXME - this doesn't seem to want to focus()
          // FIXME: $new_p.element().attr('contenteditable', true);
          // FIXME: $new_p.element().focus();
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
      var embed_url = vid_link; // The default, will be changed below
      $new_module.element().attr('data-video-link', vid_link); // Save for later use if needed (to edit??)
      var matches = vid_link.match(/(vimeo|youtube).com\/(.+)$/);

      if (matches && vid_link.search(/(?:youtube.+embed|player\.vimeo)/) == -1) {
        var vid_host = matches[1];
        var vid_path = matches[2];
        var vid_host_meta = {
          'youtube': ["//www.youtube.com/embed/",  "",              /[\?\&]v=(\w+)/],
          'vimeo'  : ["//player.vimeo.com/video/", "?color=8d69bf", /^(\w+)/],
        };
        var matches2 = vid_path.match(vid_host_meta[vid_host][2]);
        if (matches2) {
          embed_url = vid_host_meta[vid_host][0] + matches2[1] + vid_host_meta[vid_host][1];
        }
      }
      else if (vid_link.search(/^\/\//) == -1) {
        embed_url = "//" + vid_link.replace(/^https?:\/\//, '');
      }

      $new_module.element().find('iframe').attr('src', embed_url);
      var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
    });

    this.element().find('#glass-add-vid-btn').click(function (e) {
      // Insert
      var $vid_module = $('#glass-parking #glass-module-vid-template').clone();
      $vid_module.removeAttr('id'); //The id only stays on the one in the parking

      // Update link
      var vid_link = $('#glass-vid-url-input').val();
      $('#glass-vid-url-input').val('');

      var embed_url = vid_link; // The default, will be changed below
      $vid_module.attr('data-video-link', vid_link); // Save for later use if needed (to edit??)
      var matches = vid_link.match(/(vimeo|youtube).com\/(.+)$/);

      if (matches && vid_link.search(/(?:youtube.+embed|player\.vimeo)/) == -1) {
        var vid_host = matches[1];
        var vid_path = matches[2];
        var vid_host_meta = {
          'youtube': ["//www.youtube.com/embed/",  "",              /[\?\&]v=(\w+)/],
          'vimeo'  : ["//player.vimeo.com/video/", "?color=8d69bf", /^(\w+)/],
        };
        var matches2 = vid_path.match(vid_host_meta[vid_host][2]);
        if (matches2) {
          embed_url = vid_host_meta[vid_host][0] + matches2[1] + vid_host_meta[vid_host][1];
        }
      }
      else if (vid_link.search(/^\/\//) == -1) {
        embed_url = "//" + vid_link.replace(/^https?:\/\//, '');
      }

      $vid_module.find('iframe').attr('src', embed_url);

      this_control.module().element().replaceWith($vid_module);
      this_control.module().editor().removeGlassControl();
    });

    this.element().find('#glass-choose-custom').click(function (e) {
      e.preventDefault();
      var $cur_module = this_control.module();
      var $new_module = $cur_module.editor().newModule('glass-module-custom', 'after', $cur_module);
      $cur_module.element().remove();
      var $new_p = $new_module.editor().newModule('glass-module-p', 'after', $new_module);
    });
  }

  $(document).on('content-ready', function (e, element) {
    var $container = $(element).find('#page-preview').length > 0 ? $(element).find('#page-preview') : $(element);

    if ($container.attr('id') != 'page-preview' && $container.parents('#page-preview').length < 1) {
      return;
    }

    // set #domain-name to the current domain
    $(element).find('#domain-name').html('http://' + window.location.hostname);

    // if there is a #page-preview somewhere, we'll grab all .glass-edit's (over in the sidebar too)
    var $glass_editables = $(element).find('.glass-edit');

    var $form = null;
    var $prev_chunk = null;
    $glass_editables.each(function () {
      var $chunk  = $(this).glassChunk();
      $chunk.makeEditable();

      if ($chunk.getForm()) {
        $form = $chunk.getForm();
      }

      if ($prev_chunk) {
        $prev_chunk.tabTo($chunk);
      }
      $prev_chunk = $chunk;
    });

    if ($form) {
      var populate_form_for_submit = function (e) {
        $('.glass-edit').each(function () {
          $(this).glassChunk().setFormValFromHtml();
        });
      };
      $form.on('form-before-submit', populate_form_for_submit);
      $form.submit(populate_form_for_submit);
    }
  });

  // Return API for other modules
  return {};
})(jQuery);
