#= require codemirror/codemirror
#= require codemirror/xml

# Override the refinery skin for WYMeditor
skin = WYMeditor.SKINS["refinery"]

$.extend skin,
  super: skin.init,
  
  init: (wym) ->
    this.super(wym)
    textarea = wym._element.get(0)
    container = $(textarea).parent()
    mainPanel = $(".wym_area_main", container)    
    section = $("<div/>").addClass("wym_codemirror wym_section").appendTo(mainPanel)
    
    # build the codemirror textarea
    codemirror = CodeMirror.fromTextArea(textarea,
      lineNumbers: true
      matchBrackets: true
      mode: "text/html"
      enterMode: "keep"
      tabMode: "shift"
      htmlMode: true
      indentUnit: 2
      onChange: -> # keep wym updated     
        html = codemirror.getValue()
        wym.html(html)
    )
    
    # move the editor into the proper place
    $(".CodeMirror", container).detach().appendTo(section)
    
    # remove the textarea section
    $(".wym_html", container).remove()

    # click handler for the html button
    $(".wym_tools_html a").click ->
      $(".wym_iframe, .wym_codemirror", container).toggle()
      codemirror.refresh() # codemirror must be refreshed if it was hidden