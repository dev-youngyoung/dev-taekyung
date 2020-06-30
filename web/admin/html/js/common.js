var isIE = ((navigator.userAgent.indexOf("Microsoft")!= -1) || (navigator.userAgent.indexOf("Trident") != -1)) ? 1 : 0;

function SetCookie(name, value, expires, path, domain, secure) { //expires => 초
	var date = new Date();
	date.setSeconds(date.getSeconds() + expires);

	document.cookie= name + "=" + escape(value) + "; path=" + ((path) ? path : "/") +
	((expires) ? "; expires=" + date.toGMTString() : "") +
	((domain) ? "; domain=" + domain : "") +
	((secure) ? "; secure" : "");
}

function GetCookie(name) {
	var dc = document.cookie;
	var prefix = name + "=";
	var begin = dc.indexOf("; " + prefix);
	if (begin == -1) {
		begin = dc.indexOf(prefix);
		if (begin != 0) return null;
	} else {
		begin += 2;
	}
	var end = document.cookie.indexOf(";", begin);
	if (end == -1) {
		end = dc.length;
	}
	return unescape(dc.substring(begin + prefix.length, end));
}

function DelCookie(name, path, domain)
{
    if (GetCookie(name)) {
        document.cookie = name + "=" + 
            ((path) ? "; path=" + path : "") +
            ((domain) ? "; domain=" + domain : "") +
            "; expires=Thu, 01-Jan-70 00:00:01 GMT";
    }
}

/*
function OpenDialog(nLink, nWin, nWidth, nHeight, xPos, yPos) {
	if(typeof nLink == "object") url = nLink.href;
	else url = nLink;
	var qResult = window.showModalDialog( url, nWin, "dialogwidth:"+nWidth+"px;dialogheight:"+nHeight+"px;toolbar:no;location:no;help:no;directories:no;status:no;menubar:no;scroll:no;resizable:no");
}
*/
function OpenDialog(nLink, nWin, nWidth, nHeight,scroll) {
	if(typeof nLink == "object") url = nLink.href;
	else url = nLink;
	var qResult = window.showModalDialog( url, nWin, "dialogwidth:"+nWidth+"px;dialogheight:"+nHeight+"px;toolbar:no;location:no;help:no;directories:no;status:no;menubar:no;scroll:"+scroll+";resizable:no");
	return qResult
}

function OpenWindow(nLink, nTarget, nWidth, nHeight, xPos, yPos) {
	if(typeof nLink == "object") url = nLink.href;
	else url = nLink;

	adjX = xPos ? xPos : (window.screen.width/2 - nWidth/2);
	adjY = yPos ? yPos : (window.screen.height/2 - nHeight/2 - 50);
	var qResult = window.open( url, nTarget, "width="+nWidth+", height="+nHeight+",left="+adjX+",top="+adjY+",toolbar=no,status=yes,scrollbars=no,resizable=no");
	qResult.focus();
	//return qResult;
}

function OpenWindows(nLink, nTarget, nWidth, nHeight, xPos, yPos) {
	if(typeof nLink == "object") url = nLink.href;
	else url = nLink;

	adjX = xPos ? xPos : (window.screen.width/2 - nWidth/2);
	adjY = yPos ? yPos : (window.screen.height/2 - nHeight/2 - 50);
	var qResult = window.open( url, nTarget, "width="+nWidth+", height="+nHeight+",left="+adjX+",top="+adjY+",toolbar=no,status=yes,scrollbars=1,resizable=no");
	qResult.focus();
	//return qResult;
}

function ConfirmAction(obj) {
	if(confirm(obj.value + " 하시겠습니까?")) {
		location.href = obj.href;
	}
}

function BtnConfirmGo(obj, url) {
	var msg;
	if(typeof obj == "object") msg = obj.value;
	else msg = obj;
	if(confirm(msg + "하시겠습니까?")) {
		location.href = url;
	}
}

function Go(url) {
	location.href = url;
}

function IfGo(msg, url, url2) {
	if(confirm(msg)) Go(url);
	else {
		if(!url2) return false;
		else Go(url2);
	}
	return true;
}

function ConfirmCheckGo(f, n, url, msg) {
    var idx = GetFormValue(f, n);
    if(idx == "") {
        alert("선택 항목이 없습니다.");
    } else {
        if(confirm(msg)) {
            location.href = url + idx;
        }
    }
}

function ResizeImage(el, w, h) {
	var img = new Image();
	img.src = el.src;

	if(el.width > img.width) el.width = img.width;
	if(el.height > img.height) el.height = img.height;

	var sheight = el.width * img.height / img.width;
	var swidth = el.height * img.width / img.height;

	if(swidth < el.width) el.width = swidth;
	if(sheight < el.height) el.height = sheight;
}

function ShowLayer(n) {
	var el = document.getElementById(n);
	if(el) {
		el.style.display = 'block';
	}
}

function HideLayer(n) {
	var el = document.getElementById(n);
	if(el) {
		el.style.display = 'none';
	}
}

function AutoLayer(n) {
	var el = document.getElementById(n);
	if(!el) return;
	if(el.style.display == 'none') {
		el.style.display = 'block'
	} else {
		el.style.display = 'none'
	}
}

function validate(el) {
	return true;
}

function attEvent(eventNm, funcObj){
	if( window.attachEvent){  // IE의 경우
		window.attachEvent( eventNm, funcObj );
	}else{  // IE가 아닌 경우.
		window.addEventListener( eventNm, funcObj , false );
	}
}


function setElementValue(element, v, sep) {
	if(!element) return false;
	switch(element.type) {
		case 'text':
		case 'password':
		case 'hidden':
			element.setAttribute("value",v);
			break;
		case 'textarea':
			element.innerHTML = v;
			break;
		case 'checkbox':
			if(element.value == v) element.setAttribute("checked","true");
			break;
		case 'select-one':
			for(var i=0; i<element.options.length; i++) if(element.options[i].value == v) element.options[i].setAttribute("selected","true"); else element.options[i].removeAttribute("selected");
			break;
		default:
			if(sep) {
				var val = v.split(sep);
				for(var i=0; i<element.length; i++) {
					for(var j=0; j<val.length; j++) {
						if(element[i].value == val[j])  element[i].setAttribute("checked","true");
					}
				}
			}
			else {
				for(var i=0; i<element.length; i++) {
					if(element[i].value == v) element[i].checked.setAttribute("checked","true");			
				}
			}
			break;
	}
}
function SetFormValue(f, n, v, sep) {	
	var f = document.forms[f];
	if(!f || !f[n]) return false;
	switch(f[n].type) {
		case 'text':
		case 'password':
		case 'hidden':
			f[n].value = v;
			f[n].setAttribute("value",v);
			break;
		case 'textarea':
			f[n].value = v;
			f[n].innerHTML = v;
			break;
		case 'checkbox':
			if(f[n].value == v) f[n].setAttribute("checked","true");
			break;
		case 'select-one':
			for(var i=0; i<f[n].options.length; i++) f[n].options[i].removeAttribute("selected");
			for(var i=0; i<f[n].options.length; i++) if(f[n].options[i].value == v) f[n].options[i].setAttribute("selected","true");
			break;
		default:
			if(sep) {
				var val = v.split(sep);
				for(var i=0; i<f[n].length; i++) {
					for(var j=0; j<val.length; j++) {
						if(f[n][i].value == val[j]){
							f[n][i].setAttribute("checked","true");
						}
					}
				}
			}
			else {
				for(var i=0; i<f[n].length; i++) {
					if(f[n][i].value == v){
						f[n][i].setAttribute("checked","true");			
					}else{
						f[n][i].removeAttribute("checked");
					}
				}
			}
			break;
	}
}

function GetFormValue(f, n) {
	var f = document.forms[f];
	if(!f || !f[n]) return false;
	switch(f[n].type) {
		case 'text':
		case 'file':
		case 'password':
		case 'hidden':
			return f[n].value;
			break;
		case 'textarea':
			return f[n].text;
			break;
		case 'checkbox':
			if(f[n].checked == true) return f[n].value;
			break;
		case 'select-one':
			for(var i=0; i<f[n].options.length; i++) {
				if(f[n].options[i].selected == true) {
					return f[n].options[i].value;
				}
			}
			break;
		default:
			var arr = new Array();
			var j = 0;
			for(var i=0; i<f[n].length; i++) {
				if(f[n][i].checked == true) {
					 arr[j] = f[n][i].value;
					 j++;
				}
			}
			return arr.join(",");
			break;
	}
	return false;
}

var AUTO_CHECK_STATUS = true;

function AutoCheck(f, n, base) {
	var f = document.forms[f];
	if(!f || !f[n]) return;
	if(typeof(f[n]) == "object") {
		if(f[n].length > 0) {
			for(var i=0; i<f[n].length; i++) {
				if(base == null){
					f[n][i].checked = AUTO_CHECK_STATUS;
				}else{
					f[n][i].checked = f[base].checked;
				}
			}
		} else {
			if(base == null){
				f[n].checked = AUTO_CHECK_STATUS;
			}else{
				f[n].checked = f[base].checked;
			}
		}
		if(base == null){
			if(AUTO_CHECK_STATUS == true) {
				AUTO_CHECK_STATUS = false;
			} else {
				AUTO_CHECK_STATUS = true;
			}
		}
	}
}

function CheckGo(f, n, url, msg, confMsg) {
	var idx = GetFormValue(f, n);
	if(idx == "") {
		alert(msg);
	} else {
		if(confMsg && !confirm(confMsg)) return;
		if(url.indexOf("javascript:") != -1) {
			eval(url.replace("javascript:", ""));
		} else {
			location.href = url + idx;
		}
	}
}

/*
function CheckGo(f, n, url, msg) {
	var idx = GetFormValue(f, n);
	if(idx == "") {
		alert(msg);
	} else {
		location.href = url + idx;
	}
}
*/

function ResizeIframe(n) {
	var h;
	if(el = parent.document.getElementById(n)) {
		//el.height = 0;
		if(isIE) h = document.body.scrollHeight;
		else h = document.documentElement.scrollHeight;
		if(h > 10) el.height = h;
		else el.height = 0;
		el.style.height = el.height;
	}
}
function parentResizeIframe(n) {
	var h;
	if(el = parent.parent.document.getElementById(n)) {
		//el.height = 0;
		if(isIE) h = parent.document.body.scrollHeight;
		else h = parent.document.documentElement.scrollHeight;
		if(h > 10) el.height = h;
		else el.height = 0;
	}
}

function GoNext(fm,pos,size) {

	if(fm.elements[0].name == "PHPSESSID") {
		pos++;
	}

	next_pos = pos + 1;
	value = fm.elements[pos].value;
	len = value.length;
	is_num = Number(value);

	if(!is_num) {
		if((len > 0) && (value != '0') && (value != '00') && (value != '000')) {
			alert('숫자를 넣어주세요');
			fm.elements[pos].select();
			fm.elements[pos].focus();
			return false;
		}
	}
	
	if(len == size) {
		fm.elements[next_pos].focus();
		return true;
	}
}

function MoveNext(el, next, size) {
	var len = el.value.length;
	if(len == size) {
		next.focus();
		return true;
	}
}

function IsNumeric(sText)
{
   var ValidChars = "0123456789.-";
   var IsNumber=true;
   var Char;
 
   for (i = 0; i < sText.length && IsNumber == true; i++) { 
      Char = sText.charAt(i); 
      if (ValidChars.indexOf(Char) == -1) {
         IsNumber = false;
      }
   }

   return IsNumber;
}

function OnlyNumber(el) {
	if(!IsNumeric(el.value)) {
		el.value = "";
		el.focus();
	}
}

function PhotoViewer(el) {
	var photo = new PhotoLayer();
	photo.Initialized();
	photo.doPhotoClick(el);
}

function DrawBar(cnt, max, color, width) {
	var percent;
	if(!width) width = 400;
	if(max > 0) {
		percent = Math.floor((cnt / max) * 100);
	} else {
		percent = 0;
	}
	var other = 100 - percent;
	document.write("<table align='left' width='" + width + "' cellpadding=0 cellspacing=0 height=10><tr><td width='"+percent+"%' background='../html/images/stat/s_bg_"+color+".gif'></td><td width='"+ other +"%'></td></tr></table>");
}


