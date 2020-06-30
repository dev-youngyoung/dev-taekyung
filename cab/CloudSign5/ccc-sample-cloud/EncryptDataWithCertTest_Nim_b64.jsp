<%@ page language="java" import="java.io.*,java.util.*,java.text.*,crosscert.*" %>
<%@ page contentType = "text/html; charset=utf-8" %>
<%  
	/*-------------------------시작----------------------------*/ 
	response.setDateHeader("Expires",0); 
	response.setHeader("Prama","no-cache"); 

	if(request.getProtocol().equals("HTTP/1.1")) 
	{ 
		response.setHeader("Cache-Control","no-cache"); 
	} 
	/*------------------------- 끝----------------------------*/ 
	
	InputStream inCert=null;
	byte[]Certfilebuf;

	int nRet, nCertlen ;
	
	Properties props = System.getProperties(); // get list of properties
	String file_separator = (String)(props.get("file.separator"));
	String current_dir = "";
	String CertPath = "";
	String Full_path = request.getRealPath(request.getServletPath());

	String EncCertFilename = "kmCert.der"; //실제 서버인증서 경로를 읽어와야 한다
	String EncCertFullFilename = "";

	String sBase64EncodeCert = "";
	
	current_dir = Full_path.substring(0,Full_path.lastIndexOf(file_separator));

	CertPath = current_dir + file_separator + "Cert" + file_separator;

	EncCertFullFilename = CertPath + EncCertFilename;

	out.println("EncCertFullFilename : " + EncCertFullFilename + "<br>");
	

	// 암호화용 인증서 kmCert.der
	try 
	{ 

		inCert = new FileInputStream(new File(EncCertFullFilename));		
		
	}
	catch (FileNotFoundException e) 
	{
		System.out.println(e);
	}
	catch (IOException e) 
	{
		System.out.println(e);
	}
	
	
	nCertlen = inCert.available();
	Certfilebuf = new byte[nCertlen];
	nRet = inCert.read(Certfilebuf);

	inCert.close();


	// 읽어온 서버인증서 base64인코딩
	// Base64 Encoding
	Base64 base64 = new Base64();
	nRet = base64.Encode(Certfilebuf, nCertlen);
	if (nRet != 0)
	{
		out.println("base인코드 에러내용 : " + base64.errmessage + "<br>");
		out.println("base인코드에러코드 : " + base64.errcode);
		return;
	}
	sBase64EncodeCert = new String(base64.contentbuf);

%>

<!DOCTYPE html>
<html>
	<head>
  		<meta charset="utf-8">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta http-equiv="X-UA-Compatible" content="IE=Edge"/>
		<title> CrosscertWeb Plugin-Free :: HTML5 </title>
		<!-- 전자인증 모듈 설정 //-->
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/unisignweb/rsrc/css/certcommon.css?v=1" />

		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/assets/css/fonts/fonts.css">
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/assets/css/footable.core.min.css">
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/assets/css/github.css">
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/assets/css/theme.min.css">
		<link rel="stylesheet" type="text/css" href="../CC_WSTD_home/assets/css/styles.css">

		<!-- cloudsign -->
		<script type="text/javascript" src="../CC_WSTD_home/unisignweb/js/cloudsign/functions.js?v=1"></script>
		<script type="text/javascript" src="../CC_WSTD_home/unisignweb/js/unisignwebclient.js?v=1"></script>
		<script type="text/javascript" src="UniSignWeb_Multi_Init_PluginFree.js?v=1"></script>

		<!-- jQuery JS -->
		<script src="../CC_WSTD_home/assets/js/jquery-1.11.1.min.js"></script>
		<script src="../CC_WSTD_home/assets/js/jquery-ui.min.js"></script>
		<!-- 전자인증 모듈 설정 //-->
	</head>

	<script>								
		function EncryptData() 
		{
			var textBox = document.getElementById('plainText');
			var encrypedTextBox = document.getElementById('encryptedText');
			var b64KMCert = document.getElementById('base64kmcert');
			
			//alert(b64KMCert.value);
			
			// plaintext, dn, kmcert, clrUserCertList, callback

			var encodedText = unisign.Base64Encoding( textBox.value);

			unisign.EncryptDataWithCert( encodedText, b64KMCert.value, function(rv, encrypedText)
				{ 
					encrypedTextBox.value = encrypedText;
					
					if ( rv != 0 )
					{
						unisign.GetLastError(
							function(errCode, errMsg) 
							{ 
								alert('Error code : ' + errCode + '\n\nError Msg : ' + errMsg); 
							}
						);
					} 
				} 
			);
			
			document.getElementById('encrypt').blur();
		}		

		function Send()
			{
				if (document.frm.encryptedText.value == "")
				{
					alert("암호화값이 없습니다.");
					return "";
				}else{
					document.frm.method = "post";
					document.frm.action = "server_decrypt_b64.jsp";
					document.frm.submit();
				}
				
			
			}
	
	</script>

	<body>
	<h3><font color="red">  hidden  처리 대상 : 원문, 전자서명값</font></h3><br>
		form 속성에 onsubmit="return false" 을 설정해야 함 <br>
		<form name="frm" onsubmit="return false">
		<table>
			<tr>
				<td >
					<table >
						<tr>
							<td >
								<textarea id="plainText" rows="5" cols="25">홍길동/!@#$%^&*()_+|-=\1234567890123 ┃↕╂⇔1212121212</textarea> 
								<center><h3><font color="blue">원문</font></h3><br></center> 
								<input type=button value="비대칭키 암호화 실행" onclick="EncryptData();"></button>
							</td>
						</tr>
					</table>
				</td>
				<td width="50">&nbsp;
				</td>
				<td>
					<table>
						<tr>
							<td>
								<textarea id="encryptedText" name="encryptedText" rows="10" cols="80"></textarea>
								<center><h3><font color="blue">암호화값</font></h3><br></center> 
							</td>
						</tr>
							<tr>
							<td align = "center">
							<input type=button value="전송(server_decrypt.jsp)" onclick="Send();">	
							</td>
							</tr>
						<tr>
					<td>
						<center><textarea name="base64kmcert" id="base64kmcert"   rows="10" cols="40"><%=sBase64EncodeCert%></textarea>
						<center><h3><font color="blue">암호화용 공개키</font></h3><br></center> 
					</td>
					<td width="50">&nbsp;
					</td>
				</tr>	
				<br>
					</table>
				</td>
			</tr>
			</form>
		</table>
	</body>	
</html>

