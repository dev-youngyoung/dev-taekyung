var __newpassword=function(b){var m=function(g){function l(){var a=document.getElementById("us-new-password-first-textbox").value,c=document.getElementById("us-password-check-rule1"),d=document.getElementById("us-password-check-rule2"),h=document.getElementById("us-password-check-rule3"),f=document.getElementById("us-password-check-rule4"),g=document.getElementById("us-password-check-rule5"),e=!0;b.ESVS.LimitMinNewPWLen<=a.length?c.className="check":(c.className="",e=!1);"NPKI"===b.ESVS.PKI||2===b.ESVS.LimitNewPWPattern?(c=/^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[^a-zA-Z0-9])/g,c.exec(a)?d.className="check":(d.className="",e=!1)):1===b.ESVS.LimitNewPWPattern&&(c=/^(?=.*[a-zA-Z])(?=.*[0-9])/g,c.exec(a)?d.className="check":(d.className="",e=!1));if("NPKI"===b.ESVS.PKI)if(c=/['"\\|]/g,c.exec(a)?(g.className="",e=!1):g.className="check",2<a.length){for(d=0;d<a.length-2;d++)if(a.charAt(d)===a.charAt(d+1)&&a.charAt(d)===a.charAt(d+2)){h.className="";e=!1;break}else h.className="check";for(d=0;d<a.length-2;d++)if(a.charCodeAt(d)===a.charCodeAt(d+1)-1&&a.charCodeAt(d)===a.charCodeAt(d+2)-2){f.className="";e=!1;break}else f.className="check"}else h.className="check",f.className="check";return e}function e(a){var c=document.getElementById("us-new-password-first-textbox"),d=document.getElementById("us-new-password-second-textbox");"touchen"==b.ESVS.SecureKeyboardType&&b.bsUtil().isTouchEnKeyUsable()&&(c.value=b.bsUtil().GetEncryptPwd("us-keyboard-secure-frm","us-new-password-first-textbox"),d.value=b.bsUtil().GetEncryptPwd("us-keyboard-secure-frm2","us-new-password-second-textbox"));if(!c.value)return b.uiUtil().msgBox(a.IDS_MSGBOX_ERROR_PLEASE_INPUT_NEW_PASSWORD),c.focus(),!1;if(b.ESVS.LimitMaxNewPWLen<c.value.length)return b.uiUtil().msgBox(b.ESVS.LimitMaxNewPWLen+a.IDS_MSGBOX_ERROR_LONGER_THAN_LIMIT_MAX_LENGTH),c.focus(),!1;if(!l())return b.uiUtil().msgBox(a.IDS_MSGBOX_ERROR_CANT_PASS_RULES),c.focus(),!1;if(c.value!=d.value)return b.uiUtil().msgBox(a.IDS_MSGBOX_ERROR_PLEASE_RETRY_TO_INPUT_CORRECTLY),c.focus(),!1;g.onConfirm(c.value);c.value="";d.value="";return!0}var f=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/layout/newpassword.html?V="+b.ver,!1);a.send(null);return a.responseText},k=function(){var a;a=window.XMLHttpRequest?new window.XMLHttpRequest:new ActiveXObject("MSXML2.XMLHTTP.3.0");a.open("GET",b.ESVS.SRCPath+"unisignweb/rsrc/lang/newpassword_"+b.ESVS.Language+".js?V="+b.ver,!1);a.send(null);return a.responseText},h=b.ESVS.TabIndex;return function(){var a=eval(f),c=eval(eval(k)());b.ESVS.TargetObj.innerHTML=a();a=document.getElementById("us-new-password-lbl-title");a.appendChild(document.createTextNode(c.IDS_NEW_PASSWORD));a.setAttribute("tabindex",h,0);document.getElementById("us-new-password-cls-btn-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/x-btn.png",0);document.getElementById("us-new-password-lock-img").setAttribute("src",b.ESVS.SRCPath+"unisignweb/rsrc/img/password-lock-img.png",0);document.getElementById("us-new-password-notice-text").innerHTML=c.IDS_NEW_PASSWORD_NOTICE+"<br>("+b.ESVS.LimitMinNewPWLen+c.IDS_NEW_PASSWORD_LIMIT+")";document.getElementById("us-new-password-first-lbl").appendChild(document.createTextNode(c.IDS_NEW_PASSWORD_FIRST));a=document.getElementById("us-new-password-first-textbox");a.setAttribute("tabindex",h+1,0);a.onkeyup=function(a){l()};document.getElementById("us-new-password-second-lbl").appendChild(document.createTextNode(c.IDS_NEW_PASSWORD_SECOND));document.getElementById("us-new-password-second-textbox").setAttribute("tabindex",h+2,0);document.getElementById("us-password-check-rule1").appendChild(document.createTextNode(b.ESVS.LimitMinNewPWLen+""+c.IDS_PASSWORD_RULE1));"NPKI"===b.ESVS.PKI?(a=document.getElementById("us-password-check-rule2"),a.appendChild(document.createTextNode(c.IDS_PASSWORD_RULE2_ALL)),document.getElementById("us-password-check-rule3").appendChild(document.createTextNode(c.IDS_PASSWORD_RULE3)),document.getElementById("us-password-check-rule4").appendChild(document.createTextNode(c.IDS_PASSWORD_RULE4)),document.getElementById("us-password-check-rule5").appendChild(document.createTextNode(c.IDS_PASSWORD_RULE5))):(a=document.getElementById("us-password-check-rule2"),1===b.ESVS.LimitNewPWPattern?a.appendChild(document.createTextNode(c.IDS_PASSWORD_RULE2_ENGNUM)):2===b.ESVS.LimitNewPWPattern&&a.appendChild(document.createTextNode(c.IDS_PASSWORD_RULE2_ALL)));document.getElementById("us-new-password-warning-text").appendChild(document.createTextNode(c.IDS_NEW_PASSWORD_WARNING));a=document.getElementById("us-new-password-confirm-btn");a.setAttribute("value",c.IDS_CONFIRM,0);a.setAttribute("title",c.IDS_CONFIRM+c.IDS_BUTTON,0);a.setAttribute("tabindex",h+3,0);a.onclick=function(){e(c)};a=document.getElementById("us-new-password-cancel-btn");a.setAttribute("value",c.IDS_CANCEL,0);a.setAttribute("title",c.IDS_CANCEL+c.IDS_BUTTON,0);a.setAttribute("tabindex",h+4,0);a.onclick=function(){g.onCancel()};a=document.getElementById("us-new-password-cls-img-btn");a.setAttribute("title",c.IDS_NEW_PASSWORD_CLOSE,0);a.setAttribute("tabindex",h+5,0);a.onclick=function(){g.onCancel()};return document.getElementById("us-div-new-password")}()};return function(g){var l=b.uiLayerLevel,e=b.uiUtil().getOverlay(l),f=m({type:g.type,args:g.args,onConfirm:g.onConfirm,onCancel:g.onCancel});f.style.zIndex=l+1;b.ESVS.TargetObj.insertBefore(e,b.ESVS.TargetObj.firstChild);var k=window.onresize;return{show:function(){draggable(f,document.getElementById("us-div-new-password-title"));e.style.display="block";b.uiUtil().offsetResize(f);window.onresize=function(){b.uiUtil().offsetResize(f);k&&k()};b.uiLayerLevel+=10;b.ESVS.TabIndex+=30;setTimeout(function(){var e=f.getElementsByTagName("p");if(0<e.length)for(var a=0;a<e.length;a++)"us-new-password-lbl-title"==e[a].id&&e[a].focus();b.bsUtil().SetSecurityStatus("us-new-password-first-textbox");b.bsUtil().SetSecurityStatus("us-new-password-second-textbox");b.bsUtil().SetReScan("us-keyboard-secure-frm","us-new-password-first-textbox");b.bsUtil().SetReScan("us-keyboard-secure-frm2","us-new-password-second-textbox")},10)},hide:function(){e.style.display="none";f.style.display="none"},dispose:function(){window.onresize=function(){k&&k()};f.parentNode.removeChild(f);e.parentNode.removeChild(e);b.uiLayerLevel-=10;b.ESVS.TabIndex-=30}}}};