Element.addMethods('iframe', 
{
	document: function(element) {
		element = $(element);
		if (element.contentWindow)
			return element.contentWindow.document;
		else if (element.contentDocument)
			return element.contentDocument;
		else
			return null;
	},
	$: function(element, frameElement) { 
		element = $(element);
		var frameDocument = element.document();
		if (arguments.length > 2) {
			for (var i = 1, frameElements = [], length = arguments.length; i < length; i++)
				frameElements.push(element.$(arguments[i]));
			return frameElements;
		}
		if (Object.isString(frameElement))
			frameElement = frameDocument.getElementById(frameElement);
		return frameElement || element;
	}
});