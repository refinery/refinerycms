{ // a dummy block, so I can collapse all the meta stuff in the editor
/****************************************************************************
 * jQuery 1.3.x plugin to shorten styled text to fit in a block, appending
 * an ellipsis ("...", &hellip;, Unicode: 2026) or other text.
 * (Only supports ltr text for now.)
 *
 * This is achieved by placing the text of the 'selected' element (eg. span or
 * div) inside a table and measuring its width. If it's too big to big to fit in
 * the element's parent block it's shortened and measured again until it (and
 * appended ellipsis or text) fits inside the block. A tooltip on the 'selected'
 * element displays the full original text.
 *
 * If the browser supports truncating text using the 'text-overflow:ellipsis'
 * CSS property then that will be used (if the text to append is the default
 * ellipsis).
 *
 * If the text is truncated by the plugin any markup in the text will be
 * stripped (eg: "<a" starts stripping, "< a" does not). This behaviour is
 * dictated by the jQuery .text(val) method.
 * The appended text may contain HTML however (a link or span for example).
 *
 * Usage Example ('selecting' a div with an id of "element"):

	<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.3.2/jquery.min.js"></script>
	<script type="text/javascript" src="jquery.textTruncate.js"></script>
	<script type="text/javascript">
		$(function() {
			$("#element").textTruncate();
		});
	</script>

 * By default the plugin will use the parent block's width as maximum width and
 * an ellipsis as appended text when truncating.
 *
 * There are three ways of configuring the plugin:
 *
 * 1) Passing a configuration hash as the plugin's argument, eg:

	.textTruncate({
		width: 300,
		tail: ' <a href="#">more</a>',
		tooltip: false
	});

 * 2) Using two optional arguments (deprecated!):
 * width = the desired pixel width, integer
 * tail = text/html to append when truncating
 *
 * 3) By changing the plugin defaults, eg:

	$.fn.textTruncate.defaults.tail = ' <a href="#">more</a>';

 * Note: there is no default width (unless you create one).
 *
 * You may want to set the element's css to {visibility:hidden;} so it won't
 * initially flash at full width.
 *
 *
 * Created by M. David Green (www.mdavidgreen.com) in 2009. Free to use for
 * personal or commercial purposes under MIT (X11) license with no warranty
 *
 * Heavily modified/simplified/improved by Marc Diethelm (http://web5.me/).
 *
****************************************************************************/
}


(function ($) {

	$.fn.textTruncate = function() {

		var userOptions = {};
		var args = arguments; // for better minification
		var func = args.callee // dito; and much shorter than $.fn.textTruncate

		if ( args.length ) {

			if ( args[0].constructor == Object ) {
				userOptions = args[0];
			} else if ( args[0] == "options" ) {
				return $(this).eq(0).data("options-truncate");
			} else {
				userOptions = {
					width: parseInt(args[0]),
					tail: args[1]
				}
			}
		}

		this.css("visibility","hidden"); // Hide the element(s) while manipulating them

		// apply options vs. defaults
		var options = $.extend({}, func.defaults, userOptions);


		/**
		 * HERE WE GO!
		 **/
		return this.each(function () {

			var $this = $(this);
			$this.data("options-truncate", options);

			/**
			 * If browser implements text-overflow:ellipsis in CSS and tail is "...", use it!
			 **/
			if ( options.tail == "..." && func._native ) {

				this.style[func._native] = "ellipsis";
				/*var css_obj = {}
				css_obj[func._native] = "ellipsis";
				$this.css(css_obj);*/
				$this.css("visibility","visible");

				return true;
			}

			var width = options.width || $this.parent().width();

			var text = $this.text();
			var textlength = text.length;
			var css = "padding:0; margin:0; border:none; font:inherit;";
			var $table = $('<table style="'+ css +'width:auto;zoom:1;position:absolute;"><tr style="'+ css +'"><td style="'+ css +'white-space:nowrap;">' + options.tail + '</td></tr></table>');
			var $td = $("td", $table);
			$this.html( $table );

			var tailwidth = $td.width();
			var targetWidth = width - tailwidth;

			$td.text( text );

			if ($td.width() > width) {
				if ( options.tooltip ) {
					$this.attr("title", text);
				}

				while ($td.width() >= targetWidth ) {
					textlength--;
					$td.html($td.html().substring(0, textlength)); // .html(val) is faster than .text(val) and we already used .text(val) to strip/escape html
				}

				text = $.trim( $td.html() );
				$this.html( text + options.tail );

			} else {
				$this.html( text );
			}

			this.style.visibility = "visible";

			return true;
		});

		return true;

	};

	var css = document.documentElement.style;
	var _native = false;

	if ( "textOverflow" in css ) {
		_native = "textOverflow";
	} else if ( "OTextOverflow" in css ) {
		_native = "OTextOverflow";
	}

	$.fn.textTruncate._native = _native;

	$.fn.textTruncate.defaults = {
		tail: "&hellip;",
		tooltip: true
	};

})(jQuery);
