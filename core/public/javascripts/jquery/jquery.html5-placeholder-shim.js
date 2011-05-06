(function($) {
  // @todo Document this.
  $.extend($,{ placeholder: {
      browser_supported: function() {
        return this._supported !== undefined ?
          this._supported :
          ( this._supported = !!('placeholder' in $('<input type="text">')[0]) );
      },
      shim: function(opts) {
        var config = {
          color: '#888',
          cls: 'placeholder',
          lr_padding:4,
          selector: 'input[placeholder], textarea[placeholder]'
        };
        $.extend(config,opts);
        !this.browser_supported() && $(config.selector)._placeholder_shim(config);
      }
  }});

  $.extend($.fn,{
    _placeholder_shim: function(config) {
      function calcPositionCss(target)
      {
        var op = $(target).offsetParent().offset();
        var ot = $(target).offset();

        return {
          top: ot.top - op.top + ($(target).outerHeight() - $(target).height()) /2,
          left: ot.left - op.left + config.lr_padding,
          width: $(target).width() - config.lr_padding
        };
      }
      return this.each(function() {
        if( $(this).data('placeholder') ) {
          var $ol = $(this).data('placeholder');
          $ol.css(calcPositionCss($(this)));
          return true;
        }

        var possible_line_height = {};
        if( $(this).css('height') != 'auto') {
          possible_line_height = { lineHeight: $(this).css('height') };
        }

        var ol = $('<label />')
          .text($(this).attr('placeholder'))
          .addClass(config.cls)
          .css($.extend({
            position:'absolute',
            display: 'inline',
            float:'none',
            overflow:'hidden',
            whiteSpace:'nowrap',
            textAlign: 'left',
            color: config.color,
            cursor: 'text',
            paddingTop: $(this).css('padding-top'),
            paddingLeft: $(this).css('padding-left'),
            fontSize: $(this).css('font-size'),
            fontFamily: $(this).css('font-family'),
            fontStyle: $(this).css('font-style'),
            fontWeight: $(this).css('font-weight'),
            textTransform: $(this).css('text-transform'),
            zIndex: 99
          }, possible_line_height))
          .css(calcPositionCss(this))
          .attr('for', this.id)
          .data('target',$(this))
          .click(function(){
            $(this).data('target').focus()
          })
          .insertBefore(this);
        $(this)
          .data('placeholder',ol)
          .focus(function(){
            ol.hide();
          }).blur(function() {
            ol[$(this).val().length ? 'hide' : 'show']();
          }).triggerHandler('blur');
        $(window)
          .resize(function() {
            var $target = ol.data('target')
            ol.css(calcPositionCss($target))
          });
      });
    }
  });
})(jQuery);

jQuery(document).add(window).bind('ready load', function() {
  if (jQuery.placeholder) {
    jQuery.placeholder.shim();
  }
});