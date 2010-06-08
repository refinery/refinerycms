(function($) {
	$.extend($,{ placeholder: {
			browser_supported: function() {
				return this._supported !== undefined ?
					this._supported :
					( this._supported = !!('placeholder' in $('<input type="text">')[0]) );
			},
			shim: function(opts) {
				var config = {
					color: '#888',
					cls: '',
					lr_padding:4
				};
				$.extend(config,opts);
				!this.browser_supported() && $('input[placeholder]')._placeholder_shim(config);
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

				var ol = $('<label />')
					.text($(this).attr('placeholder'))
					.addClass(config.cls)
					.css({
						position:'absolute',
						display: 'inline',
						float:'none',
						overflow:'hidden',
						whiteSpace:'nowrap',
						textAlign: 'left',
						color: config.color,
						cursor: 'text',
						fontSize: $(this).css('font-size'),
						lineHeight: $(this).css('height')
					})
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