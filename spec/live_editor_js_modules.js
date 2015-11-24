var count = 0;
var passed = 0;
var testname = 'TEST';

function describe(title) {
  testname = title;
}

function expect(got, expected) {
  ++count;

  if (got != expected) {
    console.log("FAILED " + testname + ": got '" + got + "' expected = '" + expected + "'");
    var $fail_div = $('#fail-tmpl').clone();
    $fail_div.removeAttr('id');
    $fail_div.find('.got').html(got);
    $fail_div.find('.expected').html(expected);
    $fail_div.show();
    $('body').append($fail_div);
    return false;
  }

  ++passed;
  return true;
}





var MyTestModule = function() {
  this.getName = function() {
    return 'tmodule';
  }

  this.glassConstructor(MyTestModule);
};

function MyTestControl(type_id) {
  this.getName = function() {
    return 'tcontrol';
  }

  this.id = type_id;

  this.glassConstructor(MyTestControl);
};

GlassModuleBase.extend(MyTestModule,  GlassModuleBase);
GlassModuleBase.extend(MyTestControl, GlassModuleBase);

MyTestModule.on('*', 'init', function(this_module) {
  this_module.run = function(speed) {
    return 'Running ' + speed;
  };
});

MyTestControl.prototype.eat = function(food) {
  return "I am eating " + food;
};

MyTestModule.prototype.eat = function(food) {
  return "I will eat " + food;
};

MyTestModule.prototype.glass_id = function() {
  return 'module foo';
};

MyTestModule.on('*', 'init', function(this_module) {
  this_module.custom_on_init = function() {
    return 'woohoo!';
  };
});

$(function () {
  var mod = new MyTestModule();
  var con = new MyTestControl();

  describe('child methods');
  expect(mod.getName(), 'tmodule');
  expect(con.getName(), 'tcontrol');

  describe('child has base method');
  expect(con.glass_id(), 'base-unknown');

  describe('child overrides base method');
  expect(mod.glass_id(), 'module foo');

  describe('decoration');
  expect(mod.run('fast'), 'Running fast');
  expect(con.eat('greens'), 'I am eating greens');
  expect(mod.eat('dessert'), 'I will eat dessert');

  describe('init callback');
  expect(mod.custom_on_init(), 'woohoo!');

  describe('init callback per module type');
  MyTestControl.in_context({'source': 'test'}, function () {
    MyTestControl.on('c1', 'init', function (this_control) {
      this_control.custom_on_init = function() { return 'I am C1'; };
    });

    MyTestControl.on('c2', 'init', function (this_control) {
      this_control.custom_on_init = function() { return 'I strive for exellence'; };
    });
  });

  MyTestControl.prototype.glass_id = function() {
    return this.id;
  };

  var c1 = new MyTestControl('c1');
  var c2 = new MyTestControl('c2');
  expect(c1.custom_on_init(), 'I am C1');
  expect(c2.custom_on_init(), 'I strive for exellence');

  console.log("ALL TESTS COMPLETE. pass:" + passed + " fail:" + (count - passed));
});
