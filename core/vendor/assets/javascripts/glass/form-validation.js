/** Verify.js - v0.0.1 - 2013/06/12
 * https://github.com/jpillora/verify
 * Copyright (c) 2013 Jaime Pillora - MIT
 */

(function(window,document,undefined) {
(function($) {

  if(window.console === undefined)
    window.console = { isFake: true };

  var fns = ["log","warn","info","group","groupCollapsed","groupEnd"];
  for (var i = fns.length - 1; i >= 0; i--)
    if(window.console[fns[i]] === undefined)
      window.console[fns[i]] = $.noop;

  if(!$) return;
  
  var I = function(i){ return i; };

  function log() {
    if(this.suppressLog)
      return;
    cons('log', this, arguments);
  }

  function warn() {
    cons('warn', this, arguments);
  }

  function info() {
    cons('info', this, arguments);
  }

  function cons(type, opts, args) {
    if(window.console === undefined ||
       window.console.isFake === true)
      return;

    var a = $.map(args,I);
    a[0] = [opts.prefix, a[0], opts.postfix].join('');
    var grp = $.type(a[a.length-1]) === 'boolean' ? a.pop() : null;

    //if(a[0]) a[0] = getName(this) + a[0];
    if(grp === true) window.console.group(a[0]);
    if(a[0] && grp === null)
      if(window.navigator.userAgent.indexOf("MSIE") >= 0)
        window.console.log(a.join(','));
      else
        window.console[type].apply(window.console, a);
    if(grp === false) window.console.groupEnd();
  }

  function withOptions(opts) {
    return {
      log:  function() { log.apply(opts, arguments); },
      warn: function() { warn.apply(opts, arguments); },
      info: function() { info.apply(opts, arguments); }
    };
  }

  var console = function(opts) {
    opts = $.extend({}, console.defaults, opts);
    return withOptions(opts);
  };

  console.defaults = {
    suppressLog: false,
    prefix: '',
    postfix: ''
  };

  $.extend(console, withOptions(console.defaults));

  if($.console === undefined)
    $.console = console;
  
  $.consoleNoConflict = console;

}(jQuery));

//plugin wide ajax cache
var ajaxCache = { loading: {}, loaded: {} } ;

//callable from user defined rules. alias: r.ajax
function ajaxHelper(userOpts, r) {

  var defaults = {
        method: "GET",
        timeout: 15 * 1000
      },
      exec = r._exec,
      promptContainer = exec.type === "GroupRuleExecution" ?
          exec.element.domElem :
          r.field,
      userSuccess = userOpts.success,
      userError   = userOpts.error,
      options = exec.element.options,
      serialised = JSON ? JSON.stringify(userOpts) : guid();

  function onErrorDefault(e) {
    log("ajax error");
    r.callback("There has been an error");
  }

  var userCallbacks = {
    success: userSuccess,
    error: userError || onErrorDefault
  };

  //already completed
  if(ajaxCache.loaded[serialised]) {

    var args = ajaxCache.loaded[serialised],
        success = userCallbacks.success;

    success.apply(r, args);
    return;
  }

  //this request is in progress,
  //store callbacks for when first request completes
  if(!ajaxCache.loading[serialised])
    ajaxCache.loading[serialised] = [];
  ajaxCache.loading[serialised].push(userCallbacks);

  if(ajaxCache.loading[serialised].length !== 1) return;

  options.prompt(promptContainer, "Checking...", "load");

  function intercept() {
    options.prompt(promptContainer, false);

    var reqs = ajaxCache.loading[serialised];
    while(reqs.length)
      reqs.pop().success.apply(r,arguments);

    ajaxCache.loaded[serialised] = arguments;
  }

  var realCallbacks = {
    success: intercept,
    error: intercept
  };

  exec.ajax = $.ajax($.extend(defaults, userOpts, realCallbacks));
}



// var guid = function() {
//   return (((1 + Math.random()) * 65536) | 0).toString(16).substring(1);
// };

var guid = function() {
  return guid.curr++;
};
guid.curr = 1;

$.fn.verifyScrollView = function(onComplete) {
  var field = $(this).first();
  if(field.length !== 1) return $(this);
  return $(this).verifyScrollTo(field, onComplete);
};

$.fn.verifyScrollTo = function( target, options, callback ){
  if(typeof options == 'function' && arguments.length == 2){ callback = options; options = target; }
  var settings = $.extend({
    scrollTarget  : target,
    offsetTop     : 50,
    duration      : 500,
    easing        : 'swing'
  }, options);
  return this.each(function(){
    var scrollPane = $(this);
    var scrollTarget = (typeof settings.scrollTarget == "number") ? settings.scrollTarget : $(settings.scrollTarget);
    var scrollY = (typeof scrollTarget == "number") ? scrollTarget : scrollTarget.offset().top + scrollPane.scrollTop() - parseInt(settings.offsetTop, 10);
    scrollPane.animate({scrollTop : scrollY }, parseInt(settings.duration, 10), settings.easing, function(){
      if (typeof callback == 'function') { callback.call(this); }
    });
  });
};

$.fn.equals = function(that) {
  if($(this).length !== that.length)
    return false;
  for(var i=0,l=$(this).length;i<l;++i)
    if($(this)[i] !== that[i])
      return false;
  return true;
};


// Inspired by base2 and Prototype

var Class = null;

(function(){
  var initializing = false, fnTest = /xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/;
  // The base Class implementation (does nothing)
  Class = function(){};
  
  // Create a new Class that inherits from this class
  Class.extend = function(prop) {
    var _super = this.prototype;
    
    // Instantiate a base class (but only create the instance,
    // don't run the init constructor)
    initializing = true;
    var prototype = new this();
    initializing = false;
    
    // Copy the properties over onto the new prototype
    for (var name in prop) {
      // Check if we're overwriting an existing function
      prototype[name] = typeof prop[name] == "function" && 
        typeof _super[name] == "function" && fnTest.test(prop[name]) ?
        (function(name, fn){
          return function() {
            var tmp = this._super;
            
            // Add a new ._super() method that is the same method
            // but on the super-class
            this._super = _super[name];
            
            // The method only need to be bound temporarily, so we
            // remove it when we're done executing
            var ret = fn.apply(this, arguments);        
            this._super = tmp;
            
            return ret;
          };
        })(name, prop[name]) :
        prop[name];
    }
    
    // The dummy class constructor
    function Class() {
      // All construction is actually done in the init method
      if ( !initializing && this.init )
        this.init.apply(this, arguments);
    }
    
    // Populate our constructed prototype object
    Class.prototype = prototype;
    
    // Enforce the constructor to be what we expect
    Class.prototype.constructor = Class;

    // And make this class extendable
    Class.extend = arguments.callee;
    
    return Class;
  };
})();
var Set = Class.extend({
  //class variables
  init: function(items, name) {
    //instance variables
    if(name)
      this.name = name;
    else
      this.name = "Set_"+guid();
    this.array = [];
    this.addAll(items);
  },

  indexOf: function(obj) {
    for(var i = 0, l = this.array.length;i<l; ++i)
      if($.isFunction(obj) ?
          obj(this.get(i)) :
          this.equals(this.get(i),obj))
        return i;
    return -1;
  },

  //obj can be a filter function or an object to 'equals' against
  find: function(obj) {
    return this.get(this.indexOf(obj)) || null;
  },

  get: function(i) {
    return this.array[i];
  },
  //truthy find
  has: function(item) {
    return !!this.find(item);
  },
  add: function(item) {
    if(!this.has(item)) {
      this.array.push(item);
      return true;
    }
    return false;
  },
  addAll: function(items) {
    if(!items) return 0;
    if(!$.isArray(items)) items = [items];
    var count = 0;
    for(var i = 0, l = items.length; i<l; ++i)
      if(this.add(items[i]))
        count++;
    return count;
  },
  remove: function(item) {
    var newSet = [];
    for(var i = 0, l = this.array.length; i<l; ++i)
      if(!this.equals(this.get(i),item))
        newSet.push(this.get(i));

    this.array = newSet;
    return item;
  },
  removeAll: function() {
    this.array = [];
  },
  equals: function(i1, i2) {
    if(i1 && i2 && i1.equals !== undefined && i2.equals !== undefined)
      return i1.equals(i2);
    else
      return i1 === i2;
  },
  each: function(fn) {
    for(var i = 0, l = this.array.length; i<l; ++i)
      if( fn(this.get(i)) === false)
        return;
  },
  map: function(fn) {
    return $.map(this.array,fn);
  },
  filter: function(fn) {
    return $.grep(this.array, fn);
  },
  size: function() {
    return this.array.length;
  },
  getArray: function() {
    return this.array;
  }
});
var TypedSet = Set.extend({
  init: function(type, items, name) {
    this.type = type;
    this._super(items, name);
  },
  add: function(item) {
    if(item instanceof this.type)
      this._super(item);
    else
      this.log("add failed - invalid type")
  }
});
var Utils = {

  //object create implementation
  create: function (o) {
    function F() {}
    F.prototype = o;
    return new F();
  },

  //bind method
  bind: $.proxy,

  //check options - throws a warning if the option doesn't exist
  checkOptions: function(opts) {
    if(!opts) return;
    for(var key in opts)
      if(globalOptions[key] === undefined)
        warn("Invalid option: '" + key + "'");
  },

  //append to arguments[i]
  appendArg: function(args, expr, i) {
      if(!i) i = 0;
      var a = [].slice.call(args, i);
      a[i] = expr + a[i];
      return a;
  },

  //memoize.js - by @addyosmani, @philogb, @mathias
  // with a few useful tweaks from @DmitryBaranovsk
  memoize: function( fn ) {
    return function () {
      var args = Array.prototype.slice.call(arguments),
      hash = "",
      i  = args.length,
      currentArg = null;
      while(i--){
        currentArg = args[i];
        hash += (currentArg === Object(currentArg)) ?
              JSON.stringify(currentArg) : currentArg;
        fn.memoize || (fn.memoize = {});
      }
      return (hash in fn.memoize) ? fn.memoize[hash] :
      fn.memoize[hash] = fn.apply( this , args );
    };
  },

  dateToString: function(date) {
    return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
  },

  parseDate: function(dateStr) {
    //format check
    var m = dateStr.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})$/);
    if(!m) return null;

    var date;
    //parse with jquery ui's date picker
    if($.datepicker !== undefined) {
      try {
        var epoch = $.datepicker.parseDate("dd/mm/yy", dateStr);
        date = new Date(epoch);
      } catch(e) { return null; }
    //simple regex parse
    } else {
      date = new Date(parseInt(m[3], 10),parseInt(m[2], 10)-1,parseInt(m[1], 10));
    }

    return date;
  },

  /**
   * returns true if we are in a RTLed document
   * @param {jqObject} field
   */
  isRTL: function(field) {
    var $document = $(document);
    var $body = $('body');
    var rtl =
      (field && field.hasClass('rtl')) ||
      (field && (field.attr('dir') || '').toLowerCase()==='rtl') ||
      $document.hasClass('rtl') ||
      ($document.attr('dir') || '').toLowerCase()==='rtl' ||
      $body.hasClass('rtl') ||
      ($body.attr('dir') || '').toLowerCase()==='rtl';
    return Boolean(rtl);
  }
};


