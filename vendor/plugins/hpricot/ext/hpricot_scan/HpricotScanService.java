// line 1 "hpricot_scan.java.rl"

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

// line 561 "hpricot_scan.java.rl"



// line 517 "HpricotScanService.java"
private static byte[] init__hpricot_scan_actions_0()
{
	return new byte [] {
	    0,    1,    1,    1,    2,    1,    4,    1,    5,    1,    6,    1,
	    7,    1,    8,    1,    9,    1,   10,    1,   11,    1,   12,    1,
	   14,    1,   16,    1,   20,    1,   21,    1,   22,    1,   24,    1,
	   25,    1,   26,    1,   28,    1,   29,    1,   30,    1,   32,    1,
	   33,    1,   38,    1,   39,    1,   40,    1,   41,    1,   42,    1,
	   43,    1,   44,    1,   45,    1,   46,    1,   47,    1,   48,    1,
	   49,    1,   50,    1,   51,    2,    2,    5,    2,    2,    6,    2,
	    2,   11,    2,    2,   12,    2,    2,   14,    2,    4,   39,    2,
	    4,   40,    2,    4,   41,    2,    5,    2,    2,    6,   14,    2,
	    7,    6,    2,    7,   14,    2,   11,   12,    2,   13,    3,    2,
	   14,    6,    2,   14,   40,    2,   15,   24,    2,   15,   28,    2,
	   15,   32,    2,   15,   45,    2,   17,   23,    2,   18,   27,    2,
	   19,   31,    2,   22,   34,    2,   22,   36,    3,    2,    6,   14,
	    3,    2,   14,    6,    3,    6,    7,   14,    3,    6,   14,   40,
	    3,    7,   14,   40,    3,   11,    2,   12,    3,   14,    6,   40,
	    3,   14,   13,    3,    3,   22,    0,   37,    3,   22,    2,   34,
	    3,   22,   14,   35,    4,    2,   14,   13,    3,    4,    6,    7,
	   14,   40,    4,   22,    2,   14,   35,    4,   22,    6,   14,   35,
	    4,   22,    7,   14,   35,    4,   22,   14,    6,   35,    5,   22,
	    2,    6,   14,   35,    5,   22,    2,   14,    6,   35,    5,   22,
	    6,    7,   14,   35
	};
}

private static final byte _hpricot_scan_actions[] = init__hpricot_scan_actions_0();


private static short[] init__hpricot_scan_key_offsets_0()
{
	return new short [] {
	    0,    3,    4,    5,    6,    7,    8,    9,   10,   13,   22,   37,
	   44,   45,   46,   47,   48,   49,   52,   57,   69,   81,   86,   93,
	   94,   95,  100,  101,  105,  106,  107,  121,  135,  152,  169,  186,
	  203,  210,  212,  214,  220,  222,  227,  232,  238,  240,  245,  251,
	  265,  266,  267,  268,  269,  270,  271,  272,  273,  274,  275,  276,
	  282,  296,  300,  313,  326,  340,  354,  355,  366,  375,  388,  405,
	  423,  441,  450,  461,  480,  499,  510,  521,  536,  538,  540,  556,
	  572,  575,  587,  599,  619,  639,  658,  677,  697,  717,  728,  739,
	  751,  763,  775,  791,  794,  809,  811,  813,  829,  845,  848,  860,
	  871,  890,  910,  930,  941,  952,  964,  984, 1004, 1016, 1036, 1057,
	 1074, 1091, 1095, 1098, 1110, 1122, 1142, 1162, 1182, 1194, 1206, 1226,
	 1242, 1258, 1270, 1291, 1310, 1313, 1328, 1340, 1355, 1358, 1369, 1371,
	 1373, 1384, 1391, 1404, 1418, 1432, 1445, 1446, 1447, 1448, 1449, 1450,
	 1451, 1455, 1460, 1469, 1479, 1484, 1491, 1492, 1493, 1494, 1495, 1496,
	 1497, 1498, 1499, 1503, 1508, 1512, 1522, 1527, 1533, 1534, 1535, 1536,
	 1537, 1538, 1539, 1540, 1541, 1542, 1546, 1551, 1553, 1554, 1555, 1560,
	 1561, 1562, 1564, 1565, 1566, 1567, 1568, 1572, 1582, 1591, 1601, 1602,
	 1603, 1605, 1614, 1615, 1616, 1617, 1619, 1621, 1624, 1627, 1631, 1633,
	 1634, 1636, 1637, 1640
	};
}

private static final short _hpricot_scan_key_offsets[] = init__hpricot_scan_key_offsets_0();


