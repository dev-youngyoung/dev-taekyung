/*
	CrossEX Prototype Interface
	iniLINE Co.,Ltd.
	%VERSIONINFO%
*/

// TODO Plugin Object Define
var TOUCHENEX;

var downBasePath = location.protocol+"//"+location.host;

// TODO Plugin Info Set
var touchenexInfo = {
	"exPluginCallName"	: "TOUCHENEX",			
	"exPluginName"		: "TOUCHENEX",			
	"exPluginInfo"		: "touchenexInfo",		
	"exModuleName"		: "nxkey",			
	"tkInstallpage"		: nxKey.tkInstallpage,
	"tkMainpage"		: nxKey.tkMainpage, 
	"tkInstalled"		: false,
	"exInstalled"		: false,
	"clInstalled"		: false,
	"exErrFunc"			:"TK_CommonError",
	"exErrFunc2"		: "",//모듈 변조시 FAQ 페이지로 이동 로직 추가
	"lic"				: nxKey.lic,

	// Module Info, 플러그인 설치파일 경로
	"moduleInfo" : {
		"exWinVer"			: nxKey.exWinVer,
		"exWinClient"		: nxKey.exWinClient,
		"exWin64Ver"		: nxKey.exWin64Ver,
		"exWin64Client"		: nxKey.exWin64Client
	},

	// EX Protocol Info, EX를 포함한 플러그인 클라이언트 파일 경로
	"exProtocolInfo" : {
		"exWinProtocolVer"			: nxKey.exWinProtocolVer,
		"exWinProtocolDownURL"		: nxKey.exWinProtocolDownURL,
		"exWin64ProtocolDownURL"	: nxKey.exWin64ProtocolDownURL
	},

	//////////////////////////////////////////////////////////////
	//////       CrossEX AREA DO NOT EDIT !!
	//////////////////////////////////////////////////////////////
	"isInstalled"		: false,
	"exProtocolName"	: "touchenex",
	"exExtHeader"		: "touchenex",
	"exNPPluginId"		: "touchenexPlugin",
	"exNPMimeType"		: "application/x-raon-touchenex",
	"exFormName"		: "__TOUCHENEX_FORM__",
	"exFormDataName"	: "__CROSSEX_DATA__",


	"exEdgeInfo" : {
		"isUse"			: nxKey.exEdgeInfo.isUse,
		"addScript"		: nxKey.exEdgeInfo.addScript,
		"portChecker"	: nxKey.exEdgeInfo.portChecker,
		"localhost"		: nxKey.exEdgeInfo.localhost,
		"edgeStartPort"	: nxKey.exEdgeInfo.edgeStartPort,
		"portChkCnt"	: nxKey.exEdgeInfo.portChkCnt,
		"daemonVer"		: nxKey.exEdgeInfo.daemonVer,
		"daemonDownURL"	: nxKey.exEdgeInfo.daemonDownURL,
		"supportBrowser": ["EDGE"]
	},
	// module minimum specification
	// PASS, ALL, NO
	"checkSpec"	: true,
	"reqSpec"	: {
		"OS"	: {
			"WINDOWS"	: "PASS",	// XP=5.1, VISTA=6.0, Win7=6.1, Win8=6.2, Win8.1=6.3, Win10=6.4/10.0
			"MACOSX"	: "PASS",	// Leopard=10.5, Snow Leopard=10.6, Lion=10.7, Mountain Lion=10.8, Mavericks=10.9, Yosemite=10.10, El Capitan=10.11
			"LINUX"		: "PASS"
		},
		"Browser": {
			"MSIE"		: TouchEnUtil.muduleMinVer.MSIE,
			"EDGE"		: TouchEnUtil.muduleMinVer.Edge,
			"CHROME"	: TouchEnUtil.muduleMinVer.chromeMinVer,
			"FIREFOX"	: TouchEnUtil.muduleMinVer.FireFoxMinVer,
			"OPERA"		: TouchEnUtil.muduleMinVer.OperaMinVer,
			"SAFARI_WIN": TouchEnUtil.muduleMinVer.SafariMinVer,
			"SAFARI_MAC": "PASS"
		}
	},
	//////////////////////////////////////////////////////////////
	//////       CrossEX AREA DO NOT EDIT !!
	//////////////////////////////////////////////////////////////
	"isInstalled"		: false,				
	"exProtocolName"	: "touchenex",
	"exExtHeader"		: "touchenex",
	"exNPPluginId"		: "touchenexPlugin",
	"exNPMimeType"		: "application/x-raon-touchenex",
	"exSiteName"		: "raon",
	// Extension Info
	"exExtensionInfo" : {
		"exChromeExtVer"		: nxKey.exChromeExtVer,
		"exChromeExtDownURL"	: nxKey.exChromeExtDownURL,
		"exFirefoxExtVer"		: nxKey.exFirefoxExtVer,
		"exFirefoxExtDownURL"	: nxKey.exFirefoxExtDownURL,
		"exFirefoxExtIcon"		: nxKey.exFirefoxExtIcon,//48*48 icon
		"exOperaExtVer"			: nxKey.exOperaExtVer,
		"exOperaExtDownURL"		: nxKey.exOperaExtDownURL
	}
};

