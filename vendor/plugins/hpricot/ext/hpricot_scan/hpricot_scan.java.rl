
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

public class HpricotScanService implements BasicLibraryService {
    public static byte[] realloc(byte[] input, int size) {
        byte[] newArray = new byte[size];
        System.arraycopy(input, 0, newArray, 0, input.length);
        return newArray;
    }

    // hpricot_state
    public static class State {
        public IRubyObject doc;
        public IRubyObject focus;
        public IRubyObject last;
        public IRubyObject EC;
        public boolean xml, strict, fixup;
    }

    static boolean OPT(IRubyObject opts, String key) {
        Ruby runtime = opts.getRuntime();
        return !opts.isNil() && ((RubyHash)opts).op_aref(runtime.getCurrentContext(), runtime.newSymbol(key)).isTrue();
    }

    // H_PROP(name, H_ELE_TAG)
    public static IRubyObject hpricot_ele_set_name(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_TAG, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_name(IRubyObject self) {
        H_ELE_SET(self, H_ELE_TAG, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_name(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_TAG);
    }

    // H_PROP(raw, H_ELE_RAW)
    public static IRubyObject hpricot_ele_set_raw(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_RAW, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_raw(IRubyObject self) {
        H_ELE_SET(self, H_ELE_RAW, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_raw(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_RAW);
    }

    // H_PROP(parent, H_ELE_PARENT)
    public static IRubyObject hpricot_ele_set_parent(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_PARENT, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_parent(IRubyObject self) {
        H_ELE_SET(self, H_ELE_PARENT, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_parent(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_PARENT);
    }

    // H_PROP(attr, H_ELE_ATTR)
    public static IRubyObject hpricot_ele_set_attr(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_ATTR, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_attr(IRubyObject self) {
        H_ELE_SET(self, H_ELE_ATTR, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_attr(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_ATTR);
    }

    // H_PROP(etag, H_ELE_ETAG)
    public static IRubyObject hpricot_ele_set_etag(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_ETAG, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_etag(IRubyObject self) {
        H_ELE_SET(self, H_ELE_ETAG, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_etag(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_ETAG);
    }

    // H_PROP(children, H_ELE_CHILDREN)
    public static IRubyObject hpricot_ele_set_children(IRubyObject self, IRubyObject x) {
        H_ELE_SET(self, H_ELE_CHILDREN, x);
        return self;
    }

    public static IRubyObject hpricot_ele_clear_children(IRubyObject self) {
        H_ELE_SET(self, H_ELE_CHILDREN, self.getRuntime().getNil());
        return self.getRuntime().getTrue();
    }

    public static IRubyObject hpricot_ele_get_children(IRubyObject self) {
        return H_ELE_GET(self, H_ELE_CHILDREN);
    }

    // H_ATTR(target)
    public static IRubyObject hpricot_ele_set_target(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("target"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_target(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("target"));
    }

    // H_ATTR(encoding)
    public static IRubyObject hpricot_ele_set_encoding(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("encoding"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_encoding(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("encoding"));
    }

    // H_ATTR(version)
    public static IRubyObject hpricot_ele_set_version(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("version"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_version(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("version"));
    }

    // H_ATTR(standalone)
    public static IRubyObject hpricot_ele_set_standalone(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("standalone"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_standalone(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("standalone"));
    }

    // H_ATTR(system_id)
    public static IRubyObject hpricot_ele_set_system_id(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("system_id"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_system_id(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("system_id"));
    }

    // H_ATTR(public_id)
    public static IRubyObject hpricot_ele_set_public_id(IRubyObject self, IRubyObject x) {
        ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).fastASet(self.getRuntime().newSymbol("public_id"), x);
        return self;
    }

    public static IRubyObject hpricot_ele_get_public_id(IRubyObject self) {
        return ((RubyHash)H_ELE_GET(self, H_ELE_ATTR)).op_aref(self.getRuntime().getCurrentContext(), self.getRuntime().newSymbol("public_id"));
    }

    public static class Scanner {
        public IRubyObject SET(int mark, int E, IRubyObject org) {
            if(mark == -1 || E == mark) {
                return runtime.newString("");
            } else if(E > mark) {
                return RubyString.newString(runtime, data, mark, E-mark);
            } else {
                return org;
            }
        }

        public int SLIDE(int N) {
            if(N > ts) {
                return N - ts;
            } else {
                return N;
            }
        }

        public IRubyObject CAT(IRubyObject N, int mark, int E) {
            if(N.isNil()) {
                return SET(mark, E, N);
            } else {
                ((RubyString)N).cat(data, mark, E-mark);
                return N;
            }
        }

        public void ATTR(IRubyObject K, IRubyObject V) {
            if(!K.isNil()) {
                if(attr.isNil()) {
                    attr = RubyHash.newHash(runtime);
                }
                ((RubyHash)attr).fastASet(K, V);
            }
        }

        public void TEXT_PASS() {
            if(!text) {
                if(ele_open) {
                    ele_open = false;
                    if(ts != -1) {
                        mark_tag = ts;
                    }
                } else {
                    mark_tag = p;
                }
                attr = runtime.getNil();
                tag = runtime.getNil();
                text = true;
            }
        }

        public void ELE(IRubyObject N) {
            if(te > ts || text) {
                int raw = -1;
                int rawlen = 0;
                ele_open = false; 
                text = false;

                if(ts != -1 && N != x.sym_cdata && N != x.sym_text && N != x.sym_procins && N != x.sym_comment) {
                    raw = ts; 
                    rawlen = te - ts;
                }

                if(block.isGiven()) {
                    IRubyObject raw_string = runtime.getNil();
                    if(raw != -1) {
                        raw_string = RubyString.newString(runtime, data, raw, rawlen);
                    }
                    yieldTokens(N, tag, attr, runtime.getNil(), taint);
                } else {
                    hpricotToken(S, N, tag, attr, raw, rawlen, taint);
                }
            }
        }
        

        public void EBLK(IRubyObject N, int T) {
            tag = CAT(tag, mark_tag, p - T + 1);
            ELE(N);
        }

        public void hpricotAdd(IRubyObject focus, IRubyObject ele) {
            IRubyObject children = H_ELE_GET(focus, H_ELE_CHILDREN);
            if(children.isNil()) {
                H_ELE_SET(focus, H_ELE_CHILDREN, children = RubyArray.newArray(runtime, 1));
            }
            ((RubyArray)children).append(ele);
            H_ELE_SET(ele, H_ELE_PARENT, focus);
        }

        private static class TokenInfo {
            public IRubyObject sym;
            public IRubyObject tag;
            public IRubyObject attr;
            public int raw;
            public int rawlen;
            public IRubyObject ec;
            public IRubyObject ele;
            public Extra x;
            public Ruby runtime;
            public Scanner scanner;
            public State S;

            public void H_ELE(RubyClass klass) {
                ele = klass.allocate();
                if(klass == x.cElem) {
                    H_ELE_SET(ele, H_ELE_TAG, tag);
                    H_ELE_SET(ele, H_ELE_ATTR, attr);
                    H_ELE_SET(ele, H_ELE_EC, ec);
                    if(raw != -1 && (sym == x.sym_emptytag || sym == x.sym_stag || sym == x.sym_doctype)) {
                        H_ELE_SET(ele, H_ELE_RAW, RubyString.newString(runtime, scanner.data, raw, rawlen));
                    }
                } else if(klass == x.cDocType || klass == x.cProcIns || klass == x.cXMLDecl || klass == x.cBogusETag) {
                    if(klass == x.cBogusETag) {
                        H_ELE_SET(ele, H_ELE_TAG, tag);
                        if(raw != -1) {
                            H_ELE_SET(ele, H_ELE_ATTR, RubyString.newString(runtime, scanner.data, raw, rawlen));
                        }
                    } else {
                        if(klass == x.cDocType) {
                            scanner.ATTR(runtime.newSymbol("target"), tag);
                        }
                        H_ELE_SET(ele, H_ELE_ATTR, attr);
                        if(klass != x.cProcIns) {
                            tag = runtime.getNil();
                            if(raw != -1) {
                                tag = RubyString.newString(runtime, scanner.data, raw, rawlen);
                            }
                        }
                        H_ELE_SET(ele, H_ELE_TAG, tag);
                    }
                } else {
                    H_ELE_SET(ele, H_ELE_TAG, tag);
                }
                S.last = ele;
            }

            public void hpricotToken(boolean taint) {
                //
                // in html mode, fix up start tags incorrectly formed as empty tags
                //
                if(!S.xml) {
                    if(sym == x.sym_emptytag || sym == x.sym_stag || sym == x.sym_etag) {
                        ec = ((RubyHash)S.EC).op_aref(scanner.ctx, tag);
                        if(ec.isNil()) {
                            tag = tag.callMethod(scanner.ctx, "downcase");
                            ec = ((RubyHash)S.EC).op_aref(scanner.ctx, tag);
                        }
                    }

                    if(H_ELE_GET(S.focus, H_ELE_EC) == x.sym_CDATA && 
                       (sym != x.sym_procins && sym != x.sym_comment && sym != x.sym_cdata && sym != x.sym_text) && 
                       !(sym == x.sym_etag && runtime.newFixnum(tag.hashCode()).equals(H_ELE_GET(S.focus, H_ELE_HASH)))) {
                        sym = x.sym_text;
                        tag = RubyString.newString(runtime, scanner.data, raw, rawlen);
                    }

                    if(!ec.isNil()) {
                        if(sym == x.sym_emptytag) {
                            if(ec != x.sym_EMPTY) {
                                sym = x.sym_stag;
                            }
                        } else if(sym == x.sym_stag) {
                            if(ec == x.sym_EMPTY) {
                                sym = x.sym_emptytag;
                            }
                        }
                    }
                }

                if(sym == x.sym_emptytag || sym == x.sym_stag) {
                    IRubyObject name = runtime.newFixnum(tag.hashCode());
                    H_ELE(x.cElem);
                    H_ELE_SET(ele, H_ELE_HASH, name);

                    if(!S.xml) {
                        IRubyObject match = runtime.getNil(), e = S.focus;
                        while(e != S.doc) {
                            IRubyObject hEC = H_ELE_GET(e, H_ELE_EC);
                            if(hEC instanceof RubyHash) {
                                IRubyObject has = ((RubyHash)hEC).op_aref(scanner.ctx, name);
                                if(!has.isNil()) {
                                    if(has == runtime.getTrue()) {
                                        if(match.isNil()) {
                                            match = e;
                                        }
                                    } else if(has == x.symAllow) {
                                        match = S.focus;
                                    } else if(has == x.symDeny) {
                                        match = runtime.getNil();
                                    }
                                }
                            }
                            e = H_ELE_GET(e, H_ELE_PARENT);
                        }
                    
                        if(match.isNil()) {
                            match = S.focus;
                        }
                        S.focus = match;
                    }

                    scanner.hpricotAdd(S.focus, ele);

                    //
                    // in the case of a start tag that should be empty, just
                    // skip the step that focuses the element.  focusing moves
                    // us deeper into the document.
                    //
                    if(sym == x.sym_stag) {
                        if(S.xml || ec != x.sym_EMPTY) {
                            S.focus = ele;
                            S.last = runtime.getNil();
                        }
                    }
                } else if(sym == x.sym_etag) {
                    IRubyObject name, match = runtime.getNil(), e = S.focus;
                    if(S.strict) {
                        if(((RubyHash)S.EC).op_aref(scanner.ctx, tag).isNil()) {
                            tag = runtime.newString("div");
                        }
                    }

                    name = runtime.newFixnum(tag.hashCode());
                    while(e != S.doc) {
                        if(H_ELE_GET(e, H_ELE_HASH).equals(name)) {
                            match = e;
                            break;
                        }
                        e = H_ELE_GET(e, H_ELE_PARENT);

                    }
                    if(match.isNil()) {
                        H_ELE(x.cBogusETag);
                        scanner.hpricotAdd(S.focus, ele);
                    } else {
                        ele = runtime.getNil();
                        if(raw != -1) {
                            ele = RubyString.newString(runtime, scanner.data, raw, rawlen);
                        }
                        H_ELE_SET(match, H_ELE_ETAG, ele);
                        S.focus = H_ELE_GET(match, H_ELE_PARENT);
                        S.last = runtime.getNil();

                    }
                } else if(sym == x.sym_cdata) {
                    H_ELE(x.cCData);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_comment) {
                    H_ELE(x.cComment);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_doctype) {
                    H_ELE(x.cDocType);
                    if(S.strict) {
                        RubyHash h = (RubyHash)attr;
                        h.fastASet(runtime.newSymbol("system_id"), runtime.newString("http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"));
                        h.fastASet(runtime.newSymbol("public_id"), runtime.newString("-//W3C//DTD XHTML 1.0 Strict//EN"));
                    }
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_procins) {
                    IRubyObject match = tag.callMethod(scanner.ctx, "match", x.reProcInsParse);
                    tag = RubyRegexp.nth_match(1, match);
                    attr = RubyRegexp.nth_match(2, match);
                    H_ELE(x.cProcIns);
                    scanner.hpricotAdd(S.focus, ele);
                } else if(sym == x.sym_text) {
                    if(!S.last.isNil() && S.last.getType() == x.cText) {
                        ((RubyString)H_ELE_GET(S.last, H_ELE_TAG)).append(tag);
                    } else {
                        H_ELE(x.cText);
                        scanner.hpricotAdd(S.focus, ele);
                    }
                } else if(sym == x.sym_xmldecl) {
                    H_ELE(x.cXMLDecl);
                    scanner.hpricotAdd(S.focus, ele);
                }
            }
        }

        public void hpricotToken(State S, IRubyObject _sym, IRubyObject _tag, IRubyObject _attr, int _raw, int _rawlen, boolean taint) {
            TokenInfo t = new TokenInfo();
            t.sym = _sym;
            t.tag = _tag;
            t.attr = _attr;
            t.raw = _raw;
            t.rawlen = _rawlen;
            t.ec = runtime.getNil();
            t.ele = runtime.getNil();
            t.x = x;
            t.runtime = runtime;
            t.scanner = this;
            t.S = S;

            t.hpricotToken(taint);
        }

        public void yieldTokens(IRubyObject sym, IRubyObject tag, IRubyObject attr, IRubyObject raw, boolean taint) {
            if(sym == x.sym_text) {
                raw = tag;
            }
            IRubyObject ary = RubyArray.newArrayNoCopy(runtime, new IRubyObject[]{sym, tag, attr, raw});
            if(taint) {
                ary.setTaint(true);
                tag.setTaint(true);
                attr.setTaint(true);
                raw.setTaint(true);
            }

            block.yield(ctx, ary);
        }

%%{
  machine hpricot_scan;

  action newEle {
    if(text) {
        tag = CAT(tag, mark_tag, p);
        ELE(x.sym_text);
        text = false;
    }
    attr = runtime.getNil();
    tag = runtime.getNil();
    mark_tag = -1;
    ele_open = true;
  }

  action _tag  { mark_tag = p; }
  action _aval { mark_aval = p; }
  action _akey { mark_akey = p; }
  action tag   { tag = SET(mark_tag, p, tag); }
  action tagc  { tag = SET(mark_tag, p-1, tag); }
  action aval  { aval = SET(mark_aval, p, aval); }
  action aunq {
      if(data[p-1] == '"' || data[p-1] == '\'') {
          aval = SET(mark_aval, p-1, aval);
      } else {
          aval = SET(mark_aval, p, aval);
      }
  }
  action akey {   akey = SET(mark_akey, p, akey); }
  action xmlver { aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("version"), aval); }
  action xmlenc { aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("encoding"), aval); }
  action xmlsd  { aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("standalone"), aval); }
  action pubid  { aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("public_id"), aval); }
  action sysid  { aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("system_id"), aval); }

  action new_attr {
      akey = runtime.getNil();
      aval = runtime.getNil();
      mark_akey = -1;
      mark_aval = -1;
  }

  action save_attr {
      if(!S.xml) {
          akey = akey.callMethod(runtime.getCurrentContext(), "downcase");
      }
      ATTR(akey, aval);
  }

  include hpricot_common "hpricot_common.rl";
}%%

%% write data nofinal;

        public final static int BUFSIZE = 16384;


        private int cs, act, have = 0, nread = 0, curline = 1;
        private int ts = 0, te = 0, eof = -1, p = -1, pe = -1, buf = 0;
        private byte[] data;
        private State S = null;
        private IRubyObject port, opts, attr, tag, akey, aval, bufsize;
        private int mark_tag = -1, mark_akey = -1, mark_aval = -1;
        private boolean done = false, ele_open = false, taint = false, io = false, text = false;
        private int buffer_size = 0;

        private Extra x;

        private IRubyObject self;
        private Ruby runtime;
        private ThreadContext ctx;
        private Block block;

        private IRubyObject xmldecl, doctype, stag, etag, emptytag, comment, cdata, procins;

        private RaiseException newRaiseException(RubyClass exceptionClass, String message) {
            return new RaiseException(runtime, exceptionClass, message, true);
        }

        public Scanner(IRubyObject self, IRubyObject[] args, Block block) {
            this.self = self;
            this.runtime = self.getRuntime();
            this.ctx = runtime.getCurrentContext();
            this.block = block;
            attr = runtime.getNil();
            tag = runtime.getNil();
            akey = runtime.getNil();
            aval = runtime.getNil();
            bufsize = runtime.getNil();

            this.x = (Extra)this.runtime.getModule("Hpricot").dataGetStruct();

            this.xmldecl = x.sym_xmldecl;
            this.doctype = x.sym_doctype;
            this.stag = x.sym_stag;
            this.etag = x.sym_etag;
            this.emptytag = x.sym_emptytag;
            this.comment = x.sym_comment;
            this.cdata = x.sym_cdata;
            this.procins = x.sym_procins;

            port = args[0];
            if(args.length == 2) {
                opts = args[1];
            } else {
                opts = runtime.getNil();
            }

            taint = port.isTaint();
            io = port.respondsTo("read");
            if(!io) {
                if(port.respondsTo("to_str")) {
                    port = port.callMethod(ctx, "to_str");
                    port = port.convertToString();
                } else {
                    throw runtime.newArgumentError("an Hpricot document must be built from an input source (a String or IO object.)");
                }
            }

            if(!(opts instanceof RubyHash)) {
                opts = runtime.getNil();
            }

            if(!block.isGiven()) {
                S = new State();
                S.doc = x.cDoc.allocate();
                S.focus = S.doc;
                S.last = runtime.getNil();
                S.xml = OPT(opts, "xml");
                S.strict = OPT(opts, "xhtml_strict");
                S.fixup = OPT(opts, "fixup_tags");
                if(S.strict) {
                    S.fixup = true;
                }
                S.doc.getInstanceVariables().fastSetInstanceVariable("@options", opts);
                S.EC = x.mHpricot.getConstant("ElementContent");
            }

            buffer_size = BUFSIZE;
            if(self.getInstanceVariables().fastHasInstanceVariable("@buffer_size")) {
                bufsize = self.getInstanceVariables().fastGetInstanceVariable("@buffer_size");
                if(!bufsize.isNil()) {
                    buffer_size = RubyNumeric.fix2int(bufsize);
                }
            }

            if(io) {
                buf = 0;
                data = new byte[buffer_size];
            }
        }
        
        private int len, space;
        // hpricot_scan
        public IRubyObject scan() {
%% write init;
            while(!done) {
                p = pe = len = buf;
                space = buffer_size - have;
                
                if(io) {
                    if(space == 0) {
                        /* We've used up the entire buffer storing an already-parsed token
                         * prefix that must be preserved.  Likely caused by super-long attributes.
                         * Increase buffer size and continue  */
                        buffer_size += BUFSIZE;
                        data = realloc(data, buffer_size);
                        space = buffer_size - have;
                    }

                    p = have;
                    IRubyObject str = port.callMethod(ctx, "read", runtime.newFixnum(space));
                    ByteList bl = str.convertToString().getByteList();
                    len = bl.realSize;
                    System.arraycopy(bl.bytes, bl.begin, data, p, len);
                } else {
                    ByteList bl = port.convertToString().getByteList();
                    data = bl.bytes;
                    buf = bl.begin;
                    p = bl.begin;
                    len = bl.realSize + 1;
                    if(p + len >= data.length) {
                        data = new byte[len];
                        System.arraycopy(bl.bytes, bl.begin, data, 0, bl.realSize);
                        p = 0;
                        buf = 0;
                    }
                    done = true;
                    eof = p + len;
                }

                nread += len;

                /* If this is the last buffer, tack on an EOF. */
                if(io && len < space) {
                    data[p + len++] = 0;
                    eof = p + len;
                    done = true;
                }

                pe = p + len;

                %% write exec;

                if(cs == hpricot_scan_error) {
                    if(!tag.isNil()) {
                        throw newRaiseException(x.rb_eHpricotParseError, "parse error on element <" + tag + ">, starting on line " + curline + ".\n" + NO_WAY_SERIOUSLY);
                    } else {
                        throw newRaiseException(x.rb_eHpricotParseError, "parse error on line " + curline + ".\n" + NO_WAY_SERIOUSLY);
                    }
                }

                if(done && ele_open) {
                    ele_open = false;
                    if(ts > 0) {
                        mark_tag = ts;
                        ts = 0;
                        text = true;
                    }
                }

                if(ts == -1) {
                    have = 0;
                    if(mark_tag != -1 && text) {
                        if(done) {
                            if(mark_tag < p - 1) {
                                tag = CAT(tag, mark_tag, p-1);
                                ELE(x.sym_text);
                            }
                        } else {
                            tag = CAT(tag, mark_tag, p);
                        }
                    }
                    if(io) {
                        mark_tag = 0;
                    } else {
                        mark_tag = ((RubyString)port).getByteList().begin;
                    }
                } else if(io) {
                    have = pe - ts;
                    System.arraycopy(data, ts, data, buf, have);
                    mark_tag = SLIDE(mark_tag);
                    mark_akey = SLIDE(mark_akey);
                    mark_aval = SLIDE(mark_aval);
                    te -= ts;
                    ts = 0;
                }
            }

            if(S != null) {
                return S.doc;
            }

            return runtime.getNil();
        }
    }

    public static class HpricotModule {
        // hpricot_scan
        @JRubyMethod(module = true, optional = 1, required = 1, frame = true)
        public static IRubyObject scan(IRubyObject self, IRubyObject[] args, Block block) {
            return new Scanner(self, args, block).scan();
        }

        // hpricot_css
        @JRubyMethod(module = true)
        public static IRubyObject css(IRubyObject self, IRubyObject mod, IRubyObject str, IRubyObject node) {
            return new HpricotCss(self, mod, str, node).scan();
        }
    }

    public static class CData {
        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class Comment {
        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class DocType {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject target(IRubyObject self) {
            return hpricot_ele_get_target(self);
        }

        @JRubyMethod(name = "target=")
        public static IRubyObject target_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_target(self, value);
        }

        @JRubyMethod
        public static IRubyObject public_id(IRubyObject self) {
            return hpricot_ele_get_public_id(self);
        }

        @JRubyMethod(name = "public_id=")
        public static IRubyObject public_id_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_public_id(self, value);
        }

        @JRubyMethod
        public static IRubyObject system_id(IRubyObject self) {
            return hpricot_ele_get_system_id(self);
        }

        @JRubyMethod(name = "system_id=")
        public static IRubyObject system_id_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_system_id(self, value);
        }
    }

    public static class Elem {
        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_raw(self);
        }
    }

    public static class BogusETag {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_attr(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_attr(self);
        }
    }

    public static class Text {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }
    }

    public static class XMLDecl {
        @JRubyMethod
        public static IRubyObject raw_string(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod
        public static IRubyObject clear_raw(IRubyObject self) {
            return hpricot_ele_clear_name(self);
        }

        @JRubyMethod
        public static IRubyObject encoding(IRubyObject self) {
            return hpricot_ele_get_encoding(self);
        }

        @JRubyMethod(name = "encoding=")
        public static IRubyObject encoding_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_encoding(self, value);
        }

        @JRubyMethod
        public static IRubyObject standalone(IRubyObject self) {
            return hpricot_ele_get_standalone(self);
        }

        @JRubyMethod(name = "standalone=")
        public static IRubyObject standalone_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_standalone(self, value);
        }

        @JRubyMethod
        public static IRubyObject version(IRubyObject self) {
            return hpricot_ele_get_version(self);
        }

        @JRubyMethod(name = "version=")
        public static IRubyObject version_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_version(self, value);
        }
    }

    public static class ProcIns {
        @JRubyMethod
        public static IRubyObject target(IRubyObject self) {
            return hpricot_ele_get_name(self);
        }

        @JRubyMethod(name = "target=")
        public static IRubyObject target_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_name(self, value);
        }

        @JRubyMethod
        public static IRubyObject content(IRubyObject self) {
            return hpricot_ele_get_attr(self);
        }

        @JRubyMethod(name = "content=")
        public static IRubyObject content_set(IRubyObject self, IRubyObject value) {
            return hpricot_ele_set_attr(self, value);
        }
    }

    public final static String NO_WAY_SERIOUSLY = "*** This should not happen, please send a bug report with the HTML you're parsing to why@whytheluckystiff.net.  So sorry!";

    public final static int H_ELE_TAG = 0;
    public final static int H_ELE_PARENT = 1;
    public final static int H_ELE_ATTR = 2;
    public final static int H_ELE_ETAG = 3;
    public final static int H_ELE_RAW = 4;
    public final static int H_ELE_EC = 5;
    public final static int H_ELE_HASH = 6;
    public final static int H_ELE_CHILDREN = 7;

    public static IRubyObject H_ELE_GET(IRubyObject recv, int n) {
        return ((IRubyObject[])recv.dataGetStruct())[n];
    }

    public static IRubyObject H_ELE_SET(IRubyObject recv, int n, IRubyObject value) {
        ((IRubyObject[])recv.dataGetStruct())[n] = value;
        return value;
    }

    private static class RefCallback implements Callback {
        private final int n;
        public RefCallback(int n) { this.n = n; }

        public IRubyObject execute(IRubyObject recv, IRubyObject[] args, Block block) {
            return H_ELE_GET(recv, n);
        }

        public Arity getArity() {
            return Arity.NO_ARGUMENTS;
        }
    }

    private static class SetCallback implements Callback {
        private final int n;
        public SetCallback(int n) { this.n = n; }

        public IRubyObject execute(IRubyObject recv, IRubyObject[] args, Block block) {
            return H_ELE_SET(recv, n, args[0]);
        }

        public Arity getArity() {
            return Arity.ONE_ARGUMENT;
        }
    }

    private final static Callback[] ref_func = new Callback[]{
        new RefCallback(0),
        new RefCallback(1),
        new RefCallback(2),
        new RefCallback(3),
        new RefCallback(4),
        new RefCallback(5),
        new RefCallback(6),
        new RefCallback(7),
        new RefCallback(8),
        new RefCallback(9)};

    private final static Callback[] set_func = new Callback[]{
        new SetCallback(0),
        new SetCallback(1),
        new SetCallback(2),
        new SetCallback(3),
        new SetCallback(4),
        new SetCallback(5),
        new SetCallback(6),
        new SetCallback(7),
        new SetCallback(8),
        new SetCallback(9)};

    public final static ObjectAllocator alloc_hpricot_struct = new ObjectAllocator() {
            // alloc_hpricot_struct
            public IRubyObject allocate(Ruby runtime, RubyClass klass) {
                RubyClass kurrent = klass;
                Object sz = kurrent.fastGetInternalVariable("__size__");
                while(sz == null && kurrent != null) {
                    kurrent = kurrent.getSuperClass();
                    sz = kurrent.fastGetInternalVariable("__size__");
                }
                int size = RubyNumeric.fix2int((RubyObject)sz);
                RubyObject obj = new RubyObject(runtime, klass);
                IRubyObject[] all = new IRubyObject[size];
                java.util.Arrays.fill(all, runtime.getNil());
                obj.dataWrapStruct(all);
                return obj;
            }
        };

    public static RubyClass makeHpricotStruct(Ruby runtime, IRubyObject[] members) {
        RubyClass klass = RubyClass.newClass(runtime, runtime.getObject());
        klass.fastSetInternalVariable("__size__", runtime.newFixnum(members.length));
        klass.setAllocator(alloc_hpricot_struct);

        for(int i = 0; i < members.length; i++) {
            String id = members[i].toString();
            klass.defineMethod(id, ref_func[i]);
            klass.defineMethod(id + "=", set_func[i]);
        }
    
        return klass;
    }

    public boolean basicLoad(final Ruby runtime) throws IOException {
        Init_hpricot_scan(runtime);
        return true;
    }

    public static class Extra {
        IRubyObject symAllow, symDeny, sym_xmldecl, sym_doctype, 
            sym_procins, sym_stag, sym_etag, sym_emptytag, 
            sym_allowed, sym_children, sym_comment, 
            sym_cdata, sym_name, sym_parent, 
            sym_raw_attributes, sym_raw_string, sym_tagno, 
            sym_text, sym_EMPTY, sym_CDATA;

        public RubyModule mHpricot;
        public RubyClass structElem;
        public RubyClass structAttr;
        public RubyClass structBasic;
        public RubyClass cDoc;
        public RubyClass cCData;
        public RubyClass cComment;
        public RubyClass cDocType;
        public RubyClass cElem;
        public RubyClass cBogusETag;
        public RubyClass cText;
        public RubyClass cXMLDecl;
        public RubyClass cProcIns;
        public RubyClass rb_eHpricotParseError;
        public IRubyObject reProcInsParse;

        public Extra(Ruby runtime) {
            symAllow = runtime.newSymbol("allow");
            symDeny = runtime.newSymbol("deny");
            sym_xmldecl = runtime.newSymbol("xmldecl");
            sym_doctype = runtime.newSymbol("doctype");
            sym_procins = runtime.newSymbol("procins");
            sym_stag = runtime.newSymbol("stag");
            sym_etag = runtime.newSymbol("etag");
            sym_emptytag = runtime.newSymbol("emptytag");
            sym_allowed = runtime.newSymbol("allowed");
            sym_children = runtime.newSymbol("children");
            sym_comment = runtime.newSymbol("comment");
            sym_cdata = runtime.newSymbol("cdata");
            sym_name = runtime.newSymbol("name");
            sym_parent = runtime.newSymbol("parent");
            sym_raw_attributes = runtime.newSymbol("raw_attributes");
            sym_raw_string = runtime.newSymbol("raw_string");
            sym_tagno = runtime.newSymbol("tagno");
            sym_text = runtime.newSymbol("text");
            sym_EMPTY = runtime.newSymbol("EMPTY");
            sym_CDATA = runtime.newSymbol("CDATA");
        }
    }

    public static void Init_hpricot_scan(Ruby runtime) {
        Extra x = new Extra(runtime);

        x.mHpricot = runtime.defineModule("Hpricot");
        x.mHpricot.dataWrapStruct(x);

        x.mHpricot.getSingletonClass().attr_accessor(runtime.getCurrentContext(),new  IRubyObject[]{runtime.newSymbol("buffer_size")});
        x.mHpricot.defineAnnotatedMethods(HpricotModule.class);

        x.rb_eHpricotParseError = x.mHpricot.defineClassUnder("ParseError",runtime.getClass("StandardError"),runtime.getClass("StandardError").getAllocator());

        x.structElem = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes, x.sym_etag, x.sym_raw_string, x.sym_allowed, x.sym_tagno, x.sym_children});
        x.structAttr = makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent, x.sym_raw_attributes});
        x.structBasic= makeHpricotStruct(runtime, new IRubyObject[] {x.sym_name, x.sym_parent});