function getEmbedTag(url, cls, cb, mt, d) {
	var h = '', n;
	h = '<embed type="' + mt + '" src="'+ url +'" alt="multiupload" wmode="transparent"></embed>';
	return h;
}

function call(url, id, callback) {

	if(!id) id = "AJAX_DIV";
	var client = false;

	if(window.ActiveXObject) {
		try {
			client = new ActiveXObject("Msxml2.XMLHTTP");
		} catch(e) {
			try {
				client = new ActiveXObject("Microsoft.XMLHTTP");
			} catch(e) {}
		}
	} else {
		client = new XMLHttpRequest();
	}
	if(client) {
		client.onreadystatechange = function() {
			if(client.readyState == 4) {

				//출력레이어가 없을 경우 생성
				var el = document.getElementById(id);
				if(!el) {
					el = document.createElement("div");
					el.style.display = 'none';
					document.body.appendChild(el);
				}
				
				//IE의 경우 버그가 존재함. 그래서 &nbsp를 추가
				/*
				if(isIE && client.responseText.indexOf("<script") > 0 ) {
					el.innerHTML = "<span style='display:none;'>&nbsp;</span>" + client.responseText;
				} else {
					el.innerHTML = client.responseText;
				}*/
				
				el.innerHTML = "<span style='display:none;'>&nbsp;</span>" + client.responseText;

				if(callback) {
					try {
						eval(callback + "(client.responseText)");
					} catch(e) { alert(callback + " 함수가 없습니다."); }
				}

				//자바스크립트 실행 (defer는 IE 에서 실행되어 안씀)
				var scripts = el.getElementsByTagName("script");
				for(var i=0; i<scripts.length; i++) {
					eval(scripts[i].innerHTML.replace("<!--", "").replace("-->", ""));
				}
			}
		}
		var f;
		if(f = document.forms[url]) {
			var parameters = "";
			for(var i=0; i<f.elements.length; i++) {
				if(f.elements[i].name == "") continue; 
				if(f.elements[i].type == "radio" || f.elements[i].type == "checkbox") {
					if(f.elements[i].checked == false) continue;
				}
				parameters += f.elements[i].name + "=" + encodeURI( f.elements[i].value ) + "&";
			}
			if(!f.action) f.action = location.href;
			client.open('POST', f.action, true);
			client.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			client.setRequestHeader("Content-Length", parameters.length);
			client.setRequestHeader("Connection", "close");
			client.send(parameters);
		} else {
			client.open("GET", url, true);
			client.send(null);
		}
	}


}

function docWrite(str) {
	document.write(str);
}


function ToggleLayer(objName, tarName, addX, addY) {
	var obj = document.getElementById(objName);
	if(!obj) {
		alert(objName + ' 레이어가 존재하지 않습니다.');
		return;
	}

	var tar = tarName ? document.getElementById(tarName) : null;
	if(tar) {
		var curleft = curtop = 0;
		if (tar.offsetParent) {
			do {
				curleft += tar.offsetLeft;
				curtop += tar.offsetTop;
			} while (tar = tar.offsetParent);
		}
		obj.style.position = "absolute";
		obj.style.left = curleft + (addX ? parseInt(addX) : 0);
		obj.style.top = curtop + (addY ? parseInt(addY) : 0);
	}	
	if(obj.style.display == "none") {
		obj.style.display = "block";
	} else {
		obj.style.display = "none";
	}
}

function ImageError(el, url) {
	if(url && url.toUpperCase() == "TEXTMODE") {
		if(el) el.parentNode.innerHTML = "<span><table width='" + (el.width * 1) + "' height='" + (el.height * 1)+ "' cellpadding='0' cellspacing='0' style='border:1px solid #f2f2f2;'><tr><td style='font-family:arial;color:#d0d0d0'>No Image.</td></tr></table></span>";
	} else {
		var noimg = new Image();
		noimg.src = url ? url : "/_god/html/images/viewer/img_no_photo2.gif";
		noimg.onerror = function() {
			alert("[개발 Debug] common.js - function ImageError() 오류 : \n" + noimg.src + ' 파일이 존재 하지 않습니다.');
			return false;
		}
		if(el) el.src = noimg.src;
	}
}



function changeYear(element, d, num) {
	if(!element) return;
	if(!num) num = 10;
	var year = parseInt(element.value * 1);
	if(!year) year = !d ? new Date().getFullYear() : d;
	year = parseInt(year * 1);
	var pattern = /[^0-9]/;
	var add = "";
	var head = "";
	if(element.options.length > 0) {
		add = pattern.test(element.options[element.selectedIndex].text);
		head = element.options[0].value == "" ? element.options[0].text : "";
		}
	element.options.length = 0; var j = 0;
	if(head) {
		element.options[0] = new Option(head, "", false);
		j++;
	}
	for (var i=year-num; i<=year+num; i++, j++) {
		element.options[j] = new Option(i + (add ? "년" : ""), i, false);
		if (i == year) element.options[j].selected = true;
	}
}

Offset = function(element) {
	this.obj = element;
	this.left;
	this.top;
	this.height;
	this.width;
	this.centerLeft;
	this.getOffset();
}       
Offset.prototype.getOffset = function() {
	var obj = this.obj;
	var top = left = 0;
	if (obj.offsetParent) {
		do {
			top += obj.offsetTop;
			left +=
			obj.offsetLeft;
		} while(obj = obj.offsetParent);
	}
	this.left = left;
	this.top = top;
	this.width = this.obj.offsetWidth;
	this.height = this.obj.offsetHeight;
	this.centerLeft = this.left + Math.round(this.width/2);
}

function number_format( number, decimals, dec_point, thousands_sep ) {
	// +   original by: Jonas Raoni Soares Silva (http://www.jsfromhell.com)
	// +   improved by: Kevin van Zonneveld (http://kevin.vanzonneveld.net)
	// *     example 1: number_format(1234.5678, 2, '.', '');
	// *     returns 1: 1234.57

	var i, j, kw, kd, km;

	// input sanitation & defaults
	if( isNaN(decimals = Math.abs(decimals)) ){
		decimals = 0;
	}
	if( dec_point == undefined ){
		dec_point = ".";
	}
	if( thousands_sep == undefined ){
		thousands_sep = ",";
	}

	i = parseInt(number = (+number || 0).toFixed(decimals)) + "";

	if( (j = i.length) > 3 ){
		j = j % 3;
	} else{
		j = 0;
	}

	km = (j ? i.substr(0, j) + thousands_sep : "");
	kw = i.substr(j).replace(/(\d{3})(?=\d)/g, "$1" + thousands_sep);
	kd = (decimals ? dec_point + Math.abs(number - i).toFixed(decimals).slice(2) : "");

	return km + kw + kd;
}

function addslashes( str ) {
    return str.replace('/(["\'\])/g', "\\$1").replace('/\0/g', "\\0");
}

function strip_tags(input,allowed){allowed=(((allowed||"")+"").toLowerCase().match(/<[a-z][a-z0-9]*>/g)||[]).join('');var tags=/<\/?([a-z][a-z0-9]*)\b[^>]*>/gi,commentsAndPhpTags=/<!--[\s\S]*?-->|<\?(?:php)?[\s\S]*?\?>/gi;return input.replace(commentsAndPhpTags,'').replace(tags,function($0,$1){return allowed.indexOf('<'+$1.toLowerCase()+'>')>-1?$0:'';});}

function in_array(needle, haystack, strict) {
    var found = false, key, strict = !!strict;
    for (key in haystack) {
        if ((strict && haystack[key] === needle) || (!strict && haystack[key] == needle)) {
            found = true;
            break;
        }
    }
    return found;
}

//var descpreload = new Image(); descpreload.src = "../html/images/s_desc.gif";
//var ascpreload = new Image(); ascpreload.src = "../html/images/s_asc.gif";
function ListSort(element, ord) {
	if(element) {
		document.forms['form1']['ord'].value = element.getAttribute("id").replace("CL_", "") + " " + (ord.indexOf(" ASC") != -1 ? "DESC" : "ASC");
		document.forms['form1'].submit();
	} else {
		var arr = ord.split(" ");
		var element = document.getElementById("CL_" + arr[0])
		if(element && arr.length == 2) {
			var arrow = arr[1] == "ASC" ? ' <img src="../html/images/s_asc.gif">' : ' <img src="../html/images/s_desc.gif">';
			element.innerHTML = element.innerHTML + arrow;
		}
	}
}

function removeAttr(formName, keys, type) {
	var f = document.forms[formName];
	if(!f) return;
	type = !type ? "required" : type;
	var arr = keys.replace(/ +/g, "").split(",");

	for(var i=0; i<arr.length; i++) {	
		if(f[arr[i]]) {
			var el = f[arr[i]];
			if (el.type != "select-one" && el.length > 1) el = el[0];
			el.removeAttribute(type);
		}
	}
}
function setAttr(formName, keys, type, value) {
	var f = document.forms[formName];
	if(!f) return;
	var arr = keys.replace(/ +/g, "").split(",");
	for(var i=0; i<arr.length; i++) {
		if(f[arr[i]]) {
			var el = f[arr[i]];
			if (el.type != "select-one" && el.length > 1) el = el[0];
			el.setAttribute(type, value);
			//alert(el.name + ":::" + type + ":::" + el.getAttribute(type));
		}
	}
}
/* ex)
removeAttr("form1", "aa, ba, ca");
removeAttr("form1", "aa, ba, ca", "optino");
setAttr("form1", "aa, ba, ca", "required", "Y");
*/


function setDisabled(element){
	if(!element)return;
	switch(element.type) {
		case 'text':
		case 'password':
		case 'textarea':
			element.className = "in_readonly";
			element.readOnly = true;
			break;
		case 'radio':	
		case 'checkbox':
			element.className = "in_readonly";
			element.disabled = true;
			break;
		case "button":
			element.style.display = "none";
			break;
		case "select-one":
			element.className = "in_readonly";
			element.disabled=true;
			break;	
		default:
			if(element.length){			
				for(var i=0; i<element.length; i++) {
					element[i].disabled = true;
				}
			}
			break;
		}
}

function setEnabled(element){
	if(!element)return;
	switch(element.type) {
		case 'text':
		case 'password':
		case 'textarea':
			element.className = "label";
			element.readOnly = false;
			break;
		case 'radio':	
		case 'checkbox':
			element.disabled = false;
			break;
		case "button":
			element.style.display = "";
			break;
		case "select-one":
			element.disabled=false;
			break;
		default:
			if(element.length){			
				for(var i=0; i<element.length; i++) {
					element[i].disabled = false;
				}
			}
			break;
	}
}

/**
 *  웹표준에 따른 innerHTML 때문에 만들었다.
 *  ie9과 chrom에서는 사용자가 입력한 값이 innerHTML로 읽혀 오지 않는다.
 *  사용자가 화면 상에서 입력한 값은 html의 dom에 바로 반영 되는 것이 아니여서 innerHTML로 읽히지 않는다.
 *  따라서 javascript setAttribute 또는 innerHTML 을 이용하여 직접 셋팅해주어야 한다. 
 * **/
function val2attr(element){
	if(!element)return;
	switch(element.type) {
		case 'text':
		case 'password':
		case 'hidden':
			element.setAttribute("value", element.value);
			break;
		case 'textarea':
			element.innerHTML = element.value;
			break;
		case 'radio':
		case 'checkbox':
			if(element.checked)
				element.setAttribute("checked", "true");
			break;
		case 'select-one':
			for(var i=0; i<element.options.length; i++) if(element.options[i].value == element.value) element.options[i].setAttribute("selected", "true");
			break;
		default:
			break;
	}
}

