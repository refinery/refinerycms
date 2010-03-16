#line 1 "hpricot_scan.rl"
/*
 * hpricot_scan.rl
 *
 * $Author: why $
 * $Date: 2006-05-08 22:03:50 -0600 (Mon, 08 May 2006) $
 *
 * Copyright (C) 2006 why the lucky stiff
 */
#include <ruby.h>

#ifndef RARRAY_LEN
#define RARRAY_LEN(arr)  RARRAY(arr)->len
#define RSTRING_LEN(str) RSTRING(str)->len
#define RSTRING_PTR(str) RSTRING(str)->ptr
#endif

VALUE hpricot_css(VALUE, VALUE, VALUE, VALUE, VALUE);

#define NO_WAY_SERIOUSLY "*** This should not happen, please send a bug report with the HTML you're parsing to why@whytheluckystiff.net.  So sorry!"

static VALUE sym_xmldecl, sym_doctype, sym_procins, sym_stag, sym_etag, sym_emptytag, sym_comment,
      sym_cdata, sym_name, sym_parent, sym_raw_attributes, sym_raw_string, sym_tagno,
      sym_allowed, sym_text, sym_children, sym_EMPTY, sym_CDATA;
static VALUE mHpricot, rb_eHpricotParseError;
static VALUE cBogusETag, cCData, cComment, cDoc, cDocType, cElem, cText,
      cXMLDecl, cProcIns, symAllow, symDeny;
static ID s_ElementContent;
static ID s_downcase, s_new, s_parent, s_read, s_to_str;
static VALUE reProcInsParse;

#define H_ELE_TAG      0
#define H_ELE_PARENT   1
#define H_ELE_ATTR     2
#define H_ELE_ETAG     3
#define H_ELE_RAW      4
#define H_ELE_EC       5
#define H_ELE_HASH     6
#define H_ELE_CHILDREN 7

#define H_ELE_GET(ele, idx)      RSTRUCT_PTR(ele)[idx]
#define H_ELE_SET(ele, idx, val) RSTRUCT_PTR(ele)[idx] = val

#define OPT(opts, key) (!NIL_P(opts) && RTEST(rb_hash_aref(opts, ID2SYM(rb_intern("" # key)))))

#define ELE(N) \
  if (te > ts || text == 1) { \
    char *raw = NULL; \
    int rawlen = 0; \
    ele_open = 0; text = 0; \
    if (ts != 0 && sym_##N != sym_cdata && sym_##N != sym_text && sym_##N != sym_procins && sym_##N != sym_comment) { \
      raw = ts; rawlen = te - ts; \
    } \
    if (rb_block_given_p()) { \
      VALUE raw_string = Qnil; \
      if (raw != NULL) raw_string = rb_str_new(raw, rawlen); \
      rb_yield_tokens(sym_##N, tag, attr, Qnil, taint); \
    } else \
      rb_hpricot_token(S, sym_##N, tag, attr, raw, rawlen, taint); \
  }

#define SET(N, E) \
  if (mark_##N == NULL || E == mark_##N) \
    N = rb_str_new2(""); \
  else if (E > mark_##N) \
    N = rb_str_new(mark_##N, E - mark_##N);

#define CAT(N, E) if (NIL_P(N)) { SET(N, E); } else { rb_str_cat(N, mark_##N, E - mark_##N); }

#define SLIDE(N) if (mark_##N > ts) mark_##N = buf + (mark_##N - ts);

#define ATTR(K, V) \
    if (!NIL_P(K)) { \
      if (NIL_P(attr)) attr = rb_hash_new(); \
      rb_hash_aset(attr, K, V); \
    }

#define TEXT_PASS() \
    if (text == 0) \
    { \
      if (ele_open == 1) { \
        ele_open = 0; \
        if (ts > 0) { \
          mark_tag = ts; \
        } \
      } else { \
        mark_tag = p; \
      } \
      attr = Qnil; \
      tag = Qnil; \
      text = 1; \
    }

#define EBLK(N, T) CAT(tag, p - T + 1); ELE(N);

#line 142 "hpricot_scan.rl"



#line 101 "hpricot_scan.c"
static const int hpricot_scan_start = 204;
static const int hpricot_scan_error = -1;

static const int hpricot_scan_en_html_comment = 214;
static const int hpricot_scan_en_html_cdata = 216;
static const int hpricot_scan_en_html_procins = 218;
static const int hpricot_scan_en_main = 204;

#line 145 "hpricot_scan.rl"

#define BUFSIZE 16384

void rb_yield_tokens(VALUE sym, VALUE tag, VALUE attr, VALUE raw, int taint)
{
  VALUE ary;
  if (sym == sym_text) {
    raw = tag;
  }
  ary = rb_ary_new3(4, sym, tag, attr, raw);
  if (taint) {
    OBJ_TAINT(ary);
    OBJ_TAINT(tag);
    OBJ_TAINT(attr);
    OBJ_TAINT(raw);
  }
  rb_yield(ary);
}

#ifndef RHASH_TBL
/* rb_hash_lookup() is only in Ruby 1.8.7 */
static VALUE
our_rb_hash_lookup(VALUE hash, VALUE key)
{
  VALUE val;

  if (!st_lookup(RHASH(hash)->tbl, key, &val)) {
    return Qnil; /* without Hash#default */
  }

  return val;
}
#define rb_hash_lookup our_rb_hash_lookup
#endif

static void
rb_hpricot_add(VALUE focus, VALUE ele)
{
  VALUE children = H_ELE_GET(focus, H_ELE_CHILDREN);
  if (NIL_P(children))
    H_ELE_SET(focus, H_ELE_CHILDREN, (children = rb_ary_new2(1)));
  rb_ary_push(children, ele);
  H_ELE_SET(ele, H_ELE_PARENT, focus);
}

typedef struct {
  VALUE doc;
  VALUE focus;
  VALUE last;
  VALUE EC;
  unsigned char xml, strict, fixup;
} hpricot_state;

#define H_PROP(prop, idx) \
  static VALUE hpricot_ele_set_##prop(VALUE self, VALUE x) { \
    H_ELE_SET(self, idx, x); \
    return self; \
  } \
  static VALUE hpricot_ele_clear_##prop(VALUE self) { \
    H_ELE_SET(self, idx, Qnil); \
    return Qtrue; \
  } \
  static VALUE hpricot_ele_get_##prop(VALUE self) { \
    return H_ELE_GET(self, idx); \
  }

#define H_ATTR(prop) \
  static VALUE hpricot_ele_set_##prop(VALUE self, VALUE x) { \
    rb_hash_aset(H_ELE_GET(self, H_ELE_ATTR), ID2SYM(rb_intern("" # prop)), x); \
    return self; \
  } \
  static VALUE hpricot_ele_get_##prop(VALUE self) { \
    return rb_hash_aref(H_ELE_GET(self, H_ELE_ATTR), ID2SYM(rb_intern("" # prop))); \
  }

H_PROP(name, H_ELE_TAG);
H_PROP(raw, H_ELE_RAW);
H_PROP(parent, H_ELE_PARENT);
H_PROP(attr, H_ELE_ATTR);
H_PROP(etag, H_ELE_ETAG);
H_PROP(children, H_ELE_CHILDREN);
H_ATTR(target);
H_ATTR(encoding);
H_ATTR(version);
H_ATTR(standalone);
H_ATTR(system_id);
H_ATTR(public_id);

#define H_ELE(klass) \
  ele = rb_obj_alloc(klass); \
  if (klass == cElem) { \
    H_ELE_SET(ele, H_ELE_TAG, tag); \
    H_ELE_SET(ele, H_ELE_ATTR, attr); \
    H_ELE_SET(ele, H_ELE_EC, ec); \
    if (raw != NULL && (sym == sym_emptytag || sym == sym_stag || sym == sym_doctype)) { \
      H_ELE_SET(ele, H_ELE_RAW, rb_str_new(raw, rawlen)); \
    } \
  } else if (klass == cDocType || klass == cProcIns || klass == cXMLDecl || klass == cBogusETag) { \
    if (klass == cBogusETag) { \
      H_ELE_SET(ele, H_ELE_TAG, tag); \
      if (raw != NULL) \
        H_ELE_SET(ele, H_ELE_ATTR, rb_str_new(raw, rawlen)); \
    } else { \
      if (klass == cDocType) \
        ATTR(ID2SYM(rb_intern("target")), tag); \
      H_ELE_SET(ele, H_ELE_ATTR, attr); \
      if (klass != cProcIns) { \
        tag = Qnil; \
        if (raw != NULL) tag = rb_str_new(raw, rawlen); \
      } \
      H_ELE_SET(ele, H_ELE_TAG, tag); \
    } \
  } else { \
    H_ELE_SET(ele, H_ELE_TAG, tag); \
  } \
  S->last = ele

//
// the swift, compact parser logic.  most of the complicated stuff is done
// in the lexer.  this step just pairs up the start and end tags.
//
void
rb_hpricot_token(hpricot_state *S, VALUE sym, VALUE tag, VALUE attr, char *raw, int rawlen, int taint)
{
  VALUE ele, ec = Qnil;

  //
  // in html mode, fix up start tags incorrectly formed as empty tags
  //
  if (!S->xml) {
    if (sym == sym_emptytag || sym == sym_stag || sym == sym_etag) {
      ec = rb_hash_aref(S->EC, tag);
      if (NIL_P(ec)) {
        tag = rb_funcall(tag, s_downcase, 0);
        ec = rb_hash_aref(S->EC, tag);
      }
    }

    if (H_ELE_GET(S->focus, H_ELE_EC) == sym_CDATA &&
       (sym != sym_procins && sym != sym_comment && sym != sym_cdata && sym != sym_text) &&
      !(sym == sym_etag && INT2FIX(rb_str_hash(tag)) == H_ELE_GET(S->focus, H_ELE_HASH)))
    {
      sym = sym_text;
      tag = rb_str_new(raw, rawlen);
    }

    if (!NIL_P(ec)) {
      if (sym == sym_emptytag) {
        if (ec != sym_EMPTY)
          sym = sym_stag;
      } else if (sym == sym_stag) {
        if (ec == sym_EMPTY)
          sym = sym_emptytag;
      }
    }
  }

  if (sym == sym_emptytag || sym == sym_stag) {
    VALUE name = INT2FIX(rb_str_hash(tag));
    H_ELE(cElem);
    H_ELE_SET(ele, H_ELE_HASH, name);

    if (!S->xml) {
      VALUE match = Qnil, e = S->focus;
      while (e != S->doc)
      {
        VALUE hEC = H_ELE_GET(e, H_ELE_EC);

        if (TYPE(hEC) == T_HASH)
        {
          VALUE has = rb_hash_lookup(hEC, name);
          if (has != Qnil) {
            if (has == Qtrue) {
              if (match == Qnil)
                match = e;
            } else if (has == symAllow) {
              match = S->focus;
            } else if (has == symDeny) {
              match = Qnil;
            }
          }
        }

        e = H_ELE_GET(e, H_ELE_PARENT);
      }

      if (match == Qnil)
        match = S->focus;
      S->focus = match;
    }

    rb_hpricot_add(S->focus, ele);

    //
    // in the case of a start tag that should be empty, just
    // skip the step that focuses the element.  focusing moves
    // us deeper into the document.
    //
    if (sym == sym_stag) {
      if (S->xml || ec != sym_EMPTY) {
        S->focus = ele;
        S->last = Qnil;
      }
    }
  } else if (sym == sym_etag) {
    VALUE name, match = Qnil, e = S->focus;
    if (S->strict) {
      if (NIL_P(rb_hash_aref(S->EC, tag))) {
        tag = rb_str_new2("div");
      }
    }

    //
    // another optimization will be to improve this very simple
    // O(n) tag search, where n is the depth of the focused tag.
    //
    // (see also: the search above for fixups)
    //
    name = INT2FIX(rb_str_hash(tag));
    while (e != S->doc)
    {
      if (H_ELE_GET(e, H_ELE_HASH) == name)
      {
        match = e;
        break;
      }

      e = H_ELE_GET(e, H_ELE_PARENT);
    }

    if (NIL_P(match))
    {
      H_ELE(cBogusETag);
      rb_hpricot_add(S->focus, ele);
    }
    else
    {
      VALUE ele = Qnil;
      if (raw != NULL)
        ele = rb_str_new(raw, rawlen);
      H_ELE_SET(match, H_ELE_ETAG, ele);
      S->focus = H_ELE_GET(match, H_ELE_PARENT);
      S->last = Qnil;
    }
  } else if (sym == sym_cdata) {
    H_ELE(cCData);
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_comment) {
    H_ELE(cComment);
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_doctype) {
    H_ELE(cDocType);
    if (S->strict) {
      rb_hash_aset(attr, ID2SYM(rb_intern("system_id")), rb_str_new2("http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"));
      rb_hash_aset(attr, ID2SYM(rb_intern("public_id")), rb_str_new2("-//W3C//DTD XHTML 1.0 Strict//EN"));
    }
    rb_hpricot_add(S->focus, ele);
  } else if (sym == sym_procins) {
    VALUE match = rb_funcall(tag, rb_intern("match"), 1, reProcInsParse);
    tag = rb_reg_nth_match(1, match);
    attr = rb_reg_nth_match(2, match);
    {
      H_ELE(cProcIns);
      rb_hpricot_add(S->focus, ele);
    }
  } else if (sym == sym_text) {
    // TODO: add raw_string as well?
    if (!NIL_P(S->last) && RBASIC(S->last)->klass == cText) {
      rb_str_append(H_ELE_GET(S->last, H_ELE_TAG), tag);
    } else {
      H_ELE(cText);
      rb_hpricot_add(S->focus, ele);
    }
  } else if (sym == sym_xmldecl) {
    H_ELE(cXMLDecl);
    rb_hpricot_add(S->focus, ele);
  }
}

VALUE hpricot_scan(int argc, VALUE *argv, VALUE self)
{
  int cs, act, have = 0, nread = 0, curline = 1, text = 0, io = 0;
  char *ts = 0, *te = 0, *buf = NULL, *eof = NULL;

  hpricot_state *S = NULL;
  VALUE port, opts;
  VALUE attr = Qnil, tag = Qnil, akey = Qnil, aval = Qnil, bufsize = Qnil;
  char *mark_tag = 0, *mark_akey = 0, *mark_aval = 0;
  int done = 0, ele_open = 0, buffer_size = 0, taint = 0;

  rb_scan_args(argc, argv, "11", &port, &opts);
  taint = OBJ_TAINTED(port);
  io = rb_respond_to(port, s_read);
  if (!io)
  {
    if (rb_respond_to(port, s_to_str))
    {
      port = rb_funcall(port, s_to_str, 0);
      StringValue(port);
    }
    else
    {
      rb_raise(rb_eArgError, "an Hpricot document must be built from an input source (a String or IO object.)");
    }
  }

  if (TYPE(opts) != T_HASH)
    opts = Qnil;

  if (!rb_block_given_p())
  {
    S = ALLOC(hpricot_state);
    S->doc = rb_obj_alloc(cDoc);
    rb_gc_register_address(&S->doc);
    S->focus = S->doc;
    S->last = Qnil;
    S->xml = OPT(opts, xml);
    S->strict = OPT(opts, xhtml_strict);
    S->fixup = OPT(opts, fixup_tags);
    if (S->strict) S->fixup = 1;
    rb_ivar_set(S->doc, rb_intern("@options"), opts);

    S->EC = rb_const_get(mHpricot, s_ElementContent);
  }

  buffer_size = BUFSIZE;
  if (rb_ivar_defined(self, rb_intern("@buffer_size")) == Qtrue) {
    bufsize = rb_ivar_get(self, rb_intern("@buffer_size"));
    if (!NIL_P(bufsize)) {
      buffer_size = NUM2INT(bufsize);
    }
  }

  if (io)
    buf = ALLOC_N(char, buffer_size);

  
#line 448 "hpricot_scan.c"
	{
	cs = hpricot_scan_start;
	ts = 0;
	te = 0;
	act = 0;
	}
#line 482 "hpricot_scan.rl"

  while (!done) {
    VALUE str;
    char *p, *pe;
    int len, space = buffer_size - have, tokstart_diff, tokend_diff, mark_tag_diff, mark_akey_diff, mark_aval_diff;

    if (io)
    {
      if (space == 0) {
        /* We've used up the entire buffer storing an already-parsed token
         * prefix that must be preserved.  Likely caused by super-long attributes.
         * Increase buffer size and continue  */
         tokstart_diff = ts - buf;
         tokend_diff = te - buf;
         mark_tag_diff = mark_tag - buf;
         mark_akey_diff = mark_akey - buf;
         mark_aval_diff = mark_aval - buf;

         buffer_size += BUFSIZE;
         REALLOC_N(buf, char, buffer_size);

         space = buffer_size - have;

         ts = buf + tokstart_diff;
         te = buf + tokend_diff;
         mark_tag = buf + mark_tag_diff;
         mark_akey = buf + mark_akey_diff;
         mark_aval = buf + mark_aval_diff;
      }
      p = buf + have;

      str = rb_funcall(port, s_read, 1, INT2FIX(space));
      len = RSTRING_LEN(str);
      memcpy(p, StringValuePtr(str), len);
    }
    else
    {
      p = RSTRING_PTR(port);
      len = RSTRING_LEN(port) + 1;
      done = 1;
    }

    nread += len;

    /* If this is the last buffer, tack on an EOF. */
    if (io && len < space) {
      p[len++] = 0;
      done = 1;
    }

    pe = p + len;
    
#line 508 "hpricot_scan.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 73 "hpricot_scan.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	goto st204;
tr4:
#line 71 "hpricot_scan.rl"
	{te = p+1;{ {goto st214;} }}
	goto st204;
tr15:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
#line 66 "hpricot_scan.rl"
	{te = p+1;{ ELE(doctype); }}
	goto st204;
tr18:
#line 66 "hpricot_scan.rl"
	{te = p+1;{ ELE(doctype); }}
	goto st204;
tr39:
#line 1 "hpricot_scan.rl"
	{	switch( act ) {
	case 8:
	{{p = ((te))-1;} ELE(doctype); }
	break;
	case 10:
	{{p = ((te))-1;} ELE(stag); }
	break;
	case 12:
	{{p = ((te))-1;} ELE(emptytag); }
	break;
	case 15:
	{{p = ((te))-1;} TEXT_PASS(); }
	break;
	default: break;
	}
	}
	goto st204;
tr93:
#line 72 "hpricot_scan.rl"
	{te = p+1;{ {goto st216;} }}
	goto st204;
tr97:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
#line 69 "hpricot_scan.rl"
	{te = p+1;{ ELE(etag); }}
	goto st204;
tr99:
#line 69 "hpricot_scan.rl"
	{te = p+1;{ ELE(etag); }}
	goto st204;
tr103:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr107:
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr112:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr117:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr118:
#line 70 "hpricot_scan.rl"
	{te = p+1;{ ELE(emptytag); }}
	goto st204;
tr129:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr133:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr139:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{te = p+1;{ ELE(stag); }}
	goto st204;
tr349:
#line 67 "hpricot_scan.rl"
	{{p = ((te))-1;}{ {goto st218;} }}
	goto st204;
tr363:
#line 65 "hpricot_scan.rl"
	{te = p+1;{ ELE(xmldecl); }}
	goto st204;
tr411:
#line 73 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st204;
tr412:
#line 9 "hpricot_scan.rl"
	{curline += 1;}
#line 73 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st204;
tr414:
#line 73 "hpricot_scan.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	goto st204;
tr419:
#line 66 "hpricot_scan.rl"
	{te = p;p--;{ ELE(doctype); }}
	goto st204;
tr420:
#line 67 "hpricot_scan.rl"
	{te = p;p--;{ {goto st218;} }}
	goto st204;
st204:
#line 1 "hpricot_scan.rl"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof204;
case 204:
#line 1 "hpricot_scan.rl"
	{ts = p;}
#line 686 "hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr412;
		case 60: goto tr413;
	}
	goto tr411;
tr413:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 98 "hpricot_scan.rl"
	{
    if (text == 1) {
      CAT(tag, p);
      ELE(text);
      text = 0;
    }
    attr = Qnil;
    tag = Qnil;
    mark_tag = NULL;
    ele_open = 1;
  }
#line 73 "hpricot_scan.rl"
	{act = 15;}
	goto st205;
st205:
	if ( ++p == pe )
		goto _test_eof205;
case 205:
#line 714 "hpricot_scan.c"
	switch( (*p) ) {
		case 33: goto st0;
		case 47: goto st59;
		case 58: goto tr417;
		case 63: goto st145;
		case 95: goto tr417;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr417;
	} else if ( (*p) >= 65 )
		goto tr417;
	goto tr414;
st0:
	if ( ++p == pe )
		goto _test_eof0;
case 0:
	switch( (*p) ) {
		case 45: goto st1;
		case 68: goto st2;
		case 91: goto st53;
	}
	goto tr0;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
	if ( (*p) == 45 )
		goto tr4;
	goto tr0;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
	if ( (*p) == 79 )
		goto st3;
	goto tr0;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
	if ( (*p) == 67 )
		goto st4;
	goto tr0;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
	if ( (*p) == 84 )
		goto st5;
	goto tr0;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
	if ( (*p) == 89 )
		goto st6;
	goto tr0;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	if ( (*p) == 80 )
		goto st7;
	goto tr0;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	if ( (*p) == 69 )
		goto st8;
	goto tr0;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
	if ( (*p) == 32 )
		goto st9;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st9;
	goto tr0;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
	switch( (*p) ) {
		case 32: goto st9;
		case 58: goto tr12;
		case 95: goto tr12;
	}
	if ( (*p) < 65 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st9;
	} else if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr12;
	} else
		goto tr12;
	goto tr0;
tr12:
#line 110 "hpricot_scan.rl"
	{ mark_tag = p; }
	goto st10;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
#line 822 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr13;
		case 62: goto tr15;
		case 63: goto st10;
		case 91: goto tr16;
		case 95: goto st10;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st10;
		} else if ( (*p) >= 9 )
			goto tr13;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st10;
		} else if ( (*p) >= 65 )
			goto st10;
	} else
		goto st10;
	goto tr0;
tr13:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
	goto st11;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
#line 853 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st11;
		case 62: goto tr18;
		case 80: goto st12;
		case 83: goto st48;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st11;
	goto tr0;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
	if ( (*p) == 85 )
		goto st13;
	goto tr0;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	if ( (*p) == 66 )
		goto st14;
	goto tr0;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
	if ( (*p) == 76 )
		goto st15;
	goto tr0;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
	if ( (*p) == 73 )
		goto st16;
	goto tr0;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
	if ( (*p) == 67 )
		goto st17;
	goto tr0;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
	if ( (*p) == 32 )
		goto st18;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st18;
	goto tr0;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
	switch( (*p) ) {
		case 32: goto st18;
		case 34: goto st19;
		case 39: goto st30;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st18;
	goto tr0;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	switch( (*p) ) {
		case 9: goto tr30;
		case 34: goto tr31;
		case 61: goto tr30;
		case 95: goto tr30;
	}
	if ( (*p) < 39 ) {
		if ( 32 <= (*p) && (*p) <= 37 )
			goto tr30;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr30;
		} else if ( (*p) >= 63 )
			goto tr30;
	} else
		goto tr30;
	goto tr0;
tr30:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
#line 950 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st20;
		case 34: goto tr33;
		case 61: goto st20;
		case 95: goto st20;
	}
	if ( (*p) < 39 ) {
		if ( 32 <= (*p) && (*p) <= 37 )
			goto st20;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st20;
		} else if ( (*p) >= 63 )
			goto st20;
	} else
		goto st20;
	goto tr0;
tr31:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
	goto st21;
tr33:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
	goto st21;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
#line 983 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st22;
		case 62: goto tr18;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st22;
	goto tr0;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
	switch( (*p) ) {
		case 32: goto st22;
		case 34: goto st23;
		case 39: goto st28;
		case 62: goto tr18;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st22;
	goto tr0;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
	if ( (*p) == 34 )
		goto tr38;
	goto tr37;
tr37:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st24;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
#line 1021 "hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr41;
	goto st24;
tr38:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st25;
tr41:
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st25;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
#line 1039 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st25;
		case 62: goto tr18;
		case 91: goto st26;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st25;
	goto tr39;
tr16:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
	goto st26;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
#line 1056 "hpricot_scan.c"
	if ( (*p) == 93 )
		goto st27;
	goto st26;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	switch( (*p) ) {
		case 32: goto st27;
		case 62: goto tr18;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st27;
	goto tr39;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	if ( (*p) == 39 )
		goto tr38;
	goto tr44;
tr44:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st29;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
#line 1086 "hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr41;
	goto st29;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	switch( (*p) ) {
		case 9: goto tr46;
		case 39: goto tr47;
		case 61: goto tr46;
		case 95: goto tr46;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto tr46;
		} else if ( (*p) >= 32 )
			goto tr46;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr46;
		} else if ( (*p) >= 63 )
			goto tr46;
	} else
		goto tr46;
	goto tr0;
tr46:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st31;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
#line 1123 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st31;
		case 39: goto tr49;
		case 61: goto st31;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 32 )
			goto st31;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 63 )
			goto st31;
	} else
		goto st31;
	goto tr0;