private static char[] init__hpricot_scan_trans_keys_0()
{
	return new char [] {
	   45,   68,   91,   45,   79,   67,   84,   89,   80,   69,   32,    9,
	   13,   32,   58,   95,    9,   13,   65,   90,   97,  122,   32,   62,
	   63,   91,   95,    9,   13,   45,   46,   48,   58,   65,   90,   97,
	  122,   32,   62,   80,   83,   91,    9,   13,   85,   66,   76,   73,
	   67,   32,    9,   13,   32,   34,   39,    9,   13,    9,   34,   61,
	   95,   32,   37,   39,   59,   63,   90,   97,  122,    9,   34,   61,
	   95,   32,   37,   39,   59,   63,   90,   97,  122,   32,   62,   91,
	    9,   13,   32,   34,   39,   62,   91,    9,   13,   34,   34,   32,
	   62,   91,    9,   13,   93,   32,   62,    9,   13,   39,   39,    9,
	   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,   90,   97,
	  122,    9,   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,
	   90,   97,  122,    9,   32,   33,   39,   62,   91,   95,   10,   13,
	   35,   37,   40,   59,   61,   90,   97,  122,    9,   32,   34,   39,
	   62,   91,   95,   10,   13,   33,   37,   40,   59,   61,   90,   97,
	  122,    9,   32,   33,   39,   62,   91,   95,   10,   13,   35,   37,
	   40,   59,   61,   90,   97,  122,    9,   32,   34,   39,   62,   91,
	   95,   10,   13,   33,   37,   40,   59,   61,   90,   97,  122,   32,
	   34,   39,   62,   91,    9,   13,   34,   39,   34,   39,   32,   39,
	   62,   91,    9,   13,   39,   93,   32,   62,   93,    9,   13,   32,
	   39,   62,    9,   13,   32,   34,   62,   91,    9,   13,   34,   93,
	   32,   34,   62,    9,   13,   32,   39,   62,   91,    9,   13,    9,
	   39,   61,   95,   32,   33,   35,   37,   40,   59,   63,   90,   97,
	  122,   89,   83,   84,   69,   77,   67,   68,   65,   84,   65,   91,
	   58,   95,   65,   90,   97,  122,   32,   62,   63,   95,    9,   13,
	   45,   46,   48,   58,   65,   90,   97,  122,   32,   62,    9,   13,
	   32,   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   32,   47,   62,   63,   95,    9,   13,   45,   58,   65,   90,
	   97,  122,   32,   47,   61,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   47,   61,   62,   63,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   62,   13,   32,   34,   39,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   47,   60,   62,    9,
	   10,   11,   12,   32,   47,   62,   63,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   13,   32,   47,   60,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   47,
	   60,   61,   62,   63,   95,    9,   10,   11,   12,   45,   58,   65,
	   90,   97,  122,   13,   32,   47,   60,   61,   62,   63,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   47,
	   60,   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,   62,
	   63,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,
	   13,   32,   34,   39,   47,   60,   62,   63,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   47,   60,
	   62,   92,    9,   10,   11,   12,   13,   32,   34,   47,   60,   62,
	   92,    9,   10,   11,   12,   32,   34,   47,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   34,   92,   34,   92,
	   32,   34,   47,   61,   62,   63,   92,   95,    9,   13,   45,   58,
	   65,   90,   97,  122,   32,   34,   47,   61,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   34,   62,   92,   13,
	   32,   34,   39,   47,   60,   62,   92,    9,   10,   11,   12,   13,
	   32,   34,   39,   47,   60,   62,   92,    9,   10,   11,   12,   13,
	   32,   34,   39,   47,   60,   62,   63,   92,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,   47,
	   60,   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,
	   90,   97,  122,   13,   32,   34,   47,   60,   62,   63,   92,   95,
	    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,
	   34,   47,   60,   62,   63,   92,   95,    9,   10,   11,   12,   45,
	   58,   65,   90,   97,  122,   13,   32,   34,   47,   60,   61,   62,
	   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,
	  122,   13,   32,   34,   47,   60,   61,   62,   63,   92,   95,    9,
	   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,
	   47,   60,   62,   92,    9,   10,   11,   12,   13,   32,   34,   47,
	   60,   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,
	   60,   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,
	   60,   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,
	   60,   62,   92,    9,   10,   11,   12,   32,   34,   39,   47,   62,
	   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   34,
	   39,   92,   32,   39,   47,   62,   63,   92,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   39,   92,   39,   92,   32,   39,   47,
	   61,   62,   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,
	  122,   32,   39,   47,   61,   62,   63,   92,   95,    9,   13,   45,
	   58,   65,   90,   97,  122,   39,   62,   92,   13,   32,   34,   39,
	   47,   60,   62,   92,    9,   10,   11,   12,   13,   32,   39,   47,
	   60,   62,   92,    9,   10,   11,   12,   13,   32,   39,   47,   60,
	   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   13,   32,   39,   47,   60,   61,   62,   63,   92,   95,
	    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,
	   39,   47,   60,   61,   62,   63,   92,   95,    9,   10,   11,   12,
	   45,   58,   65,   90,   97,  122,   13,   32,   39,   47,   60,   62,
	   92,    9,   10,   11,   12,   13,   32,   39,   47,   60,   62,   92,
	    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,   62,   92,
	    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,   62,   63,
	   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,
	   13,   32,   34,   39,   47,   60,   62,   63,   92,   95,    9,   10,
	   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,
	   47,   60,   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,
	   47,   60,   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,
	   65,   90,   97,  122,   13,   32,   34,   39,   47,   60,   61,   62,
	   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,   97,
	  122,   32,   34,   39,   47,   61,   62,   63,   92,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   32,   34,   39,   47,   61,   62,
	   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   34,
	   39,   62,   92,   34,   39,   92,   13,   32,   34,   39,   47,   60,
	   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   13,   32,   34,   39,   47,   60,   62,   63,   92,   95,
	    9,   10,   11,   12,   45,   58,   65,   90,   97,  122,   13,   32,
	   34,   39,   47,   60,   62,   63,   92,   95,    9,   10,   11,   12,
	   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,   47,   60,
	   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   92,    9,   10,   11,   12,   13,   32,   34,   39,   47,   60,
	   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   32,   34,   39,   47,   62,   63,   92,   95,    9,   13,
	   45,   58,   65,   90,   97,  122,   32,   34,   39,   47,   62,   63,
	   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   13,   32,
	   34,   39,   47,   60,   62,   92,    9,   10,   11,   12,   13,   32,
	   34,   39,   47,   60,   61,   62,   63,   92,   95,    9,   10,   11,
	   12,   45,   58,   65,   90,   97,  122,   13,   32,   39,   47,   60,
	   62,   63,   92,   95,    9,   10,   11,   12,   45,   58,   65,   90,
	   97,  122,   34,   39,   92,   32,   39,   47,   62,   63,   92,   95,
	    9,   13,   45,   58,   65,   90,   97,  122,   13,   32,   34,   39,
	   47,   60,   62,   92,    9,   10,   11,   12,   32,   34,   47,   62,
	   63,   92,   95,    9,   13,   45,   58,   65,   90,   97,  122,   34,
	   39,   92,   13,   32,   39,   47,   60,   62,   92,    9,   10,   11,
	   12,   34,   92,   39,   92,   13,   32,   34,   39,   47,   60,   62,
	    9,   10,   11,   12,   58,   95,  120,   65,   90,   97,  122,   32,
	   63,   95,    9,   13,   45,   46,   48,   58,   65,   90,   97,  122,
	   32,   63,   95,  109,    9,   13,   45,   46,   48,   58,   65,   90,
	   97,  122,   32,   63,   95,  108,    9,   13,   45,   46,   48,   58,
	   65,   90,   97,  122,   32,   63,   95,    9,   13,   45,   46,   48,
	   58,   65,   90,   97,  122,  101,  114,  115,  105,  111,  110,   32,
	   61,    9,   13,   32,   34,   39,    9,   13,   95,   45,   46,   48,
	   58,   65,   90,   97,  122,   34,   95,   45,   46,   48,   58,   65,
	   90,   97,  122,   32,   62,   63,    9,   13,   32,   62,   63,  101,
	  115,    9,   13,   62,  110,   99,  111,  100,  105,  110,  103,   32,
	   61,    9,   13,   32,   34,   39,    9,   13,   65,   90,   97,  122,
	   34,   95,   45,   46,   48,   57,   65,   90,   97,  122,   32,   62,
	   63,    9,   13,   32,   62,   63,  115,    9,   13,  116,   97,  110,
	  100,   97,  108,  111,  110,  101,   32,   61,    9,   13,   32,   34,
	   39,    9,   13,  110,  121,  111,   34,   32,   62,   63,    9,   13,
	  101,  115,  110,  121,  111,   39,  101,  115,   65,   90,   97,  122,
	   39,   95,   45,   46,   48,   57,   65,   90,   97,  122,   95,   45,
	   46,   48,   58,   65,   90,   97,  122,   39,   95,   45,   46,   48,
	   58,   65,   90,   97,  122,   62,   62,   10,   60,   33,   47,   58,
	   63,   95,   65,   90,   97,  122,   39,   93,   34,   34,   92,   39,
	   92,   34,   39,   92,   32,    9,   13,   32,  118,    9,   13,   10,
	   45,   45,   10,   93,   93,   10,   62,   63,   62,    0
	};
}

