/**
 ***************************************************************************
 * TouchEn Nx, 1.0.0
 *
 * For more information on this product, please see
 * http://www.raonsecure.com
 *
 * Copyright (c) Raonsecure Co.,Ltd  All Rights Reserved.
 *
 * 본 코드에 대한 모든 권한은 (주)라온시큐어 있으며 동의없이 사용/배포/가공할 수 없습니다.
 *
 ***************************************************************************
 */
 
 /**
****************************************************
TouchEnNx_daemon.js
****************************************************
| Version     작성자        수정일        변경사항 
 ---------  -------  -----------  ----------   
| v1.0.0.2    백서린    2017.01.20      
| v1.0.0.1    백서린    2017.01.20      최초

****************************************************
 Copyright ⒞ RaonSecure Co., Ltd. 
****************************************************
**/


var TOUCHENEX_usedaemon = false;
if(TOUCHENEX_UTIL.isEdge()){
	TOUCHENEX_usedaemon = true;
	//엣지 무조건 데몬
}else{
	//익스텐션 브라우저
	if(TOUCHENEX_UTIL.typeExtension() && !TOUCHENEX_UTIL.isMac()){
		if(daemon.SupportBrowser.length > 0){
			for(var i = 0; i < daemon.SupportBrowser.length; i++){
				var reqBrowser = daemon.SupportBrowser[i];
				if(TOUCHENEX_UTIL.getBrowserInfo().browser.toUpperCase() == reqBrowser.toUpperCase()){
					TOUCHENEX_usedaemon = true;
				}
			}
		}
		if(TOUCHEN_RUNTYPE=="onlydaemon"){
			TOUCHENEX_usedaemon = true;
			//지원브라우저에 대해 무조건 익스텐션 사용
		}else if(TOUCHEN_RUNTYPE == "mainextension"){
			if(typeof touchenex_nativecall == "function"){
				TOUCHENEX_usedaemon = false;
			}
		}else if(TOUCHEN_RUNTYPE == ""){
			TOUCHENEX_usedaemon = false;
		}
	}else{
		TOUCHENEX_usedaemon = false;
	}
}
if(TOUCHENEX_usedaemon){
	var TOUCHENEX_DAEMON = {
		thisObj : null,
		request : "",
		callback : "",
		moduleCheck : function( currPluginCnt ){
			exlog("_DAEMON.moduleCheck", currPluginCnt);
			
			// generate IE tab id
			if(!TOUCHENEX_CONST.extabid){
				TOUCHENEX_CONST.extabid = TOUCHENEX_UTIL.createId();
			}
			
			TOUCHENEX_CHECK.chkCurrPluginCnt = currPluginCnt;
			
			if(currPluginCnt >= TOUCHENEX_CONST.pluginCount){
				var chk = true;
				for(var i=0; i<TOUCHENEX_CONST.pluginCount; i++){
					var currInstalled = true;
					var currStatus = TOUCHENEX_CHECK.chkInfoStatus.info[i];
					if(!currStatus.daemon){
						chk = false;
						currInstalled = false;
					}
					if(!currStatus.EX){
						chk = false;
						currInstalled = false;
					}
					if(!currStatus.client){
						chk = false;
						currInstalled = false;
					}
					if(typeof currStatus.extension){
						delete currStatus.extension;
					}
					currStatus.isInstalled = currInstalled;
				}
				TOUCHENEX_CHECK.chkInfoStatus.status = chk;
				exlog("_DAEMON.moduleCheck.chkInfoStatus", TOUCHENEX_CHECK.chkInfoStatus);
				eval(TOUCHENEX_CHECK.chkCallback)(TOUCHENEX_CHECK.chkInfoStatus);
				return;
			}
			
			var pluginInfo = TOUCHENEX_CONST.pluginInfo[currPluginCnt];
			
			var checkCallback = "TOUCHENEX_CHECK.daemonVersionCheck";
			var request = {};
			request.tabid = TOUCHENEX_CONST.extabid;
			request.init = "get_versions";
			
			request.m = pluginInfo.exModuleName;
			request.origin = location.origin;
			request.lic = pluginInfo.lic;
			request.callback = "";
			
			try {
				if(sessionStorage.getItem("crossexws")){
					exlog("_DAEMON.moduleCheck.portCheck.getSession.crossexws", sessionStorage.getItem("crossexws"));
					TOUCHENEX_UTIL.sendWS(pluginInfo.exEdgeInfo.localhost, request, checkCallback);
				} else {
					if(typeof(Worker) !== "undefined") {
					var start_port = pluginInfo.exEdgeInfo.edgeStartPort;
					var local_host = pluginInfo.exEdgeInfo.localhost;
					var check_count = pluginInfo.exEdgeInfo.portChkCnt;
					var end_port = start_port + check_count;
					var current_port = start_port;
	
					function wsPortScanWorker() {
							   if (current_port >= end_port) {
										 exlog("_DAEMON.moduleCheck.portCheck", "crossexws daemon port not found");
										 TOUCHENEX_CHECK.setDaemonStatus("", false, true);
										 return;
							   }
							   try {
										 exlog("_DAEMON.moduleCheck.portCheck", "connect :: " + local_host + ":" + current_port + "/");
										 var ws = new WebSocket(local_host + ":" + current_port + "/");
										 ws.onopen = function() {
													exlog("_DAEMON.moduleCheck.portCheck","onopen");
													ws.send({});
										 };
										 ws.onmessage = function(event) {
													exlog("_DAEMON.moduleCheck.portCheck","response :: " + event.data);
													ws.close();
													
													sessionStorage.setItem("crossexws", current_port);
													exlog("_DAEMON.moduleCheck.setSession.crossexws", sessionStorage.getItem("crossexws"));
													TOUCHENEX_UTIL.sendWS(pluginInfo.exEdgeInfo.localhost, request, checkCallback);
										 };
										 ws.onerror = function(e) {
													//exlog("_DAEMON.moduleCheck.portCheck.error", e);
													current_port++;
													wsPortScanWorker();
										 };
										 ws.onclose = function() {
													exlog("_DAEMON.moduleCheck.portCheck","onclose");
										 };
							   } catch (e) {
										 exlog("_DAEMON.moduleCheck.portCheck","exception :: " + e);
										 exlog("_DAEMON.moduleCheck.portCheck", "crossexws daemon port not found");
										 TOUCHENEX_CHECK.setDaemonStatus("", false, true);
										 return;
							   }
					}
					wsPortScanWorker();
	
	
					} else {
						alert("worker not support");
						TOUCHENEX_CHECK.setDaemonStatus("", false, true);
						return;
					}
				}
			} catch(e){
				exalert("_DAEMON.moduleCheck.portCheck", e);
				TOUCHENEX_CHECK.setDaemonStatus("", false, true);
				return;
			}
		},
		
		daemonVersionCheck : function(updateInfo) {
			
			var pluginInfo = TOUCHENEX_CONST.pluginInfo[TOUCHENEX_CHECK.chkCurrPluginCnt];
			
			if(updateInfo){
				exlog("_DAEMON.daemonVersionCheck.updateInfo", updateInfo);
				if(updateInfo == "-1"){
					TOUCHENEX_CHECK.setDaemonStatus("", false, true);
					return;
				}
				
				// license check
				if(typeof updateInfo.status !== "undefined" && updateInfo.status == false){
					exlog("_CHECK.extensionNativeVersionCheck [license check]", pluginInfo.exPluginName + " license check FAIL");
					TOUCHENEX_CHECK.setStatus("license", "", false, false, updateInfo.expire);
				} else {
					exlog("_CHECK.extensionNativeVersionCheck [license check]", pluginInfo.exPluginName + " license check SUCCESS");
					TOUCHENEX_CHECK.setStatus("license", "", true, false, updateInfo.expire);
				}
				
				exlog("_DAEMON.daemonVersionCheck", "daemon version check");
				var exDaemonSvrVer = pluginInfo.exEdgeInfo.daemonVer;
				if(TOUCHENEX_UTIL.diffVersion(updateInfo.daemon, exDaemonSvrVer)) {
					TOUCHENEX_CHECK.setDaemonStatus(updateInfo.daemon, true, false);
					exlog("_DAEMON.daemonVersionCheck", "EX version check");
					var exEXSvrVer = pluginInfo.exProtocolInfo.exWinProtocolVer;
					if(TOUCHENEX_UTIL.diffVersion(updateInfo.ex, exEXSvrVer)) {
						TOUCHENEX_CHECK.setStatus("EX", updateInfo.ex, true, false);
						// Client Version Diff
						var currModuleInfoArr = updateInfo.m;
						var currModuleVer;
						for(var i = 0; i < currModuleInfoArr.length; i++){
							var cm = currModuleInfoArr[i];
							if(cm.name == pluginInfo.exModuleName){
								currModuleVer = cm.version;
								break;
							}
						}
						exlog("_DAEMON.EXVersionCheck", "Client version check");
						var exModuleSvrVer = pluginInfo.moduleInfo.exWinVer;
						if(TOUCHENEX_UTIL.diffVersion(currModuleVer, exModuleSvrVer)) {
							// set installed
							TOUCHENEX_CHECK.setStatus("client", currModuleVer, true, true);
						} else {
							TOUCHENEX_CHECK.setStatus("client", currModuleVer, false, true);
						}
					} else {
						TOUCHENEX_CHECK.setStatus("EX", updateInfo.ex, false, true);
					}
				} else {
					TOUCHENEX_CHECK.setDaemonStatus(updateInfo.daemon, false, true);
				}
			} else {
				exlog("_DAEMON.daemonVersionCheck", pluginInfo.exPluginName + " updateInfo Error");
				TOUCHENEX_CHECK.setDaemonStatus("", false, true);
			}
		},
		// for TOUCHENEX_UTIL.sendWS..
		sendWS : function(host, request, callback) {
			try {
				TOUCHENEX_DAEMON.callback = callback;
				if ("WebSocket" in window){
					if(typeof touchenexWS == "undefined"){
						exlog("_DAEMON.sendWS","create object touchenexWS");
						window["touchenexWS"] = new Object();
					}
					
					if(touchenexWS.readyState == 1){
						exlog("### _DAEMON.sendWS.send", request);
						touchenexWS.send(JSON.stringify(request));
					} else {
						exlog("### _DAEMON.sendWS.new WebSocket", "create WebSocket!!");
						//2016-07-05
						var url = "";
						if(request.m =="nxkey"){
							url = host + ":" + sessionStorage.getItem("crossexws") + "/" + touchenexInfo.exSiteName + "/" + touchenexInfo.exProtocolName + "/Call";
						}else if(request.m =="nxwirelesscert"){
							url = host + ":" + sessionStorage.getItem("crossexws") + "/" + keysharpnxInfo.exSiteName + "/" + keysharpnxInfo.exProtocolName + "/Call";
						}else if(request.m	=="nxweb"){
				    		url = host + ":" + sessionStorage.getItem("crossexws") + "/" + touchennxwebInfo.exSiteName + "/" + touchennxwebInfo.exProtocolName + "/Call";
						}else if(request.m	=="nxfirewall"){
							url = host + ":" + sessionStorage.getItem("crossexws") + "/" + touchennxfwInfo.exSiteName + "/" + touchennxfwInfo.exProtocolName + "/Call";
						}
	
						touchenexWS = new WebSocket(url);
						touchenexWS.onopen = function(){
							exlog("_DAEMON.sendWS.send2", request);
							touchenexWS.send(JSON.stringify(request));
						};
						touchenexWS.onmessage = function(event){
							var response =  event.data;
							try {
								response = JSON.parse(response);
							} catch(e){
								response = response;
							}
							exlog("_DAEMON.sendWS.callback", TOUCHENEX_DAEMON.callback);
							exlog("_DAEMON.sendWS.response", response);
							
							if(typeof response.response != "undefined" &&
								response.response.id == "setcallback"){
								// setcallback function evaluation..
								eval(response.response.callback)(response.response.reply);
							} else {
								if(TOUCHENEX_DAEMON.callback){
									var sendWSCallbackFn = TOUCHENEX_DAEMON.executeFunctionByName(TOUCHENEX_DAEMON.callback);
									sendWSCallbackFn.apply(TOUCHENEX_DAEMON.thisObj, [response]);
								}
							}
						};
						touchenexWS.onerror = function(error){
							exlog("_DAEMON.sendWS.onerror TOUCHENEX_DAEMON.callback", TOUCHENEX_DAEMON.callback);
							if(TOUCHENEX_DAEMON.callback == "TOUCHENEX_CHECK.daemonVersionCheck"){
								exlog("_DAEMON.sendWS.error", "TOUCHENEX_CHECK.daemonVersionCheck!!!!!!!!!!!!!!!!!!");
								window["TOUCHENEX_CHECK"]["daemonVersionCheck"]("-1");
							} else {
								exlog("_DAEMON.sendWS.error", error);
								eval(TOUCHENEX.exDefaultCallbackName)({"NAME":"TOUCHENEX", "ERR":"BLOCK:INTERNAL"});
							}
						};
						touchenexWS.onclose = function(){
							exlog("_DAEMON.sendWS.onclose", "onclose");
						};
					}
				} else {
					exlog("_DAEMON.sendWS", "WebSocket not supported");
					exalert("_DAEMON.sendWS", "WebSocket not supported");
					return;
				}
			} catch(e){
				exlog("_DAEMON.sendWS", "sendWS Daemon not load");
				exalert("_DAEMON.sendWS sendWS Daemon not load", e);
				return;
			}
		},
		setDaemonStatus : function(localVer, status, isNext){
			try{
				if (TOUCHENEX_CHECK.chkInfoStatus.info[TOUCHENEX_CHECK.chkCurrPluginCnt] != undefined) {
					TOUCHENEX_CHECK.chkInfoStatus.info[TOUCHENEX_CHECK.chkCurrPluginCnt].daemonVer = localVer;
					TOUCHENEX_CHECK.chkInfoStatus.info[TOUCHENEX_CHECK.chkCurrPluginCnt].daemon = status;
				}
			}catch(e){}
			
			if(isNext){
				TOUCHENEX_CHECK.moduleCheck(TOUCHENEX_CHECK.chkCurrPluginCnt + 1);
			}
		},
		executeFunctionByName : function( functionName ) {
			var args = Array.prototype.slice.call(arguments, 2);
			var namespaces = functionName.split(".");
			var func = namespaces.pop();
			var funcArr;
			for (var i = 0; i < namespaces.length; i++) {
				if(i==0){
					funcArr = window[namespaces[i]];
					this.thisObj = funcArr;
				} else {
					funcArr = funcArr[namespaces[i]];
				}
			}
			return funcArr[func];
		}
	};
	
	
	/* 
	 * CrossEX Construct
	 * TOUCHENEX_EX
	 */
	var TOUCHENEX_EX = function( property ) {
		
		this.isInstalled	= property.isInstalled;
		this.exPluginName	= property.exPluginName;
		this.exModuleName	= property.exModuleName ? property.exModuleName : property.exProtocolName;
		this.exProtocolName	= property.exProtocolName;
		this.exExtHeader	= property.exExtHeader;
		this.exNPPluginId	= property.exNPPluginId;
		this.exErrFunc		= property.exErrFunc;
		this.lic			= property.lic;
		this.host			= property.exEdgeInfo.localhost;
		this.exDefaultCallbackName = property.exPluginName + ".exDefaultDaemonCallback";
		
		dummyDomain	= property.dummyDomain?property.dummyDomain:location.host;
		hostid		= property.hostid?property.hostid:location.host;
		
		this.initEXInfoArr	= [];
		this.exInterfaceArr	= [];
		this.exEcho			= false;
		this.setEcho = function( status ){
			this.exEcho =status;
		};
		this.alertInfo		= {"BLOCK":false, "EX":false, "CLIENT":false, "INTERNAL":false};
		
		// default callback
		this.exDefaultDaemonCallback = function( response ){
			exlog("exDefaultCallback", response);
			if(response){
				var resPluginObj;
				if(response.NAME){
					resPluginObj = eval(response.NAME);
				}
				
				if(response.ERR == "BLOCK"){
					if(!resPluginObj.alertInfo.BLOCK){
						resPluginObj.alertInfo.BLOCK = true;
						if(bInit==0) {
							alert(response.NAME + " 라이센스를 확인하세요.");
						} else {
							alert(response.NAME + " 프로그램에 오류가 발생하였습니다.(daemon)\n페이지를 새로고침 하세요."); 
						}					
						try{
							if(resPluginObj.exErrFunc){
								eval(resPluginObj.exErrFunc)(response);
							}
						} catch (e){}
					}
				} else if(response.ERR == "BLOCK:EX"){
					if(!resPluginObj.alertInfo.EX){
						resPluginObj.alertInfo.EX = true;
						alert(response.NAME + " 프로그램이 변조되었습니다.(EX)\n재설치가 필요합니다.");
						try{
							if(resPluginObj.exErrFunc){
								eval(resPluginObj.exErrFunc)(response);
							}
						} catch (e){}
					}
				} else if(response.ERR == "BLOCK:CLIENT"){
					if(!resPluginObj.alertInfo.CLIENT){
						resPluginObj.alertInfo.CLIENT = true;
						alert(response.NAME + " 프로그램이 변조되었습니다.(client)\n재설치가 필요합니다.");
						try{
							if(resPluginObj.exErrFunc){
								eval(resPluginObj.exErrFunc)(response);
							}
						} catch (e){}
					}
				} else if(response.ERR == "BLOCK:INTERNAL"){
					if(!resPluginObj.alertInfo.INTERNAL){
						resPluginObj.alertInfo.INTERNAL = true;
						alert(response.NAME + " 프로그램에 오류가 발생하였습니다.(daemon)\n페이지를 새로고침 하세요.");
						try{
							if(resPluginObj.exErrFunc){
								eval(resPluginObj.exErrFunc)(response);
							}
						} catch (e){}
					}
				} else {
					exalert("실행중 오류가 발생하였습니다.(EX)", response);
				}
			} else {
				exalert("실행중 오류가 발생하였습니다.(EX)", "InvokeCallback not response");
			}
		};
		
		/*
		 * Invoke
		 */
		this.Invoke = function( fname, args, exCallback, pageCallback ){
			
			var id = TOUCHENEX_UTIL.createId();
			var obj = {};
			obj.id = id;
			obj.EXCallback = exCallback ? exCallback:null;
			obj.pageCallback = pageCallback ? pageCallback : null;
			obj.pluginName = this.exPluginName;
			this.exInterfaceArr.push(obj);
			exlog(this.exPluginName + ".Invoke.exInterfaceArr.id", id);
			//exlog(this.exPluginName + ".Invoke.exInterfaceArr.push", obj);
			//exlog(this.exPluginName + ".Invoke.exInterfaceArr.length", this.exInterfaceArr.length);
			
			var cmd = "native";
			// insert Q
			if(typeof touchenexInvokeQ == 'undefined'){
				window['touchenexInvokeQ'] = new Array();
			}
			touchenexInvokeQ.push([id, cmd, fname, args, exCallback]);
			if(touchenexInvokeQ.length == 1)
				this.InvokeDaemon.apply(this, touchenexInvokeQ[0]);
		};
		
		/*
		 * SetPushCallback
		 */
		this.SetPushCallback = function( fname, args ) {
			
			var id = TOUCHENEX_UTIL.createId();
			var obj = {};
			obj.id = id;
			this.exInterfaceArr.push(obj);
			exlog(this.exPluginName + ".SetPushCallback.info", obj);
			
			var cmd = "setcallback";
			// insert Q
			if(typeof touchenexInvokeQ == 'undefined'){
				window['touchenexInvokeQ'] = new Array();
			}
			touchenexInvokeQ.push([id, cmd, fname, args]);
			if(touchenexInvokeQ.length == 1)
				this.InvokeDaemon.apply(this, touchenexInvokeQ[0]);
		};
		
		this.InvokeDaemon = function( id, cmd, fname, args, callback ) {
			
			var request = {};
			request.id = id;
			request.tabid = TOUCHENEX_CONST.extabid;
			request.module = this.exModuleName;
			request.cmd = cmd;
			request.origin = location.origin != undefined ? location.origin : location.host;
			request.exfunc = {};
			request.exfunc.fname = fname;
			request.exfunc.args = args;
			request.callback = callback;
			if(this.exEcho) request.echo = true;
			
			try {
				exlog(this.exPluginName + ".InvokeDaemon.request", request);
				TOUCHENEX_UTIL.sendWS(this.host, request, this.exPluginName + ".InvokeCallback");
			} catch (e){
				alert("파라미터 생성중 오류가 발생하였습니다.");
				alert(e);
			}
		};
		
		this.InvokeCallback = function( response ){
			if(response){
				try{
					exlog(this.exPluginName + ".InvokeCallback.response", response);
					if(typeof response == "object"){
						var strSerial = JSON.stringify(response);
					} else if(typeof response == "string"){
						response = JSON.parse(response);
					}
					response = response.response;
					
					var status = response.status;
									
				// remove invokeQ
				if(touchenexInvokeQ.length > 0){
					if(status == "TRUE"){
						touchenexInvokeQ.splice(0, 1);
						exlog(this.exPluginName + ".InvokeCallback.remain Q size :: ", touchenexInvokeQ.length);
						
						this.InvokeDaemon.apply(this, touchenexInvokeQ[0]);
					} else {
						touchenexInvokeQ.splice(0, touchenexInvokeQ.length);
						exlog(this.exPluginName + ".InvokeCallback.remain Q remove");
					}
				} else {
					exlog(this.exPluginName + ".InvokeCallback.remain Q size :: ", 0);
				}
				
					if(status == "TRUE") {	// success
						var id = response.id;
						var funcInfo = {};
						for(var i=0; i < this.exInterfaceArr.length; i++){
							if(this.exInterfaceArr[i]){
								var arrObj = this.exInterfaceArr[i];
								if(arrObj.id == id){
									//exlog(this.exPluginName + ".InvokeCallback remove exInterfaceArr info", arrObj);
									funcInfo = arrObj;
									this.exInterfaceArr.splice(i,1);
									break;
								}
							}
						}
						var callback = funcInfo.EXCallback;
						var reply = response.reply.reply;
						
						// run callback
						if(callback){
							if(reply instanceof Array) {
								var strReply = {};
								strReply.callback = funcInfo.pageCallback;
								var replyArr;
								replyArr = "[";
								for(var i in reply) {
									var str = reply[i];
									str = str.replace("\\r", "\r");
									str = str.replace("\\n", "\n");
									replyArr += "'" + str + "',";
								}
								replyArr += "]";
								strReply.reply = replyArr;
								callback = callback + "(" + JSON.stringify(strReply) + ");";
							} else if(typeof reply == 'string') {
								var strReply = {};
								strReply.callback = funcInfo.pageCallback;
								strReply.reply = reply.replace("\\r", "\r").replace("\\n", "\n");
								callback = callback + "(" + JSON.stringify(strReply) + ");";
							} else if(typeof reply == 'object') {
								//reply.id = id;
								reply.callback = funcInfo.pageCallback;
								if(reply.status == "_TOUCHENEX_BLOCK_"){
									var err = reply.err;
									eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":err});
								} else {
									callback = callback + "(" + JSON.stringify(reply) + ");";
								}
							} else {
								callback = callback + "()";
							}
							//exlog(this.exPluginName + ".InvokeCallback run EXCallback", callback);
							eval(callback);
						}
					} else if(status == "BLOCK") {
						exlog(this.exPluginName + ".InvokeCallback.response", response);
						// checkInfo값에 license 유무에 따라서 BLOCK와 INTERNAL로 구분한다. only edge
						var chkInfo = TOUCHENEX_CHECK.chkInfoStatus.info;
						var chkBlock = true;
						for(var i=0; i<chkInfo.length; i++){
							var tmpInfo = chkInfo[i];
							if(this.exPluginName == tmpInfo.name && tmpInfo.license){
								exlog(this.exPluginName + ".InvokeCallback", "CrossEXClient fail(daemon)");
								chkBlock = false;
								eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":"BLOCK:INTERNAL"});
								break;
							}
						}
						if(chkBlock){
							exlog(this.exPluginName + ".InvokeCallback", "license not valid");
							eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":"BLOCK"});
						}
					} else if(status == "BLOCK:EX") {
						exlog(this.exPluginName + ".InvokeCallback.response", response);
						exlog(this.exPluginName + ".InvokeCallback", "CrossEX sig check fail");
						eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":"BLOCK:EX"});
					} else if(status == "BLOCK:CLIENT") {
						exlog(this.exPluginName + ".InvokeCallback.response", response);
						exlog(this.exPluginName + ".InvokeCallback", "Client sig check fail");
						eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":"BLOCK:CLIENT"});
					} else if(status == "BLOCK:INTERNAL") {
						exlog(this.exPluginName + ".InvokeCallback.response", response);
						exlog(this.exPluginName + ".InvokeCallback", "CrossEXClient fail");
						eval(this.exDefaultCallbackName)({"NAME":this.exPluginName, "ERR":"BLOCK:INTERNAL"});
					} else {
						exlog(this.exPluginName + ".InvokeCallback.response", response);
						exlog(this.exPluginName + ".InvokeCallback", "native response status not TRUE");
						eval(this.exDefaultCallbackName)(response);
					}
				} catch (e) {
					exlog(this.exPluginName + ".InvokeCallback [exception]", e);
					exlog(this.exPluginName + ".InvokeCallback [exception]", "native response process exception");
					eval(this.exDefaultCallbackName)(response);
				}
			} else {
				exlog(this.exPluginName + ".InvokeCallback", "native call not response");
				eval(this.exDefaultCallbackName)();
			}
		};
	};

// Static variable function set..

	TOUCHENEX_CHECK.moduleCheck = TOUCHENEX_DAEMON.moduleCheck;
	TOUCHENEX_CHECK.daemonVersionCheck = TOUCHENEX_DAEMON.daemonVersionCheck;
	TOUCHENEX_CHECK.setDaemonStatus = TOUCHENEX_DAEMON.setDaemonStatus;
	TOUCHENEX_UTIL.sendWS = TOUCHENEX_DAEMON.sendWS;
	TOUCHENEX_UTIL.executeFunctionByName = TOUCHENEX_DAEMON.executeFunctionByName;
}
