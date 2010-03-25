/*
 * hpricot_css.rl
 * ragel -C hpricot_css.rl -o hpricot_css.c
 *
 * Copyright (C) 2008 why the lucky stiff
 */
#include <ruby.h>

#define FILTER(id) \
  rb_funcall2(mod, rb_intern("" # id), fargs, fvals); \
  rb_ary_clear(tmpt); \
  fargs = 1
#define FILTERAUTO() \
  char filt[10]; \
  sprintf(filt, "%.*s", te - ts, ts); \
  rb_funcall2(mod, rb_intern(filt), fargs, fvals); \
  rb_ary_clear(tmpt); \
  fargs = 1
#define PUSH(aps, ape) rb_ary_push(tmpt, fvals[fargs++] = rb_str_new(aps, ape - aps))
#define P(id) printf(id ": %.*s\n", te - ts, ts);

%%{
  machine hpricot_css;

  action a {
    aps = p;
  }

  action b {
    ape = p;
    PUSH(aps, ape); 
  }

  action c {
    ape = p;
    aps2 = p;
  }

  action d {
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }

  commas    = space* "," space*;
  traverse  = [>+~];
  sdot      = "\\.";
  utfw      = alnum | "_" | "-" | 
              (0xc4 0xa8..0xbf) | (0xc5..0xdf 0x80..0xbf) |
              (0xe0..0xef 0x80..0xbf 0x80..0xbf) |
              (0xf0..0xf4 0x80..0xbf 0x80..0xbf 0x80..0xbf);
  utfword   = utfw+;
  utfname   = (utfw | sdot)+; 
  quote1    = "'" [^']* "'";
  quote2    = '"' [^"]* '"';

  cssid     = "#" %a utfname %b;
  cssclass  = "." %a utfname %b;
  cssname   = "[name=" %a utfname %b "]";
  cssattr   = "[" %a utfname %c space* [^ \n\t]? "=" %d space* (quote1 | quote2 | [^\]]+) "]";
  csstag    = utfname >a %b;
  cssmod    = ("even" | "odd" | (digit | "n" | "+" | "-")* );
  csschild  = ":" %a ("only" | "nth" | "last" | "first") "-child" %b ("(" %a cssmod %b ")")?;
  csspos    = ":" %a ("nth" | "eq" | "gt" | "lt" | "first" | "last" | "even" | "odd") %b ("(" %a digit+ %b ")")?;
  pseudop   = "(" [^)]+ ")";
  pseudoq   = "'" (pseudop+ | [^'()]*) "'" |
              '"' (pseudop+ | [^"()]*) '"' |
                  (pseudop+ | [^"()]*);
  pseudo    = ":" %a utfname %b ("(" %a pseudoq %b ")")?;

  main     := |*
    cssid      => { FILTER(ID); };
    cssclass   => { FILTER(CLASS); };
    cssname    => { FILTER(NAME); };
    cssattr    => { FILTER(ATTR); };
    csstag     => { FILTER(TAG); };
    cssmod     => { FILTER(MOD); };
    csschild   => { FILTER(CHILD); };
    csspos     => { FILTER(POS); };
    pseudo     => { FILTER(PSUEDO); };
    commas     => { focus = rb_ary_new3(1, node); };
    traverse   => { FILTERAUTO(); };
    space;
  *|;

  write data nofinal;
}%%

VALUE hpricot_css(VALUE self, VALUE mod, VALUE str, VALUE node)
{
  int cs, act, eof;
  char *p, *pe, *ts, *te, *aps, *ape, *aps2, *ape2;

  int fargs = 1;
  VALUE fvals[6];
  VALUE focus = rb_ary_new3(1, node);
  VALUE tmpt = rb_ary_new();
  rb_gc_register_address(&focus);
  rb_gc_register_address(&tmpt);
  fvals[0] = focus;

  if (TYPE(str) != T_STRING)
    rb_raise(rb_eArgError, "bad CSS selector, String only please.");
 
  StringValue(str);
  p = RSTRING_PTR(str);
  pe = p + RSTRING_LEN(str);

  %% write init;
  %% write exec;
  
  rb_gc_unregister_address(&focus);
  rb_gc_unregister_address(&tmpt);
  return focus;
}