var VERSION = "0.0.1",
    cons = $.consoleNoConflict({ prefix: 'verify.js: ' }),
    log  = cons.log,
    warn = cons.warn,
    info = cons.info;



/* ===================================== *
 * Plugin Settings/Variables
 * ===================================== */

var globalOptions = {
  // Display log messages flag
  debug: false,
  // Auto initialise forms (on DOM ready)
  autoInit: true,
  // Attribute used to find validators
  validateAttribute: "data-validate",
  // Name of the event triggering field validation
  validationEventTrigger: "blur",
  // Automatically scroll viewport to the first error
  scroll: true,
  // Focus on the first input
  focusFirstField: true,
  // Hide error while the user is changing
  hideErrorOnChange: false,
  // Whether to skip the hidden fields
  skipHiddenFields: true,
  // Whether to skip the hidden fields
  skipDisabledFields: true,
  // What class name to apply to the 'errorContainer'
  errorClass: "error",
  // Filter method to find element to apply error class
  errorContainer: function (e) {
    return e;
  },
  // Filter method to find element which reskins the current element
  reskinContainer: function (e) {
    return e;
  },
  //Before form-submit hook
  beforeSubmit: function(e, result) {
    return result;
  },
  //tracking method
  track: $.noop,
  //whether to show prompts
  showPrompt: true,
  //prompt method,
  prompt: function(element, text, opts) {
    if($.type($.notify) === 'function') {
      if(!opts) opts = {color: 'red'};
      $.notify(element, text, opts);
    }
  }
};

