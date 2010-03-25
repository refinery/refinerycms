#line 1 "hpricot_css.rl"
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


#line 25 "hpricot_css.c"
static const int hpricot_css_start = 87;
static const int hpricot_css_error = 0;

static const int hpricot_css_en_main = 87;

#line 87 "hpricot_css.rl"


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

  
#line 55 "hpricot_css.c"
	{
	cs = hpricot_css_start;
	ts = 0;
	te = 0;
	act = 0;
	}
#line 110 "hpricot_css.rl"
  
#line 64 "hpricot_css.c"
	{
	if ( p == pe )
		goto _test_eof;
	switch ( cs )
	{
tr0:
#line 1 "hpricot_css.rl"
	{	switch( act ) {
	case 0:
	{{goto st0;}}
	break;
	case 1:
	{{p = ((te))-1;} FILTER(ID); }
	break;
	case 2:
	{{p = ((te))-1;} FILTER(CLASS); }
	break;
	case 5:
	{{p = ((te))-1;} FILTER(TAG); }
	break;
	case 7:
	{{p = ((te))-1;} FILTER(CHILD); }
	break;
	case 8:
	{{p = ((te))-1;} FILTER(POS); }
	break;
	case 9:
	{{p = ((te))-1;} FILTER(PSUEDO); }
	break;
	default: break;
	}
	}
	goto st87;
tr4:
#line 83 "hpricot_css.rl"
	{{p = ((te))-1;}}
	goto st87;
tr41:
#line 80 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(PSUEDO); }}
	goto st87;
tr46:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p+1;{ FILTER(PSUEDO); }}
	goto st87;
tr48:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p+1;{ FILTER(PSUEDO); }}
	goto st87;
tr62:
#line 79 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(POS); }}
	goto st87;
tr64:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 79 "hpricot_css.rl"
	{te = p+1;{ FILTER(POS); }}
	goto st87;
tr66:
#line 78 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(CHILD); }}
	goto st87;
tr67:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p+1;{ FILTER(CHILD); }}
	goto st87;
tr71:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p+1;{ FILTER(CHILD); }}
	goto st87;
tr100:
#line 75 "hpricot_css.rl"
	{te = p+1;{ FILTER(ATTR); }}
	goto st87;
tr105:
#line 75 "hpricot_css.rl"
	{{p = ((te))-1;}{ FILTER(ATTR); }}
	goto st87;
tr132:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 74 "hpricot_css.rl"
	{te = p+1;{ FILTER(NAME); }}
	goto st87;
tr143:
#line 82 "hpricot_css.rl"
	{te = p+1;{ FILTERAUTO(); }}
	goto st87;
tr149:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 76 "hpricot_css.rl"
	{te = p;p--;{ FILTER(TAG); }}
	goto st87;
tr153:
#line 83 "hpricot_css.rl"
	{te = p;p--;}
	goto st87;
tr154:
#line 81 "hpricot_css.rl"
	{te = p;p--;{ focus = rb_ary_new3(1, node); }}
	goto st87;
tr155:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 72 "hpricot_css.rl"
	{te = p;p--;{ FILTER(ID); }}
	goto st87;
tr159:
#line 77 "hpricot_css.rl"
	{te = p;p--;{ FILTER(MOD); }}
	goto st87;
tr162:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 73 "hpricot_css.rl"
	{te = p;p--;{ FILTER(CLASS); }}
	goto st87;
tr166:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{te = p;p--;{ FILTER(PSUEDO); }}
	goto st87;
tr173:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 79 "hpricot_css.rl"
	{te = p;p--;{ FILTER(POS); }}
	goto st87;
tr192:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 78 "hpricot_css.rl"
	{te = p;p--;{ FILTER(CHILD); }}
	goto st87;
tr200:
#line 75 "hpricot_css.rl"
	{te = p;p--;{ FILTER(ATTR); }}
	goto st87;
st87:
#line 1 "hpricot_css.rl"
	{ts = 0;}
#line 1 "hpricot_css.rl"
	{act = 0;}
	if ( ++p == pe )
		goto _test_eof87;
case 87:
#line 1 "hpricot_css.rl"
	{ts = p;}
#line 268 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr133;
		case 32: goto tr137;
		case 35: goto st7;
		case 43: goto st92;
		case 44: goto st90;
		case 45: goto tr140;
		case 46: goto st13;
		case 58: goto st19;
		case 62: goto tr143;
		case 91: goto st52;
		case 92: goto tr146;
		case 95: goto tr144;
		case 101: goto tr147;
		case 110: goto tr140;
		case 111: goto tr148;
		case 126: goto tr143;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr134;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr136;
		} else
			goto tr135;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr140;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr144;
		} else
			goto tr144;
	} else
		goto tr137;
	goto st0;
st0:
cs = 0;
	goto _out;
tr133:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st1;
st1:
	if ( ++p == pe )
		goto _test_eof1;
case 1:
#line 321 "hpricot_css.c"
	if ( -88 <= (*p) && (*p) <= -65 )
		goto tr1;
	goto tr0;
tr1:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st88;
tr144:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st88;
st88:
	if ( ++p == pe )
		goto _test_eof88;
case 88:
#line 345 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
tr134:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st2;
st2:
	if ( ++p == pe )
		goto _test_eof2;
case 2:
#line 380 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto tr1;
	goto tr0;
tr135:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st3;
st3:
	if ( ++p == pe )
		goto _test_eof3;
