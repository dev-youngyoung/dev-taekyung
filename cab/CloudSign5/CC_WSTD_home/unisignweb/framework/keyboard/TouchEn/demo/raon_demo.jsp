<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<head>
<title>### TouchEn NxKey For Edge ###</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></meta>
<!-- 키보드보안 스크립트 호출 Start-->
<script type="text/javascript" src="/TouchEn/nxKey/js/jquery-1.11.1.js"></script>
<script type="text/javascript" src="/TouchEn/nxKey/js/TouchEnNxYT.js"></script>
<!-- 키보드보안 스크립트 호출 End-->
<script type="text/javascript">
function GetEncCrossCert() {
    var pubkey = "-----BEGIN CERTIFICATE-----MIIDSzCCAjOgAwIBAgIJAOYjCX4wgWIVMA0GCSqGSIb3DQEBCwUAMGcxCzAJBgNVBAYTAktSMR0wGwYDVQQKExRSYW9uU2VjdXJlIENvLiwgTHRkLjEaMBgGA1UECxMRUXVhbGl0eSBBc3N1cmFuY2UxHTAbBgNVBAMTFFJhb25TZWN1cmUgQ28uLCBMdGQuMB4XDTEzMTIzMDAxNTAxMloXDTIzMTIyODAxNTAxMlowRzELMAkGA1UEBhMCS1IxGzAZBgNVBAoTElJhb25TZWN1cmUgQ28uLEx0ZDEbMBkGA1UEAxMSUmFvblNlY3VyZSBDby4sTHRkMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsXWsBJXwRwoTwGbSwYZbyGWJsdNg8JM6lZ15hVMzRrz7epFAHqX0xcigLcLUTNoLmnegcn1Kvq96zxMyn8A7YJt1bjx2lHOwF5BC+yDVSeylKcsa4HUQ7gUUswzR7K+Ck3tUFklNp+CnsT/uq5s8lixWddepvhmqRCuBhSRoNDpw/KY8x5ZK8VByoRI8mIouwTTaMTT8BD0XV55YN6JR2QkE9doANlinByG2SLcI8zQFw5D2J+gnX006gNYmjqk4FXBQZNMsGP5o2CdOuor39j17jkhdzi6iJ0W87/7LbWaVh462ULuCN/iT5kbLSToeL4lAiUdhJKVTpK5n4AooLwIDAQABoxowGDAJBgNVHRMEAjAAMAsGA1UdDwQEAwIF4DANBgkqhkiG9w0BAQsFAAOCAQEAlh7htO04E4as1OiLRVBpwnBEFgYtDNq9dyb8KbBI/fqa3ny6xf8Fg+RIgHjP1d//hAe/9tXNDapJ9tC//5ikpCNTTsE4fVGLb0nfimSA4ZrqXL8p2METZ36oymxoxl1vL30FmmOst0TfgcF5YM9C+4wNsXq8qj+JtRejrImEjA7oW6pJOcnWutjrXlFKEDYHYymWfOiZqHQtWBwCv8P8PjD8jRJxPpKLpfsQU6MatAHXNsuYc0orUsG6wUxjwTTorBlSnjBnXeFsUK5UXaWK81tnN57dw2pT8OZoZw2JwCxCED6o+U8uqgZfioK4DTByHxdkssoOhjyot+0hYEGa9A==-----END CERTIFICATE-----";
    var frmName = "frm";
    var eleId = "certpwd";
    TK_GetEncCrossCert(frmName, eleId, pubkey, function(result){
    	alert("서명값 암호화 : " + result); // 암호화 결과값
    });
}
function makeFiled(){
	//동적 필드 생성
	//키보드보안 적용시 해당 input 필드에 data-enc Attribute를 추가 합니다.
	var inn = '<br><br>인증서 연동 : <form id="frm" name="frm" />';
	inn += '<input type="password" id="certpwd" name="certpwd" data-enc="on" />';
	inn += '<input type="button" value="암호화확인" onclick="GetEncCrossCert();" ></input>';
	document.getElementById("m").innerHTML = inn;
	//동적 필드 생성이 완료 된 이 후 해당 필드에 키보드보안 적용을 위해 TK_Rescan_HTML(frmname,inputname)을 호출하여 보안 적용을 해 줍니다.
	TK_Rescan_HTML("frm","certpwd");//키보드보안 동적 적용
}
function SubmitData(formObj) 
{
	//암호화된 데이터를 보기위한 함수.
	TK_makeEncData(formObj);
	
	formObj.submit();
}
</script>
</head>
<body>
		비밀번호 : <input type="password" id="pwd01" data-enc="on"/>
		<input type="button" value="로그인" onclick="SubmitData(frm)"/>
		<input type="button" value="공인인증서 로그인" onclick="makeFiled()"/><br/>
		<div id="m">
		</div>	
</body>
</html>
