<%@ page contentType="text/html; charset=UTF-8" %>
<%

if(request.getServerName().equals("www.nicedocu.com")&&!request.isSecure()){
	//response.sendRedirect(request.getRequestURL().toString().replaceAll("http://", "https://")+"?"+request.getQueryString());
	response.sendRedirect("https://www.nicedocu.com");
	return;
}

// 물류 나이스다큐로 접근할 경우
if(request.getServerName().equals("logis.nicedocu.com"))
	response.sendRedirect("/web/logis/index.jsp");
else if(request.getServerName().equals("wemakeprice.nicedocu.com"))
	response.sendRedirect("/web/buyer/index.jsp");
else if(request.getServerName().equals("wmp.nicedocu.com"))
	response.sendRedirect("/web/buyer/index.jsp");
else if(request.getServerName().equals("www.niceaptbid.co.kr"))
	response.sendRedirect("https://www.niceaptbid.com:444/web/apt/index.jsp");
else if(request.getServerName().equals("www.niceaptbid.com"))
	response.sendRedirect("https://www.niceaptbid.com:444/web/apt/index.jsp");
else if(request.getServerName().equals("www.nicebid4apt.co.kr"))
	response.sendRedirect("https://www.niceaptbid.com:444/web/apt/index.jsp");
else if(request.getServerName().equals("www.nicebid4apt.com"))
	response.sendRedirect("https://www.niceaptbid.com:444/web/apt/index.jsp");
else if(request.getServerName().equals("nfc.nicedocu.com"))
	response.sendRedirect("/web/fc/index.jsp");

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<meta content="IE=edge" http-equiv="X-UA-Compatible">

	<title>나이스다큐</title>
	<link rel="stylesheet" type="text/css" href="/web/hub/css/default.css">
	<link rel="stylesheet" type="text/css" href="/web/hub/css/libs/jquery.bxslider.css">

	<script src="/web/hub/js/libs/jquery-1.11.1.min.js"></script>
	<script src="/web/hub/js/libs/jquery.bxslider.js"></script>
	<script src="/web/hub/js/common.js"></script>

	<!-- placeholder fix -->
	<script src="/web/hub/js/libs/jquery.placeholder.js"></script>

	<script type="text/javascript">

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
				//client.setRequestHeader("Content-Length", parameters.length); 크롬 보안에 위반
				//client.setRequestHeader("Connection", "close");
				client.send(parameters);
			} else {
				client.open("GET", url, true);
				client.send(null);
			}
		}
	}

	function chkclient(){
		var f = document.forms['form1'];
		var vendcd = f['vendcd'].value.replace("-","");
		if(vendcd.length !=10 ){
			alert("사업자등록번호를 정확히 입력해주세요.");
			f['vendcd'].focus();
			return false;
		}
		if(isNaN(vendcd)){
			alert("사업자등록번호를 정확히 입력해주세요.");
			f['vendcd'].focus();
			return false;
		}
		call("form1","comp_info");
	}

	$(document).ready(function(){
	});
	</script>
