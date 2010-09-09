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
 * http://github.com/botskonet/jquery.serialize-list
 */
(function($){
    $.fn.serializelist = function(options) {
        // Extend the configuration options with user-provided
        var defaults = {
			attributes: ['id', 'class'], // which html attributes should be sent?
			allow_nest: true, // allow nested elements to be included
            prepend: 'ul', // which query string param name should be used?
			att_regex: false, // replacement regex to run on attr values
            is_child: false // determine if we're serializing a child list
        };
        var opts = $.extend(defaults, options);
        var serialStr     = '';
        if(!opts.is_child){ opts.prepend = '&'+opts.prepend; }
        // Begin the core plugin
        this.each(function() {
            var li_count = 0;
            $(this).children().each(function(){
				if(opts.allow_nest || opts.attributes.length > 1){
					for(att in opts.attributes){
						val = att_rep(opts.attributes[att], $(this).attr(opts.attributes[att]));
						serialStr += opts.prepend+'['+li_count+']['+opts.attributes[att]+']='+val;
					}
				} else {
					val = att_rep(opts.attributes[0], $(this).attr(opts.attributes[0]));
					serialStr += opts.prepend+'['+li_count+']='+val;
				}
                // append any children elements
				if(opts.allow_nest){
					var child_base = opts.prepend+'['+li_count+'][children]';
					$(this).children().each(function(){
						if(this.tagName == 'UL' || this.tagName == 'OL'){
							serialStr += $(this).serializelist({'prepend': child_base, 'is_child': true});
						}
					});
				}
                li_count++;
            });
			function att_rep (att, val){
				if(opts.att_regex){
					for(x in opts.att_regex){
						if(opts.att_regex[x].att == att){
							return val.replace(opts.att_regex[x].regex, '');
						}
					}
				} else {
					return val;
				}
			}
        });
        return(serialStr);
    };
})(jQuery);