tr47:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
	goto st32;
tr49:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
	goto st32;
tr55:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st32;
tr82:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st32;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
#line 1173 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st33;
		case 32: goto st33;
		case 33: goto st31;
		case 39: goto tr49;
		case 62: goto tr18;
		case 91: goto st26;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 10 )
			goto st22;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 61 )
			goto st31;
	} else
		goto st31;
	goto tr0;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	switch( (*p) ) {
		case 9: goto st33;
		case 32: goto st33;
		case 34: goto st23;
		case 39: goto tr51;
		case 62: goto tr18;
		case 91: goto st26;
		case 95: goto st31;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 33 <= (*p) && (*p) <= 37 )
				goto st31;
		} else if ( (*p) >= 10 )
			goto st22;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st31;
		} else if ( (*p) >= 61 )
			goto st31;
	} else
		goto st31;
	goto tr0;
tr51:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
	goto st34;
tr62:
#line 124 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st34;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
#line 1240 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto tr52;
		case 32: goto tr52;
		case 33: goto tr54;
		case 39: goto tr55;
		case 62: goto tr56;
		case 91: goto tr57;
		case 95: goto tr54;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto tr54;
		} else if ( (*p) >= 10 )
			goto tr53;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr54;
		} else if ( (*p) >= 61 )
			goto tr54;
	} else
		goto tr54;
	goto tr44;
tr52:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st35;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
#line 1273 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st35;
		case 32: goto st35;
		case 34: goto st37;
		case 39: goto tr62;
		case 62: goto tr63;
		case 91: goto st40;
		case 95: goto st47;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 13 ) {
			if ( 33 <= (*p) && (*p) <= 37 )
				goto st47;
		} else if ( (*p) >= 10 )
			goto st36;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st47;
		} else if ( (*p) >= 61 )
			goto st47;
	} else
		goto st47;
	goto st29;
tr53:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st36;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
#line 1306 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st36;
		case 34: goto st37;
		case 39: goto tr65;
		case 62: goto tr63;
		case 91: goto st40;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st36;
	goto st29;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	switch( (*p) ) {
		case 34: goto tr67;
		case 39: goto tr68;
	}
	goto tr66;
tr66:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st38;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
#line 1334 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr70;
		case 39: goto tr71;
	}
	goto st38;
tr81:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st39;
tr67:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st39;
tr70:
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st39;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
#line 1358 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st39;
		case 39: goto tr41;
		case 62: goto tr63;
		case 91: goto st40;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st39;
	goto st29;
tr56:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 66 "hpricot_scan.rl"
	{act = 8;}
	goto st206;
tr63:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 66 "hpricot_scan.rl"
	{act = 8;}
	goto st206;
st206:
	if ( ++p == pe )
		goto _test_eof206;
case 206:
#line 1386 "hpricot_scan.c"
	if ( (*p) == 39 )
		goto tr41;
	goto st29;