private static final char _hpricot_scan_trans_keys[] = init__hpricot_scan_trans_keys_0();


private static byte[] init__hpricot_scan_single_lengths_0()
{
	return new byte [] {
	    3,    1,    1,    1,    1,    1,    1,    1,    1,    3,    5,    5,
	    1,    1,    1,    1,    1,    1,    3,    4,    4,    3,    5,    1,
	    1,    3,    1,    2,    1,    1,    4,    4,    7,    7,    7,    7,
	    5,    2,    2,    4,    2,    3,    3,    4,    2,    3,    4,    4,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    2,
	    4,    2,    5,    5,    6,    6,    1,    7,    5,    5,    7,    8,
	    8,    5,    7,    9,    9,    7,    7,    7,    2,    2,    8,    8,
	    3,    8,    8,   10,   10,    9,    9,   10,   10,    7,    7,    8,
	    8,    8,    8,    3,    7,    2,    2,    8,    8,    3,    8,    7,
	    9,   10,   10,    7,    7,    8,   10,   10,    8,   10,   11,    9,
	    9,    4,    3,    8,    8,   10,   10,   10,    8,    8,   10,    8,
	    8,    8,   11,    9,    3,    7,    8,    7,    3,    7,    2,    2,
	    7,    3,    3,    4,    4,    3,    1,    1,    1,    1,    1,    1,
	    2,    3,    1,    2,    3,    5,    1,    1,    1,    1,    1,    1,
	    1,    1,    2,    3,    0,    2,    3,    4,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    2,    3,    2,    1,    1,    3,    1,
	    1,    2,    1,    1,    1,    1,    0,    2,    1,    2,    1,    1,
	    2,    5,    1,    1,    1,    2,    2,    3,    1,    2,    2,    1,
	    2,    1,    3,    1
	};
}

private static final byte _hpricot_scan_single_lengths[] = init__hpricot_scan_single_lengths_0();


private static byte[] init__hpricot_scan_range_lengths_0()
{
	return new byte [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    1,    3,    5,    1,
	    0,    0,    0,    0,    0,    1,    1,    4,    4,    1,    1,    0,
	    0,    1,    0,    1,    0,    0,    5,    5,    5,    5,    5,    5,
	    1,    0,    0,    1,    0,    1,    1,    1,    0,    1,    1,    5,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    2,
	    5,    1,    4,    4,    4,    4,    0,    2,    2,    4,    5,    5,
	    5,    2,    2,    5,    5,    2,    2,    4,    0,    0,    4,    4,
	    0,    2,    2,    5,    5,    5,    5,    5,    5,    2,    2,    2,
	    2,    2,    4,    0,    4,    0,    0,    4,    4,    0,    2,    2,
	    5,    5,    5,    2,    2,    2,    5,    5,    2,    5,    5,    4,
	    4,    0,    0,    2,    2,    5,    5,    5,    2,    2,    5,    4,
	    4,    2,    5,    5,    0,    4,    2,    4,    0,    2,    0,    0,
	    2,    2,    5,    5,    5,    5,    0,    0,    0,    0,    0,    0,
	    1,    1,    4,    4,    1,    1,    0,    0,    0,    0,    0,    0,
	    0,    0,    1,    1,    2,    4,    1,    1,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    1,    1,    0,    0,    0,    1,    0,
	    0,    0,    0,    0,    0,    0,    2,    4,    4,    4,    0,    0,
	    0,    2,    0,    0,    0,    0,    0,    0,    1,    1,    0,    0,
	    0,    0,    0,    0
	};
}

private static final byte _hpricot_scan_range_lengths[] = init__hpricot_scan_range_lengths_0();