        x.cDoc = x.mHpricot.defineClassUnder("Doc", x.structElem, x.structElem.getAllocator());

        x.cCData = x.mHpricot.defineClassUnder("CData", x.structBasic, x.structBasic.getAllocator());
        x.cCData.defineAnnotatedMethods(CData.class);

        x.cComment = x.mHpricot.defineClassUnder("Comment", x.structBasic, x.structBasic.getAllocator());
        x.cComment.defineAnnotatedMethods(Comment.class);

        x.cDocType = x.mHpricot.defineClassUnder("DocType", x.structAttr, x.structAttr.getAllocator());
        x.cDocType.defineAnnotatedMethods(DocType.class);

        x.cElem = x.mHpricot.defineClassUnder("Elem", x.structElem, x.structElem.getAllocator());
        x.cElem.defineAnnotatedMethods(Elem.class);

        x.cBogusETag = x.mHpricot.defineClassUnder("BogusETag", x.structAttr, x.structAttr.getAllocator());
        x.cBogusETag.defineAnnotatedMethods(BogusETag.class);

        x.cText = x.mHpricot.defineClassUnder("Text", x.structBasic, x.structBasic.getAllocator());
        x.cText.defineAnnotatedMethods(Text.class);

        x.cXMLDecl = x.mHpricot.defineClassUnder("XMLDecl", x.structAttr, x.structAttr.getAllocator());
        x.cXMLDecl.defineAnnotatedMethods(XMLDecl.class);

        x.cProcIns = x.mHpricot.defineClassUnder("ProcIns", x.structAttr, x.structAttr.getAllocator());
        x.cProcIns.defineAnnotatedMethods(ProcIns.class);

        x.reProcInsParse = runtime.evalScriptlet("/\\A<\\?(\\S+)\\s+(.+)/m");
        x.mHpricot.setConstant("ProcInsParse", x.reProcInsParse);
    }
}