tr57:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st40;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
#line 1398 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr73;
		case 93: goto st42;
	}
	goto st40;
tr73:
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
#line 1412 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st41;
		case 62: goto tr76;
		case 93: goto st27;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st41;
	goto st26;
tr76:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 66 "hpricot_scan.rl"
	{act = 8;}
	goto st207;
st207:
	if ( ++p == pe )
		goto _test_eof207;
case 207:
#line 1431 "hpricot_scan.c"
	if ( (*p) == 93 )
		goto st27;
	goto st26;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
	switch( (*p) ) {
		case 32: goto st42;
		case 39: goto tr41;
		case 62: goto tr63;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st42;
	goto st29;
tr68:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st43;
tr71:
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st43;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
#line 1461 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st43;
		case 34: goto tr41;
		case 62: goto tr78;
		case 91: goto st44;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st43;
	goto st24;
tr78:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 66 "hpricot_scan.rl"
	{act = 8;}
	goto st208;
st208:
	if ( ++p == pe )
		goto _test_eof208;
case 208:
#line 1481 "hpricot_scan.c"
	if ( (*p) == 34 )
		goto tr41;
	goto st24;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
	switch( (*p) ) {
		case 34: goto tr73;
		case 93: goto st45;
	}
	goto st44;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
	switch( (*p) ) {
		case 32: goto st45;
		case 34: goto tr41;
		case 62: goto tr78;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st45;
	goto st24;
tr65:
#line 125 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }
	goto st46;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
#line 1514 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr81;
		case 39: goto tr38;
		case 62: goto tr56;
		case 91: goto tr57;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr81;
	goto tr44;
tr54:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st47;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
#line 1532 "hpricot_scan.c"
	switch( (*p) ) {
		case 9: goto st47;
		case 39: goto tr82;
		case 61: goto st47;
		case 95: goto st47;
	}
	if ( (*p) < 40 ) {
		if ( (*p) > 33 ) {
			if ( 35 <= (*p) && (*p) <= 37 )
				goto st47;
		} else if ( (*p) >= 32 )
			goto st47;
	} else if ( (*p) > 59 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st47;
		} else if ( (*p) >= 63 )
			goto st47;
	} else
		goto st47;
	goto st29;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	if ( (*p) == 89 )
		goto st49;
	goto tr0;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	if ( (*p) == 83 )
		goto st50;
	goto tr0;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
	if ( (*p) == 84 )
		goto st51;
	goto tr0;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	if ( (*p) == 69 )
		goto st52;
	goto tr0;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	if ( (*p) == 77 )
		goto st21;
	goto tr0;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
	if ( (*p) == 67 )
		goto st54;
	goto tr0;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
	if ( (*p) == 68 )
		goto st55;
	goto tr0;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
	if ( (*p) == 65 )
		goto st56;
	goto tr0;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
	if ( (*p) == 84 )
		goto st57;
	goto tr0;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
	if ( (*p) == 65 )
		goto st58;
	goto tr0;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
	if ( (*p) == 91 )
		goto tr93;
	goto tr0;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
	switch( (*p) ) {
		case 58: goto tr94;
		case 95: goto tr94;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr94;
	} else if ( (*p) >= 65 )
		goto tr94;
	goto tr0;
tr94:
#line 110 "hpricot_scan.rl"
	{ mark_tag = p; }
	goto st60;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
#line 1653 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr95;
		case 62: goto tr97;
		case 63: goto st60;
		case 95: goto st60;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st60;
		} else if ( (*p) >= 9 )
			goto tr95;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st60;
		} else if ( (*p) >= 65 )
			goto st60;
	} else
		goto st60;
	goto tr0;
tr95:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
	goto st61;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
#line 1683 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st61;
		case 62: goto tr99;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st61;
	goto tr0;
tr417:
#line 110 "hpricot_scan.rl"
	{ mark_tag = p; }
	goto st62;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
#line 1699 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr100;
		case 47: goto tr102;
		case 62: goto tr103;
		case 63: goto st62;
		case 95: goto st62;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr100;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st62;
		} else if ( (*p) >= 65 )
			goto st62;
	} else
		goto st62;
	goto tr0;
tr100:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
	goto st63;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
#line 1727 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st63;
		case 47: goto st66;
		case 62: goto tr107;
		case 63: goto tr105;
		case 95: goto tr105;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st63;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr105;
		} else if ( (*p) >= 65 )
			goto tr105;
	} else
		goto tr105;
	goto tr0;
tr105:
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st64;
tr114:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st64;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
#line 1779 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr108;
		case 47: goto tr110;
		case 61: goto tr111;
		case 62: goto tr112;
		case 63: goto st64;
		case 95: goto st64;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr108;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st64;
		} else if ( (*p) >= 65 )
			goto st64;
	} else
		goto st64;
	goto tr39;
tr108:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st65;
tr140:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st65;
tr134:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st65;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
#line 1824 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st65;
		case 47: goto tr115;
		case 61: goto st67;
		case 62: goto tr117;
		case 63: goto tr114;
		case 95: goto tr114;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st65;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr114;
		} else if ( (*p) >= 65 )
			goto tr114;
	} else
		goto tr114;
	goto tr39;
tr102:
#line 113 "hpricot_scan.rl"
	{ SET(tag, p); }
	goto st66;
tr110:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st66;
tr115:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st66;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
#line 1871 "hpricot_scan.c"
	if ( (*p) == 62 )
		goto tr118;
	goto tr39;
tr111:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st67;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
#line 1883 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr120;
		case 32: goto tr120;
		case 34: goto st142;
		case 39: goto st143;
		case 47: goto tr124;
		case 60: goto tr39;
		case 62: goto tr117;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr121;
	} else if ( (*p) >= 9 )
		goto tr120;
	goto tr119;
tr119:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st68;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
#line 1907 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr126;
		case 32: goto tr126;
		case 47: goto tr128;
		case 60: goto tr39;
		case 62: goto tr129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr127;
	} else if ( (*p) >= 9 )
		goto tr126;
	goto st68;
tr126:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st69;
tr331:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st69;
tr169:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st69;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
#line 1942 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st69;
		case 47: goto tr115;
		case 62: goto tr117;
		case 63: goto tr114;
		case 95: goto tr114;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st69;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr114;
		} else if ( (*p) >= 65 )
			goto tr114;
	} else
		goto tr114;
	goto tr39;
tr127:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st70;
tr155:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st70;
tr163:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st70;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
#line 1983 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr126;
		case 32: goto tr126;
		case 47: goto tr132;
		case 60: goto tr39;
		case 62: goto tr133;
		case 63: goto tr131;
		case 95: goto tr131;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr127;
		} else if ( (*p) >= 9 )
			goto tr126;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr131;
		} else if ( (*p) >= 65 )
			goto tr131;
	} else
		goto tr131;
	goto st68;
tr131:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st71;
tr150:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st71;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
#line 2048 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr134;
		case 32: goto tr134;
		case 47: goto tr137;
		case 60: goto tr39;
		case 61: goto tr138;
		case 62: goto tr139;
		case 63: goto st71;
		case 95: goto st71;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr135;
		} else if ( (*p) >= 9 )
			goto tr134;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st71;
		} else if ( (*p) >= 65 )
			goto st71;
	} else
		goto st71;
	goto st68;
tr141:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st72;
tr135:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st72;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
#line 2094 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr140;
		case 32: goto tr140;
		case 47: goto tr132;
		case 60: goto tr39;
		case 61: goto st74;
		case 62: goto tr133;
		case 63: goto tr131;
		case 95: goto tr131;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr141;
		} else if ( (*p) >= 9 )
			goto tr140;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr131;
		} else if ( (*p) >= 65 )
			goto tr131;
	} else
		goto tr131;
	goto st68;
tr124:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st73;
tr128:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st73;
tr132:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st73;
tr137:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st73;
tr147:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st73;
tr151:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st73;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
#line 2205 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr126;
		case 32: goto tr126;
		case 47: goto tr128;
		case 60: goto tr39;
		case 62: goto tr129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr127;
	} else if ( (*p) >= 9 )
		goto tr126;
	goto st68;
tr121:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st74;
tr138:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st74;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
#line 2231 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr143;
		case 32: goto tr143;
		case 34: goto st77;
		case 39: goto st141;
		case 47: goto tr147;
		case 60: goto tr39;
		case 62: goto tr129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr144;
	} else if ( (*p) >= 9 )
		goto tr143;
	goto tr119;
tr148:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st75;
tr143:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st75;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
#line 2264 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr148;
		case 32: goto tr148;
		case 34: goto st142;
		case 39: goto st143;
		case 47: goto tr124;
		case 60: goto tr39;
		case 62: goto tr117;
		case 63: goto tr150;
		case 95: goto tr150;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr149;
		} else if ( (*p) >= 9 )
			goto tr148;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr150;
		} else if ( (*p) >= 65 )
			goto tr150;
	} else
		goto tr150;
	goto tr119;
tr149:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st76;
tr144:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st76;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
#line 2308 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr143;
		case 32: goto tr143;
		case 34: goto st77;
		case 39: goto st141;
		case 47: goto tr151;
		case 60: goto tr39;
		case 62: goto tr133;
		case 63: goto tr150;
		case 95: goto tr150;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr144;
		} else if ( (*p) >= 9 )
			goto tr143;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr150;
		} else if ( (*p) >= 65 )
			goto tr150;
	} else
		goto tr150;
	goto tr119;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
	switch( (*p) ) {
		case 13: goto tr153;
		case 32: goto tr153;
		case 34: goto tr155;
		case 47: goto tr156;
		case 60: goto tr157;
		case 62: goto tr158;
		case 92: goto tr159;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr154;
	} else if ( (*p) >= 9 )
		goto tr153;
	goto tr152;
tr152:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st78;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
#line 2362 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr161;
		case 32: goto tr161;
		case 34: goto tr163;
		case 47: goto tr164;
		case 60: goto st80;
		case 62: goto tr166;
		case 92: goto st94;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr162;
	} else if ( (*p) >= 9 )
		goto tr161;
	goto st78;
tr336:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st79;
tr161:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st79;
tr153:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st79;
tr317:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st79;
tr174:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st79;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
#line 2412 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st79;
		case 34: goto tr169;
		case 47: goto tr171;
		case 62: goto tr172;
		case 63: goto tr170;
		case 92: goto st81;
		case 95: goto tr170;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st79;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr170;
		} else if ( (*p) >= 65 )
			goto tr170;
	} else
		goto tr170;
	goto st80;
tr157:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st80;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
#line 2442 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr169;
		case 92: goto st81;
	}
	goto st80;
tr340:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st81;
st81:
	if ( ++p == pe )
		goto _test_eof81;
case 81:
#line 2456 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr174;
		case 92: goto st81;
	}
	goto st80;
tr170:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st82;
tr337:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st82;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
#line 2502 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr175;
		case 34: goto tr169;
		case 47: goto tr177;
		case 61: goto tr178;
		case 62: goto tr179;
		case 63: goto st82;
		case 92: goto st81;
		case 95: goto st82;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr175;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st82;
		} else if ( (*p) >= 65 )
			goto st82;
	} else
		goto st82;
	goto st80;
tr175:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st83;
tr206:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st83;
tr200:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st83;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
#line 2549 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st83;
		case 34: goto tr169;
		case 47: goto tr171;
		case 61: goto st85;
		case 62: goto tr172;
		case 63: goto tr170;
		case 92: goto st81;
		case 95: goto tr170;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st83;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr170;
		} else if ( (*p) >= 65 )
			goto tr170;
	} else
		goto tr170;
	goto st80;
tr177:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st84;
tr171:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st84;
tr338:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st84;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
#line 2604 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr169;
		case 62: goto tr182;
		case 92: goto st81;
	}
	goto st80;
tr158:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr166:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr172:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr179:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr182:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 70 "hpricot_scan.rl"
	{act = 12;}
	goto st209;
tr196:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr197:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr205:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
tr339:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st209;
st209:
	if ( ++p == pe )
		goto _test_eof209;
case 209:
#line 2752 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr169;
		case 92: goto st81;
	}
	goto st80;
tr178:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st85;
st85:
	if ( ++p == pe )
		goto _test_eof85;
case 85:
#line 2766 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr183;
		case 32: goto tr183;
		case 34: goto tr185;
		case 39: goto st140;
		case 47: goto tr187;
		case 60: goto st80;
		case 62: goto tr172;
		case 92: goto tr159;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr184;
	} else if ( (*p) >= 9 )
		goto tr183;
	goto tr152;
tr183:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st86;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
#line 2791 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr188;
		case 32: goto tr188;
		case 34: goto tr185;
		case 39: goto st140;
		case 47: goto tr187;
		case 60: goto st80;
		case 62: goto tr172;
		case 92: goto tr159;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr189;
	} else if ( (*p) >= 9 )
		goto tr188;
	goto tr152;
tr188:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st87;
tr191:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st87;
st87:
	if ( ++p == pe )
		goto _test_eof87;
case 87:
#line 2825 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr188;
		case 32: goto tr188;
		case 34: goto tr185;
		case 39: goto st140;
		case 47: goto tr187;
		case 60: goto st80;
		case 62: goto tr172;
		case 63: goto tr190;
		case 92: goto tr159;
		case 95: goto tr190;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr189;
		} else if ( (*p) >= 9 )
			goto tr188;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr190;
		} else if ( (*p) >= 65 )
			goto tr190;
	} else
		goto tr190;
	goto tr152;
tr189:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st88;
tr192:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st88;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
#line 2870 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr191;
		case 32: goto tr191;
		case 34: goto tr193;
		case 39: goto st96;
		case 47: goto tr195;
		case 60: goto st80;
		case 62: goto tr196;
		case 63: goto tr190;
		case 92: goto tr159;
		case 95: goto tr190;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr192;
		} else if ( (*p) >= 9 )
			goto tr191;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr190;
		} else if ( (*p) >= 65 )
			goto tr190;
	} else
		goto tr190;
	goto tr152;