private static short[] init__hpricot_scan_index_offsets_0()
{
	return new short [] {
	    0,    4,    6,    8,   10,   12,   14,   16,   18,   21,   28,   39,
	   46,   48,   50,   52,   54,   56,   59,   64,   73,   82,   87,   94,
	   96,   98,  103,  105,  109,  111,  113,  123,  133,  146,  159,  172,
	  185,  192,  195,  198,  204,  207,  212,  217,  223,  226,  231,  237,
	  247,  249,  251,  253,  255,  257,  259,  261,  263,  265,  267,  269,
	  274,  284,  288,  298,  308,  319,  330,  332,  342,  350,  360,  373,
	  387,  401,  409,  419,  434,  449,  459,  469,  481,  484,  487,  500,
	  513,  517,  528,  539,  555,  571,  586,  601,  617,  633,  643,  653,
	  664,  675,  686,  699,  703,  715,  718,  721,  734,  747,  751,  762,
	  772,  787,  803,  819,  829,  839,  850,  866,  882,  893,  909,  926,
	  940,  954,  959,  963,  974,  985, 1001, 1017, 1033, 1044, 1055, 1071,
	 1084, 1097, 1108, 1125, 1140, 1144, 1156, 1167, 1179, 1183, 1193, 1196,
	 1199, 1209, 1215, 1224, 1234, 1244, 1253, 1255, 1257, 1259, 1261, 1263,
	 1265, 1269, 1274, 1280, 1287, 1292, 1299, 1301, 1303, 1305, 1307, 1309,
	 1311, 1313, 1315, 1319, 1324, 1327, 1334, 1339, 1345, 1347, 1349, 1351,
	 1353, 1355, 1357, 1359, 1361, 1363, 1367, 1372, 1375, 1377, 1379, 1384,
	 1386, 1388, 1391, 1393, 1395, 1397, 1399, 1402, 1409, 1415, 1422, 1424,
	 1426, 1429, 1437, 1439, 1441, 1443, 1446, 1449, 1453, 1456, 1460, 1463,
	 1465, 1468, 1470, 1474
	};
}

private static final short _hpricot_scan_index_offsets[] = init__hpricot_scan_index_offsets_0();