</head>
<body>
	<div class="wrap">
		<div class="header">
			<div class="inner-contents">
				<div class="logo">
					<img src="/web/hub/images/hub_logo.png" alt="구매 조달 장터 나이스다큐 전자입찰 전자계약 클라우드 서비스">
				</div>
				<div class="main-title">
					<img src="/web/hub/images/hub_title.png" alt="Industry 4.0 Sloud Service Leader">
				</div>
				<div class="search">
					<p>회원가입을 요청한 상대업체 확인하기</p>
					<div class="input-wrap">
						<form novalidate name="form1" method="post" action="chk_client.jsp" onsubmit="return false">
						<input type="text" name="vendcd" maxlength="10" placeholder="사업자번호(숫자만입력)" onkeyup="if(event.keyCode=='13'){chkclient();}" >
						<input type="button" value="검색" onclick="chkclient()">
						</form>
					</div>
				</div>
			</div>
		</div>
		<div class="container">
			<div class="contents-wrap">
				<div class="inner-contents">
					<ul class="gnb">
						<li class="item01">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img1.jpg" alt="">
								</div>
								<p class="title">일반 기업용</p>
								<p class="text">전자구매시스템</p>
								<div class="btn">
									<a href="/web/buyer/main/index.jsp">바로가기</a>
								</div>
							</div>
						</li>
						<li class="item02">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img2.jpg" alt="">
								</div>
								<p class="title">건설 기업용</p>
								<p class="text">전자조달시스템</p>
								<div class="btn">
									<a href="/web/supplier/main/index.jsp">바로가기</a>
								</div>
							</div>
						</li>
						<li class="item03">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img3.jpg" alt="">
								</div>
								<p class="title">프랜차이즈 기업용</p>
								<p class="text">가맹계약관리시스템</p>
								<div class="btn">
									<a href="http://nfc.nicedocu.com">바로가기</a>
								</div>
							</div>
						</li>
						<li class="item04">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img4.jpg" alt="">
								</div>
								<p class="title">물류 기업용</p>
								<p class="text">전자계약시스템</p>
								<div class="btn">
									<a href="http://logis.nicedocu.com">바로가기</a>
								</div>
							</div>
						</li>
					</ul>
				</div>
				<div class="gnb-bottom">
					<ul class="gnb-contents">
						<li class="base active">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">이용안내</p>
									<ul class="gb-con-list">
										<li>회원가입을 요청 받아 가입하고자 하는 서비스를 선택하세요. </li>
										<li><u>‘비건설’</u> 나이스다큐가 <u>‘일반기업용’</u> 나이스다큐로 서비스 명칭이 변경되었습니다. </li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item01">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">일반기업 이용안내(비건설)</p>
									<ul class="gb-con-list">
										<li>서비스 내용 : 전자견적, 전자입찰, 전자계약, 통계관리, 협력사관리</li>
										<li>전자입찰 : 다양한 입찰방법 및 낙찰자선정방법 지원, 국가(지방)계약법 지원</li>
										<li>전자계약 : 다양한 인증수단을 이용하여 손쉽고 간편하게 계약 체결이 가능합니다.</li>
										<li>신청서 등 단방향 서식에 대해서도 전자문서화를 지원합니다.</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item02 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">건설기업 이용안내</p>
									<ul class="gb-con-list">
										<li>건설 기업用 나이스다큐 건설 업종에 최적화된 전자조달시스템을 제공합니다.</li>
										<li>서비스 내용 : 전자입찰, 전자계약, 전자문서, 전자실적증명발급, 통계관리, 협력사관리, 상호협력평가관리</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item03 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">프랜차이즈 기업 이용안내</p>
									<ul class="gb-con-list">
										<li>프랜차이즈 기업用 나이스다큐는 프랜차이즈 업종에 최적화된 전자계약 서비스를 제공합니다.</li>
										<li>가맹본부와 (희망)점주간에 가맹계약 각종 관련서류를 전자문서화가 가능 합니다.</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item04 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">물류 기업 이용안내</p>
									<ul class="gb-con-list">
										<li>물류 기업用 나이스다큐는 전자계약 업무를 지원하며, CJ대한통운, 한진, 롯데글로벌로지스가 회원사입니다.</li>
										<li>집배점, 택배운송, 택배표준 계약 등 물류(택배) 계약을 체결하고자 하는 경우는 “물류 기업用”으로 회원가입을 하세요.</li>
										<li>CJ대한통운과 위수탁, 임대차, 장비공급 등 계약 체결 시에는  “일반기업用”으로 회원가입을 하세요.</li>
									</ul>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<div class="footer">
			<div class="inner-contents">
				<div class="logo">
					<img src="/web/hub/images/footer_nice.png" alt="nice">
				</div>
				<div class="text">
					NICE 디앤알(주)  대표자 : 강용구│통신판매업 신고번호 : 제2012-서울구로-1033호<br>
					서울시 서대문구 충정로 36(충정로3가) │TEL : 02-788-9097  FAX : 02-6442-2383│사업자등록번호 : 107-87-08207<br>
					Copyrightⓒ 나이스디앤알주식회사 All Rights Reserved.
				</div>
				<div class="service">
					<img src="/web/hub/images/service_number.png" alt="임대서비스 및 시스템 구축 문의 고객센터 02-788-9097">
				</div>
			</div>
		</div>
	</div>

	<!-- 레이어팝업 -->
	<!--
		[D] active 클래스로 보여주고 감춰주기
	-->
	<div class="lp-wrap HeightAuto" id="comp_info">
	</div>
	<!-- 레이어팝업 -->
</body>
</html>
