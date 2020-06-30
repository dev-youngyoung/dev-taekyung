<%@ page contentType="text/html; charset=EUC-KR" %>
<%

if(request.getServerName().equals("www.nicedocu.com")&&!request.isSecure()){
	//response.sendRedirect(request.getRequestURL().toString().replaceAll("http://", "https://")+"?"+request.getQueryString());
	response.sendRedirect("https://www.nicedocu.com");
	return;
}

// ���� ���̽���ť�� ������ ���
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

	<title>���̽���ť</title>
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

					//��·��̾ ���� ��� ����
					var el = document.getElementById(id);
					if(!el) {
						el = document.createElement("div");
						el.style.display = 'none';
						document.body.appendChild(el);
					}

					//IE�� ��� ���װ� ������. �׷��� &nbsp�� �߰�
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
						} catch(e) { alert(callback + " �Լ��� �����ϴ�."); }
					}

					//�ڹٽ�ũ��Ʈ ���� (defer�� IE ���� ����Ǿ� �Ⱦ�)
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
				//client.setRequestHeader("Content-Length", parameters.length); ũ�� ���ȿ� ����
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
			alert("����ڵ�Ϲ�ȣ�� ��Ȯ�� �Է����ּ���.");
			f['vendcd'].focus();
			return false;
		}
		if(isNaN(vendcd)){
			alert("����ڵ�Ϲ�ȣ�� ��Ȯ�� �Է����ּ���.");
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
					<img src="/web/hub/images/hub_logo.png" alt="���� ���� ���� ���̽���ť �������� ���ڰ�� Ŭ���� ����">
				</div>
				<div class="main-title">
					<img src="/web/hub/images/hub_title.png" alt="Industry 4.0 Sloud Service Leader">
				</div>
				<div class="search">
					<p>ȸ�������� ��û�� ����ü Ȯ���ϱ�</p>
					<div class="input-wrap">
						<form novalidate name="form1" method="post" action="chk_client.jsp" onsubmit="return false">
						<input type="text" name="vendcd" maxlength="10" placeholder="����ڹ�ȣ(���ڸ��Է�)" onkeyup="if(event.keyCode=='13'){chkclient();}" >
						<input type="button" value="�˻�" onclick="chkclient()">
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
								<p class="title">�Ϲ� �����</p>
								<p class="text">���ڱ��Žý���</p>
								<div class="btn">
									<a href="/web/buyer/main/index.jsp">�ٷΰ���</a>
								</div>
							</div>
						</li>
						<li class="item02">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img2.jpg" alt="">
								</div>
								<p class="title">�Ǽ� �����</p>
								<p class="text">�������޽ý���</p>
								<div class="btn">
									<a href="/web/supplier/main/index.jsp">�ٷΰ���</a>
								</div>
							</div>
						</li>
						<li class="item03">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img3.jpg" alt="">
								</div>
								<p class="title">���������� �����</p>
								<p class="text">���Ͱ������ý���</p>
								<div class="btn">
									<a href="http://nfc.nicedocu.com">�ٷΰ���</a>
								</div>
							</div>
						</li>
						<li class="item04">
							<div class="gnb-wrap">
								<div class="off-block"></div>
								<div class="img">
									<img src="/web/hub/images/gnb_img4.jpg" alt="">
								</div>
								<p class="title">���� �����</p>
								<p class="text">���ڰ��ý���</p>
								<div class="btn">
									<a href="http://logis.nicedocu.com">�ٷΰ���</a>
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
									<p class="title">�̿�ȳ�</p>
									<ul class="gb-con-list">
										<li>ȸ�������� ��û �޾� �����ϰ��� �ϴ� ���񽺸� �����ϼ���. </li>
										<li><u>����Ǽ���</u> ���̽���ť�� <u>���Ϲݱ���롯</u> ���̽���ť�� ���� ��Ī�� ����Ǿ����ϴ�. </li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item01">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">�Ϲݱ�� �̿�ȳ�(��Ǽ�)</p>
									<ul class="gb-con-list">
										<li>���� ���� : ���ڰ���, ��������, ���ڰ��, ������, ���»����</li>
										<li>�������� : �پ��� ������� �� �����ڼ������ ����, ����(����)���� ����</li>
										<li>���ڰ�� : �پ��� ���������� �̿��Ͽ� �ս��� �����ϰ� ��� ü���� �����մϴ�.</li>
										<li>��û�� �� �ܹ��� ���Ŀ� ���ؼ��� ���ڹ���ȭ�� �����մϴ�.</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item02 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">�Ǽ���� �̿�ȳ�</p>
									<ul class="gb-con-list">
										<li>�Ǽ� ����� ���̽���ť �Ǽ� ������ ����ȭ�� �������޽ý����� �����մϴ�.</li>
										<li>���� ���� : ��������, ���ڰ��, ���ڹ���, ���ڽ�������߱�, ������, ���»����, ��ȣ�����򰡰���</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item03 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">���������� ��� �̿�ȳ�</p>
									<ul class="gb-con-list">
										<li>���������� ����� ���̽���ť�� ���������� ������ ����ȭ�� ���ڰ�� ���񽺸� �����մϴ�.</li>
										<li>���ͺ��ο� (���)���ְ��� ���Ͱ�� ���� ���ü����� ���ڹ���ȭ�� ���� �մϴ�.</li>
									</ul>
								</div>
							</div>
						</li>
						<li class="item04 ">
							<div class="gb-wrap">
								<div class="left-con">
									<p class="title">���� ��� �̿�ȳ�</p>
									<ul class="gb-con-list">
										<li>���� ����� ���̽���ť�� ���ڰ�� ������ �����ϸ�, CJ�������, ����, �Ե��۷ι��������� ȸ�����Դϴ�.</li>
										<li>������, �ù���, �ù�ǥ�� ��� �� ����(�ù�) ����� ü���ϰ��� �ϴ� ���� ������ ����ġ����� ȸ�������� �ϼ���.</li>
										<li>CJ�������� ����Ź, �Ӵ���, ������ �� ��� ü�� �ÿ���  ���Ϲݱ���ġ����� ȸ�������� �ϼ���.</li>
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
					NICE ��ؾ�(��)  ��ǥ�� : ���뱸������Ǹž� �Ű��ȣ : ��2012-���ﱸ��-1033ȣ<br>
					����� ���빮�� ������ 36(������3��) ��TEL : 02-788-9097  FAX : 02-6442-2383������ڵ�Ϲ�ȣ : 107-87-08207<br>
					Copyright�� ���̽���ؾ��ֽ�ȸ�� All Rights Reserved.
				</div>
				<div class="service">
					<img src="/web/hub/images/service_number.png" alt="�Ӵ뼭�� �� �ý��� ���� ���� ������ 02-788-9097">
				</div>
			</div>
		</div>
	</div>

	<!-- ���̾��˾� -->
	<!--
		[D] active Ŭ������ �����ְ� �����ֱ�
	-->
	<div class="lp-wrap HeightAuto" id="comp_info">
	</div>
	<!-- ���̾��˾� -->
</body>
</html>