private static short[] init__hpricot_scan_indicies_0()
{
	return new short [] {
	    1,    2,    3,    0,    4,    0,    5,    0,    6,    0,    7,    0,
	    8,    0,    9,    0,   10,    0,   11,   11,    0,   11,   12,   12,
	   11,   12,   12,    0,   13,   15,   14,   16,   14,   13,   14,   14,
	   14,   14,    0,   17,   18,   19,   20,   21,   17,    0,   22,    0,
	   23,    0,   24,    0,   25,    0,   26,    0,   27,   27,    0,   27,
	   28,   29,   27,    0,   30,   31,   30,   30,   30,   30,   30,   30,
	    0,   32,   33,   32,   32,   32,   32,   32,   32,    0,   34,   18,
	   21,   34,    0,   34,   35,   36,   18,   21,   34,    0,   38,   37,
	   41,   40,   42,   18,   21,   42,   39,   43,   21,   43,   18,   43,
	   39,   38,   44,   41,   45,   46,   47,   46,   46,   46,   46,   46,
	   46,   46,    0,   48,   49,   48,   48,   48,   48,   48,   48,   48,
	    0,   50,   50,   48,   49,   18,   21,   48,   34,   48,   48,   48,
	   48,    0,   50,   50,   35,   51,   18,   21,   48,   34,   48,   48,
	   48,   48,    0,   52,   52,   54,   55,   56,   57,   54,   53,   54,
	   54,   54,   54,   44,   58,   58,   61,   62,   63,   64,   60,   59,
	   60,   60,   60,   60,   45,   59,   61,   65,   63,   64,   59,   45,
	   67,   68,   66,   70,   71,   69,   72,   41,   63,   64,   72,   45,
	   73,   74,   64,   75,   76,   43,   75,   21,   74,   41,   63,   74,
	   45,   77,   41,   78,   79,   77,   40,   73,   80,   79,   80,   41,
	   78,   80,   40,   81,   38,   56,   57,   81,   44,   60,   82,   60,
	   60,   60,   60,   60,   60,   60,   45,   83,    0,   84,    0,   85,
	    0,   86,    0,   87,    0,   88,    0,   89,    0,   90,    0,   91,
	    0,   92,    0,   93,    0,   94,   94,   94,   94,    0,   95,   97,
	   96,   96,   95,   96,   96,   96,   96,    0,   98,   99,   98,    0,
	  100,  102,  103,  101,  101,  100,  101,  101,  101,    0,  104,  106,
	  107,  105,  105,  104,  105,  105,  105,    0,  108,  110,  111,  112,
	  109,  109,  108,  109,  109,  109,   39,  113,  115,  116,  117,  114,
	  114,  113,  114,  114,  114,   39,  118,   39,  120,  120,  122,  123,
	  124,   39,  117,  120,  121,  119,  126,  126,  128,   39,  129,  126,
	  127,  125,  130,  115,  117,  114,  114,  130,  114,  114,  114,   39,
	  126,  126,  132,   39,  133,  131,  131,  126,  127,  131,  131,  131,
	  125,  134,  134,  137,   39,  138,  139,  136,  136,  134,  135,  136,
	  136,  136,  125,  140,  140,  132,   39,  142,  133,  131,  131,  140,
	  141,  131,  131,  131,  125,  126,  126,  128,   39,  129,  126,  127,
	  125,  143,  143,  145,  146,  147,   39,  129,  143,  144,  119,  148,
	  148,  122,  123,  124,   39,  117,  150,  150,  148,  149,  150,  150,
	  150,  119,  143,  143,  145,  146,  151,   39,  133,  150,  150,  143,
	  144,  150,  150,  150,  119,  153,  153,  155,  156,  157,  158,  159,
	  153,  154,  152,  161,  161,  163,  164,  165,  166,  167,  161,  162,
	  160,  168,  169,  171,  172,  170,  173,  170,  168,  170,  170,  170,
	  165,  169,  173,  165,  174,  173,  165,  175,  169,  177,  178,  179,
	  176,  173,  176,  175,  176,  176,  176,  165,  180,  169,  171,  181,
	  172,  170,  173,  170,  180,  170,  170,  170,  165,  169,  182,  173,
	  165,  183,  183,  185,  186,  187,  165,  172,  159,  183,  184,  152,
	  188,  188,  185,  186,  187,  165,  172,  159,  188,  189,  152,  188,
	  188,  185,  186,  187,  165,  172,  190,  159,  190,  188,  189,  190,
	  190,  190,  152,  191,  191,  193,  194,  195,  165,  196,  190,  159,
	  190,  191,  192,  190,  190,  190,  152,  153,  153,  155,  195,  157,
	  197,  190,  159,  190,  153,  154,  190,  190,  190,  152,  161,  161,
	  163,  199,  165,  196,  198,  167,  198,  161,  162,  198,  198,  198,
	  160,  200,  200,  163,  203,  165,  204,  205,  202,  167,  202,  200,
	  201,  202,  202,  202,  160,  206,  206,  163,  199,  165,  208,  196,
	  198,  167,  198,  206,  207,  198,  198,  198,  160,  161,  161,  163,
	  164,  165,  166,  167,  161,  162,  160,  161,  161,  209,  164,  165,
	  166,  167,  161,  162,  160,  191,  191,  193,  194,  156,  165,  166,
	  159,  191,  192,  152,  211,  211,  213,  214,  215,  216,  217,  218,
	  211,  212,  210,  220,  220,  222,  209,  223,  224,  225,  226,  220,
	  221,  219,  227,  228,  174,  230,  231,  229,  232,  229,  227,  229,
	  229,  229,  224,  228,  174,  232,  224,  234,  169,  236,  237,  235,
	  238,  235,  234,  235,  235,  235,  233,  169,  238,  233,  228,  238,
	  233,  239,  169,  241,  242,  243,  240,  238,  240,  239,  240,  240,
	  240,  233,  244,  169,  236,  245,  237,  235,  238,  235,  244,  235,
	  235,  235,  233,  169,  246,  238,  233,  248,  248,  250,  251,  252,
	  233,  237,  253,  248,  249,  247,  255,  255,  163,  257,  233,  258,
	  259,  255,  256,  254,  255,  255,  163,  261,  233,  262,  260,  259,
	  260,  255,  256,  260,  260,  260,  254,  263,  263,  163,  266,  233,
	  267,  268,  265,  259,  265,  263,  264,  265,  265,  265,  254,  269,
	  269,  163,  261,  233,  271,  262,  260,  259,  260,  269,  270,  260,
	  260,  260,  254,  255,  255,  163,  257,  233,  258,  259,  255,  256,
	  254,  255,  255,  222,  257,  233,  258,  259,  255,  256,  254,  272,
	  272,  274,  275,  276,  233,  258,  253,  272,  273,  247,  277,  277,
	  250,  251,  252,  233,  237,  279,  253,  279,  277,  278,  279,  279,
	  279,  247,  272,  272,  274,  275,  280,  233,  262,  279,  253,  279,
	  272,  273,  279,  279,  279,  247,  211,  211,  281,  214,  215,  216,
	  217,  218,  211,  212,  210,  220,  220,  222,  209,  283,  224,  284,
	  282,  226,  282,  220,  221,  282,  282,  282,  219,  285,  285,  222,
	  209,  288,  224,  289,  290,  287,  226,  287,  285,  286,  287,  287,
	  287,  219,  291,  228,  174,  230,  292,  231,  229,  232,  229,  291,
	  229,  229,  229,  224,  293,  228,  174,  295,  296,  297,  294,  232,
	  294,  293,  294,  294,  294,  224,  228,  174,  298,  232,  224,  299,
	  299,  232,  224,  300,  300,  302,  303,  304,  224,  231,  218,  300,
	  301,  210,  305,  305,  302,  303,  304,  224,  231,  218,  305,  306,
	  210,  305,  305,  302,  303,  304,  224,  231,  307,  218,  307,  305,
	  306,  307,  307,  307,  210,  308,  308,  310,  311,  312,  224,  284,
	  307,  218,  307,  308,  309,  307,  307,  307,  210,  211,  211,  281,
	  214,  312,  216,  313,  307,  218,  307,  211,  212,  307,  307,  307,
	  210,  220,  220,  222,  209,  223,  224,  225,  226,  220,  221,  219,
	  220,  220,  314,  314,  223,  224,  225,  226,  220,  221,  219,  211,
	  211,  213,  214,  312,  216,  313,  307,  218,  307,  211,  212,  307,
	  307,  307,  210,  315,  316,  317,  319,  320,  318,  321,  318,  315,
	  318,  318,  318,  216,  315,  322,  317,  319,  320,  318,  321,  318,
	  315,  318,  318,  318,  216,  308,  308,  310,  311,  215,  224,  225,
	  218,  308,  309,  210,  323,  323,  222,  209,  283,  224,  325,  284,
	  282,  226,  282,  323,  324,  282,  282,  282,  219,  326,  326,  155,
	  280,  328,  329,  279,  253,  279,  326,  327,  279,  279,  279,  247,
	  316,  317,  321,  216,  330,  331,  333,  334,  332,  335,  332,  330,
	  332,  332,  332,  328,  277,  277,  250,  251,  252,  233,  237,  253,
	  277,  278,  247,  336,  331,  338,  339,  337,  340,  337,  336,  337,
	  337,  337,  157,  322,  317,  321,  216,  326,  326,  155,  276,  328,
	  341,  253,  326,  327,  247,  331,  340,  157,  331,  335,  328,  148,
	  148,  122,  123,  124,   39,  117,  148,  149,  119,  342,  342,  343,
	  342,  342,    0,  344,  345,  345,  344,  345,  345,  345,  345,    0,
	  344,  345,  345,  346,  344,  345,  345,  345,  345,    0,  344,  345,
	  345,  347,  344,  345,  345,  345,  345,    0,  348,  345,  345,  348,
	  345,  345,  345,  345,    0,  350,  349,  351,  349,  352,  349,  353,
	  349,  354,  349,  355,  349,  355,  356,  355,  349,  356,  357,  358,
	  356,  349,  359,  359,  359,  359,  359,  349,  360,  361,  361,  361,
	  361,  361,  349,  362,  363,  364,  362,  349,  362,  363,  364,  365,
	  366,  362,  349,  363,  349,  367,  349,  368,  349,  369,  349,  370,
	  349,  371,  349,  372,  349,  373,  349,  373,  374,  373,  349,  374,
	  375,  376,  374,  349,  377,  377,  349,  378,  379,  379,  379,  379,
	  379,  349,  380,  363,  364,  380,  349,  380,  363,  364,  366,  380,
	  349,  381,  349,  382,  349,  383,  349,  384,  349,  385,  349,  386,
	  349,  387,  349,  388,  349,  389,  349,  389,  390,  389,  349,  390,
	  391,  392,  390,  349,  393,  394,  349,  395,  349,  396,  349,  397,
	  363,  364,  397,  349,  398,  349,  395,  349,  399,  400,  349,  401,
	  349,  396,  349,  402,  349,  401,  349,  403,  403,  349,  378,  404,
	  404,  404,  404,  404,  349,  405,  405,  405,  405,  405,  349,  360,
	  406,  406,  406,  406,  406,  349,  408,  407,  410,  409,  412,  413,
	  411,  415,  416,  417,  418,  417,  417,  417,  414,   41,   45,   43,
	   21,   41,   40,  169,  173,  165,  169,  238,  233,  228,  174,  232,
	  224,  344,  344,  420,  348,  421,  348,  420,  423,  424,  422,  426,
	  425,  428,  429,  427,  431,  430,  433,  434,  435,  432,  434,  436,
	    0
	};
}