tr193:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st89;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
#line 2906 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr153;
		case 32: goto tr153;
		case 34: goto tr155;
		case 47: goto tr195;
		case 60: goto tr157;
		case 62: goto tr197;
		case 63: goto tr190;
		case 92: goto tr159;
		case 95: goto tr190;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr154;
		} else if ( (*p) >= 9 )
			goto tr153;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr190;
		} else if ( (*p) >= 65 )
			goto tr190;
	} else
		goto tr190;
	goto tr152;
tr162:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st90;
tr154:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st90;
tr214:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st90;
tr209:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st90;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
#line 2963 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr161;
		case 32: goto tr161;
		case 34: goto tr163;
		case 47: goto tr199;
		case 60: goto st80;
		case 62: goto tr196;
		case 63: goto tr198;
		case 92: goto st94;
		case 95: goto tr198;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr162;
		} else if ( (*p) >= 9 )
			goto tr161;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr198;
		} else if ( (*p) >= 65 )
			goto tr198;
	} else
		goto tr198;
	goto st78;
tr198:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st91;
tr190:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st91;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
#line 3030 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr200;
		case 32: goto tr200;
		case 34: goto tr163;
		case 47: goto tr203;
		case 60: goto st80;
		case 61: goto tr204;
		case 62: goto tr205;
		case 63: goto st91;
		case 92: goto st94;
		case 95: goto st91;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr201;
		} else if ( (*p) >= 9 )
			goto tr200;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st91;
		} else if ( (*p) >= 65 )
			goto st91;
	} else
		goto st91;
	goto st78;
tr207:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st92;
tr201:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st92;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
#line 3078 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr206;
		case 32: goto tr206;
		case 34: goto tr163;
		case 47: goto tr199;
		case 60: goto st80;
		case 61: goto st95;
		case 62: goto tr196;
		case 63: goto tr198;
		case 92: goto st94;
		case 95: goto tr198;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr207;
		} else if ( (*p) >= 9 )
			goto tr206;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr198;
		} else if ( (*p) >= 65 )
			goto tr198;
	} else
		goto tr198;
	goto st78;
tr187:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st93;
tr164:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st93;
tr199:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st93;
tr203:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st93;
tr156:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st93;
tr195:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st93;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
#line 3191 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr161;
		case 32: goto tr161;
		case 34: goto tr163;
		case 47: goto tr164;
		case 60: goto st80;
		case 62: goto tr166;
		case 92: goto st94;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr162;
	} else if ( (*p) >= 9 )
		goto tr161;
	goto st78;
tr159:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st94;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
#line 3215 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr161;
		case 32: goto tr161;
		case 34: goto tr209;
		case 47: goto tr164;
		case 60: goto st80;
		case 62: goto tr166;
		case 92: goto st94;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr162;
	} else if ( (*p) >= 9 )
		goto tr161;
	goto st78;
tr184:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st95;
tr204:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st95;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
#line 3243 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr191;
		case 32: goto tr191;
		case 34: goto tr193;
		case 39: goto st96;
		case 47: goto tr156;
		case 60: goto st80;
		case 62: goto tr166;
		case 92: goto tr159;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr192;
	} else if ( (*p) >= 9 )
		goto tr191;
	goto tr152;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
	switch( (*p) ) {
		case 13: goto tr211;
		case 32: goto tr211;
		case 34: goto tr213;
		case 39: goto tr214;
		case 47: goto tr215;
		case 60: goto tr216;
		case 62: goto tr217;
		case 92: goto tr218;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr212;
	} else if ( (*p) >= 9 )
		goto tr211;
	goto tr210;
tr210:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st97;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
#line 3288 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr220;
		case 32: goto tr220;
		case 34: goto tr222;
		case 39: goto tr209;
		case 47: goto tr223;
		case 60: goto st99;
		case 62: goto tr225;
		case 92: goto st129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr221;
	} else if ( (*p) >= 9 )
		goto tr220;
	goto st97;
tr315:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st98;
tr220:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st98;
tr211:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st98;
tr299:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st98;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
#line 3333 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st98;
		case 34: goto tr228;
		case 39: goto tr174;
		case 47: goto tr230;
		case 62: goto tr231;
		case 63: goto tr229;
		case 92: goto st122;
		case 95: goto tr229;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st98;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr229;
		} else if ( (*p) >= 65 )
			goto tr229;
	} else
		goto tr229;
	goto st99;
tr216:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st99;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
#line 3364 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr228;
		case 39: goto tr174;
		case 92: goto st122;
	}
	goto st99;
tr330:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st100;
tr255:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st100;
tr326:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st100;
tr316:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st100;
tr228:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st100;
tr322:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st100;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
#line 3411 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st100;
		case 39: goto tr169;
		case 47: goto tr236;
		case 62: goto tr237;
		case 63: goto tr235;
		case 92: goto st102;
		case 95: goto tr235;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st100;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr235;
		} else if ( (*p) >= 65 )
			goto tr235;
	} else
		goto tr235;
	goto st101;
tr328:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st101;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
#line 3441 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr169;
		case 92: goto st102;
	}
	goto st101;
tr335:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st102;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
#line 3455 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr228;
		case 92: goto st102;
	}
	goto st101;
tr235:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st103;
tr332:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st103;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
#line 3501 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr239;
		case 39: goto tr169;
		case 47: goto tr241;
		case 61: goto tr242;
		case 62: goto tr243;
		case 63: goto st103;
		case 92: goto st102;
		case 95: goto st103;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr239;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st103;
		} else if ( (*p) >= 65 )
			goto st103;
	} else
		goto st103;
	goto st101;
tr239:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st104;
tr269:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st104;
tr263:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st104;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
#line 3548 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st104;
		case 39: goto tr169;
		case 47: goto tr236;
		case 61: goto st106;
		case 62: goto tr237;
		case 63: goto tr235;
		case 92: goto st102;
		case 95: goto tr235;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st104;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr235;
		} else if ( (*p) >= 65 )
			goto tr235;
	} else
		goto tr235;
	goto st101;
tr241:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st105;
tr236:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st105;
tr333:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st105;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
#line 3603 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr169;
		case 62: goto tr246;
		case 92: goto st102;
	}
	goto st101;
tr341:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr258:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr237:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr243:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr246:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 70 "hpricot_scan.rl"
	{act = 12;}
	goto st210;
tr262:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr329:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr268:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
tr334:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st210;
st210:
	if ( ++p == pe )
		goto _test_eof210;
case 210:
#line 3751 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr169;
		case 92: goto st102;
	}
	goto st101;
tr242:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st106;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
#line 3765 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr248;
		case 32: goto tr248;
		case 34: goto st136;
		case 39: goto tr251;
		case 47: goto tr252;
		case 60: goto st101;
		case 62: goto tr237;
		case 92: goto tr253;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr249;
	} else if ( (*p) >= 9 )
		goto tr248;
	goto tr247;
tr247:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st107;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
#line 3790 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr255;
		case 32: goto tr255;
		case 39: goto tr163;
		case 47: goto tr257;
		case 60: goto st101;
		case 62: goto tr258;
		case 92: goto st112;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr256;
	} else if ( (*p) >= 9 )
		goto tr255;
	goto st107;
tr256:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st108;
tr327:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st108;
tr281:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st108;
tr222:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st108;
tr213:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st108;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
#line 3842 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr255;
		case 32: goto tr255;
		case 39: goto tr163;
		case 47: goto tr261;
		case 60: goto st101;
		case 62: goto tr262;
		case 63: goto tr260;
		case 92: goto st112;
		case 95: goto tr260;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr256;
		} else if ( (*p) >= 9 )
			goto tr255;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr260;
		} else if ( (*p) >= 65 )
			goto tr260;
	} else
		goto tr260;
	goto st107;
tr260:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st109;
tr279:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st109;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
#line 3909 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr263;
		case 32: goto tr263;
		case 39: goto tr163;
		case 47: goto tr266;
		case 60: goto st101;
		case 61: goto tr267;
		case 62: goto tr268;
		case 63: goto st109;
		case 92: goto st112;
		case 95: goto st109;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr264;
		} else if ( (*p) >= 9 )
			goto tr263;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st109;
		} else if ( (*p) >= 65 )
			goto st109;
	} else
		goto st109;
	goto st107;
tr270:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st110;
tr264:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st110;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
#line 3957 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr269;
		case 32: goto tr269;
		case 39: goto tr163;
		case 47: goto tr261;
		case 60: goto st101;
		case 61: goto st113;
		case 62: goto tr262;
		case 63: goto tr260;
		case 92: goto st112;
		case 95: goto tr260;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr270;
		} else if ( (*p) >= 9 )
			goto tr269;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr260;
		} else if ( (*p) >= 65 )
			goto tr260;
	} else
		goto tr260;
	goto st107;
tr252:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st111;
tr257:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st111;
tr261:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st111;
tr266:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st111;
tr276:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st111;
tr280:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st111;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
#line 4070 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr255;
		case 32: goto tr255;
		case 39: goto tr163;
		case 47: goto tr257;
		case 60: goto st101;
		case 62: goto tr258;
		case 92: goto st112;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr256;
	} else if ( (*p) >= 9 )
		goto tr255;
	goto st107;
tr253:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st112;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
#line 4094 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr255;
		case 32: goto tr255;
		case 39: goto tr222;
		case 47: goto tr257;
		case 60: goto st101;
		case 62: goto tr258;
		case 92: goto st112;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr256;
	} else if ( (*p) >= 9 )
		goto tr255;
	goto st107;
tr249:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st113;
tr267:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st113;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
#line 4122 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr272;
		case 32: goto tr272;
		case 34: goto st116;
		case 39: goto tr275;
		case 47: goto tr276;
		case 60: goto st101;
		case 62: goto tr258;
		case 92: goto tr253;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr273;
	} else if ( (*p) >= 9 )
		goto tr272;
	goto tr247;
tr277:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st114;
tr272:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st114;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
#line 4156 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr277;
		case 32: goto tr277;
		case 34: goto st136;
		case 39: goto tr251;
		case 47: goto tr252;
		case 60: goto st101;
		case 62: goto tr237;
		case 63: goto tr279;
		case 92: goto tr253;
		case 95: goto tr279;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr278;
		} else if ( (*p) >= 9 )
			goto tr277;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr279;
		} else if ( (*p) >= 65 )
			goto tr279;
	} else
		goto tr279;
	goto tr247;
tr278:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st115;
tr273:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st115;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
#line 4201 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr272;
		case 32: goto tr272;
		case 34: goto st116;
		case 39: goto tr275;
		case 47: goto tr280;
		case 60: goto st101;
		case 62: goto tr262;
		case 63: goto tr279;
		case 92: goto tr253;
		case 95: goto tr279;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr273;
		} else if ( (*p) >= 9 )
			goto tr272;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr279;
		} else if ( (*p) >= 65 )
			goto tr279;
	} else
		goto tr279;
	goto tr247;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
	switch( (*p) ) {
		case 13: goto tr211;
		case 32: goto tr211;
		case 34: goto tr281;
		case 39: goto tr214;
		case 47: goto tr215;
		case 60: goto tr216;
		case 62: goto tr217;
		case 92: goto tr218;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr212;
	} else if ( (*p) >= 9 )
		goto tr211;
	goto tr210;
tr221:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st117;
tr212:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st117;
tr314:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st117;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
#line 4273 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr220;
		case 32: goto tr220;
		case 34: goto tr222;
		case 39: goto tr209;
		case 47: goto tr283;
		case 60: goto st99;
		case 62: goto tr284;
		case 63: goto tr282;
		case 92: goto st129;
		case 95: goto tr282;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr221;
		} else if ( (*p) >= 9 )
			goto tr220;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr282;
		} else if ( (*p) >= 65 )
			goto tr282;
	} else
		goto tr282;
	goto st97;
tr282:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st118;
tr307:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st118;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
#line 4341 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr285;
		case 32: goto tr285;
		case 34: goto tr222;
		case 39: goto tr209;
		case 47: goto tr288;
		case 60: goto st99;
		case 61: goto tr289;
		case 62: goto tr290;
		case 63: goto st118;
		case 92: goto st129;
		case 95: goto st118;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr286;
		} else if ( (*p) >= 9 )
			goto tr285;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st118;
		} else if ( (*p) >= 65 )
			goto st118;
	} else
		goto st118;
	goto st97;
tr293:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st119;
tr323:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st119;
tr285:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st119;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
#line 4394 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st119;
		case 34: goto tr228;
		case 39: goto tr174;
		case 47: goto tr230;
		case 61: goto st123;
		case 62: goto tr231;
		case 63: goto tr229;
		case 92: goto st122;
		case 95: goto tr229;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto st119;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr229;
		} else if ( (*p) >= 65 )
			goto tr229;
	} else
		goto tr229;
	goto st99;
tr229:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st120;
tr318:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 127 "hpricot_scan.rl"
	{
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }
#line 112 "hpricot_scan.rl"
	{ mark_akey = p; }
	goto st120;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
#line 4458 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr293;
		case 34: goto tr228;
		case 39: goto tr174;
		case 47: goto tr295;
		case 61: goto tr296;
		case 62: goto tr297;
		case 63: goto st120;
		case 92: goto st122;
		case 95: goto st120;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr293;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st120;
		} else if ( (*p) >= 65 )
			goto st120;
	} else
		goto st120;
	goto st99;
tr295:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st121;
tr230:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st121;
tr319:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st121;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
#line 4514 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr228;
		case 39: goto tr174;
		case 62: goto tr298;
		case 92: goto st122;
	}
	goto st99;
tr217:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr225:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr231:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr297:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr298:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 70 "hpricot_scan.rl"
	{act = 12;}
	goto st211;
tr284:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr313:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr290:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
tr320:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 68 "hpricot_scan.rl"
	{act = 10;}
	goto st211;
st211:
	if ( ++p == pe )
		goto _test_eof211;
case 211:
#line 4663 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr228;
		case 39: goto tr174;
		case 92: goto st122;
	}
	goto st99;
tr321:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st122;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
#line 4678 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr299;
		case 39: goto tr299;
		case 92: goto st122;
	}
	goto st99;
