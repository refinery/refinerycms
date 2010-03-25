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
    cssid      => { FILTER("ID"); };
    cssclass   => { FILTER("CLASS"); };
    cssname    => { FILTER("NAME"); };
    cssattr    => { FILTER("ATTR"); };
    csstag     => { FILTER("TAG"); };
    cssmod     => { FILTER("MOD"); };
    csschild   => { FILTER("CHILD"); };
    csspos     => { FILTER("POS"); };
    pseudo     => { FILTER("PSUEDO"); };
    commas     => { focus = RubyArray.newArray(runtime, node); };
    traverse   => { FILTERAUTO(); };
    space;
  *|;

  write data nofinal;
}%%

    public IRubyObject scan() {
%% write init;
%% write exec;

        return focus;
    }
}
