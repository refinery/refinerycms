// line 1 "hpricot_css.java.rl"
import java.io.IOException;

import org.jruby.Ruby;
import org.jruby.RubyArray;
import org.jruby.RubyClass;
import org.jruby.RubyHash;
import org.jruby.RubyModule;
import org.jruby.RubyNumeric;
import org.jruby.RubyObject;
import org.jruby.RubyObjectAdapter;
import org.jruby.RubyRegexp;
import org.jruby.RubyString;
import org.jruby.anno.JRubyMethod;
import org.jruby.exceptions.RaiseException;
import org.jruby.javasupport.JavaEmbedUtils;
import org.jruby.runtime.Arity;
import org.jruby.runtime.Block;
import org.jruby.runtime.ObjectAllocator;
import org.jruby.runtime.ThreadContext;
import org.jruby.runtime.builtin.IRubyObject;
import org.jruby.runtime.callback.Callback;
import org.jruby.exceptions.RaiseException;
import org.jruby.runtime.load.BasicLibraryService;
import org.jruby.util.ByteList;

public class HpricotCss {
    public void FILTER(String id) {
        IRubyObject[] args = new IRubyObject[fargs];
        System.arraycopy(fvals, 0, args, 0, fargs);
        mod.callMethod(ctx, id, args);
        tmpt.rb_clear();
        fargs = 1;
    }

    public void FILTERAUTO() {
        try {
            FILTER(new String(data, ts, te - ts, "ISO-8859-1"));
        } catch(java.io.UnsupportedEncodingException e) {}
    }

    public void PUSH(int aps, int ape) {
        RubyString str = RubyString.newString(runtime, data, aps, ape-aps);
        fvals[fargs++] = str;
        tmpt.append(str);
    }

    private IRubyObject self, mod, str, node;
    private int cs, act, eof, p, pe, ts, te, aps, ape, aps2, ape2;
    private byte[] data;

    private int fargs = 1;
    private IRubyObject[] fvals = new IRubyObject[6];
    private RubyArray focus;
    private RubyArray tmpt;
    private Ruby runtime;
    private ThreadContext ctx;

