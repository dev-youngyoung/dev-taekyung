<%@ page contentType="text/html; charset=EUC-KR" %>
<%

if(request.getServerName().equals("www.nicedocu.com")&&!request.isSecure()){
	//response.sendRedirect(request.getRequestURL().toString().replaceAll("http://", "https://")+"?"+request.getQueryString());
	response.sendRedirect("https://www.nicedocu.com");
	return;
}
response.sendRedirect("/web/buyer/index.jsp");

%>
<%@ page contentType="text/html; charset=EUC-KR" %>
<%
	String gubun = request.getParameter("gubun")==null ? "":request.getParameter("gubun");
	String bg_gubun = "main";
	if(gubun.equals("buyer")){
		bg_gubun = "sub1";
	}
%>
<%@ include file="/web/hub2/header.jsp" %>
<body>
<div class="parallax-bg <%=bg_gubun%>"></div>
<div class="wrap">
	<header>
		<div class="inner-container">
			<h1>
				<a href="/">
					<img src="/web/hub2/images/common/common_logo.png" alt="나이스다큐" class="white-logo">
					<img src="/web/hub2/images/common/common_logo_color.png" alt="나이스다큐" class="color-logo">
				</a>
			</h1>
			<nav class="gnb">
				<ul class="depth1">
					<li>
						<a href="./index.jsp?gubun=buyer">일반 기업용</a>
						<ul class="depth2">
							<li>
								<a href="javascript:mobileChkGo('/web/buyer/');">사이트 이동</a>
							</li>
							<li>
								<a href="./index.jsp?gubun=buyer">서비스 소개</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="./index.jsp?gubun=supplier">건설 기업용</a>
						<ul class="depth2">
							<li>
								<a href="javascript:mobileChkGo('/web/supplier/');">사이트 이동</a>
							</li>
							<li>
								<a href="./index.jsp?gubun=supplier">서비스 소개</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="./index.jsp?gubun=fc">프랜차이즈 기업용</a>
						<ul class="depth2">
							<li>
								<a href="javascript:mobileChkGo('/web/fc/');">사이트 이동</a>
							</li>
							<li>
								<a href="./index.jsp?gubun=fc">서비스 소개</a>
							</li>
						</ul>
					</li>
					<li>
						<a href="./index.jsp?gubun=logis">물류 기업용</a>
						<ul class="depth2">
							<li>
								<a href="javascript:mobileChkGo('/web/logis');">사이트 이동</a>
							</li>
							<li>
								<a href="./index.jsp?gubun=logis">서비스 소개</a>
							</li>
						</ul>
					</li>
				</ul>
			</nav>
			<a href="/web/hub2/mobile_gnb.html" class="gnb-mobile"  onclick="ajaxLink(this.href,'GET','');return false;">메뉴열기</a>
		</div>
	</header>


	<div class="container">

		<%
			if(gubun.equals("buyer")){
		%>
		<%@ include file="/web/hub2/content_buyer.jsp" %>
		<%
		}else if(gubun.equals("supplier")){
		%>
		<%@ include file="/web/hub2/content_supplier.jsp" %>
		<%
		}else if(gubun.equals("fc")){
		%>
		<%@ include file="/web/hub2/content_fc.jsp" %>
		<%
		}else if(gubun.equals("logis")){
		%>
		<%@ include file="/web/hub2/content_logis.jsp" %>
		<%
		}else{
		%>
		<%@ include file="/web/hub2/content_main.jsp" %>
		<%
			}
		%>


		<div class="contact-block">
			<div class="inner-container">
				<p class="tit">도입문의</p>
				<ul class="contact-list">
					<li>
						<a href="tel:02-788-9097" style="color: inherit">
							<div class="icon">
								<img src="/web/hub2/images/main/contact_icon1.png" alt="아이콘1">
							</div>
							<p>02-788-9097</p>
						</a>
					</li>
					<li>
						<a href="mailto:nicedocu@nicednr.co.kr" style="color: inherit">
							<div class="icon">
								<img src="/web/hub2/images/main/contact_icon2.png" alt="아이콘2">
							</div>
							<p>nicedocu@nicednr.co.kr</p>
						</a>
					</li>
					<li>
						<div class="icon">
							<img src="/web/hub2/images/main/contact_icon3.png" alt="아이콘3">
						</div>
						<p>
							<a href="/web/hub2/qna.html" onclick="ajaxLink(this.href,'GET','');return false;">문의글 남기기</a>
						</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<footer>
		<div class="inner-container">
			<div class="footer__top">
				<div class="footer__link">
					<ul>
						<li>
							<a href="javascript:fPopupPrivacy();" style="color:#ff6c00">개인정보취급방침</a>
						</li>
					</ul>
				</div>
				<!--
                <div class="footer__pc">
                    <a href="">PC버전</a>
                </div>
                -->
			</div>
			<div class="footer__bottom">
				<div class="footer__logo">
					<img src="/web/hub2/images/common/footer_logo.jpg" alt="나이스디앤알">
				</div>
				<div class="footer__address">
					<ul>
						<li>NICE D&R(NICE Data & Research)</li>
						<li>대표자 : 강용구</li>
						<li>사업자등록번호 : 107-87-08207</li>
						<li>통신판매업 신고번호 : 제2012-서울구로-1033호</li>
						<li>서울 서대문구 충정로 36(충정로3가)</li>
						<li>대표번호 : 02-788-9097</li>
					</ul>
					<p class="footer__copyright">Copyrightⓒ 2019 NICE D&R Inc, All Rights Reserved.</p>
				</div>
			</div>
		</div>
	</footer>
</div>
<div class="top-btn">
	<a href="javascript:;">
		<i class="fas fa-long-arrow-alt-up"></i>
		TOP
	</a>
</div>

</body>
</html>