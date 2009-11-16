switch_area = function(area)
{
	$$('#dialog_menu_left span.selected_radio').each(function(span)
	{
		span.removeClassName('selected_radio');
	});
	$($(area).parentNode).addClassName('selected_radio');

	$$('#dialog_main div.dialog_area').each(function(div)
	{
		div.hide();
	});

	$(area.value + '_area').show();
}

FastInit.addOnLoad(function()
{
	radios = $$('#dialog_menu_left input[type=radio]');
	selected = $$('#dialog_menu_left .selected_radio input[type=radio]')[0] || radios[0];
	
	radios.each(function(input)
	{
		input.observe('click', function()
		{
			switch_area(this);
		});
	});
	
	if (selected)
	{ 
		selected.checked = true;
		switch_area(selected);
	}
	
	$$('#TB_window .close_dialog').each(function(close) {
		close.observe('click', function(e)
		{
			if (parent && typeof(parent.tb_remove) == "function") {
				parent.tb_remove();
			}
			else if (typeof(tb_remove) == 'function') {
				tb_remove();
			}

			if (e)
			{
				e.stop();
			}
		});
	});
});