    public HpricotCss(IRubyObject self, IRubyObject mod, IRubyObject str, IRubyObject node) {
        this.self = self;
        this.mod = mod;
        this.str = str;
        this.node = node;
        this.runtime = self.getRuntime();
        this.ctx = runtime.getCurrentContext();
        this.focus = RubyArray.newArray(runtime, node);
        this.tmpt = runtime.newArray();

        fvals[0] = focus;

        if(!(str instanceof RubyString)) {
            throw runtime.newArgumentError("bad CSS selector, String only please.");
        }

        ByteList bl = ((RubyString)str).getByteList();

        data = bl.bytes;
        p = bl.begin;
        pe = p + bl.realSize;
        eof = pe;
    }
    

// line 85 "HpricotCss.java"
private static byte[] init__hpricot_css_actions_0()
{
	return new byte [] {
	    0,    1,    0,    1,    1,    1,    2,    1,    3,    1,    6,    1,
	    7,    1,   15,    1,   19,    1,   22,    1,   24,    1,   28,    1,
	   29,    1,   30,    1,   31,    1,   32,    1,   33,    1,   34,    1,
	   35,    2,    0,    3,    2,    1,   14,    2,    1,   16,    2,    1,
	   17,    2,    1,   18,    2,    1,   20,    2,    1,   21,    2,    1,
	   23,    2,    1,   25,    2,    1,   26,    2,    1,   27,    2,    4,
	    5,    2,    7,    8,    2,    7,    9,    2,    7,   10,    2,    7,
	   11,    2,    7,   12,    2,    7,   13,    3,    0,    1,   16,    3,
	    0,    1,   18,    3,    7,    0,    8,    3,    7,    0,    9,    3,
	    7,    0,   10,    3,    7,    0,   13,    3,    7,    1,   13
	};
}

private static final byte _hpricot_css_actions[] = init__hpricot_css_actions_0();


private static short[] init__hpricot_css_key_offsets_0()
{
	return new short [] {
	    0,    0,    4,   20,   21,   23,   25,   27,   29,   30,   32,   34,
	   36,   38,   54,   55,   57,   59,   61,   63,   85,   89,   92,   95,
	   98,   99,  100,  101,  103,  107,  111,  114,  115,  116,  118,  119,
	  120,  122,  123,  125,  127,  129,  131,  137,  142,  153,  161,  165,
	  169,  173,  176,  180,  184,  201,  221,  222,  228,  229,  235,  237,
	  238,  239,  241,  242,  246,  253,  259,  261,  264,  267,  270,  272,
	  275,  277,  278,  299,  320,  341,  361,  384,  401,  403,  406,  409,
	  412,  415,  417,  419,  449,  453,  456,  472,  477,  495,  511,  527,
	  544,  563,  580,  598,  616,  634,  652,  670,  688,  705,  723,  741,
	  759,  777,  795,  812,  830,  849,  867,  885,  904,  922,  940,  958,
	  975,  976,  977,  994, 1011, 1027, 1044
	};
}

private static final short _hpricot_css_key_offsets[] = init__hpricot_css_key_offsets_0();


private static char[] init__hpricot_css_trans_keys_0()
{
	return new char [] {
	   32,   44,    9,   13,   45,   92,   95,  196,   48,   57,   65,   90,
	   97,  122,  197,  223,  224,  239,  240,  244,   46,  168,  191,  128,
	  191,  128,  191,  128,  191,   46,  168,  191,  128,  191,  128,  191,
	  128,  191,   45,   92,   95,  196,   48,   57,   65,   90,   97,  122,
	  197,  223,  224,  239,  240,  244,   46,  168,  191,  128,  191,  128,
	  191,  128,  191,   45,   92,   95,  101,  102,  103,  108,  110,  111,
	  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,
	  244,   34,   39,   40,   41,   34,   40,   41,   34,   40,   41,   34,
	   40,   41,   41,   41,   41,   34,   40,   34,   39,   40,   41,   34,
	   39,   40,   41,   39,   40,   41,   41,   41,   39,   40,   41,   41,
	   40,   41,   46,  168,  191,  128,  191,  128,  191,  128,  191,   34,
	   39,   40,   41,   48,   57,   34,   40,   41,   48,   57,   34,   39,
	   40,   41,   43,   45,  101,  110,  111,   48,   57,   34,   40,   41,
	   43,   45,  110,   48,   57,   34,   40,   41,  118,   34,   40,   41,
	  101,   34,   40,   41,  110,   34,   40,   41,   34,   40,   41,  100,
	   34,   40,   41,  100,   45,   92,   95,  110,  196,   48,   57,   65,
	   90,   97,  122,  197,  223,  224,  239,  240,  244,   32,   45,   61,
	   92,   95,  196,    9,   13,   48,   57,   65,   90,   97,  122,  197,
	  223,  224,  239,  240,  244,   61,   32,   34,   39,   93,    9,   13,
	   93,   32,   34,   39,   93,    9,   13,   34,   93,   34,   93,   39,
	   93,   39,   32,   61,    9,   13,   32,   34,   39,   61,   93,    9,
	   13,   32,   34,   39,   93,    9,   13,   46,   61,   61,  168,  191,
	   61,  128,  191,   61,  128,  191,  128,  191,   61,  128,  191,  128,
	  191,   46,   32,   45,   61,   92,   95,   97,  196,    9,   13,   48,
	   57,   65,   90,   98,  122,  197,  223,  224,  239,  240,  244,   32,
	   45,   61,   92,   95,  109,  196,    9,   13,   48,   57,   65,   90,
	   97,  122,  197,  223,  224,  239,  240,  244,   32,   45,   61,   92,
	   95,  101,  196,    9,   13,   48,   57,   65,   90,   97,  122,  197,
	  223,  224,  239,  240,  244,   32,   45,   61,   92,   95,  196,    9,
	   13,   48,   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,
	  244,   32,   34,   39,   45,   61,   92,   93,   95,  196,    9,   13,
	   48,   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,
	   45,   92,   93,   95,  196,   48,   57,   65,   90,   97,  122,  197,
	  223,  224,  239,  240,  244,   46,   93,   93,  168,  191,   93,  128,
	  191,   93,  128,  191,   93,  128,  191,  168,  191,  128,  191,   32,
	   35,   43,   44,   45,   46,   58,   62,   91,   92,   95,  101,  110,
	  111,  126,  196,    9,   13,   48,   57,   65,   90,   97,  122,  197,
	  223,  224,  239,  240,  244,   32,   44,    9,   13,   32,    9,   13,
	   45,   92,   95,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   43,   45,  110,   48,   57,   43,   45,   92,
	   95,  110,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   45,   92,   95,  196,   48,   57,   65,   90,   97,
	  122,  197,  223,  224,  239,  240,  244,   45,   92,   95,  196,   48,
	   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,
	   45,   92,   95,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  113,  118,  196,   48,
	   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,
	   45,   92,   95,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  101,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,
	   92,   95,  110,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  105,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,
	   92,   95,  114,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  115,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,
	   92,   95,  116,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  196,   48,   57,   65,
	   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,
	   95,   99,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   40,   45,   92,   95,  104,  196,   48,   57,   65,
	   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,
	   95,  105,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   40,   45,   92,   95,  108,  196,   48,   57,   65,
	   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,
	   95,  100,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   40,   45,   92,   95,  196,   48,   57,   65,   90,
	   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,   95,
	  116,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,  239,
	  240,  244,   40,   45,   92,   95,   97,  116,  196,   48,   57,   65,
	   90,   98,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,
	   95,  116,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   40,   45,   92,   95,  104,  196,   48,   57,   65,
	   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,   92,
	   95,  100,  110,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  100,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,
	   92,   95,  108,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,   40,   45,   92,   95,  121,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   40,   45,
	   92,   95,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   34,   39,   45,   92,   95,  118,  196,   48,   57,
	   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,   45,   92,
	   95,  101,  196,   48,   57,   65,   90,   97,  122,  197,  223,  224,
	  239,  240,  244,   45,   92,   95,  196,   48,   57,   65,   90,   97,
	  122,  197,  223,  224,  239,  240,  244,   45,   92,   95,  100,  196,
	   48,   57,   65,   90,   97,  122,  197,  223,  224,  239,  240,  244,
	   45,   92,   95,  196,   48,   57,   65,   90,   97,  122,  197,  223,
	  224,  239,  240,  244,    0
	};
}

private static final char _hpricot_css_trans_keys[] = init__hpricot_css_trans_keys_0();


private static byte[] init__hpricot_css_single_lengths_0()
{
	return new byte [] {
	    0,    2,    4,    1,    0,    0,    0,    0,    1,    0,    0,    0,
	    0,    4,    1,    0,    0,    0,    0,   10,    4,    3,    3,    1,
	    1,    1,    1,    2,    4,    4,    1,    1,    1,    2,    1,    1,
	    2,    1,    0,    0,    0,    0,    4,    3,    9,    6,    4,    4,
	    4,    3,    4,    4,    5,    6,    1,    4,    1,    4,    2,    1,
	    1,    2,    1,    2,    5,    4,    2,    1,    1,    1,    0,    1,
	    0,    1,    7,    7,    7,    6,    9,    5,    2,    1,    1,    1,
	    1,    0,    0,   16,    2,    1,    4,    3,    6,    4,    4,    5,
	    7,    5,    6,    6,    6,    6,    6,    6,    5,    6,    6,    6,
	    6,    6,    5,    6,    7,    6,    6,    7,    6,    6,    6,    5,
	    1,    1,    5,    5,    4,    5,    4
	};
}

private static final byte _hpricot_css_single_lengths[] = init__hpricot_css_single_lengths_0();


private static byte[] init__hpricot_css_range_lengths_0()
{
	return new byte [] {
	    0,    1,    6,    0,    1,    1,    1,    1,    0,    1,    1,    1,
	    1,    6,    0,    1,    1,    1,    1,    6,    0,    0,    0,    1,
	    0,    0,    0,    0,    0,    0,    1,    0,    0,    0,    0,    0,
	    0,    0,    1,    1,    1,    1,    1,    1,    1,    1,    0,    0,
	    0,    0,    0,    0,    6,    7,    0,    1,    0,    1,    0,    0,
	    0,    0,    0,    1,    1,    1,    0,    1,    1,    1,    1,    1,
	    1,    0,    7,    7,    7,    7,    7,    6,    0,    1,    1,    1,
	    1,    1,    1,    7,    1,    1,    6,    1,    6,    6,    6,    6,
	    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
	    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,    6,
	    0,    0,    6,    6,    6,    6,    6
	};
}

private static final byte _hpricot_css_range_lengths[] = init__hpricot_css_range_lengths_0();


private static short[] init__hpricot_css_index_offsets_0()
{
	return new short [] {
	    0,    0,    4,   15,   17,   19,   21,   23,   25,   27,   29,   31,
	   33,   35,   46,   48,   50,   52,   54,   56,   73,   78,   82,   86,
	   89,   91,   93,   95,   98,  103,  108,  111,  113,  115,  118,  120,
	  122,  125,  127,  129,  131,  133,  135,  141,  146,  157,  165,  170,
	  175,  180,  184,  189,  194,  206,  220,  222,  228,  230,  236,  239,
	  241,  243,  246,  248,  252,  259,  265,  268,  271,  274,  277,  279,
	  282,  284,  286,  301,  316,  331,  345,  362,  374,  377,  380,  383,
	  386,  389,  391,  393,  417,  421,  424,  435,  440,  453,  464,  475,
	  487,  501,  513,  526,  539,  552,  565,  578,  591,  603,  616,  629,
	  642,  655,  668,  680,  693,  707,  720,  733,  747,  760,  773,  786,
	  798,  800,  802,  814,  826,  837,  849
	};
}

private static final short _hpricot_css_index_offsets[] = init__hpricot_css_index_offsets_0();


private static byte[] init__hpricot_css_trans_targs_wi_0()
{
	return new byte [] {
	    1,   89,    1,   87,   90,    3,   90,    4,   90,   90,   90,    5,
	    6,    7,    0,   90,   87,   90,   87,   90,   87,    5,   87,    6,
	   87,   93,   87,   93,   87,   93,   87,   10,   87,   11,   87,   94,
	   14,   94,   15,   94,   94,   94,   16,   17,   18,    0,   94,   87,
	   94,   87,   94,   87,   16,   87,   17,   87,   95,   37,   95,   96,
	  100,  111,  112,  113,  115,   38,   95,   95,   95,   39,   40,   41,
	    0,   22,   28,   34,   87,   21,   87,   87,   87,   21,   24,   25,
	   87,   23,   24,   87,   23,   87,   87,   87,   26,   27,   26,   24,
	   25,   87,   30,   21,   31,   87,   29,   30,   21,   87,   87,   29,
	   24,   87,   30,   87,   32,   33,   32,   24,   31,   87,   87,   35,
	   36,   35,   34,   87,   87,   95,   87,   95,   87,   95,   87,   39,
	   87,   40,   87,   22,   28,   34,   87,   43,   21,   87,   87,   87,
	   43,   21,   22,   28,   34,   87,   45,   45,   46,   45,   50,   45,
	   21,   87,   87,   87,   45,   45,   45,   45,   21,   87,   87,   87,
	   47,   21,   87,   87,   87,   48,   21,   87,   87,   87,   49,   21,
	   87,   87,   87,   21,   87,   87,   87,   51,   21,   87,   87,   87,
	   49,   21,   53,   73,   53,   74,   85,   53,   53,   53,   70,   72,
	   86,    0,   63,   53,   64,   66,   53,   67,   63,   53,   53,   53,
	   68,   69,   71,   54,   55,    0,   57,   58,   61,    0,   57,   56,
	   87,   56,   57,   58,   61,   87,   57,   56,   56,  120,   58,   60,
	   59,   87,   87,   56,  121,   61,   60,   62,   63,   64,   63,   54,
	   57,   58,   61,   65,    0,   57,   56,   57,   58,   61,   87,   57,
	   56,   53,   55,    0,   55,   53,    0,   55,   53,    0,   55,   70,
	    0,   53,    0,   55,   72,    0,   70,    0,   53,    0,   63,   53,
	   64,   66,   53,   75,   67,   63,   53,   53,   53,   68,   69,   71,
	   54,   63,   53,   64,   66,   53,   76,   67,   63,   53,   53,   53,
	   68,   69,   71,   54,   63,   53,   64,   66,   53,   77,   67,   63,
	   53,   53,   53,   68,   69,   71,   54,   63,   53,   78,   66,   53,
	   67,   63,   53,   53,   53,   68,   69,   71,   54,   57,   58,   61,
	   79,   65,   80,    0,   79,   81,   57,   79,   79,   79,   82,   83,
	   84,   56,   79,   80,   87,   79,   81,   79,   79,   79,   82,   83,
	   84,   56,   79,   87,   56,   87,   79,   56,   87,   79,   56,   87,
	   82,   56,   87,   83,   56,   53,    0,   72,    0,   88,    2,   91,
	   89,   92,   13,   19,   87,   52,    8,   93,  122,   92,  125,   87,
	    9,   88,   92,   93,   93,   10,   11,   12,    0,    1,   89,    1,
	   87,   89,   89,   87,   90,    3,   90,    4,   90,   90,   90,    5,
	    6,    7,   87,   91,   91,   91,   91,   87,   91,   92,    8,   93,
	   92,    9,   92,   93,   93,   10,   11,   12,   87,   93,    8,   93,
	    9,   93,   93,   93,   10,   11,   12,   87,   94,   14,   94,   15,
	   94,   94,   94,   16,   17,   18,   87,   20,   95,   37,   95,   38,
	   95,   95,   95,   39,   40,   41,   87,   20,   95,   37,   95,   97,
	   98,   38,   95,   95,   95,   39,   40,   41,   87,   42,   95,   37,
	   95,   38,   95,   95,   95,   39,   40,   41,   87,   20,   95,   37,
	   95,   99,   38,   95,   95,   95,   39,   40,   41,   87,   20,   95,
	   37,   95,   97,   38,   95,   95,   95,   39,   40,   41,   87,   20,
	   95,   37,   95,  101,   38,   95,   95,   95,   39,   40,   41,   87,
	   20,   95,   37,   95,  102,   38,   95,   95,   95,   39,   40,   41,
	   87,   20,   95,   37,   95,  103,   38,   95,   95,   95,   39,   40,
	   41,   87,   20,   95,   37,   95,  104,   38,   95,   95,   95,   39,
	   40,   41,   87,   42,  105,   37,   95,   38,   95,   95,   95,   39,
	   40,   41,   87,   20,   95,   37,   95,  106,   38,   95,   95,   95,
	   39,   40,   41,   87,   20,   95,   37,   95,  107,   38,   95,   95,
	   95,   39,   40,   41,   87,   20,   95,   37,   95,  108,   38,   95,
	   95,   95,   39,   40,   41,   87,   20,   95,   37,   95,  109,   38,
	   95,   95,   95,   39,   40,   41,   87,   20,   95,   37,   95,  110,
	   38,   95,   95,   95,   39,   40,   41,   87,   44,   95,   37,   95,
	   38,   95,   95,   95,   39,   40,   41,   87,   20,   95,   37,   95,
	   97,   38,   95,   95,   95,   39,   40,   41,   87,   20,   95,   37,
	   95,  102,   97,   38,   95,   95,   95,   39,   40,   41,   87,   20,
	   95,   37,   95,  114,   38,   95,   95,   95,   39,   40,   41,   87,
	   20,   95,   37,   95,  104,   38,   95,   95,   95,   39,   40,   41,
	   87,   20,   95,   37,   95,  116,  117,   38,   95,   95,   95,   39,
	   40,   41,   87,   20,   95,   37,   95,   97,   38,   95,   95,   95,
	   39,   40,   41,   87,   20,   95,   37,   95,  118,   38,   95,   95,
	   95,   39,   40,   41,   87,   20,   95,   37,   95,  119,   38,   95,
	   95,   95,   39,   40,   41,   87,   20,  105,   37,   95,   38,   95,
	   95,   95,   39,   40,   41,   87,   60,   59,   60,   62,   93,    8,
	   93,  123,    9,   93,   93,   93,   10,   11,   12,   87,   93,    8,
	   93,  124,    9,   93,   93,   93,   10,   11,   12,   87,   93,    8,
	   93,    9,   93,   93,   93,   10,   11,   12,   87,   93,    8,   93,
	  126,    9,   93,   93,   93,   10,   11,   12,   87,   93,    8,   93,
	    9,   93,   93,   93,   10,   11,   12,   87,    0
	};
}

private static final byte _hpricot_css_trans_targs_wi[] = init__hpricot_css_trans_targs_wi_0();


private static byte[] init__hpricot_css_trans_actions_wi_0()
{
	return new byte [] {
	    0,    0,    0,   33,   99,    1,   99,    1,   99,   99,   99,    1,
	    1,    1,    0,   73,   35,   73,   35,   73,   35,    0,   35,    0,
	   35,   79,   35,   79,   35,   79,   35,    0,   35,    0,   35,  103,
	    1,  103,    1,  103,  103,  103,    1,    1,    1,    0,   76,   35,
	   76,   35,   76,   35,    0,   35,    0,   35,  111,    1,  111,  111,
	  111,  111,  111,  111,  111,    1,  111,  111,  111,    1,    1,    1,
	    0,    1,    1,    1,   95,    1,   35,   35,   49,    0,    0,    0,
	   35,    0,    0,   35,    0,   49,   35,   35,    0,    0,    0,    0,
	    0,   35,    0,    0,    0,   49,    0,    0,    0,   35,   49,    0,
	    0,   35,    0,   35,    0,    0,    0,    0,    0,   35,   35,    0,
	    0,    0,    0,   49,   35,   88,   35,   88,   35,   88,   35,    0,
	   35,    0,   35,    1,    1,    1,   95,    1,    1,   29,   29,   46,
	    0,    0,    1,    1,    1,   91,    1,    1,    1,    1,    1,    1,
	    1,   27,   27,   43,    0,    0,    0,    0,    0,   27,   27,   49,
	    0,    0,   27,   27,   49,    0,    0,   27,   27,   49,    0,    0,
	   27,   27,   43,    0,   27,   27,   49,    0,    0,   27,   27,   49,
	    0,    0,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    0,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
	    5,    5,    5,    5,    0,    0,    7,    7,    7,    0,    7,    7,
	   13,    0,    0,    0,    0,   13,    0,    0,    0,   11,    0,    0,
	    0,   13,   25,    0,   11,    0,    0,    0,    0,    0,    0,    0,
	    7,    7,    7,    7,    0,    7,    7,    7,    7,    7,   13,    7,
	    7,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    5,    5,
	    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
	    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
	    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
	    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,    5,
	    5,    5,    5,    5,    5,    5,    5,    5,    5,    7,    7,    7,
	   37,    7,   37,    0,   37,   37,    7,   37,   37,   37,   37,   37,
	   37,    7,    0,    0,   40,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,   13,    0,   13,    0,    0,   13,    0,    0,   13,
	    0,    0,   13,    0,    0,    0,    0,    0,    0,   11,    0,    0,
	    0,  107,    0,    0,   15,    0,    1,  107,  107,  107,  107,   15,
	    1,   11,  107,  107,  107,    1,    1,    1,    0,    0,    0,    0,
	   23,    0,    0,   21,   73,    0,   73,    0,   73,   73,   73,    0,
	    0,    0,   52,    0,    0,    0,    0,   19,    3,   79,    0,   79,
	   79,    0,   79,   79,   79,    0,    0,    0,   58,   79,    0,   79,
	    0,   79,   79,   79,    0,    0,    0,   58,   76,    0,   76,    0,
	   76,   76,   76,    0,    0,    0,   55,    3,   88,    0,   88,    0,
	   88,   88,   88,    0,    0,    0,   67,    3,   88,    0,   88,   85,
	   88,    0,   88,   88,   88,    0,    0,    0,   67,    3,  115,    3,
	  115,    3,  115,  115,  115,    3,    3,    3,   64,    3,   88,    0,
	   88,   88,    0,   88,   88,   88,    0,    0,    0,   67,    3,   88,
	    0,   88,   85,    0,   88,   88,   88,    0,    0,    0,   67,    3,
	   88,    0,   88,   88,    0,   88,   88,   88,    0,    0,    0,   67,
	    3,   88,    0,   88,   88,    0,   88,   88,   88,    0,    0,    0,
	   67,    3,   88,    0,   88,   88,    0,   88,   88,   88,    0,    0,
	    0,   67,    3,   88,    0,   88,   85,    0,   88,   88,   88,    0,
	    0,    0,   67,    3,  115,    3,  115,    3,  115,  115,  115,    3,
	    3,    3,   64,    3,   88,    0,   88,   88,    0,   88,   88,   88,
	    0,    0,    0,   67,    3,   88,    0,   88,   88,    0,   88,   88,
	   88,    0,    0,    0,   67,    3,   88,    0,   88,   88,    0,   88,
	   88,   88,    0,    0,    0,   67,    3,   88,    0,   88,   88,    0,
	   88,   88,   88,    0,    0,    0,   67,    3,   88,    0,   88,   82,
	    0,   88,   88,   88,    0,    0,    0,   67,    3,  115,    3,  115,
	    3,  115,  115,  115,    3,    3,    3,   61,    3,   88,    0,   88,
	   85,    0,   88,   88,   88,    0,    0,    0,   67,    3,   88,    0,
	   88,   88,   85,    0,   88,   88,   88,    0,    0,    0,   67,    3,
	   88,    0,   88,   88,    0,   88,   88,   88,    0,    0,    0,   67,
	    3,   88,    0,   88,   85,    0,   88,   88,   88,    0,    0,    0,
	   67,    3,   88,    0,   88,   88,   88,    0,   88,   88,   88,    0,
	    0,    0,   67,    3,   88,    0,   88,   85,    0,   88,   88,   88,
	    0,    0,    0,   67,    3,   88,    0,   88,   88,    0,   88,   88,
	   88,    0,    0,    0,   67,    3,   88,    0,   88,   88,    0,   88,
	   88,   88,    0,    0,    0,   67,    3,   88,    0,   88,    0,   88,
	   88,   88,    0,    0,    0,   67,    0,    0,    0,    0,   79,    0,
	   79,   79,    0,   79,   79,   79,    0,    0,    0,   58,   79,    0,
	   79,   79,    0,   79,   79,   79,    0,    0,    0,   58,   79,    0,
	   79,    0,   79,   79,   79,    0,    0,    0,   58,   79,    0,   79,
	   79,    0,   79,   79,   79,    0,    0,    0,   58,   79,    0,   79,
	    0,   79,   79,   79,    0,    0,    0,   58,    0
	};
}

private static final byte _hpricot_css_trans_actions_wi[] = init__hpricot_css_trans_actions_wi_0();


private static byte[] init__hpricot_css_to_state_actions_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,   70,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0
	};
}

