var __certverify=function(c){var q=function(e){function n(d,b,g){if(!d||!b)return null;var a=null;if(1&c.ESVS.Mode){if(c.plugin().valid){console.log("*** Call VerifyCertWithCRL Func ***");var h=c.plugin().VerifyCertWithCRL(d);if(0===h)a=b.IDS_VERIFY_CERT_OK;else{var f=c.plugin().GetLastErrorCode();d=c.plugin().GetLastErrorMessage();console.log("*** VerifyCertWithCRL return error ***");console.log("Err Code : ",f,"\nErr Msg : ",d);switch(f){case 3001:a=b.IDS_VERIFY_CERT_ERROR_INVALID_TYPE;break;case 3002:a=b.IDS_VERIFY_CERT_ERROR_DECODING_FAIL;break;case 3003:a=b.IDS_VERIFY_CERT_ERROR_LOADING_FAIL;break;case 3005:a=b.IDS_VERIFY_CERT_ERROR_EXPIRED;break;case 3009:a=b.IDS_VERIFY_CERT_ERROR_NO_DP;break;case 3010:a=b.IDS_VERIFY_CERT_ERROR_WRONG_DP;break;case 3013:a=b.IDS_VERIFY_CERT_ERROR_WRONG_CRL+"<br><br>Code [ "+f+" ]";break;case 3014:a=b.IDS_VERIFY_CERT_ERROR_EXPIRED_CRL;break;case 3015:a=b.IDS_VERIFY_CERT_ERROR_WRONG_CRL+"<br><br>Code [ "+f+" ]";break;case 3016:a=b.IDS_VERIFY_CERT_ERROR_HOLDED+"<br><br>Code [ "+f+" ]";break;case 3017:a=b.IDS_VERIFY_CERT_ERROR_REVOKED+"<br><br>Code [ "+f+" ]";break;case 3059:a=b.IDS_VERIFY_CERT_ERROR_GETTING_CRL_FROM_LDAP_FAIL;break;case 3060:a=b.IDS_VERIFY_CERT_ERROR_CHECKING_ISSUER_FAIL;break;case 3062:a=b.IDS_VERIFY_CERT_ERROR_CA_CERT_PATH;break;case 3063:a=b.IDS_VERIFY_CERT_ERROR_ROOTCA_CERT_PATH;break;case 3900:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_UNSUPERSEDED;break;case 3901:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_KEYCOMPROMISE;break;case 3902:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_CACOMPROMISE;break;case 3903:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_AFFILIATIONCHANGED;break;case 3904:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_SUPERSEDED;break;case 3905:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_CESSATIONOFOPERATION;break;case 3906:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_HOLD;break;case 3907:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_REMOVEFROMCRL;break;case 3908:a=b.IDS_VERIFY_CERT_ERROR_REVOKED+"<br><br>Code [ "+f+" ]";break;case 3909:a=b.IDS_VERIFY_CERT_ERROR_REVOKED+"<br><br>Code [ "+f+" ]";break;case 3999:a=b.IDS_VERIFY_CERT_ERROR_EXPIRED+"<br><br>Code [ "+f+" ]";break;default:a=b.IDS_VERIFY_CERT_ERROR_UNKNOWN+"<br><br>Code [ "+f+" ]"}}}else c.uiUtil().msgBox(b.IDS_MSGBOX_PLUGIN_ERROR_UNLOAD),a=null;return a}if(4&c.ESVS.Mode)if(c.nimservice())c.nimservice().ValidateCertificate(d,function(c,d,f,h){if(0==c)if(999==f)a=b.IDS_VERIFY_CERT_OK;else switch(f){case 0:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_UNSUPERSEDED;break;case 1:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_KEYCOMPROMISE;break;case 2:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_CACOMPROMISE;break;case 3:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_AFFILIATIONCHANGED;break;case 4:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_SUPERSEDED;break;case 5:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_CESSATIONOFOPERATION;break;case 6:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_HOLD;break;case 8:a=b.IDS_VERIFY_CERT_ERROR_REVOKED_REMOVEFROMCRL;break;case 9:a=b.IDS_VERIFY_CERT_ERROR_REVOKED+"<br><br>Code [ "+f+" ]";break;case 10:a=b.IDS_VERIFY_CERT_ERROR_REVOKED+"<br><br>Code [ "+f+" ]";break;case 11:a=b.IDS_VERIFY_CERT_ERROR_EXPIRED;break;default:a=b.IDS_VERIFY_CERT_ERROR_UNKNOWN+"<br><br>Code [ "+f+" ]"}else a=d;g(a)});else return c.uiUtil().msgBox(b.IDS_MSGBOX_NIM_ERROR_UNLOAD),a=null;else if(2==c.ESVS.Mode){var e=null;try{var k=c.usWebToolkit.pki.createCaStore(),e=c.PFSH.GetCACerts(),l;for(l in e)caCert=e[l],k.addCertificate(c.usWebToolkit.pki.certificateFromBase64(caCert));if(null==c.certsList||null==c.certsList.list||0>=c.certsList.list.length)return"";var n=c.usWebToolkit.pki.certificateFromBase64(c.certsList.list[d-1].cert);c.usWebToolkit.pki.verifyCertificateChain(k,n,function(c,d,e){!0===c?(h=0,a=b.IDS_VERIFY_CERT_OK):(h=-1,null!=e&&void 0!=e&&0<=e.indexOf("Certificate is not valid yet or has expired")?(f=3005,a=b.IDS_VERIFY_CERT_ERROR_EXPIRED):null!=e&&void 0!=e&&0<=e.indexOf("no parent issuer, so certificate not trusted")?(f=3060,a=b.IDS_VERIFY_CERT_ERROR_CHECKING_ISSUER_FAIL):(f=-1,a=e));g(a)})}catch(m){f=m.code,a=m.message,g(a)}}}function k(c){if(!c)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=c;return!0}var h=function(){var d;d=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");d.open("GET",c.ESVS.SRCPath+"unisignweb/rsrc/layout/certverify.html?V="+c.ver,!1);d.send(null);return d.responseText},l=function(){var d;d=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");d.open("GET",c.ESVS.SRCPath+"unisignweb/rsrc/lang/certverify_"+c.ESVS.Language+".js?V="+c.ver,!1);d.send(null);return d.responseText},m=c.ESVS.TabIndex;return function(){var d=eval(h),b=eval(eval(l)()),g=e.args.idx;k(d());d=document.getElementById("us-cert-verify-lbl-title");d.appendChild(document.createTextNode(b.IDS_VERIFY_CERT));d.setAttribute("tabindex",m,0);var a=document.getElementById("us-cert-verify-lbl");4&c.ESVS.Mode||2&c.ESVS.Mode?n(g,b,function(b){b&&a&&(a.innerHTML=b,a.setAttribute("tabindex",m+1,0))}):(g=n(g,b))&&a&&(a.innerHTML=g,a.setAttribute("tabindex",m+1,0));g=document.getElementById("us-cert-verify-confirm-btn");g.setAttribute("value",b.IDS_CONFIRM,0);g.setAttribute("title",b.IDS_CONFIRM+b.IDS_BUTTON,0);g.setAttribute("tabindex",m+2,0);g.onclick=function(){e.onConfirm()};var p=document.getElementById("us-cert-verify-cls-img-btn");p.setAttribute("title",b.IDS_VERIFY_CERT_CLOSE,0);p.setAttribute("tabindex",m+3,0);p.onclick=function(){e.onCancel()};document.getElementById("us-cert-verify-cls-btn-img").setAttribute("src",c.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);c.uiUtil().setRotationTabFocus(g,a,d);c.uiUtil().setRotationTabFocus(d,g,a);return document.getElementById("us-div-cert-verify")}()};return function(e){var n=c.uiLayerLevel,k=c.uiUtil().getOverlay(n),h=q({type:e.type,args:e.args,onConfirm:e.onConfirm,onCancel:e.onCancel});h.style.zIndex=n+1;c.ESVS.TargetObj.insertBefore(k,c.ESVS.TargetObj.firstChild);var l=window.onresize;return{show:function(){draggable(h,document.getElementById("us-div-cert-verify-title"));k.style.display="block";c.uiUtil().offsetResize(h);window.onresize=function(){c.uiUtil().offsetResize(h);l&&l()};c.uiLayerLevel+=10;c.ESVS.TabIndex+=30;setTimeout(function(){c.uiUtil().setFirstFocus("us-cert-verify-lbl-title")},10)},hide:function(){k.style.display="none";h.style.display="none"},dispose:function(){window.onresize=function(){l&&l()};h.parentNode.parentNode.removeChild(h.parentNode);k.parentNode.removeChild(k);c.uiLayerLevel-=10;c.ESVS.TabIndex-=30}}}};