tr296:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st123;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
#line 4693 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr300;
		case 32: goto tr300;
		case 34: goto tr302;
		case 39: goto tr303;
		case 47: goto tr304;
		case 60: goto st99;
		case 62: goto tr231;
		case 92: goto tr218;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr301;
	} else if ( (*p) >= 9 )
		goto tr300;
	goto tr210;
tr300:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st124;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
#line 4718 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr305;
		case 32: goto tr305;
		case 34: goto tr302;
		case 39: goto tr303;
		case 47: goto tr304;
		case 60: goto st99;
		case 62: goto tr231;
		case 92: goto tr218;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr306;
	} else if ( (*p) >= 9 )
		goto tr305;
	goto tr210;
tr305:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st125;
tr308:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st125;
st125:
	if ( ++p == pe )
		goto _test_eof125;
case 125:
#line 4752 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr305;
		case 32: goto tr305;
		case 34: goto tr302;
		case 39: goto tr303;
		case 47: goto tr304;
		case 60: goto st99;
		case 62: goto tr231;
		case 63: goto tr307;
		case 92: goto tr218;
		case 95: goto tr307;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr306;
		} else if ( (*p) >= 9 )
			goto tr305;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr307;
		} else if ( (*p) >= 65 )
			goto tr307;
	} else
		goto tr307;
	goto tr210;
tr306:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st126;
tr309:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st126;
st126:
	if ( ++p == pe )
		goto _test_eof126;
case 126:
#line 4797 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr308;
		case 32: goto tr308;
		case 34: goto tr310;
		case 39: goto tr311;
		case 47: goto tr312;
		case 60: goto st99;
		case 62: goto tr284;
		case 63: goto tr307;
		case 92: goto tr218;
		case 95: goto tr307;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr309;
		} else if ( (*p) >= 9 )
			goto tr308;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr307;
		} else if ( (*p) >= 65 )
			goto tr307;
	} else
		goto tr307;
	goto tr210;
tr310:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st127;
st127:
	if ( ++p == pe )
		goto _test_eof127;
case 127:
#line 4833 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr211;
		case 32: goto tr211;
		case 34: goto tr281;
		case 39: goto tr214;
		case 47: goto tr312;
		case 60: goto tr216;
		case 62: goto tr313;
		case 63: goto tr307;
		case 92: goto tr218;
		case 95: goto tr307;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr212;
		} else if ( (*p) >= 9 )
			goto tr211;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr307;
		} else if ( (*p) >= 65 )
			goto tr307;
	} else
		goto tr307;
	goto tr210;
tr304:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st128;
tr223:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st128;
tr283:
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st128;
tr288:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st128;
tr215:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
	goto st128;
tr312:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
#line 134 "hpricot_scan.rl"
	{
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st128;
st128:
	if ( ++p == pe )
		goto _test_eof128;
case 128:
#line 4946 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr220;
		case 32: goto tr220;
		case 34: goto tr222;
		case 39: goto tr209;
		case 47: goto tr223;
		case 60: goto st99;
		case 62: goto tr225;
		case 92: goto st129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr221;
	} else if ( (*p) >= 9 )
		goto tr220;
	goto st97;
tr218:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st129;
st129:
	if ( ++p == pe )
		goto _test_eof129;
case 129:
#line 4971 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr220;
		case 32: goto tr220;
		case 34: goto tr314;
		case 39: goto tr314;
		case 47: goto tr223;
		case 60: goto st99;
		case 62: goto tr225;
		case 92: goto st129;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr221;
	} else if ( (*p) >= 9 )
		goto tr220;
	goto st97;
tr311:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st130;
st130:
	if ( ++p == pe )
		goto _test_eof130;
case 130:
#line 4996 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr211;
		case 32: goto tr211;
		case 34: goto tr213;
		case 39: goto tr214;
		case 47: goto tr312;
		case 60: goto tr216;
		case 62: goto tr313;
		case 63: goto tr307;
		case 92: goto tr218;
		case 95: goto tr307;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr212;
		} else if ( (*p) >= 9 )
			goto tr211;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr307;
		} else if ( (*p) >= 65 )
			goto tr307;
	} else
		goto tr307;
	goto tr210;
tr302:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st131;
st131:
	if ( ++p == pe )
		goto _test_eof131;
case 131:
#line 5032 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr315;
		case 34: goto tr316;
		case 39: goto tr317;
		case 47: goto tr319;
		case 62: goto tr320;
		case 63: goto tr318;
		case 92: goto tr321;
		case 95: goto tr318;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr315;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr318;
		} else if ( (*p) >= 65 )
			goto tr318;
	} else
		goto tr318;
	goto tr216;
tr303:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st132;
st132:
	if ( ++p == pe )
		goto _test_eof132;
case 132:
#line 5063 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr315;
		case 34: goto tr322;
		case 39: goto tr317;
		case 47: goto tr319;
		case 62: goto tr320;
		case 63: goto tr318;
		case 92: goto tr321;
		case 95: goto tr318;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr315;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr318;
		} else if ( (*p) >= 65 )
			goto tr318;
	} else
		goto tr318;
	goto tr216;
tr301:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st133;
tr289:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
	goto st133;
st133:
	if ( ++p == pe )
		goto _test_eof133;
case 133:
#line 5098 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr308;
		case 32: goto tr308;
		case 34: goto tr310;
		case 39: goto tr311;
		case 47: goto tr215;
		case 60: goto st99;
		case 62: goto tr225;
		case 92: goto tr218;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr309;
	} else if ( (*p) >= 9 )
		goto tr308;
	goto tr210;
tr324:
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st134;
tr286:
#line 120 "hpricot_scan.rl"
	{ SET(akey, p); }
#line 116 "hpricot_scan.rl"
	{
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
	goto st134;
st134:
	if ( ++p == pe )
		goto _test_eof134;
case 134:
#line 5135 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr323;
		case 32: goto tr323;
		case 34: goto tr222;
		case 39: goto tr209;
		case 47: goto tr283;
		case 60: goto st99;
		case 61: goto st133;
		case 62: goto tr284;
		case 63: goto tr282;
		case 92: goto st129;
		case 95: goto tr282;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr324;
		} else if ( (*p) >= 9 )
			goto tr323;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr282;
		} else if ( (*p) >= 65 )
			goto tr282;
	} else
		goto tr282;
	goto st97;
tr275:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st135;
st135:
	if ( ++p == pe )
		goto _test_eof135;
case 135:
#line 5172 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr326;
		case 32: goto tr326;
		case 39: goto tr155;
		case 47: goto tr280;
		case 60: goto tr328;
		case 62: goto tr329;
		case 63: goto tr279;
		case 92: goto tr253;
		case 95: goto tr279;
	}
	if ( (*p) < 45 ) {
		if ( (*p) > 10 ) {
			if ( 11 <= (*p) && (*p) <= 12 )
				goto tr327;
		} else if ( (*p) >= 9 )
			goto tr326;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr279;
		} else if ( (*p) >= 65 )
			goto tr279;
	} else
		goto tr279;
	goto tr247;
st136:
	if ( ++p == pe )
		goto _test_eof136;
case 136:
	switch( (*p) ) {
		case 34: goto tr316;
		case 39: goto tr317;
		case 92: goto tr321;
	}
	goto tr216;
tr251:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st137;
st137:
	if ( ++p == pe )
		goto _test_eof137;
case 137:
#line 5217 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr330;
		case 39: goto tr331;
		case 47: goto tr333;
		case 62: goto tr334;
		case 63: goto tr332;
		case 92: goto tr335;
		case 95: goto tr332;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr330;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr332;
		} else if ( (*p) >= 65 )
			goto tr332;
	} else
		goto tr332;
	goto tr328;
tr248:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st138;
st138:
	if ( ++p == pe )
		goto _test_eof138;
case 138:
#line 5247 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr277;
		case 32: goto tr277;
		case 34: goto st136;
		case 39: goto tr251;
		case 47: goto tr252;
		case 60: goto st101;
		case 62: goto tr237;
		case 92: goto tr253;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr278;
	} else if ( (*p) >= 9 )
		goto tr277;
	goto tr247;
tr185:
#line 115 "hpricot_scan.rl"
	{ SET(aval, p); }
	goto st139;
st139:
	if ( ++p == pe )
		goto _test_eof139;
case 139:
#line 5272 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr336;
		case 34: goto tr331;
		case 47: goto tr338;
		case 62: goto tr339;
		case 63: goto tr337;
		case 92: goto tr340;
		case 95: goto tr337;
	}
	if ( (*p) < 45 ) {
		if ( 9 <= (*p) && (*p) <= 13 )
			goto tr336;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr337;
		} else if ( (*p) >= 65 )
			goto tr337;
	} else
		goto tr337;
	goto tr157;
st140:
	if ( ++p == pe )
		goto _test_eof140;
case 140:
	switch( (*p) ) {
		case 34: goto tr322;
		case 39: goto tr317;
		case 92: goto tr321;
	}
	goto tr216;
st141:
	if ( ++p == pe )
		goto _test_eof141;
case 141:
	switch( (*p) ) {
		case 13: goto tr326;
		case 32: goto tr326;
		case 39: goto tr155;
		case 47: goto tr276;
		case 60: goto tr328;
		case 62: goto tr341;
		case 92: goto tr253;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr327;
	} else if ( (*p) >= 9 )
		goto tr326;
	goto tr247;
st142:
	if ( ++p == pe )
		goto _test_eof142;
case 142:
	switch( (*p) ) {
		case 34: goto tr331;
		case 92: goto tr340;
	}
	goto tr157;
st143:
	if ( ++p == pe )
		goto _test_eof143;
case 143:
	switch( (*p) ) {
		case 39: goto tr331;
		case 92: goto tr335;
	}
	goto tr328;
tr120:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st144;
st144:
	if ( ++p == pe )
		goto _test_eof144;
case 144:
#line 5349 "hpricot_scan.c"
	switch( (*p) ) {
		case 13: goto tr148;
		case 32: goto tr148;
		case 34: goto st142;
		case 39: goto st143;
		case 47: goto tr124;
		case 60: goto tr39;
		case 62: goto tr117;
	}
	if ( (*p) > 10 ) {
		if ( 11 <= (*p) && (*p) <= 12 )
			goto tr149;
	} else if ( (*p) >= 9 )
		goto tr148;
	goto tr119;
st145:
	if ( ++p == pe )
		goto _test_eof145;
case 145:
	switch( (*p) ) {
		case 58: goto tr342;
		case 95: goto tr342;
		case 120: goto tr343;
	}
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr342;
	} else if ( (*p) >= 65 )
		goto tr342;
	goto tr0;
tr342:
#line 46 "hpricot_scan.rl"
	{ TEXT_PASS(); }
	goto st146;
st146:
	if ( ++p == pe )
		goto _test_eof146;
case 146:
#line 5388 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st212;
		case 63: goto st146;
		case 95: goto st146;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st146;
		} else if ( (*p) >= 9 )
			goto st212;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st146;
		} else if ( (*p) >= 65 )
			goto st146;
	} else
		goto st146;
	goto tr0;
st212:
	if ( ++p == pe )
		goto _test_eof212;
case 212:
	if ( (*p) == 32 )
		goto st212;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st212;
	goto tr420;
tr343:
#line 46 "hpricot_scan.rl"
	{ TEXT_PASS(); }
	goto st147;
st147:
	if ( ++p == pe )
		goto _test_eof147;
case 147:
#line 5426 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st212;
		case 63: goto st146;
		case 95: goto st146;
		case 109: goto st148;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st146;
		} else if ( (*p) >= 9 )
			goto st212;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st146;
		} else if ( (*p) >= 65 )
			goto st146;
	} else
		goto st146;
	goto tr0;
st148:
	if ( ++p == pe )
		goto _test_eof148;
case 148:
	switch( (*p) ) {
		case 32: goto st212;
		case 63: goto st146;
		case 95: goto st146;
		case 108: goto st149;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st146;
		} else if ( (*p) >= 9 )
			goto st212;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st146;
		} else if ( (*p) >= 65 )
			goto st146;
	} else
		goto st146;
	goto tr0;
st149:
	if ( ++p == pe )
		goto _test_eof149;
case 149:
	switch( (*p) ) {
		case 32: goto tr348;
		case 63: goto st146;
		case 95: goto st146;
	}
	if ( (*p) < 48 ) {
		if ( (*p) > 13 ) {
			if ( 45 <= (*p) && (*p) <= 46 )
				goto st146;
		} else if ( (*p) >= 9 )
			goto tr348;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st146;
		} else if ( (*p) >= 65 )
			goto st146;
	} else
		goto st146;
	goto tr0;
tr348:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
	goto st213;
st213:
	if ( ++p == pe )
		goto _test_eof213;
case 213:
#line 5505 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto tr348;
		case 118: goto st150;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr348;
	goto tr420;
st150:
	if ( ++p == pe )
		goto _test_eof150;
case 150:
	if ( (*p) == 101 )
		goto st151;
	goto tr349;
st151:
	if ( ++p == pe )
		goto _test_eof151;
case 151:
	if ( (*p) == 114 )
		goto st152;
	goto tr349;
st152:
	if ( ++p == pe )
		goto _test_eof152;
case 152:
	if ( (*p) == 115 )
		goto st153;
	goto tr349;
st153:
	if ( ++p == pe )
		goto _test_eof153;
case 153:
	if ( (*p) == 105 )
		goto st154;
	goto tr349;
st154:
	if ( ++p == pe )
		goto _test_eof154;
case 154:
	if ( (*p) == 111 )
		goto st155;
	goto tr349;
st155:
	if ( ++p == pe )
		goto _test_eof155;
case 155:
	if ( (*p) == 110 )
		goto st156;
	goto tr349;
st156:
	if ( ++p == pe )
		goto _test_eof156;
case 156:
	switch( (*p) ) {
		case 32: goto st156;
		case 61: goto st157;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st156;
	goto tr349;
st157:
	if ( ++p == pe )
		goto _test_eof157;
case 157:
	switch( (*p) ) {
		case 32: goto st157;
		case 34: goto st158;
		case 39: goto st200;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st157;
	goto tr349;
st158:
	if ( ++p == pe )
		goto _test_eof158;
case 158:
	if ( (*p) == 95 )
		goto tr359;
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto tr359;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr359;
		} else if ( (*p) >= 65 )
			goto tr359;
	} else
		goto tr359;
	goto tr349;