function setAttrValue(div){
    var div = document.getElementById(div);
	var input = div.getElementsByTagName("input");
	for(var i = 0; i < input.length; i ++){
		var element = input[i];
		val2attr(element);
	}
	var select = div.getElementsByTagName("select");
	for(var i = 0; i < select.length; i ++){
		var element = select[i];
		val2attr(element);
	}

	var textarea = div.getElementsByTagName("textarea");
	for(var i = 0; i < textarea.length; i ++){
		var element = textarea[i];
		val2attr(element);
	}
}

/******************
	숫자만 입력하기
******************/
function num_only(){
	e = window.event;
	if((48 <= e.keyCode && e.keyCode <= 57 || 96 <= e.keyCode && e.keyCode <= 105 || e.keyCode == 8 || e.keyCode == 46) ||
		 e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 27 || e.keyCode == 8 || e.keyCode == 9)
	{
		return;
	}else{	
		 if(e.preventDefault){
            e.preventDefault();
        } else {
            e.returnValue = false;
        }
	}
	return;
}
/******************
	숫자만 입력하기
******************/
function num_point_only(){
	e = window.event;
	
	if((48 <= e.keyCode && e.keyCode <= 57 || 96 <= e.keyCode && e.keyCode <= 105 || e.keyCode == 8 || e.keyCode == 46) ||
		 e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 27 || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 110 || e.keyCode == 190)
	{
		return;
	}else
	{		
		if(e.preventDefault){
            e.preventDefault();
        } else {
            e.returnValue = false;
        }
	}
}
/******************
	숫자만 입력하기
******************/
function num_minus_only(){
	e = window.event;
	if((48 <= e.keyCode && e.keyCode <= 57 || 96 <= e.keyCode && e.keyCode <= 105 || e.keyCode == 8 || e.keyCode == 45 || e.keyCode == 46) ||
		 e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 27 || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 109 || e.keyCode == 189)
	{
		return;
	}else
	{	
		if(e.preventDefault){
            e.preventDefault();
        } else {
            e.returnValue = false;
        }
	}
}
/******************
숫자만 입력하기
******************/
function num_point_minus_only(){
e = window.event;
if((48 <= e.keyCode && e.keyCode <= 57 || 96 <= e.keyCode && e.keyCode <= 105 || e.keyCode == 8 || e.keyCode == 45 || e.keyCode == 46) ||
	 e.keyCode == 37 || e.keyCode == 39 || e.keyCode == 27 || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 110 || e.keyCode == 190 || e.keyCode == 109 || e.keyCode == 189)
{
	return;
}else
{	
	 if(e.preventDefault){
         e.preventDefault();
     } else {
         e.returnValue = false;
     }
}
}
/*********************************************************************
	다음 필드로 이동
	onKeyUp 이벤드로 실행
	iFillLen	:	현필드가 몇개가 차야 이동할것인가에 대한 현 필드 max 수
	sNextName	:	이동할 다음 필드 ex)document.formname.필드명
**********************************************************************/
function moveNext(sNextName)
{
	var	sFormName	=	event.srcElement.form.name;
	var	iLen			=	(event.srcElement.value).length;
	var	iSize			=	event.srcElement.size;
	var	sChar			=	"";
	if(event.keyCode > 95 && event.keyCode < 106)
	{
		sChar	=	String.fromCharCode(event.keyCode-48);
	}else
	{ 
		sChar	=	String.fromCharCode(event.keyCode);
	}
	
	if(iLen	==	iSize)
	{
		eval("document."+sFormName+"."+sNextName).focus();
	}
}

/*********************************************************************
	이전 필드로 이동
	onKeyUp 이벤드로 실행
	sPrvName	:	이전할 다음 필드 ex)document.formname.필드명
**********************************************************************/
function movePrv(sPrvName)
{
	var	iLen			=	(event.srcElement.value).length;
	var	sFormName	=	event.srcElement.form.name;

	if(event.keyCode != 229	&&	(event.keyCode	==	8 || event.keyCode	==	46))
	{
		if(iLen == 0 )
		{
			eval("document."+sFormName+"."+sPrvName).focus();	
			eval("document."+sFormName+"."+sPrvName).value	=	eval("document."+sFormName+"."+sPrvName).value;	
		}
	}
}



/*********************
	사업자등록번호 체크
*********************/
function check_busino(vencod) {
	var sum = 0;
	var getlist =new Array(10);
	var chkvalue =new Array("1","3","7","1","3","7","1","3","5");
	for(var i=0; i<10; i++) { getlist[i] = vencod.substring(i, i+1); }
	for(var i=0; i<9; i++) { sum += getlist[i]*chkvalue[i]; }
	sum = sum + parseInt((getlist[8]*5)/10);
	sidliy = sum % 10;
	sidchk = 0;
	if(sidliy != 0) { sidchk = 10 - sidliy; }
	else { sidchk = 0; }
	if(sidchk != getlist[9]) { return false; }
	return true;
}

/*********************
	우편번호 찾기
*********************/
 function pop_postcode(form,post_code1, post_code2, address){
 	
 	var result = OpenDialog("/web/com/supp/csc1010p.jsp", self, "400", "380","yes");
 	if(result != null){
	 	var f = document.forms[form];
	 	f[post_code1].value = result[2];
	 	f[post_code2].value = result[3];
	 	f[address].value = result[1];
	 	alert("나머지 주소를 입력하세요.");
	 	f[address].focus();
 	}
 	return;
 }
 
 
/*********************
	우편번호 찾기(http://www.juso.go.kr)
*********************/
function jusoPopup() {
	 var pop = window.open("/web/com/supp/jusoPopup.jsp","juso","width=570,height=420, scrollbars=yes, resizable=yes"); 
}
 
 function layer_postcode(form){
	fLayerPop("postcode", "/web/com/supp/csc1011p.jsp?form="+form, 400, 380);
 }

function layer_postresult(form, result)
{
 	if(result != null){
	 	var f = document.forms[form];
	 	f['post_code1'].value = result[2];
	 	f['post_code2'].value = result[3];
	 	f['address'].focus();
	 	f['address'].value = result[1] + ' ';
 	}
}

/*********************
	즐겨 찾기 등록
*********************/
function bookMark()
{
	var title = "나이스다큐(건설)";
	var url = "http://www.nicedocu.com/web/supplier/index.jsp";
        //파이어폭스~! 
    if(window.sidebar) {
        window.sidebar.addPanel(title, url,"");
    }else if( window.external ) {//익스플로어
        window.external.AddFavorite( url, title);
    }   
}

/*********************************
	trim 기능
*********************************/
String.prototype.trim	=	function() 
{
	return	this.replace(/(^\s*)|(\s*$)/gi, "");
}

/*********************************
	replaceAll 기능
*********************************/
String.prototype.replaceAll = function(sVal1, sVal2)
{
	return	funcReplaceStrAll(this,sVal1,sVal2);
}

/*********************************
	replaceAll 기능
*********************************/
function funcReplaceStrAll( org_str,  find_str,  replace_str)
{
    var pos = 0;
    pos = org_str.indexOf(find_str);

    while(pos != -1)
    {
        pre_str = org_str.substring(0, pos);
        post_str = org_str.substring(pos + find_str.length, org_str.length);
        org_str = pre_str + replace_str + post_str;

        pos = org_str.indexOf(find_str);
    }
    return org_str;
}


/*********************************
 startsWith 기능
 *********************************/
if (!String.prototype.startsWith) {
	String.prototype.startsWith = function(search, pos) {
		return this.substr(!pos || pos < 0 ? 0 : +pos, search.length) === search;
	};
}

/*************************
	유효한 월(月)인지 확인.
	Parameter : MM(월)
	Return : true / false
*************************/
function isValidMonth(mm) 
{
	var m = parseInt(mm,10);

	return (m >= 1 && m <= 12);
}

/***************************************
	유효한 일(日)인지 확인.             
	Parameter : YYYY, MM, DD(년, 월, 일)
	Return : true / false              
***************************************/
function isValidDay(yyyy, mm, dd) 
{
	var m = parseInt(mm,10) - 1;
	var d = parseInt(dd,10);

	var end = new Array(31,28,31,30,31,30,31,31,30,31,30,31);
	if ((yyyy % 4 == 0 && yyyy % 100 != 0) || yyyy % 400 == 0) 
		end[1] = 29;

	return (d >= 1 && d <= end[m]);
}

/***************************************
	유효한 시간인지 확인.             
	Parameter : hh(시간)
	Return : true / false              
***************************************/
function isValidHour(hh)
{
	var hour = parseInt(hh,10);

	if(hour < 24)
		return true;
	else
		return false;
}

/***************************************
	유효한 분인지 확인.             
	Parameter : mm(분)
	Return : true / false              
***************************************/
function isValidMin(mm)
{
	var min = parseInt(mm,10);

	if(min < 60)
		return true;
	else
		return false;
}

/** 
 *	숫자인지 체크
 *  true - 숫자
 *	false - 숫자가 아님
 */
function isNum(objValue)
{
	var str="0123456789"
	if (objValue=="")
	{
		return false;
	}
	for (i=0;i<objValue.length;i++)
	{
		if (str.indexOf(objValue.charAt(i))==-1)
		{
			return false;
		}
	}
	return true;
}
/*
 * 유효한 날짜(Date) 인지 체크
 * Parameter : YYYYMMDD(년월일)
 * Return : true / false
 */
function isValidDate(objValue) 
{
	objValue = objValue.replaceAll("-","");
	if(!isNum(objValue) || objValue.length < 8)
		return false;

	year  = objValue.substring(0, 4);
	month = objValue.substring(4, 6);
	day   = objValue.substring(6, 8);
	
	if (parseInt(year, 10) >= 1900  && isValidMonth(month) && isValidDay(year, month, day)) 
		return true;

	return false;
}

function js_isDateCmp(FromDate, ToDate) { 
  return FromDate > ToDate ? false : true;
} 


/* --- 날짜 형식 (onKeyUp 이벤트) --- */
function dateFormat(obj)
{
	var str  = obj.value.replace(/\-/gi, "");
	var leng = str.length;

	switch (leng)
	{
		case 1 :
		case 2 :
		case 3 :
		case 4 : obj.value = str; break;
		case 5 :
		case 6 : obj.value = str.substring(0, 4) + "-" + str.substring(4); break;
		case 7 :
		case 8 : obj.value = str.substring(0, 4) + "-" + str.substring(4, 6) + "-" + str.substring(6); 
		break;
	}
}

/*인증서 서명시 만료일 체크로 사용중*/
function getFormatDate(date,splitor){
	if(!splitor){
		splitor = "";
	}
	var year = date.getFullYear();                                 //yyyy
	var month = (1 + date.getMonth());                     //M
	month = month >= 10 ? month : '0' + month;     // month 두자리로 저장
	var day = date.getDate();                                        //d
	day = day >= 10 ? day : '0' + day;                            //day 두자리로 저장
	return  year + splitor + month + splitor + day;
}

	

/******************************************
	인자로 입력된 값을 3자리 단위로 "," 추가
******************************************/
function fnMakeComma()
{
	if(event==null) return;
	if(event.keyCode == 37 || event.keyCode == 39)
	{
		return;
	}
	
	var num 	= 	event.srcElement.value;
	var	sScale	=	"";
	if(event.srcElement.getAttribute("scale") != null)
	{
		sScale	=	event.srcElement.getAttribute("scale");
	}
	
	num = num.replaceAll(",","");
	if(num.length > 0 && num.substring(0,1) == ".")
	{
		alert("소숫점을 처음부터 기입하실수 없습니다.");
		event.srcElement.value	=	"";
		event.srcElement.focus();
		return;
	}
	if(num.split(".").length > 2)
	{
		alert("소수점은 1개까지만 허용됩니다.");
		event.srcElement.value	=	"";
		event.srcElement.focus();
	    return;
	}
	
	var	sNum	=	"";
	var	sNum2	=	"";
	var	aNum;
	if(num.indexOf(".") != -1)
	{
		var	aNum	=	num.split(".");
		sNum	=	aNum[0];
		sNum2	=	aNum[1];
	}else
	{
		sNum	=	num;
	}
	
	if(sNum2 && sNum2.length > 3)
	{
		alert("소수점은 3자리까지 입력가능합니다.");
		event.srcElement.value	=	"";
		event.srcElement.focus();
	    return;
	}
	
	sNum	=	fnMakeComma2(sNum);
	
	if(num.indexOf(".") != -1)
	{
		event.srcElement.value	=	sNum + "." + sNum2;
	}else
	{
		event.srcElement.value	=	sNum;
	}
}