/****************************
 ** edge condition
 ** include exproto_ext_daemon.js
 ****************************/
function touchenexEdgeCond(){
	return touchenexInfo.exEdgeInfo.isUse && TOUCHENEX_UTIL.isEdge();
}
if(touchenexEdgeCond()){
//	document.write("<script type='text/javascript' src='" + touchenexInfo.exEdgeInfo.addScript + "'></script>");
}

// TODO Plugin Interface Define
var touchenexInterface = {
	TestEXPush : function( params ){
		TOUCHENEX.SetPushCallback("new", params);
	},
	
	TestEXPushAdd : function( params ){
		TOUCHENEX.SetPushCallback("add", params);
	},
	
	//////////////////////////////////////////////
	// UserDefinition Interface Code Area......
	//////////////////////////////////////////////
	
	
	//=======================================================
	// start here...

	TK_Request : function( params, callback ){
		var exCallback = "touchenexInterface.TK_RequestCallback";
		TOUCHENEX.Invoke("Request", params, exCallback, callback);
	},
	
	TK_RequestCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_RequestCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_RequestCallback [exception] result", result);
			exalert("touchenexInterface.TK_RequestCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},
	
	GetEncData : function( params, callback){
			var exCallback = "touchenexInterface.GetEncDataCallback";
			TOUCHENEX.Invoke("GetEncData", params, exCallback, callback);		
	},
	
	
	GetEncDataCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.GetEncDataCallback", result);
			if(result.callback){
				eval(result.callback)(result);
			}
		} catch (e) {
			exlog("touchenexInterface.GetEncDataCallback [exception] result", result);
			exalert("touchenexInterface.GetEncDataCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},


	TK_Start : function( params, callback ){
		exlog("TK_Start.params", params);
		var exCallback = "touchenexInterface.TK_StartCallback";
		TOUCHENEX.Invoke("Key_Start", params, exCallback, callback);
	},
	
	TK_StartCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_StartCallback", result);
			//exalert("touchenexInterface.TK_StartCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_StartCallback [exception] result", result);
			exalert("touchenexInterface.TK_StartCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},
	
	TK_Init : function( params, callback ){
		exlog("TK_Init.params", params);
		var exCallback = "touchenexInterface.TK_InitCallback";
		TOUCHENEX.Invoke("Key_Init", params, exCallback, callback);
	},
	
	TK_InitCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_InitCallback", result);
			//exalert("EXInterface.TK_StartCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_InitCallback [exception] result", result);
			exalert("touchenexInterface.TK_InitCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_Stop : function( params, callback ){

		var exCallback = "touchenexInterface.TK_StopCallback";
		TOUCHENEX.Invoke("Key_Stop", params, exCallback, callback);
	},

	TK_StopCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_StopCallback", result);
			//exalert("touchenexInterface.TK_StopCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_StopCallback [exception] result", result);
			exalert("touchenexInterface.TK_StopCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_RealStop : function( params, callback ){

		var exCallback = "touchenexInterface.TK_RealStopCallback";
		TOUCHENEX.Invoke("Key_RealStop", params, exCallback, callback);
	},

	TK_RealStopCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_RealStopCallback", result);
			//exalert("touchenexInterface.TK_StopCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_RealStopCallback [exception] result", result);
			exalert("touchenexInterface.TK_RealStopCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	},

	TK_KeyDown : function( params, callback ){

		var exCallback = "touchenexInterface.TK_KeyDownCallback";
		TOUCHENEX.Invoke("Key_Keydown", params, exCallback, callback);
	},

	TK_KeyDownCallback : function( result ) {
		try{
			var strSerial = JSON.stringify(result);
			exlog("touchenexInterface.TK_KeyDownCallback", result);
			//exalert("touchenexInterface.TK_KeyDownCallback", result);
			eval(result.callback)(result.reply);
		} catch (e) {
			exlog("touchenexInterface.TK_KeyDownCallback [exception] result", result);
			exalert("touchenexInterface.TK_KeyDownCallback", "처리중 오류가 발생하였습니다.\n" + "result : "+result + "\nexception : " + e);
		}
	}

};