case 3:
#line 394 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st2;
	goto tr0;
tr136:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st4;
st4:
	if ( ++p == pe )
		goto _test_eof4;
case 4:
#line 408 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st3;
	goto tr0;
tr146:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st5;
st5:
	if ( ++p == pe )
		goto _test_eof5;
case 5:
#line 422 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr1;
	goto tr0;
tr137:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st89;
st89:
	if ( ++p == pe )
		goto _test_eof89;
case 89:
#line 434 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st6;
		case 44: goto st90;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st6;
	goto tr153;
st6:
	if ( ++p == pe )
		goto _test_eof6;
case 6:
	switch( (*p) ) {
		case 32: goto st6;
		case 44: goto st90;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st6;
	goto tr4;
st90:
	if ( ++p == pe )
		goto _test_eof90;
case 90:
	if ( (*p) == 32 )
		goto st90;
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st90;
	goto tr154;
st7:
	if ( ++p == pe )
		goto _test_eof7;
case 7:
	switch( (*p) ) {
		case -60: goto tr7;
		case 45: goto tr12;
		case 92: goto tr13;
		case 95: goto tr12;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr10;
		} else if ( (*p) >= -59 )
			goto tr9;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr12;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr12;
		} else
			goto tr12;
	} else
		goto tr11;
	goto st0;
tr7:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st8;
st8:
	if ( ++p == pe )
		goto _test_eof8;
case 8:
#line 500 "hpricot_css.c"
	if ( -88 <= (*p) && (*p) <= -65 )
		goto tr14;
	goto tr0;
tr12:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 72 "hpricot_css.rl"
	{act = 1;}
	goto st91;
tr14:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 72 "hpricot_css.rl"
	{act = 1;}
	goto st91;
st91:
	if ( ++p == pe )
		goto _test_eof91;
case 91:
#line 524 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st8;
		case 45: goto tr14;
		case 92: goto st12;
		case 95: goto tr14;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st10;
		} else if ( (*p) >= -59 )
			goto st9;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr14;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr14;
		} else
			goto tr14;
	} else
		goto st11;
	goto tr155;
tr9:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st9;
st9:
	if ( ++p == pe )
		goto _test_eof9;
case 9:
#line 559 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto tr14;
	goto tr0;
tr10:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st10;
st10:
	if ( ++p == pe )
		goto _test_eof10;
case 10:
#line 573 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st9;
	goto tr0;
tr11:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st11;
st11:
	if ( ++p == pe )
		goto _test_eof11;
case 11:
#line 587 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st10;
	goto tr0;
tr13:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st12;
st12:
	if ( ++p == pe )
		goto _test_eof12;
case 12:
#line 601 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr14;
	goto tr0;
tr160:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st92;
st92:
	if ( ++p == pe )
		goto _test_eof92;
case 92:
#line 616 "hpricot_css.c"
	switch( (*p) ) {
		case 43: goto st92;
		case 45: goto st92;
		case 110: goto st92;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st92;
	goto tr159;
tr161:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st93;
tr140:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st93;
st93:
	if ( ++p == pe )
		goto _test_eof93;
case 93:
#line 645 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 43: goto tr160;
		case 45: goto tr161;
		case 92: goto st5;
		case 95: goto tr1;
		case 110: goto tr161;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr161;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
st13:
	if ( ++p == pe )
		goto _test_eof13;
case 13:
	switch( (*p) ) {
		case -60: goto tr17;
		case 45: goto tr21;
		case 92: goto tr22;
		case 95: goto tr21;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr19;
		} else if ( (*p) >= -59 )
			goto tr18;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr21;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr21;
		} else
			goto tr21;
	} else
		goto tr20;
	goto st0;
tr17:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st14;
st14:
	if ( ++p == pe )
		goto _test_eof14;
case 14:
#line 710 "hpricot_css.c"
	if ( -88 <= (*p) && (*p) <= -65 )
		goto tr23;
	goto tr0;
tr21:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 73 "hpricot_css.rl"
	{act = 2;}
	goto st94;
tr23:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 73 "hpricot_css.rl"
	{act = 2;}
	goto st94;
st94:
	if ( ++p == pe )
		goto _test_eof94;
case 94:
#line 734 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st14;
		case 45: goto tr23;
		case 92: goto st18;
		case 95: goto tr23;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st16;
		} else if ( (*p) >= -59 )
			goto st15;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr23;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr23;
		} else
			goto tr23;
	} else
		goto st17;
	goto tr162;
tr18:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st15;
st15:
	if ( ++p == pe )
		goto _test_eof15;
case 15:
#line 769 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto tr23;
	goto tr0;
tr19:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st16;
st16:
	if ( ++p == pe )
		goto _test_eof16;
case 16:
#line 783 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st15;
	goto tr0;
tr20:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st17;
st17:
	if ( ++p == pe )
		goto _test_eof17;
case 17:
#line 797 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st16;
	goto tr0;
tr22:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st18;
st18:
	if ( ++p == pe )
		goto _test_eof18;
case 18:
#line 811 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr23;
	goto tr0;
st19:
	if ( ++p == pe )
		goto _test_eof19;