private static final byte _hpricot_css_to_state_actions[] = init__hpricot_css_to_state_actions_0();


private static byte[] init__hpricot_css_from_state_actions_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    9,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0
	};
}

private static final byte _hpricot_css_from_state_actions[] = init__hpricot_css_from_state_actions_0();


private static short[] init__hpricot_css_eof_trans_0()
{
	return new short [] {
	    0,    1,    0,   11,   11,   11,   11,   11,   11,   11,   11,   11,
	   11,    0,   11,   11,   11,   11,   11,    0,   39,   11,   11,   11,
	   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,   11,
	   11,   11,   11,   11,   11,   11,   63,   63,   67,   67,   67,   67,
	   67,   67,   67,   67,    0,    0,    0,    0,    0,    0,    0,  105,
	  105,    0,  105,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,  150,  151,  152,  156,  157,  157,  163,  167,
	  167,  174,  167,  167,  167,  167,  167,  167,  174,  167,  167,  167,
	  167,  167,  193,  167,  167,  167,  167,  167,  167,  167,  167,  167,
	  201,  201,  157,  157,  157,  157,  157
	};
}

private static final short _hpricot_css_eof_trans[] = init__hpricot_css_eof_trans_0();


static final int hpricot_css_start = 87;
static final int hpricot_css_error = 0;

