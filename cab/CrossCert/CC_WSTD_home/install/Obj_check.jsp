<%@page import="nicelib.util.Base64Coder"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%
String callback = request.getParameter("callback")==null?"":request.getParameter("callback");
if(callback.equals("")||callback.startsWith("http")){
	/* out.println("<script>");
	out.println("alert('정상적인 경로로 접근하세요.');");
	out.println("self.close();");
	out.println("</script>");
	return; */
}
callback = new String(Base64Coder.decode(callback),"UTF-8");
%>
<!-- 
	설치 후 이동할 페이지 경로 설정 : mainPageUrl
-->
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8" />
	<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
	<title>한국전자인증 인증서 관리프로그램 설치 </title>
	<link rel="stylesheet" href="style.css" /> 
	<script type="text/javascript" src="../unisignweb/framework/json2.js"></script>
</head>
	<style type="text/css">
		body,div,ul,ol,li,nav,section,footer{margin: 0px auto; padding: 0px; font-family :NanumGothic, dotum, Georgia, serif,san-serif; font-size : 14px;color: #333;}
		h1,h2,h3,h4,h5{ margin: 0px; padding: 0px; font-weight: normal;}
		ul,li{ list-style: none; }
		a{text-decoration:none;border-radius:3px;}
		
		#setup{ width: 95%; height: 100%; margin: auto;}
		#next{ padding: 10px}
		#faq{ float: right; margin-bottom: 10px }
		#list{ list-style: none; line-height: 150%;margin-top: 10px}
		#bottom{ width: 100%; background: #f7f8f9;padding:15px 10px; position: fixed; bottom:100px;}
		#floating{ position: fixed; bottom:7px; right:10px; z-index:1;}
		
		/* button */
		#btn{ text-align: center; margin-top:15px}
		#btn li{ display: inline; }
		.bl_s a{height: 32px; line-height: 32px; border: 1px solid #244997; background: #2e58a6;color: #fff; padding: 7px 20px; margin:5px;font-size : 12px;}
		.bl_s a:hover{color: #2e58a6; background: #fff}
		.wh a{height: 32px; line-height: 32px;  background: #fff;color: #2e58a6;border: 1px solid #244997; padding: 10px 10px;font-size : 18px;}
		.wh a:hover{ background: #2e58a6;color: #fff;}
		.wh_s a{line-height: 32px;  background: #fff;color: #2e58a6;border: 1px solid #244997;  padding: 6px 18px; font-size : 12px;}
		.wh_s a:hover{ background: #2e58a6;color: #fff;}
		.rd_s a:hover{  background: #fff;color: #e55c5c;border: 1px solid #e55c5c; }
		.rd_s a{ background: #e55c5c;color: #fff; line-height: 32px; padding: 7px 20px; font-size : 12px;}
		.setting{ color: red;}
		.flor{ float: right;  }
		#setup{ max-width: 720px; padding-top: 15px }
	
		/* table */
		table {border-collapse: collapse; width:100%; border-top: 2px solid #5e6062; border-left: 2px solid #fff; border-right: 2px solid #fff;margin-top:10px;text-align:center}
		td{ background: #f7f8f9; font-size: 12px;}
		td a{ color: #333; }
		td a:hover{ color: #28459d}
		th, td {padding:8px; border: 1px solid #dee0e2; line-height: 140%; }
		td li{ text-align: left;line-height: 180%; background: url('../images/icon_dot.gif') no-repeat 0 8px; padding-left: 8px;margin-left: 5px}
	</style>


<body>
	<div id="setup">
		<a href="https://open.crosscert.com/index.jsp" class="logo_footer" alt="한국전자인증 로고"><span class="blind">한국전자인증 로고</span></a>
		<img src="https://open.crosscert.com/images/setup_img.jpg" alt="" />
		<ul id="list_bl">
			<li>· 고객님의 안전한 공인인증서비스 이용을 위하여 인증프로그램을 설치합니다.</li>
			<li>· 설치가 완료되면 [F5]키를 눌러 새로고침을 하시거나, 브라우저를 닫은 후 다시 접속하여 주시기 바랍니다.</li>
			<li>· 오류 메시지가 발생할 경우 다운로드 안내창에서 ‘저장’을 눌러 PC에 다운로드 후 실행하세요.</li>
			<li>· 설치화면이 반복적으로 나올 경우 웹브라우저를 종료하고 다시 접속하세요.</li>
			
			</br>
			<div id="faq">
				<span style="margin-right: 15px;">프로그램 설치 중 오류 문의 |<a href="mailto:;sos@crosscert.com" > sos@crosscert.com</a></span>&nbsp;&nbsp;
				<span id="btn" class="wh_s"><a href="https://www.crosscert.com/support" target="_blank">원격지원서비스</a></span>&nbsp;&nbsp;
				<span id="btn" class="rd_s"><a href="http://blog.daum.net/crosscert/199" target="_blank">프로그램 설치 오류 해결하기</a></span>
			</div>

		</ul>
		<table>
			<tr>
				<th width="20%">프로그램명</th>
				<th width="20%">기능</th>
				<th width="20%">설치상태</th>
				<th width="20%">운영체제(OS)</th>
				<th>웹브라우저</th>
			</tr>
			<tr>
				<td>인증프로그램</td>
				<td>공인인증서 발급 및 전자서명을 위한 프로그램</td>
				<td>
					<div id="status_text"></div>
				</td>
				<td>
					<script type="text/javascript">
					/* 사용자 OS */
			    	var userOs = "";
			        var ua = navigator.userAgent;

			        if( ua.indexOf("NT 5.0") != -1 ) {
			        	userOs = "Windows 2000";
			        }

			        else if( ua.indexOf("NT 5.1") != -1 ) {
			        	userOs = "Windows XP";
			        }

			        else if( ua.indexOf("NT 5.2") != -1 ) {
			        	userOs = "Windows Server 2003";
			        }

			        else if( ua.indexOf("NT 6.0") != -1 ) {
			        	userOs = "Windows Vista";
			        }

			        else if( ua.indexOf("NT 6.1") != -1 ) {
			        	userOs = "Windows 7";
			        }

			        else if( ua.indexOf("NT 6.2") != -1 ) {
			        	userOs = "Windows 8";
			        }
			        
			        else if( ua.indexOf("NT 6.3") != -1 ) {
			        	userOs = "Windows 8.1";
			        }
			        
			        else if( ua.indexOf("NT 6.4") != -1 ) {
			        	userOs = "Windows 10";
			        }
			        
			        else if( ua.indexOf("NT 10.0") != -1 ) {
			        	userOs = "Windows 10";
			        }

			        else if( ua.indexOf("98") != -1 ) {
			        	userOs = "Windows 98";
			        }

			        else if( ua.indexOf("95") != -1 ) {
			        	userOs = "Windows 95";
			        }

			        else if( ua.indexOf("Linux") != -1 ) {
			        	userOs = "Linux";
			        }

			        else if( ua.indexOf("Mac") != -1 ) {
			        	userOs = "mac";
			        }

			        else{
			        	userOs = "미확인";
			        }
					document.write(userOs);
					</script>
				</td>
				<td>
					<script type="text/javascript">
					/* 브라우저 확인 */
			        var Browser = { a : navigator.userAgent.toLowerCase() }
			        var browserNm = "";
			        var browserVr = "";
			        
			        if( Browser.a.indexOf('msie 5') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.5";
			        }

			        if( Browser.a.indexOf('msie 6') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.6";
			        }

			        if( Browser.a.indexOf('msie 7') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.7";
			        }

			        /* IE8 부터는 msie 값으로 브라우저 버전을 분별할수 없음 trident 값으로 해야한다. */
			        if( Browser.a.indexOf('trident/4.0') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.8";
			        }

			        if( Browser.a.indexOf('trident/5.0') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.9";
			        }

			        if( Browser.a.indexOf('trident/6.0') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.10";
			        }
			        
			        if( Browser.a.indexOf('trident/7.0') != -1 ) {
			            browserNm = "Internet Explorer";
			            browserVr = "v.11";
			        }
			        
			        if( Browser.a.indexOf('edge') != -1 ) {
			            browserNm = "Edge Browser";
			            browserVr = "";
			        }

			        if( !!window.opera ) {
			            browserNm = "opera";
			            browserVr = "";
			        }

			        if( Browser.a.indexOf('safari') != -1 ) {
			            browserNm = "safari";
			            browserVr = "";
			        }

			        if( Browser.a.indexOf('applewebkit/5') != -1 ) {
			            browserNm = "safari3";
			            browserVr = "";
			        }

			        if( Browser.a.indexOf('mac') != -1 ) {
			            browserNm = "mac";
			            browserVr = "";
			        }

			        if( Browser.a.indexOf('chrome') != -1 ) {
			            browserNm = "chrome";
			            browserVr = "";
			        }

					if( Browser.a.indexOf('whale') != -1 ) {
			            browserNm = "Whale";
			            browserVr = "";
			        }

			        if( Browser.a.indexOf('firefox') != -1 ) {
			            browserNm = "firefox";
			            browserVr = "";
			        }
			        
			        if(browserVr == "v.5" || browserVr == "v.6" || browserVr == "v.7" ){
			           alert("[알림]IE7 이하 브라우저는 국제표준규격인 HTML5 지원이 안되는 브라우져입니다.\n안정적인 서비스를 위해 상위 브라우저(IE8이상)로 접속하여 주십시오");
		               document.location.href = "/glca_AX/01_00_AX.jsp";
			        }
			        document.write(browserNm + "<br/>" + browserVr);
					</script>
				</td>
			</tr>
		</table>
		</br>		
		<iframe id="us-downloadURL" name="us-downloadURL" width="0" height="0" style="display: none;"></iframe>
		</br>
		<div id="next" style="text-align: center">
			인증서 관리 프로그램이 설치되어있지 않거나 실행중이 아닙니다<br><br> 프로그램이 자동으로 설치되지 않으므로 <b>설치하기</b>를 클릭해 주십시오.<br>
		</div>
		<div id="next2" style="text-align: center">
			설치완료 후 자동으로 다음페이지로 이동합니다. 설치후에도 1분이상 변화가 없을 경우 <span id="btnreload" class="bl_s"><a href="javascript:;" onclick="location.reload();"><b>새로고침</a></b></span>을 눌러주세요
		</div>


	</div>

<script type="text/javascript">
		// OS
		var OSTYPE_WIN32					= "Win32";
		var OSTYPE_WIN64					= "Win64";
		var OSTYPE_MAC						= "MAC";
		var OSTYPE_UNKNOWN                  = "Unknown";
		var Client_OS						= "Win32";
		
		// OS version
		var VestCert_MAC_Version 			= "2.5.10.0";
		var VestCert_WIN_Version 			= "2.5.10.0";

		// OS package
		var VestCert_MAC_PKG 				= 'VestCertSetup.dmg';
		var VestCert_WIN_PKG 				= 'VestCertSetup.exe';			

		
		// OS package  - Real 반영전에 센터에 확인할 것.
		//var VestCert_MAC_PKG 				= 'https://www.crosscert.com/Download/2.4.8/VestCertSetup.exe';
		//var VestCert_WIN_PKG 				= 'https://www.crosscert.com/Download/2.4.8/VestCertSetup.exe';			
		
		// default는 windows. GetClientOS 이후 OS에 맞는 버전과 package명 설정
		var VestCert_PKG = VestCert_WIN_PKG;
		var lastestVersion = VestCert_WIN_Version;
		
		var mainPageUrl = "";
		//var mainPageUrl = "../unisignweb_sample/TestMain.html";
		var chkCount = 0;
		var versionCheck = false;
		var iframesrc = "https://127.0.0.1:14461";
		var cntAdd = 0;
		var sessionID = Math.random();
		
		function parseInt(s){
			var ver = s.replace(/\./g, "");
			return ver * 1;
		}
		
		var text = {
			"messageNumber": 0,
			"sessionID": "" + sessionID,
			"operation":"GetVersion"
		};
		
		function send () {
			var request = document.getElementById("hsmiframe").contentWindow;
			request.postMessage(JSON.stringify(text), iframesrc);
		};
		
		function statusMsg(txt, cnt){
			if(cnt) for(var i=0; i<cnt; i++) txt += ".";
			document.getElementById("status_text").innerHTML = txt;
		}
		
		function isUpdate(ver){
			var l = lastestVersion.split('.'), 
			c = ver.split('.'), len = Math.max(l.length, c.length);
			
			for(var i=0; i<len; i++){
				//window.console.log(l[i] + '>' + c[i] + ' = ' + (parseInt(l[i]) > parseInt(c[i])));
				if ((l[i] && !c[i] && parseInt(l[i]) > 0) || (parseInt(l[i]) > parseInt(c[i]))) {
                    return true;
                } else if ((c[i] && !l[i] && parseInt(c[i]) > 0) || (parseInt(l[i]) < parseInt(c[i]))) {
                	return false;
                }
			}
			return false;
		}
		
		var receivedData = function (event){
			if(event.origin == iframesrc){
				var obj = JSON.parse(event.data);
				if( !obj || !obj.list || !obj.list[0]){
					setTimeout(send, 2000);
					return;
				} 
				

				var currentVersion = obj.list[0].version;
				var cv = currentVersion.split('.');
				currentVersion = cv[0] + '.' + cv[1] + '.' + cv[2] + '.0';
						
				//currentVersion = cv[0] + cv[1] + cv[2] + '.0';
				//currentVersion = parseInt(currentVersion);
				
				//if(obj.list == null || currentVersion < parseInt(lastestVersion)){
				if( isUpdate(currentVersion) ){
					statusMsg("인증서 관리 프로그램이 최신버전이 아닙니다.<br>최신버전으로 설치해주시기바랍니다.<br><br>최신버전 : " + lastestVersion + "<br>설치된 버전 : " + currentVersion + '<div id="btn" class="wh_s"><a href="'+VestCert_PKG+'">설치하기</a></div>');
					if(versionCheck == false) document.getElementById("hsmiframe").src = VestCert_PKG;
					versionCheck = true;
					setTimeout(send, 2000);
			}else{
					statusMsg("인증서 관리 프로그램이 설치되었습니다");
					setTimeout(function(){/*document.location.href = mainPageUrl;*/if(opener){opener.location.reload();}self.close();}, 500);
			}
			}else return;
		}
		
		function removeEvent(){
			cntAdd--;
			if (typeof window.addEventListener === 'function') {
			    window.removeEventListener('message', receivedData, false);
			} else if (typeof window.attachEvent === 'function') {
			    window.detachEvent('onmessage', receivedData);
			} else {
				window.detachEvent('onmessage', receivedData);
			}
		}
		
		function addEvent(){
			if(cntAdd > 0) removeEvent();
			if (typeof window.addEventListener === 'function') {
			    window.addEventListener('message', receivedData, false);
			} else if (typeof window.attachEvent === 'function') {
			    window.attachEvent('onmessage', receivedData);
			} else {
				window.attachEvent('onmessage', receivedData);
			}
			cntAdd++;
		}
	
		function UniSignWeb_LoadObject(){
			document.writeln("<iframe src='"+iframesrc+"' name='hsmiframe' id='hsmiframe' style='visibility:hidden;position:absolute' onload='send();'></iframe>");
		}
		
		var iframeLoaded = false;
		var fnInstallCheck = function(rv){
			iframeLoaded = false;
			var isFirst = true;
			var fnResult = function(obj, r){
				iframeLoaded = r;
				if(isFirst){
					isFirst = false;
					if(obj && obj.parentNode) obj.parentNode.removeChild(obj);
					rv(r);
				}
			}
			
			var chkImg;
			if (navigator.userAgent.indexOf("MSIE 7.0") != -1) {
				chkImg = document.createElement("<img id='hsmImg' src='"+iframesrc + '/TIC?cd=' + Math.random() + "' onload='' onerror='' />");
				chkImg.onerror = function() {fnResult(chkImg, false);};
				chkImg.onload = function() {fnResult(chkImg, true);};
				chkImg.style.display = "none";
			} else {
				chkImg = document.createElement('img');
				chkImg.setAttribute('id', "hsmImg");
				chkImg.setAttribute('src', iframesrc + '/TIC?cd=' + Math.random());
				chkImg.onerror = function() {fnResult(chkImg, false);};
				chkImg.onload = function() {fnResult(chkImg, true);};
				chkImg.style.display = "none";
			}
			document.body.appendChild(chkImg);
			
			if (navigator.userAgent.indexOf("MSIE 8") != -1) {
				var ie8 = function(){
					if(iframeLoaded == false) setTimeout(ie8, 100);
					else fnResult(null, true);
				}
				setTimeout(ie8, 100);
			}
		};
		
		function fnVestCertCall(){
			document.getElementById("hsmiframe").src = "mangowire:///";
			setTimeout(function(){document.location.reload();}, 5000);
		}
		
		var fnChecker = function(r){
			if(r){
				chkCount = 0;
				if(versionCheck == false){
					document.getElementById("hsmiframe").src = iframesrc;
					statusMsg("설치된 인증서 관리프로그램 버전 확인중", chkCount);
					addEvent();
					setTimeout(send, 200);
					setTimeout(function(){fnChecker(true);}, 1000);
				}
			}else{
				if(navigator.userAgent.indexOf("Firefox") > -1){
					statusMsg('<span class="setting">미설치</span><div id="btn" class="wh_s"><a href="'+VestCert_PKG+'">설치하기</a></div>');
				}else if (navigator.userAgent.indexOf("MSIE 7.0") > -1 && navigator.userAgent.indexOf("compatible") < 0) {
					statusMsg("사용중인 IE7 브라우져에서는 동작하지 않습니다. 타 브라우져 또는 IE버전을 업데이트 하시길 바랍니다.");
					document.getElementById("btn_run").style.display = "block";
				} else {
					statusMsg('<span class="setting">미설치</span><div id="btn" class="wh_s"><a href="'+VestCert_PKG+'">설치하기</a></div>');
					//document.getElementById("btn_run").style.display = "block";
					setTimeout(function(){ fnInstallCheck(fnChecker); }, 1000);
				}
			}
			chkCount++;
		};
		
		function GetClientOS() {
			if(navigator.platform == OSTYPE_WIN32) 	{
				Client_OS = OSTYPE_WIN32;
			} 
			else if(navigator.platform == OSTYPE_WIN64) 	{
				Client_OS = OSTYPE_WIN64;
			} 
			else if(navigator.platform == "MacIntel")	{
				Client_OS = OSTYPE_MAC;
			}
			else 	{
				Client_OS = OSTYPE_UNKNOWN;
			}
			
			/* if(Client_OS == OSTYPE_MAC){
				document.getElementById("mac_downloadBox").style.display = "block";
				document.getElementById("win_downloadBox").style.display = "none";
			}else{
				document.getElementById("win_downloadBox").style.display = "block";
				document.getElementById("mac_downloadBox").style.display = "none";
			} */
		}
		
		function SetVestCertInfo() {
			if (Client_OS == OSTYPE_MAC) {
				VestCert_PKG = VestCert_MAC_PKG;
				lastestVersion = VestCert_MAC_Version;
			}
		}
		
		GetClientOS();
		SetVestCertInfo();
		
		addEvent();
		UniSignWeb_LoadObject();
		fnInstallCheck(fnChecker);
		
	</script>
</body>
</html>
