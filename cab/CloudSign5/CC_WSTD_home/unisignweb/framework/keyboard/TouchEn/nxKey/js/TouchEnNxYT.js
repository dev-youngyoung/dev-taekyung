var downBasePath = location.protocol+"//"+location.host;
var touchenexBaseDir = "../unisignweb/framework/keyboard/TouchEn";
var nx_useYT = false;
var TouchEnNxInit = false;
var TNK_SR = "";
if (typeof JSON !== "object" || navigator.userAgent.match(/msie 8/i)) {
	try {
		JSON = {};
		if(!nx_useYT){
			document.write("<script type='text/javascript' src='" + touchenexBaseDir + "/cmn/json2.js'></script>");
		}else{
			$.getScript(touchenexBaseDir + "/cmn/json2.js","");
		}
		
		
	} catch(e) {
		alert("json2.js load error");
	}
}

var nxKey = {
	//메인 모듈 및 Protocol 버젼 41
	"processingbar"			: true,
	"processingbarimg"		: touchenexBaseDir + "/nxKey/images/processing.gif",
	"TouchEnNxKey"			: touchenexBaseDir + "/nxKey/js/",
	"TouchEnNxKey_Install"	: touchenexBaseDir + "/nxKey/js/",
	"exproto"				: touchenexBaseDir + "/cmn/",
	"TouchEnNxKey_Interface": touchenexBaseDir + "/nxKey/js/",
	"tkappiver"				: "1.0.0.51",
	"tkappmver"				: "1.0.0.41",
	"exWinVer"				: "1.0.0.54",
	"exWinClient"			: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_32bit.exe",
	"exWin64Ver"			: "1.0.0.54",
	"exWin64Client"			: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_64bit.exe",
	"exWinProtocolVer"		: "1.0.1.981",
	"exWinProtocolDownURL"	: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_32bit.exe",
	"exWin64ProtocolDownURL": downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_64bit.exe",
	"exChromeExtVer"		: "1.0.1.12",
	"exChromeExtDownURL"	: "https://chrome.google.com/webstore/detail/dncepekefegjiljlfbihljgogephdhph",
	"exFirefoxExtVer"		: "1.0.1.12",
	"exFirefoxExtDownURL"	: downBasePath + touchenexBaseDir + "/nxKey/module/touchenex_firefox.xpi",
	"exFirefoxExtIcon"		: "",//48*48 icon
	"exOperaExtVer"			: "1.0.1.12",
	"exOperaExtDownURL"		: downBasePath + touchenexBaseDir + "/nxKey/module/touchenex_opera.nex",
	"blankPath"				: touchenexBaseDir + "/cmn/",
	"json2Path"				: touchenexBaseDir + "/cmn/",
	"tkInstallpage"			: touchenexBaseDir + "/install/install.html"+"?"+"&url=" + encodeURIComponent(window.location.href),	
	"tkMainpage"			: "",
	//전자인증 테스트라이선스 201704017 LSH
	"lic"					: "eyJ2ZXJzaW9uIjoiMS4wIiwiaXNzdWVfZGF0ZSI6IjIwMTcwNDEzMTI0MDQwIiwicHJvdG9jb2xfbmFtZSI6InRvdWNoZW5leCIsInV1aWQiOiI3ZjU5MzA1OTM3NDE0ZTljOTc5NzNiMGZmNWFkM2I3YSIsImxpY2Vuc2UiOiJwZkFDbldHMU90MlZleEpjaVluenhjRFJQVmJwNTNxYTFNNnhDenJKRzZLbEtzWm1Ba0JLcW03aTVpcFVaZGJQY2NrenNTTVhONlViUW5ZZDVDbVIxUT09In0=",
	"exEdgeInfo" : {
		"isUse"			: true,
		"addScript"		: downBasePath + touchenexBaseDir + "/cmn/TouchEnNx_daemon.js",
		"portChecker"	: downBasePath + touchenexBaseDir + "/cmn/TouchEnNx_port_checker.js",
		"localhost"		: "wss://127.0.0.1",
		"edgeStartPort"	: 34581,
		"portChkCnt"	: 3,
		"daemonVer"		: "1.0.2.2",
		"daemonDownURL"	: downBasePath + touchenexBaseDir + "/nxKey/module/TouchEn_nxKey_Installer_32bit.exe"
	}
};

var daemon = {
		SupportBrowser	: ["EDGE", "CHROME", "FIREFOX", "OPERA"],
		info			: {
			isUse			: true,
			portChecker		: downBasePath + touchenexBaseDir + "/cmn/TouchEnNx_port_checker.js",
			localhost		: "wss://127.0.0.1",
			edgeStartPort	: 34581,
			portChkCnt		: 3
		}
};

