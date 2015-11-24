var GlassModuleBase = function() {};

GlassModuleBase.prototype = {
  glassConstructor: function(childClass) {
    var this_module = this;
    var glass_id = this_module.glass_id();
    this_module.debugit = this_module.element().hasClass('debug');
    childClass.call_cbs('*',      'decorators', []           );
    childClass.call_cbs(glass_id, 'pre-init',   [this_module]);
    childClass.call_cbs(glass_id, 'init',       [this_module]);
    setTimeout(function () {
      // Allow for all 'init' callbacks on other modules to run
      childClass.call_cbs(glass_id,'post-init', [this_module]);
    }, 100);
    return this_module;
  },
  glass_id: function() { return 'base-unknown'; },
  debug: function(message) {
    if (this.debugit) {
      console.log("DEBUG: " + this.glass_id() + ": " + message);
    }
  }
};

function addClassMethods(childClass) {
  childClass.callbacks = {
    '*': {
      'decorators': [], // INTERNAL - for decorator contexts
      'pre-init': [],   // modify HTML if necessary
      'init': [],       // attach events (like click or hover)
      'post-init': [],  // init code that relies on other 'init' already run (self or other modules)
      'attach': [],     // it has just attached to a module
      'detatch': [],    // it is just about to detatch from a module
    }
  }

  childClass.default_context = {
    'glass_id': '*',
    'source': 'anon'
  };

  childClass.call_cbs = function(type_key, key, params) {
    var type_keys = ['*'];
    if (type_key != '*') {
      type_keys.push(type_key);
    }
    $.each(type_keys, function (i, type_ky) {
      if (type_ky in childClass.callbacks && key in childClass.callbacks[type_ky]) {
        $.each(childClass.callbacks[type_ky][key], function (i, val) {
          childClass.set_context(val[1]);
          params ? val[0].apply(this, params) : val[0]();
          childClass.reset_context();
        });
      }
    });
  };

  childClass.set_context = function(their_context) {
    childClass.cur_context = $.extend({}, childClass.default_context, their_context);
  };

  childClass.reset_context = function() {
    childClass.cur_context = $.extend({}, childClass.default_context);
  };

  childClass.push_cb = function(type_key, key, cb, context) {
    if (!(type_key in childClass.callbacks)) {
      childClass.callbacks[type_key] = {};
    }
    cb_hash = childClass.callbacks[type_key];
    if (!(key in cb_hash)) {
      cb_hash[key] = [];
    }
    cb_hash[key].push([cb, context]);
  };

  childClass.in_context = function(ctx, cb) {
    var ctx = (typeof ctx == 'string') ? {'glass_id': ctx} : ctx;
    childClass.push_cb('*', 'decorators', cb, ctx);
  };

  childClass.on = function(glass_id, event_name, cb) {
    var ctx = childClass.cur_context;
    ctx['glass_id'] = glass_id;
    childClass.push_cb(ctx['glass_id'], event_name, cb, ctx);
  };

  childClass.reset_context();
};

/**
 * Create a new constructor function, whose prototype is the parent object's prototype.
 * Set the child's prototype to the newly created constructor function.
 * This was borrowed from: http://davidshariff.com/blog/javascript-inheritance-patterns/
 **/
GlassModuleBase.extend = function(childClass, parentClass) {
  var tmpClass = function () {};
  tmpClass.prototype = parentClass.prototype;
  childClass.prototype = new tmpClass();
  childClass.prototype.constructor = childClass;

  addClassMethods(childClass);
};
