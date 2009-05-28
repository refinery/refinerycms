// Tooltip Object
var Tooltip = Class.create();
Tooltip.prototype = {
	initialize: function(el, options) {
		this.el = $(el);
		this.el.tooltip = this;
		this.initialized = false;
		this.setOptions(options);
		this.options.relativeTo = $(this.options.relativeTo);
		
		// Event handlers
		this.showEvent = this.show.bindAsEventListener(this);
		this.hideEvent = this.hide.bindAsEventListener(this);
		this.updateEvent = this.update.bindAsEventListener(this);
		Event.observe(this.el, "mouseover", this.showEvent );
		Event.observe(this.el, "mouseout", this.hideEvent );
		
		// Removing title from DOM element to avoid showing it
		this.content = this.el.title;
		this.el.title = "";

		// If descendant elements has 'alt' attribute defined, clear it
		this.el.descendants().each(function(el){
			if(Element.readAttribute(el, 'alt'))
				el.alt = "";
		});
		
		rounding = this.options.rounded ? ["xb1", "xb2", "xb3", "xb4"] : [];
		
		// Building tooltip container
		tooltipClassName = this.options.rounded ? "tooltip tooltip-rounded" : "tooltip tooltip-square";
		this.tooltip = new Element("div", {className: tooltipClassName, style: "display: none;"});

		xtop = new Element("div", {className:'xtop'});
		rounding.each(function(rounder)
		{
			xtop.insert(new Element("div", {className:rounder}));
		});
		this.tooltip.insert(xtop);
		this.tooltip.insert(new Element("div", {className: "xboxcontent"}).update(this.content));

		xbottom = new Element("div", {className:'xbottom'});
		rounding.reverse(false).each(function(rounder)
		{
			xbottom.insert(new Element("div", {className:rounder}));
		});
		this.tooltip.insert(xbottom);
		
		document.body.insertBefore(this.tooltip, document.body.childNodes[0]);
		
		this.options.width = this.tooltip.getWidth() + 2 // adding 2 seems to display tooltips on one line in FF, yay;
		this.tooltip.style.minWidth = (this.options.width < this.options.maxWidth ? this.options.width : this.options.maxWidth) + 'px'; // IE7 needs width to be defined. Use min-width because we can sacrifice older browser compatibility.
		
		return this;
	},
	setOptions: function(options) {
		this.options = {
			maxWidth: 250	// Default tooltip width
			,align: "left" // Default align
			,delay: 250 // Default delay before tooltip appears in ms
			,mouseFollow: true // Tooltips follows the mouse moving
			,opacity: .75 // Default tooltips opacity
			,appearDuration: .25 // Default appear duration in sec
			,hideDuration: .25 // Default disappear duration in sec
			,position: 'top'
			,rounded: true
			,spacing:{x:0,y:6}
			,relativeTo:this.el
			,maxHeight:600 // Default tooltip height
		};
		Object.extend(this.options, options || {});
	},
	show: function(e) {
		this.update();
		
		if(!this.initialized)
			this.timeout = window.setTimeout(this.appear.bind(this), this.options.delay);
	},
	hide: function(e) {
		if(this.initialized) {
			if (this.appearingFX != null)
			{
				this.appearingFX.cancel();
			}
			if(this.options.mouseFollow)
			{
				Event.stopObserving(this.el, "mousemove", this.updateEvent);
			}
			if (this.options.hideDuration > 0)
			{
				new Effect.Fade(this.tooltip, {duration: this.options.hideDuration, afterFinish: function() { Element.remove(this.tooltip) }.bind(this) });
			}
			else
			{
				this.tooltip.hide();
			}
		}
		this._clearTimeout(this.timeout);
		
		this.initialized = false;
	},
	update: function(e){
		offset = this.options.relativeTo.cumulativeOffset();
		this.xCord = offset[0];//Event.pointerX(e);
		this.yCord = offset[1];//Event.pointerY(e);
		this.setup();
	},
	appear: function() {
		Element.extend(this.tooltip); // IE needs element to be manually extended
		
		if(this.options.mouseFollow)
		{
			Event.observe(this.el, "mousemove", this.updateEvent);
		}
		
		this.setup();
		
		this.initialized = true;
		if (this.options.appearDuration > 0)
		{
			this.appearingFX = new Effect.Appear(this.tooltip, {duration: this.options.appearDuration, to: this.options.opacity });
		}
		else
		{
			this.tooltip.show();
		}
	},
	setup: function(){
		// If content width is more then allowed max width, set width to max
		if(this.options.width > this.options.maxWidth) {
			this.options.width = this.options.maxWidth;
			this.tooltip.style.width = this.options.width + 'px';
		}
			
		// Tooltip doesn't fit the current document dimensions
		if(this.xCord + this.options.width >= Element.getWidth(document.body)) {
			this.options.align = "right";
			this.xCord = this.xCord - this.options.width + 20;
		}
		
		switch(this.options.position)
		{
			case "left":
			{
				this.tooltip.style.left = (this.xCord - this.options.relativeTo.getWidth() - this.options.spacing.x) + "px";
				this.tooltip.style.top = this.yCord + this.options.spacing.y + "px";
				break;
			}
			case "right":
			{
				this.tooltip.style.left = (this.xCord + this.options.relativeTo.getWidth() + this.options.spacing.x) + "px";
				this.tooltip.style.top = this.yCord + this.options.spacing.y + "px";
				break;
			}
			default:
			{
				this.tooltip.style.left = this.xCord - (this.tooltip.getWidth() / 2) + (this.options.relativeTo.getWidth() / 2) - this.options.spacing.x + "px";
				this.tooltip.style.top = this.yCord - this.tooltip.getHeight() - this.options.spacing.y + "px";
				break;
			}
		}
	},
	_clearTimeout: function(timer) {
		clearTimeout(timer);
		clearInterval(timer);
		return null;
	}
};