case 19:
	switch( (*p) ) {
		case -60: goto tr26;
		case 45: goto tr30;
		case 92: goto tr31;
		case 95: goto tr30;
		case 101: goto tr32;
		case 102: goto tr33;
		case 103: goto tr34;
		case 108: goto tr35;
		case 110: goto tr36;
		case 111: goto tr37;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr28;
		} else if ( (*p) >= -59 )
			goto tr27;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr30;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr30;
		} else
			goto tr30;
	} else
		goto tr29;
	goto st0;
tr26:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st20;
tr174:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st20;
st20:
	if ( ++p == pe )
		goto _test_eof20;
case 20:
#line 866 "hpricot_css.c"
	if ( -88 <= (*p) && (*p) <= -65 )
		goto tr38;
	goto tr0;
tr30:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st95;
tr38:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st95;
tr179:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st95;
st95:
	if ( ++p == pe )
		goto _test_eof95;
case 95:
#line 901 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr27:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st21;
tr175:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st21;
st21:
	if ( ++p == pe )
		goto _test_eof21;
case 21:
#line 944 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto tr38;
	goto tr0;
tr28:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st22;
tr176:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st22;
st22:
	if ( ++p == pe )
		goto _test_eof22;
case 22:
#line 965 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st21;
	goto tr0;
tr29:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st23;
tr177:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st23;
st23:
	if ( ++p == pe )
		goto _test_eof23;
case 23:
#line 986 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st22;
	goto tr0;
tr169:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st24;
st24:
	if ( ++p == pe )
		goto _test_eof24;
case 24:
#line 1001 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr43;
		case 39: goto tr44;
		case 40: goto tr45;
		case 41: goto tr46;
	}
	goto tr42;
tr42:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st25;
st25:
	if ( ++p == pe )
		goto _test_eof25;
case 25:
#line 1019 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr0;
		case 40: goto tr0;
		case 41: goto tr48;
	}
	goto st25;
tr43:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st26;
st26:
	if ( ++p == pe )
		goto _test_eof26;
case 26:
#line 1036 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st28;
		case 40: goto st29;
		case 41: goto tr0;
	}
	goto st27;
st27:
	if ( ++p == pe )
		goto _test_eof27;
case 27:
	if ( (*p) == 34 )
		goto st28;
	if ( 40 <= (*p) && (*p) <= 41 )
		goto tr0;
	goto st27;
st28:
	if ( ++p == pe )
		goto _test_eof28;
case 28:
	if ( (*p) == 41 )
		goto tr48;
	goto tr0;
st29:
	if ( ++p == pe )
		goto _test_eof29;
case 29:
	if ( (*p) == 41 )
		goto tr0;
	goto st30;
st30:
	if ( ++p == pe )
		goto _test_eof30;
case 30:
	if ( (*p) == 41 )
		goto st31;
	goto st30;
st31:
	if ( ++p == pe )
		goto _test_eof31;
case 31:
	switch( (*p) ) {
		case 34: goto st28;
		case 40: goto st29;
	}
	goto tr0;
tr44:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st32;
st32:
	if ( ++p == pe )
		goto _test_eof32;
case 32:
#line 1092 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st34;
		case 39: goto st25;
		case 40: goto st35;
		case 41: goto tr48;
	}
	goto st33;
st33:
	if ( ++p == pe )
		goto _test_eof33;
case 33:
	switch( (*p) ) {
		case 34: goto st34;
		case 39: goto st25;
		case 40: goto tr0;
		case 41: goto tr48;
	}
	goto st33;
st34:
	if ( ++p == pe )
		goto _test_eof34;
case 34:
	if ( (*p) == 39 )
		goto st28;
	if ( 40 <= (*p) && (*p) <= 41 )
		goto tr0;
	goto st34;
st35:
	if ( ++p == pe )
		goto _test_eof35;
case 35:
	if ( (*p) == 41 )
		goto tr0;
	goto st36;
st36:
	if ( ++p == pe )
		goto _test_eof36;
case 36:
	if ( (*p) == 41 )
		goto st37;
	goto st36;
st37:
	if ( ++p == pe )
		goto _test_eof37;
case 37:
	switch( (*p) ) {
		case 39: goto st28;
		case 40: goto st35;
	}
	goto tr0;
tr45:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st38;
st38:
	if ( ++p == pe )
		goto _test_eof38;
case 38:
#line 1153 "hpricot_css.c"
	if ( (*p) == 41 )
		goto tr0;
	goto st39;
st39:
	if ( ++p == pe )
		goto _test_eof39;
case 39:
	if ( (*p) == 41 )
		goto st40;
	goto st39;
st40:
	if ( ++p == pe )
		goto _test_eof40;
case 40:
	switch( (*p) ) {
		case 40: goto st38;
		case 41: goto tr48;
	}
	goto tr0;
tr31:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st41;
tr180:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st41;
st41:
	if ( ++p == pe )
		goto _test_eof41;
case 41:
#line 1190 "hpricot_css.c"
	if ( (*p) == 46 )
		goto tr38;
	goto tr0;
tr32:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st96;
st96:
	if ( ++p == pe )
		goto _test_eof96;
case 96:
#line 1208 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 113: goto tr171;
		case 118: goto tr172;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr171:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 79 "hpricot_css.rl"
	{act = 8;}
	goto st97;
st97:
	if ( ++p == pe )
		goto _test_eof97;
case 97:
#line 1246 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr174;
		case 40: goto tr178;
		case 45: goto tr179;
		case 92: goto tr180;
		case 95: goto tr179;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr176;
		} else if ( (*p) >= -59 )
			goto tr175;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr179;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr179;
		} else
			goto tr179;
	} else
		goto tr177;
	goto tr173;
