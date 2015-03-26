/*
  // Create a watcher (watch for onchange & onkeypress events)
  watcher = new WatchForChanges.Watcher({
    'onchange'   : $auto_save_form.find('input, select:not(#parish), textarea'),
    'onkeypress' : $auto_save_form.find('input, textarea'),
    'callback'   : saveStart,
  });

  // Notify the watcher that you've manually triggered the event
  watcher.manually_triggered();

  // Pause and resume (probably when waiting for an ajax response)
  watcher.pause();
  watcher.resume();
*/

var WatchForChanges = (function($){

  var watchers = [];

  function addWatcher(watcher) {
    if (watchers.length === 0) {
      setInterval(do_the_watching, watcher.delay);
    }
    watchers.push(watcher);
  }

  function do_the_watching() {
    $.each(watchers, function(i, watcher) {
      watcher.watch_out();
    });
  }

  function Watcher(args) {
    this.latestChangedElement = $('#funeral_first_name');
    this.latestChangeTime      = Date.now();
    this.callback              = null;
    this.oldestUnsavedTime     = Number.MAX_VALUE;
    this.latestSaveTime        = Date.now() + 1;
    this.paused                = false;

    this.pause  = function() { this.paused = true; };
    this.resume = function() { this.paused = false; };

    var watcher = this;

    if (args['onchange']) {
      args['onchange'].change(function (e) {
        watcher.formElementChanged($(this));
      });
    }

    if (args['onkeypress']) {
      args['onkeypress'].keypress(function (e) {
        watcher.formElementChanged($(this));
      });
    }

    this.callback = args['callback'];
    this.delay    = args['delay']     || 1000;
    this.maxdelay = args['maxdelay']  || 10000;

    addWatcher(this);

    this.formElementChanged = function($element) {
      this.latestChangedElement = $element;
      this.latestChangeTime      = Date.now();
      if (this.oldestUnsavedTime == Number.MAX_VALUE) {
        this.oldestUnsavedTime   = Date.now();
      }
    };

    this.watch_out = function() {
      var readyToSave = false;
      if (this.latestChangeTime > this.latestSaveTime) {           // we have unsaved changes
        if (Date.now() > this.latestChangeTime + this.delay) {     // a bit of "no changes" time has passed
          readyToSave = true;
        }
        if (this.oldestUnsavedTime < Date.now() - this.maxdelay) { // unsaved changes are getting too old
          readyToSave = true;
        }
      }

      if (readyToSave) {
        this.clean_reset();
        this.callback(this.latestChangedElement);
      }
    };

    this.clean_reset = function() {
      // This serves to stop saving while another is in progress
      this.latestSaveTime       = Date.now();
      this.oldestUnsavedTime    = Number.MAX_VALUE;
    };
    
    this.manually_triggered = function() {
      this.clean_reset();
    }
  }

  //Return API for other modules
  return {
    'Watcher': Watcher
  };
})(jQuery);
