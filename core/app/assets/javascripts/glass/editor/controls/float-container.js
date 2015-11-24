GlassControl.on('*', 'attach', function (this_control) {
  if (this_control.element().hasClass('in-float-menu')) {
    var module = this_control.module();
    module.attachControl('float-container'); // attach it if it's not already there
    module.element().children().filter('[data-glass-id="float-container"]').append(this_control.element());
  }
});