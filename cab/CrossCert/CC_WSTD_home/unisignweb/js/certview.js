var __certview=function(a){var F=function(s){function A(a){if(!a)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=a;return!0}function v(a){a=parseInt(a);var g=document.getElementById("us-view-simple"),d=document.getElementById("us-view-detail"),e=document.getElementById("us-view-certpath"),l=document.getElementById("us-view-cert-cps-btn");document.getElementById("us-view-cert-confirm-btn");document.getElementById("us-view-cls-img-btn");var c=document.getElementById("us-view-content-wrap");if(0===a){g.style.display="block";d.style.display="none";e.style.display="none";l.style.display="inline";var f=function(a){!a.getAttribute("title")||1>a.getAttribute("title").length?setTimeout(function(){f(a)},100):c.setAttribute("title",b.IDS_TAB_CONTENT_1+a.getAttribute("title"))};f(g);z.clearList()}else 1===a?(g.style.display="none",d.style.display="block",e.style.display="none",l.style.display="none",c.setAttribute("title",b.IDS_TAB_CONTENT_2),z.redrawList(B.list,B.list.length)):2===a&&(g.style.display="none",d.style.display="none",e.style.display="block",l.style.display="none",c.setAttribute("title",b.IDS_TAB_CONTENT_3))}function p(a,b){var d=a||window.event,d=d.target||d.srcElement,e=b.getElementsByTagName("a"),l=document.getElementById("us-view-tab-simple"),c=document.getElementById("us-view-tab-detail"),f=document.getElementById("us-view-tab-certpath");for(n in e)if(d==e[n]){isNaN(n)&&("us-view-tab-simple"==n?n=0:"us-view-tab-detail"==n?n=1:"us-view-tab-certpath"==n&&(n=2));0==n?(l.className="us-view-tab-tag active",c.className="us-view-tab-tag",f.className="us-view-tab-tag"):1==n?(l.className="us-view-tab-tag",c.className="us-view-tab-tag active",f.className="us-view-tab-tag"):2==n&&(l.className="us-view-tab-tag",c.className="us-view-tab-tag",f.className="us-view-tab-tag active");v(n);break}}function x(b,g,d,e,l){var c=null;a.usWebToolkit.x509Certificate.parser(e,d);e=a.usWebToolkit.x509Certificate.getVersion();var c=a.usWebToolkit.x509Certificate.getSerialNumber(),f=a.usWebToolkit.x509Certificate.getSignAlgo(),m=a.usWebToolkit.x509Certificate.getIssuerName(),t=a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotBefore()),k=a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotAfter()),q=a.usWebToolkit.x509Certificate.getSubjectName(),C=a.usWebToolkit.x509Certificate.getPublickey(),D=a.usWebToolkit.x509Certificate.getAuthorityKeyIndentifier(),w=a.usWebToolkit.x509Certificate.getSubjectKeyIdentifier(),I=a.usWebToolkit.x509Certificate.getKeyUsage(),J=a.usWebToolkit.x509Certificate.getCertificatePoliciesOid(),K=a.usWebToolkit.x509Certificate.getSubjectAltName(),r=a.usWebToolkit.x509Certificate.getAuthorityInfoAccess(),s=a.usWebToolkit.x509Certificate.getcRLDistributionPoints(),p="";try{p=a.usWebToolkit.x509Certificate.getCertificatePoliciesCPS()}catch(v){}var u="";try{u=a.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice()}catch(x){}var y=a.usWebToolkit.x509Certificate.getSignature();d=[];d[0]=e;d[1]=c;d[2]=f;d[3]=m;d[4]=t;d[5]=k;d[6]=q;d[7]=C;d[8]=D;d[9]=w;d[10]=I;d[11]=J;d[12]=K;d[13]=r;d[14]=s;d[15]=p;d[16]=u;d[17]=y;e=[];for(c=0;c<d.length;c++)f=[],f[0]=g[c].field,f[1]=d[c],e[c]=f;B=c={list:e};G=a.loadUI("gridlist");z=G({type:"detailslist",tblid:"us-view-tbl-list",tbltitleid:"us-view-tbl-list-th",titlelistid:"us-view-grid-head-div",titlerowid:"us-view-list-title-row",titleelementid:"us-view-list-title-element",titledividerid:null,titlelistcn:"us-layout-view-grid-head-div",titlerowcn:"us-layout-view-grid-head-row",titleelementcn:"us-layout-view-grid-row-title-element",titledividercn:null,tblbodyid:"us-view-tbl-list-td",datalistid:"us-view-grid-body-div",datarowid:"us-view-list-body-row",dataelementid:"us-view-list-data-element",datalistcn:"us-layout-view-grid-body-div",datarowcn:"us-layout-view-grid-body-row",dataelementcn:"us-layout-view-grid-row-data-element",dataselectcn:"us-layout-view-grid-row-data-selected-element",textboxid:"us-view-detail-text-box"});z.drawTitle(b,b.length,l,!1)}function E(h,g,d,e,l){if(!h||0>=g||!d||!e)return!1;var c=document.getElementById("us-view-cert-status-img"),f=document.getElementById("us-view-cert-status-msg"),m=-1,t=0,k=null;if(2==a.ESVS.Mode){g=null;try{var q=a.usWebToolkit.pki.createCaStore();g=a.PFSH.GetCACerts();for(var C in g)caCert=g[C],q.addCertificate(a.usWebToolkit.pki.certificateFromBase64(caCert));var D=a.usWebToolkit.pki.certificateFromBase64(d);a.usWebToolkit.pki.verifyCertificateChain(q,D,function(d,b,h){null!=c&&null!=f&&(!0===d?(m=0,c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_valid.png",0),f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_VALID)),r=!0):(m=-1,c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_invalid.png",0),null!=h&&void 0!=h&&0<=h.indexOf("Certificate is not valid yet or has expired")?f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_EXPIRED)):null!=h&&void 0!=h&&0<=h.indexOf("no parent issuer, so certificate not trusted")?f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_ISSUER_FAIL)):f.appendChild(document.createTextNode(h)),r=!1),l(m))})}catch(w){y.log("***** [Plugin Free] VerifyCertBasicAndChain exception *****"),t=w.code,k=w.message,y.log("e.code : ",w.code,"e.message : ",w.message,"e.detail : ",w.detail),a.uiUtil().errMsgBox(w.message,w.code)}}else 4&a.ESVS.Mode?a.nimservice()?a.nimservice().ValidateCertificate(g,function(d,h,b,k){null!=c&&null!=f&&(0==d?999==b?(c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_valid.png",0),f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_VALID)),r=!0):(c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_invalid.png",0),f.appendChild(document.createTextNode(k)),r=!1):(c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_invalid.png",0),f.appendChild(document.createTextNode(h)),r=!1),l(0))}):(a.uiUtil().msgBox(b.IDS_MSGBOX_NIM_ERROR_UNLOAD),rv=-1,l(-1)):a.plugin().valid?(y.log("*** [Plugin] Call VerifyCertBasicAndChain Func ***"),m=a.plugin().VerifyCertBasicAndChain(g),0!==m&&(y.log("*** [Plugin] VerifyCertBasicAndChain return error ***"),t=a.plugin().GetLastErrorCode(),k=a.plugin().GetLastErrorMessage(),y.log("Err Code : ",t,"\nErr Msg : ",k))):a.uiUtil().msgBox(e.IDS_MSGBOX_PLUGIN_ERROR_UNLOAD);if(!(4&a.ESVS.Mode||2&a.ESVS.Mode))if(0===m)c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_valid.png",0),f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_VALID)),r=!0;else switch(r=!1,c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/cert_invalid.png",0),t){case 3005:f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_EXPIRED));break;default:f.appendChild(document.createTextNode(e.IDS_CERT_STATUS_INVALID))}(function(){a.usWebToolkit.x509Certificate.parser(d,h);document.getElementById("us-view-cert-subject-name-data").appendChild(document.createTextNode(a.certUtil().getCN(a.usWebToolkit.x509Certificate.getSubjectName())));var b=document.getElementById("us-view-cert-issuer-name-data"),c=a.certUtil().getCN(a.usWebToolkit.x509Certificate.getIssuerName());if(""==c||"undefined"==c)c=a.certUtil().getO(a.usWebToolkit.x509Certificate.getIssuerName());b.appendChild(document.createTextNode(c));document.getElementById("us-view-cert-validity-date-from").appendChild(document.createTextNode(a.certUtil().getLocalDate(a.usWebToolkit.x509Certificate.getNotBefore())));document.getElementById("us-view-cert-validity-date-to").appendChild(document.createTextNode(a.certUtil().getLocalDate(a.usWebToolkit.x509Certificate.getNotAfter())));b=document.getElementById("us-view-cert-purpose");c=null;try{c=a.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice()}catch(f){}null!=c&&b.appendChild(document.createTextNode(c));document.getElementById("us-view-cert-cps-btn").onclick=function(){var c=a.usWebToolkit.x509Certificate.getCertificatePoliciesCPS();"firefox"==a.browserName?window.open(c,"cps_url","scrollbars=1"):window.open(c);this.focus()}})();return!0}function F(a){if(null==a||0==a.length)return"";for(var b=a.length,d="",e=0,l=b;e<b;e++,l--)0==l%4&&l!=b&&(d+=" "),d+=a.charAt(e);return d.toUpperCase()}function H(b,g,d,e,l){function c(a,b){var c=document.getElementById(a);c&&c.appendChild(document.createTextNode(b))}function f(a,b){var c=document.createElement("li");!0==a?c.setAttribute("class","valid"):!1==a?c.setAttribute("class","invalid"):null!=a?c.setAttribute("class",a):c.appendChild(document.createTextNode(b));return c}function m(b,c){var d=null;if(null==b||0>=b.length)return null;var f=a.usWebToolkit.x509Certificate.parser(b,c),f=a.usWebToolkit.asn1.fromDer(f.getExtension("authorityKeyIdentifier").value),e=a.usWebToolkit.util.bytesToHex(f.value[0].value);f.value[2]&&(e+="_"+parseInt(a.usWebToolkit.util.bytesToHex(f.value[2].value),16));caCerts=a.PFSH.GetCACerts();for(var h in caCerts)h.toUpperCase()==e.toUpperCase()&&(d=caCerts[h]);return d}function t(g,m){try{var l=a.usWebToolkit.md.sha256.create();l.start();l.update(a.usWebToolkit.util.decode64(m));var t=l.digest().toHex();a.usWebToolkit.x509Certificate.parser(m,b);k.appendChild(f(!0));k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName()));c("us-view-certpath-version",e.IDS_CERT_PATH_ROOTCA_VERSION);c("us-view-certpath-version-data",a.usWebToolkit.x509Certificate.getVersion());c("us-view-certpath-date",e.IDS_CERT_PATH_ROOTCA_VALIDDATE);c("us-view-certpath-date-from",a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotBefore()));c("us-view-certpath-date-to",a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotAfter()));a.usWebToolkit.x509Certificate.parser(g,b);k.appendChild(f("dot"));k.appendChild(f(!0));k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName()));a.usWebToolkit.x509Certificate.parser(d,b);k.appendChild(f("dot2"));k.appendChild(f(r));k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName()));var q=F(t);if(null==q||0==q.length)q="  ";c("us-view-certpath-hash",e.IDS_CERT_PATH_NOTICE);c("us-view-certpath-hash-data",q);c("us-view-certpath-tail",e.IDS_CERT_PATH_ROOTHASH_URL);c("us-view-certpath-tail",e.IDS_CERT_PATH_ROOTHASH_URL2);c("us-view-certpath-tail",e.IDS_CERT_PATH_ROOTHASH_URL3);document.getElementById("us-view-certpath-tail").onclick=function(){window.open(e.IDS_CERT_PATH_ROOTHASH_LINK,"ca_hash","scrollbars=1;width=650;height=460;")}}catch(p){a.usWebToolkit.x509Certificate.parser(d,b),k&&k.appendChild(f(r)),k&&k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName()))}}if(4&a.ESVS.Mode&&!a.nimservice())a.uiUtil().msgBox(e.IDS_MSGBOX_NIM_ERROR_UNLOAD);else{var k=document.getElementById("us-view-certpath-info-tree");if(2&a.ESVS.Mode){var q=g=null;g=m(d,b);q=m(g,b);null!=g&&null!=q?t(g,q):(a.usWebToolkit.x509Certificate.parser(d,b),k&&k.appendChild(f(r)),k&&k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName())));l()}else 4&a.ESVS.Mode&&a.nimservice().GetCACertificates(g,function(c,e,g){null!=k&&(0==c?t(e,g):(a.usWebToolkit.x509Certificate.parser(d,b),k&&k.appendChild(f(r)),k&&k.appendChild(f(null,a.usWebToolkit.x509Certificate.getSubjectName()))),l())})}}var L=function(){var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/layout/certview.html?V="+a.ver,!1);b.send(null);return b.responseText},M=function(){var b;b=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");b.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/lang/certview_"+a.ESVS.Language+".js?V="+a.ver,!1);b.send(null);return b.responseText},G=null,z=null,B=null,r=!0,u=a.ESVS.TabIndex,b=null,y=window.console||{log:function(){}};return function(){var h=eval(L);b=eval(eval(M)());var g=s.args.type,d=s.args.idx,e=s.args.cert;A(h());var l=document.getElementById("us-view-lbl-title");l.appendChild(document.createTextNode(b.IDS_CERT_VIEW));l.setAttribute("tabindex",u++,0);h=document.getElementById("us-view-tab");h.onclick=function(a){p(a?a:event,this)};h.onkeydown=function(a){if((a=a?a:event)&&this){var b=a||window.event;13==(b.which||b.keyCode)&&p(a,this)}};h=document.getElementById("us-view-tab-simple");h.setAttribute("tabindex",u++,0);h.appendChild(document.createTextNode(b.IDS_CERT_SIMPLE_VIEW));h=document.getElementById("us-view-tab-detail");h.appendChild(document.createTextNode(b.IDS_CERT_DETAIL_VIEW));h.setAttribute("tabindex",u++,0);h=document.getElementById("us-view-tab-certpath");h.appendChild(document.createTextNode(b.IDS_CERT_PATH_VIEW));h.setAttribute("tabindex",u++,0);document.getElementById("us-view-content-wrap").setAttribute("tabindex",u++,0);var h=u++,c=document.getElementById("us-view-cert-cps-btn");c.setAttribute("tabindex",u++,0);c.setAttribute("value",b.IDS_CERT_SUPPLEMENT_INFO,0);c.style.display="none";c=document.getElementById("us-view-cert-confirm-btn");c.setAttribute("tabindex",u++,0);c.setAttribute("value",b.IDS_CERT_CONFIRM,0);c.onclick=function(){z.restoreOnMouseEvent();s.onCancel()};document.getElementById("us-view-simple");document.getElementById("us-view-cert-info").appendChild(document.createTextNode(b.IDS_CERT_INFO));document.getElementById("us-view-cert-subject-name").appendChild(document.createTextNode(b.IDS_CERT_SUBJECT_NAME));document.getElementById("us-view-cert-issuer-name").appendChild(document.createTextNode(b.IDS_CERT_ISSUER_NAME));document.getElementById("us-view-cert-validity-date").appendChild(document.createTextNode(b.IDS_CERT_VALIDITY_DATE));c=document.getElementById("us-view-cls-img-btn");c.onclick=function(){z.restoreOnMouseEvent();s.onCancel()};c.onfocus=function(){l.focus()};document.getElementById("us-view-cls-btn-img").setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);var f=function(){for(var a=document.querySelectorAll(".us-layout-view-simple dt"),b=document.querySelectorAll(".us-layout-view-simple dd"),c="",d=0;d<a.length;d++){var f=a[d].innerHTML,e=b[d].innerHTML;b[d].querySelector("div")?e=b[d].querySelector("div").innerHTML:b[d].querySelector("span")&&(e=b[d].querySelectorAll("span")[0].innerHTML+"~"+b[d].querySelectorAll("span")[1].innerHTML);0<c.length&&(c+=", ");c+=f+e}document.getElementById("us-view-simple").setAttribute("title",c)};x([{title:b.IDS_CERT_FIELD},{title:b.IDS_CERT_VALUE}],[{field:b.IDS_CERT_VERSION},{field:b.IDS_CERT_SERIAL_NUMBER},{field:b.IDS_CERT_SIGN_ALGOLISM},{field:b.IDS_CERT_ISSUER},{field:b.IDS_CERT_VALIDATE_FROM},{field:b.IDS_CERT_VALIDATE_TO},{field:b.IDS_CERT_SUBJECT},{field:b.IDS_CERT_PUBLIC_KEY},{field:b.IDS_CERT_AUTHORITY_KEY_IDENTIFIER},{field:b.IDS_CERT_SUBJECT_KEY_IDENTIFIER},{field:b.IDS_CERT_KEY_USAGE},{field:b.IDS_CERT_POLICY},{field:b.IDS_CERT_SUBJECT_ALT_NAME},{field:b.IDS_CERT_AUTHORITY_INFO_ACCESS},{field:b.IDS_CERT_CRL_DISTRIBUTE_POINTS},{field:b.IDS_CERT_CPS},{field:b.IDS_CERT_PURPOSE},{field:b.IDS_CERT_SIGNATURE}],g,e,h);4&a.ESVS.Mode?E(g,d,e,b,function(a){f();H(g,d,e,b,function(a){})}):2&a.ESVS.Mode?E(g,d,e,b,function(a){f();H(g,d,e,b,function(a){})}):(E(g,d,e,b),f(),document.getElementById("us-view-tab3").style.display="none");a.uiUtil().setRotationTabFocus("us-view-cert-confirm-btn","us-view-cert-cps-btn","us-view-lbl-title");a.uiUtil().setRotationTabFocus("us-view-lbl-title","us-view-cert-confirm-btn","us-view-tab-simple");v(0);return document.getElementById("us-div-cert-view")}()};return function(s){var A=a.uiLayerLevel,v=a.uiUtil().getOverlay(A),p=F({type:s.type,args:s.args,onConfirm:s.onConfirm,onCancel:s.onCancel});p.style.zIndex=A+1;a.ESVS.TargetObj.insertBefore(v,a.ESVS.TargetObj.firstChild);var x=window.onresize;return{show:function(){draggable(p,document.getElementById("us-div-view-title"));v.style.display="block";a.uiUtil().offsetResize(p);window.onresize=function(){a.uiUtil().offsetResize(p);x&&x()};a.uiLayerLevel+=10;a.ESVS.TabIndex+=30;setTimeout(function(){a.uiUtil().setFirstFocus("us-view-lbl-title")},10)},hide:function(){v.style.display="none";p.style.display="none"},dispose:function(){window.onresize=function(){x&&x()};p.parentNode.parentNode.removeChild(p.parentNode);v.parentNode.removeChild(v);a.uiLayerLevel-=10;a.ESVS.TabIndex-=30}}}};