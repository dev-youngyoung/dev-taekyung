/**
 * fileDownload sample script
 */
var TOUCHENEX_INSTALL = {
	
	installWindow : null,
	
	download : function( moduleName, type ) {
		
		//2016-07-05
		var downloadInfo = touchenexInfo;
		try{
			if(moduleName =="nxkey"){
				downloadInfo = touchenexInfo;
			}else if(moduleName =="nxwirelesscert"){
				downloadInfo = keysharpnxInfo;
			}else if(moduleName	=="nxweb"){
				downloadInfo = touchennxwebInfo;
			}else if(moduleName == "nxfirewall"){
				downloadInfo = touchennxfwInfo;
			}
		}catch(e){}
		
		var pluginInfo = {};
		for(var i = 0; i < TOUCHENEX_CONST.pluginInfo.length; i++){
			if(TOUCHENEX_CONST.pluginInfo[i].exModuleName == moduleName){
				pluginInfo = TOUCHENEX_CONST.pluginInfo[i];
				//exlog("_INSTALL.download", pluginInfo);
				break;
			}
		}
		var dummyParam = "dummy="+Math.floor(Math.random() * 10000) + 1;
		
		// Extension
		if(type == "extension"){
			
			if(TOUCHENEX_UTIL.isChrome()){
				
				if(!this.installWindow || this.installWindow.closed){
					this.installWindow = window.open(touchenexInfo.exExtensionInfo.exChromeExtDownURL);
					if(this.installWindow == null) alert("팝업차단을 확인해주세요.");
				}
				
			} else if(TOUCHENEX_UTIL.isFirefox()) {
				
				var params = {};
				dummyParam = "ver=" + touchenexInfo.exExtensionInfo.exFirefoxExtVer;
				
				params[touchenexInfo.exProtocolName + "_firefox"] = {
					URL: touchenexInfo.exExtensionInfo.exFirefoxExtDownURL + "?" + dummyParam,
					IconURL: touchenexInfo.exExtensionInfo.exFirefoxExtIcon
				};
				InstallTrigger.install(params);
				
			} else if(TOUCHENEX_UTIL.isOpera()) {
				
				dummyParam = "ver=" + touchenexInfo.exExtensionInfo.exOperaExtVer;
				location.href = touchenexInfo.exExtensionInfo.exOperaExtDownURL + "?" + dummyParam;
			} else {
				alert("현재 브라우저는 extension 설치를 지원하지 않습니다.");
			}
			return;
		}
		
		// EX
		if(type == "EX"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.isIE() && (TOUCHENEX_UTIL.getBrowserBit() == "64")){
					downURL = touchenexInfo.exProtocolInfo.exWin64ProtocolDownURL;
				} else {
					downURL = touchenexInfo.exProtocolInfo.exWinProtocolDownURL;
				}
			} else if(TOUCHENEX_UTIL.isMac()){
				downURL = touchenexInfo.exProtocolInfo.exMacProtocolDownURL;
			} else if(TOUCHENEX_UTIL.isLinux()){
				// TODO
			}
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + touchenexInfo.exProtocolInfo.exWinProtocolVer;
				location.href = downURL + "?" + dummyParam;
			} else {
				location.href = downURL;
			}
			return;
		}
		
		// Daemon
		if(type == "daemon"){
			var downURL = "";
			var bSupportBrowser = false;
					
			if (getTouchEnNXEType.MSIEBrowser || (TouchEn_BaseBRW.sf && !TouchEn_BaseBRW.cr))
			{				
				if(TOUCHENEX_UTIL.isIE() && TOUCHENEX_UTIL.getBrowserBit() == "64"){
					downURL = downloadInfo.exEdgeInfo.daemon64DownURL;
				} else {
					downURL = downloadInfo.exEdgeInfo.daemonDownURL;
				}
			}
			else {
				//if(typeof TOUCHENEX_UTIL.typeDaemonEX == "function" && TOUCHENEX_UTIL.typeDaemonEX(pluginInfo)){
				//if(TOUCHENEX_UTIL.isEdge() || TOUCHENEX_UTIL.isChrome() || TOUCHENEX_UTIL.isFirefox() || TOUCHENEX_UTIL.isOpera()) {
					var daemonInfo = downloadInfo.exEdgeInfo;
					var browserType = TOUCHENEX_UTIL.getBrowserInfo().browser;
					if(daemonInfo && daemonInfo.supportBrowser instanceof Array && daemonInfo.supportBrowser.length > 0)
					{
						for(var i = 0; i < daemonInfo.supportBrowser.length; i++)
						{
							var reqBrowser = daemonInfo.supportBrowser[i];
							if(browserType.toUpperCase() == reqBrowser.toUpperCase())
							{
								if(TOUCHEN_RUNTYPE == "mainextension" && TOUCHENEX_UTIL.isFirefox() && TOUCHENEX_UTIL.getBrowserBit() == "64" && typeof touchenex_nativecall != "undefined")
								{
									downURL = downloadInfo.exEdgeInfo.daemon64DownURL;
								}
								else
								{
									downURL = downloadInfo.exEdgeInfo.daemonDownURL;									
								}
								
								bSupportBrowser = true;
							}
						}
					}
				
				if(bSupportBrowser == false) 
				{
					alert("현재 브라우저는 daemon 설치를 지원하지 않습니다.");
					return;
				}
			}
				
			location.href = downURL;
				   
			return;
		}
		
		// Client
		if(type == "client"){
			var downURL = "";
			
			if(TOUCHENEX_UTIL.isWin()){
				if(TOUCHENEX_UTIL.isIE() && (TOUCHENEX_UTIL.getBrowserBit() == "64")){
					downURL = touchenexInfo.moduleInfo.exWin64Client;
				} else {
					downURL = touchenexInfo.moduleInfo.exWinClient;
				}
			} else if(TOUCHENEX_UTIL.isMac()){
				downURL = touchenexInfo.moduleInfo.exMacClient;
			} else if(TOUCHENEX_UTIL.isLinux()){
				// TODO
			}
			
			if(!TOUCHENEX_UTIL.isIE()){
				dummyParam = "ver=" + touchenexInfo.moduleInfo.exWinVer;
				location.href = downURL + "?" + dummyParam;
			} else {
				location.href = downURL;
			}
			return;
		}
	}
};

