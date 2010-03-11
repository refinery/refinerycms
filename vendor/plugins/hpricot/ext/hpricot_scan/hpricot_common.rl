%%{

  machine hpricot_common;

  #
  # HTML tokens
  # (a blatant rip from HTree)
  #
  newline = '\n' @{curline += 1;} ;
  NameChar = [\-A-Za-z0-9._:?] ;
  Name = [A-Za-z_:] NameChar* ;
  StartComment = "<!--" ;
  EndComment = "-->" ;
  StartCdata = "<![CDATA[" ;
  EndCdata = "]]>" ;

  NameCap = Name >_tag %tag;
  NameAttr = NameChar+ >_akey %akey ;
  Q1Char = ( "\\\'" | [^'] ) ;
  Q1Attr = Q1Char* >_aval %aval ;
  Q2Char = ( "\\\"" | [^"] ) ;
  Q2Attr = Q2Char* >_aval %aval ;
  UnqAttr = ( space >_aval | [^ \t\r\n<>"'] >_aval [^ \t\r\n<>]* %aunq ) ; 
  Nmtoken = NameChar+ >_akey %akey ;

  Attr =  NameAttr space* "=" space* ('"' Q2Attr '"' | "'" Q1Attr "'" | UnqAttr space+ ) space* ;
  AttrEnd = ( NameAttr space* "=" space* UnqAttr? | Nmtoken >new_attr %save_attr ) ;
  AttrSet = ( Attr >new_attr %save_attr | Nmtoken >new_attr space+ %save_attr ) ;
  StartTag = "<" NameCap space+ AttrSet* (AttrEnd >new_attr %save_attr)? ">" | "<" NameCap ">";
  EmptyTag = "<" NameCap space+ AttrSet* (AttrEnd >new_attr %save_attr)? "/>" | "<" NameCap "/>" ;

  EndTag = "</" NameCap space* ">" ;
  XmlVersionNum = [a-zA-Z0-9_.:\-]+ >_aval %xmlver ;
  XmlVersionInfo = space+ "version" space* "=" space* ("'" XmlVersionNum "'" | '"' XmlVersionNum '"' ) ;
  XmlEncName = [A-Za-z] >_aval [A-Za-z0-9._\-]* %xmlenc ;
  XmlEncodingDecl = space+ "encoding" space* "=" space* ("'" XmlEncName "'" | '"' XmlEncName '"' ) ;
  XmlYesNo = ("yes" | "no") >_aval %xmlsd ;
  XmlSDDecl = space+ "standalone" space* "=" space* ("'" XmlYesNo "'" | '"' XmlYesNo '"') ;
  XmlDecl = "<?xml" XmlVersionInfo XmlEncodingDecl? XmlSDDecl? space* "?"? ">" ;

  SystemLiteral = '"' [^"]* >_aval %sysid '"' | "'" [^']* >_aval %sysid "'" ;
  PubidLiteral = '"' [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]*  >_aval %pubid '"' |
    "'" [\t a-zA-Z0-9\-'()+,./:=?;!*\#@$_%]* >_aval %pubid "'" ;
  ExternalID = ( "SYSTEM" | "PUBLIC" space+ PubidLiteral ) (space+ SystemLiteral)? ;
  DocType = "<!DOCTYPE" space+ NameCap (space+ ExternalID)? space* ("[" [^\]]* "]" space*)? ">" ;
  StartXmlProcIns = "<?" Name >{ TEXT_PASS(); } space+ ;
  EndXmlProcIns = "?"? ">" ;

  html_comment := |*
    EndComment @{ EBLK(comment, 3); fgoto main; };
    any | newline { TEXT_PASS(); };
  *|;

  html_cdata := |*
    EndCdata @{ EBLK(cdata, 3); fgoto main; };
    any | newline { TEXT_PASS(); };
  *|;

  html_procins := |*
    EndXmlProcIns @{ EBLK(procins, 2); fgoto main; };
    any | newline { TEXT_PASS(); };
  *|;

  main := |*
    XmlDecl >newEle { ELE(xmldecl); };
    DocType >newEle { ELE(doctype); };
    StartXmlProcIns >newEle { fgoto html_procins; };
    StartTag >newEle { ELE(stag); };
    EndTag >newEle { ELE(etag); };
    EmptyTag >newEle { ELE(emptytag); };
    StartComment >newEle { fgoto html_comment; };
    StartCdata >newEle { fgoto html_cdata; };
    any | newline { TEXT_PASS(); };
  *|;

}%%;
