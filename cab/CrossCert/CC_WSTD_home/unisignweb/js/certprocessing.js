var __certprocessing=function(b){var e=null,m=function(c){var h=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/layout/certprocessing.html?V="+b.ver,!1);a.send(null);return a.responseText},k=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/lang/certprocessing_"+b.ESVS.Language+".js?V="+b.ver,!1);a.send(null);return a.responseText};return function(){var a=eval(h),f=eval(eval(k)());e=f;b.ESVS.TargetObj.innerHTML=a();document.getElementById("us-cert-processing-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/processing-img.gif",0);a=document.getElementById("us-cert-processing-text");"CERT_ISSUE"==c.type?a.appendChild(document.createTextNode(f.IDS_CERT_ISSUING)):"CERT_RENEWAL"==c.type?a.appendChild(document.createTextNode(f.IDS_CERT_RENEWING)):"CERT_REVOCATION"==c.type?a.appendChild(document.createTextNode(f.IDS_CERT_REVOKING)):"CERT_SOE"==c.type&&a.appendChild(document.createTextNode(f.IDS_CERT_SOEING));return document.getElementById("us-div-cert-processing")}()};return function(c){var h=b.uiLayerLevel,k=b.uiUtil().getOverlay(h);k.style.cursor="wait";var a=m({type:c.type,args:c.args,onConfirm:c.onConfirm,onCancel:c.onCancel});a.style.zIndex=h+1;b.ESVS.TargetObj.insertBefore(k,b.ESVS.TargetObj.firstChild);var f=window.onresize;return{show:function(){draggable(a);k.style.display="block";b.uiUtil().offsetResize(a);window.onresize=function(){b.uiUtil().offsetResize(a);f&&f()};b.uiLayerLevel+=10;b.ESVS.TabIndex+=30},hide:function(){k.style.display="none";a.style.display="none"},dispose:function(g,l,h,m,n){window.onresize=function(){f&&f()};var d=null;if(m)if("CERT_ISSUE"==c.type)if(0!=g)switch(l){default:d=e.IDS_MSGBOX_CERT_ISSUE_ERROR+"<br><br>"+h+"<br><br>Error Code [ "+l+" ]"}else d=e.IDS_MSGBOX_CERT_ISSUED;else if("CERT_RENEWAL"==c.type)if(0!=g)switch(l){default:d=e.IDS_MSGBOX_CERT_RENEW_DENIED_ERROR+"<br><br>"+h+"<br><br>Error Code [ "+l+" ]"}else d=e.IDS_MSGBOX_CERT_RENEWED;else if("CERT_REVOCATION"==c.type)if(0==g)d=e.IDS_MSGBOX_CERT_REVOKED;else if("object"===typeof g)d=e.IDS_MSGBOX_CERT_REVOKE_DENIED_ERROR+"<br><br>"+g.msg+"<br><br>Error Code [ "+g.code+" ]";else switch(l){default:d=e.IDS_MSGBOX_CERT_REVOKE_DENIED_ERROR+"<br><br>"+h+"<br><br>Error Code [ "+l+" ]"}else if("CERT_SOE"==c.type)if(0!=g)switch(l){default:d=e.IDS_MSGBOX_CERT_SOE_DENIED_ERROR+"<br><br>"+h+"<br><br>Error Code [ "+l+" ]"}else d=e.IDS_MSGBOX_CERT_SOEED;g=a.parentNode;null!=g&&g.removeChild(a);null!=k.parentNode&&k.parentNode.removeChild(k);b.uiLayerLevel-=10;b.ESVS.TabIndex-=30;if(d){var p=b.loadUI("notice")({type:null,args:{msg:d},onConfirm:function(){p.dispose();n()},onCancel:function(){p.dispose();n()}});p.show()}else n()}}}};