tr359:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st159;
st159:
	if ( ++p == pe )
		goto _test_eof159;
case 159:
#line 5604 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr360;
		case 95: goto st159;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st159;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st159;
		} else if ( (*p) >= 65 )
			goto st159;
	} else
		goto st159;
	goto tr349;
tr360:
#line 121 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("version")), aval); }
	goto st160;
st160:
	if ( ++p == pe )
		goto _test_eof160;
case 160:
#line 5629 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st161;
		case 62: goto tr363;
		case 63: goto st162;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st161;
	goto tr349;
st161:
	if ( ++p == pe )
		goto _test_eof161;
case 161:
	switch( (*p) ) {
		case 32: goto st161;
		case 62: goto tr363;
		case 63: goto st162;
		case 101: goto st163;
		case 115: goto st176;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st161;
	goto tr349;
st162:
	if ( ++p == pe )
		goto _test_eof162;
case 162:
	if ( (*p) == 62 )
		goto tr363;
	goto tr349;
st163:
	if ( ++p == pe )
		goto _test_eof163;
case 163:
	if ( (*p) == 110 )
		goto st164;
	goto tr349;
st164:
	if ( ++p == pe )
		goto _test_eof164;
case 164:
	if ( (*p) == 99 )
		goto st165;
	goto tr349;
st165:
	if ( ++p == pe )
		goto _test_eof165;
case 165:
	if ( (*p) == 111 )
		goto st166;
	goto tr349;
st166:
	if ( ++p == pe )
		goto _test_eof166;
case 166:
	if ( (*p) == 100 )
		goto st167;
	goto tr349;
st167:
	if ( ++p == pe )
		goto _test_eof167;
case 167:
	if ( (*p) == 105 )
		goto st168;
	goto tr349;
st168:
	if ( ++p == pe )
		goto _test_eof168;
case 168:
	if ( (*p) == 110 )
		goto st169;
	goto tr349;
st169:
	if ( ++p == pe )
		goto _test_eof169;
case 169:
	if ( (*p) == 103 )
		goto st170;
	goto tr349;
st170:
	if ( ++p == pe )
		goto _test_eof170;
case 170:
	switch( (*p) ) {
		case 32: goto st170;
		case 61: goto st171;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st170;
	goto tr349;
st171:
	if ( ++p == pe )
		goto _test_eof171;
case 171:
	switch( (*p) ) {
		case 32: goto st171;
		case 34: goto st172;
		case 39: goto st198;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st171;
	goto tr349;
st172:
	if ( ++p == pe )
		goto _test_eof172;
case 172:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr377;
	} else if ( (*p) >= 65 )
		goto tr377;
	goto tr349;
tr377:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st173;
st173:
	if ( ++p == pe )
		goto _test_eof173;
case 173:
#line 5749 "hpricot_scan.c"
	switch( (*p) ) {
		case 34: goto tr378;
		case 95: goto st173;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st173;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st173;
		} else if ( (*p) >= 65 )
			goto st173;
	} else
		goto st173;
	goto tr349;
tr378:
#line 122 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("encoding")), aval); }
	goto st174;
st174:
	if ( ++p == pe )
		goto _test_eof174;
case 174:
#line 5774 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st175;
		case 62: goto tr363;
		case 63: goto st162;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st175;
	goto tr349;
st175:
	if ( ++p == pe )
		goto _test_eof175;
case 175:
	switch( (*p) ) {
		case 32: goto st175;
		case 62: goto tr363;
		case 63: goto st162;
		case 115: goto st176;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st175;
	goto tr349;
st176:
	if ( ++p == pe )
		goto _test_eof176;
case 176:
	if ( (*p) == 116 )
		goto st177;
	goto tr349;
st177:
	if ( ++p == pe )
		goto _test_eof177;
case 177:
	if ( (*p) == 97 )
		goto st178;
	goto tr349;
st178:
	if ( ++p == pe )
		goto _test_eof178;
case 178:
	if ( (*p) == 110 )
		goto st179;
	goto tr349;
st179:
	if ( ++p == pe )
		goto _test_eof179;
case 179:
	if ( (*p) == 100 )
		goto st180;
	goto tr349;
st180:
	if ( ++p == pe )
		goto _test_eof180;
case 180:
	if ( (*p) == 97 )
		goto st181;
	goto tr349;
st181:
	if ( ++p == pe )
		goto _test_eof181;
case 181:
	if ( (*p) == 108 )
		goto st182;
	goto tr349;
st182:
	if ( ++p == pe )
		goto _test_eof182;
case 182:
	if ( (*p) == 111 )
		goto st183;
	goto tr349;
st183:
	if ( ++p == pe )
		goto _test_eof183;
case 183:
	if ( (*p) == 110 )
		goto st184;
	goto tr349;
st184:
	if ( ++p == pe )
		goto _test_eof184;
case 184:
	if ( (*p) == 101 )
		goto st185;
	goto tr349;
st185:
	if ( ++p == pe )
		goto _test_eof185;
case 185:
	switch( (*p) ) {
		case 32: goto st185;
		case 61: goto st186;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st185;
	goto tr349;
st186:
	if ( ++p == pe )
		goto _test_eof186;
case 186:
	switch( (*p) ) {
		case 32: goto st186;
		case 34: goto st187;
		case 39: goto st193;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st186;
	goto tr349;
st187:
	if ( ++p == pe )
		goto _test_eof187;
case 187:
	switch( (*p) ) {
		case 110: goto tr393;
		case 121: goto tr394;
	}
	goto tr349;
tr393:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st188;
st188:
	if ( ++p == pe )
		goto _test_eof188;
case 188:
#line 5899 "hpricot_scan.c"
	if ( (*p) == 111 )
		goto st189;
	goto tr349;
st189:
	if ( ++p == pe )
		goto _test_eof189;
case 189:
	if ( (*p) == 34 )
		goto tr396;
	goto tr349;
tr396:
#line 123 "hpricot_scan.rl"
	{ SET(aval, p); ATTR(ID2SYM(rb_intern("standalone")), aval); }
	goto st190;
st190:
	if ( ++p == pe )
		goto _test_eof190;
case 190:
#line 5918 "hpricot_scan.c"
	switch( (*p) ) {
		case 32: goto st190;
		case 62: goto tr363;
		case 63: goto st162;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st190;
	goto tr349;
tr394:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st191;
st191:
	if ( ++p == pe )
		goto _test_eof191;
case 191:
#line 5935 "hpricot_scan.c"
	if ( (*p) == 101 )
		goto st192;
	goto tr349;
st192:
	if ( ++p == pe )
		goto _test_eof192;
case 192:
	if ( (*p) == 115 )
		goto st189;
	goto tr349;
st193:
	if ( ++p == pe )
		goto _test_eof193;
case 193:
	switch( (*p) ) {
		case 110: goto tr399;
		case 121: goto tr400;
	}
	goto tr349;
tr399:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st194;
st194:
	if ( ++p == pe )
		goto _test_eof194;
case 194:
#line 5963 "hpricot_scan.c"
	if ( (*p) == 111 )
		goto st195;
	goto tr349;
st195:
	if ( ++p == pe )
		goto _test_eof195;
case 195:
	if ( (*p) == 39 )
		goto tr396;
	goto tr349;
tr400:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st196;
st196:
	if ( ++p == pe )
		goto _test_eof196;
case 196:
#line 5982 "hpricot_scan.c"
	if ( (*p) == 101 )
		goto st197;
	goto tr349;
st197:
	if ( ++p == pe )
		goto _test_eof197;
case 197:
	if ( (*p) == 115 )
		goto st195;
	goto tr349;
st198:
	if ( ++p == pe )
		goto _test_eof198;
case 198:
	if ( (*p) > 90 ) {
		if ( 97 <= (*p) && (*p) <= 122 )
			goto tr403;
	} else if ( (*p) >= 65 )
		goto tr403;
	goto tr349;
tr403:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st199;
st199:
	if ( ++p == pe )
		goto _test_eof199;
case 199:
#line 6011 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr378;
		case 95: goto st199;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st199;
	} else if ( (*p) > 57 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st199;
		} else if ( (*p) >= 65 )
			goto st199;
	} else
		goto st199;
	goto tr349;
st200:
	if ( ++p == pe )
		goto _test_eof200;
case 200:
	if ( (*p) == 95 )
		goto tr405;
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto tr405;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr405;
		} else if ( (*p) >= 65 )
			goto tr405;
	} else
		goto tr405;
	goto tr349;
tr405:
#line 111 "hpricot_scan.rl"
	{ mark_aval = p; }
	goto st201;
st201:
	if ( ++p == pe )
		goto _test_eof201;
case 201:
#line 6054 "hpricot_scan.c"
	switch( (*p) ) {
		case 39: goto tr360;
		case 95: goto st201;
	}
	if ( (*p) < 48 ) {
		if ( 45 <= (*p) && (*p) <= 46 )
			goto st201;
	} else if ( (*p) > 58 ) {
		if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st201;
		} else if ( (*p) >= 65 )
			goto st201;
	} else
		goto st201;
	goto tr349;
tr407:
#line 51 "hpricot_scan.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	goto st214;
tr408:
#line 50 "hpricot_scan.rl"
	{ EBLK(comment, 3); {goto st204;} }
#line 50 "hpricot_scan.rl"
	{te = p+1;}
	goto st214;
tr422:
#line 51 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st214;
tr423:
#line 9 "hpricot_scan.rl"
	{curline += 1;}
#line 51 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st214;
tr425:
#line 51 "hpricot_scan.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	goto st214;
st214:
#line 1 "hpricot_scan.rl"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof214;
case 214:
#line 1 "hpricot_scan.rl"
	{ts = p;}
#line 6103 "hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr423;
		case 45: goto tr424;
	}
	goto tr422;
tr424:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
	goto st215;
st215:
	if ( ++p == pe )
		goto _test_eof215;
case 215:
#line 6117 "hpricot_scan.c"
	if ( (*p) == 45 )
		goto st202;
	goto tr425;
st202:
	if ( ++p == pe )
		goto _test_eof202;
case 202:
	if ( (*p) == 62 )
		goto tr408;
	goto tr407;
tr409:
#line 56 "hpricot_scan.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	goto st216;
tr410:
#line 55 "hpricot_scan.rl"
	{ EBLK(cdata, 3); {goto st204;} }
#line 55 "hpricot_scan.rl"
	{te = p+1;}
	goto st216;
tr427:
#line 56 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st216;
tr428:
#line 9 "hpricot_scan.rl"
	{curline += 1;}
#line 56 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st216;
tr430:
#line 56 "hpricot_scan.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	goto st216;
st216:
#line 1 "hpricot_scan.rl"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof216;
case 216:
#line 1 "hpricot_scan.rl"
	{ts = p;}
#line 6160 "hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr428;
		case 93: goto tr429;
	}
	goto tr427;
tr429:
#line 1 "hpricot_scan.rl"
	{te = p+1;}
	goto st217;
st217:
	if ( ++p == pe )
		goto _test_eof217;
case 217:
#line 6174 "hpricot_scan.c"
	if ( (*p) == 93 )
		goto st203;
	goto tr430;
st203:
	if ( ++p == pe )
		goto _test_eof203;
case 203:
	if ( (*p) == 62 )
		goto tr410;
	goto tr409;
tr432:
#line 61 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st218;
tr433:
#line 9 "hpricot_scan.rl"
	{curline += 1;}
#line 61 "hpricot_scan.rl"
	{te = p+1;{ TEXT_PASS(); }}
	goto st218;
tr434:
#line 60 "hpricot_scan.rl"
	{ EBLK(procins, 2); {goto st204;} }
#line 60 "hpricot_scan.rl"
	{te = p+1;}
	goto st218;
tr436:
#line 61 "hpricot_scan.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	goto st218;
st218:
#line 1 "hpricot_scan.rl"
	{ts = 0;}
	if ( ++p == pe )
		goto _test_eof218;
case 218:
#line 1 "hpricot_scan.rl"
	{ts = p;}
#line 6213 "hpricot_scan.c"
	switch( (*p) ) {
		case 10: goto tr433;
		case 62: goto tr434;
		case 63: goto st219;
	}
	goto tr432;
st219:
	if ( ++p == pe )
		goto _test_eof219;