var TouchEnUtil = {
getOSInfo : function(){
	var
		tp = navigator.platform,
		ua = navigator.userAgent,
		tem;
	var result = {};
	
	// platform
	if (tp == "Win32" || tp == "Win64") result.platform = "WINDOWS";
	else result.platform = "UNKNOWN";
	if(result.platform == "WINDOWS"){
		if(ua.indexOf("Windows NT 5.1") != -1) {result.version="5.1"; result.name="XP";}
		else if(ua.indexOf("Windows NT 6.0") != -1) {result.version="6.0"; result.name="VISTA";}
		else if(ua.indexOf("Windows NT 6.1") != -1) {result.version="6.1"; result.name="7";}
		else if(ua.indexOf("Windows NT 6.2") != -1) {result.version="6.2"; result.name="8";}
		else if(ua.indexOf("Windows NT 6.3") != -1) {result.version="6.3"; result.name="8.1";}
		else if(ua.indexOf("Windows NT 6.4") != -1) {result.version="6.4"; result.name="10";}
		else if(ua.indexOf("Windows NT 10.0") != -1) {result.version="10.0"; result.name="10";}
		else if(ua.indexOf("Windows NT") != -1){
			// TODO
		} else {
			result.version="UNKNOWN"; result.name="UNKNOWN";
		}
		if(ua.indexOf("WOW64") != -1 || ua.indexOf("Win64") != -1) result.bit="64";
		else result.bit="32";
	}
	return result;
},
isWin : function() {
	var OSInfo = TouchEnUtil.getOSInfo().platform;
	if(!OSInfo) OSInfo = TouchEnUtil.getOSInfo().platform;
	if (OSInfo == "WINDOWS") return true;
	return false;
},
getBrowserInfo : function(){
	var
		tp = navigator.platform,
		N= navigator.appName,
		ua= navigator.userAgent,
		tem;
	var result, M;
	
	//exlog("appName", N);
	//exlog("userAgent", ua);
	
	// if Edge
	M = ua.match(/(edge)\/?\s*(\.?\d+(\.\d+)*)/i);
	M = M ? {"browser":"Edge", "version":M[2]} : M;
	
	// if opera
	if(!M){
		M = ua.match(/(opera|opr)\/?\s*(\.?\d+(\.\d+)*)/i);
		if(M && (tem = ua.match(/version\/([\.\d]+)/i)) != null) M[2] = tem[1];
		M = M ? {"browser":"Opera", "version":M[2]} : M;
	}
	
	// if IE7 under
	if(!M) {
		M = ua.match(/MSIE ([67].\d+)/);
		if(M) M = {"browser":"MSIE", "version":M[1]};
	}
	
	// others
	if(!M) {
		M = ua.match(/(msie|trident|chrome|safari|firefox)\/?\s*(\.?\d+(\.\d+)*)/i);
		if(M){
			if((tem = ua.match(/rv:([\d]+)/)) != null) {
				M[2] = tem[1];
			} else if((tem = ua.match(/version\/([\.\d]+)/i)) != null) {
				M[2] = tem[1];
			}
			if(M[1] == "Trident") M[1] = "MSIE";
			M = M? {"browser":M[1], "version":M[2]} : {"browser":N, "version1":navigator.appVersion,"other":'-?'};
		}
	}
	
	if(!M){
		return {"browser":"UNDEFINED", "version":""};
	}
	
	if(M.version){
		var verArr = (M.version).split(".");
		M.version = verArr[0];
	}
	
	if(M.browser == "MSIE" || M.browser == "Edge") {
		if(tp == "Win32"){
			M.bit = "32";
		} else if (tp == "Win64"){
			M.bit = "64";
		}
	}
	
	result = M;
	
	//exlog("CrossEXUtil.getBrowserInfo", result);
	return result;
},
getBrowserVer : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	return browserInfo.version;
},
getBrowserBit : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	return browserInfo.bit;
},
isIE : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if(browserInfo.browser.toLowerCase().indexOf("msie") != -1) {
		return true;
	} else {
		return false;
	}
},
isEdge : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if(browserInfo.browser.toLowerCase().indexOf("edge") != -1) {
		return true;
	} else {
		return false;
	}
},
isChrome : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if(browserInfo.browser.toLowerCase().indexOf("chrome") != -1) {
		return true;
	} else {
		return false;
	}
},
isFirefox : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if(browserInfo.browser.toLowerCase().indexOf("firefox") != -1) {
		return true;
	} else {
		return false;
	}
},
isOpera : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if(browserInfo.browser.toLowerCase().indexOf("opera") != -1) {
		return true;
	} else {
		return false;
	}
},
isSafari : function() {
	var browserInfo = TouchEnUtil.getBrowserInfo();
	if(!browserInfo) browserInfo = TouchEnUtil.getBrowserInfo();
	if((browserInfo.browser).toLowerCase().indexOf("safari") != -1) {
		return true;
	} else {
		return false;
	}
},
"muduleMinVer" : {
	"MSIE"			: "6",
	"chromeMinVer"	: "38",
	"FireFoxMinVer"	: "36",
	"OperaMinVer"	: "26",
	"SafariMinVer"	: "5",
	"Edge"			: "ALL"
	}
};
var useTouchEnnxKey = false;
try{
	if(TouchEnUtil.isWin()){
		if(TouchEnUtil.isIE() && parseInt(TouchEnUtil.getBrowserVer()) >= parseInt(TouchEnUtil.muduleMinVer.MSIE)) useTouchEnnxKey = true;
		else if(TouchEnUtil.isChrome() && parseInt(TouchEnUtil.getBrowserVer()) >= parseInt(TouchEnUtil.muduleMinVer.chromeMinVer)) useTouchEnnxKey = true;
		else if(TouchEnUtil.isFirefox() && parseInt(TouchEnUtil.getBrowserVer()) >= parseInt(TouchEnUtil.muduleMinVer.FireFoxMinVer)) useTouchEnnxKey = true;
		else if(TouchEnUtil.isOpera() && parseInt(TouchEnUtil.getBrowserVer()) >= parseInt(TouchEnUtil.muduleMinVer.OperaMinVer)) useTouchEnnxKey = true;
		else if(TouchEnUtil.isSafari() && parseInt(TouchEnUtil.getBrowserVer()) >= parseInt(TouchEnUtil.muduleMinVer.SafariMinVer)) useTouchEnnxKey = true;
		else if(TouchEnUtil.isEdge())	/*Edge 브라우저 사용 여부*/useTouchEnnxKey = true;
		else useTouchEnnxKey = false;
	} else{
		useTouchEnnxKey = false;
	}
}catch(e){
	useTouchEnnxKey = false;
}
//동작방식 선택
var TOUCHEN_RUNTYPE = "onlydaemon";

