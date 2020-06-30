var __mobileselect=function(b){var q=function(h){function n(a){if(!a)return alert("UI load error."),!1;var b=document.createElement("div");document.body.insertBefore(b,document.body.firstChild);b.innerHTML=a;return!0}function k(a){var b=["mobiletoken","mobilephone"];p=a;for(var c in b)a==c?document.getElementById("us-btn-storage-"+b[c]).className="us-layout-storage-btn-on":document.getElementById("us-btn-storage-"+b[c]).className="us-layout-storage-btn-off"}function e(a){if(null==a||void 0==a)return!1;var f=!b.uiUtil().isItSupportingThisStorage(a);!1==f&&null!=b.ESVS.Media&&null!=b.ESVS.Media.list&&0>b.ESVS.Media.list.indexOf(a.name)&&(f=!0);if(f)return!1;var f=document.getElementById("us-btn-mobile-btn-list"),c=document.createElement("li");c.setAttribute("id","us-mobile-btn-li-"+a.name,0);c.setAttribute("mediaIndex",a.mediaIndex,0);7==a.mediaIndex&&(c.className="line-first");"hidden"===a.visibility?(c.style.display="none",c.style.visibility="hidden"):(c.style.display="block",c.style.visibility="visible");var d=document.createElement("button");d.setAttribute("type","button",0);d.setAttribute("id","us-btn-storage-"+a.name,0);d.setAttribute("title",a.label,0);d.setAttribute("tabindex",a.tabIndex,0);a.disabled?(d.onclick=function(){b.uiUtil().msgBox(q.IDS_MSGBOX_NOT_SUPPORTED_MEDIA)},d.className="us-layout-storage-btn-none"):(d.onclick=a.onclick,d.className="us-layout-storage-btn-off");c.appendChild(d);if("harddisk"!==a.name&&"webstorage"!==a.name){var g=document.createElement("span");g.className="us-drive-select";d.appendChild(g)}g=document.createElement("span");g.className="us-img-storage";var e=document.createElement("img");e.setAttribute("id","us-img-mobile-"+a.name,0);e.setAttribute("alt",a.label,0);a.disabled?e.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/media_"+a.name+"_d.png",0):e.setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/media_"+a.name+".png",0);g.appendChild(e);d.appendChild(g);g=document.createElement("span");g.setAttribute("id","us-lbl-mobile-"+a.name,0);g.className="us-layout-lbl-storage";g.appendChild(document.createTextNode(a.label));d.appendChild(g);c.appendChild(d);f.appendChild(c);return!0}var l=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/layout/mobileselect.html?version="+b.ver,!1);a.send(null);return a.responseText},r=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/lang/mobileselect_"+b.ESVS.Language+".js?version="+b.ver,!1);a.send(null);return a.responseText},q=eval(eval(r)()),m=b.ESVS.TabIndex,p=null;return function(){var a=eval(l),f=eval(eval(r)());n(a());a=document.getElementById("us-mobile-select-lbl-title");a.appendChild(document.createTextNode(f.IDS_STORAGE_SELECTION));a.setAttribute("tabindex",m++,0);document.getElementById("us-mobile-select-cls-btn-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);var c=b.CONST.medias.mobiletoken;c.label=f.IDS_STORAGE_MOBILETOKEN;c.onclick=function(){k(0)};c.tabIndex=m++;c.mediaIndex=1;c.visibility="visible";e(c);c=b.CONST.medias.mobilephone;c.label=f.IDS_STORAGE_MOBILEPHONE;c.onclick=function(){k(1)};c.tabIndex=m++;c.mediaIndex=2;c.visibility="visible";e(c);c=document.getElementById("us-mobile-select-confirm-btn");c.setAttribute("value",f.IDS_CONFIRM,0);c.setAttribute("title",f.IDS_CONFIRM,0);c.setAttribute("tabindex",m++,0);c.onclick=function(){if(null==p)alert(f.IDS_MSGBOX_ERROR_PLEASE_SELECT_STORAGE);else h.onConfirm(p)};var d=document.getElementById("us-mobile-select-cancel-btn");d.setAttribute("value",f.IDS_CANCEL,0);d.setAttribute("title",f.IDS_CANCEL,0);d.setAttribute("tabindex",m++,0);d.onclick=function(){h.onCancel()};var g=document.getElementById("us-mobile-select-cls-img-btn");g.setAttribute("title",f.IDS_STORAGE_SELECTION_CLOSE,0);g.setAttribute("tabindex",m++,0);g.onclick=function(){h.onCancel()};b.uiUtil().setRotationTabFocus(d,c,a);b.uiUtil().setRotationTabFocus(a,d,b.CONST.medias.mobiletoken);return document.getElementById("us-div-mobile-select")}()};return function(h){var n=b.uiLayerLevel,k=b.uiUtil().getOverlay(n),e=q({type:h.type,args:h.args,onConfirm:h.onConfirm,onCancel:h.onCancel});e.style.zIndex=n+1;b.ESVS.TargetObj.insertBefore(k,b.ESVS.TargetObj.firstChild);var l=window.onresize;return{show:function(){draggable(e,document.getElementById("us-div-mobile-select-title"));k.style.display="block";b.uiUtil().offsetResize(e);window.onresize=function(){b.uiUtil().offsetResize(e);l&&l()};b.uiLayerLevel+=10;b.ESVS.TabIndex+=30;setTimeout(function(){b.uiUtil().setFirstFocus("us-mobile-select-lbl-title")},10)},hide:function(){k.style.display="none";e.style.display="none"},dispose:function(){window.onresize=function(){l&&l()};e.parentNode.parentNode.removeChild(e.parentNode);k.parentNode.removeChild(k);b.uiLayerLevel-=10;b.ESVS.TabIndex-=30}}}};