/**
 * jQuery Serialize List
 * Copyright (c) 2009 Mike Botsko, Botsko.net LLC
 * Licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * Copyright notice and license must remain intact for legal use
 * Version .2
 *
 * Serialize an unordered or ordered list item. Optional ability
 * to determine which attributes are included. The serialization
 * will be read by PHP as a multidimensional array which you may
 * use for saving state.
 *
 * https://github.com/botskonet/jquery.serialize-list
 */
(function($) {
  $.fn.serializelist = function(options) {
    var defaults = {
        attributes: ['id'],
        allow_nest: true,
        prepend: 'ul',
        att_regex: false,
        is_child: false
      },
      opts = $.extend(defaults, options),
      attrs = opts.attributes,
      serialStr = '',
      val, x, att, child_base;

    var att_rep = function(att, val) {
      if(!opts.att_regex) { return val; }

			for(x in opts.att_regex) {
				if(opts.att_regex[x].att === att) {
					return val.replace(opts.att_regex[x].regex, '');
				}
			}
		};

    if(!opts.is_child) { opts.prepend = '&' + opts.prepend; }

    this.each(function(ul_count, ul) {
      $(ul).children().each(function(li_count, li) {
    		if(opts.allow_nest || attrs.length > 1) {
    			for(var i = 0; i < attrs.length; i++) {
    				val = att_rep(attrs[i], $(li).attr(attrs[i]));
    				serialStr += opts.prepend+'['+ul_count+']['+li_count+']['+attrs[i]+']='+val;
    			}
    		} else {
    			val = att_rep(attrs[0], $(li).attr(attrs[0]));
    			serialStr += opts.prepend+'['+ul_count+']['+li_count+']='+val;
    		}

    		if(opts.allow_nest) {
    			child_base = opts.prepend+'['+ul_count+']['+li_count+'][children]';
    			$(li).children().each(function() {
    				if(this.tagName == 'UL' || this.tagName == 'OL') {
    					serialStr += $(this).serializelist({'prepend': child_base, 'is_child': true});
    				}
    			});
    		}

        li_count++;
      });
    });

    return(serialStr);
  };
})(jQuery);