tr178:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st42;
st42:
	if ( ++p == pe )
		goto _test_eof42;
case 42:
#line 1283 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr43;
		case 39: goto tr44;
		case 40: goto tr45;
		case 41: goto tr46;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr63;
	goto tr42;
tr63:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st43;
st43:
	if ( ++p == pe )
		goto _test_eof43;
case 43:
#line 1303 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr62;
		case 40: goto tr62;
		case 41: goto tr64;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st43;
	goto st25;
tr172:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st98;
st98:
	if ( ++p == pe )
		goto _test_eof98;
case 98:
#line 1322 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 101: goto tr181;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr181:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st99;
st99:
	if ( ++p == pe )
		goto _test_eof99;
case 99:
#line 1359 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 110: goto tr171;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr33:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st100;
st100:
	if ( ++p == pe )
		goto _test_eof100;
case 100:
#line 1400 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 105: goto tr182;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr182:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st101;
st101:
	if ( ++p == pe )
		goto _test_eof101;
case 101:
#line 1437 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 114: goto tr183;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr183:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st102;
st102:
	if ( ++p == pe )
		goto _test_eof102;
case 102:
#line 1474 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 115: goto tr184;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr184:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st103;
st103:
	if ( ++p == pe )
		goto _test_eof103;
case 103:
#line 1511 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 116: goto tr185;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr185:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 79 "hpricot_css.rl"
	{act = 8;}
	goto st104;
st104:
	if ( ++p == pe )
		goto _test_eof104;
case 104:
#line 1548 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr174;
		case 40: goto tr178;
		case 45: goto tr186;
		case 92: goto tr180;
		case 95: goto tr179;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr176;
		} else if ( (*p) >= -59 )
			goto tr175;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr179;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr179;
		} else
			goto tr179;
	} else
		goto tr177;
	goto tr173;
tr199:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st105;
tr186:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st105;
st105:
	if ( ++p == pe )
		goto _test_eof105;
case 105:
#line 1595 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 99: goto tr187;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr187:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st106;
st106:
	if ( ++p == pe )
		goto _test_eof106;
case 106:
#line 1632 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 104: goto tr188;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr188:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st107;
st107:
	if ( ++p == pe )
		goto _test_eof107;
case 107:
#line 1669 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 105: goto tr189;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr189:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st108;
st108:
	if ( ++p == pe )
		goto _test_eof108;
case 108:
#line 1706 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 108: goto tr190;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr190:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st109;
st109:
	if ( ++p == pe )
		goto _test_eof109;
case 109:
#line 1743 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 100: goto tr191;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr191:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 78 "hpricot_css.rl"
	{act = 7;}
	goto st110;
st110:
	if ( ++p == pe )
		goto _test_eof110;
case 110:
#line 1780 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr174;
		case 40: goto tr193;
		case 45: goto tr179;
		case 92: goto tr180;
		case 95: goto tr179;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr176;
		} else if ( (*p) >= -59 )
			goto tr175;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr179;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr179;
		} else
			goto tr179;
	} else
		goto tr177;
	goto tr192;
tr193:
#line 29 "hpricot_css.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	goto st44;
st44:
	if ( ++p == pe )
		goto _test_eof44;
case 44:
#line 1817 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr43;
		case 39: goto tr44;
		case 40: goto tr45;
		case 41: goto tr67;
		case 43: goto tr68;
		case 45: goto tr68;
		case 101: goto tr69;
		case 110: goto tr68;
		case 111: goto tr70;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto tr68;
	goto tr42;
tr68:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st45;
st45:
	if ( ++p == pe )
		goto _test_eof45;
case 45:
#line 1842 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr71;
		case 43: goto st45;
		case 45: goto st45;
		case 110: goto st45;
	}
	if ( 48 <= (*p) && (*p) <= 57 )
		goto st45;
	goto st25;
tr69:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st46;
st46:
	if ( ++p == pe )
		goto _test_eof46;
case 46:
#line 1864 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr48;
		case 118: goto st47;
	}
	goto st25;
st47:
	if ( ++p == pe )
		goto _test_eof47;
case 47:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr48;
		case 101: goto st48;
	}
	goto st25;
st48:
	if ( ++p == pe )
		goto _test_eof48;
case 48:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr48;
		case 110: goto st49;
	}
	goto st25;
st49:
	if ( ++p == pe )
		goto _test_eof49;
case 49:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr71;
	}
	goto st25;
tr70:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st50;
st50:
	if ( ++p == pe )
		goto _test_eof50;
case 50:
#line 1914 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr48;
		case 100: goto st51;
	}
	goto st25;
st51:
	if ( ++p == pe )
		goto _test_eof51;
case 51:
	switch( (*p) ) {
		case 34: goto tr66;
		case 40: goto tr66;
		case 41: goto tr48;
		case 100: goto st49;
	}
	goto st25;
tr34:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st111;
st111:
	if ( ++p == pe )
		goto _test_eof111;
case 111:
#line 1947 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 116: goto tr171;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr35:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st112;
st112:
	if ( ++p == pe )
		goto _test_eof112;
case 112:
#line 1988 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 97: goto tr183;
		case 116: goto tr171;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 98 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr36:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st113;
st113:
	if ( ++p == pe )
		goto _test_eof113;