/******************************************
	3자리 단위로 "," 추가
******************************************/
function fnMakeComma2(val){
	var	aNum;
	var	sNum	=	"";
	var	sNum2	=	"";
	
	if(val.indexOf(".") != -1)
	{
		aNum	=	val.split(".");
		sNum	=	aNum[0];
		sNum2	=	aNum[1];
	}else
	{
		sNum	=	val;
	}
	
	var new_num = "";
	for(i=0;i<sNum.length;i++) {
		new_num=sNum.substr(sNum.length-i-1,1) + new_num;
		if( sNum.substr(sNum.length-i-2,1) !=  '-' ) {
			if (  ((i+1) % 3 == 0  ) && ( ((i+1) != sNum.length)  )) {
				new_num = "," + new_num ;
			}
		}
	}
	
	if(sNum2.length > 0)
	{
		return new_num	+ "." + sNum2;
	}else
	{
		return new_num;
	}
}

function makeComma(obj){
  var num = obj.value;
  num = num.replaceAll(",","");
  var aNum = num.split(".");
  if ( aNum.length > 2 ) {
    alert("소수점은 1개까지만 허용됩니다.");
    obj.select();
    return;
  }
  num = aNum[0];
  new_num = "";
  num = num + new_num;
  for(i=0;i<num.length;i++) {
    new_num=num.substr(num.length-i-1,1) + new_num;
    if( num.substr(num.length-i-2,1) !=  '-' ) {
      if (  ((i+1) % 3 == 0  ) && ( ((i+1) != num.length)  )) {
        new_num = "," + new_num ;
      }
    }
  }
  if (aNum.length > 1){
		obj.value = new_num + "." + aNum[1];
	}else{
		obj.value = new_num;
	}
}

/***************************
	버림
***************************/
function getFloor(nVal, nLen)
{
	var	sVal = nVal + "";
	
	var	aNum;
	var	sNum	=	"";
	var	sNum2	=	"";
	if(sVal.indexOf(".") != -1)
	{
		aNum	=	sVal.split(".");
		sNum	=	aNum[0];	
		sNum2	=	aNum[1];	
	}else
	{
		sNum	=	sVal;
	}
	
	if(sNum2.length > nLen)
	{
		sNum2	=	sNum2.substring(0,nLen);
		
		var	nNum3	=	Number("0."+sNum2);
		var	sNum3	=	(nNum3+"").replaceAll("0.","");
		sNum2	=	sNum3;
	}
	
	var	sRtnVal	=	"";
	
	sRtnVal	=	sNum;
	if(sNum2.length > 0)
	{
		sRtnVal	=	sRtnVal	+ "." + sNum2;	
	}
	return Number(sRtnVal);
}

/************************
	달력띄우기
************************/
function open_calendar(fieldname)
{
	var	xpos  = event.clientX;
	var	ypos  = event.clientY + document.body.scrollTop;  // scroll 고려 (by hjh)
	var	iSize	=	10;

	var	sYYYYMMDD	=	"";

	if(typeof((document.getElementById(fieldname)).Text) != "undefined")
	{
		sYYYYMMDD	=	(document.getElementById(fieldname)).Text;
	}
		
	if(typeof((document.getElementById(fieldname)).value) != "undefined")
	{
		iSize	=	document.getElementById(fieldname).size;
		sYYYYMMDD	=	(document.getElementById(fieldname)).value;
	}

	var	oNode	=	document.getElementById("ifCalendar");
	
	if(oNode != null)
	{
		document.body.removeChild(oNode);
	}

    // 달력 frame 하단 위치가 화면 총 높이를 벗어나면 보정 (by hjh)
    // 화면 총 높이가 달력 frame 높이(190)보다 크고, 달력 frame 하단 위치가 화면 총 높이를 초과하면
    if ( (document.body.scrollHeight - 190 > 0) && (document.body.scrollHeight - ypos < 190) )
    {
        // 달력 frame 하단 위치를 화면 총 높이에 맞춘다
        ypos = document.body.scrollHeight - 190;
    }

	var	iframe = document.createElement('iframe');
	iframe.style.position = "absolute";
	iframe.style.width		= 175;
	iframe.style.height		= "190px";
	iframe.style.top			= ypos;
	iframe.style.left			= xpos;

	// 오른쪽 경계 넘어가면 위치 조정
	var xMax = parseInt(document.body.clientWidth);
	if( (parseInt(xpos)+parseInt(iframe.style.width)) > xMax)
		iframe.style.left = xMax - parseInt(iframe.style.width) - 20;

	iframe.id							=	"ifCalendar";
	iframe.marginwidth		=	"0px";
	iframe.marginheight		=	"0px";
	iframe.scrolling			=	"no";
	iframe.frameBorder		=	"0px";
	iframe.src						=	"/web/supplier/common/Calendar.jsp?fieldname="+fieldname+"&yyyymmdd="+sYYYYMMDD+"&length="+iSize;
	document.body.appendChild(iframe);
}

/*****************************
	첨부파일 다운로드
	argKey	:	프로퍼티 키
*****************************/
function filedown(argKey, argSubPath, argTarFile_Name)
{	
	var	oNode	=	document.getElementById("ifFileDown");
	
	if(oNode != null)
	{
		document.body.removeChild(oNode);
	}

	var vUrl	= "/servlets/procure.common.file.FileDownLoad?"
						+ "FILE_KEY=" + argKey
						+ "&FILE_SUB_PATH=" + escape(argSubPath)
						+ "&FILE_TAR_FILE=" + escape(argTarFile_Name.replaceAll(",","_"));//jeus에서 unescape못하고 있음.
						//+ "&FILE_TAR_FILE=" + encodeURIComponent(encodeURIComponent(argTarFile_Name.replaceAll(",","_")));
//https://daemonjin.tistory.com/entry/%EC%9E%90%EB%B0%94%EC%8A%A4%ED%81%AC%EB%A6%BD%ED%8A%B8-encodeURIComponent-java-URLDecoderdecodeString-UTF8
	var	iframe = document.createElement('iframe');
	iframe.style.width		= "0px";
	iframe.style.height		= "0px";
	iframe.id							=	"ifFileDown";
	iframe.marginwidth		=	"0px";
	iframe.marginheight		=	"0px";
	iframe.scrolling			=	"no";
	iframe.frameBorder		=	"0px";
	iframe.src						=	vUrl;
	document.body.appendChild(iframe);
}


function filedown2(argKey, argSubPath, argFile_Name, argTarFile_Name)
{	
	var	oNode	=	document.getElementById("ifFileDown");
	
	if(oNode != null)
	{
		document.body.removeChild(oNode);
	}

	var vUrl	= "/servlets/procure.common.file.FileDownLoad?"
						+ "FILE_KEY=" + argKey
						+ "&FILE_SUB_PATH=" + argSubPath
						+ "&FILE_NAME=" + escape(argFile_Name)
						+ "&FILE_TAR_FILE=" + escape(argTarFile_Name);
						//+ "&FILE_TAR_FILE=" + encodeURIComponent(encodeURIComponent(argTarFile_Name));

	var	iframe = document.createElement('iframe');
	iframe.style.width		= "0px";
	iframe.style.height		= "0px";
	iframe.id							=	"ifFileDown";
	iframe.marginwidth		=	"0px";
	iframe.marginheight		=	"0px";
	iframe.scrolling			=	"no";
	iframe.frameBorder		=	"0px";
	iframe.src						=	vUrl;
	document.body.appendChild(iframe);
}


function contPdfViewer(cont_no, cont_chasu, cfile_seq){
    var pdfjs_yn = "";
	
	browserInfo = getBrowserInfo();
	if(browserInfo['name']=="Internet Explorer"){
		if(browserInfo['version']=="v.10"||browserInfo['version']=="v.11"||browserInfo['version']=="edge"){//ie10부터 지원
			pdfjs_yn = "Y";
		}
	}else{
		pdfjs_yn = "Y";
	}
	
	var link = "/web/admin/buyer/pop_pdf_viewer.jsp?" 
	           +"cont_no="+cont_no
	           +"&cont_chasu="+cont_chasu
	           +"&cfile_seq="+cfile_seq
			   +"&pdfjs_yn="+pdfjs_yn;
	OpenWindow(link,"cont_pdfViewer",830,800);
}


function contPdfViewerPartner(cont_no, cont_chasu, cfile_seq,member_no){
    var pdfjs_yn = "";
	
	browserInfo = getBrowserInfo();
	if(browserInfo['name']=="Internet Explorer"){
		if(browserInfo['version']=="v.10"||browserInfo['version']=="v.11"||browserInfo['version']=="edge"){//ie10부터 지원
			pdfjs_yn = "Y";
		}
	}else{
		pdfjs_yn = "Y";
	}
	
	var link = "/web/supplier/contract/pop_pdf_viewer_partner.jsp?" 
	           +"cont_no="+cont_no
	           +"&cont_chasu="+cont_chasu
	           +"&cfile_seq="+cfile_seq
	           +"&member_no="+member_no
	           +"&pdfjs_yn="+pdfjs_yn;
	OpenWindow(link,"cont_pdfViewer_partner",830,800);
}

function contWarr(cont_no, cont_chasu, warr_seq){
	var link = "/web/supplier/contract/pop_warr_modify.jsp?" 
	           +"cont_no="+cont_no
	           +"&cont_chasu="+cont_chasu
	           +"&warr_seq="+warr_seq;
	OpenWindow(link,"pop_warr",600,550);
}

function infoWarr(member_no, warr_seq){
	var link = "/web/supplier/info/pop_warr_modify.jsp?"
				+"member_no="+member_no		
				+"&warr_seq="+warr_seq;
	OpenWindow(link,"pop_warr",600,390);
}

function infoWarrAdd(){
	var link = "/web/supplier/info/pop_warr_insert.jsp"; 
	OpenWindow(link,"pop_warr",600,390);
}

function infoCert(member_no, cert_seq){
	var link = "/web/supplier/info/pop_cert_modify.jsp?"
				+"member_no="+member_no		
				+"&cert_seq="+cert_seq;
	OpenWindow(link,"pop_cert",600,300);
}

function infoCertAdd(){
	var link = "/web/supplier/info/pop_cert_insert.jsp"; 
	OpenWindow(link,"pop_cert",600,300);
}

function fPopupStampInfo(cont_no, cont_chasu, member_no){
	var link = "/web/supplier/contract/pop_stamp_modify.jsp?" 
	           +"cont_no="+cont_no
	           +"&cont_chasu="+cont_chasu
	           +"&member_no="+member_no;
	OpenWindows(link,"pop_stamp",600,600);
}


function elcPdfViewer(elc_no){
	var pdfjs_yn = "";
	
	browserInfo = getBrowserInfo();
	if(browserInfo['name']=="Internet Explorer"){
		if(browserInfo['version']=="v.10"||browserInfo['version']=="v.11"||browserInfo['version']=="edge"){//ie10부터 지원
			pdfjs_yn = "Y";
		}
	}else{
		pdfjs_yn = "Y";
	}
	var link = "/web/supplier/elc/pop_pdf_viewer.jsp" 
	           +"?elc_no="+elc_no
	           +"&pdfjs_yn="+pdfjs_yn;
	OpenWindow(link,"elc_pdfViewer",830,800);
}


function proofPdfViewer(proof_no){
	var pdfjs_yn = "";
	
	browserInfo = getBrowserInfo();
	if(browserInfo['name']=="Internet Explorer"){
		if(browserInfo['version']=="v.10"||browserInfo['version']=="v.11"||browserInfo['version']=="edge"){//ie10부터 지원
			pdfjs_yn = "Y";
		}
	}else{
		pdfjs_yn = "Y";
	}
	
    var link = "/web/supplier/proof/pop_pdf_viewer.jsp"
        +"?proof_no="+proof_no
        +"&pdfjs_yn="+pdfjs_yn;
    OpenWindow(link,"cont_pdfViewer",830,800);
}


