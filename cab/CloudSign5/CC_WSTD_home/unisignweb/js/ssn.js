var __ssn=function(b){var k=function(f){function h(a){if(!a)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=a;return!0}var g=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/layout/ssn.html?version="+b.ver,!1);a.send(null);return a.responseText},d=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/lang/ssn_"+b.ESVS.Language+".js?version="+b.ver,!1);a.send(null);return a.responseText},e=b.ESVS.TabIndex;return function(){var a=eval(g),c=eval(eval(d)());h(a());a=document.getElementById("us-ssn-lbl-title");a.appendChild(document.createTextNode(c.IDS_SSN));a.setAttribute("tabindex",e,0);document.getElementById("us-ssn-cls-btn-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);document.getElementById("us-ssn-notice-text").innerHTML=c.IDS_SSN_NOTICE+" ("+c.IDS_SSN_WARNING+")";document.getElementById("us-ssn-input-text").appendChild(document.createTextNode(c.IDS_SSN_NAME));a=document.getElementById("us-ssn-input-textbox");a.setAttribute("tabindex",e+1,0);a.onkeydown=function(a){if(a=a?a:event)a=a||window.event,13==(a.which||a.keyCode)&&document.getElementById("us-ssn-confirm-btn").click()};a=document.getElementById("us-ssn-confirm-btn");a.setAttribute("value",c.IDS_CONFIRM,0);a.setAttribute("title",c.IDS_CONFIRM+c.IDS_BUTTON,0);a.setAttribute("tabindex",e+2,0);a.onclick=function(){if(c){var a=document.getElementById("us-ssn-input-textbox");a.value?(f.onConfirm(a.value),a.value=""):(b.uiUtil().msgBox(c.IDS_MSGBOX_ERROR_PLEASE_INPUT_SSN),a.focus())}};a=document.getElementById("us-ssn-cancel-btn");a.setAttribute("value",c.IDS_CANCEL,0);a.setAttribute("title",c.IDS_CANCEL+c.IDS_BUTTON,0);a.setAttribute("tabindex",e+3,0);a.onclick=function(){f.onCancel()};a=document.getElementById("us-ssn-cls-btn");a.setAttribute("title",c.IDS_SSN_CLOSE,0);a.setAttribute("tabindex",e+4,0);a.onclick=function(){f.onCancel()};return document.getElementById("us-div-ssn")}()};return function(f){var h=b.uiLayerLevel,g=b.uiUtil().getOverlay(h),d=k({type:f.type,args:f.args,onConfirm:f.onConfirm,onCancel:f.onCancel});d.style.zIndex=h+1;b.ESVS.TargetObj.insertBefore(g,b.ESVS.TargetObj.firstChild);var e=window.onresize;return{show:function(){draggable(d,document.getElementById("us-div-ssn-title"));g.style.display="block";b.uiUtil().offsetResize(d);window.onresize=function(){b.uiUtil().offsetResize(d);e&&e()};b.uiLayerLevel+=10;b.ESVS.TabIndex+=30;setTimeout(function(){var a=d.getElementsByTagName("p");if(0<a.length)for(var b=0;b<a.length;b++)"us-ssn-lbl-title"==a[b].id&&a[b].focus()},10)},hide:function(){g.style.display="none";d.style.display="none"},dispose:function(){window.onresize=function(){e&&e()};d.parentNode.parentNode.removeChild(d.parentNode);g.parentNode&&g.parentNode.removeChild(g);b.uiLayerLevel-=10;b.ESVS.TabIndex-=30}}}};