var __swinfo=function(b){var m=function(f){function k(a){if(!a)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=a;return!0}var g=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/layout/swinfo.html?V="+b.ver,!1);a.send(null);return a.responseText},d=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/lang/swinfo_"+b.ESVS.Language+".js?V="+b.ver,!1);a.send(null);return a.responseText},e=b.ESVS.TabIndex;return function(){var a=eval(g),c=eval(eval(d)());k(a());a=document.getElementById("us-sw-info-lbl-title");a.appendChild(document.createTextNode(c.IDS_SW_INFO));a.setAttribute("tabindex",e,0);var l=document.getElementById("us-sw-info-lbl");l.setAttribute("tabindex",e+1,0);var h="";1&b.ESVS.Mode?b.plugin().valid?(h=b.plugin().version,a=c.IDS_SW_NAME+" v"+h+"<br><br>"+c.IDS_COPY_RIGHT,l.innerHTML=a):b.uiUtil().msgBox(c.IDS_MSGBOX_PLUGIN_ERROR_UNLOAD):4&b.ESVS.Mode?b.nimservice()?b.nimservice().Version(function(a){h=a;a=h.split(".");h=a[0]+a[1]+a[2];l.innerHTML=c.IDS_SW_NAME+" v"+b.ver+", v"+a[0]+"."+a[1]+"."+a[2]+".0<br><br>"+c.IDS_COPY_RIGHT;b.uiUtil().loadingBox(!1,"us-div-list-load")}):b.uiUtil().msgBox(c.IDS_MSGBOX_NIM_ERROR_UNLOAD):(h=b.ver,a=c.IDS_SW_NAME+" v"+h+"<br><br>"+c.IDS_COPY_RIGHT,l.innerHTML=a);a=document.getElementById("us-sw-info-confirm-btn");a.setAttribute("value",c.IDS_CONFIRM,0);a.setAttribute("title",c.IDS_CONFIRM+c.IDS_BUTTON,0);a.setAttribute("tabindex",e+2,0);a.onclick=function(){f.onConfirm()};a=document.getElementById("us-sw-info-cls-img-btn");a.setAttribute("title",c.IDS_SW_INFO_CLOSE,0);a.setAttribute("tabindex",e+3,0);a.onclick=function(){f.onCancel()};document.getElementById("us-sw-info-cls-btn-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);return document.getElementById("us-div-sw-info")}()};return function(f){var k=b.uiLayerLevel,g=b.uiUtil().getOverlay(k),d=m({type:f.type,args:f.args,onConfirm:f.onConfirm,onCancel:f.onCancel});d.style.zIndex=k+1;b.ESVS.TargetObj.insertBefore(g,b.ESVS.TargetObj.firstChild);var e=window.onresize;return{show:function(){draggable(d,document.getElementById("us-div-sw-info-title"));g.style.display="block";b.uiUtil().offsetResize(d);window.onresize=function(){b.uiUtil().offsetResize(d);e&&e()};b.uiLayerLevel+=10;b.ESVS.TabIndex+=30;setTimeout(function(){var a=d.getElementsByTagName("p");if(0<a.length)for(var b=0;b<a.length;b++)"us-sw-info-lbl-title"==a[b].id&&a[b].focus()},10)},hide:function(){g.style.display="none";d.style.display="none"},dispose:function(){window.onresize=function(){e&&e()};d.parentNode.parentNode.removeChild(d.parentNode);g.parentNode.removeChild(g);b.uiLayerLevel-=10;b.ESVS.TabIndex-=30}}}};