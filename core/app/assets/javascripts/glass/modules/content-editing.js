/**
 * Created by jkrump on 14/01/15.
 * Completely refactored by StefanS
 */
var GlassContentEditing = (function ($) {
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
        module.resetControl();
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

  // JQuery seems to get in the way here.. need to add event to raw DOM element
  function filterPasteEvents(element, textOnly) {
    element.addEventListener("paste", function (e) {
      e.preventDefault();

      if (e && e.clipboardData && e.clipboardData.getData) {
        var result = '';
        if (textOnly !== undefined && textOnly) {
          result = e.clipboardData.getData("text/plain").replace(/<!--[\s\S]*?-->/gm,"");
        }
        else {
          result = GlassHtmlEditor.formatHtml(e.clipboardData.getData("text/html").replace(/<!--[\s\S]*?-->/gm,""));
        }
        document.execCommand("insertHTML", false, result);
      }
      else {
        alert("Sorry, you will need a different browser in order to paste content"); // FIXME
      }
    });
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
          $form_elem.val(this.ch.editor.exportHtml());
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
        });

        // sever the link if this field changes (user has chosen a custom slug themselves)
        if ($slugify_if.length > 0) {
          this_chunk.element().keyup(function (e) {
            $slugify_if.prop("checked", false);
          });
        }
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
      $form.data("monitor-page-unload", true);
      $form.submit(populate_form_for_submit);
    }
  });

  // Return API for other modules
  return {
    filterPasteEvents: filterPasteEvents,
  };
})(jQuery);