case 219:
	if ( (*p) == 62 )
		goto tr434;
	goto tr436;
	}
	_test_eof204: cs = 204; goto _test_eof; 
	_test_eof205: cs = 205; goto _test_eof; 
	_test_eof0: cs = 0; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof21: cs = 21; goto _test_eof; 
	_test_eof22: cs = 22; goto _test_eof; 
	_test_eof23: cs = 23; goto _test_eof; 
	_test_eof24: cs = 24; goto _test_eof; 
	_test_eof25: cs = 25; goto _test_eof; 
	_test_eof26: cs = 26; goto _test_eof; 
	_test_eof27: cs = 27; goto _test_eof; 
	_test_eof28: cs = 28; goto _test_eof; 
	_test_eof29: cs = 29; goto _test_eof; 
	_test_eof30: cs = 30; goto _test_eof; 
	_test_eof31: cs = 31; goto _test_eof; 
	_test_eof32: cs = 32; goto _test_eof; 
	_test_eof33: cs = 33; goto _test_eof; 
	_test_eof34: cs = 34; goto _test_eof; 
	_test_eof35: cs = 35; goto _test_eof; 
	_test_eof36: cs = 36; goto _test_eof; 
	_test_eof37: cs = 37; goto _test_eof; 
	_test_eof38: cs = 38; goto _test_eof; 
	_test_eof39: cs = 39; goto _test_eof; 
	_test_eof206: cs = 206; goto _test_eof; 
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof207: cs = 207; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof208: cs = 208; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 
	_test_eof50: cs = 50; goto _test_eof; 
	_test_eof51: cs = 51; goto _test_eof; 
	_test_eof52: cs = 52; goto _test_eof; 
	_test_eof53: cs = 53; goto _test_eof; 
	_test_eof54: cs = 54; goto _test_eof; 
	_test_eof55: cs = 55; goto _test_eof; 
	_test_eof56: cs = 56; goto _test_eof; 
	_test_eof57: cs = 57; goto _test_eof; 
	_test_eof58: cs = 58; goto _test_eof; 
	_test_eof59: cs = 59; goto _test_eof; 
	_test_eof60: cs = 60; goto _test_eof; 
	_test_eof61: cs = 61; goto _test_eof; 
	_test_eof62: cs = 62; goto _test_eof; 
	_test_eof63: cs = 63; goto _test_eof; 
	_test_eof64: cs = 64; goto _test_eof; 
	_test_eof65: cs = 65; goto _test_eof; 
	_test_eof66: cs = 66; goto _test_eof; 
	_test_eof67: cs = 67; goto _test_eof; 
	_test_eof68: cs = 68; goto _test_eof; 
	_test_eof69: cs = 69; goto _test_eof; 
	_test_eof70: cs = 70; goto _test_eof; 
	_test_eof71: cs = 71; goto _test_eof; 
	_test_eof72: cs = 72; goto _test_eof; 
	_test_eof73: cs = 73; goto _test_eof; 
	_test_eof74: cs = 74; goto _test_eof; 
	_test_eof75: cs = 75; goto _test_eof; 
	_test_eof76: cs = 76; goto _test_eof; 
	_test_eof77: cs = 77; goto _test_eof; 
	_test_eof78: cs = 78; goto _test_eof; 
	_test_eof79: cs = 79; goto _test_eof; 
	_test_eof80: cs = 80; goto _test_eof; 
	_test_eof81: cs = 81; goto _test_eof; 
	_test_eof82: cs = 82; goto _test_eof; 
	_test_eof83: cs = 83; goto _test_eof; 
	_test_eof84: cs = 84; goto _test_eof; 
	_test_eof209: cs = 209; goto _test_eof; 
	_test_eof85: cs = 85; goto _test_eof; 
	_test_eof86: cs = 86; goto _test_eof; 
	_test_eof87: cs = 87; goto _test_eof; 
	_test_eof88: cs = 88; goto _test_eof; 
	_test_eof89: cs = 89; goto _test_eof; 
	_test_eof90: cs = 90; goto _test_eof; 
	_test_eof91: cs = 91; goto _test_eof; 
	_test_eof92: cs = 92; goto _test_eof; 
	_test_eof93: cs = 93; goto _test_eof; 
	_test_eof94: cs = 94; goto _test_eof; 
	_test_eof95: cs = 95; goto _test_eof; 
	_test_eof96: cs = 96; goto _test_eof; 
	_test_eof97: cs = 97; goto _test_eof; 
	_test_eof98: cs = 98; goto _test_eof; 
	_test_eof99: cs = 99; goto _test_eof; 
	_test_eof100: cs = 100; goto _test_eof; 
	_test_eof101: cs = 101; goto _test_eof; 
	_test_eof102: cs = 102; goto _test_eof; 
	_test_eof103: cs = 103; goto _test_eof; 
	_test_eof104: cs = 104; goto _test_eof; 
	_test_eof105: cs = 105; goto _test_eof; 
	_test_eof210: cs = 210; goto _test_eof; 
	_test_eof106: cs = 106; goto _test_eof; 
	_test_eof107: cs = 107; goto _test_eof; 
	_test_eof108: cs = 108; goto _test_eof; 
	_test_eof109: cs = 109; goto _test_eof; 
	_test_eof110: cs = 110; goto _test_eof; 
	_test_eof111: cs = 111; goto _test_eof; 
	_test_eof112: cs = 112; goto _test_eof; 
	_test_eof113: cs = 113; goto _test_eof; 
	_test_eof114: cs = 114; goto _test_eof; 
	_test_eof115: cs = 115; goto _test_eof; 
	_test_eof116: cs = 116; goto _test_eof; 
	_test_eof117: cs = 117; goto _test_eof; 
	_test_eof118: cs = 118; goto _test_eof; 
	_test_eof119: cs = 119; goto _test_eof; 
	_test_eof120: cs = 120; goto _test_eof; 
	_test_eof121: cs = 121; goto _test_eof; 
	_test_eof211: cs = 211; goto _test_eof; 
	_test_eof122: cs = 122; goto _test_eof; 
	_test_eof123: cs = 123; goto _test_eof; 
	_test_eof124: cs = 124; goto _test_eof; 
	_test_eof125: cs = 125; goto _test_eof; 
	_test_eof126: cs = 126; goto _test_eof; 
	_test_eof127: cs = 127; goto _test_eof; 
	_test_eof128: cs = 128; goto _test_eof; 
	_test_eof129: cs = 129; goto _test_eof; 
	_test_eof130: cs = 130; goto _test_eof; 
	_test_eof131: cs = 131; goto _test_eof; 
	_test_eof132: cs = 132; goto _test_eof; 
	_test_eof133: cs = 133; goto _test_eof; 
	_test_eof134: cs = 134; goto _test_eof; 
	_test_eof135: cs = 135; goto _test_eof; 
	_test_eof136: cs = 136; goto _test_eof; 
	_test_eof137: cs = 137; goto _test_eof; 
	_test_eof138: cs = 138; goto _test_eof; 
	_test_eof139: cs = 139; goto _test_eof; 
	_test_eof140: cs = 140; goto _test_eof; 
	_test_eof141: cs = 141; goto _test_eof; 
	_test_eof142: cs = 142; goto _test_eof; 
	_test_eof143: cs = 143; goto _test_eof; 
	_test_eof144: cs = 144; goto _test_eof; 
	_test_eof145: cs = 145; goto _test_eof; 
	_test_eof146: cs = 146; goto _test_eof; 
	_test_eof212: cs = 212; goto _test_eof; 
	_test_eof147: cs = 147; goto _test_eof; 
	_test_eof148: cs = 148; goto _test_eof; 
	_test_eof149: cs = 149; goto _test_eof; 
	_test_eof213: cs = 213; goto _test_eof; 
	_test_eof150: cs = 150; goto _test_eof; 
	_test_eof151: cs = 151; goto _test_eof; 
	_test_eof152: cs = 152; goto _test_eof; 
	_test_eof153: cs = 153; goto _test_eof; 
	_test_eof154: cs = 154; goto _test_eof; 
	_test_eof155: cs = 155; goto _test_eof; 
	_test_eof156: cs = 156; goto _test_eof; 
	_test_eof157: cs = 157; goto _test_eof; 
	_test_eof158: cs = 158; goto _test_eof; 
	_test_eof159: cs = 159; goto _test_eof; 
	_test_eof160: cs = 160; goto _test_eof; 
	_test_eof161: cs = 161; goto _test_eof; 
	_test_eof162: cs = 162; goto _test_eof; 
	_test_eof163: cs = 163; goto _test_eof; 
	_test_eof164: cs = 164; goto _test_eof; 
	_test_eof165: cs = 165; goto _test_eof; 
	_test_eof166: cs = 166; goto _test_eof; 
	_test_eof167: cs = 167; goto _test_eof; 
	_test_eof168: cs = 168; goto _test_eof; 
	_test_eof169: cs = 169; goto _test_eof; 
	_test_eof170: cs = 170; goto _test_eof; 
	_test_eof171: cs = 171; goto _test_eof; 
	_test_eof172: cs = 172; goto _test_eof; 
	_test_eof173: cs = 173; goto _test_eof; 
	_test_eof174: cs = 174; goto _test_eof; 
	_test_eof175: cs = 175; goto _test_eof; 
	_test_eof176: cs = 176; goto _test_eof; 
	_test_eof177: cs = 177; goto _test_eof; 
	_test_eof178: cs = 178; goto _test_eof; 
	_test_eof179: cs = 179; goto _test_eof; 
	_test_eof180: cs = 180; goto _test_eof; 
	_test_eof181: cs = 181; goto _test_eof; 
	_test_eof182: cs = 182; goto _test_eof; 
	_test_eof183: cs = 183; goto _test_eof; 
	_test_eof184: cs = 184; goto _test_eof; 
	_test_eof185: cs = 185; goto _test_eof; 
	_test_eof186: cs = 186; goto _test_eof; 
	_test_eof187: cs = 187; goto _test_eof; 
	_test_eof188: cs = 188; goto _test_eof; 
	_test_eof189: cs = 189; goto _test_eof; 
	_test_eof190: cs = 190; goto _test_eof; 
	_test_eof191: cs = 191; goto _test_eof; 
	_test_eof192: cs = 192; goto _test_eof; 
	_test_eof193: cs = 193; goto _test_eof; 
	_test_eof194: cs = 194; goto _test_eof; 
	_test_eof195: cs = 195; goto _test_eof; 
	_test_eof196: cs = 196; goto _test_eof; 
	_test_eof197: cs = 197; goto _test_eof; 
	_test_eof198: cs = 198; goto _test_eof; 
	_test_eof199: cs = 199; goto _test_eof; 
	_test_eof200: cs = 200; goto _test_eof; 
	_test_eof201: cs = 201; goto _test_eof; 
	_test_eof214: cs = 214; goto _test_eof; 
	_test_eof215: cs = 215; goto _test_eof; 
	_test_eof202: cs = 202; goto _test_eof; 
	_test_eof216: cs = 216; goto _test_eof; 
	_test_eof217: cs = 217; goto _test_eof; 
	_test_eof203: cs = 203; goto _test_eof; 
	_test_eof218: cs = 218; goto _test_eof; 
	_test_eof219: cs = 219; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 205: goto tr414;
	case 0: goto tr0;
	case 1: goto tr0;
	case 2: goto tr0;
	case 3: goto tr0;
	case 4: goto tr0;
	case 5: goto tr0;
	case 6: goto tr0;
	case 7: goto tr0;
	case 8: goto tr0;
	case 9: goto tr0;
	case 10: goto tr0;
	case 11: goto tr0;
	case 12: goto tr0;
	case 13: goto tr0;
	case 14: goto tr0;
	case 15: goto tr0;
	case 16: goto tr0;
	case 17: goto tr0;
	case 18: goto tr0;
	case 19: goto tr0;
	case 20: goto tr0;
	case 21: goto tr0;
	case 22: goto tr0;
	case 23: goto tr0;
	case 24: goto tr39;
	case 25: goto tr39;
	case 26: goto tr39;
	case 27: goto tr39;
	case 28: goto tr0;
	case 29: goto tr39;
	case 30: goto tr0;
	case 31: goto tr0;
	case 32: goto tr0;
	case 33: goto tr0;
	case 34: goto tr0;
	case 35: goto tr0;
	case 36: goto tr0;
	case 37: goto tr0;
	case 38: goto tr0;
	case 39: goto tr0;
	case 206: goto tr419;
	case 40: goto tr0;
	case 41: goto tr0;
	case 207: goto tr419;
	case 42: goto tr0;
	case 43: goto tr0;
	case 208: goto tr419;
	case 44: goto tr0;
	case 45: goto tr0;
	case 46: goto tr0;
	case 47: goto tr0;
	case 48: goto tr0;
	case 49: goto tr0;
	case 50: goto tr0;
	case 51: goto tr0;
	case 52: goto tr0;
	case 53: goto tr0;
	case 54: goto tr0;
	case 55: goto tr0;
	case 56: goto tr0;
	case 57: goto tr0;
	case 58: goto tr0;
	case 59: goto tr0;
	case 60: goto tr0;
	case 61: goto tr0;
	case 62: goto tr0;
	case 63: goto tr0;
	case 64: goto tr39;
	case 65: goto tr39;
	case 66: goto tr39;
	case 67: goto tr39;
	case 68: goto tr39;
	case 69: goto tr39;
	case 70: goto tr39;
	case 71: goto tr39;
	case 72: goto tr39;
	case 73: goto tr39;
	case 74: goto tr39;
	case 75: goto tr39;
	case 76: goto tr39;
	case 77: goto tr39;
	case 78: goto tr39;
	case 79: goto tr39;
	case 80: goto tr39;
	case 81: goto tr39;
	case 82: goto tr39;
	case 83: goto tr39;
	case 84: goto tr39;
	case 209: goto tr39;
	case 85: goto tr39;
	case 86: goto tr39;
	case 87: goto tr39;
	case 88: goto tr39;
	case 89: goto tr39;
	case 90: goto tr39;
	case 91: goto tr39;
	case 92: goto tr39;
	case 93: goto tr39;
	case 94: goto tr39;
	case 95: goto tr39;
	case 96: goto tr39;
	case 97: goto tr39;
	case 98: goto tr39;
	case 99: goto tr39;
	case 100: goto tr39;
	case 101: goto tr39;
	case 102: goto tr39;
	case 103: goto tr39;
	case 104: goto tr39;
	case 105: goto tr39;
	case 210: goto tr39;
	case 106: goto tr39;
	case 107: goto tr39;
	case 108: goto tr39;
	case 109: goto tr39;
	case 110: goto tr39;
	case 111: goto tr39;
	case 112: goto tr39;
	case 113: goto tr39;
	case 114: goto tr39;
	case 115: goto tr39;
	case 116: goto tr39;
	case 117: goto tr39;
	case 118: goto tr39;
	case 119: goto tr39;
	case 120: goto tr39;
	case 121: goto tr39;
	case 211: goto tr39;
	case 122: goto tr39;
	case 123: goto tr39;
	case 124: goto tr39;
	case 125: goto tr39;
	case 126: goto tr39;
	case 127: goto tr39;
	case 128: goto tr39;
	case 129: goto tr39;
	case 130: goto tr39;
	case 131: goto tr39;
	case 132: goto tr39;
	case 133: goto tr39;
	case 134: goto tr39;
	case 135: goto tr39;
	case 136: goto tr39;
	case 137: goto tr39;
	case 138: goto tr39;
	case 139: goto tr39;
	case 140: goto tr39;
	case 141: goto tr39;
	case 142: goto tr39;
	case 143: goto tr39;
	case 144: goto tr39;
	case 145: goto tr0;
	case 146: goto tr0;
	case 212: goto tr420;
	case 147: goto tr0;
	case 148: goto tr0;
	case 149: goto tr0;
	case 213: goto tr420;
	case 150: goto tr349;
	case 151: goto tr349;
	case 152: goto tr349;
	case 153: goto tr349;
	case 154: goto tr349;
	case 155: goto tr349;
	case 156: goto tr349;
	case 157: goto tr349;
	case 158: goto tr349;
	case 159: goto tr349;
	case 160: goto tr349;
	case 161: goto tr349;
	case 162: goto tr349;
	case 163: goto tr349;
	case 164: goto tr349;
	case 165: goto tr349;
	case 166: goto tr349;
	case 167: goto tr349;
	case 168: goto tr349;
	case 169: goto tr349;
	case 170: goto tr349;
	case 171: goto tr349;
	case 172: goto tr349;
	case 173: goto tr349;
	case 174: goto tr349;
	case 175: goto tr349;
	case 176: goto tr349;
	case 177: goto tr349;
	case 178: goto tr349;
	case 179: goto tr349;
	case 180: goto tr349;
	case 181: goto tr349;
	case 182: goto tr349;
	case 183: goto tr349;
	case 184: goto tr349;
	case 185: goto tr349;
	case 186: goto tr349;
	case 187: goto tr349;
	case 188: goto tr349;
	case 189: goto tr349;
	case 190: goto tr349;
	case 191: goto tr349;
	case 192: goto tr349;
	case 193: goto tr349;
	case 194: goto tr349;
	case 195: goto tr349;
	case 196: goto tr349;
	case 197: goto tr349;
	case 198: goto tr349;
	case 199: goto tr349;
	case 200: goto tr349;
	case 201: goto tr349;
	case 215: goto tr425;
	case 202: goto tr407;
	case 217: goto tr430;
	case 203: goto tr409;
	case 219: goto tr436;
	}
	}

	}