private static final short _hpricot_scan_indicies[] = init__hpricot_scan_indicies_0();


private static short[] init__hpricot_scan_trans_targs_wi_0()
{
	return new short [] {
	  204,    1,    2,   53,  204,    3,    4,    5,    6,    7,    8,    9,
	   10,   11,   10,  204,   26,   11,  204,   12,   48,   26,   13,   14,
	   15,   16,   17,   18,   19,   30,   20,   21,   20,   21,   22,   23,
	   28,   24,   25,  204,   24,   25,   25,   27,   29,   29,   31,   32,
	   31,   32,   33,   34,   35,   36,   47,   32,  206,   40,   35,   36,
	   47,   37,   34,  206,   40,   46,   38,   39,   43,   38,   39,   43,
	   39,   41,   42,   41,  207,   43,  208,   44,   45,   39,   32,   49,
	   50,   51,   52,   21,   54,   55,   56,   57,   58,  204,   60,   61,
	   60,  204,   61,  204,   63,   62,   66,  204,   63,   64,   66,  204,
	   65,   64,   66,   67,  204,   65,   64,   66,   67,  204,  204,   68,
	  144,   74,  142,  143,   73,   68,   69,   70,   73,  204,   69,   71,
	   73,  204,   65,   72,   71,   73,   74,  204,   65,   72,   74,   75,
	   76,   77,  141,   73,   75,   76,   71,   73,   78,   79,   90,   70,
	   93,   80,  209,   94,   78,   79,   90,   70,   93,   80,  209,   94,
	   79,   69,   82,   84,  209,   81,   79,   83,   82,   84,   85,  209,
	   83,   85,  209,   86,   95,  139,  140,   93,   87,   88,   91,   87,
	   88,   89,   96,   93,  209,  209,   91,   93,   83,   92,   91,   93,
	   95,  209,   83,   92,   95,   90,   97,   98,  117,  108,   90,  128,
	   99,  211,  129,   97,   98,  117,  108,  128,   99,  211,  129,   98,
	  100,  120,  121,  211,  122,  101,  100,  103,  105,  210,  102,  104,
	  103,  105,  106,  210,  104,  106,  210,  107,  138,  113,  136,  137,
	  111,  112,  107,  100,  108,  111,  210,  112,  109,  111,  210,  104,
	  110,  109,  111,  113,  210,  104,  110,  113,  114,  115,  116,  135,
	  111,  114,  115,  109,  111,  108,  118,  128,  211,  119,  134,  118,
	  128,  133,  211,  119,  123,  119,  120,  121,  123,  211,  211,   98,
	  124,  133,  131,  132,  128,  125,  126,  118,  125,  126,  127,  130,
	  128,  211,  117,   98,  100,   79,  120,  121,  211,  122,  100,  119,
	  134,  133,  100,  108,  101,  210,  100,   69,  103,  105,  210,  102,
	   79,   82,   84,  209,   81,  210,  146,  147,  212,  146,  148,  149,
	  213,  204,  151,  152,  153,  154,  155,  156,  157,  158,  200,  159,
	  160,  159,  161,  204,  162,  163,  176,  164,  165,  166,  167,  168,
	  169,  170,  171,  172,  198,  173,  174,  173,  175,  177,  178,  179,
	  180,  181,  182,  183,  184,  185,  186,  187,  193,  188,  191,  189,
	  190,  190,  192,  194,  196,  195,  197,  199,  199,  201,  201,  214,
	  214,  216,  216,  204,  204,  205,  204,    0,   59,   62,  145,  204,
	  204,  150,  214,  214,  215,  214,  202,  216,  216,  217,  216,  203,
	  218,  218,  218,  219,  218
	};
}

private static final short _hpricot_scan_trans_targs_wi[] = init__hpricot_scan_trans_targs_wi_0();


