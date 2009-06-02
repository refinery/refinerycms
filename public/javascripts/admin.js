init_tooltips = function(){
	$$('a[title]').each(function(element)
	{
		new Tooltip(element, {mouseFollow:false, delay: 0, opacity: 1, appearDuration:0, hideDuration: 0, rounded: false});
	})
};

FastInit.addOnLoad(function()
{
	init_tooltips();
	// focus first field in an admin form.
	try{$(document.forms[0]).getInputs('text').first().focus();}catch(err){}

	$$('a([href*="dialog=true"])').each(function(anchor)
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
});