case 113:
#line 2030 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 116: goto tr194;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr194:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st114;
st114:
	if ( ++p == pe )
		goto _test_eof114;
case 114:
#line 2067 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 104: goto tr185;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr37:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st115;
st115:
	if ( ++p == pe )
		goto _test_eof115;
case 115:
#line 2108 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 100: goto tr195;
		case 110: goto tr196;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr195:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st116;
st116:
	if ( ++p == pe )
		goto _test_eof116;
case 116:
#line 2146 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 100: goto tr171;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr196:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st117;
st117:
	if ( ++p == pe )
		goto _test_eof117;
case 117:
#line 2183 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 108: goto tr197;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr197:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st118;
st118:
	if ( ++p == pe )
		goto _test_eof118;
case 118:
#line 2220 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr38;
		case 92: goto st41;
		case 95: goto tr38;
		case 121: goto tr198;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
tr198:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 80 "hpricot_css.rl"
	{act = 9;}
	goto st119;
st119:
	if ( ++p == pe )
		goto _test_eof119;
case 119:
#line 2257 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st20;
		case 40: goto tr169;
		case 45: goto tr199;
		case 92: goto st41;
		case 95: goto tr38;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st22;
		} else if ( (*p) >= -59 )
			goto st21;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr38;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr38;
		} else
			goto tr38;
	} else
		goto st23;
	goto tr166;
st52:
	if ( ++p == pe )
		goto _test_eof52;
case 52:
	switch( (*p) ) {
		case -60: goto tr77;
		case 45: goto tr81;
		case 92: goto tr82;
		case 95: goto tr81;
		case 110: goto tr83;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto tr79;
		} else if ( (*p) >= -59 )
			goto tr78;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr81;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr81;
		} else
			goto tr81;
	} else
		goto tr80;
	goto st0;
tr77:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st53;
st53:
	if ( ++p == pe )
		goto _test_eof53;
case 53:
#line 2322 "hpricot_css.c"
	if ( -88 <= (*p) && (*p) <= -65 )
		goto st54;
	goto st0;
tr81:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st54;
tr91:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st54;
st54:
	if ( ++p == pe )
		goto _test_eof54;
case 54:
#line 2343 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr86;
		case 32: goto tr90;
		case 45: goto tr91;
		case 61: goto tr92;
		case 92: goto tr93;
		case 95: goto tr91;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr87;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr89;
		} else
			goto tr88;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr91;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr91;
		} else
			goto tr91;
	} else
		goto tr90;
	goto tr85;
tr85:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st55;
st55:
	if ( ++p == pe )
		goto _test_eof55;
case 55:
#line 2384 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st56;
	goto st0;
st56:
	if ( ++p == pe )
		goto _test_eof56;