private static short[] init__hpricot_scan_trans_actions_wi_0()
{
	return new short [] {
	   73,    0,    0,    0,   59,    0,    0,    0,    0,    0,    0,    0,
	    1,    5,    0,   92,    5,    0,   51,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    3,   83,    0,   19,    0,    0,
	    0,    3,   86,   75,    0,   21,    0,    0,    3,    0,    3,   83,
	    0,   19,    0,   19,    3,    3,    3,  172,  188,    3,    0,    0,
	    0,    0,  113,  146,    0,   21,    3,   86,   86,    0,   21,   21,
	    0,   21,    0,    0,  146,    0,  146,    0,    0,    3,  113,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,   61,    1,    5,
	    0,   98,    0,   55,    5,    0,    5,   95,    0,  116,    0,   53,
	   11,    0,  110,   11,  168,    0,  180,   23,    0,  122,   57,    3,
	    3,    3,    0,    0,   89,    0,    9,    9,  104,  164,    0,  180,
	  119,  176,  107,  107,    0,  160,   11,  201,    9,    9,    0,   80,
	   80,    0,    0,  152,    3,    3,  196,  156,    3,   80,   80,   77,
	  152,    3,  226,    3,    0,    9,    9,    7,  104,    0,  211,    0,
	    0,    7,  180,   23,  192,    0,    7,   11,    0,  110,   11,  216,
	    0,    0,  149,    3,    3,    7,    0,   89,    3,    3,  196,   80,
	   80,    7,    0,  156,  221,  232,  180,  119,  107,  107,    0,  160,
	   11,  238,    9,    9,    0,    7,    3,   80,   80,  101,   77,  152,
	    3,  226,    3,    0,    9,    9,    7,  104,    0,  211,    0,    0,
	    7,  180,   23,  192,    0,    0,    0,  180,   23,  192,    0,   11,
	    0,  110,   11,  216,    0,    0,  149,    3,    3,    3,    0,    7,
	   89,    3,    0,    9,    9,  104,  211,    0,  180,  119,  221,  107,
	  107,    0,  160,   11,  238,    9,    9,    0,   80,   80,    0,    7,
	  152,    3,    3,  196,  156,   77,  180,  119,  221,  107,  107,    0,
	  160,   11,  238,    0,    0,   11,    0,  110,   11,  216,  149,    7,
	    3,    3,    7,    7,   89,    3,    3,  196,   80,   80,    7,    7,
	  156,  232,    7,    3,   77,   77,  196,   89,  206,    3,  101,    9,
	    9,    0,   80,   80,    3,  232,    3,   77,  196,   89,  206,    3,
	    3,  196,   89,  206,    3,  226,   25,   25,    0,    0,    0,    0,
	   31,   71,    0,    0,    0,    0,    0,    0,    0,    0,    0,    3,
	   13,    0,    0,   49,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    3,   15,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    3,    3,    0,
	   17,    0,    0,    3,    3,    0,    0,    3,    0,    3,    0,   37,
	  137,   43,  140,   63,  134,  184,   69,    0,    0,    1,    0,   65,
	   67,    0,   33,  125,   31,   35,    0,   39,  128,   31,   41,    0,
	   45,  131,  143,    0,   47
	};
}

private static final short _hpricot_scan_trans_actions_wi[] = init__hpricot_scan_trans_actions_wi_0();


private static short[] init__hpricot_scan_to_state_actions_0()
{
	return new short [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	   27,    0,    0,    0,    0,    0,    0,    0,    0,    0,   27,    0,
	   27,    0,   27,    0
	};
}

private static final short _hpricot_scan_to_state_actions[] = init__hpricot_scan_to_state_actions_0();


private static short[] init__hpricot_scan_from_state_actions_0()
{
	return new short [] {
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
	   29,    0,    0,    0,    0,    0,    0,    0,    0,    0,   29,    0,
	   29,    0,   29,    0
	};
}

private static final short _hpricot_scan_from_state_actions[] = init__hpricot_scan_from_state_actions_0();


private static short[] init__hpricot_scan_eof_trans_0()
{
	return new short [] {
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	   40,   40,   40,   40,    1,   40,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
	    1,    1,    1,    1,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,   40,
	   40,    1,    1,    1,    1,    1,  350,  350,  350,  350,  350,  350,
	  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,
	  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,
	  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,
	  350,  350,  350,  350,  350,  350,  350,  350,  350,  350,  408,  410,
	    0,  415,  420,  420,  420,   40,   40,   40,  421,  421,    0,  426,
	    0,  431,    0,  437
	};
}

private static final short _hpricot_scan_eof_trans[] = init__hpricot_scan_eof_trans_0();


static final int hpricot_scan_start = 204;
static final int hpricot_scan_error = -1;

static final int hpricot_scan_en_html_comment = 214;
static final int hpricot_scan_en_html_cdata = 216;
static final int hpricot_scan_en_html_procins = 218;
static final int hpricot_scan_en_main = 204;

// line 564 "hpricot_scan.java.rl"

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

// line 1227 "HpricotScanService.java"
	{
	cs = hpricot_scan_start;
	ts = -1;
	te = -1;
	act = 0;
	}
// line 667 "hpricot_scan.java.rl"
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

                
// line 1282 "HpricotScanService.java"
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
case 1:
	_acts = _hpricot_scan_from_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 21:
// line 1 "hpricot_scan.java.rl"
	{ts = p;}
	break;
// line 1307 "HpricotScanService.java"
		}
	}

	_match: do {
	_keys = _hpricot_scan_key_offsets[cs];
	_trans = _hpricot_scan_index_offsets[cs];
	_klen = _hpricot_scan_single_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + _klen - 1;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + ((_upper-_lower) >> 1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 1;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid] )
				_lower = _mid + 1;
			else {
				_trans += (_mid - _keys);
				break _match;
			}
		}
		_keys += _klen;
		_trans += _klen;
	}

	_klen = _hpricot_scan_range_lengths[cs];
	if ( _klen > 0 ) {
		int _lower = _keys;
		int _mid;
		int _upper = _keys + (_klen<<1) - 2;
		while (true) {
			if ( _upper < _lower )
				break;

			_mid = _lower + (((_upper-_lower) >> 1) & ~1);
			if ( data[p] < _hpricot_scan_trans_keys[_mid] )
				_upper = _mid - 2;
			else if ( data[p] > _hpricot_scan_trans_keys[_mid+1] )
				_lower = _mid + 2;
			else {
				_trans += ((_mid - _keys)>>1);
				break _match;
			}
		}
		_trans += _klen;
	}
	} while (false);

	_trans = _hpricot_scan_indicies[_trans];