#line 534 "hpricot_scan.rl"

    if (cs == hpricot_scan_error) {
      if (buf != NULL)
        free(buf);
      if (!NIL_P(tag))
      {
        rb_raise(rb_eHpricotParseError, "parse error on element <%s>, starting on line %d.\n" NO_WAY_SERIOUSLY, RSTRING_PTR(tag), curline);
      }
      else
      {
        rb_raise(rb_eHpricotParseError, "parse error on line %d.\n" NO_WAY_SERIOUSLY, curline);
      }
    }

    if (done && ele_open)
    {
      ele_open = 0;
      if (ts > 0) {
        mark_tag = ts;
        ts = 0;
        text = 1;
      }
    }

    if (ts == 0)
    {
      have = 0;
      /* text nodes have no ts because each byte is parsed alone */
      if (mark_tag != NULL && text == 1)
      {
        if (done)
        {
          if (mark_tag < p-1)
          {
            CAT(tag, p-1);
            ELE(text);
          }
        }
        else
        {
          CAT(tag, p);
        }
      }
      if (io)
        mark_tag = buf;
      else
        mark_tag = RSTRING_PTR(port);
    }
    else if (io)
    {
      have = pe - ts;
      memmove(buf, ts, have);
      SLIDE(tag);
      SLIDE(akey);
      SLIDE(aval);
      te = buf + (te - ts);
      ts = buf;
    }
  }

  if (buf != NULL)
    free(buf);

  if (S != NULL)
  {
    VALUE doc = S->doc;
    rb_gc_unregister_address(&S->doc);
    free(S);
    return doc;
  }

  return Qnil;
}

static VALUE
alloc_hpricot_struct(VALUE klass)
{
  VALUE size;
  long n;
  NEWOBJ(st, struct RStruct);
  OBJSETUP(st, klass, T_STRUCT);

  size = rb_struct_iv_get(klass, "__size__");
  n = FIX2LONG(size);

#ifndef RSTRUCT_EMBED_LEN_MAX
  st->ptr = ALLOC_N(VALUE, n);
  rb_mem_clear(st->ptr, n);
  st->len = n;
#else
  if (0 < n && n <= RSTRUCT_EMBED_LEN_MAX) {
    RBASIC(st)->flags &= ~RSTRUCT_EMBED_LEN_MASK;
    RBASIC(st)->flags |= n << RSTRUCT_EMBED_LEN_SHIFT;
    rb_mem_clear(st->as.ary, n);
  } else {
    st->as.heap.ptr = ALLOC_N(VALUE, n);
    rb_mem_clear(st->as.heap.ptr, n);
    st->as.heap.len = n;
  }
#endif

  return (VALUE)st;
}

static VALUE hpricot_struct_ref0(VALUE obj) {return H_ELE_GET(obj, 0);}
static VALUE hpricot_struct_ref1(VALUE obj) {return H_ELE_GET(obj, 1);}
static VALUE hpricot_struct_ref2(VALUE obj) {return H_ELE_GET(obj, 2);}
static VALUE hpricot_struct_ref3(VALUE obj) {return H_ELE_GET(obj, 3);}
static VALUE hpricot_struct_ref4(VALUE obj) {return H_ELE_GET(obj, 4);}
static VALUE hpricot_struct_ref5(VALUE obj) {return H_ELE_GET(obj, 5);}
static VALUE hpricot_struct_ref6(VALUE obj) {return H_ELE_GET(obj, 6);}
static VALUE hpricot_struct_ref7(VALUE obj) {return H_ELE_GET(obj, 7);}
static VALUE hpricot_struct_ref8(VALUE obj) {return H_ELE_GET(obj, 8);}
static VALUE hpricot_struct_ref9(VALUE obj) {return H_ELE_GET(obj, 9);}

static VALUE (*ref_func[10])() = {
  hpricot_struct_ref0,
  hpricot_struct_ref1,
  hpricot_struct_ref2,
  hpricot_struct_ref3,
  hpricot_struct_ref4,
  hpricot_struct_ref5,
  hpricot_struct_ref6,
  hpricot_struct_ref7,
  hpricot_struct_ref8,
  hpricot_struct_ref9,
};

static VALUE hpricot_struct_set0(VALUE obj, VALUE val) {return H_ELE_SET(obj, 0, val);}
static VALUE hpricot_struct_set1(VALUE obj, VALUE val) {return H_ELE_SET(obj, 1, val);}
static VALUE hpricot_struct_set2(VALUE obj, VALUE val) {return H_ELE_SET(obj, 2, val);}
static VALUE hpricot_struct_set3(VALUE obj, VALUE val) {return H_ELE_SET(obj, 3, val);}
static VALUE hpricot_struct_set4(VALUE obj, VALUE val) {return H_ELE_SET(obj, 4, val);}
static VALUE hpricot_struct_set5(VALUE obj, VALUE val) {return H_ELE_SET(obj, 5, val);}
static VALUE hpricot_struct_set6(VALUE obj, VALUE val) {return H_ELE_SET(obj, 6, val);}
static VALUE hpricot_struct_set7(VALUE obj, VALUE val) {return H_ELE_SET(obj, 7, val);}
static VALUE hpricot_struct_set8(VALUE obj, VALUE val) {return H_ELE_SET(obj, 8, val);}
static VALUE hpricot_struct_set9(VALUE obj, VALUE val) {return H_ELE_SET(obj, 9, val);}

static VALUE (*set_func[10])() = {
  hpricot_struct_set0,
  hpricot_struct_set1,
  hpricot_struct_set2,
  hpricot_struct_set3,
  hpricot_struct_set4,
  hpricot_struct_set5,
  hpricot_struct_set6,
  hpricot_struct_set7,
  hpricot_struct_set8,
  hpricot_struct_set9,
};

static VALUE
make_hpricot_struct(VALUE members)
{
  int i = 0;
  VALUE klass = rb_class_new(rb_cObject);
  rb_iv_set(klass, "__size__", INT2NUM(RARRAY_LEN(members)));
  rb_define_alloc_func(klass, alloc_hpricot_struct);
  rb_define_singleton_method(klass, "new", rb_class_new_instance, -1);
  for (i = 0; i < RARRAY_LEN(members); i++) {
    ID id = SYM2ID(RARRAY_PTR(members)[i]);
    rb_define_method_id(klass, id, ref_func[i], 0);
    rb_define_method_id(klass, rb_id_attrset(id), set_func[i], 1);
  }
  return klass;
}

void Init_hpricot_scan()
{
  VALUE structElem, structAttr, structBasic;

  s_ElementContent = rb_intern("ElementContent");
  symAllow = ID2SYM(rb_intern("allow"));
  symDeny = ID2SYM(rb_intern("deny"));
  s_downcase = rb_intern("downcase");
  s_new = rb_intern("new");
  s_parent = rb_intern("parent");
  s_read = rb_intern("read");
  s_to_str = rb_intern("to_str");
  sym_xmldecl = ID2SYM(rb_intern("xmldecl"));
  sym_doctype = ID2SYM(rb_intern("doctype"));
  sym_procins = ID2SYM(rb_intern("procins"));
  sym_stag = ID2SYM(rb_intern("stag"));
  sym_etag = ID2SYM(rb_intern("etag"));
  sym_emptytag = ID2SYM(rb_intern("emptytag"));
  sym_allowed = ID2SYM(rb_intern("allowed"));
  sym_children = ID2SYM(rb_intern("children"));
  sym_comment = ID2SYM(rb_intern("comment"));
  sym_cdata = ID2SYM(rb_intern("cdata"));
  sym_name = ID2SYM(rb_intern("name"));
  sym_parent = ID2SYM(rb_intern("parent"));
  sym_raw_attributes = ID2SYM(rb_intern("raw_attributes"));
  sym_raw_string = ID2SYM(rb_intern("raw_string"));
  sym_tagno = ID2SYM(rb_intern("tagno"));
  sym_text = ID2SYM(rb_intern("text"));
  sym_EMPTY = ID2SYM(rb_intern("EMPTY"));
  sym_CDATA = ID2SYM(rb_intern("CDATA"));

  mHpricot = rb_define_module("Hpricot");
  rb_define_attr(rb_singleton_class(mHpricot), "buffer_size", 1, 1);
  rb_define_singleton_method(mHpricot, "scan", hpricot_scan, -1);
  rb_define_singleton_method(mHpricot, "css", hpricot_css, 3);
  rb_eHpricotParseError = rb_define_class_under(mHpricot, "ParseError", rb_eStandardError);

  structElem = make_hpricot_struct(rb_ary_new3(8, sym_name, sym_parent,
    sym_raw_attributes, sym_etag, sym_raw_string, sym_allowed,
    sym_tagno, sym_children));
  structAttr = make_hpricot_struct(rb_ary_new3(3, sym_name, sym_parent, sym_raw_attributes));
  structBasic = make_hpricot_struct(rb_ary_new3(2, sym_name, sym_parent));

  cDoc = rb_define_class_under(mHpricot, "Doc", structElem);
  cCData = rb_define_class_under(mHpricot, "CData", structBasic);
  rb_define_method(cCData, "content", hpricot_ele_get_name, 0);
  rb_define_method(cCData, "content=", hpricot_ele_set_name, 1);
  cComment = rb_define_class_under(mHpricot, "Comment", structBasic);
  rb_define_method(cComment, "content", hpricot_ele_get_name, 0);
  rb_define_method(cComment, "content=", hpricot_ele_set_name, 1);
  cDocType = rb_define_class_under(mHpricot, "DocType", structAttr);
  rb_define_method(cDocType, "raw_string", hpricot_ele_get_name, 0);
  rb_define_method(cDocType, "clear_raw", hpricot_ele_clear_name, 0);
  rb_define_method(cDocType, "target", hpricot_ele_get_target, 0);
  rb_define_method(cDocType, "target=", hpricot_ele_set_target, 1);
  rb_define_method(cDocType, "public_id", hpricot_ele_get_public_id, 0);
  rb_define_method(cDocType, "public_id=", hpricot_ele_set_public_id, 1);
  rb_define_method(cDocType, "system_id", hpricot_ele_get_system_id, 0);
  rb_define_method(cDocType, "system_id=", hpricot_ele_set_system_id, 1);
  cElem = rb_define_class_under(mHpricot, "Elem", structElem);
  rb_define_method(cElem, "clear_raw", hpricot_ele_clear_raw, 0);
  cBogusETag = rb_define_class_under(mHpricot, "BogusETag", structAttr);
  rb_define_method(cBogusETag, "raw_string", hpricot_ele_get_attr, 0);
  rb_define_method(cBogusETag, "clear_raw", hpricot_ele_clear_attr, 0);
  cText = rb_define_class_under(mHpricot, "Text", structBasic);
  rb_define_method(cText, "raw_string", hpricot_ele_get_name, 0);
  rb_define_method(cText, "clear_raw", hpricot_ele_clear_name, 0);
  rb_define_method(cText, "content", hpricot_ele_get_name, 0);
  rb_define_method(cText, "content=", hpricot_ele_set_name, 1);
  cXMLDecl = rb_define_class_under(mHpricot, "XMLDecl", structAttr);
  rb_define_method(cXMLDecl, "raw_string", hpricot_ele_get_name, 0);
  rb_define_method(cXMLDecl, "clear_raw", hpricot_ele_clear_name, 0);
  rb_define_method(cXMLDecl, "encoding", hpricot_ele_get_encoding, 0);
  rb_define_method(cXMLDecl, "encoding=", hpricot_ele_set_encoding, 1);
  rb_define_method(cXMLDecl, "standalone", hpricot_ele_get_standalone, 0);
  rb_define_method(cXMLDecl, "standalone=", hpricot_ele_set_standalone, 1);
  rb_define_method(cXMLDecl, "version", hpricot_ele_get_version, 0);
  rb_define_method(cXMLDecl, "version=", hpricot_ele_set_version, 1);
  cProcIns = rb_define_class_under(mHpricot, "ProcIns", structAttr);
  rb_define_method(cProcIns, "target", hpricot_ele_get_name, 0);
  rb_define_method(cProcIns, "target=", hpricot_ele_set_name, 1);
  rb_define_method(cProcIns, "content", hpricot_ele_get_attr, 0);
  rb_define_method(cProcIns, "content=", hpricot_ele_set_attr, 1);

  rb_const_set(mHpricot, rb_intern("ProcInsParse"),
    reProcInsParse = rb_eval_string("/\\A<\\?(\\S+)\\s+(.+)/m"));
}