case 56:
	switch( (*p) ) {
		case 32: goto tr96;
		case 34: goto tr97;
		case 39: goto tr98;
		case 93: goto st0;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr96;
	goto tr95;
tr95:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st57;
st57:
	if ( ++p == pe )
		goto _test_eof57;
case 57:
#line 2413 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr100;
	goto st57;
tr96:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st58;
st58:
	if ( ++p == pe )
		goto _test_eof58;
case 58:
#line 2429 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st58;
		case 34: goto st59;
		case 39: goto st62;
		case 93: goto tr100;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st58;
	goto st57;
tr97:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st59;
st59:
	if ( ++p == pe )
		goto _test_eof59;
case 59:
#line 2451 "hpricot_css.c"
	switch( (*p) ) {
		case 34: goto st57;
		case 93: goto tr104;
	}
	goto st59;
tr104:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st120;
st120:
	if ( ++p == pe )
		goto _test_eof120;
case 120:
#line 2465 "hpricot_css.c"
	if ( (*p) == 34 )
		goto st61;
	goto st60;
st60:
	if ( ++p == pe )
		goto _test_eof60;
case 60:
	if ( (*p) == 34 )
		goto st61;
	goto st60;
st61:
	if ( ++p == pe )
		goto _test_eof61;
case 61:
	if ( (*p) == 93 )
		goto tr100;
	goto tr105;
tr98:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st62;
st62:
	if ( ++p == pe )
		goto _test_eof62;
case 62:
#line 2495 "hpricot_css.c"
	switch( (*p) ) {
		case 39: goto st57;
		case 93: goto tr108;
	}
	goto st62;
tr108:
#line 1 "hpricot_css.rl"
	{te = p+1;}
	goto st121;
st121:
	if ( ++p == pe )
		goto _test_eof121;
case 121:
#line 2509 "hpricot_css.c"
	if ( (*p) == 39 )
		goto st61;
	goto st63;
st63:
	if ( ++p == pe )
		goto _test_eof63;
case 63:
	if ( (*p) == 39 )
		goto st61;
	goto st63;
tr86:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st64;
st64:
	if ( ++p == pe )
		goto _test_eof64;
case 64:
#line 2531 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st56;
	if ( -88 <= (*p) && (*p) <= -65 )
		goto st54;
	goto st0;
tr87:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st65;
st65:
	if ( ++p == pe )
		goto _test_eof65;
case 65:
#line 2548 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st56;
	if ( (*p) <= -65 )
		goto st54;
	goto st0;
tr88:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st66;
st66:
	if ( ++p == pe )
		goto _test_eof66;
case 66:
#line 2565 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st56;
	if ( (*p) <= -65 )
		goto st67;
	goto st0;
tr78:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st67;
st67:
	if ( ++p == pe )
		goto _test_eof67;
case 67:
#line 2581 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st54;
	goto st0;
tr89:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st68;
st68:
	if ( ++p == pe )
		goto _test_eof68;
case 68:
#line 2596 "hpricot_css.c"
	if ( (*p) == 61 )
		goto st56;
	if ( (*p) <= -65 )
		goto st69;
	goto st0;
tr79:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st69;
st69:
	if ( ++p == pe )
		goto _test_eof69;
case 69:
#line 2612 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st67;
	goto st0;
tr90:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st70;
st70:
	if ( ++p == pe )
		goto _test_eof70;
case 70:
#line 2627 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto st70;
		case 61: goto st71;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto st70;
	goto st55;
tr92:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st71;
st71:
	if ( ++p == pe )
		goto _test_eof71;
case 71:
#line 2646 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr96;
		case 34: goto tr97;
		case 39: goto tr98;
		case 61: goto tr115;
		case 93: goto st0;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr96;
	goto tr95;
tr115:
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st72;
st72:
	if ( ++p == pe )
		goto _test_eof72;
case 72:
#line 2669 "hpricot_css.c"
	switch( (*p) ) {
		case 32: goto tr96;
		case 34: goto tr97;
		case 39: goto tr98;
		case 93: goto tr100;
	}
	if ( 9 <= (*p) && (*p) <= 13 )
		goto tr96;
	goto tr95;
tr93:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st73;
st73:
	if ( ++p == pe )
		goto _test_eof73;
case 73:
#line 2690 "hpricot_css.c"
	switch( (*p) ) {
		case 46: goto st54;
		case 61: goto st56;
	}
	goto st0;
tr80:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st74;
st74:
	if ( ++p == pe )
		goto _test_eof74;
case 74:
#line 2706 "hpricot_css.c"
	if ( (*p) <= -65 )
		goto st69;
	goto st0;
tr82:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st75;
st75:
	if ( ++p == pe )
		goto _test_eof75;
case 75:
#line 2720 "hpricot_css.c"
	if ( (*p) == 46 )
		goto st54;
	goto st0;
tr83:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
	goto st76;
st76:
	if ( ++p == pe )
		goto _test_eof76;
case 76:
#line 2734 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr86;
		case 32: goto tr90;
		case 45: goto tr91;
		case 61: goto tr92;
		case 92: goto tr93;
		case 95: goto tr91;
		case 97: goto tr116;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr87;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr89;
		} else
			goto tr88;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr91;
		} else if ( (*p) > 90 ) {
			if ( 98 <= (*p) && (*p) <= 122 )
				goto tr91;
		} else
			goto tr91;
	} else
		goto tr90;
	goto tr85;
tr116:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st77;
st77:
	if ( ++p == pe )
		goto _test_eof77;
case 77:
#line 2776 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr86;
		case 32: goto tr90;
		case 45: goto tr91;
		case 61: goto tr92;
		case 92: goto tr93;
		case 95: goto tr91;
		case 109: goto tr117;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr87;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr89;
		} else
			goto tr88;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr91;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr91;
		} else
			goto tr91;
	} else
		goto tr90;
	goto tr85;
tr117:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st78;
st78:
	if ( ++p == pe )
		goto _test_eof78;
case 78:
#line 2818 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr86;
		case 32: goto tr90;
		case 45: goto tr91;
		case 61: goto tr92;
		case 92: goto tr93;
		case 95: goto tr91;
		case 101: goto tr118;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr87;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr89;
		} else
			goto tr88;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr91;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr91;
		} else
			goto tr91;
	} else
		goto tr90;
	goto tr85;
tr118:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st79;
st79:
	if ( ++p == pe )
		goto _test_eof79;
case 79:
#line 2860 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr86;
		case 32: goto tr90;
		case 45: goto tr91;
		case 61: goto tr119;
		case 92: goto tr93;
		case 95: goto tr91;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr87;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr89;
		} else
			goto tr88;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr91;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr91;
		} else
			goto tr91;
	} else
		goto tr90;
	goto tr85;
tr119:
#line 34 "hpricot_css.rl"
	{
    ape = p;
    aps2 = p;
  }
	goto st80;
st80:
	if ( ++p == pe )
		goto _test_eof80;
case 80:
#line 2901 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto tr120;
		case 32: goto tr96;
		case 34: goto tr97;
		case 39: goto tr98;
		case 45: goto tr124;
		case 61: goto tr115;
		case 92: goto tr125;
		case 93: goto st0;
		case 95: goto tr124;
	}
	if ( (*p) < 9 ) {
		if ( (*p) < -32 ) {
			if ( -59 <= (*p) && (*p) <= -33 )
				goto tr121;
		} else if ( (*p) > -17 ) {
			if ( -16 <= (*p) && (*p) <= -12 )
				goto tr123;
		} else
			goto tr122;
	} else if ( (*p) > 13 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr124;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr124;
		} else
			goto tr124;
	} else
		goto tr96;
	goto tr95;
tr120:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st81;
st81:
	if ( ++p == pe )
		goto _test_eof81;
case 81:
#line 2950 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr100;
	if ( -88 <= (*p) && (*p) <= -65 )
		goto st82;
	goto st57;
tr124:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st82;
st82:
	if ( ++p == pe )
		goto _test_eof82;