case 3:
	cs = _hpricot_scan_trans_targs_wi[_trans];

	if ( _hpricot_scan_trans_actions_wi[_trans] != 0 ) {
		_acts = _hpricot_scan_trans_actions_wi[_trans];
		_nacts = (int) _hpricot_scan_actions[_acts++];
		while ( _nacts-- > 0 )
	{
			switch ( _hpricot_scan_actions[_acts++] )
			{
	case 0:
// line 514 "hpricot_scan.java.rl"
	{
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
	break;
	case 1:
// line 526 "hpricot_scan.java.rl"
	{ mark_tag = p; }
	break;
	case 2:
// line 527 "hpricot_scan.java.rl"
	{ mark_aval = p; }
	break;
	case 3:
// line 528 "hpricot_scan.java.rl"
	{ mark_akey = p; }
	break;
	case 4:
// line 529 "hpricot_scan.java.rl"
	{ tag = SET(mark_tag, p, tag); }
	break;
	case 5:
// line 531 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); }
	break;
	case 6:
// line 532 "hpricot_scan.java.rl"
	{
      if(data[p-1] == '"' || data[p-1] == '\'') {
          aval = SET(mark_aval, p-1, aval);
      } else {
          aval = SET(mark_aval, p, aval);
      }
  }
	break;
	case 7:
// line 539 "hpricot_scan.java.rl"
	{   akey = SET(mark_akey, p, akey); }
	break;
	case 8:
// line 540 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("version"), aval); }
	break;
	case 9:
// line 541 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("encoding"), aval); }
	break;
	case 10:
// line 542 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("standalone"), aval); }
	break;
	case 11:
// line 543 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("public_id"), aval); }
	break;
	case 12:
// line 544 "hpricot_scan.java.rl"
	{ aval = SET(mark_aval, p, aval); ATTR(runtime.newSymbol("system_id"), aval); }
	break;
	case 13:
// line 546 "hpricot_scan.java.rl"
	{
      akey = runtime.getNil();
      aval = runtime.getNil();
      mark_akey = -1;
      mark_aval = -1;
  }
	break;
	case 14:
// line 553 "hpricot_scan.java.rl"
	{
      if(!S.xml) {
          akey = akey.callMethod(runtime.getCurrentContext(), "downcase");
      }
      ATTR(akey, aval);
  }
	break;
	case 15:
// line 9 "hpricot_scan.java.rl"
	{curline += 1;}
	break;
	case 16:
// line 46 "hpricot_scan.java.rl"
	{ TEXT_PASS(); }
	break;
	case 17:
// line 50 "hpricot_scan.java.rl"
	{ EBLK(comment, 3); {cs = 204; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 18:
// line 55 "hpricot_scan.java.rl"
	{ EBLK(cdata, 3); {cs = 204; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 19:
// line 60 "hpricot_scan.java.rl"
	{ EBLK(procins, 2); {cs = 204; _goto_targ = 2; if (true) continue _goto;} }
	break;
	case 22:
// line 1 "hpricot_scan.java.rl"
	{te = p+1;}
	break;
	case 23:
// line 50 "hpricot_scan.java.rl"
	{te = p+1;}
	break;
	case 24:
// line 51 "hpricot_scan.java.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 25:
// line 51 "hpricot_scan.java.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 26:
// line 51 "hpricot_scan.java.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 27:
// line 55 "hpricot_scan.java.rl"
	{te = p+1;}
	break;
	case 28:
// line 56 "hpricot_scan.java.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 29:
// line 56 "hpricot_scan.java.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 30:
// line 56 "hpricot_scan.java.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 31:
// line 60 "hpricot_scan.java.rl"
	{te = p+1;}
	break;
	case 32:
// line 61 "hpricot_scan.java.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 33:
// line 61 "hpricot_scan.java.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 34:
// line 66 "hpricot_scan.java.rl"
	{act = 8;}
	break;
	case 35:
// line 68 "hpricot_scan.java.rl"
	{act = 10;}
	break;
	case 36:
// line 70 "hpricot_scan.java.rl"
	{act = 12;}
	break;
	case 37:
// line 73 "hpricot_scan.java.rl"
	{act = 15;}
	break;
	case 38:
// line 65 "hpricot_scan.java.rl"
	{te = p+1;{ ELE(xmldecl); }}
	break;
	case 39:
// line 66 "hpricot_scan.java.rl"
	{te = p+1;{ ELE(doctype); }}
	break;
	case 40:
// line 68 "hpricot_scan.java.rl"
	{te = p+1;{ ELE(stag); }}
	break;
	case 41:
// line 69 "hpricot_scan.java.rl"
	{te = p+1;{ ELE(etag); }}
	break;
	case 42:
// line 70 "hpricot_scan.java.rl"
	{te = p+1;{ ELE(emptytag); }}
	break;
	case 43:
// line 71 "hpricot_scan.java.rl"
	{te = p+1;{ {cs = 214; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 44:
// line 72 "hpricot_scan.java.rl"
	{te = p+1;{ {cs = 216; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 45:
// line 73 "hpricot_scan.java.rl"
	{te = p+1;{ TEXT_PASS(); }}
	break;
	case 46:
// line 66 "hpricot_scan.java.rl"
	{te = p;p--;{ ELE(doctype); }}
	break;
	case 47:
// line 67 "hpricot_scan.java.rl"
	{te = p;p--;{ {cs = 218; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 48:
// line 73 "hpricot_scan.java.rl"
	{te = p;p--;{ TEXT_PASS(); }}
	break;
	case 49:
// line 67 "hpricot_scan.java.rl"
	{{p = ((te))-1;}{ {cs = 218; _goto_targ = 2; if (true) continue _goto;} }}
	break;
	case 50:
// line 73 "hpricot_scan.java.rl"
	{{p = ((te))-1;}{ TEXT_PASS(); }}
	break;
	case 51:
// line 1 "hpricot_scan.java.rl"
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
	break;
// line 1612 "HpricotScanService.java"
			}
		}
	}

case 2:
	_acts = _hpricot_scan_to_state_actions[cs];
	_nacts = (int) _hpricot_scan_actions[_acts++];
	while ( _nacts-- > 0 ) {
		switch ( _hpricot_scan_actions[_acts++] ) {
	case 20:
// line 1 "hpricot_scan.java.rl"
	{ts = -1;}
	break;
// line 1626 "HpricotScanService.java"
		}
	}

	if ( ++p != pe ) {
		_goto_targ = 1;
		continue _goto;
	}
case 4:
	if ( p == eof )
	{
	if ( _hpricot_scan_eof_trans[cs] > 0 ) {
		_trans = _hpricot_scan_eof_trans[cs] - 1;
		_goto_targ = 3;
		continue _goto;
	}
	}

case 5:
	}
	break; }
	}
// line 714 "hpricot_scan.java.rl"

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