//option object creator inheriting from globals
function CustomOptions(opts) {
  $.extend(true, this, opts);



}
CustomOptions.prototype = globalOptions;

/* ===================================== *
 * Base Class
 * ===================================== */

var BaseClass = Class.extend({
  name: "Class",
  toString: function() {
    return (this.type ? this.type + ": ":'') +
           (this.name ? this.name + ": ":'');
  },
  log: function() {
    if(!globalOptions.debug) return;
    log.apply(this, Utils.appendArg(arguments, this.toString()));
  },
  warn: function() {
    warn.apply(this, Utils.appendArg(arguments, this.toString()));
  },
  info: function() {
    info.apply(this, Utils.appendArg(arguments, this.toString()));
  },
  bind: function(name) {
    var prop = this[name];
    if(prop && $.isFunction(prop))
        this[name] = Utils.bind(prop,this);
  },
  bindAll: function() {
    for(var propName in this)
      this.bind(propName);
  },
  //enforce asynchronicity
  nextTick: function(fn, args, ms) {
    var _this = this;
    return window.setTimeout(function() {
      fn.apply(_this, args);
    }, ms || 0);
  }
});
// the Rule class will store all state relating to
// the user definition, all rule state from the DOM
// will be passes into the function inside an
// instance of a RuleExecution

var Rule = BaseClass.extend({

  init: function(name, userObj){
    this.name = name;

    if(!$.isPlainObject(userObj))
      return this.warn("rule definition must be a function or an object");

    this.type = userObj.__ruleType;

    //construct user obj inheriting parent
    this.extendInterface(userObj.extend);
    //does not inherit
    if(!this.userObj) this.userObj = {};
    //clone object to keep a canonical version intact
    $.extend(this.userObj, userObj);
    //infer 'fn' property
    this.buildFn();
    //rule is ready to be used
    this.ready = this.fn !== undefined;
  },

  extendInterface: function(parentName) {

    if(!parentName || typeof parentName !== 'string')
      return;

    //circular dependancy check - not extending itself or any of it's parents
    var p, name = parentName, names = [];
    while(name) {
      if(name === this.name)
        return this.error("Rule already extends '%s'", name);
      p = ruleManager.getRawRule(name);
      name = p ? p.extend : null;
    }
    //extend using another validator -> validator name
    var parentRule = ruleManager.getRule(parentName);
    if(!parentRule)
      return this.warn("Rule missing '%s'", name);

    this.parent = parentRule;

    //type check
    if(!(parentRule instanceof Rule))
      return this.error("Cannot extend: '"+otherName+"' invalid type");

    this.userObj = Utils.create(parentRule.userObj);
    this.userObj.parent = parentRule.userObj;
  },

  buildFn: function() {
    //handle object.fn
    if($.isFunction(this.userObj.fn)) {

      //createe ref on the rule
      this.fn = this.userObj.fn;

    //handle object.regexp
    } else if($.type(this.userObj.regex) === "regexp") {

      //build regex function
      this.fn = (function(regex) {
        return function(r) {
          var re = new RegExp(regex);
          if(!r.val().match(re))
            return r.message || "Invalid Format";
          return true;
        };

      })(this.userObj.regex);

    } else {
      return this.error("Rule has no function");
    }
  },

  //the 'this's in these interface mixins
  //refer to the rule 'r' object
  defaultInterface: {
    log: log,
    warn: warn,
    ajax: function(userOpts) {
      ajaxHelper(userOpts, this);
    }
  },

  defaultFieldInterface: {
    val: function() {
      return this.field.val.apply(this.field,arguments);
    }
  },

  defaultGroupInterface: {
    val: function(id, newVal) {
      var field = this.field(id);
      if(field) return newVal === undefined ? field.val() : field.val(newVal);
    },
    field: function(id) {
      var elems = $.grep(this._exec.members, function(exec) {
        return exec.id === id;
      });

      var elem = elems.length ? elems[0].element.domElem : null;

      if(!elem)
        this.warn("Cannot find group element with id: '" + id + "'");
      return elem;
    },
    fields: function() {
      return $().add($.map(this._exec.members, function(exec) {
        return exec.element.domElem;
      }));
    }
  },

  //build public ruleInterface the 'r' rule object
  buildInterface: function(exec) {
    var objs = [];

    objs.push({});
    //user object has lowest precedence!
    objs.push(this.userObj);
    objs.push(this.defaultInterface);
    if(this.type === 'field') {
      objs.push(this.defaultFieldInterface);
      objs.push({ field: exec.element.domElem });
    }
    if(this.type === 'group')
      objs.push(this.defaultGroupInterface);

    objs.push({
      prompt: exec.element.options.prompt,
      form:  exec.element.form.domElem,
      callback: exec.callback,
      args: exec.args,
      _exec: exec
    });

    return $.extend.apply(this,objs);
  }
});

/* ===================================== *
 * Rules Manager (Plugin Wide)
 * ===================================== */