case 82:
#line 2972 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st81;
		case 45: goto st82;
		case 92: goto st86;
		case 93: goto tr132;
		case 95: goto st82;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st84;
		} else if ( (*p) >= -59 )
			goto st83;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto st82;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto st82;
		} else
			goto st82;
	} else
		goto st85;
	goto st57;
tr121:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st83;
st83:
	if ( ++p == pe )
		goto _test_eof83;
case 83:
#line 3014 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr100;
	if ( (*p) <= -65 )
		goto st82;
	goto st57;
tr122:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st84;
st84:
	if ( ++p == pe )
		goto _test_eof84;
case 84:
#line 3036 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr100;
	if ( (*p) <= -65 )
		goto st83;
	goto st57;
tr123:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st85;
st85:
	if ( ++p == pe )
		goto _test_eof85;
case 85:
#line 3058 "hpricot_css.c"
	if ( (*p) == 93 )
		goto tr100;
	if ( (*p) <= -65 )
		goto st84;
	goto st57;
tr125:
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 39 "hpricot_css.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	goto st86;
st86:
	if ( ++p == pe )
		goto _test_eof86;
case 86:
#line 3080 "hpricot_css.c"
	switch( (*p) ) {
		case 46: goto st82;
		case 93: goto tr100;
	}
	goto st57;
tr147:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st122;
st122:
	if ( ++p == pe )
		goto _test_eof122;
case 122:
#line 3100 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
		case 118: goto tr201;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
tr201:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st123;
st123:
	if ( ++p == pe )
		goto _test_eof123;
case 123:
#line 3136 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
		case 101: goto tr202;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
tr202:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st124;
st124:
	if ( ++p == pe )
		goto _test_eof124;
case 124:
#line 3172 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
tr148:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 25 "hpricot_css.rl"
	{
    aps = p;
  }
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st125;
st125:
	if ( ++p == pe )
		goto _test_eof125;
case 125:
#line 3211 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
		case 100: goto tr203;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
tr203:
#line 1 "hpricot_css.rl"
	{te = p+1;}
#line 76 "hpricot_css.rl"
	{act = 5;}
	goto st126;
st126:
	if ( ++p == pe )
		goto _test_eof126;
