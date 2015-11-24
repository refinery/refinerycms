GlassControl.on('delete-btn', 'attach', function(this_control) {
  // float-container puts the btn into the float container for us (.in-float-menu)

  this_control.element().click(function (e) {
    e.preventDefault();
    this_control.module().element().fadeOut(500, function() {
      this_control.module().remove();
    });
  });
});