var ruleManager = null;
(function() {

  //regex parser - with pre 'one(1,2),three.scope(6,7),five)'
  var parseString = function(str) {

    var chars = str.split(""),
        rule, rules = [],
        c, m, depth = 0;

    //replace argument commas with semi-colons
    // TODO allow escaping of '(' ')' ','
    for(var i = 0, l = chars.length; i<l; ++i) {
      c = chars[i];
      if(c === '(') depth++;
      if(c === ')') depth--;
      if(depth > 1) return null;
      if(c === ',' && depth === 1) chars[i] = ";";
    }

    //bracket check
    if(depth !== 0) return null;

    //convert string in format: "name.scope#id(args...)" to object
    $.each(chars.join('').split(','), function(i, rule) {
      //regex doc:      NAME  . SCOPE   # ID      ( PARAM;PARAM* )
      m = rule.match(/^(\w+)(\.(\w+))?(\#(\w+))?(\(([^;\)]+(\;[^;\)]+)*)\))?$/);
      if(!m) return warn("Invalid validate attribute: " + str);
      rule = {};
      rule.name = m[1];
      if(m[3]) rule.scope = m[3];
      if(m[5]) rule.id = m[5];
      rule.args = m[7] ? m[7].split(';') : [];
      rules.push(rule);
    });
    return rules;
  };

  var parseStringMemo = Utils.memoize(parseString);

  //privates
  var rawRules = {},
      builtRules = {};

  var addRules = function(type,obj) {
    //check format, insert type
    for(var name in obj){
      if(rawRules[name])
        warn("validator '%s' already exists", name);

      //functions get auto-objectified
      if($.isFunction(obj[name]))
        obj[name] = { fn: obj[name] };
      //
      obj[name].__ruleType = type;
    }

    //deep extend rules by obj
    $.extend(true, rawRules, obj);
  };

  //public
  var addFieldRules = function(obj) {
    addRules('field', obj);
  };

  var addGroupRules = function(obj) {
    addRules('group', obj);
  };

  var updateRules = function(obj) {

    var data = {};
    //check format, insert type
    for(var name in obj) {

      if(rawRules[name])
        data[name] = obj[name];
      else
        warn("cannot update validator '%s' doesn't exist yet", name);

      //rebuild
      if(builtRules[name])
        delete builtRules[name];
    }

    $.extend(true, rawRules, data);
  };

  var getRawRule = function(name) {
    return rawRules[name];
  };

  var getRule = function(name) {
    var r = builtRules[name],
        obj = rawRules[name];

    if(!obj)
      warn("Missing rule: " + name);
    else if(!r)
      r = builtRules[name] = new Rule(name, obj);

    return r;
  };

  //extract an objectified version of the "data-validate" attribute
  var parseAttribute = function(element) {
    var attrName = element.form.options.validateAttribute,
        attr = element.domElem.attr(attrName);
    if(!attr) return null;
    return parseStringMemo(attr);
  };

  //add a rule property to the above object
  var parseElement = function(element) {

    var required = false,
        type = null,
        attrResults = null,
        results = [];

    if(element.type !== 'ValidationField')
      return warn("Cannot get rules from invalid type");

    if(!element.domElem)
      return results;

    attrResults = this.parseAttribute(element);

    if(!attrResults || !attrResults.length)
      return results;

    //add rule instances
    $.each(attrResults, function(i, result) {
      //special required case
      if(/required/.test(result.name))
        required = true;

      result.rule = getRule(result.name);

      if(result.rule)
        results.push(result);
    });

    results.required = required;
    return results;
  };

  //public interface
  ruleManager = {
    addFieldRules: addFieldRules,
    addGroupRules: addGroupRules,
    getRule: getRule,
    getRawRule: getRawRule,
    parseString: parseString,
    parseAttribute: parseAttribute,
    parseElement: parseElement
  };

}());


var ValidationForm = null;
(function() {

  /* ===================================== *
   * Element Super Class
   * ===================================== */

  var ValidationElement = BaseClass.extend({

    type: "ValidationElement",
    init: function(domElem) {

      if(!domElem || !domElem.length)
        throw "Missing Element";

      this.domElem = domElem;
      this.bindAll();
      this.name = this.domElem.attr('name') ||
                  this.domElem.attr('id') ||
                  guid();
      this.execution = null;

      if(domElem.data('verify'))
        return false;

      domElem.data('verify',this);
      return true;
    },

    equals: function(that) {
      var e1, e2;

      if( this.domElem )
        e1 = this.domElem;
      else
        return false;

      if( that.jquery )
        e2 = that;
      else if( that instanceof ValidationElement && that.domElem )
        e2 = that.domElem;

      if(e1 && e2)
        return e1.equals(e2);

      return false;
    }

  });

  /* ===================================== *
   * Field Wrapper
   * ===================================== */

  var ValidationField = ValidationElement.extend({

    //class variables
    type: "ValidationField",
    init: function(domElem, form) {

      this._super(domElem);

      //instance variables
      this.form = form;
      this.options = form.options;
      this.groups = form.groups;
      this.ruleNames = null;
      this.touched = false;
    },

    //for use with $(field).validate(callback);
    validate: function(callback) {
      if(!callback) callback = $.noop;

      var exec = new FieldExecution(this);

      exec.execute().done(function() {
        callback(true);
      }).fail(function() {
        callback(false);
      });
      return;
    },

    update: function() {
      this.rules = ruleManager.parseElement(this);

      //manage this field within shared groups
      for(var i = 0; i < this.rules.length; ++i) {
        var r = this.rules[i];
        //skip uninitialised and field rules
        if(!r.rule) continue;
        if(r.rule.type !== 'group') continue;
        //shared groups map
        if(!this.groups[r.name])
          this.groups[r.name] = {};
        //calculate scope
        var scope = r.scope || 'default';
        if(!this.groups[r.name][scope])
          this.groups[r.name][scope] = new TypedSet(ValidationField);
        //add self to group
        this.groups[r.name][scope].add(this);
      }

    },

    handleResult: function(exec) {

      var opts = this.options,
          reskinElem = opts.reskinContainer(this.domElem);

      if(!reskinElem || !reskinElem.length)
        return this.warn("No reskin element found. Check 'reskinContainer' option.");

      //handle first error
      // if(!exec.success &&
      //    exec.parent.type === 'FormExecution' &&
      //    !exec.parent.handledError) {
      //   exec.parent.handledError = true;
      //   this.scrollFocus(reskinElem);
      // }

      //show prompt
      if(opts.showPrompt)
        opts.prompt(reskinElem, exec.response);

      //toggle error classes
      var container = opts.errorContainer(reskinElem);
      if(container && container.length)
        container.toggleClass(opts.errorClass, !exec.success);

      //track event
      this.options.track(
        'Validate',
        [this.form.name,this.name].join(' '),
        exec.success ? 'Valid' : exec.response ? '"'+exec.response+'"' : 'Silent Fail'
      );
    },

    //listening for 'validate' event
    scrollFocus: function(reskinElem) {

      var callback = $.noop;
      if(this.options.focusFirstField)
        callback = function() {
          reskinElem.focus();
        };

      if (this.options.scroll)
        reskinElem.verifyScrollView(callback);
      else if(this.options.focusFirstField)
        field.focus();
    }

  });

  /* ===================================== *
   * Form Wrapper
   * ===================================== */

  ValidationForm = ValidationElement.extend({

    /* ===================================== *
     * Instance variables
     * ===================================== */
    type: "ValidationForm",

    init: function(domElem, options) {
      //sanity checks
      this._super(domElem);

      if(!domElem.is("form"))
        throw "Must be a form";

      this.options = new CustomOptions(options);

      this.fields = new TypedSet(ValidationField);
      this.groups = {};
      this.fieldByName = {};
      this.invalidFields = {};
      this.fieldHistory = {};
      this.submitResult = undefined;
      this.submitPending = false;
      this.cache = {
        ruleNames: {},
        ajax: { loading: {}, loaded: {} }
      };

      $(document).ready(this.domReady);
    },

    extendOptions: function(opts) {
      $.extend(true, this.options, opts);
    },

    domReady: function() {
      this.bindEvents();
      this.updateFields();
      this.log("bound to " + this.fields.size() + " elems");
    },

    bindEvents: function() {
      this.domElem
        .on("keyup.jqv", "input", this.onKeyup)
        .on("blur.jqv", "input[type=text]:not(.hasDatepicker),input:not([type].hasDatepicker),textarea", this.onValidate)
        .on("change.jqv", "input[type=text].hasDatepicker,select,[type=checkbox],[type=radio]", this.onValidate)
        .on("submit.jqv", this.onSubmit)
        .trigger("initialised.jqv");
    },

    unbindEvents: function() {
      this.domElem.off(".jqv");
    },

    updateFields: function() {
      var sel = "["+this.options.validateAttribute+"]";
      this.domElem.find(sel).each(this.updateField);
    },

    //creates new validation elements
    //adds them to the form
    updateField: function(i, domElem) {
      if(i.jquery !== undefined) domElem = i;
      if(domElem.jquery === undefined)
        domElem = $(domElem);

      var fieldSelector = "input:not([type=hidden]),select,textarea",
          field, fieldElem;

      if(!domElem.is(fieldSelector))
        return this.warn("Validators will not work on container elements ("+domElem.prop('tagName')+"). Please use INPUT, SELECT or TEXTAREA.");

      fieldElem = domElem;

      field = this.fields.find(fieldElem);

      if(!field) {
        field = new ValidationField(fieldElem, this);
        this.fields.add(field);
      }

      field.update();

      return field;
    },

    /* ===================================== *
     * Event Handlers
     * ===================================== */

    onSubmit: function(event) {

      var submitForm = false;

      if(this.submitPending)
        this.warn("pending...");

      //no result -> begin
      if(!this.submitPending &&
          this.submitResult === undefined) {

        this.submitPending = true;
        this.validate(this.doSubmit);

      //have result
      } else if (this.submitResult !== undefined) {
        submitForm = this.options.beforeSubmit.call(this.domElem, event, this.submitResult);
      }

      if(!submitForm) event.preventDefault();
      return submitForm;
    },

    doSubmit: function(success) {
      this.log('doSubmit', success);
      this.submitPending = false;
      this.submitResult = success;
      this.domElem.submit(); //trigger onSubmit, though with a result
      this.submitResult = undefined;
    },

    onKeyup: function(event) {
      if(this.options.hideErrorOnChange)
        this.options.prompt($(event.currentTarget), null);
    },

    //user triggered validate field event
    onValidate: function(event) {
      var domElem = $(event.currentTarget);
      var field = domElem.data('verify') || this.updateField(domElem);
      field.log("validate");
      field.validate($.noop);
    },

    /* ===================================== *
     * Validate Form
     * ===================================== */

    validate: function(callback) {
      if(!callback) callback = $.noop;

      this.updateFields();

      var exec = new FormExecution(this);

      exec.execute().done(function() {
        callback(true);
      }).fail(function() {
        callback(false);
      });
      return;
    }
  });

})();
// only exposing two classes
var FormExecution = null,
    FieldExecution = null;

//instantiated inside private scope
(function() {

  var STATUS = {
    NOT_STARTED: 0,
    RUNNING: 1,
    COMPLETE: 2
  };

  //super class
  //set in private scope
  var Execution = BaseClass.extend({

    type: "Execution",

    init: function(element, parent) {
      //corresponding <Form|Field>Element class

      this.element = element;
      if(element) {
        this.prevExec = element.execution;
        element.execution = this;
        this.options = this.element.options;
        this.domElem = element.domElem;
      }
      //parent Execution class
      this.parent = parent;
      this.name = '#'+guid();
      this.status = STATUS.NOT_STARTED;
      this.bindAll();

      //deferred object
      this.d = this.restrictDeferred();
      this.d.done(this.executePassed);
      this.d.fail(this.executeFailed);

    },

    isPending: function() {
      return this.prevExec && this.prevExec.status !== STATUS.COMPLETE;
    },

    toString: function() {
      return this._super() + "[" + this.element.name + (!this.rule ? "" : ":" + this.rule.name) + "] ";
    },

    //execute in sequence, stop on fail
    serialize: function(objs) {

      var fns = this.mapExecutables(objs);

      if(!$.isArray(fns) || fns.length === 0)
        return this.resolve();

      var pipeline = fns[0](),
          i = 1, l = fns.length;

      this.log("SERIALIZE", l);

      if(!pipeline || !pipeline.pipe)
        throw "Invalid Deferred Object";

      for(;i < l;i++)
        pipeline = pipeline.pipe(fns[i]);

      //link pipeline
      pipeline.done(this.resolve).fail(this.reject);

      return this.d.promise();
    },

    //execute all at once,
    parallelize: function(objs) {

      var fns = this.mapExecutables(objs);

      var _this = this,
          n = 0, i = 0, l = fns.length,
          rejected = false;

      this.log("PARALLELIZE", l);

      if(!$.isArray(fns) || l === 0)
        return this.resolve();

      function pass(response) {
        n++;
        if(n === l) _this.resolve(response);
      }

      function fail(response) {
        if(rejected) return;
        rejected = true;
        _this.reject(response);
      }

      //execute all at once
      for(; i<l; ++i ) {
        var dd = fns[i]();
        if(!dd || !dd.done || !dd.fail)
          throw "Invalid Deferred Object";
        dd.done(pass).fail(fail);
      }

      return this.d.promise();
    },

    mapExecutables: function(objs) {
      return $.map(objs, function(o) {
        if($.isFunction(o)) return o;
        if($.isFunction(o.execute)) return o.execute;
        throw "Invalid executable";
      });
    },

    linkPass: function(that) {
      that.d.done(this.resolve);
    },
    linkFail: function(that) {
      that.d.fail(this.reject);
    },
    link: function(that) {
      this.linkPass(that);
      this.linkFail(that);
    },

    execute: function() {

      var p = this.parent,
          ps = [];
      while(p) {
        ps.unshift(p.name);
        p = p.parent;
      }
      var gap = "(" + ps.join(' < ') + ")";

      this.log(this.parent ? gap : '', 'executing...');
      this.status = STATUS.RUNNING;
      if(this.domElem)
        this.domElem.triggerHandler("validating");

      return true;
    },

    executePassed: function(response) {
      this.success = true;
      this.response = this.filterResponse(response);
      this.executed();
    },
    executeFailed: function(response) {
      this.success = false;
      this.response = this.filterResponse(response);
      this.executed();
    },

    executed: function() {
      this.status = STATUS.COMPLETE;

      this.log((this.success ? 'Passed' : 'Failed') + ": " + this.response);

      if(this.domElem)
        this.domElem.triggerHandler("validated", this.success);
    },

    //resolves or rejects the execution's deferred object 'd'
    resolve: function(response) {
      return this.resolveOrReject(true, response);
    },
    reject: function(response) {
      return this.resolveOrReject(false, response);
    },
    resolveOrReject: function(success, response) {
      var fn = success ? '__resolve' : '__reject';
      if(!this.d || !this.d[fn]) throw "Invalid Deferred Object";
      this.nextTick(this.d[fn], [response], 0);
      return this.d.promise();
    },
    filterResponse: function(response) {
      if(typeof response === 'string')
        return response;
      return null;
    },
    restrictDeferred: function(d) {
      if(!d) d = $.Deferred();
      d.__reject = d.reject;
      d.__resolve = d.resolve;
      d.reject = d.resolve = function() {
        console.error("Use execution.resolve|reject()");
      };
      return d;
    }

  });

  //set in plugin scope
  FormExecution = Execution.extend({
    type: "FormExecution",

    init: function(form) {
      this._super(form);
      this.ajaxs = [];

      //prepare child executables
      this.children = this.element.fields.map($.proxy(function(f) {
        return new FieldExecution(f, this);
      }, this));
    },

    execute: function() {
      this._super();

      if(this.isPending()) {
        this.warn("pending... (waiting for %s)", this.prevExec.name);
        return this.reject();
      }

      this.log("exec fields #" + this.children.length);
      return this.parallelize(this.children);
    }

  });

  //set in plugin scope
  FieldExecution = Execution.extend({
    type: "FieldExecution",

    init: function(field, parent) {
      this._super(field, parent);
      if(parent instanceof FormExecution)
        this.formExecution = parent;
      field.touched = true;
      this.children = [];
    },

    execute: function() {
      this._super();

      if(this.isPending()) {
        this.warn("pending... (waiting for %s)", this.prevExec.name);
        return this.reject();
      }

      //execute rules
      var ruleParams = ruleManager.parseElement(this.element);

      //skip check
      this.skip = this.skipValidations(ruleParams);
      if(this.skip)
        return this.resolve();

      //ready
      this.children = $.map(ruleParams, $.proxy(function(r) {
        if(r.rule.type === 'group')
          return new GroupRuleExecution(r, this);
        else
          return new RuleExecution(r, this);
      }, this));

      // this.log("exec rules #%s", this.children.length);
      return this.serialize(this.children);
    },

    skipValidations: function(ruleParams) {

      //no rules
      if(ruleParams.length === 0) {
        this.log("skip (no validators)");
        return true;
      }

      //not required
      if(!ruleParams.required && !$.trim(this.domElem.val())) {
        this.warn("skip (not required)");
        return true;
      }

      //custom-form-elements.js hidden fields
      if(this.options.skipHiddenFields &&
         this.options.reskinContainer(this.domElem).is(':hidden')) {
        this.log("skip (hidden)");
        return true;
      }

      //skip disabled
      if(this.options.skipDisabledFields &&
         this.domElem.is('[disabled]')) {
        this.log("skip (disabled)");
        return true;
      }

      return false;
    },

    executed: function() {
      this._super();

      //pass error to element
      var i, exec = this,
          children = this.children;
      for(i = 0; i < children.length; ++i)
        if(children[i].success === false) {
          exec = children[i];
          break;
        }
      this.element.handleResult(exec);
    }

  });

  //set in private scope
  var RuleExecution = Execution.extend({
    type: "RuleExecution",

    init: function(ruleParamObj, parent) {
      this._super(null, parent);

      this.rule = ruleParamObj.rule;
      this.args = ruleParamObj.args;
      this.element = this.parent.element;
      this.options = this.element.options;
      this.rObj = {};
    },

    //the function that gets called when
    //rules return or callback
    callback: function(response) {
      clearTimeout(this.t);
      this.callbackCount++;
      this.log(this.rule.name + " (cb:" + this.callbackCount + "): " + response);

      if(this.callbackCount > 1)
        return;

      if(response === undefined)
        this.warn("Undefined result");

      //success
      if(response === true)
        this.resolve(response);
      else
        this.reject(response);

    },

    timeout: function() {
      this.warn("timeout!");
      this.callback("Timeout");
    },

    execute: function() {
      this._super();
      this.callbackCount = 0;

      //sanity checks
      if(!this.element || !this.rule.ready) {
        this.warn(this.element ? 'not  ready.' : 'invalid parent.');
        return this.resolve();
      }

      this.t = setTimeout(this.timeout, 10000);
      this.r = this.rule.buildInterface(this);
      //finally execute validator

      var response;
      try {
        response = this.rule.fn(this.r);
      } catch(e) {
        response = true;
        console.error("Error caught in validation rule: '" + this.rule.name +
                      "', skipping.\nERROR: " + e.toString() + "\nSTACK:" + e.stack);
      }

      //used return statement
      if(response !== undefined)
        this.nextTick(this.callback, [response]);

      return this.d.promise();
    }

  });

  var GroupRuleExecution = RuleExecution.extend({

    type: "GroupRuleExecution",

    init: function(ruleParamObj, parent) {
      this._super(ruleParamObj, parent);
      this.groupName = ruleParamObj.name;
      this.id = ruleParamObj.id;
      this.scope = ruleParamObj.scope || 'default';
      this.group = this.element.groups[this.groupName][this.scope];
      if(!this.group)
        throw "Missing Group Set";
      if(this.group.size() === 1)
        this.warn("Group only has 1 field. Consider a field rule.");
    },

    execute: function() {

      var sharedExec = this.group.exec,
          parentExec = this.parent,
          originExec = parentExec && parentExec.parent,
          groupOrigin = originExec instanceof GroupRuleExecution,
          fieldOrigin = !originExec,
          formOrigin = originExec instanceof FormExecution,
          _this = this, i, j, field, exec, child,
          isMember = false;

      if(!sharedExec || sharedExec.status === STATUS.COMPLETE) {
        this.log("MASTER");
        this.members = [this];
        this.executeGroup = this._super;
        sharedExec = this.group.exec = this;

        if(formOrigin)
          sharedExec.linkFail(originExec);

      } else {

        this.members = sharedExec.members;
        for(i = 0; i < this.members.length; ++i)
          if(this.element === this.members[i].element)
            isMember = true;

        if(isMember) {
          //start a new execution - reject old
          this.log("ALREADY A MEMBER OF %s", sharedExec.name);
          this.reject();
          return;

        } else {
          this.log("SLAVE TO %s", sharedExec.name);
          this.members.push(this);
          this.link(sharedExec);
          if(this.parent) sharedExec.linkFail(this.parent);
        }
      }

      if(fieldOrigin)
      for(i = 0; i < this.group.size(); ++i) {
        field = this.group.get(i);

        if(this.element === field)
          continue;

        this.log("CHECK:", field.name);
        //let the user make their way onto
        // the field first - silent fail!
        if(!field.touched) {
          this.log("FIELD NOT READY: ", field.name);
          return this.reject();
        }

        exec = field.execution;
        //silent fail unfinished
        if(exec && exec.status !== STATUS.COMPLETE)
          exec.reject();

        this.log("STARTING ", field.name);
        exec = new FieldExecution(field, this);
        exec.execute();
      }

      var groupSize = this.group.size(),
          execSize = sharedExec.members.length;

      if(groupSize === execSize&&
         sharedExec.status === STATUS.NOT_STARTED) {
        sharedExec.log("RUN");
        sharedExec.executeGroup();
      } else {
        this.log("WAIT (" + execSize + "/" + groupSize + ")");
      }

      return this.d.promise();
    },

    filterResponse: function(response) {
      if(!response || !this.members.length)
        return this._super(response);

      var isObj = $.isPlainObject(response),
          isStr = (typeof response === 'string');

      if(isStr && this === this.group.exec) return response;
      if(isObj && response[this.id]) return response[this.id];

      return null;
    }

  });

})();
$.fn.validate = function(callback) {
  var validator = $(this).data('verify');
  if(validator)
    validator.validate(callback);
  else
    warn("element does not have verifyjs attached");
};

$.fn.validate.version = VERSION;

$.fn.verify = function(userOptions) {
  return this.each(function() {

    //get existing form class this element
    var form = $.verify.forms.find($(this));

    //unbind and destroy form
    if(userOptions === false || userOptions === "destroy") {
      if(form) {
        form.unbindEvents();
        $.verify.forms.remove(form);
      }
      return;
    }

    Utils.checkOptions(userOptions);
    if(form) {
      form.extendOptions(userOptions);
      form.updateFields();
    } else {
      form = new ValidationForm($(this), userOptions);
      $.verify.forms.add(form);
    }

  });
};

$.verify = function(options) {
  Utils.checkOptions(options);
  $.extend(globalOptions, options);
};

$.extend($.verify, {
  version: VERSION,
  updateRules: ruleManager.updateRules,
  addRules: ruleManager.addFieldRules,
  addFieldRules: ruleManager.addFieldRules,
  addGroupRules: ruleManager.addGroupRules,
  log: info,
  warn: warn,
  defaults: globalOptions,
  globals: globalOptions,
  utils: Utils,
  forms: new TypedSet(ValidationForm, [], "FormSet"),
  _hidden: {
    ruleManager: ruleManager
  }
});

/* ===================================== *
 * Auto attach on DOM ready
 * ===================================== */

$(function() {
  if(globalOptions.autoInit)
  $("form").filter(function() {
    return $(this).find("[" + globalOptions.validateAttribute + "]").length > 0;
  }).verify();
});

// log("plugin added.");


(function($) {

  if($.verify === undefined) {
    window.alert("Please include verify.js before each rule file");
    return;
  }

  $.verify.addFieldRules({
    /* Regex validators
     * - at plugin load, 'regex' will be transformed into validator function 'fn' which uses 'message'
     */
    currency: {
      regex: /^\-?\$?\d{1,2}(,?\d{3})*(\.\d+)?$/,
      message: "Invalid monetary value"
    },
    email: {
      regex: /^(([^<>()\[\]\\.,;:\s@\"]+(\.[^<>()\[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/,
      message: "Invalid email address"
    },
    url: {
      regex: /^https?:\/\/[\-A-Za-z0-9+&@#\/%?=~_|!:,.;]*[\-A-Za-z0-9+&@#\/%=~_|]/,
      message: "Invalid URL"
    },
    alphanumeric: {
      regex: /^[0-9A-Za-z]+$/,
      message: "Use digits and letters only"
    },
    street_number: {
      regex: /^\d+[A-Za-z]?(-\d+)?[A-Za-z]?$/,
      message: "Street Number only"
    },
    number: {
      regex: /^\d+$/,
      message: "Use digits only"
    },
    numberSpace: {
      regex: /^[\d\ ]+$/,
      message: "Use digits and spaces only"
    },
    postcode: {
      regex: /^\d{4}$/,
      message: "Invalid postcode"
    },
    date: {
      fn: function(r) {
        if($.verify.utils.parseDate(r.val()))
          return true;
        return r.message;
      },
      message: "Invalid date"
    },
    required: {

      fn: function(r) {
        return r.requiredField(r, r.field);
      },

      requiredField: function(r, field) {
        var v = field.val();

        switch (field.prop("type")) {
          case "radio":
          case "checkbox":
            var name = field.attr("name");
            var group = field.data('fieldGroup');

            if(!group) {
              group = r.form.find("input[name='" + name + "']");
              field.data('fieldGroup', group);
            }

            if (group.is(":checked"))
              break;

            if (group.size() === 1)
              return r.messages.single;

            return r.messages.multiple;

          default:
            if (! $.trim(v))
              return r.messages.all;
            break;
        }
        return true;
      },
      messages: {
        "all": "This field is required",
        "multiple": "Please select an option",
        "single": "This checkbox is required"
      }
    },
    regex: {
      fn: function(r) {
        var re;
        try {
          var str = r.args[0];
          re = new RegExp(str);
        } catch(error) {
          r.warn("Invalid regex: " + str);
          return true;
        }

        if(!r.val().match(re))
          return r.args[1] || r.message;
        return true;
      },
      message: "Invalid format"
    },
    //an alias
    pattern: {
      extend: 'regex'
    },
    asyncTest: function(r) {

      r.prompt(r.field, "Please wait...");
      setTimeout(function() {
        r.callback();
      },2000);

    },
    phone: function(r) {
      r.val(r.val().replace(/\D/g,''));
      var v = r.val();
      if(!v.match(/^\+?[\d\s]+$/))
        return "Use digits and spaces only";
      if(v.match(/^\+/))
        return true; //allow all international
      if(!v.match(/^0/))
        return "Number must start with 0";
      if(v.replace(/\s/g,"").length !== 10)
        return "Must be 10 digits long";
      return true;
    },
    size: function(r){
      var v = r.val(), exactOrLower = r.args[0], upper = r.args[1];
      if(exactOrLower !== undefined && upper === undefined) {
        var exact = parseInt(exactOrLower, 10);
        if(r.val().length !== exact)
          return  "Must be "+exact+" characters";
      } else if(exactOrLower !== undefined && upper !== undefined) {
        var lower = parseInt(exactOrLower, 10);
        upper = parseInt(upper, 10);
        if(v.length < lower || upper < v.length)
          return "Must be between "+lower+" and "+upper+" characters";
      } else {
        r.warn("size validator parameter error on field: " + r.field.attr('name'));
      }

      return true;
    },
    min: function(r) {
      var v = r.val(), min = parseInt(r.args[0], 10);
      if(v.length < min)
        return "Must be at least " + min + " characters";
      return true;
    },
    max: function(r) {
      var v = r.val(), max = parseInt(r.args[0], 10);
      if(v.length > max)
        return "Must be at most " + max + " characters";
      return true;
    },

    decimal: function(r) {
      var vStr = r.val(),
          places = r.args[0] ? parseInt(r.args[0], 10) : 2;

      if(!vStr.match(/^\d+(,\d{3})*(\.\d+)?$/))
        return "Invalid decimal value";

      var v = parseFloat(vStr.replace(/[^\d\.]/g,'')),
          factor = Math.pow(10,places);

      v = (Math.round(v*factor)/factor);
      r.field.val(v);

      return true;
    },
    minVal: function(r) {
      var v = parseFloat(r.val().replace(/[^\d\.]/g,'')),
          suffix = r.args[1] || '',
          min = parseFloat(r.args[0]);
      if(v < min)
        return "Must be greater than " + min + suffix;
      return true;
    },
    maxVal: function(r) {
      var v = parseFloat(r.val().replace(/[^\d\.]/g,'')),
          suffix = r.args[1] || '',
          max = parseFloat(r.args[0]);
      if(v > max)
        return "Must be less than " + max + suffix;
      return true;
    },
    rangeVal: function(r) {
      var v = parseFloat(r.val().replace(/[^\d\.]/g,'')),
          prefix = r.args[2] || '',
          suffix = r.args[3] || '',
          min = parseFloat(r.args[0]),
          max = parseFloat(r.args[1]);
      if(v > max || v < min)
        return "Must be between " + prefix + min + suffix + "\nand " + prefix + max + suffix;
      return true;
    },

    agreement: function(r){
      if(!r.field.is(":checked"))
        return "You must agree to continue";
      return true;
    },
    minAge: function(r){
      var age = parseInt(r.args[0],10);
      if(!age || isNaN(age)) {
        console.log("WARNING: Invalid Age Param: " + age);
        return true;
      }
      var currDate = new Date();
      var minDate = new Date();
      minDate.setFullYear(minDate.getFullYear() - age);
      var fieldDate = $.verify.utils.parseDate(r.val());

      if(fieldDate === "Invalid Date")
        return "Invalid Date";
      if(fieldDate > minDate)
        return "You must be at least " + age;
      return true;
    }
  });

  // Group validation rules
  $.verify.addGroupRules({

    dateRange: function(r) {
      var start = r.field("start"),
          end = r.field("end");

      if(start.length === 0 || end.length === 0) {
        r.warn("Missing dateRange fields, skipping...");
        return true;
      }

      var startDate = $.verify.utils.parseDate(start.val());
      if(!startDate)
        return "Invalid Start Date";

      var endDate = $.verify.utils.parseDate(end.val());
      if(!endDate)
        return "Invalid End Date";

      if(startDate >= endDate)
        return "Start Date must come before End Date";

      return true;
    },

    requiredAll: {
      extend: 'required',
      fn: function(r) {

        var size = r.fields().length,
            message,
            passes = [], fails = [];

        r.fields().each(function(i, field) {
          message = r.requiredField(r, field);
          if(message === true)
            passes.push(field);
          else
            fails.push({ field: field, message:message });
        });

        if(passes.length > 0 && fails.length > 0) {
          $.each(fails, function(i, f) {
            r.prompt(f.field, f.message);
          });
          return false;
        }

        return true;
      }
    }

  });

})(jQuery);
}(window,document));