UserSelectType();
function UserSelectType()
{
	if (TouchEnUtil.isIE() || (TouchEnUtil.isSafari() && !TouchEnUtil.isChrome())) 
		return;
	
	if(TouchEnUtil.isEdge() || TOUCHEN_RUNTYPE == "onlydaemon")
	{
		nxKey.exEdgeInfo.isUse = true;
		return;
	} 
	else if(TOUCHEN_RUNTYPE == "mainextension")
	{
		if(typeof touchenex_nativecall != "undefined")  
			nxKey.exEdgeInfo.isUse = false; 
   		 else
			nxKey.exEdgeInfo.isUse = true; 
	}
}

if(!nx_useYT){
	document.write("<script type='text/javascript' charset='utf-8' src='" + nxKey.TouchEnNxKey + "TouchEnNxKey_YT.js'></script>");
	document.write("<script type='text/javascript' charset='utf-8' src='" + nxKey.TouchEnNxKey_Install + "TouchEnNxKey_Install.js'></script>");
	document.write("<script type='text/javascript' charset='utf-8' src='" + nxKey.exproto + "TouchEnNx_exproto.js'></script>");
	document.write("<script type='text/javascript' charset='utf-8' src='" + nxKey.TouchEnNxKey_Interface + "TouchEnNxKey_Interface.js'></script>");
	if(nxKey.exEdgeInfo.isUse && useTouchEnnxKey){
		document.write("<script type='text/javascript' src='" + nxKey.exEdgeInfo.addScript + "'></script>");
	}
}else{
	$("a").each(function() {
	    var temp = $(this).attr("href");
	    if ( temp == "#none"
	      || temp == "#a"
	      || temp == "#"
	      || temp == "#n"
	      || temp == "#;"
	      ) {
	        $(this).attr('href','javascript:void(0)');
	    }
	});
	$.getScript(nxKey.TouchEnNxKey + 'TouchEnNxKey_YT.js',function(){
		$.getScript(nxKey.TouchEnNxKey_Install + 'TouchEnNxKey_Install.js',function(){
			$.getScript(nxKey.exproto + 'TouchEnNx_exproto.js',function(){
				$.getScript(nxKey.TouchEnNxKey_Interface + 'TouchEnNxKey_Interface.js',function(){
					if(nxKey.exEdgeInfo.isUse && useTouchEnnxKey){
						$.getScript(nxKey.exEdgeInfo.addScript,function(){
							TK_Loading();
						});
					}else{
						TK_Loading();
					}
				});	
			});
		});
	});
}
//jQuery방식으로 스크립트 로딩을 하지 않은 경우, 별도 로딩함수 호출.
$(document).ready(function(){
	if (typeof TouchEnKey_installpage != "string" && useTouchEnnxKey && !nx_useYT){
		TK_Loading();
	}else{
		/**
		 * 키보드보안 미지원 OS 또는 브라우저입니다. 가상키패드 사용 Default로 변경 필요합니다.
		 * 가상키패드 제품이 없을 경우 안내 페이지로 이동하여 브라우저 업데이트 또는 타 OS사용 권장이 필요합니다.
		**/
	}
});

function TK_initSucuess(){
	//키보드보안 로딩 후 처리 내용을 추가 한다.
	// ex : 첫번째 필드 focus 등등
	// TouchEnNxInit 변수를 통하여, 키보드보안 로딩 여부 구분.
	TouchEnNxInit = true;
	TK_processingbar(false);
}
