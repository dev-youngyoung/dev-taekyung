var __nimservice = function (m) {
    function r() {
        return {
            x: (window.innerWidth ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width) / 2 + (void 0 !== window.screenLeft ? window.screenLeft : window.screenX),
            y: (window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height) / 2 + (void 0 !== window.screenTop ? window.screenTop : window.screenY) - 170
        }
    }

    function ca(a, b, c) {
        a = JSON.parse(a);
        var d = {};
        d.messageNumber = b;
        d.operation = a.operation;
        d.certIdentifier = a.certIdentifier ? a.certIdentifier : "";
        d.callback = c;
        d.valid = !0;
        10 <= G && (G = 0);
        x[G] = d;
        G += 1;
        f += 1
    }

    function s(a, b, c) {
        ca(a, b, c);
        try {
            var d = document.getElementById("hsmiframe");
            if ("undefined" === typeof window.postMessage) {
                var e = window.crosscert.util || {};
                b = B + "/TIC";
                var d = B + "/VestCert/MangoFS.jsp", g = document.getElementById("IFR_SERVER"),
                    h = document.getElementById("FRM_SENDER"), f = document.getElementById("message"),
                    l = document.getElementById("returnURL");
                null != g && g.parentNode.removeChild(g);
                null != h && h.parentNode.removeChild(h);
                -1 != navigator.userAgent.indexOf("MSIE 7.0") ? (g = document.createElement('<iframe id="IFR_SERVER" name="IFR_SERVER" src="' + b + '" />'), g.style.display = "none", document.body.appendChild(g), h = document.createElement('<form id="FRM_SENDER" action="' + d + '" method="post" target="IFR_SERVER" > </form>')) : (g = document.createElement("iframe"), g.setAttribute("id", "IFR_SERVER"), g.setAttribute("name", "IFR_SERVER"), g.setAttribute("src", b), g.style.display = "none", document.body.appendChild(g), h = document.createElement("form"), h.setAttribute("id", "FRM_SENDER"), h.setAttribute("action", d), h.setAttribute("method", "post"), h.setAttribute("target", "IFR_SERVER"));
                h.style.display = "none";
                document.body.appendChild(h);
                f = document.createElement("input");
                f.setAttribute("id", "message");
                f.setAttribute("name", "message");
                f.value = e.bytesToHex(e.encodeUtf8(a));
                h.appendChild(f);
                l = document.createElement("input");
                l.setAttribute("id", "fsreturnURL");
                l.setAttribute("name", "returnURL");
                h.appendChild(l);
                l.value = e.bytesToHex(e.encodeUtf8(location.href));
                try {
                    L(g, "onload", function (a) {
                        a = document.getElementById("IFR_SERVER");
                        var b, d = {};
                        try {
                            b = a.contentWindow.name
                        } catch (c) {
                            throw c;
                        }
                        try {
                            d.data = e.decodeUtf8(e.decode64(b)), d.origin = B
                        } catch (g) {
                            return
                        }
                        P(d)
                    })
                } catch (k) {
                    alert(k.message)
                }
                h.submit()
            } else d.contentWindow.postMessage(a, B)
        } catch (n) {
            null != c && c(-1)
        }
    }

    function L(a, b, c) {
        null == a && (a = window);
        null == c && (c = P);
        if (0 < M) {
            var d = a, e = b, g = c;
            null == d && (d = window);
            M--;
            "function" === typeof d.addEventListener ? (null == e && (e = "message"), d.removeEventListener(e, g, !1)) : (null == e && (e = "onmessage"), d.detachEvent(e, g))
        }
        "function" === typeof a.addEventListener ? (null == b && (b = "message"), a.addEventListener(b, c, !1)) : (null == b && (b = "onmessage"), a.attachEvent(b, c));
        M++
    }

    function w(a, b) {
        for (var c = v.length, d = 0; d < c; d++) {
            var e = v[d];
            if (e.device == a && e.drive == b) return "" + e.tokenIdentifier
        }
        return ""
    }

    function da(a, b, c, d, e) {
        var g = w(p, u);
        null == g || 0 >= g.length ? e(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[4],
            tokenIdentifier: g,
            CAType: "crosscert",
            referenceNumber: c,
            authenticationCode: d,
            options: {center: r(), CAServiceIP: a, CAServicePort: b},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(a), f, e))
    }

    function Q(a, b, c, d, e, g, h) {
        var y = w(p, u);
        if (null == y || 0 >= y.length) h(-1); else {
            var l = "", n = "";
            p != z.device && d && (l = d.certIdentifier, n = d.keyIdentifier);
            d = "";
            d = 0 < e.length || 0 < g.length ? {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[6],
                tokenIdentifier: y,
                CAType: "crosscert",
                oldcertIdentifier: l,
                oldKeyIdentifier: n,
                newpin: e,
                oldpin: g,
                options: {center: r(), CAServiceIP: b, CAServicePort: c, reIssue: a},
                SecKeyVendor: m.bsUtil().GetKeyboardType()
            } : {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[6],
                tokenIdentifier: y,
                CAType: "crosscert",
                oldcertIdentifier: l,
                oldKeyIdentifier: n,
                options: {center: r(), CAServiceIP: b, CAServicePort: c, reIssue: a},
                SecKeyVendor: m.bsUtil().GetKeyboardType()
            };
            s(JSON.stringify(d), f, h)
        }
    }

    function ea(a, b) {
        var c = w(p, u);
        null == c || 0 >= c.length ? b(-1) : (c = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[5],
            tokenIdentifier: c,
            certIdentifier: a.certIdentifier,
            KeyIdentifier: a.keyIdentifier,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(c), f, b))
    }

    function fa(a, b, c, d, e) {
        var g = w(p, u);
        if (null == g || 0 >= g.length) e(-1); else {
            var h = "", y = "";
            p != z.device && d && (h = d.certIdentifier, y = d.keyIdentifier);
            a = {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[7],
                tokenIdentifier: g,
                CAType: "crosscert",
                certIdentifier: h,
                keyIdentifier: y,
                options: {center: r(), CAServiceIP: a, CAServicePort: b, reason: c}
            };
            s(JSON.stringify(a), f, e)
        }
    }

    function R(a, b) {
        v.length = 0;
        var c = {messageNumber: f, sessionID: "" + k, operation: this.operation[0], options: {center: r()}, reload: a};
        s(JSON.stringify(c), f, b)
    }

    function S(a) {
        var b = {messageNumber: f, sessionID: "" + k, operation: this.operation[8], options: {center: r()}};
        s(JSON.stringify(b), f, a)
    }

    function T(a) {
        t.length = 0;
        var b = w(p, u);
        if (null == b || 0 >= b.length) m.uiUtil().loadingBox(!1, "us-div-list-load"), a(-1); else {
            var c = null;
            null != D ? (D = D.replace(/\|/gi, ";"), c = {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[1],
                tokenIdentifier: b,
                filter: {mode: "", OID: D},
                options: {center: r(), pkitype: U()}
            }) : c = {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[1],
                tokenIdentifier: b,
                options: {center: r(), pkitype: U()}
            };
            D = null;
            s(JSON.stringify(c), f, a)
        }
    }

    function U() {
        var a = 0;
        -1 < m.ESVS.PKI.indexOf("NPKI") && (a = 1);
        -1 < m.ESVS.PKI.indexOf("GPKIC2") && (a += 16);
        -1 < m.ESVS.PKI.indexOf("GPKIC1") && (a += 256);
        return a
    }

    function N(a, b) {
        var c = w(p, u);
        null == c || 0 >= c.length || void 0 == a || null == a ? b(-1) : "" == a.certIdentifier ? b(-1) : (c = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[2],
            tokenIdentifier: c,
            certIdentifier: a.certIdentifier,
            options: {center: r()}
        }, s(JSON.stringify(c), f, b))
    }

    function ga(a, b, c, d, e, g) {
        var h = w(p, u);
        if (null == h || 0 >= h.length) g(-1); else {
            var y = "2";
            !1 == d && (y = "4");
            var l = d = "";
            p != z.device && a && (d = a.certIdentifier, l = a.keyIdentifier);
            a = null != e ? {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: h,
                pin: b,
                certIdentifier: d,
                keyIdentifier: l,
                plain: c[0],
                outputfile: c[2],
                options: {
                    center: r(),
                    vid: {recipientCertificate: e, type: "1"},
                    signInputType: "2",
                    signOutputType: c[1] + "",
                    signtype: y,
                    encoding: "0"
                }
            } : {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: h,
                pin: b,
                certIdentifier: d,
                keyIdentifier: l,
                plain: c[0],
                outputfile: c[2],
                options: {center: r(), signInputType: "2", signOutputType: c[1] + "", signtype: y, encoding: "0"}
            };
            s(JSON.stringify(a), f, g)
        }
    }

    function V(a, b, c, d, e, g, h) {
        var l = w(p, u);
        if (null == l || 0 >= l.length) h(-1); else {
            var n = "2";
            !1 == e && (n = "4");
            var m = e = "";
            p != z.device && a && (e = a.certIdentifier, m = a.keyIdentifier);
            a = null != g ? {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: l,
                pin: b,
                certIdentifier: e,
                keyIdentifier: m,
                plain: d,
                options: {
                    center: r(),
                    vid: {recipientCertificate: g, type: "1"},
                    signInputType: c + "",
                    signtype: n,
                    encoding: "0"
                }
            } : {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: l,
                pin: b,
                certIdentifier: e,
                keyIdentifier: m,
                plain: d,
                options: {center: r(), signInputType: c + "", signtype: n, encoding: "0"}
            };
            s(JSON.stringify(a), f, h)
        }
    }

    function ha(a, b, c, d, e) {
        var g = w(p, u);
        if (null == g || 0 >= g.length) e(-1); else {
            var h = "";
            p != z.device && a && (h = a.keyIdentifier);
            a = null != d ? {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: g,
                pin: b,
                keyIdentifier: h,
                plain: c,
                options: {center: r(), vid: {recipientCertificate: d, type: "1"}, signtype: "0", encoding: "0"}
            } : {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[3],
                tokenIdentifier: g,
                pin: b,
                keyIdentifier: h,
                plain: c,
                options: {center: r(), signtype: "0", encoding: "0"}
            };
            s(JSON.stringify(a), f, e)
        }
    }

    function ia(a, b, c, d, e) {
        var g = w(p, u);
        null == g || 0 >= g.length ? e(-1) : (a = w(a, b), null == a || 0 >= a.length ? e(-1) : (c = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[9],
            tokenIdentifier: g,
            newTokenIdentifier: a,
            certIdentifier: c.certIdentifier,
            keyIdentifier: c.keyIdentifier,
            deleteCert: null == d || !1 == d ? "0" : "1",
            checkCert: 1,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(c), f, e)))
    }

    function ja(a, b) {
        var c = w(p, u);
        if (null == c || 0 >= c.length) b(-1); else {
            var d = "";
            p != z.device && a && (d = a.certIdentifier);
            c = {
                messageNumber: f,
                sessionID: "" + k,
                manager: "Manager",
                operation: this.operation[10],
                tokenIdentifier: c,
                certIdentifier: d,
                mode: "",
                options: {center: r()}
            };
            s(JSON.stringify(c), f, b)
        }
    }

    function ka(a, b, c, d) {
        var e = w(p, u);
        null == e || 0 >= e.length ? d(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[11],
            tokenIdentifier: e,
            certIdentifier: a.certIdentifier,
            keyIdentifier: a.keyIdentifier,
            reusePin: b,
            returnType: c,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(a), f, d))
    }

    function la(a, b, c) {
        var d = w(p, u);
        null == d || 0 >= d.length ? c(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[25],
            tokenIdentifier: d,
            certIdentifier: a.certIdentifier,
            keyIdentifier: a.keyIdentifier,
            kmCertIdentifier: a.kmcertIdentifier,
            kmKeyIdentifier: a.kmkeyIdentifier,
            reusePin: 0,
            pin: b,
            returnType: "text",
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(a), f, c))
    }

    function ma(a) {
        var b = w(p, u);
        null == b || 0 >= b.length ? a(-1) : (b = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[12],
            tokenIdentifier: b,
            checkCert: 1,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(b), f, a))
    }

    function na(a, b, c, d, e, g, h) {
        var l = w(p, u);
        null == l || 0 >= l.length ? h(-1) : (a = e && 0 < e.length ? {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[24],
            tokenIdentifier: l,
            pin: b,
            tokenPin: a,
            cert: c,
            pri: d,
            kmCert: e,
            kmPri: g,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        } : {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[24],
            tokenIdentifier: l,
            pin: b,
            tokenPin: a,
            cert: c,
            pri: d,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(a), f, h))
    }

    function oa(a, b) {
        var c = w(p, u);
        null == c || 0 >= c.length ? b(-1) : (c = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Manager",
            operation: this.operation[13],
            tokenIdentifier: c,
            certIdentifier: a.certIdentifier,
            keyIdentifier: a.keyIdentifier,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(c), f, b))
    }

    function pa(a, b) {
        var c = eval(a.list);
        if ("ok" != a.resultMessage) return l = a.resultCode, n = a.resultMessage, b(a.resultCode, 0), !1;
        for (var d = 1, e = 1, g = 1, h = c.length, f = 0; f < h; f++) {
            var k = c[f], m = {};
            m.tokenIdentifier = k.tokenIdentifier;
            m.name = k.name;
            m.type = k.type;
            m.device = k.type == W.name ? !0 == k.systemDrive ? W.device : O.device : k.type == H.name ? H.device : k.type == I.name ? I.device : k.type == J.name ? J.device : k.type == z.name ? z.device : k.type == K.name ? K.device : 0;
            m.drive = 0;
            m.device == O.device ? (m.drive = g, g += 1) : m.device == J.device ? (m.drive = e, e += 1) : m.device == I.device ? (m.drive = d, d += 1, m.trusted = k.trusted) : m.drive = 0;
            v[f] = m
        }
        b(a.resultCode, h)
    }

    function qa(a) {
        for (var b = t.length, c = 0; c < b; c++) if (t[c].subject == a) return !0;
        return !1
    }

    function ra(a, b) {
        if ("ok" != a.resultMessage) return l = a.resultCode, n = a.resultMessage, b(l, 0), !1;
        for (var c = 0, d = eval(a.list), e = d.length, g = 0; g < e; g++) {
            var h = d[g], f = {};
            f.subject = h.subject;
            f.issuer = h.issuer;
            f.serial = h.serial;
            f.validFrom = h.validFrom;
            f.validTo = h.validTo;
            f.certIdentifier = h.certIdentifier;
            f.keyIdentifier = h.keyIdentifier;
            f.kmcertIdentifier = h.kmCertIdentifier;
            f.kmkeyIdentifier = h.kmKeyIdentifier;
            var k = {};
            k.id = h.policy.id;
            k.userNotice = h.policy.userNotice;
            f.policy = k;
            f.cert = "";
            "KECA" == m.certUtil().getO(h.subject) ? !1 == qa(h.subject) && (t[c++] = f) : t[c++] = f
        }
        b(a.resultCode, t.length)
    }

    function X(a, b) {
        if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
        b(a.resultCode, a.resultMessage)
    }

    function Y(a, b, c, d) {
        a = null == b ? {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[14],
            tokenIdentifier: "0",
            signature: c,
            options: {center: r(), signtype: "2"}
        } : {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[14],
            tokenIdentifier: "0",
            signature: c,
            params: {plainType: a, plain: b},
            options: {center: r(), signtype: "4"}
        };
        s(JSON.stringify(a), f, d)
    }

    function sa(a, b, c, d) {
        a = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[14],
            tokenIdentifier: "0",
            signature: b,
            params: {plain: a, type: 0, certOrKey: c},
            options: {center: r(), signtype: "0"}
        };
        s(JSON.stringify(a), f, d)
    }

    function ta(a, b, c, d, e, g) {
        a = null == a ? {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[14],
            tokenIdentifier: "0",
            signature: c,
            outputfile: e,
            options: {center: r(), signtype: "2", signInputType: b + "", signOutputType: d + ""}
        } : {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[14],
            tokenIdentifier: "0",
            signature: c,
            outputfile: e,
            params: {plainInputType: 2, plain: a},
            options: {center: r(), signtype: "4", signInputType: b + "", signOutputType: d + ""}
        };
        s(JSON.stringify(a), f, g)
    }

    function ua(a, b, c, d) {
        var e = w(p, u);
        if (null == e || 0 >= e.length) d(-1); else {
            var g = "", h = g = "";
            p != z.device && a && (g = a.certIdentifier, h = a.keyIdentifier);
            g = null == b ? {
                messageNumber: f,
                sessionID: "" + k,
                manager: "Manager",
                operation: this.operation[15],
                tokenIdentifier: e,
                certIdentifier: g,
                keyIdentifier: h,
                options: {center: r()},
                idn: c
            } : {
                messageNumber: f,
                sessionID: "" + k,
                manager: "Manager",
                operation: this.operation[15],
                tokenIdentifier: e,
                pin: b,
                certIdentifier: g,
                keyIdentifier: h,
                options: {center: r()},
                idn: c
            };
            s(JSON.stringify(g), f, d)
        }
    }

    function Z(a, b, c, d, e) {
        var g = w(H.device, 0);
        null == g || 0 >= g.length ? e(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[16],
            tokenIdentifier: g,
            options: {center: r(), wParam: b, lParam: c, version: a, url: d}
        }, s(JSON.stringify(a), f, e))
    }

    function va(a, b, c, d, e, g) {
        var h = w(z.device, 0);
        null == h || 0 >= h.length ? g(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[16],
            tokenIdentifier: h,
            options: {
                center: r(),
                tokenorder: "Mobile_SmartCert",
                sitecode: a,
                modcode: b,
                siteURL: c,
                serviceIP: d,
                servicePort: e
            }
        }, s(JSON.stringify(a), f, g))
    }

    function wa(a, b) {
        var c = w(p, u);
        null == c || 0 >= c.length ? b(-1) : (c = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[17],
            tokenIdentifier: c,
            certIdentifier: a.certIdentifier,
            options: {center: r()}
        }, s(JSON.stringify(c), f, b))
    }

    function xa(a, b, c, d) {
        var e = 0;
        "sha256" == c.toLowerCase() && (e = 1);
        a = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Cipher",
            operation: this.operation[18],
            tokenIdentifier: 0,
            plainType: a,
            plain: b,
            mode: e,
            options: {center: r()}
        };
        s(JSON.stringify(a), f, d)
    }

    function ya(a, b, c, d, e, g, h) {
        a = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Cipher",
            tokenIdentifier: 0,
            operation: this.operation[19],
            plain: d,
            args: {algorithm: a, mode: 0, padding: 0},
            keys: {key: c, iv: b},
            options: {center: r(), fromCharset: e, toCharset: g}
        };
        s(JSON.stringify(a), f, h)
    }

    function za(a, b, c, d, e, g, h) {
        a = {
            messageNumber: f,
            sessionID: "" + k,
            manager: "Cipher",
            operation: this.operation[20],
            encMsg: d,
            args: {algorithm: a, mode: 0, padding: 0},
            keys: {key: c, iv: b},
            options: {center: r(), fromCharset: e, toCharset: g}
        };
        s(JSON.stringify(a), f, h)
    }

    function Aa(a, b, c, d) {
        var e = w(p, u);
        if (null == e || 0 >= e.length) d(-1); else {
            var g = b.certIdentifier;
            "kmcert" == a && (g = b.kmcertIdentifier);
            a = {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[21],
                tokenIdentifier: e,
                certIdentifier: g,
                plain: c,
                options: {center: r()}
            };
            s(JSON.stringify(a), f, d)
        }
    }

    function Ba(a, b, c, d, e) {
        var g = w(p, u);
        if (null == g || 0 >= g.length) e(-1); else {
            var h = b.keyIdentifier;
            "kmcert" == a && (h = b.kmkeyIdentifier);
            a = {
                messageNumber: f,
                sessionID: "" + k,
                operation: this.operation[22],
                tokenIdentifier: g,
                pin: c,
                keyIdentifier: h,
                envelopedMsg: d,
                options: {center: r()}
            };
            s(JSON.stringify(a), f, e)
        }
    }

    function Ca(a) {
        var b = w(p, u);
        null == b || 0 >= b.length ? a(-1) : s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[26],
            tokenIdentifier: b
        }), f, a)
    }

    function Da(a, b, c) {
        a = w(K.device, 0);
        null == a || 0 >= a.length ? c(-1) : (a = {
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[23],
            tokenIdentifier: a,
            options: {center: r()},
            SecKeyVendor: m.bsUtil().GetKeyboardType()
        }, s(JSON.stringify(a), f, c))
    }

    function Ea(a, b) {
        if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage, b(l, n); else {
            t.length = 0;
            p = K.device;
            u = 0;
            for (var c = eval(a.list), d = c.length, e = 0; e < d; e++) {
                var g = c[e], f = {};
                f.subject = g.subject;
                f.issuer = g.issuer;
                f.serial = g.serial;
                f.validFrom = g.validFrom;
                f.validTo = g.validTo;
                f.certIdentifier = g.certIdentifier;
                f.keyIdentifier = g.keyIdentifier;
                f.kmcertIdentifier = g.kmCertIdentifier;
                f.kmkeyIdentifier = g.kmKeyIdentifier;
                var k = {};
                k.id = g.policy.id;
                k.userNotice = g.policy.userNotice;
                f.policy = k;
                f.cert = "";
                t[e] = f
            }
            b(a.resultCode, a.resultMessage)
        }
    }

    function Fa(a, b) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[27],
            manager: "Manager",
            mode: a
        }), f, b)
    }

    function $(a, b, c) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[28],
            manager: "Manager",
            path: a,
            version: b
        }), f, c)
    }

    function Ga(a, b, c, d, e) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[29],
            manager: "Manager",
            apiName: {action: a, free: b, error: c},
            param: d
        }), f, e)
    }

    function aa(a) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[30],
            manager: "Manager"
        }), f, a)
    }

    function Ha(a, b, c) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[31],
            manager: "Manager",
            plain: a,
            options: {fromCharset: 1, toCharset: b}
        }), f, c)
    }

    function Ia(a) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[32],
            manager: "Manager"
        }), f, a)
    }

    function Ja(a, b) {
        s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[33],
            manager: "Manager",
            pins: a
        }), f, b)
    }

    function Ka(a, b, c, d) {
        var e = w(p, u);
        null == e || 0 >= e.length || void 0 == a || null == a ? d(-1) : s(JSON.stringify({
            messageNumber: f,
            sessionID: "" + k,
            operation: this.operation[34],
            pin: b,
            tokenIdentifier: e,
            keyIdentifier: a.keyIdentifier,
            type: c
        }), f, d)
    }

    function E(a) {
        return 1 * a.replace(/\./g, "")
    }

    function La(a) {
        var b = m.nimVersion.split(".");
        a = a.split(".");
        for (var c = Math.max(b.length, a.length), d = 0; d < c; d++) {
            if (b[d] && !a[d] && 0 < E(b[d]) || E(b[d]) > E(a[d])) return !0;
            if (a[d] && !b[d] && 0 < E(a[d]) || E(b[d]) < E(a[d])) break
        }
        return !1
    }

    function C(a) {
        var b = 0;
        switch (a) {
            case 0:
                for (b = 0; b < x.length; b++) if (x[b].operation == this.operation[0] || x[b].operation == this.operation[1] || x[b].operation == this.operation[2]) x[b].valid = !1;
                break;
            case 1:
                for (b = 0; b < x.length; b++) if (x[b].operation == this.operation[1] || x[b].operation == this.operation[2]) x[b].valid = !1;
                break;
            case 2:
                for (b = 0; b < x.length; b++) x[b].operation == this.operation[2] && (x[b].valid = !1)
        }
    }

    var f = 0, k = Math.random();
    this.operation = [];
    this.operation[0] = "GetTokenList";
    this.operation[1] = "GetCertificateList";
    this.operation[2] = "GetCertificate";
    this.operation[3] = "GenerateSignature";
    this.operation[4] = "IssueCertificate";
    this.operation[5] = "DeleteCertificate";
    this.operation[6] = "UpdateCertificate";
    this.operation[7] = "RevokeCertificate";
    this.operation[8] = "GetVersion";
    this.operation[9] = "ChangeStorage";
    this.operation[10] = "ValidateCertificate";
    this.operation[11] = "ExportCertificate";
    this.operation[12] = "ImportCertificate";
    this.operation[13] = "ChangePin";
    this.operation[14] = "VerifySignature";
    this.operation[15] = "VerifyVID";
    this.operation[16] = "SetTokenOptions";
    this.operation[17] = "GetCACertificate";
    this.operation[18] = "GetHash";
    this.operation[19] = "Encrypt";
    this.operation[20] = "Decrypt";
    this.operation[21] = "Envelope";
    this.operation[22] = "Deenvelope";
    this.operation[23] = "GetCertificateListWithP12";
    this.operation[24] = "ImportCertificateAndKey";
    this.operation[25] = "ExportCertificateAndKey";
    this.operation[26] = "GetTokenInfo";
    this.operation[27] = "GetMacAddress";
    this.operation[28] = "3rdPartyLib.initialize";
    this.operation[29] = "3rdPartyLib.action";
    this.operation[30] = "3rdPartyLib.finalize";
    this.operation[31] = "ConvertStringFormat";
    this.operation[32] = "GetE2EInfo";
    this.operation[33] = "CheckComplexPin";
    this.operation[34] = "EncryptVIDRandom";
    var A = !1, F = null, v = [], t = [], p = 0, u = 0, D = null, l = "", n = "", G = 0, x = [],
        B = "https://127.0.0.1:14461", O = {device: 1, name: "DISK DRIVE"}, I = {device: 2, name: "PKCS#11 TOKEN"},
        J = {device: 3, name: "SmartCard TOKEN"}, H = {device: 4, name: "Ubikey"}, W = {device: 5, name: "DISK DRIVE"},
        z = {device: 6, name: "Mobile USIM"}, K = {device: 9, name: "PKCS#12 TOKEN"}, M = 0, P = function (a) {
            if (a.origin == B && (A = !0, !(null == a.data || 0 >= a.data.length))) {
                var b = 0, c = "", d = null;
                a = JSON.parse(a.data);
                for (b = 0; b < x.length; b++) if (x[b].messageNumber == a.messageNumber) {
                    if (!1 == x[b].valid) {
                        x[b].callback(-1);
                        return
                    }
                    a.operation == this.operation[2] && (c = x[b].certIdentifier);
                    d = x[b].callback;
                    x[b] = 0;
                    break
                }
                if (a.operation == this.operation[0]) pa(a, d); else if (a.operation == this.operation[1]) ra(a, d); else if (a.operation == this.operation[2]) if (b = c, 0 != a.resultCode && "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage, d(l, ""); else {
                    for (var c = t.length, e = 0; e < c; e++) b == t[e].certIdentifier && (t[e].cert = a.certificate, a.path && (t[e].path = a.path.substr(0, a.path.lastIndexOf("\\"))));
                    a.path ? d(a.resultCode, a.certificate, a.path.substr(0, a.path.lastIndexOf("\\"))) : d(a.resultCode, a.certificate, "")
                } else if (a.operation == this.operation[3]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    var b = "", b = a.file ? a.file : a.signature, g = e = c = "";
                    void 0 != a.encryptedVIDRandom && (c = a.encryptedVIDRandom);
                    void 0 != a.usimCert && (e = a.usimCert);
                    void 0 != a.label && (g = a.label);
                    d(a.resultCode, a.resultMessage, b, c, e, g)
                } else if (a.operation == this.operation[4]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(l, n)) : d(0, "success"); else if (a.operation == this.operation[5]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[6]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[7]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[8]) F = a.list[0].version, a = F.split("."), F = a[0] + "." + a[1] + "." + a[2] + ".0", d(F); else if (a.operation == this.operation[9]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[10]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage, a.validCode, a.validMessage)
                } else if (a.operation == this.operation[11]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[12]) X(a, d); else if (a.operation == this.operation[13]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[14]) l = a.resultCode, n = a.resultMessage, b = "", b = a.file ? a.file : a.verifyResult, d(a.resultCode, b, a.certificate); else if (a.operation == this.operation[15]) l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage); else if (a.operation == this.operation[16]) l = a.resultCode, n = a.resultMessage, d(a.resultCode); else if (a.operation == this.operation[17]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(l)) : d(a.resultCode, a.caCertificate, a.rootCertificate); else if (a.operation == this.operation[18]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.hash)
                } else if (a.operation == this.operation[19]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.encResult)
                } else if (a.operation == this.operation[20]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.decResult)
                } else if (a.operation == this.operation[21]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage, a.envelopeResult)
                } else if (a.operation == this.operation[22]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage, a.deenvelopeResult)
                } else if (a.operation == this.operation[23]) Ea(a, d); else if (a.operation == this.operation[24]) X(a, d); else if (a.operation == this.operation[25]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    a.cert && a.pri ? d(a.resultCode, a.resultMessage, a.cert, a.pri, a.kmCert, a.kmPri) : d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[26]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage)) : d(a.resultCode, a.resultMessage, a.label); else if (a.operation == this.operation[27]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage)) : d(a.resultCode, a.resultMessage, a.mac); else if (a.operation == this.operation[28]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[29]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage)) : d(a.resultCode, a.resultMessage, a.output); else if (a.operation == this.operation[30]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[31]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage)) : d(a.resultCode, a.resultMessage, a.encResult); else if (a.operation == this.operation[32]) 0 != a.resultCode || "ok" != a.resultMessage ? (l = a.resultCode, n = a.resultMessage, d(a.resultCode, a.resultMessage)) : d(a.resultCode, a.resultMessage, a.publicKey); else if (a.operation == this.operation[33]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage)
                } else if (a.operation == this.operation[34]) {
                    if (0 != a.resultCode || "ok" != a.resultMessage) l = a.resultCode, n = a.resultMessage;
                    d(a.resultCode, a.resultMessage, a.encryptedVID)
                }
            }
        }, ba = function (a) {
            A = !1;
            var b = !0, c = function (d, c) {
                b && (b = !1, d && d.parentNode && d.parentNode.removeChild(d), c ? setTimeout(function () {
                    S(function (b) {
                        b = b.split(".");
                        b = b[0] + "." + b[1] + "." + b[2] + ".0";
                        La(b) ? (alert(m.uiUtil().getErrorMessageLang().IDS_ERROR_NIM_NOT_LASTEST_VERSION), null != parent ? parent.document.location = m.nimCheckUrl : document.location.href = m.nimCheckUrl) : (A = c, m.xmlNormalizer && m.xmlNormalizer.using && !1 == m.xmlNormalizer.installcheck ? $(m.xmlNormalizer.name, m.xmlNormalizer.version, function (b, d) {
                            m.xmlNormalizer.installcheck = !0;
                            aa(function (b, d) {
                                0 == b || "0" == b ? a(c) : null != parent ? parent.document.location = m.nimCheckUrl : document.location.href = m.nimCheckUrl
                            })
                        }) : a(c))
                    })
                }, 300) : (A = c, a(c)))
            }, d;
            -1 != navigator.userAgent.indexOf("MSIE 7.0") ? d = document.createElement("<img id='hsmImg' src='" + B + "/TIC?cd=" + Math.random() + "' onload='' onerror='fnResult(this, false)' />") : (d = document.createElement("img"), d.setAttribute("id", "hsmImg"), d.setAttribute("src", B + "/TIC?cd=" + Math.random()));
            d.onerror = function () {
                c(d, !1)
            };
            d.onload = function () {
                c(d, !0)
            };
            d.style.display = "none";
            document.body.appendChild(d);
            if (-1 != navigator.userAgent.indexOf("MSIE 8")) {
                var e = function () {
                    !1 == A ? setTimeout(e, 100) : c(null, !0)
                };
                setTimeout(e, 100)
            }
        };
    ba(function (a) {
        (A = a) ? (a = document.getElementById("hsmiframe"), null != a && (a.onload = function () {
            L()
        })) :
            (typeof chkVestcertInstall== "function"?chkVestcertInstall():confirm(m.uiUtil().getErrorMessageLang().IDS_ERROR_NIM_NOT_INSTALL_CFM))
            && (null != parent ? parent.document.location = m.nimCheckUrl : document.location = m.nimCheckUrl)
    });
    L();
    var q = function (a, b) {
        -1 != b && m.uiUtil().loadingBox(!0, "us-div-list-load", b);
        ba(function (b) {
            b ? a() : (document.location = "mangowire:///", setTimeout(a, 1500))
        })
    };
    return {
        Version: function (a) {
            q(function () {
                null == F ? S(a) : a(F)
            })
        }, GetLastErrorCode: function () {
            return l
        }, GetLastErrorMessage: function () {
            return n
        }, IsAvailable: function () {
            return A
        }, GetAllUserCertListNum: function (a, b, c, d, e) {
            q(function () {
                C(1);
                l = -1;
                n = "";
                p = a;
                u = b;
                D = d;
                a == H.device ? Z(m.ubiKeyEnv.version, m.ubiKeyEnv.siteInfo, m.ubiKeyEnv.securityInfo, m.ubiKeyEnv.downloadURL, function (a) {
                    0 == a ? T(e) : e(a, 0)
                }) : T(e)
            }, 0)
        }, GetSignDataP7: function (a, b, c, d, e, f, h) {
            q(function () {
                l = -1;
                n = "";
                V(t[a - 1], b, c, d, e, f, h)
            }, 1)
        }, GetAllUserCert: function (a, b) {
            q(function () {
                function c(h, l, k) {
                    d++;
                    if (0 == h) null != l && 0 < l.length && (h = {}, h.index = e + 1, h.cert = l, h.path = k ? k : "", f[e] = h); else return b(h), !1;
                    if (a == d) return __callback = null, b(0, f), !0;
                    e += 1;
                    N(t[e], c)
                }

                C(2);
                var d = 0, e = 0, f = [];
                N(t[e], c)
            })
        }, GetSignDataP1: function (a, b, c, d, e) {
            q(function () {
                l = -1;
                n = "";
                ha(t[a - 1], b, c, d, e)
            }, 1)
        }, GetCert: function (a) {
            return t && t[a - 1] ? t[a - 1].cert : null
        }, GetIframeLoaded: function () {
            return A
        }, ExpireCertificate: function () {
        }, DeleteCertificate: function (a, b, c, d) {
            q(function () {
                l = -1;
                n = "";
                p = a;
                u = b;
                ea(t[c - 1], d)
            }, 3)
        }, RenewCertificate: function (a, b, c, d, e, f, h, k) {
            q(function () {
                l = -1;
                n = "";
                p = c;
                u = d;
                Q(0, a, b, t[e - 1], f, h, k)
            }, 4)
        }, IssueKMCertificate: function (a, b, c, d, e, f, h, k) {
            q(function () {
                l = -1;
                n = "";
                p = c;
                u = d;
                Q(1, a, b, t[e - 1], f, h, k)
            }, 4)
        }, RevokeCertificate: function (a, b, c, d, e, f, h) {
            q(function () {
                l = -1;
                n = "";
                p = c;
                u = d;
                fa(a, b, f, t[e - 1], h)
            }, 2)
        }, IssueCertificate: function (a, b, c, d, e, f, h, k) {
            q(function () {
                l = -1;
                n = "";
                p = c;
                u = d;
                da(a, b, f, h, k)
            })
        }, GetDiskListNum: function (a, b) {
            C(0);
            p = a;
            for (var c = 0, d = v.length, e = 0, c = 0; c < d; c++) v[c].device == a && e++;
            b(e)
        }, GetDiskListNumNotDeviceSelect: function (a, b) {
            C(0);
            for (var c = 0, d = v.length, e = 0, c = 0; c < d; c++) v[c].device == a && e++;
            b(e)
        }, GetDiskDriveName: function (a) {
            for (var b = 0, c = v.length, b = 0; b < c; b++) if (v[b].device == O.device && v[b].drive == a) return v[b].name;
            return ""
        }, ValidateCertificate: function (a, b) {
            q(function () {
                l = -1;
                n = "";
                ja(t[a - 1], b)
            }, 12)
        }, CopyCert: function (a, b, c, d, e, f, h) {
            q(function () {
                p = a;
                u = b;
                ia(c, d, t[e - 1], f, h)
            }, 5)
        }, ImportCert: function (a, b, c) {
            q(function () {
                p = a;
                u = b;
                ma(c)
            }, 6)
        }, ExportCert: function (a, b, c, d, e, f) {
            q(function () {
                p = a;
                u = b;
                ka(t[c - 1], d, e, f)
            }, 7)
        }, ChangePassword: function (a, b, c, d) {
            q(function () {
                p = a;
                u = b;
                oa(t[c - 1], d)
            }, 8)
        }, VerifySignedData: function (a, b, c) {
            q(function () {
                Y(0, a, b, c)
            })
        }, VerifySignature: function (a, b, c, d) {
            q(function () {
                sa(a, b, c, d)
            })
        }, GetSecureTokenName: function (a) {
            for (var b = 0, c = v.length, b = 0; b < c; b++) if (v[b].device == I.device && v[b].drive == a) return v[b].name + "|" + v[b].type + "|" + v[b].trusted;
            return ""
        }, GetSmartCardName: function (a) {
            for (var b = 0, c = v.length, b = 0; b < c; b++) if (v[b].device == J.device && v[b].drive == a) return v[b].name;
            return ""
        }, GetMobileTokenName: function (a) {
            for (var b = 0, c = v.length, b = 0; b < c; b++) if (v[b].device == z.device && v[b].drive == a) return v[b].name;
            return ""
        }, VerifyVID: function (a, b, c, d) {
            q(function () {
                ua(t[a - 1], b, c, d)
            })
        }, GetCACertificates: function (a, b) {
            q(function () {
                wa(t[a - 1], b)
            }, -1)
        }, VerifySignedDataWithHashValue: function (a, b, c) {
            q(function () {
                Y(2, a, b, c)
            })
        }, GetAllMediaList: function (a, b) {
            q(function () {
                function c(a, c) {
                    0 == a ? va(m.usimEnv.sitecode, m.usimEnv.modecode, m.usimEnv.siteURL, m.usimEnv.serviceIP, m.usimEnv.servicePort, function (c) {
                        b(a, v.length);
                        return !0
                    }) : b(a, c)
                }

                1 == a && 0 < v.length ? b(0, v.length) : (C(1), l = -1, n = "", 0 == a ? R(a, c) : R(a, b))
            })
        }, HashData: function (a, b, c, d) {
            q(function () {
                xa(a, b, c, d)
            })
        }, EncryptData: function (a, b, c, d, e, f, h) {
            q(function () {
                ya(a, b, c, d, e, f, h)
            })
        }, DecryptData: function (a, b, c, d, e, f, h) {
            q(function () {
                za(a, b, c, d, e, f, h)
            })
        }, EnvelopData: function (a, b, c, d) {
            q(function () {
                var e = t[b - 1];
                "kmcert" == a && e.certIdentifier == e.kmcertIdentifier ? d(-2) : Aa(a, t[b - 1], c, d)
            }, 10)
        }, DeenvelopData: function (a, b, c, d, e) {
            q(function () {
                var f = t[b - 1];
                "kmcert" == a && f.keyIdentifier == f.kmkeyIdentifier ? e(-2) : Ba(a, t[b - 1], c, d, e)
            }, 11)
        }, GetCertListWithP12: function (a, b, c, d, e) {
            q(function () {
                C(1);
                Da(c, d, e)
            })
        }, GetSelectUserCert: function (a, b) {
            q(function () {
                C(2);
                N(t[a - 1], b)
            })
        }, CheckPassword: function (a, b, c, d) {
            q(function () {
                l = -1;
                n = "";
                V(t[a - 1], b, 0, c, !0, null, d)
            }, 9)
        }, GetSignFileP7: function (a, b, c, d, e, f) {
            q(function () {
                l = -1;
                n = "";
                ga(t[a - 1], b, c, d, e, f)
            }, 1)
        }, VerifySignedFile: function (a, b, c, d, e, f) {
            q(function () {
                ta(a, b, c, d, e, f)
            })
        }, ImportCertEx: function (a, b, c, d, e, f, h, k, l) {
            q(function () {
                p = a;
                u = b;
                na(c, d, e, f, h, k, l)
            }, 6)
        }, ExportCertEx: function (a, b, c, d, e) {
            q(function () {
                p = a;
                u = b;
                la(t[c - 1], d, e)
            }, 7)
        }, GetTokenInfo: function (a, b, c) {
            q(function () {
                p = a;
                u = b;
                Ca(c)
            }, 13)
        }, GetMacAddress: function (a, b) {
            q(function () {
                Fa(a, b)
            })
        }, XMLDllInitialize: function (a, b, c) {
            q(function () {
                $(a, b, c)
            })
        }, XMLDllAction: function (a, b, c, d, e) {
            q(function () {
                Ga(a, b, c, d, e)
            })
        }, XMLDllFinalize: function (a) {
            q(function () {
                aa(a)
            })
        }, ConvertStringFormat: function (a, b, c) {
            q(function () {
                Ha(a, b, c)
            })
        }, GetE2EInfo: function (a) {
            q(function () {
                Ia(a)
            })
        }, CheckComplexPin: function (a, b) {
            q(function () {
                Ja(a, b)
            })
        }, SetUBIKeyOptions: function (a) {
            q(function () {
                Z(m.ubiKeyEnv.version, m.ubiKeyEnv.siteInfo, m.ubiKeyEnv.securityInfo, m.ubiKeyEnv.downloadURL, a)
            })
        }, EncryptVIDRandom: function (a, b, c, d) {
            q(function () {
                l = -1;
                n = "";
                Ka(t[a - 1], b, c, d)
            })
        }
    }
};