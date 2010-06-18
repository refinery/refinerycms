WYMeditor.SKINS['refinery'] = {

	init: function(wym) {
		//render following sections as buttons
		$(wym._box).find(wym._options.toolsSelector)
			.addClass('wym_buttons');

		// auto add some margin to the main area sides if left area
		// or right area are not empty (if they contain sections)
		$(wym._box).find('div.wym_area_right ul')
			.parents('div.wym_area_right').show()
			.parents(wym._options.boxSelector)
			.find('div.wym_area_main')
			.css({'margin-right': '155px'});

		$(wym._box).find('div.wym_area_left ul')
			.parents('div.wym_area_left').show()
			.parents(wym._options.boxSelector)
			.find('div.wym_area_main')
			.css({'margin-left': '155px'});

		//make hover work under IE < 7
		$(wym._box).find('.wym_section').hover(function(){
			$(this).addClass('hover');
		},function(){
			$(this).removeClass('hover');
		});

    // adjust sizing
    $(wym._box).css('width', $(wym._element).width() - 2)
      .find('.wym_iframe iframe').css('width', $(wym._box).width() - 2);

		$('.button').corner('6px');
		$(".wym_area_top li>a").corner("2px");

		$(".wym_skin_refinery").animate({
			opacity: 1
		}, 800);
	}
};
