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

%%{
  machine hpricot_scan;

  action newEle {
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

  action _tag { mark_tag = p; }
  action _aval { mark_aval = p; }
  action _akey { mark_akey = p; }
  action tag { SET(tag, p); }
  action tagc { SET(tag, p-1); }
  action aval { SET(aval, p); }
  action aunq {
    if (*(p-1) == '"' || *(p-1) == '\'') { SET(aval, p-1); }
    else { SET(aval, p); }
  }
  action akey { SET(akey, p); }
  action xmlver { SET(aval, p); ATTR(ID2SYM(rb_intern("version")), aval); }
  action xmlenc { SET(aval, p); ATTR(ID2SYM(rb_intern("encoding")), aval); }
  action xmlsd  { SET(aval, p); ATTR(ID2SYM(rb_intern("standalone")), aval); }
  action pubid  { SET(aval, p); ATTR(ID2SYM(rb_intern("public_id")), aval); }
  action sysid  { SET(aval, p); ATTR(ID2SYM(rb_intern("system_id")), aval); }

  action new_attr {
    akey = Qnil;
    aval = Qnil;
    mark_akey = NULL;
    mark_aval = NULL;
  }

  action save_attr {
    if (!S->xml)
      akey = rb_funcall(akey, s_downcase, 0);
    ATTR(akey, aval);
  }

  include hpricot_common "hpricot_common.rl";

}%%

%% write data nofinal;

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

  %% write init;

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
    %% write exec;

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
