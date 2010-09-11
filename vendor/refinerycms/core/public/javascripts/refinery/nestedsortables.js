/*
 * jQuery UI Nested Sortable 1.0.1
 *
 * Copyright 2010, Manuele J Sarfatti
 *
 * http://mjsarfatti.com/sandbox/nestedSortable
 *
 * Depends:
 *	 jquery.ui.core.js 1.8+
 *	 jquery.ui.widget.js 1.8+
 *	 jquery.ui.sortable.js 1.8+
 */
(function($) {
	$.widget("ui.nestedSortable", $.extend({}, $.ui.sortable.prototype, {
		options: {
			tabSize: 20,
			disableNesting: 'ui-nestedSortable-no-nesting',
			errorClass: 'ui-nestedSortable-error'
		},
		_create: function(){
			this.element.data('sortable', this.element.data('sortableTree'));
			return $.ui.sortable.prototype._create.apply(this, arguments);
		},
		_mouseDrag: function(event) {
	
			//Compute the helpers position
			this.position = this._generatePosition(event);
			this.positionAbs = this._convertPositionTo("absolute");
	
			if (!this.lastPositionAbs) {
				this.lastPositionAbs = this.positionAbs;
			}
	
			//Do scrolling
			if(this.options.scroll) {
				var o = this.options, scrolled = false;
				if(this.scrollParent[0] != document && this.scrollParent[0].tagName != 'HTML') {
	
					if((this.overflowOffset.top + this.scrollParent[0].offsetHeight) - event.pageY < o.scrollSensitivity)
						this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop + o.scrollSpeed;
					else if(event.pageY - this.overflowOffset.top < o.scrollSensitivity)
						this.scrollParent[0].scrollTop = scrolled = this.scrollParent[0].scrollTop - o.scrollSpeed;
	
					if((this.overflowOffset.left + this.scrollParent[0].offsetWidth) - event.pageX < o.scrollSensitivity)
						this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft + o.scrollSpeed;
					else if(event.pageX - this.overflowOffset.left < o.scrollSensitivity)
						this.scrollParent[0].scrollLeft = scrolled = this.scrollParent[0].scrollLeft - o.scrollSpeed;
	
				} else {
	
					if(event.pageY - $(document).scrollTop() < o.scrollSensitivity)
						scrolled = $(document).scrollTop($(document).scrollTop() - o.scrollSpeed);
					else if($(window).height() - (event.pageY - $(document).scrollTop()) < o.scrollSensitivity)
						scrolled = $(document).scrollTop($(document).scrollTop() + o.scrollSpeed);
	
					if(event.pageX - $(document).scrollLeft() < o.scrollSensitivity)
						scrolled = $(document).scrollLeft($(document).scrollLeft() - o.scrollSpeed);
					else if($(window).width() - (event.pageX - $(document).scrollLeft()) < o.scrollSensitivity)
						scrolled = $(document).scrollLeft($(document).scrollLeft() + o.scrollSpeed);
	
				}
	
				if(scrolled !== false && $.ui.ddmanager && !o.dropBehaviour)
					$.ui.ddmanager.prepareOffsets(this, event);
			}
	
			//Regenerate the absolute position used for position checks
			this.positionAbs = this._convertPositionTo("absolute");
	
			//Set the helper position
			if(!this.options.axis || this.options.axis != "y") this.helper[0].style.left = this.position.left+'px';
			if(!this.options.axis || this.options.axis != "x") this.helper[0].style.top = this.position.top+'px';
				
			//Rearrange
			for (var i = this.items.length - 1; i >= 0; i--) {
	
				//Cache variables and intersection, continue if no intersection
				var item = this.items[i], itemElement = item.item[0], intersection = this._intersectsWithPointer(item);			
				if (!intersection) continue;
	
				if(itemElement != this.currentItem[0] //cannot intersect with itself
					&&	this.placeholder[intersection == 1 ? "next" : "prev"]()[0] != itemElement //no useless actions that have been done before
					&&	!$.ui.contains(this.placeholder[0], itemElement) //no action if the item moved is the parent of the item checked
					&& (this.options.type == 'semi-dynamic' ? !$.ui.contains(this.element[0], itemElement) : true)
					//&& itemElement.parentNode == this.placeholder[0].parentNode // only rearrange items within the same container
				) {
	
					this.direction = intersection == 1 ? "down" : "up";
	
					if (this.options.tolerance == "pointer" || this._intersectsWithSides(item)) {
						this._rearrange(event, item);
					} else {
						break;
					}
					
					// Clear emtpy ul's
					this._clearUls(itemElement);
	
					this._trigger("change", event, this._uiHash());
					break;
				}
			}
			
			// Get the real previous item
			itemBefore = this.placeholder[0].previousSibling;
			while (itemBefore != null) {
				if (itemBefore.nodeType == 1 && itemBefore != this.currentItem[0]) {		
					break;
				} else {
					itemBefore = itemBefore.previousSibling;
				}
			}
			
			parentItem = this.placeholder[0].parentNode.parentNode;
			newUl = document.createElement('ul');
			
			// Make/delete nested ul's
			if (parentItem != null && parentItem.nodeName == 'LI' && this.positionAbs.left < parentItem.offsetLeft) {
				$(parentItem).after(this.placeholder[0]);
				this._clearUls(parentItem);
			} else if (itemBefore != null && itemBefore.nodeName == 'LI' && this.position.left > itemBefore.offsetLeft + this.options.tabSize) {				
				if (!($(itemBefore).hasClass(this.options.disableNesting))) {
					if ($(this.placeholder[0]).hasClass(this.options.errorClass)) {
						$(this.placeholder[0]).css('marginLeft', 0).removeClass(this.options.errorClass);
					}
					if (itemBefore.children[1] == null) {
						itemBefore.appendChild(newUl);						
					}
					itemBefore.children[1].appendChild(this.placeholder[0]);
				} else {
					$(this.placeholder[0]).addClass(this.options.errorClass).css('marginLeft', this.options.tabSize);
				}
			} else if (itemBefore != null) {
				if ($(this.placeholder[0]).hasClass(this.options.errorClass)) {
					$(this.placeholder[0]).css('marginLeft', 0).removeClass(this.options.errorClass);
				}
				$(itemBefore).after(this.placeholder[0]);
			}
			//Post events to containers
			this._contactContainers(event);
			//Interconnect with droppables
			if($.ui.ddmanager) $.ui.ddmanager.drag(this, event);
			//Call callbacks
			this._trigger('sort', event, this._uiHash());
			this.lastPositionAbs = this.positionAbs;
			return false;
		},
		_clear: function(event, noPropagation) {
			$.ui.sortable.prototype._clear.apply(this, arguments);
			// Clean last empty ul
			for (var i = this.items.length - 1; i >= 0; i--) {	
				var item = this.items[i].item[0];
				this._clearUls(item);
			}			
			return true;	
		},
		_clearUls: function(item) {
			if (item.children[1] && item.children[1].children.length == 0) {
				item.removeChild(item.children[1]);
			}		
		}
	}));
	$.ui.nestedSortable.prototype.options = $.extend({}, $.ui.sortable.prototype.options, $.ui.nestedSortable.prototype.options);
})(jQuery);