function chkClick(obj ,formName, targetName, checkedValue){
	if(obj.type="checkbox"){
		if(document.forms[formName][obj.name].type=="checkbox"){
			if(obj.checked== true){
				document.forms[formName][targetName].value= checkedValue;
			}else{
				document.forms[formName][targetName].value= "";
			}
		}else{
			var cnt = document.forms[formName][obj.name].length;
			var pos = 0;
			for(var i = 0 ; i < cnt ; i ++){
				if(obj== document.forms[formName][obj.name][i]){
					pos = i;
				}
			}
			if(obj.checked== true){
				document.forms[formName][targetName][pos].value= checkedValue;
			}else{
				document.forms[formName][targetName][pos].value= "";
			}
		}
	}
}


// 결제 영수증 보기
function fViewReciept(sResultPayType, sResultTid, sResultReceitType)
{
	var sUrl = "";
	var w = 500;
	var h = 500;
	//결제수단 (01:신용카드, 02:계좌이체)
	if(sResultPayType == "01")
	{
		sUrl = "https://pg.nicepay.co.kr/issue/CardIssue.jsp?TID="+sResultTid+"&svcCd=01&sendMail=0";
	}
	else if(sResultPayType == "02")
	{
		w = 420
		h = 540
		//현금영수증유형(0:미발행, 1:소득공제, 2:지출증빙)
		if( sResultReceitType == "0" ||  sResultReceitType == "" )
		{
			sUrl = "https://npg.nicepay.co.kr/issue/IssueLoader.do?TID="+sResultTid+"&type=0";
		}
		else if(sResultReceitType == "1" || sResultReceitType == "2")
		{
			sUrl = "https://npg.nicepay.co.kr/issue/IssueLoader.do?TID="+sResultTid+"&type=1";
			
		}
		else if(sResultReceitType == "3")
		{
			alert("통장으로 계좌이체한 건입니다.");
			return;
		}

	}else if(sResultPayType == "05"){
		alert("후불건으로 세금계산서로 발행 됩니다.");
		return;
	}

	window.open(sUrl, "popupIssue", "width="+w+",height="+h+",scrollbar=no");
}



// 금액 입력시 한글로 표시
function fSetKoreanMoney(inputVal, displayId)
{
    var koreanMoney = "";
    var numVal = trimComma(inputVal);

    if ( (numVal != "") && isIntNum(numVal) )
    {
        koreanMoney = "一金 " + num2han(numVal) + "원整";
    }

    document.getElementById(displayId).innerHTML = koreanMoney;

	replaceInput(koreanMoney, displayId);  // 금액 입력시 한글로 표시(class로 찾기)
    return;
}

/** 
 * 숫자를 한글로
 */ 
function num2han(num){ 
	var i, j=0, k=0; 
	var han1 = new Array("","일","이","삼","사","오","육","칠","팔","구"); 
	var han2 = new Array("","만","억","조","경","해","시","양","구","간"); 
	var han3 = new Array("","십","백","천"); 
	var result="", hangul = num + "", pm = ""; 
	var str = new Array(), str2=""; 
	var strTmp = new Array(); 

	if(parseInt(num)==0) return "영"; //입력된 숫자가 0일 경우 처리 
	if(hangul.substring(0,1) == "-"){ //음수 처리 
		pm = "감 "; 
		hangul = hangul.substring(1, hangul.length); 
	} 
	if(hangul.length > han2.length*4) return "too much number"; //범위를 넘는 숫자 처리 자리수 배열 han2에 자리수 단위만 추가하면 범위가 늘어남. 

	for(i=hangul.length; i > 0; i=i-4){ 
		str[j] = hangul.substring(i-4,i); //4자리씩 끊는다. 
		for(k=str[j].length;k>0;k--){ 
			strTmp[k] = (str[j].substring(k-1,k))?str[j].substring(k-1,k):""; 
			strTmp[k] = han1[parseInt(strTmp[k])]; 
			if(strTmp[k]) strTmp[k] += han3[str[j].length-k]; 
			str2 = strTmp[k] + str2; 
		} 
		str[j] = str2; 
		//if(str[j]) result = str[j]+han2[j]+result; 
		//4자리마다 한칸씩 띄워서 보여주는 부분. 우선은 주석처리 
		//result = (str[j])? " "+str[j]+han2[j]+result : " " + result; 
		result = (str[j])? " "+str[j]+han2[j]+result : " " + result; 

		j++; str2 = ""; 
	} 

	return pm + result; //부호 + 숫자값 
} 

// 금액인지
function isIntNum(objValue)
{
	var str="-0123456789"
	if (objValue=="")
	{
		return false;
	}
	for (i=0;i<objValue.length;i++)
	{
		if (str.indexOf(objValue.charAt(i))==-1)
		{
			return false;
		}
	}
	return true;
}


/**
 *  문자열에서 Comma(,) 삭제
 *
 */
function trimComma(inString) 
{
	var len = inString.length;
	var ch, outString = "c";
	
	for (i=1; i<=len; i++ ) 
    {
		ch = inString.substr(i-1, 1);
		if (ch == ",") 
        {
		}
		else
		{
			outString = outString + ch;
		}
	}
	outlen = outString.length;
    outString = outString.substring(1,outlen);
	return outString;
}


/**
 * 템플릿에 있는 입력양식에서 input control을 제거한다.
 * 어느 곳에 입력하던 같은 값을 가지게 된다.
 *
 * @param inObj inputBox를 제거하려는 원본 Div 컨트롤객체
 * @param outObj inputBox를 제거한 값을 출력할 input(text, textarea) 컨트롤객체
 * @param isDebug 디버깅 화면 출력여부( 디버깅을 원하면 true, 아니면 false 또는 인자생략)
 * @return
 */