case 126:
#line 3247 "hpricot_css.c"
	switch( (*p) ) {
		case -60: goto st1;
		case 45: goto tr1;
		case 92: goto st5;
		case 95: goto tr1;
	}
	if ( (*p) < -16 ) {
		if ( (*p) > -33 ) {
			if ( -32 <= (*p) && (*p) <= -17 )
				goto st3;
		} else if ( (*p) >= -59 )
			goto st2;
	} else if ( (*p) > -12 ) {
		if ( (*p) < 65 ) {
			if ( 48 <= (*p) && (*p) <= 57 )
				goto tr1;
		} else if ( (*p) > 90 ) {
			if ( 97 <= (*p) && (*p) <= 122 )
				goto tr1;
		} else
			goto tr1;
	} else
		goto st4;
	goto tr149;
	}
	_test_eof87: cs = 87; goto _test_eof; 
	_test_eof1: cs = 1; goto _test_eof; 
	_test_eof88: cs = 88; goto _test_eof; 
	_test_eof2: cs = 2; goto _test_eof; 
	_test_eof3: cs = 3; goto _test_eof; 
	_test_eof4: cs = 4; goto _test_eof; 
	_test_eof5: cs = 5; goto _test_eof; 
	_test_eof89: cs = 89; goto _test_eof; 
	_test_eof6: cs = 6; goto _test_eof; 
	_test_eof90: cs = 90; goto _test_eof; 
	_test_eof7: cs = 7; goto _test_eof; 
	_test_eof8: cs = 8; goto _test_eof; 
	_test_eof91: cs = 91; goto _test_eof; 
	_test_eof9: cs = 9; goto _test_eof; 
	_test_eof10: cs = 10; goto _test_eof; 
	_test_eof11: cs = 11; goto _test_eof; 
	_test_eof12: cs = 12; goto _test_eof; 
	_test_eof92: cs = 92; goto _test_eof; 
	_test_eof93: cs = 93; goto _test_eof; 
	_test_eof13: cs = 13; goto _test_eof; 
	_test_eof14: cs = 14; goto _test_eof; 
	_test_eof94: cs = 94; goto _test_eof; 
	_test_eof15: cs = 15; goto _test_eof; 
	_test_eof16: cs = 16; goto _test_eof; 
	_test_eof17: cs = 17; goto _test_eof; 
	_test_eof18: cs = 18; goto _test_eof; 
	_test_eof19: cs = 19; goto _test_eof; 
	_test_eof20: cs = 20; goto _test_eof; 
	_test_eof95: cs = 95; goto _test_eof; 
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
	_test_eof40: cs = 40; goto _test_eof; 
	_test_eof41: cs = 41; goto _test_eof; 
	_test_eof96: cs = 96; goto _test_eof; 
	_test_eof97: cs = 97; goto _test_eof; 
	_test_eof42: cs = 42; goto _test_eof; 
	_test_eof43: cs = 43; goto _test_eof; 
	_test_eof98: cs = 98; goto _test_eof; 
	_test_eof99: cs = 99; goto _test_eof; 
	_test_eof100: cs = 100; goto _test_eof; 
	_test_eof101: cs = 101; goto _test_eof; 
	_test_eof102: cs = 102; goto _test_eof; 
	_test_eof103: cs = 103; goto _test_eof; 
	_test_eof104: cs = 104; goto _test_eof; 
	_test_eof105: cs = 105; goto _test_eof; 
	_test_eof106: cs = 106; goto _test_eof; 
	_test_eof107: cs = 107; goto _test_eof; 
	_test_eof108: cs = 108; goto _test_eof; 
	_test_eof109: cs = 109; goto _test_eof; 
	_test_eof110: cs = 110; goto _test_eof; 
	_test_eof44: cs = 44; goto _test_eof; 
	_test_eof45: cs = 45; goto _test_eof; 
	_test_eof46: cs = 46; goto _test_eof; 
	_test_eof47: cs = 47; goto _test_eof; 
	_test_eof48: cs = 48; goto _test_eof; 
	_test_eof49: cs = 49; goto _test_eof; 
	_test_eof50: cs = 50; goto _test_eof; 
	_test_eof51: cs = 51; goto _test_eof; 
	_test_eof111: cs = 111; goto _test_eof; 
	_test_eof112: cs = 112; goto _test_eof; 
	_test_eof113: cs = 113; goto _test_eof; 
	_test_eof114: cs = 114; goto _test_eof; 
	_test_eof115: cs = 115; goto _test_eof; 
	_test_eof116: cs = 116; goto _test_eof; 
	_test_eof117: cs = 117; goto _test_eof; 
	_test_eof118: cs = 118; goto _test_eof; 
	_test_eof119: cs = 119; goto _test_eof; 
	_test_eof52: cs = 52; goto _test_eof; 
	_test_eof53: cs = 53; goto _test_eof; 
	_test_eof54: cs = 54; goto _test_eof; 
	_test_eof55: cs = 55; goto _test_eof; 
	_test_eof56: cs = 56; goto _test_eof; 
	_test_eof57: cs = 57; goto _test_eof; 
	_test_eof58: cs = 58; goto _test_eof; 
	_test_eof59: cs = 59; goto _test_eof; 
	_test_eof120: cs = 120; goto _test_eof; 
	_test_eof60: cs = 60; goto _test_eof; 
	_test_eof61: cs = 61; goto _test_eof; 
	_test_eof62: cs = 62; goto _test_eof; 
	_test_eof121: cs = 121; goto _test_eof; 
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
	_test_eof85: cs = 85; goto _test_eof; 
	_test_eof86: cs = 86; goto _test_eof; 
	_test_eof122: cs = 122; goto _test_eof; 
	_test_eof123: cs = 123; goto _test_eof; 
	_test_eof124: cs = 124; goto _test_eof; 
	_test_eof125: cs = 125; goto _test_eof; 
	_test_eof126: cs = 126; goto _test_eof; 

	_test_eof: {}
	if ( p == eof )
	{
	switch ( cs ) {
	case 1: goto tr0;
	case 88: goto tr149;
	case 2: goto tr0;
	case 3: goto tr0;
	case 4: goto tr0;
	case 5: goto tr0;
	case 89: goto tr153;
	case 6: goto tr4;
	case 90: goto tr154;
	case 8: goto tr0;
	case 91: goto tr155;
	case 9: goto tr0;
	case 10: goto tr0;
	case 11: goto tr0;
	case 12: goto tr0;
	case 92: goto tr159;
	case 93: goto tr149;
	case 14: goto tr0;
	case 94: goto tr162;
	case 15: goto tr0;
	case 16: goto tr0;
	case 17: goto tr0;
	case 18: goto tr0;
	case 20: goto tr0;
	case 95: goto tr166;
	case 21: goto tr0;
	case 22: goto tr0;
	case 23: goto tr0;
	case 24: goto tr41;
	case 25: goto tr0;
	case 26: goto tr0;
	case 27: goto tr0;
	case 28: goto tr0;
	case 29: goto tr0;
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
	case 40: goto tr0;
	case 41: goto tr0;
	case 96: goto tr166;
	case 97: goto tr173;
	case 42: goto tr62;
	case 43: goto tr62;
	case 98: goto tr166;
	case 99: goto tr166;
	case 100: goto tr166;
	case 101: goto tr166;
	case 102: goto tr166;
	case 103: goto tr166;
	case 104: goto tr173;
	case 105: goto tr166;
	case 106: goto tr166;
	case 107: goto tr166;
	case 108: goto tr166;
	case 109: goto tr166;
	case 110: goto tr192;
	case 44: goto tr66;
	case 45: goto tr66;
	case 46: goto tr66;
	case 47: goto tr66;
	case 48: goto tr66;
	case 49: goto tr66;
	case 50: goto tr66;
	case 51: goto tr66;
	case 111: goto tr166;
	case 112: goto tr166;
	case 113: goto tr166;
	case 114: goto tr166;
	case 115: goto tr166;
	case 116: goto tr166;
	case 117: goto tr166;
	case 118: goto tr166;
	case 119: goto tr166;
	case 120: goto tr200;
	case 60: goto tr105;
	case 61: goto tr105;
	case 121: goto tr200;
	case 63: goto tr105;
	case 122: goto tr149;
	case 123: goto tr149;
	case 124: goto tr149;
	case 125: goto tr149;
	case 126: goto tr149;
	}
	}

	_out: {}
	}
#line 111 "hpricot_css.rl"
  
  rb_gc_unregister_address(&focus);
  rb_gc_unregister_address(&tmpt);
  return focus;
}
