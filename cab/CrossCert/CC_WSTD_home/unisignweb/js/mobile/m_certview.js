var __certview=function(a){var y=function(g){function u(a){if(!a)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=a;return!0}function m(a){a=parseInt(a);var b=document.getElementById("m-us-view-simple"),d=document.getElementById("m-us-view-detail"),x=document.getElementById("m-us-view-cert-cps-btn"),q=document.getElementById("m-us-view-cert-confirm-btn"),k=document.getElementById("m-us-view-cls-img-btn");0===a?(b.style.display="block",d.style.display="none",x.style.display="inline",p.clearList(),x.setAttribute("tabindex",e+3,0),q.setAttribute("tabindex",e+4,0),k.setAttribute("tabindex",e+5,0)):1===a&&(b.style.display="none",d.style.display="block",x.style.display="none",p.redrawList(h.list,h.list.length),x.removeAttribute("tabindex"),q.setAttribute("tabindex",e+4,0),k.setAttribute("tabindex",e+5,0))}function f(a,b){var d=a||window.event,d=d.target||d.srcElement,e=b.getElementsByTagName("a"),h=document.getElementById("m-us-view-tab-simple"),k=document.getElementById("m-us-view-tab-detail");for(n in e)if(d==e[n]){isNaN(n)&&(n="m-us-view-tab-simple"==n?0:1);0==n?(h.className="m-us-view-tab-tag active",k.className="m-us-view-tab-tag"):(h.className="m-us-view-tab-tag",k.className="m-us-view-tab-tag active");m(n);break}}function l(c,b){var d=null,f=a.usWebToolkit.x509Certificate.getVersion(),q=a.usWebToolkit.x509Certificate.getSerialNumber(),k=a.usWebToolkit.x509Certificate.getSignAlgo(),g=a.usWebToolkit.x509Certificate.getIssuerName(),m=a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotBefore()),w=a.certUtil().getLocalDateNTime(a.usWebToolkit.x509Certificate.getNotAfter()),v=a.usWebToolkit.x509Certificate.getSubjectName(),l=a.usWebToolkit.x509Certificate.getPublickey(),z=a.usWebToolkit.x509Certificate.getAuthorityKeyIndentifier(),r=a.usWebToolkit.x509Certificate.getSubjectKeyIdentifier(),t=a.usWebToolkit.x509Certificate.getKeyUsage(),A=a.usWebToolkit.x509Certificate.getCertificatePoliciesOid(),u=a.usWebToolkit.x509Certificate.getSubjectAltName(),y=a.usWebToolkit.x509Certificate.getAuthorityInfoAccess(),B=a.usWebToolkit.x509Certificate.getcRLDistributionPoints(),C=a.usWebToolkit.x509Certificate.getCertificatePoliciesCPS(),D=a.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice(),E=a.usWebToolkit.x509Certificate.getSignature(),d=[];d[0]=f;d[1]=q;d[2]=k;d[3]=g;d[4]=m;d[5]=w;d[6]=v;d[7]=l;d[8]=z;d[9]=r;d[10]=t;d[11]=A;d[12]=u;d[13]=y;d[14]=B;d[15]=C;d[16]=D;d[17]=E;f=[];for(q=0;q<d.length;q++)k=[],k[0]=b[q].field,k[1]=d[q],f[q]=k;h=d={list:f};s=a.loadUI("gridlist");p=s({type:"detailslist",tblid:"m-us-view-tbl-list",tbltitleid:"m-us-view-tbl-list-th",titlelistid:"m-us-view-grid-head-div",titlerowid:"m-us-view-list-title-row",titleelementid:"m-us-view-list-title-element",titledividerid:null,titlelistcn:"m-us-layout-view-grid-head-div",titlerowcn:"m-us-layout-view-grid-head-row",titleelementcn:"m-us-layout-view-grid-row-title-element",titledividercn:null,tblbodyid:"m-us-view-tbl-list-td",datalistid:"m-us-view-grid-body-div",datarowid:"m-us-view-list-body-row",dataelementid:"m-us-view-list-data-element",datalistcn:"m-us-layout-view-grid-body-div",datarowcn:"m-us-layout-view-grid-body-row",dataelementcn:"m-us-layout-view-grid-row-data-element",dataselectcn:"m-us-layout-view-grid-row-data-selected-element",textboxid:"m-us-view-detail-text-box"});p.drawTitle(c,c.length,e+3,!1)}function w(c,b,d,e){if(!c||0>=b||!d||!e)return!1;b=document.getElementById("m-us-view-cert-status-img");var h=document.getElementById("m-us-view-cert-status-msg"),k=-1,f=0;if(2&a.ESVS.Mode){var g=null;try{var m=a.usWebToolkit.pki.createCaStore(),g=a.PFSH.GetCACerts(),p;for(p in g)caCert=g[p],m.addCertificate(a.usWebToolkit.pki.certificateFromBase64(caCert));var w=a.usWebToolkit.pki.certificateFromBase64(d);a.usWebToolkit.pki.verifyCertificateChain(m,w,function(a,b,c){!0===a?(k=0,v.log("*** [Plugin Free] VerifyCertBasicAndChain return Verify Success!(depth : "+b+")")):(k=-1,v.log("*** [Plugin Free] VerifyCertBasicAndChain return Verify Fail!(depth : "+b+", errMessage : "+c+")"),f=null!=c&&void 0!=c&&0<=c.indexOf("Certificate is not valid yet or has expired")?3005:-1)})}catch(l){v.log("***** [Plugin Free] VerifyCertBasicAndChain exception *****"),f=l.code,v.log("e.code : ",l.code,"e.message : ",l.message,"e.detail : ",l.detail),a.uiUtil().errMsgBox(l.message,l.code)}}if(0===k)b.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/mobile/m_cert_valid_small.png",0),h.appendChild(document.createTextNode(e.IDS_CERT_STATUS_VALID));else switch(b.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/mobile/m_cert_invalid_small.png",0),f){case 3005:h.appendChild(document.createTextNode(e.IDS_CERT_STATUS_EXPIRED));break;default:h.appendChild(document.createTextNode(e.IDS_CERT_STATUS_INVALID))}a.usWebToolkit.x509Certificate.parser(d,c);document.getElementById("m-us-view-cert-subject-name-data").appendChild(document.createTextNode(a.certUtil().getCN(a.usWebToolkit.x509Certificate.getSubjectName())));document.getElementById("m-us-view-cert-issuer-name-data").appendChild(document.createTextNode(a.certUtil().getCN(a.usWebToolkit.x509Certificate.getIssuerName())));document.getElementById("m-us-view-cert-validity-date-from").appendChild(document.createTextNode(a.certUtil().getLocalDate(a.usWebToolkit.x509Certificate.getNotBefore())));document.getElementById("m-us-view-cert-validity-date-to").appendChild(document.createTextNode(a.certUtil().getLocalDate(a.usWebToolkit.x509Certificate.getNotAfter())));c=document.getElementById("m-us-view-cert-purpose");d=a.usWebToolkit.x509Certificate.getCertificatePoliciesUserNotice();null!=d&&c.appendChild(document.createTextNode(d));document.getElementById("m-us-view-cert-cps-btn").onclick=function(){var b=a.usWebToolkit.x509Certificate.getCertificatePoliciesCPS();"firefox"==a.browserName?window.open(b,"cps_url","scrollbars=1"):window.open(b);this.focus()};return!0}var r=function(){var c;c=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");c.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/layout/mobile/m_certview.html?V="+a.ver,!1);c.send(null);return c.responseText},t=function(){var c;c=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");c.open("GET",a.ESVS.SRCPath+"unisignweb/rsrc/lang/certview_"+a.ESVS.Language+".js?V="+a.ver,!1);c.send(null);return c.responseText},s=null,p=null,h=null,e=a.ESVS.TabIndex,v=window.console||{log:function(){}};return function(){var c=eval(r),b=eval(eval(t)()),d=g.args.type,h=g.args.idx,q=g.args.cert;u(c());document.getElementById("m-us-view-lbl-title").appendChild(document.createTextNode(b.IDS_CERT_VIEW));c=document.getElementById("m-us-view-tab");c.onclick=function(a){f(a?a:event,this)};c.onkeydown=function(a){if((a=a?a:event)&&this){var b=a||window.event;13==(b.which||b.keyCode)&&f(a,this)}};c=document.getElementById("m-us-view-tab-simple");c.setAttribute("tabindex",e,0);c.appendChild(document.createTextNode(b.IDS_CERT_SIMPLE_VIEW));document.getElementById("m-us-view-simple").setAttribute("tabindex",e+1,0);c=document.getElementById("m-us-view-tab-detail");c.appendChild(document.createTextNode(b.IDS_CERT_DETAIL_VIEW));c.setAttribute("tabindex",e+2,0);document.getElementById("m-us-view-cert-info").appendChild(document.createTextNode(b.IDS_CERT_INFO));document.getElementById("m-us-view-cert-subject-name").appendChild(document.createTextNode(b.IDS_CERT_SUBJECT_NAME));document.getElementById("m-us-view-cert-issuer-name").appendChild(document.createTextNode(b.IDS_CERT_ISSUER_NAME));document.getElementById("m-us-view-cert-validity-date").appendChild(document.createTextNode(b.IDS_CERT_VALIDITY_DATE));c=document.getElementById("m-us-view-cert-cps-btn");c.setAttribute("value",b.IDS_CERT_SUPPLEMENT_INFO,0);c.setAttribute("title",b.IDS_CERT_SUPPLEMENT_INFO+b.IDS_BUTTON,0);c.style.display="none";c=document.getElementById("m-us-view-cert-confirm-btn");c.setAttribute("value",b.IDS_CERT_CONFIRM,0);c.setAttribute("title",b.IDS_CERT_CONFIRM+b.IDS_BUTTON,0);c.onclick=function(){p.restoreOnMouseEvent();g.onCancel()};c=document.getElementById("m-us-view-cls-img-btn");c.setAttribute("alt",b.IDS_CERT_VIEW_CLOSE,0);c.onclick=function(){p.restoreOnMouseEvent();g.onCancel()};c=document.getElementById("m-us-view-cls-btn-img");c.setAttribute("alt",b.IDS_CERT_VIEW_CLOSE,0);c.setAttribute("src",a.ESVS.SRCPath+"unisignweb/rsrc/img/mobile/m_x-btn.png",0);w(d,h,q,b);l([{title:b.IDS_CERT_FIELD},{title:b.IDS_CERT_VALUE}],[{field:b.IDS_CERT_VERSION},{field:b.IDS_CERT_SERIAL_NUMBER},{field:b.IDS_CERT_SIGN_ALGOLISM},{field:b.IDS_CERT_ISSUER},{field:b.IDS_CERT_VALIDATE_FROM},{field:b.IDS_CERT_VALIDATE_TO},{field:b.IDS_CERT_SUBJECT},{field:b.IDS_CERT_PUBLIC_KEY},{field:b.IDS_CERT_AUTHORITY_KEY_IDENTIFIER},{field:b.IDS_CERT_SUBJECT_KEY_IDENTIFIER},{field:b.IDS_CERT_KEY_USAGE},{field:b.IDS_CERT_POLICY},{field:b.IDS_CERT_SUBJECT_ALT_NAME},{field:b.IDS_CERT_AUTHORITY_INFO_ACCESS},{field:b.IDS_CERT_CRL_DISTRIBUTE_POINTS},{field:b.IDS_CERT_CPS},{field:b.IDS_CERT_PURPOSE},{field:b.IDS_CERT_SIGNATURE}]);m(0);return document.getElementById("m-us-div-cert-view")}()};return function(g){var u=a.uiLayerLevel,m=a.uiUtil().getOverlay(u),f=y({type:g.type,args:g.args,onConfirm:g.onConfirm,onCancel:g.onCancel});f.style.zIndex=u+1;a.ESVS.TargetObj.insertBefore(m,a.ESVS.TargetObj.firstChild);var l=window.onorientationchange;return{show:function(){m.style.display="block";var g=a.uiUtil().getNumSize(a.uiUtil().getStyle(f,"height","height")),g=-1===g?a.uiUtil().getScrollTop()+a.uiUtil().getViewportHeight()/6:a.uiUtil().getScrollTop()+(a.uiUtil().getViewportHeight()-g)/3;f.style.top=0>g?"0px":g+"px";f.style.left=a.uiUtil().getScrollLeft()+(a.uiUtil().getViewportWidth()-a.uiUtil().getNumSize(a.uiUtil().getStyle(f,"width","width")))/2+"px";f.style.display="block";var r=0,t=0,s=0,p=0;0==window.orientation||180==window.orientation?(r=a.uiUtil().getViewportWidth(),t=a.uiUtil().getViewportHeight()):(s=a.uiUtil().getViewportWidth(),p=a.uiUtil().getViewportHeight());window.addEventListener("orientationchange",function(){var h=0,e=0;"android chrome"==a.browserName||"unknown"==a.browserName?0==window.orientation||180==window.orientation?0<r?(h=r,e=t):(h=p+87,e=s-40):0<s?(h=s,e=p):(h=t+87,e=r-40):(h=a.uiUtil().getViewportWidth(),e=a.uiUtil().getViewportHeight());var g=a.uiUtil().getNumSize(a.uiUtil().getStyle(f,"width","width"));-1<g&&(h=a.uiUtil().getScrollLeft()+(h-g)/2+"px",f.style.left=h);h=a.uiUtil().getNumSize(a.uiUtil().getStyle(f,"height","height"));e=-1===h?a.uiUtil().getScrollTop()+e/6:a.uiUtil().getScrollTop()+(e-h)/3;f.style.top=e+"px";l&&l()});a.uiLayerLevel+=10;a.ESVS.TabIndex+=30;setTimeout(function(){var a=f.getElementsByTagName("a");if(0<a.length)for(var e=0;e<a.length;e++)"m-us-view-tab-simple"==a[e].id&&a[e].focus()},10)},hide:function(){m.style.display="none";f.style.display="none"},dispose:function(){window.addEventListener("orientationchange",function(){l&&l()});f.parentNode.parentNode.removeChild(f.parentNode);m.parentNode.removeChild(m);a.uiLayerLevel-=10;a.ESVS.TabIndex-=30}}}};