function removeInput(inObj, outObj, isDebug)
{
	var html = inObj.innerHTML;
	var form = document.createElement("form");	// control을 위한 임시 form
	html = html.replace(/<img.+?onClick=[\"'](.+?)[\"'].+?>/gi, '');  // click 이벤트가 있는 이미지는 삭제
	form.innerHTML  = html;

	var tmp = html.replace(/[\r|\n]/g, '');
	var style = searchStyle(html.replace(/[\r|\n]/g, ''));	// innerHtml 하면 style 태그가 사라지므로 그 부분만 따로 저장한다.

	var elems = form.elements;
	for(var i=0;i<elems.length;i++){
		var aElem = elems[i];

		if( aElem.tagName == null || ( aElem.tagName.toLowerCase() != "input" && aElem.tagName.toLowerCase() != "textarea" && aElem.tagName.toLowerCase() != "select" && aElem.tagName.toLowerCase() != "button" ) ){
			//if(aElem.tagName.toLowerCase() == "img" && aElem.getAttribute("onclick") != null)
			//aElem.style.display = "none";
			continue;
		} 

		if(aElem.type.toLowerCase() != "hidden"){

			var pdf= aElem.getAttribute("pdf");
			if( pdf != null)
			{
				var id = "";
				var arrPdf = pdf.split(":");
				switch(arrPdf[0])
				{
					case "no":			// 무조건 pdf 출력 안함
						aElem.style.display = "none";
						var pNode = aElem.parentNode;
						while(pNode.getAttribute("id")!=arrPdf[1])
						{
							pNode.style.display = "none";
							pNode = pNode.parentNode;
						}
						pNode.style.display = "none";
						break;
					case "op":
						if(aElem.value == "")	// 값이 없는 경우 pdf 출력 안함.
						{
							aElem.style.display = "none";
							var pNode = aElem.parentNode;
							while(pNode.getAttribute("id")!=arrPdf[1])
							{
								pNode.style.display = "none";
								pNode = pNode.parentNode;
							}
							pNode.style.display = "none";
						}
						break;
				}
				//continue;
			}
			aElem.style.display = "none";
			if(aElem.parentNode.nodeName.toLowerCase() == "span"){
				if(aElem.value == ""){
					aElem.parentNode.innerHTML = aElem.outerHTML + "&nbsp;";		// input을 삭제하면 elems.length 가 변하므로 정상적이지 않게 됨.
				}else{
					if(aElem.type.toLowerCase() == "checkbox" || aElem.type.toLowerCase() == "radio")
					{
						if(aElem.checked)
							aElem.parentNode.innerHTML = aElem.outerHTML + '▣';
						else
							aElem.parentNode.innerHTML = aElem.outerHTML + '□';
					}
					else
					{
						aElem.parentNode.innerHTML = aElem.outerHTML + fConvertSecuStr(aElem.value);
					}
				}
			}

		}
	}
	outObj.value = style + form.innerHTML;
	
	//alert(outObj.value);

	if(isDebug)
	{
		var __htmlRemoveDiv = document.createElement("div");	// control을 위한 임시 form

		__htmlRemoveDiv.innerHTML = form.innerHTML;
		document.body.insertBefore(__htmlRemoveDiv);
	}
}

/**
 * 템플릿에 있는 입력양식에서 input control을 제거한다.
 * 어느 곳에 입력하던 같은 값을 가지게 된다.
 *
 * @param inObj inputBox를 제거하려는 원본 Div 컨트롤객체
 * @param outObj inputBox를 제거한 값을 출력할 input(text, textarea) 컨트롤객체
 * @param isDebug 디버깅 화면 출력여부( 디버깅을 원하면 true, 아니면 false 또는 인자생략)
 * @return
 */
function removeInput2(inObj)
{
	var html = inObj.innerHTML;
	var form = document.createElement("form");	// control을 위한 임시 form
	form.innerHTML  = html;

	var elems = form.elements;
	for(var i=0;i<elems.length;i++){
		var aElem = elems[i];
		if( aElem.tagName == null || ( aElem.tagName.toLowerCase() != "input" && aElem.tagName.toLowerCase() != "textarea"  && aElem.tagName.toLowerCase() != "select" && aElem.tagName.toLowerCase() != "button" ) ){
			continue;
		}

		if(aElem.type.toLowerCase() != "hidden"){
			var pdf= aElem.getAttribute("pdf");
			if( pdf != null)
			{
				var id = "";
				var arrPdf = pdf.split(":");
				switch(arrPdf[0])
				{
					case "no":			// 무조건 pdf 출력 안함
						var pNode = aElem.parentNode;
						while(pNode.getAttribute("id")!=arrPdf[1])
							pNode = pNode.parentNode;

						pNode.style.display = "none";
						break;
					case "op":
						if(aElem.value == "")	// 값이 없는 경우 pdf 출력 안함.
						{
							var pNode = aElem.parentNode;
							while(pNode.getAttribute("id")!=arrPdf[1])
								pNode = pNode.parentNode;

							pNode.style.display = "none";
						}
						break;
				}
			}

			aElem.style.display = "none";
			if(aElem.parentNode.nodeName.toLowerCase() == "span"){
				if(aElem.value == ""){
					aElem.parentNode.innerHTML = aElem.parentNode.innerHTML + "&nbsp;";		// input을 삭제하면 elems.length 가 변하므로 정상적이지 않게 됨.
				}else{
					if(aElem.type.toLowerCase() == "checkbox" || aElem.type.toLowerCase() == "radio")
					{
						if(aElem.checked)
							aElem.parentNode.innerHTML = aElem.outerHTML + '▣';
						else
							aElem.parentNode.innerHTML = aElem.outerHTML + '□';
					}
					else
					{
						aElem.parentNode.innerHTML = aElem.outerHTML + fConvertSecuStr(aElem.value);
					}
				}
			}
		} else {
			var pdf= aElem.getAttribute("pdf");
			if( pdf != null)
			{
				var id = "";
				var arrPdf = pdf.split(":");
				switch(arrPdf[0])
				{
					case "no":			// 무조건 pdf 출력 안함
						var pNode = aElem.parentNode;
						while(pNode.getAttribute("id")!=arrPdf[1])
							pNode = pNode.parentNode;

						pNode.style.display = "none";
						break;
					case "op":
						if(aElem.value == "")	// 값이 없는 경우 pdf 출력 안함.
						{
							var pNode = aElem.parentNode;
							while(pNode.getAttribute("id")!=arrPdf[1])
								pNode = pNode.parentNode;

							pNode.style.display = "none";
						}
						break;
				}
			}
		}
	}

	inObj.innerHTML = form.innerHTML;
}


// <style type=\"text/css\">   </style> 을 찾아 내용 가져오기
function searchStyle(sIn)
{
	var v_regExp = new RegExp("<STYLE[^>]*>(.*?)</STYLE>");
	if(v_regExp.test(sIn))
	{
		var v_result = v_regExp.exec(sIn);
		if(v_result != null)
			return v_result[0];
	}

	return "";
}

/**
 * 보안 필터에 적용받지 않도록 문자열 변환
 */
function fConvertSecuStr(sHtmlString)
{
	var sContents = sHtmlString;
	sContents = sContents.replaceAll("\n", "<br>");

	return sContents;
}




/**
 * class이름을 가지고 있는 객체의 값을 input 값으로 변경한다.
 *
 * @param inputObj 값을 입력한 객체
 * @param targetClass class ID
 * @param node 검색범위 (생략하면 document가 기본값
 * @return 대상건이 있으면 true 없으면 false
 */
function replaceInput(inputObj, targetClass, node)
{
	var t;
	var inputVal;

	//alert(typeof(inputObj));
	if(typeof(inputObj) == "object")
		inputVal = inputObj.value;
	else if(typeof(inputObj) == "string")
		inputVal = inputObj;

	if(node == null)
		t = getElementsByClass(targetClass);
	else
		t = getElementsByClass(targetClass, node);

	for(var i=0; i<t.length; i++)
	{
		if(t[i].tagName == "INPUT"){
			t[i].value = inputVal;
		}else if(t[i].tagName == "SELECT"){
			t[i].value = inputVal;
		}else if(t[i].tagName == "SPAN"){
			t[i].innerHTML	=	inputVal.replace("&","&amp;");
		}else if(t[i].tagName == "DIV"){
			t[i].innerHTML	=	inputVal.replace("&","&amp;");
		}
			
	}
	if(t.length > 0)
		return 1;
	else 
		return 0;
}

// 같은 클래스명을 가진 객체를 모두 찾아낸다.
function getElementsByClass(searchClass,node,tag)
{
	var classElements = new Array();
	if ( node == null ) node = document;
	if ( tag == null ) tag = '*' ;
	var els = node.getElementsByTagName(tag);
	var elsLen = els.length;
	//var pattern = new RegExp("(^|s)" +searchClass+"(s|$)");
	var pattern = new RegExp("(^| )" +searchClass+"( |$)");
	for (i = 0, j = 0; i < elsLen; i++) {
		if( pattern.test(els[i].className) ) {
			classElements[j] = els[i];
			j++;
		}
	}
	return classElements;
}

function tabView(index) {
	// 최대 6개의 sub 양식까지만
	for(var i=0; i<=15; i++)
	{
		if(i == index)
		{
			document.getElementById("tab_"+i).className = 'tab_on';
			document.getElementById("__html_"+i).style.display = '';
		}
		else
		{
			if(document.getElementById("tab_"+i) != null)
			{
				document.getElementById("tab_"+i).className = 'tab_off';
				document.getElementById("__html_"+i).style.display = 'none';
			}
		}
	}
}

// 
/**
 * 문서를 배열 컨트롤로 만든다.
 * 
 * f : form명
 * ctrName : 생성 input 명
 * bRemoveInput : input tag display 여부(true: display none)
 * seq : 특정탭 html 지정
 */
function splitHtml(f, ctrName, bRemoveInput){
	
	for(var i=0; i<=15; i++)
	{
		if( document.getElementById("__html_"+i) != null )
		{
			if(document.getElementById(ctrName+"_"+i)){
				var node = document.getElementById(ctrName+"_"+i)
				node.parentNode.removeChild(node);
			}
			var __htmlCtrl = document.createElement("input");	// control을 위한 임시 form
			__htmlCtrl.setAttribute("type", "hidden");
			__htmlCtrl.setAttribute("name", ctrName);
			__htmlCtrl.setAttribute("id", ctrName+"_"+i);
			if(bRemoveInput){ // input tag의 display를 none으로 변경(pdf용)
				removeInput(document.getElementById("__html_"+i), __htmlCtrl);
			}else{
				__htmlCtrl.value =  document.getElementById("__html_"+i).innerHTML;
			}
			__htmlCtrl.value = Base64.encode(__htmlCtrl.value);

			f.insertBefore(__htmlCtrl, f.lastChild);
		}
	}
}

/*innerHTML 에서 사용자 입력 값을 못 가져오 기 때문에 선작업 합니다.*/
function setDivInputValue(target_id){
	var div = document.getElementById(target_id);
	
	var elems = div.getElementsByTagName("input");
	for(var i=0;i<elems.length;i++){
		var elem = elems[i];
		if(inArray(elem['type'].toLowerCase(),["text","hidden"])){
			setElementValue(elem,elem.value);
		}
		if(inArray(elem['type'].toLowerCase(),["checkbox","radio"])){
			if(elem.checked)elem.setAttribute("checked","true");
		}
	}
	
	elems = div.getElementsByTagName("select");
	for(var i=0;i<elems.length;i++){
		var elem = elems[i];
		setElementValue(elem,elem.value);
	}
	
	elems = div.getElementsByTagName("textarea");
	for(var i=0;i<elems.length;i++){
		var elem = elems[i];
		if(elem.tagName.toLowerCase() == "select"){
			setElementValue(elem,elem.value);
		}
	}
	
	elems = div.getElementsByTagName("textarea");
	for(var i=0;i<elems.length;i++){
		var elem = elems[i];
		setElementValue(elem,elem.value);
	}
}


// 광고 팝업
function popup_open( name, idx, iwidth, iheight, left  ){
	if ( GetCookie( idx ) != "done" ) {
		fLayerPop(idx, name, iwidth, iheight, left, 100);
	}
}

/*===================================================*/
var days_k=new Array()
days_k[0]="일";
days_k[1]="월";
days_k[2]="화";
days_k[3]="수";
days_k[4]="목";
days_k[5]="금";
days_k[6]="토";

var v_sYear="";
var v_sMonth="";
var v_sDay="";
var v_sHour;
var v_sMinute="";
var v_sSecond="";
var v_sD="";
var id1=null;
var id2=null;
var xx=null;
var v_Hour="";
var v_Minute="";
var v_Second="";
var v_url = null;

function StartClock(servertime, st, milli_sec, url){
	v_url = url
	ServerTime(servertime, st);
	clearTimeout(id2);
  	//id2=setTimeout("Refresh()",milli_sec);
}

function Refresh(){
	window.location = v_url;
}

/**********************************
	서버시간을 YYYYMMDDHH24MI 변환
************************************/
function getYYYYMMDDHH24MI(sSrvTime)
{
	var	_sSrvTime	=	"";
	sSrvTime	=	sSrvTime.replaceAll(" ","");
	sSrvTime	=	sSrvTime.replaceAll("(월)","");
	sSrvTime	=	sSrvTime.replaceAll("(화)","");
	sSrvTime	=	sSrvTime.replaceAll("(수)","");
	sSrvTime	=	sSrvTime.replaceAll("(목)","");
	sSrvTime	=	sSrvTime.replaceAll("(금)","");
	sSrvTime	=	sSrvTime.replaceAll("(토)","");
	sSrvTime	=	sSrvTime.replaceAll("(일)","");
	sSrvTime	=	sSrvTime.replaceAll("년","|");
	sSrvTime	=	sSrvTime.replaceAll("월","|");
	sSrvTime	=	sSrvTime.replaceAll("일","|");
	sSrvTime	=	sSrvTime.replaceAll(":","");

	var	aArry	=	sSrvTime.split("|");

	var	sYear		=	aArry[0];
	var	sMonth	=	aArry[1];
	var	sDay		=	aArry[2];
	var	sTime		=	aArry[3].substring(0,4);

	if(sMonth.length < 2)	sMonth = "0" + sMonth;
	if(sDay.length < 2)		sDay = "0" + sDay;
	
	_sSrvTime	=	sYear + sMonth + sDay + sTime; 
	
	return _sSrvTime;
}

function ServerTime(servertime, st){
	var systime = st;
	servertime.value = systime;
	systime = servertime.value;
	v_sYear = new Number(systime.substring(0, 4));
	v_sMonth = new Number(systime.substring(4, 6));
	v_sDay = new Number(systime.substring(6, 8));
	v_sHour = new Number(systime.substring(8, 10));
	v_sMinute = new Number(systime.substring(10, 12));
	v_sSecond = new Number(systime.substring(12, 14));
	v_sD = new Number(systime.substring(14, 15)) - 1;
//기존
//	v_sHour = new Number(systime.substring(9, 11));
//	v_sMinute = new Number(systime.substring(11, 13));
//	v_sSecond = new Number(systime.substring(13, 15));
//	v_sD = new Number(systime.substring(15, 16)) - 1;
	WorldTime(servertime);
}

function WorldTime(servertime){
	var leapyear2 = LeapYear2(v_sYear);
	if(v_sMinute<0){
  		v_sMinute = 60 + v_sMinute;
  		v_sHour = v_sHour - 1;
  	}

  	if(v_sHour<0){
  		v_sHour = 24 + v_sHour;
  		v_sDay = v_sDay - 1;
  		v_sD--;
  		if(v_sD < 0) v_sD = 6;
  	}

  	if(v_sDay<=0){
  		v_sMonth = v_sMonth - 1;
  		if(v_sMonth==1||v_sMonth==3||v_sMonth==5||v_sMonth==7||v_sMonth==8||v_sMonth==10||v_sMonth==12)
  			v_sDay = 31 + v_sDay;
  		else if(v_sMonth==4||v_sMonth==6||v_sMonth==9||v_sMonth==11)
  			v_sDay = 30 + v_sDay;
  		else if(v_sMonth==2 && leapyear2=="true")
  			v_sDay = 29 + v_sDay;
  		else if(v_sMonth==2 && leapyear2!="true")
  			v_sDay = 28 + v_sDay;
  		else if(v_sMonth<1){
  			v_sYear = v_sYear - 1;
  			v_sMonth = 11;
  			v_sDay = 31;
  		}
  	}
  	if(v_sSecond>=60){
  		v_sSecond = v_sSecond - 60;
  		v_sMinute = v_sMinute + 1;
  	}

	if(v_sMinute>=60){
  		v_sMinute = v_sMinute-60;
  		v_sHour = v_sHour + 1;
    }
  	if(v_sHour>=24){
  		v_sHour = v_sHour - 24;
  		v_sDay = v_sDay + 1;
  		v_sD++;
  		if(v_sD > 6) v_sD = 0;
  	}

    if(v_sMonth==1||v_sMonth==3||v_sMonth==5||v_sMonth==7||v_sMonth==8||v_sMonth==10){
		if(v_sDay>31){
			v_sDay = 1;
			v_sMonth = v_sMonth + 1;
		}
	}
	else if(v_sMonth==4||v_sMonth==6||v_sMonth==9||v_sMonth==11){
		if(v_sDay>30){
			v_sDay = 1;
			v_sMonth = v_sMonth + 1;
		}
	}
	else if(v_sMonth==2 && leapyear2=="true"){
		if(v_sDay>29){
			v_sDay = 1;
			v_sMonth = v_sMonth + 1;
		}
	}
	else if(v_sMonth==2 && leapyear2!="true"){
		if(v_sDay>28){
			v_sDay = 1;
			v_sMonth = v_sMonth + 1;
		}
	}
	else if(v_sMonth==12){
		if(v_sDay>31){
			v_sDay = 1;
			v_sMonth = 0;
			v_sYear = v_sYear + 1;
		}
    }


    var aaa = new Date(v_sYear, v_sMonth-1, v_sDay, v_sHour, v_sMinute);
    var bbb = aaa.getDay();
//  (v_sDay<10) ? v_sDay=" "+v_sDay : v_sDay;
    (v_sHour<10) ? v_Hour="0"+v_sHour : v_Hour=v_sHour;
    (v_sMinute<10) ? v_Minute="0"+v_sMinute : v_Minute=v_sMinute;
    (v_sSecond<10) ? v_Second="0"+v_sSecond : v_Second=v_sSecond;

    v_ST=v_Hour + ":" + v_Minute + ":" + v_Second;
	
	servertime.value=v_sYear + "년 " + v_sMonth + "월 " + v_sDay + "일(" + days_k[bbb] + ") " + v_ST;
	//document.form.servertime.value=v_sYear + "년 " + v_sMonth + "월 " + v_sDay + "일 " + v_ST;
	xx = servertime;
    ++v_sSecond;
    clearTimeout(id1);			// 메모리 clear -할당된 메모리 영역을 반환하지 않음으로써 시스템 부하발생... 중요.
    id1=setTimeout("WorldTime(xx)",1000);
}

function LeapYear2(year){
	if((year%4)==0) return "true";
}

// Layer Popup 오픈
function fLayerPop(layerID, htmlSrc, width, height, xPos, yPos)
{
	adjX = xPos ? xPos : (document.body.scrollWidth/2 - width/2);
	adjY = yPos ? yPos : (document.body.clientHeight/2 - height/2);		
	
	var	iframe = document.createElement('iframe');
	iframe.style.position	= "absolute";
	iframe.style.width		= width+"px";
	iframe.style.height		= height+"px";
	iframe.style.top		= adjY+"px";
	iframe.style.left		= adjX+"px";


	// 오른쪽 경계 넘어가면 위치 조정
	var xMax = parseInt(document.body.clientWidth);
	if( (parseInt(adjX)+parseInt(iframe.style.width)) > xMax)
		iframe.style.left = xMax - parseInt(iframe.style.width) - 20;

	iframe.id					= layerID;
	iframe.style.zIndex			= 11;
	iframe.style.marginwidth	= "0px";
	iframe.style.marginheight	= "0px";
	iframe.style.scrolling		= "no";
	iframe.style.frameBorder	= "0px";
	iframe.src					= htmlSrc;
	document.body.appendChild(iframe);

}


// Layer Popup 닫기
function fLayerPopClose(layerID)
{
	var	oNode	=	parent.document.getElementById(layerID);
	if(oNode != null)
	{
		parent.document.body.removeChild(oNode);
	}
}

// 거래처 코드 입력
function fPopCD(cont_no, cont_chasu, cust_member_no)
{
	var	xpos  = event.x;
	var	ypos  = event.y + document.body.scrollTop;  // scroll 고려
	fLayerPopClose('agent_cd');
	fLayerPop('agent_cd', './pop_person_cd.jsp?cont_no='+cont_no+'&cont_chasu='+cont_chasu+'&cust_member_no='+cust_member_no, 200, 130, xpos, ypos);
}

/*
	공급가액으로 부가세 및 총액(계약금액)를 자동계산한다.
	 - sSuppMoney : 공급가액
	 - sVatObject : 부가세를 숫자로 표시할 객체(ID or NAME)
	 - sHanVatObject : 부가세 한글로 표시할 객체(ID or NAME)
	 - sTotObject : 계약금액 숫자로 표시할 객체(ID or NAME)
	 - sHanTotObject : 계약금액 한글로 표시할 객체(ID or NAME)
*/
function fSetAutoSuppTot(sSuppMoney, sVatObject, sHanVatObject, sTotObject, sHanTotObject)
{
	// 처음 body onload시에는 적용하지 않는다.
	//if(isOnload != true)
	{
		var nSuppMoney = sSuppMoney.replace(/,/g, "") - 0;
		var nVatMoney = Math.floor(nSuppMoney / 10);
		var sVatMoney = nVatMoney + "";
		var sTotalMoney = (nSuppMoney + nVatMoney) + "";

		var oVatObject = document.getElementById(sVatObject);  // 부가가치세 객체
		var oTotObject = document.getElementById(sTotObject);  // 계약금액 객체

		if(sSuppMoney.length == 0||sSuppMoney == "-")
		{
			// 부가가치세
			oVatObject.value = "";				// 숫자금액
			if(sHanVatObject!="")fSetKoreanMoney("", sHanVatObject);	// 한글금액

			// 계약금액
			oTotObject.value = "";				// 숫자금액
			if(sHanTotObject!="")fSetKoreanMoney("", sHanTotObject);	// 한글금액
		}
		else
		{
			// 부가가치세
			oVatObject.value = fnMakeComma2(sVatMoney);	// 숫자금액
			if(sHanVatObject!="")fSetKoreanMoney(sVatMoney, sHanVatObject);	// 한글금액

			// 계약금액
			oTotObject.value = fnMakeComma2(sTotalMoney);	// 숫자금액
			if(sHanTotObject!="")fSetKoreanMoney(sTotalMoney, sHanTotObject);	// 한글금액
		}
	}
}

function fSetAutoSuppTot2(sSuppMoney, sVatObject, sTotObject)
{
	var nSuppMoney = sSuppMoney.replace(/,/g, "") - 0;
	var nVatMoney = Math.floor(nSuppMoney / 10);
	var sVatMoney = nVatMoney + "";
	var sTotalMoney = (nSuppMoney + nVatMoney) + "";

	var oVatObject = document.getElementById(sVatObject);  // 부가가치세 객체
	var oTotObject = document.getElementById(sTotObject);  // 계약금액 객체

	if(sSuppMoney.length == 0)
	{
		// 부가가치세
		oVatObject.value = "";				// 숫자금액

		// 계약금액
		oTotObject.value = "";				// 숫자금액
	}
	else
	{
		// 부가가치세
		oVatObject.value = fnMakeComma2(sVatMoney);	// 숫자금액

		// 계약금액
		oTotObject.value = fnMakeComma2(sTotalMoney);	// 숫자금액
	}
}

/*
	공급가액으로 부가세 및 총액(계약금액)를 자동계산한다.
	 - sBasisObject : % 값의 기준 객체(ID or NAME)
	 - sOutputObject : % 계산값 표시할 객체(ID or NAME)
	 - sPersentValue : % 값(문자열)
*/
function fSetAutoPersent(sBasisObject, sOutputObject, sPersentValue)
{
	var oBasisObject = document.getElementById(sBasisObject);  // %기준객체
	var oOutputObject = document.getElementById(sOutputObject);  // %출력객체
	var nPersentValue = sPersentValue.replace(/,/g, "") - 0;	// %값

	oOutputObject.value = Math.floor(oBasisObject.value.replace(/,/g, "") * sPersentValue / 100);
	if(oOutputObject.value == 0)
		oOutputObject.value = "";
	else 
		oOutputObject.value = fnMakeComma2(oOutputObject.value);
}

/*
부가세로 총액(계약금액)을 자동계산한다.
 - sVatMoney : 부가세액
 - sSuppObject : 공급가액 객체(ID or NAME)
 - sTotObject : 계약금액 숫자로 표시할 객체(ID or NAME)
 - sHanTotObject : 계약금액 한글로 표시할 객체(ID or NAME)
*/
function fSetVatTot(sVatMoney, sSuppObject, sTotObject, sHanTotObject)
{
	var oSuppObject = document.getElementById(sSuppObject);  // 공급가액 객체
	var oTotObject = document.getElementById(sTotObject);  // 계약금액 객체

	var nSuppMoney = oSuppObject.value.replace(/,/g, "") - 0;
	var nVatMoney = sVatMoney.replace(/,/g, "") - 0;

	var sTotalMoney = (nSuppMoney + nVatMoney) + "";


	// 계약금액
	oTotObject.value = fnMakeComma2(sTotalMoney);	// 숫자금액
	if(sHanTotObject){
		fSetKoreanMoney(sTotalMoney, sHanTotObject);	// 한글금액
	}
}


// class이름을 가지고 있는 block 을 보여줄지 말지 결정한다. (영구적임-내용을 아예 삭제함)
function displayBlock(bShow, targetClass, node)
{
	var t;

	if(node == null)
		t = getElementsByClass(targetClass);
	else
		t = getElementsByClass(targetClass, node);

	for(var i=0; i<t.length; i++)
	{
		if(bShow)
			t[i].style.display = "";
		else
		{
			t[i].innerHTML = "";
			t[i].style.display = "none";
		}
	}

	if(t.length > 0)
		return 1;
	else 
		return 0;
}

// class이름을 가지고 있는 block 을 보여줄지 말지 결정한다. (일시적임-display 숨기고 보여짐)
function displayBlock2(bShow, targetClass, node)
{
	var t;

	if(node == null)
		t = getElementsByClass(targetClass);
	else
		t = getElementsByClass(targetClass, node);

	for(var i=0; i<t.length; i++)
	{
		if(bShow)
			t[i].style.display = "";
		else
		{
			t[i].style.display = "none";
		}
	}

	if(t.length > 0)
		return 1;
	else 
		return 0;
}

//id 객체의 값을 클립보드에 복사한다.
function toclip(id){	
	var input = document.createElement('textarea');
	input.style.position = 'fixed';
	input.style.opacity = 0;
	if(document.getElementById(id).tagName.toLowerCase() == "input"){
		input.value = document.getElementById(id).value;
	}
	if(document.getElementById(id).tagName.toLowerCase() == "div"){
		input.value = document.getElementById(id).innerHTML;
	}
	document.body.appendChild(input);
	input.select();
	document.execCommand('Copy');
	document.body.removeChild(input);
	alert('복사 되었습니다.\nCtrl+v를 눌러 붙여넣기하세요.');
}

/******************************************
Ajax 사용해서 데이터 가져오기(param 직접지정)
사용법 : 
	var sRet = WCAjax_submitParam(this,"getTaxXml.jsp","issueNum="+issueNum);
	jsp단의 데이터 구성 방법 <ajax_response>리턴 데이터</ajax_response>
******************************************/
function WCAjax_submitParam(wSrcWnd,sAction,sParam)
{
try
{
	var objXML = WCAjax_getXMLHttpRequest();
	objXML.open("POST",sAction,false);
	objXML.setRequestHeader("Content-Type","application/x-www-form-urlencoded;charset=euc-kr'");
	objXML.setRequestHeader("ajax", "true");
	objXML.send(sParam);

	var sData = objXML.responseText;
	var nLen = sData.length;
	{
		var sStartExp = "<ajax_response>";
		var sEndExp = "</ajax_response>";
		var nStart = sData.indexOf(sStartExp);
		if (nStart < 0)
			return null;
		var nEnd = sData.indexOf(sEndExp);
		if (nEnd < 0)
			return null;
		var nStartExpLen = sStartExp.length;
		var sXml = sData.substring(nStart+nStartExpLen,nEnd);
		return sXml;
	}
}
catch (ex)
{
}
}




/******************************************
Ajax 사용해서 데이터 가져오기(form 이용 자동구성)
사용법 : 
	var sRet = WCAjax_submitParam(this,document.form);
	jsp단의 데이터 구성 방법 <ajax_response>리턴 데이터</ajax_response>
******************************************/
function WCAjax_submitForm(wSrcWnd,fParam)
{
try
{
	var sParam = WCAjax_getFormQueryString(fParam);
	var sAction = fParam.action;
	var rReturn = WCAjax_submitParam(wSrcWnd,sAction,sParam);
	return rReturn;
}
catch (ex)
{
}
}

function WCAjax_submitForm2(wSrcWnd,fParam)
{
try
{
	var sParam = WCAjax_getFormQueryString2(fParam);
	var sAction = fParam.action;
	var rReturn = WCAjax_submitParam(wSrcWnd,sAction,sParam);
	return rReturn;
}
catch (ex)
{
}
}

/******************************************
Ajax 기본 라이브러리
******************************************/
function WCAjax_getFormQueryString(docForm)
{
if (docForm == null)
	return null;
var submitContent = '';
var formElem;
var lastElemName = '';

for (i = 0; i < docForm.elements.length; i++)
{
	formElem = docForm.elements[i];
	switch (formElem.type) 
	{
		case 'text':
		case 'hidden':
		case 'password':
		case 'textarea':
		case 'select-one':
			submitContent += formElem.name + '=' + escape(formElem.value).replace(/\+/g, '%2B') + '&'
			break;
		case 'radio': // Radio buttons
			if (formElem.checked)
			{
				submitContent += formElem.name + '=' + escape(formElem.value).replace(/\+/g, '%2B') + '&'
			}
			break;
		case 'checkbox': // Checkboxes
			if (formElem.checked) 
			{
				{
					submitContent += formElem.name + '=' + escape(formElem.value).replace(/\+/g, '%2B');
				}
				submitContent += '&';
				lastElemName = formElem.name;
			}
		break;
	}
}
submitContent = submitContent.substr(0, submitContent.length - 1);
return submitContent;
}


/******************************************
Ajax 기본 라이브러리
******************************************/
function WCAjax_getFormQueryString2(docForm)
{
if (docForm == null)
	return null;
var submitContent = '';
var formElem;
var lastElemName = '';

for (i = 0; i < docForm.elements.length; i++)
{
	formElem = docForm.elements[i];
	switch (formElem.type) 
	{
		case 'text':
		case 'hidden':
		case 'password':
		case 'textarea':
		case 'select-one':
			submitContent += formElem.name + '=' + escape(encodeURIComponent(formElem.value)) + '&'
			break;
		case 'radio': // Radio buttons
			if (formElem.checked)
			{
				submitContent += formElem.name + '=' + escape(encodeURIComponent(formElem.value)) + '&'
			}
			break;
		case 'checkbox': // Checkboxes
			if (formElem.checked) 
			{
				{
					submitContent += formElem.name + '=' + escape(encodeURIComponent(formElem.value));
				}
				submitContent += '&';
				lastElemName = formElem.name;
			}
		break;
	}
}
submitContent = submitContent.substr(0, submitContent.length - 1);
return submitContent;
}

/******************************************
Ajax 기본 라이브러리
******************************************/
function WCAjax_getXMLHttpRequest()
{
try
{
	if (window.XMLHttpRequest) 
	{
		var xmlHttp = new XMLHttpRequest();
		return xmlHttp;
	}
	else if (window.ActiveXObject) 
	{
		var xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
		return xmlHttp;
	}
}
catch (ex)
{
}
}

function __WS__(__NSID__)
{
	var	sTag	=	__NSID__.innerHTML;
	sText	=	sTag;
	document.write(sText);
	__NSID__.id = "";
}


function inArray(val, arr){
	for(var i = 0 ; i < arr.length; i++){
		if(val == arr[i]){
			return true;
			break;
		}
	}
	return false;
}

// input box 클릭시 이미지 비우기
function OutputBackImg(input_obj){
	input_obj.style.backgroundImage = "";
}
 
// input box 에서 inblur 됐을시
function InputBackImg(input_obj,img_name){
	if(input_obj.value == ""){
		input_obj.style.backgroundImage = "url(" + img_name + ")"; 
	}
}

// 성별문자
function getGenderHan(inputGenNum, retSize) {
	
	var sGenderHan = "";
	if(inputGenNum == "1" || inputGenNum == "3")
		sGenderHan = retSize==1 ? "남" : "남자";
	else
		sGenderHan = retSize==1 ? "여" : "여자";
	
	return sGenderHan;
}

function getBirthHan(inputBirth, retType) {
	
	var sBirthHan = "";
	
	if(inputBirth.substring(0,2) > 25)
	{
		if(retType==1)
			sBirthHan = "19" + inputBirth.substring(0,2) + "-" + inputBirth.substring(2,4) + "-" + inputBirth.substring(4,6);
		else
			sBirthHan = "19" + inputBirth.substring(0,2) + "년 " + inputBirth.substring(2,4) + "월 " + inputBirth.substring(4,6) + "일";
	} else {
		if(retType==1)
			sBirthHan = "20" + inputBirth.substring(0,2) + "-" + inputBirth.substring(2,4) + "-" + inputBirth.substring(4,6);
		else
			sBirthHan = "19" + inputBirth.substring(0,2) + "년 " + inputBirth.substring(2,4) + "월 " + inputBirth.substring(4,6) + "일";
	}
	
	return sBirthHan;
}


function autoTextAreaHeight(obj, defaultHeight){
	if(obj){
		if(obj.scrollHeight>defaultHeight){
			obj.style.height = obj.scrollHeight+"px";
		}else{
			obj.style.height = defaultHeight+"px";
		}
	}
}


var Base64 = {

		// private property
		_keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",

		// public method for encoding
		encode : function (input) {
			var output = "";
			var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
			var i = 0;

			input = Base64._utf8_encode(input);

			while (i < input.length) {

				chr1 = input.charCodeAt(i++);
				chr2 = input.charCodeAt(i++);
				chr3 = input.charCodeAt(i++);

				enc1 = chr1 >> 2;
				enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
				enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
				enc4 = chr3 & 63;

				if (isNaN(chr2)) {
					enc3 = enc4 = 64;
				} else if (isNaN(chr3)) {
					enc4 = 64;
				}

				output = output +
				this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
				this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);

			}

			return output;
		},

		// public method for decoding
		decode : function (input) {
			var output = "";
			var chr1, chr2, chr3;
			var enc1, enc2, enc3, enc4;
			var i = 0;

			input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");

			while (i < input.length) {

				enc1 = this._keyStr.indexOf(input.charAt(i++));
				enc2 = this._keyStr.indexOf(input.charAt(i++));
				enc3 = this._keyStr.indexOf(input.charAt(i++));
				enc4 = this._keyStr.indexOf(input.charAt(i++));

				chr1 = (enc1 << 2) | (enc2 >> 4);
				chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
				chr3 = ((enc3 & 3) << 6) | enc4;

				output = output + String.fromCharCode(chr1);

				if (enc3 != 64) {
					output = output + String.fromCharCode(chr2);
				}
				if (enc4 != 64) {
					output = output + String.fromCharCode(chr3);
				}

			}

			output = Base64._utf8_decode(output);

			return output;

		},

		// private method for UTF-8 encoding
		_utf8_encode : function (string) {
			string = string.replace(/\r\n/g,"\n");
			var utftext = "";

			for (var n = 0; n < string.length; n++) {

				var c = string.charCodeAt(n);

				if (c < 128) {
					utftext += String.fromCharCode(c);
				}
				else if((c > 127) && (c < 2048)) {
					utftext += String.fromCharCode((c >> 6) | 192);
					utftext += String.fromCharCode((c & 63) | 128);
				}
				else {
					utftext += String.fromCharCode((c >> 12) | 224);
					utftext += String.fromCharCode(((c >> 6) & 63) | 128);
					utftext += String.fromCharCode((c & 63) | 128);
				}

			}

			return utftext;
		},

		// private method for UTF-8 decoding
		_utf8_decode : function (utftext) {
			var string = "";
			var i = 0;
			var c = c1 = c2 = 0;

			while ( i < utftext.length ) {

				c = utftext.charCodeAt(i);

				if (c < 128) {
					string += String.fromCharCode(c);
					i++;
				}
				else if((c > 191) && (c < 224)) {
					c2 = utftext.charCodeAt(i+1);
					string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
					i += 2;
				}
				else {
					c2 = utftext.charCodeAt(i+1);
					c3 = utftext.charCodeAt(i+2);
					string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
					i += 3;
				}

			}

			return string;
		}

	}
	

// 20170414 추가
function fGetKoreanMoney(valStr)
{
    var koreanMoney = "";
    var numVal = trimComma(valStr);

    if ( (numVal != "") && isNum(numVal) )
    {
        koreanMoney = "一金 " + num2han(numVal) + "원整";
    }
	return koreanMoney;
}


function attachOnload(obj){
	if( window.attachEvent ){  // IE의 경우
		window.attachEvent( "onload", obj );
	}else{  // IE가 아닌 경우.
		window.addEventListener( "load", obj , false );
	}
}

function getBrowserInfo(){
	var Browser = { a : navigator.userAgent.toLowerCase() }
	var browserInfo = null;
	var name = navigator.appName;
	var word = "";
	// IE old version ( IE 10 or Lower )
	if ( name == "Microsoft Internet Explorer" ){
		word = "msie ";
	}else{
		
		// IE 11
		if ( Browser.a.search("trident") > -1 ) word = "trident/.*rv:";
		// IE 12  ( Microsoft Edge )
		else if ( Browser.a.search("edge/") > -1 ) word = "edge/";
		
	}
	
	var reg = new RegExp( word + "([0-9]{1,})(\\.{0,}[0-9]{0,1})" );
	if (  reg.exec( Browser.a ) != null  ){
		version = RegExp.$1 + RegExp.$2;
	}
	
	
	if( version > 13){
		browserInfo = {"name":"Internet Explorer", "version":"edge"}
		return browserInfo;
		
	}else{
		
		if( Browser.a.indexOf('msie 6') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.6" }
			return browserInfo;
		}
		if( Browser.a.indexOf('msie 7') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.7" }
			return browserInfo;
		}
		/* IE8 부터는 msie 값으로 브라우저 버전을 분별할수 없음 trident 값으로 해야한다. */
		if( Browser.a.indexOf('trident/4.0') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.8" }
			return browserInfo;
		}
		if( Browser.a.indexOf('trident/5.0') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.9" }
			return browserInfo;
		}
		if( Browser.a.indexOf('trident/6.0') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.10" }
			return browserInfo;
		}
		if( Browser.a.indexOf('trident/7.0') != -1 ) {
			browserInfo = { "name" : "Internet Explorer", "version" : "v.11" }
			return browserInfo;
		}
		
		if( Browser.a.indexOf('edge/12.0') != -1 ) {
			browserInfo = { "name" : "Edge Browser", "version" : "" }
			return browserInfo;
		}
		
		if( !!window.opera ) {
			browserInfo = { "name" : "opera", "version" : "" }
			return browserInfo;
		}
		if( Browser.a.indexOf('safari') != -1 ) {
			browserInfo = { "name" : "safari", "version" : "" }
			return browserInfo;
		}
		if( Browser.a.indexOf('applewebkit/5') != -1 ) {
			browserInfo = { "name" : "safari3", "version" : "" }
			return browserInfo;
		}
		if( Browser.a.indexOf('mac') != -1 ) {
			browserInfo = { "name" : "mac", "version" : "" }
			return browserInfo;
		}
		if( Browser.a.indexOf('chrome') != -1 ) {
			browserInfo = { "name" : "chrome", "version" : "" }
			return browserInfo;
		}
		if( Browser.a.indexOf('firefox') != -1 ) {
			browserInfo = { "name" : "FireFox", "version" : "" }
			return browserInfo;
		}
	}
	return browserInfo;
}

// dksim추가
/******************
계약서pdf viewer
******************/
function contPdfViewerWork(cont_no, cont_chasu, cfile_seq){
    var pdfjs_yn = "";

	browserInfo = getBrowserInfo();

	if(browserInfo['name']=="Internet Explorer"){
		if(browserInfo['version']=="v.10"||browserInfo['version']=="v.11"||browserInfo['version']=="edge"){//ie10부터 지원
			pdfjs_yn = "Y";
		}
	}
	else {
		pdfjs_yn = "Y";
	}

	var link = "/web/admin/work/pop_pdf_viewer.jsp?" 
	           +"cont_no="+cont_no
	           +"&cont_chasu="+cont_chasu
	           +"&cfile_seq="+cfile_seq
			   +"&pdfjs_yn="+pdfjs_yn;

	OpenWindow(link,"cont_pdfViewer",830,800);
}

/******************
Key입력막기
******************/
function key_disabled() {
	var e = window.event;

	if(e.preventDefault) {
		e.preventDefault();
	}
	else {
		e.returnValue = false;
	}
}

/******************
일자범위체크
******************/
function gf_isDateCmp(FromDate, ToDate) {
	FromDate = FromDate.replace(/\-/gi, "");
	ToDate = ToDate.replace(/\-/gi, "");

	return FromDate > ToDate ? false : true;
} 