static final int hpricot_css_en_main = 87;

// line 147 "hpricot_css.java.rl"


    public IRubyObject scan() {

// line 515 "HpricotCss.java"
	{
	cs = hpricot_css_start;
	ts = -1;
	te = -1;
	act = 0;
	}
// line 151 "hpricot_css.java.rl"

// line 524 "HpricotCss.java"
	{
	int _klen;
	int _trans = 0;
	int _acts;
	int _nacts;
	int _keys;
	int _goto_targ = 0;

	_goto: while (true) {
	switch ( _goto_targ ) {
	case 0:
	if ( p == pe ) {
		_goto_targ = 4;
		continue _goto;
	}
	if ( cs == 0 ) {
		_goto_targ = 5;
		continue _goto;
	}
case 1:
	_acts = _hpricot_css_from_state_actions[cs];
	_nacts = (int) _hpricot_css_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_css_actions[_acts++] ) {
	case 6:
// line 1 "hpricot_css.java.rl"
	{ts = p;}
	break;
// line 553 "HpricotCss.java"
		}
	}

	_match: do {
	_keys = _hpricot_css_key_offsets[cs];
	_trans = _hpricot_css_index_offsets[cs];
	_klen = _hpricot_css_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _hpricot_css_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _hpricot_css_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _hpricot_css_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _hpricot_css_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _hpricot_css_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

case 3:
	cs = _hpricot_css_trans_targs_wi[_trans];

	if ( _hpricot_css_trans_actions_wi[_trans] != 0 ) {
		_acts = _hpricot_css_trans_actions_wi[_trans];
		_nacts = (int) _hpricot_css_actions[_acts++];
		while ( _nacts-- > 0 )
	{
			switch ( _hpricot_css_actions[_acts++] )
			{
	case 0:
// line 85 "hpricot_css.java.rl"
	{
    aps = p;
  }
	break;
	case 1:
// line 89 "hpricot_css.java.rl"
	{
    ape = p;
    PUSH(aps, ape); 
  }
	break;
	case 2:
// line 94 "hpricot_css.java.rl"
	{
    ape = p;
    aps2 = p;
  }
	break;
	case 3:
// line 99 "hpricot_css.java.rl"
	{
    ape2 = p;
    PUSH(aps, ape);
    PUSH(aps2, ape2);
  }
	break;
	case 7:
// line 1 "hpricot_css.java.rl"
	{te = p+1;}
	break;
	case 8:
// line 132 "hpricot_css.java.rl"
	{act = 1;}
	break;
	case 9:
// line 133 "hpricot_css.java.rl"
	{act = 2;}
	break;
	case 10:
// line 136 "hpricot_css.java.rl"
	{act = 5;}
	break;
	case 11:
// line 138 "hpricot_css.java.rl"
	{act = 7;}
	break;
	case 12:
// line 139 "hpricot_css.java.rl"
	{act = 8;}
	break;
	case 13:
// line 140 "hpricot_css.java.rl"
	{act = 9;}
	break;
	case 14:
// line 134 "hpricot_css.java.rl"
	{te = p+1;{ FILTER("NAME"); }}
	break;
	case 15:
// line 135 "hpricot_css.java.rl"
	{te = p+1;{ FILTER("ATTR"); }}
	break;
	case 16:
// line 138 "hpricot_css.java.rl"
	{te = p+1;{ FILTER("CHILD"); }}
	break;
	case 17:
// line 139 "hpricot_css.java.rl"
	{te = p+1;{ FILTER("POS"); }}
	break;
	case 18:
// line 140 "hpricot_css.java.rl"
	{te = p+1;{ FILTER("PSUEDO"); }}
	break;
	case 19:
// line 142 "hpricot_css.java.rl"
	{te = p+1;{ FILTERAUTO(); }}
	break;
	case 20:
// line 132 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("ID"); }}
	break;
	case 21:
// line 133 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("CLASS"); }}
	break;
	case 22:
// line 135 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("ATTR"); }}
	break;
	case 23:
// line 136 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("TAG"); }}
	break;
	case 24:
// line 137 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("MOD"); }}
	break;
	case 25:
// line 138 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("CHILD"); }}
	break;
	case 26:
// line 139 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("POS"); }}
	break;
	case 27:
// line 140 "hpricot_css.java.rl"
	{te = p;p--;{ FILTER("PSUEDO"); }}
	break;
	case 28:
// line 141 "hpricot_css.java.rl"
	{te = p;p--;{ focus = RubyArray.newArray(runtime, node); }}
	break;
	case 29:
// line 143 "hpricot_css.java.rl"
	{te = p;p--;}
	break;
	case 30:
// line 135 "hpricot_css.java.rl"
	{{p = ((te))-1;}{ FILTER("ATTR"); }}
	break;
	case 31:
// line 138 "hpricot_css.java.rl"
	{{p = ((te))-1;}{ FILTER("CHILD"); }}
	break;
	case 32:
// line 139 "hpricot_css.java.rl"
	{{p = ((te))-1;}{ FILTER("POS"); }}
	break;
	case 33:
// line 140 "hpricot_css.java.rl"
	{{p = ((te))-1;}{ FILTER("PSUEDO"); }}
	break;
	case 34:
// line 143 "hpricot_css.java.rl"
	{{p = ((te))-1;}}
	break;
	case 35:
// line 1 "hpricot_css.java.rl"
	{	switch( act ) {
	case 0:
	{{cs = 0; _goto_targ = 2; if (true) continue _goto;}}
	break;
	case 1:
	{{p = ((te))-1;} FILTER("ID"); }
	break;
	case 2:
	{{p = ((te))-1;} FILTER("CLASS"); }
	break;
	case 5:
	{{p = ((te))-1;} FILTER("TAG"); }
	break;
	case 7:
	{{p = ((te))-1;} FILTER("CHILD"); }
	break;
	case 8:
	{{p = ((te))-1;} FILTER("POS"); }
	break;
	case 9:
	{{p = ((te))-1;} FILTER("PSUEDO"); }
	break;
	default: break;
	}
	}
	break;
// line 784 "HpricotCss.java"
			}
		}
	}

case 2:
	_acts = _hpricot_css_to_state_actions[cs];
	_nacts = (int) _hpricot_css_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_css_actions[_acts++] ) {
	case 4:
// line 1 "hpricot_css.java.rl"
	{ts = -1;}
	break;
	case 5:
// line 1 "hpricot_css.java.rl"
	{act = 0;}
	break;
// line 802 "HpricotCss.java"
		}
	}

	if ( cs == 0 ) {
		_goto_targ = 5;
		continue _goto;
	}
	if ( ++p != pe ) {
		_goto_targ = 1;
		continue _goto;
	}
case 4:
	if ( p == eof )
	{
	if ( _hpricot_css_eof_trans[cs] > 0 ) {
		_trans = _hpricot_css_eof_trans[cs] - 1;
		_goto_targ = 3;
		continue _goto;
	}
	}

case 5:
	}
	break; }
	}
// line 152 "hpricot_css.java.rl"

        return focus;
    }
}
