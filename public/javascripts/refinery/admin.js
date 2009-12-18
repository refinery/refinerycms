init_tooltips = function(){
  arguments = arguments.length > 0 ? arguments : ['a[title]', '#image_grid img[title]'];
  $$(arguments).each(function(element)
  {
    new Tooltip(element, {mouseFollow:false, delay: 0, opacity: 1, appearDuration:0, hideDuration: 0, rounded: false});
  });
};

FastInit.addOnLoad(function()
{
  init_tooltips();
  // focus first field in an admin form.
  jQuery('form input[type=text]:first').focus();

  jQuery('a[href*="dialog=true"]').each(function(i, anchor)
  {
    ['modal=true', 'width=928', 'height=473', 'titlebar=true', 'draggable=true'].each(function(feature)
    {
      if (anchor.href.indexOf(feature.split('=')[0] + '=') == -1)
      {
        anchor.href += "&" + feature;
      }
    });

    tb_init(anchor);
  });

  jQuery('#submit_continue_button').bind('click', function(e) {
    // ensure wymeditors are up to date.
    if (jQuery(this).hasClass('wymupdate')) {
      WYMeditor.INSTANCES.each(function(wym)
      {
        wym.update();
      });
    }

    jQuery('#continue_editing').val(true);
    jQuery('#flash').fadeOut(250)

    jQuery.post(this.form.action, this.form.serialize(), function(data) {
      if ((flash_container = $('flash_container')) != null) {
        flash_container.update(data);

        jQuery('#flash').css('width', 'auto').fadeIn(550);

        jQuery('.errorExplanation').each(function(i, node) {
          if (node.parentNode.id != 'flash_container') {
            node.remove();
          }
        });

        jQuery('.fieldWithErrors').each(function(i, field) {
          field.removeClassName('fieldWithErrors').addClassName('field');
        });

        $('flash_container').scrollTo();

        jQuery('#continue_editing').val(false);

        jQuery('.fieldWithErrors:first :input:first').focus();
      }
    });

    e.preventDefault();
  });
});