$.fn.nestedSortable = function(options) {

  var settings = $.extend({
    nestable: 'li'
    , container: 'ul'
    , indent: 30
    , handle: null
    , opacity: 1
    , placeholderClass: 'placeholder'
    , placeholderElement: 'div'
    , helperClass: 'helper'
    , appendTo: 'parent'
    , start: function() {}
    , stop: function() {}
    , drag: function() {}
    , maxDepth: null
  }, options);
  settings.snapTolerance = settings.indent * 0.4;
  cursor = {x: 0, y: 0};

  this.each(function() {

    // The top level nestable list container
    var $root = $(this);

    // An element placed to preview the location of the dragged element in its new position
    var $placeholder = $('<' + settings.placeholderElement + '></' + settings.placeholderElement + '>', {
      "class":  settings.placeholderClass
    });

    
    $root.find(settings.nestable).each(function() {

      var $this = $(this);

      // Check if the element has already been set up as a nestable
      if (!$this.data("nestable")) {

       // Make the element draggable
       $this.draggable({

        // Transfer over some settings to jQuery's draggable implementation
        opacity: settings.opacity,
        handle: settings.handle,
        appendTo: settings.appendTo,

        // Creates a helper element
        helper: function() {
          // Create a helper that is a clone of the original (with a few little tweaks)
          return $this.clone().width($this.width()).addClass(settings.helperClass);
        },

        // When dragging starts
        start: function() {

          // Hide the original and initialize the placeholder ontop of the starting position
          $this.addClass('ui-dragging').hide().after($placeholder);

          // Find the deepest nested child
          var maxChildDepth = 0;
          $this.find(settings.nestable).each(function(index, child) {
           var $child = $(child);
           var childDepth = $child.parentsUntil($this).filter(settings.nestable).length;
           if (childDepth > maxChildDepth) {
             maxChildDepth = childDepth;
           }
          });
          $this.data("maxChildDepth", maxChildDepth);

          // Run a custom start function specitifed in the settings
          settings.start.apply(this);

        },

        // When dragging ends
        stop: function(event, ui) {
          // Replace the placeholder with the original while protecting it from disappearing.
          if ($.inArray($root.get(0), $placeholder.parents()) > -1) {
            $placeholder.after($this.show()).remove();
          } else {
            $this.show();
            $placeholder.remove();
          }
          // Run a custom stop function specitifed in the settings
          settings.stop.apply(this);
          $('.ui-dragging').removeClass('ui-dragging');
          $('.below-placeholder').removeClass('below-placeholder').animate({'marginTop':'0px'}, 0);
        },

        // Each "step" during the drag
        drag: function (event, ui) {
          // reduce sensitivity
          if (cursor.y == 0 || typeof(event.clientY) == 'undefined' || ((cursor.y - event.clientY) >= 15) || ((cursor.y - event.clientY) <= -15) ) {
            // Cycle through all nestables to find the item directly underneath the helper
            var largestY = 0;
            var depth;
            var maxChildDepth = $this.data("maxChildDepth");
            var underItems = $.grep($root.find(settings.nestable), function(item) {

             $item = $(item);

             // Is the item being  checked underneath the one being dragged?
             if (!(($item.offset().top < ui.position.top) && ($item.offset().top > largestY))) {
               return false;
             }

             // Is the item being checked on the same nesting level as the dragged item?
             if ($item.offset().left - settings.snapTolerance >= ui.position.left) {
               return false;
             }

             // Make sure the item being checked is not part of the helper
             if (ui.helper.find($item).length) {
               return false;
             }

             // Make sure the item complies with max depth rules
             if (settings.maxDepth !== null) {
               depth = $item.parentsUntil($root).filter(settings.container).length + maxChildDepth;
               if (depth - 1 > settings.maxDepth) {
                 return false;
               }
             }

             // If we've got this far, its a match
             largestY = $item.offset().top;
             return true;

            });

            var underItem = underItems.length ? $(underItems.pop()) : null;
            var nestedBeneath = null;

            // If there is no item directly underneath the helper, check if the helper is over the first list item
            if (underItem === null) {
               var firstItem = $root.find(settings.nestable + ":first");

               if ((firstItem.offset().top < ui.position.top + $(this).height()) && (firstItem.offset().top > ui.position.top)) {
                 underContainer = firstItem.closest(settings.container);
                 nestedBeneath = underContainer;
                 underContainer.prepend($placeholder);
               }

             // Place the placeholder inside or after the item underneath, depending on their relative x coordinates
            } else {
              // Should the dragged item be nested?
              if ((underItem.offset().left + settings.indent - settings.snapTolerance < ui.position.left) && (settings.maxDepth === null || depth <= settings.maxDepth)) {
                underContainer = underItem.children(settings.container);
                nestedBeneath = underContainer;
                underContainer.prepend($placeholder);
              }
              // ... or should it just be placed after
              else {
                nestedBeneath = underItem;
                underItem.after($placeholder);
              }
            }
            try{
              $placeholder.css({'width': (w = nestedBeneath.width()) > 0 ? w : $placeholder.parent().width()});
            } catch(e) {}

            old_placeholder = $('.below-placeholder').removeClass('below-placeholder');
            new_below_placeholder = $placeholder.nextAll('li.record:not(.ui-dragging):not(.ui-draggable-dragging):first').addClass('below-placeholder');
            if (old_placeholder.attr('id') != new_below_placeholder.attr('id')) {
              old_placeholder.animate({'marginTop':'0px'}, 125);
              new_below_placeholder.addClass('below-placeholder').animate({'marginTop' : '20px'}, 125);
            }
            // Run a custom drag callback specifed in the settings
            settings.drag.apply(this);

            // save mouse co-ordinates.
            if (typeof(event.clientX) != 'undefined') {
              cursor.x = event.clientX;
            }
            if (typeof(event.clientY) != 'undefined') {
              cursor.y = event.clientY;
            }
          }
        }

       }).data("nestable", true);
      }
    });
  });
  return this;
};