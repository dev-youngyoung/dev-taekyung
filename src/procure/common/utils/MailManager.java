package procure.common.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Authenticator;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeUtility;
import javax.servlet.http.HttpServletRequest;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.util.Util;

import org.apache.commons.configuration.CompositeConfiguration;

import procure.common.conf.Startup;
import procure.common.db.SQLManager;
import procure.common.value.DataSetValue;
import procure.common.value.ResultSetValue;
import procure.common.value.SQLJob;
import procure.common.utils.Security;
import procure.mail.OkkiMail;


public class MailManager {

	private	CompositeConfiguration ccf	=	null;
	private String mCompanyType = "";

	
	static class PopupAuthenticator extends Authenticator {
        public PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication("", "");
        }
    }

	
	/****************************************
	 * 전자계약서 전자서명 요청 메일 전송(일반기업용)
	 *
	 * @param cont_no 계약번호
	 * @param cont_chasu 계약차수
	 * @param cust_vendcd 받는업체 사업자번호
	 * @param sSendName 전송업체명
	 * @param sRecvName 받는업체 담당자명(재전송시 사용, 일반전송시 "")
	 * @param sRecvEmail 받는업체 담당자 이메일(재전송시 사용, 일반전송시 "")
	 * @return 100 : 전송할 데이터가 TCO_CUST 테이블에 존재하지 않는 경우
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 */
	public boolean sendContBMail(String cont_no, String cont_chasu, String member_no, String sSendName, String sRecvName, String sRecvEmail)
	{
		boolean succes = false;
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();

		try {		
			sqlj = new SQLJob("bct_email.xml", true);
			
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("member_no", member_no);
			ds = sqlj.getOneRow("email_s1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ", member_no : "+ member_no +")");
				sqlj.close();
				return false;
			}
			
			String sFromCompanyName = "";
			String sToCompanyName = "";
			String sToPersonName = "";
			String sToEmail = "";
			String sEmailRandom = "";
			String sContName = "";
			String sContDay = "";
			String member_status = "";//회원강입 상태 01:정회원 02:비회원

			sFromCompanyName = sSendName;
			sToCompanyName = ds.getString("member_name");
			sContName = ds.getString("cont_name");
			sContDay = ds.getString("cont_date");
			member_status = ds.getString("member_status");

			if(!sRecvName.equals("") && !sRecvEmail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = sRecvName;
				sToEmail = sRecvEmail;
				sEmailRandom = ds.getString("email_random");
			}			
			else
			{
				sToPersonName = ds.getString("user_name");
				sToEmail = ds.getString("email");
				RandomString rndStr = new RandomString();
				sEmailRandom = rndStr.getString(30,"");  // 새로 보내는 경우는 램덤 문자열 생성 후 저장
				
				sqlj.removeArray();
				sqlj.setArray(sEmailRandom);
				sqlj.setArray(cont_no);
				sqlj.setArray(cont_chasu);
				sqlj.setArray(member_no);
				sqlj.updateData("email_u1");
			}
			
			sqlj.removeArray();
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("member_no", member_no);
			ds1 = sqlj.getOneRow("email_s2");
			String sEmailSeq = ds1.getString("nextSeq");		
			
			String _sUrl = Startup.conf.getString("domain");
			String _sImg = _sUrl + "/images/email/20110620/";
			String _sEmailChk = _sUrl + "/web/buyer/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+member_no+"&num="+sEmailSeq;
			String _sEmailRet = "";
			if(member_no.substring(0,9).equals("000000000")) // 연대보증인은 이메일로 바로 서명 가능하고 회원은 사이트로 로그인하도록
			{
				_sEmailRet = _sUrl + "/web/buyer/contract/emailView.jsp?rs="+ sEmailRandom;
			}
			else
			{
				if(member_status.equals("02"))  // 비회원
				{
					_sEmailRet = _sUrl + "/web/buyer/member/join_agree.jsp";
				}
				else  // 회원
				{
					_sEmailRet = _sUrl + "/web/buyer/index.jsp";
				}
			}
			
			String html = "";
			html+="	<html>																																		";						
			html+="	<head>                                                                                                                                      ";
			html+="	<title>전자계약 서명 요청</title>                                                                                                         ";
			html+="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
			html+="	<style type=\"text/css\">                                                                                                                   ";
			html+="	<!--                                                                                                                                        ";
			html+="	td {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; line-height: normal; color: #5B5B5B}       ";
			html+="	.b {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; font-weight: bold; color: #3662B8}         ";
			html+="	-->                                                                                                                                         ";
			html+="	</style>                                                                                                                                    ";
			html+="	</head>                                                                                                                                     ";
		    html+="                                                                                                                                             ";
			html+="	<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">                           ";
			html+="	<table width=\"700\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td ><img src=\""+_sImg+"mail_top.gif\" width=\"700\" height=\"119\"></td>                                                              ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td  height=\"50\">&nbsp;</td>                                                                                                          ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td align=\"right\">                                                                                                                    ";
			html+="	      <table width=\"100%\" border=\"0\" cellspacing=\"5\" cellpadding=\"15\" bgcolor=\"90AAC7\">                                           ";
			html+="	        <tr>                                                                                                                                ";
			html+="	          <td bgcolor=\"#FFFFFF\" align=\"center\"><br>                                                                                     ";
			html+="	            <img src=\""+_sImg+"sub_title3.gif\" width=\"104\" height=\"19\"><br>                                                ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"1\" cellpadding=\"10\" bgcolor=\"B5C6D9\">                                      ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td bgcolor=\"#fafafa\">                                                                                                    ";
			html+="	                  <table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"3\">                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"20%\" align=\"center\"><b>계약업체명</b></td>                                                                 ";
			html+="	                      <td width=\"50%\" align=\"left\">: "+sFromCompanyName+"<br/></td>                                                                       ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"20%\" align=\"center\"><b>계약명</b></td>                                                                               ";
			html+="	                      <td width=\"80%\" align=\"left\">: "+sContName+"<br/></td>                                                                          ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"20%\" align=\"center\"><b>계약일</b></td>                                                                               ";
			html+="	                      <td width=\"80%\" align=\"left\">: "+sContDay+"<br/></td>                                                                            ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                  </table>                                                                                                                  ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                                                         ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td ><span class=\"b\">"+sFromCompanyName+"</span>님이 <span class=\"b\">"+sToPersonName+"</span>                                                       ";
			html+="	                  님께 계약서 서명을 요청 하였습니다.                                                                                         ";
			if(member_status.equals("02")){
				html+="	                  <p>아래 '회원가입' 버튼을 클릭하여 나이스나이스 다큐에 회원 가입 후 계약서를 조회 하시기 바랍니다.<br>                                                              ";	
			}else{
				html+="	                  <p>아래 '상세보기' 버튼을 클릭하여 확인 하시기 바랍니다.<br>                                                              ";
			}
			html+="	                  </p>                                                                                                                      ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			if(member_status.equals("02")){
				html+="	            <a href=\""+_sEmailRet+"\" target=\"_blank\"><img src=\""+_sImg+"btn_join.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";	
			}else{
				html+="	            <a href=\""+_sEmailRet+"\" target=\"_blank\"><img src=\""+_sImg+"btn_detail.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";
			}
			html+="	          </td>                                                                                                                             ";
			html+="	        </tr>                                                                                                                               ";
			html+="	      </table>                                                                                                                              ";
			html+="	    </td>                                                                                                                                   ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td >&nbsp;<img src='"+ _sEmailChk +"' width='0' height='0'></td>                                                                                                                        ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td><img src=\""+_sImg+"copyright.gif\" width=\"700\" height=\"120\"></td>                                                             ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	</table>                                                                                                                                    ";
			html+="	</body>                                                                                                                                     ";
			html+="	</html>                                                                                                                                     ";
			
			
//			String[] strCc= null;
//			String[] strBcc= null;
//			String strFrom = Startup.conf.getString("email.mailFrom");
//			String strFromName = "나이스다큐(일반기업용)";
			String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자계약서 전자서명을 요청하였습니다.";
//			String attchFile= "";
			
			//String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, strFromName, strSubject, html, attchFile);
			boolean bSuccess = OkkiMail.mail(sToEmail, sToPersonName, strSubject, html);

			String sStatus = "";
			if(bSuccess)
				sStatus = "01";  //성공 
			else
				sStatus = "02";  // 실패			
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String sysdate =  sdf.format((new GregorianCalendar()).getTime());
			sqlj.removeArray();
			sqlj.setArray(cont_no);
			sqlj.setArray(cont_chasu);
			sqlj.setArray(member_no);
			sqlj.setArray(sEmailSeq);
			sqlj.setArray(sysdate);
			sqlj.setArray(sToEmail); 
			sqlj.setArray(sToCompanyName); 
			sqlj.setArray(sToPersonName); 
			sqlj.setArray(sStatus); 
			sqlj.insertData("email_i1");
		
			sqlj.close();
			succes = true;
		}catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".sendContBMail()] :" + e.toString());
		}
		
		return succes;
		
	}	
	
	/****************************************
	 * 전자계약서 전자서명 요청 메일 전송(물류)
	 *
	 * @param cont_no 계약번호
	 * @param cont_chasu 계약차수
	 * @param cust_vendcd 받는업체 사업자번호
	 * @param sSendName 전송업체명
	 * @param sRecvName 받는업체 담당자명(재전송시 사용, 일반전송시 "")
	 * @param sRecvEmail 받는업체 담당자 이메일(재전송시 사용, 일반전송시 "")
	 * @return 100 : 전송할 데이터가 TCO_CUST 테이블에 존재하지 않는 경우
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 */
	public boolean sendContLMail(String cont_no, String cont_chasu, String member_no, String sSendName, String sRecvName, String sRecvEmail)
	{
		boolean succes = false;
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();

		try {		
			sqlj = new SQLJob("lct_email.xml", true);
			
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("member_no", member_no);
			ds = sqlj.getOneRow("email_s1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ", member_no : "+ member_no +")");
				sqlj.close();
				return false;
			}
			
			String sFromCompanyName = "";
			String sToCompanyName = "";
			String sToPersonName = "";
			String sToEmail = "";
			String sEmailRandom = "";
			String sContName = "";
			String sContDay = "";

			sFromCompanyName = sSendName;
			sToCompanyName = ds.getString("member_name");
			sContName = ds.getString("cont_name");
			sContDay = ds.getString("cont_date");

			if(!sRecvName.equals("") && !sRecvEmail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = sRecvName;
				sToEmail = sRecvEmail;
				sEmailRandom = ds.getString("true_random");
				
				sqlj.removeArray();
				sqlj.setArray(cont_no);
				sqlj.setArray(cont_chasu);
				sqlj.setArray(member_no);				
				sqlj.deleteData("email_d1");
			}			
			else
			{
				sToPersonName = ds.getString("user_name");
				sToEmail = ds.getString("email");
				RandomString rndStr = new RandomString();
				sEmailRandom = rndStr.getString(10,"");  // 새로 보내는 경우는 램덤 문자열 생성 후 저장
				
				sqlj.removeArray();
				sqlj.setArray(sEmailRandom);
				sqlj.setArray(cont_no);
				sqlj.setArray(cont_chasu);
				sqlj.setArray(member_no);
				sqlj.updateData("email_u1");
			}
			
			sqlj.removeArray();
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("member_no", member_no);
			ds1 = sqlj.getOneRow("email_s2");
			String sEmailSeq = ds1.getString("nextSeq");		
			
			String _sUrl = "http://logis.nicedocu.com";
			String _sImg = _sUrl + "/images/email/20110620/";
			String _sEmailChk = _sUrl + "/web/logis/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+member_no+"&num="+sEmailSeq;
			
			String _sEmailRet = "";
			if(member_no.substring(0,10).equals("0000000000")) // 비회원인 경우만 이메일로 바로 서명 가능하고 회원은 사이트로 로그인하도록
				_sEmailRet = _sUrl + "/web/logis/contract/emailView.jsp?rs="+ sEmailRandom;
			else
				_sEmailRet = _sUrl;
			
			String html = "";
			html+="	<html>																																		";						
			html+="	<head>                                                                                                                                      ";
			html+="	<title>전자계약 서명 요청</title>                                                                                                         ";
			html+="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
			html+="	<style type=\"text/css\">                                                                                                                   ";
			html+="	<!--                                                                                                                                        ";
			html+="	td {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; line-height: normal; color: #5B5B5B}       ";
			html+="	.b {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; font-weight: bold; color: #3662B8}         ";
			html+="	-->                                                                                                                                         ";
			html+="	</style>                                                                                                                                    ";
			html+="	</head>                                                                                                                                     ";
		    html+="                                                                                                                                             ";
			html+="	<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">                           ";
			html+="	<table width=\"700\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td ><img src=\""+_sImg+"mail_top.gif\" width=\"700\" height=\"119\"></td>                                                              ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td  height=\"50\">&nbsp;</td>                                                                                                          ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td align=\"right\">                                                                                                                    ";
			html+="	      <table width=\"100%\" border=\"0\" cellspacing=\"5\" cellpadding=\"15\" bgcolor=\"90AAC7\">                                           ";
			html+="	        <tr>                                                                                                                                ";
			html+="	          <td bgcolor=\"#FFFFFF\" align=\"center\"><br>                                                                                     ";
			html+="	            <img src=\""+_sImg+"sub_title3.gif\" width=\"104\" height=\"19\"><br>                                                ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"1\" cellpadding=\"10\" bgcolor=\"B5C6D9\">                                      ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td bgcolor=\"#fafafa\">                                                                                                    ";
			html+="	                  <table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"3\">                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"20%\" align=\"center\"><b>계약업체명</b></td>                                                                 ";
			html+="	                      <td>: "+sFromCompanyName+"<br/></td>                                                                       ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>계약명</b></td>                                                                               ";
			html+="	                      <td>: "+sContName+"<br/></td>                                                                          ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>계약일</b></td>                                                                               ";
			html+="	                      <td>: "+sContDay+"<br/></td>                                                                            ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                  </table>                                                                                                                  ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                                                         ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td><span class=\"b\">"+sFromCompanyName+"</span>님이 <span class=\"b\">"+sToCompanyName+"</span>                                                       ";
			html+="	                  님께 계약서 서명을 요청 하였습니다.                                                                                         ";
			html+="	                  <p>아래 '상세보기' 버튼을 클릭하여 확인 하시기 바랍니다.<br>                                                              ";
			html+="	                  </p>                                                                                                                      ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <a href=\""+_sEmailRet+"\" target=\"_blank\"><img src=\""+_sImg+"btn_detail.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";
			html+="	          </td>                                                                                                                             ";
			html+="	        </tr>                                                                                                                               ";
			html+="	      </table>                                                                                                                              ";
			html+="	    </td>                                                                                                                                   ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td>&nbsp;<img src='"+ _sEmailChk +"' width='0' height='0'></td>                                                                                                                        ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td><img src=\""+_sImg+"copyright.gif\" width=\"700\" height=\"120\"></td>                                                             ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	</table>                                                                                                                                    ";
			html+="	</body>                                                                                                                                     ";
			html+="	</html>                                                                                                                                     ";
			
			
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;
			String[] strBcc= null;
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strFromName = "나이스다큐(물류)";
			String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자계약서 전자서명을 요청하였습니다.";
			String attchFile= "";
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, strFromName, strSubject, html, attchFile);
			System.out.println("물류 전자계약 요청 메일 전송 결과 : " + strRtn[0]);
	
			String sStatus = "";
			if(strRtn[0].equals("ok"))
				sStatus = "01";  //성공 
			else
				sStatus = "02";  // 실패
			
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
			String sysdate =  sdf.format((new GregorianCalendar()).getTime());
			sqlj.removeArray();
			sqlj.setArray(cont_no);
			sqlj.setArray(cont_chasu);
			sqlj.setArray(member_no);
			sqlj.setArray(sEmailSeq);
			sqlj.setArray(sysdate);
			sqlj.setArray(sToEmail); 
			sqlj.setArray(sToCompanyName); 
			sqlj.setArray(sToPersonName); 
			sqlj.setArray(sStatus); 
			sqlj.insertData("email_i1");
		
			sqlj.close();
			succes = true;
		}catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".sendContLMail()] :" + e.toString());
		}
		
		return succes;
		
	}	
	
	/****************************************
	 * 전자계약서 전자서명 확인/서명 요청 메일(물류)
	 *
	 * @param mailType 메일 종류 (1:확인요청, 2:서명요청, 3:검토요청)
	 * @param cont_no 계약번호
	 * @param cont_chasu 계약차수
	 * @param member_no 받을업체 회원번호
	 * @return 100 : 전송할 데이터가 TCL_CUST 테이블에 존재하지 않는 경우
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 */
	public boolean sendContLNoti(int mailType, String cont_no, String cont_chasu, String member_no)
	{
		boolean succes = false;
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();

		String sFromCompanyName = "";
		String sToPersonName = "";
		String sToEmail = "";
		String sContName = "";
		String sContDay = "";	
		int	nCustCnt = 0;
		
		String sTitle = "";
		String sPostPosition = "이"; // 조사

		try {		
			sqlj = new SQLJob("lct_email.xml", true);
			
			if(mailType == 1) // 확인요청
			{
				sTitle = "확인";
				sqlj.setParam("cont_no", cont_no);
				sqlj.setParam("cont_chasu", cont_chasu);
				ds = sqlj.getOneRow("email_confirm_user");

				if(ds.size() < 1)
				{
					System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ", member_no : "+ member_no +")");
					sqlj.close();
					return false;
				}
				
				sToPersonName = ds.getString("user_name");
				sToEmail = ds.getString("email");
				sContName = ds.getString("cont_name");
				sContDay = ds.getString("cont_date");				
				
			} else if(mailType == 2) {// 서명요청
				sTitle = "서명";
				sqlj.setParam("cont_no", cont_no);
				sqlj.setParam("cont_chasu", cont_chasu);
				sqlj.setParam("member_no", member_no);
				ds = sqlj.getOneRow("email_sign_user");

				if(ds.size() < 1)
				{
					System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ", member_no : "+ member_no +")");
					sqlj.close();
					return false;
				}
				
				sToPersonName = ds.getString("user_name");
				sToEmail = ds.getString("email");
				sContName = ds.getString("cont_name");
				sContDay = ds.getString("cont_date");				
			} else if(mailType == 3) {// 검토요청
				sTitle = "검토";
				sPostPosition = "가";
				sqlj.setParam("cont_no", cont_no);
				sqlj.setParam("cont_chasu", cont_chasu);
				ds = sqlj.getOneRow("email_review_user");

				if(ds.size() < 1)
				{
					System.out.println("검토자(관리자)가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ")");
					sqlj.close();
					return false;
				}
				
				sToPersonName = ds.getString("user_name");
				sToEmail = ds.getString("email");
				sContName = ds.getString("cont_name");
				sContDay = ds.getString("cont_date");				
			}
			
			sqlj.removeArray();
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			ds1 = sqlj.getOneRow("email_cust_info");

			sFromCompanyName = ds1.getString("member_name");
			nCustCnt = ds1.getInt("cust_cnt");
			
			if(nCustCnt > 1)
				sFromCompanyName += "외 " + (nCustCnt-1) + "명";
			
			String _sUrl = "http://logis.nicedocu.com";
			String _sImg = _sUrl + "/images/email/20110620/";
			
			String _sEmailRet = "";
			_sEmailRet = _sUrl;
			
			String html = "";
			html+="	<html>																																		";
			html+="	<head>                                                                                                                                      ";
			html+="	<title>전자계약 "+sTitle+" 요청</title>                                                                                                         ";
			html+="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
			html+="	<style type=\"text/css\">                                                                                                                   ";
			html+="	<!--                                                                                                                                        ";
			html+="	td {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; line-height: normal; color: #5B5B5B}       ";
			html+="	.b {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; font-weight: bold; color: #3662B8}         ";
			html+="	-->                                                                                                                                         ";
			html+="	</style>                                                                                                                                    ";
			html+="	</head>                                                                                                                                     ";
		    html+="                                                                                                                                             ";
			html+="	<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">                           ";
			html+="	<table width=\"700\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td ><img src=\""+_sImg+"mail_top.gif\" width=\"700\" height=\"119\"></td>                                                              ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td  height=\"50\">&nbsp;</td>                                                                                                          ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td align=\"right\">                                                                                                                    ";
			html+="	      <table width=\"100%\" border=\"0\" cellspacing=\"5\" cellpadding=\"15\" bgcolor=\"90AAC7\">                                           ";
			html+="	        <tr>                                                                                                                                ";
			html+="	          <td bgcolor=\"#FFFFFF\" align=\"center\"><br>                                                                                     ";
			html+="	            <img src=\""+_sImg+"sub_title3.gif\" width=\"104\" height=\"19\"><br>                                                ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"1\" cellpadding=\"10\" bgcolor=\"B5C6D9\">                                      ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td bgcolor=\"#fafafa\">                                                                                                    ";
			html+="	                  <table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"3\">                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"20%\" align=\"center\"><b>계약자명</b></td>                                                                 ";
			html+="	                      <td>: "+sFromCompanyName+"<br/></td>                                                                       ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>계약명</b></td>                                                                               ";
			html+="	                      <td>: "+sContName+"<br/></td>                                                                          ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>계약일</b></td>                                                                               ";
			html+="	                      <td>: "+sContDay+"<br/></td>                                                                            ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                  </table>                                                                                                                  ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                                                         ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td><span class=\"b\">"+sToPersonName+"</span>                                                                              ";
			html+="	                  님 상기 전자계약건에 대해 계약서 "+ sTitle + sPostPosition+" 필요합니다.                                                  ";
			html+="	                  <p>아래 '상세보기' 버튼을 클릭하여 확인 하시기 바랍니다.<br>                                                              ";
			html+="	                  </p>                                                                                                                      ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <a href=\""+_sEmailRet+"\" target=\"_blank\"><img src=\""+_sImg+"btn_detail.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";
			html+="	          </td>                                                                                                                             ";
			html+="	        </tr>                                                                                                                               ";
			html+="	      </table>                                                                                                                              ";
			html+="	    </td>                                                                                                                                   ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td><img src=\""+_sImg+"copyright.gif\" width=\"700\" height=\"120\"></td>                                                             ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	</table>                                                                                                                                    ";
			html+="	</body>                                                                                                                                     ";
			html+="	</html>";

			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;
			String[] strBcc= null;
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strFromName = "나이스다큐(물류)";
			String strSubject = sToPersonName + "님 ["+sContName+"-"+sFromCompanyName+"] 전자계약서에 ["+sTitle+"] 처리 하시기 바랍니다.";
			String attchFile= "";
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, strFromName, strSubject, html, attchFile);
			System.out.println("물류 전자계약 "+sTitle+" 요청 메일 전송 결과 : " + strRtn[0]);
		
			sqlj.close();
			succes = true;
		}catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".sendContLNoti()] :" + e.toString());
		}
		
		return succes;
		
	}	
	
	
	
	/****************************************
	 * 전자계약서 확인요청  메일 전송
	 *
	 * @param sFromCompanyName 전송업체명
	 * @param sToCompanyName 받는업체명  
	 * @param sToPersonName 받는업체 담담자명
	 * @param sToPersonEmail 받는업체 담당자 이메일
	 * @return 
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 *         400 : 이메일 전송 에러
	 */
	public int sendContMail(String sFromCompanyName, String sToCompanyName, String sToPersonName, String sToPersonEmail)
	{
		int sReturn = 500;
		
		try {		
			
			String _sUrl = Startup.conf.getString("domain");
			String _sImg = _sUrl + "/images/email/20100403/";
			String _sEmailRet = _sUrl+"/web/supplier/sindex.jsp";
			
			
			String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
				+"      <tr>"
				+"        <td align='center'><p><strong>" + sFromCompanyName + "</strong> 님이 <strong>" + sToCompanyName + "</strong> 님께 <br />"
				+"          전자계약서 확인 요청 하였습니다.</p>"
				+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“확인하기” </span>버튼을 눌러 계약서를 검토하시기 바랍니다.<br />"
				+"              <br />"
				+"          </p></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td align='center'><a href='"+_sEmailRet +"'><img src='"+ _sImg + "btn_view3.gif' border='0'/></a><br />"
				+"          <br /></td>"
				+"      </tr>"
				+"      </table>"
				+"    </td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"  	  <tr>"
				+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
				+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"  		</td>"
				+"  		<td width='10'></td>"
				+"  	  </tr>"
				+"  	</table>"
				+"    </td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";  		

		
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToPersonEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자계약서를 확인 요청 하였습니다.";
			String attchFile= "";
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
			System.out.println("메일 전송 결과 : " + strRtn[0]);
	
			if(strRtn[0].equals("ok"))
				sReturn = 200;  //성공 
			else
				sReturn = 400;  //실패
			
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
			return 500;
		}
		return sReturn;		
	}	
	
	/****************************************
	 * 전자계약서 전자서명 요청 메일 전송
	 *
	 * @param cont_no 계약번호
	 * @param cont_chasu 계약차수
	 * @param cust_vendcd 받는업체 사업자번호
	 * @param sSendName 전송업체명
	 * @param sRecvName 받는업체 담당자명(재전송시 사용, 일반전송시 "")
	 * @param sRecvEmail 받는업체 담당자 이메일(재전송시 사용, 일반전송시 "")
	 * @return 100 : 전송할 데이터가 TCO_CUST 테이블에 존재하지 않는 경우
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 */
	public int sendContMail(String cont_no, String cont_chasu, String cust_vendcd, String sSendName, String sRecvName, String sRecvEmail)
	{
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();

		try {		
			sqlj = new SQLJob("sct1023.xml", true);
			
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("cust_vendcd", cust_vendcd);
			ds = sqlj.getOneRow("email_s1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(cont_no : " + cont_no + ", cont_chasu : "+ cont_chasu + ", cust_vendcd : "+ cust_vendcd +")");
				sqlj.close();
				return 100;
			}
			
			String sFromCompanyName = "";
			String sToCompanyName = "";
			String sToPersonName = "";
			String sToEmail = "";
			String sEmailRandom = "";

			sFromCompanyName = sSendName;
			sToCompanyName = ds.getString("CUST_NAME");

			if(!sRecvName.equals("") && !sRecvEmail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = sRecvName;
				sToEmail = sRecvEmail;
				sEmailRandom = ds.getString("EMAIL_RANDOM");
			}			
			else
			{
				sToPersonName = ds.getString("PER_NAME");
				sToEmail = ds.getString("PER_EMAIL");
				RandomString rndStr = new RandomString();
				sEmailRandom = rndStr.getString(30,"");  // 새로 보내는 경우는 램덤 문자열 생성 후 저장
				
				sqlj.removeArray();
				sqlj.setArray(sEmailRandom);
				sqlj.setArray(cont_no);
				sqlj.setArray(cont_chasu);
				sqlj.setArray(cust_vendcd);
				sqlj.updateData("email_u1");
			}
			
			sqlj.removeArray();
			sqlj.setParam("cont_no", cont_no);
			sqlj.setParam("cont_chasu", cont_chasu);
			sqlj.setParam("cust_vendcd", cust_vendcd);
			ds1 = sqlj.getOneRow("email_s2");
			String sEmailSeq = ds1.getString("nextSeq");		
			
			String _sUrl = Startup.conf.getString("domain");
			String _sImg = _sUrl + "/images/email/20100403/";
			String _sEmailChk = _sUrl + "/web/supplier/common/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&vendcd="+cust_vendcd+"&num="+sEmailSeq;
			String _sEmailRet = _sUrl + "/web/supplier/contract/sct3010m.jsp?rs="+ sEmailRandom;
			
			
			String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
				+"      <tr>"
				+"        <td align='center'><p><strong>" + sFromCompanyName + "</strong> 님이 <strong>" + sToCompanyName + "</strong> 님께 <br />"
				+"          전자계약서 전자서명을 요청 하였습니다.</p>"
				+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“전자서명하기” </span>버튼을 눌러 확인 하시기 바랍니다.<br />"
				+"              <br />"
				+"          </p></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td align='center'><a href='"+_sEmailRet +"'><img src='"+ _sImg + "btn_view2.gif' width='128' height='38' border='0'/></a><br />"
				+"          <br /></td>"
				+"      </tr>"
				+"      </table>"
				+"      <table border='0'><tr><td height='20'><img src='"+ _sEmailChk +"' width='0' height='0'></td></tr></table>"
				+"    </td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"  	  <tr>"
				+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
				+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"  		</td>"
				+"  		<td width='10'></td>"
				+"  	  </tr>"
				+"  	</table>"
				+"    </td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";  		

		
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자계약서 전자서명을 요청하였습니다.";
			String attchFile= "";
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
			System.out.println("메일 전송 결과 : " + strRtn[0]);
	
			String sStatus = "";
			if(strRtn[0].equals("ok"))
				sStatus = "01";  //성공 
			else
				sStatus = "02";  // 실패
	
			sqlj.removeArray();
			sqlj.setArray(cont_no);
			sqlj.setArray(cont_chasu);
			sqlj.setArray(cust_vendcd);
			sqlj.setArray(sEmailSeq); 
			sqlj.setArray(sToEmail); 
			sqlj.setArray(sToCompanyName); 
			sqlj.setArray(sToPersonName); 
			sqlj.setArray(sStatus); 
			sqlj.insertData("email_i1");
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
			return 500;
		}
		return 200;		
	}

	
	/****************************************
	 * 전자문서 전자서명 요청 메일 전송
	 *
	 * @param docu_no 문서번호
	 * @param supp_vendcd 받는업체 사업자번호
	 * @param sSendName 전송업체명
	 * @param sRecvName 받는업체 담당자명(재전송시 사용, 일반전송시 "")
	 * @param sRecvEmail 받는업체 담당자 이메일(재전송시 사용, 일반전송시 "")
	 * @return 100 : 전송할 데이터가 ELE_DOCU 테이블에 존재하지 않는 경우
	 *         500 : 이메일 전송 시스템 에러
	 *         200 : 이메일 전송 성공
	 */
	public int sendElecMail(String docu_no, String supp_vendcd, String sSendName, String sRecvName, String sRecvEmail)
	{
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();

		try {		
			sqlj = new SQLJob("email.xml", true);
			
			sqlj.setParam("docu_no", docu_no);
			sqlj.setParam("supp_vendcd", supp_vendcd);
			ds = sqlj.getOneRow("email_es1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(docu_no : " + docu_no + ", supp_vendcd : "+ supp_vendcd +")");
				sqlj.close();
				return 100;
			}
			
			String sFromCompanyName = "";
			String sToCompanyName = "";
			String sToPersonName = "";
			String sToEmail = "";
			String sEmailRandom = "";

			sFromCompanyName = sSendName;
			sToCompanyName = ds.getString("SUPP_VENDNM");

			if(!sRecvName.equals("") && !sRecvEmail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = sRecvName;
				sToEmail = sRecvEmail;
				sEmailRandom = ds.getString("EMAIL_RANDOM");
			}			
			else
			{
				sToPersonName = ds.getString("PER_NAME");
				sToEmail = ds.getString("PER_EMAIL");
				RandomString rndStr = new RandomString();
				sEmailRandom = rndStr.getString(30,"");  // 새로 보내는 경우는 램덤 문자열 생성 후 저장
				
				sqlj.removeArray();
				sqlj.setArray(sEmailRandom);
				sqlj.setArray(docu_no);
				sqlj.setArray(supp_vendcd);
				sqlj.updateData("email_eu1");
			}
			
			//sToEmail = "yisu_park@hotmail.com";
			
			String _sUrl = Startup.conf.getString("domain");
			String _sImg = _sUrl + "/images/email/20100403/";
			String _sEmailChk = _sUrl + "/web/supplier/common/emailReadCheckE.jsp?docu_no="+docu_no+"&vendcd="+supp_vendcd;
			String _sEmailRet = _sUrl + "/web/supplier/elec_docu/elc_email_viewer.jsp?rs="+ sEmailRandom;
			
			String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
				+"      <tr>"
				+"        <td align='center'><p><strong>" + sFromCompanyName + "</strong> 님이 <strong>" + sToCompanyName + "</strong> 님께 <br />"
				+"          전자문서 전자서명을 요청 하였습니다.</p>"
				+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“전자서명하기” </span>버튼을 눌러 확인 하시기 바랍니다.<br />"
				+"              <br />"
				+"          </p></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td align='center'><a href='"+_sEmailRet +"'><img src='"+ _sImg + "btn_view2.gif' width='128' height='38' border='0'/></a><br />"
				+"          <br /></td>"
				+"      </tr>"
				+"      </table>"
				+"      <table border='0'><tr><td height='20'><img src='"+ _sEmailChk +"' width='0' height='0'></td></tr></table>"
				+"    </td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"  	  <tr>"
				+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
				+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"  		</td>"
				+"  		<td width='10'></td>"
				+"  	  </tr>"
				+"  	</table>"
				+"    </td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";  		

		
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자문서 서명을 요청하였습니다.";
			//String strSubject = "전자문서 TEST";
			String attchFile= "";
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
			System.out.println("메일 전송 결과 : " + strRtn[0]);
	
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
			return 500;
		}
		return 200;		
	}	
	
	
	public int sendMail(String issueNum, String attachMode, String recvName, String recvMail)
	{
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();
		ResultSetValue rs = new ResultSetValue();
		String sItems = "";

		try {
			sqlj = new SQLJob("email.xml", true);
			
			sqlj.setParam("issuenum", issueNum); 
			ds = sqlj.getOneRow("email_s1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(issuenum : " + issueNum + ")");
				sqlj.close();
				return 100;
			}
			
			sqlj.removeArray();
			sqlj.setParam("issuenum", issueNum); 
			rs = sqlj.getRows("email_s2");
			while(rs.next())
			{
				sItems += rs.getString("itemnm") + ",";
			}
			if(sItems.length() > 0)
				sItems = sItems.substring(0,sItems.length()-1);
			
			
			String billTypeCd = ds.getString("BILLTYPECD");  // 계산서종류코드(01:세금계산서,02:수정세금계산서,03:계산서,04:수정계산서)
			String issueDivCD = ds.getString("ISSUEDIVCD");  // 정발행, 역발행
			String sFromName = "";
			String sToName = "";
			String sToEmail = "";
			String sToVendCD = "";
			String sIssueDivStr1 = "";  // (정)발행, (역)발행
			String sIssueDivStr2 = "";  // 승인, 서명
			String sEmailSeq = "";
			String sToPersonName = "";
			
			//정발행(IssueDivCD = 01)이면 공급받는자가 봐야하고
			//역발행(IssueDivCD = 02)이면 공급자가 봐야 한다.
			String viewUser = "";  // 공급자가 볼 경우:01, 공급받는자가 볼 경우:02
			if(issueDivCD.equals("01"))
			{
				viewUser = "02";
				sFromName = ds.getString("SUPP_VENDNM");
				sToName = ds.getString("RECV_VENDNM");
				sToPersonName = ds.getString("RECV_PERSONNM");
				sToEmail = ds.getString("RECV_EMAIL");
				sToVendCD = ds.getString("RECV_VENDCD");
				sIssueDivStr1 = "(정)발행";
				sIssueDivStr2 = "승인";
			}
			else
			{
				viewUser = "01";
				sFromName = ds.getString("RECV_VENDNM");
				sToName = ds.getString("SUPP_VENDNM");
				sToPersonName = ds.getString("SUPP_PERSONNM");
				sToEmail = ds.getString("SUPP_EMAIL");
				sToVendCD = ds.getString("SUPP_VENDCD");
				sIssueDivStr1 = "(역)발행";
				sIssueDivStr2 = "서명";
			}

			sqlj.removeArray();
			sqlj.setParam("issuenum", issueNum); 
			ds1 = sqlj.getOneRow("email_s3");
			sEmailSeq = ds1.getString("nextSeq");
			
			String _sUrl = "http://www.nicedocu.com";
			String _sImg = _sUrl + "/images/email/20100403/";
			String _sEmailChk = _sUrl + "/web/supplier/tax/stx1064a.jsp?mailId="+issueNum+"&num="+sEmailSeq;
			
			String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
				+"      <tr>"
				+"        <td align='center'><p><strong>" + sFromName + "</strong> 님이 <strong>" + sToName + "</strong> 님께 <br />"
				+"          세금계산서 " + sIssueDivStr2 + "을 요청 하였습니다.</p>"
				+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“세금계산서 보기” </span>버튼을 눌러 확인 하시기 바랍니다.<br />"
				+"              <br />"
				+"          </p></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td align='center'><a href='"+_sUrl+"/web/supplier/tax/stx1063m.jsp?rs="+ ds.getString("TEMPPW") +"'><img src='"+ _sImg + "btn_view.gif' width='128' height='38' border='0'/></a><br />"
				+"          <br /></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td><img src='"+ _sImg + "dot.gif'/></td>"
				+"      </tr>"
				+"    </table>"
				+"        <br />"
				+"        <table width='600' height='31' border='0' cellpadding='0' cellspacing='0'>"
				+"        <tr>"
				+"          <td width='15'>&nbsp;</td>"
				+"          <td width='151'><img src='"+ _sImg + "tab1.gif'/></td>"
				+"          <td>&nbsp;</td>"
				+"        </tr>"
				+"      </table>"
				+"      <table width='600' border='0' cellspacing='2' cellpadding='7' bgcolor='#13A8C8'>"
				+"        <tr>"
				+"          <td bgcolor='#FFFFFF'><table width='100%' border='0' cellspacing='1' cellpadding='2' bgcolor='#FFFFFF'>"
				+"              <tr>"
				+"                <td width='27%' align='center' bgcolor='#DFF7F9'>상호</td>"
				+"                <td width='73%' align='left'>"+ ds.getString("SUPP_VENDNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>담당자</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_PERSONNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>연락처</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_HP") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>이메일</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_EMAIL") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>금액</td>"
				+"                <td align='left'>"+ NumUtil.sAddComma(StringManager.doubleToIntString(Double.parseDouble(ds.getString("TOTALAMOUNT"))), true) +" 원</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>품목</td>"
				+"                <td align='left'>"+ sItems +"</td>"
				+"              </tr>"
				+"          </table></td>"
				+"        </tr>"
				+"      </table>"
				+"      <br />"
				+"      <table width='600' height='31' border='0' cellpadding='0' cellspacing='0'>"
				+"        <tr>"
				+"          <td width='15'>&nbsp;</td>"
				+"          <td width='151'><img src='"+ _sImg + "tab2.gif'/></td>"
				+"          <td>&nbsp;</td>"
				+"        </tr>"
				+"      </table>"
				+"      <table width='600' border='0' cellspacing='2' cellpadding='7' bgcolor='#2990DD'>"
				+"        <tr>"
				+"          <td bgcolor='#FFFFFF'><table width='100%' border='0' cellspacing='1' cellpadding='2' bgcolor='#FFFFFF'>"
				+"              <tr>"
				+"                <td width='27%' align='center' bgcolor='#DFECF9'>상호</td>"
				+"                <td width='73%' align='left'>"+ ds.getString("RECV_VENDNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>담당자</td>"
				+"                <td align='left'>"+ ds.getString("RECV_PERSONNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>연락처</td>"
				+"                <td align='left'>"+ ds.getString("RECV_HP") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>이메일</td>"
				+"                <td align='left'>"+ ds.getString("RECV_EMAIL") +"</td>"
				+"              </tr>"
				+"          </table></td>"
				+"        </tr>"
				+"      </table>"
				+"      <table border='0'><tr><td height='20'><img src='"+ _sEmailChk +"' width='0' height='0'></td></tr></table>"
				+"    </td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"  	  <tr>"
				+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
				+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"  		</td>"
				+"  		<td width='10'></td>"
				+"  	  </tr>"
				+"  	</table>"
				+"    </td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";  
			
			//out.print(strContents);
			if(!recvName.equals("") && !recvMail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = recvName;
				sToEmail = recvMail; 
			}
			
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = sFromName + "님이 " + sToName + "님에게 전자세금계산서를 "+sIssueDivStr1+"하였습니다.";
			String attchFile= "";
			if(attachMode != null && attachMode.length() > 0){
				if(attachMode.equals("taxXml")){
					
					String sFilePath = StrUtil.getTaxIssueNumParent(issueNum)+issueNum + "/";
					String sFileName = issueNum + ".xml";
					attchFile = Startup.conf.getString("file.path.tax") +  sFilePath + sFileName;
					
					System.out.println("MailManager xml 파일첨부:" + attchFile);
				}
			}
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
			System.out.println("메일 전송 결과 : " + strRtn[0]);

			String sStatus = "";
			if(strRtn[0].equals("ok"))
				sStatus = "01";  //성공 
			else
				sStatus = "02";  // 실패

			sqlj.removeArray();
			sqlj.setArray(issueNum); 
			sqlj.setArray(sEmailSeq); 
			sqlj.setArray(sToEmail); 
			sqlj.setArray(sToPersonName); 
			sqlj.setArray(sStatus); 
			sqlj.insertData("email_i1");
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
			return 500;
		}
		return 200;
	}	


	public int sendTaxMail(String issueNum, String attachMode, String recvName, String recvMail)
	{
		SQLJob sqlj = null;

		DataSetValue ds = new DataSetValue();
		DataSetValue ds1 = new DataSetValue();
		ResultSetValue rs = new ResultSetValue();
		String sItems = "";

		try {
			sqlj = new SQLJob("email.xml", true);
			
			sqlj.setParam("issuenum", issueNum); 
			ds = sqlj.getOneRow("email_s1");
			
			if(ds.size() < 1)
			{
				System.out.println("데이터가 존재하지 않아 이메일을 전송할 수 없습니다.(issuenum : " + issueNum + ")");
				sqlj.close();
				return 100;
			}
			
			sqlj.removeArray();
			sqlj.setParam("issuenum", issueNum); 
			rs = sqlj.getRows("email_s2");
			while(rs.next())
			{
				sItems += rs.getString("itemnm") + ",";
			}
			if(sItems.length() > 0)
				sItems = sItems.substring(0,sItems.length()-1);
			
			
			String billTypeCd = ds.getString("BILLTYPECD");  // 계산서종류코드(01:세금계산서,02:수정세금계산서,03:계산서,04:수정계산서)
			String issueDivCD = ds.getString("ISSUEDIVCD");  // 정발행, 역발행
			String sFromName = "";
			String sToName = "";
			String sToEmail = "";
			String sToVendCD = "";
			String sIssueDivStr1 = "";  // (정)발행, (역)발행
			String sIssueDivStr2 = "";  // 승인, 서명
			String sEmailSeq = "";
			String sToPersonName = "";
			
			sFromName = ds.getString("SUPP_VENDNM");
			sToName = ds.getString("RECV_VENDNM");
			sToPersonName = ds.getString("RECV_PERSONNM");
			sToEmail = ds.getString("RECV_EMAIL");
			sToVendCD = ds.getString("RECV_VENDCD");
			sIssueDivStr1 = "발행";

			sqlj.removeArray();
			sqlj.setParam("issuenum", issueNum); 
			ds1 = sqlj.getOneRow("email_s3");
			sEmailSeq = ds1.getString("nextSeq");
			
			String _sUrl = "http://www.nicedocu.com";
			String _sImg = _sUrl + "/images/email/20100403/";
			String _sEmailChk = _sUrl + "/web/supplier/tax/stx1064a.jsp?mailId="+issueNum+"&num="+sEmailSeq;
			
			String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
				+"      <tr>"
				+"        <td align='center'><p><strong>" + sFromName + "</strong> 님이 <strong>" + sToName + "</strong> 님께 <br />"
				+"          세금계산서를 발행 하였습니다.</p>"
				+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“세금계산서 보기” </span>버튼을 눌러 확인 하시기 바랍니다.<br />"
				+"              <br />"
				+"          </p></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td align='center'><a href='"+_sUrl+"/web/supplier/tax/stx10631m.jsp?rs="+ ds.getString("TEMPPW") +"'><img src='"+ _sImg + "btn_view.gif' width='128' height='38' border='0'/></a><br />"
				+"          <br /></td>"
				+"      </tr>"
				+"      <tr>"
				+"        <td><img src='"+ _sImg + "dot.gif'/></td>"
				+"      </tr>"
				+"    </table>"
				+"        <br />"
				+"        <table width='600' height='31' border='0' cellpadding='0' cellspacing='0'>"
				+"        <tr>"
				+"          <td width='15'>&nbsp;</td>"
				+"          <td width='151'><img src='"+ _sImg + "tab1.gif'/></td>"
				+"          <td>&nbsp;</td>"
				+"        </tr>"
				+"      </table>"
				+"      <table width='600' border='0' cellspacing='2' cellpadding='7' bgcolor='#13A8C8'>"
				+"        <tr>"
				+"          <td bgcolor='#FFFFFF'><table width='100%' border='0' cellspacing='1' cellpadding='2' bgcolor='#FFFFFF'>"
				+"              <tr>"
				+"                <td width='27%' align='center' bgcolor='#DFF7F9'>상호</td>"
				+"                <td width='73%' align='left'>"+ ds.getString("SUPP_VENDNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>담당자</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_PERSONNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>연락처</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_HP") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>이메일</td>"
				+"                <td align='left'>"+ ds.getString("SUPP_EMAIL") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>금액</td>"
				+"                <td align='left'>"+ NumUtil.sAddComma(StringManager.doubleToIntString(Double.parseDouble(ds.getString("TOTALAMOUNT"))), true) +" 원</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFF7F9'>품목</td>"
				+"                <td align='left'>"+ sItems +"</td>"
				+"              </tr>"
				+"          </table></td>"
				+"        </tr>"
				+"      </table>"
				+"      <br />"
				+"      <table width='600' height='31' border='0' cellpadding='0' cellspacing='0'>"
				+"        <tr>"
				+"          <td width='15'>&nbsp;</td>"
				+"          <td width='151'><img src='"+ _sImg + "tab2.gif'/></td>"
				+"          <td>&nbsp;</td>"
				+"        </tr>"
				+"      </table>"
				+"      <table width='600' border='0' cellspacing='2' cellpadding='7' bgcolor='#2990DD'>"
				+"        <tr>"
				+"          <td bgcolor='#FFFFFF'><table width='100%' border='0' cellspacing='1' cellpadding='2' bgcolor='#FFFFFF'>"
				+"              <tr>"
				+"                <td width='27%' align='center' bgcolor='#DFECF9'>상호</td>"
				+"                <td width='73%' align='left'>"+ ds.getString("RECV_VENDNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>담당자</td>"
				+"                <td align='left'>"+ ds.getString("RECV_PERSONNM") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>연락처</td>"
				+"                <td align='left'>"+ ds.getString("RECV_HP") +"</td>"
				+"              </tr>"
				+"              <tr>"
				+"                <td align='center' bgcolor='#DFECF9'>이메일</td>"
				+"                <td align='left'>"+ ds.getString("RECV_EMAIL") +"</td>"
				+"              </tr>"
				+"          </table></td>"
				+"        </tr>"
				+"      </table>"
				+"      <table border='0'><tr><td height='20'><img src='"+ _sEmailChk +"' width='0' height='0'></td></tr></table>"
				+"    </td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"  	  <tr>"
				+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
				+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"  		</td>"
				+"  		<td width='10'></td>"
				+"  	  </tr>"
				+"  	</table>"
				+"    </td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";  
			
			//out.print(strContents);
			if(!recvName.equals("") && !recvMail.equals(""))  //받는 사람을 임의로 지정한 경우
			{
				sToPersonName = recvName;
				sToEmail = recvMail; 
			}
			
			String[] strTo = {"\"" + sToPersonName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = sFromName + "님이 " + sToName + "님에게 전자세금계산서를 "+sIssueDivStr1+"하였습니다.";
			String attchFile= "";
			if(attachMode != null && attachMode.length() > 0){
				if(attachMode.equals("taxXml")){
					
					String sFilePath = StrUtil.getTaxIssueNumParent(issueNum)+issueNum + "/";
					String sFileName = issueNum + ".xml";
					attchFile = Startup.conf.getString("file.path.tax") +  sFilePath + sFileName;
					
					System.out.println("MailManager xml 파일첨부:" + attchFile);
				}
			}
			
			String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
			System.out.println("메일 전송 결과 : " + strRtn[0]);

			String sStatus = "";
			if(strRtn[0].equals("ok"))
				sStatus = "01";  //성공 
			else
				sStatus = "02";  // 실패

			sqlj.removeArray();
			sqlj.setArray(issueNum); 
			sqlj.setArray(sEmailSeq); 
			sqlj.setArray(sToEmail); 
			sqlj.setArray(sToPersonName); 
			sqlj.setArray(sStatus); 
			sqlj.insertData("email_i1");
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
			return 500;
		}
		return 200;
	}		
	
	
	
	public int sendIdPw(String id, String vendcd, String name, String email)
	{
		String sType = "";
		String sPrint = "";
		
		if((id.equals("") && vendcd.equals("")) || (!id.equals("") && !vendcd.equals("")))
			return 100;
		
		DataSetValue ds = new DataSetValue();
		try {
			SQLJob sqlj = new SQLJob("email.xml", true);

			if(id.equals(""))
			{
				sType = "id";
				sqlj.setParam("vendcd", vendcd);  
				sqlj.setParam("personnm", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchID");
			}
			else
			{
				sType = "pw";
				sqlj.setParam("userid", id);  
				sqlj.setParam("personnm", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchPW");
			}
			
			if(sType.equals("pw") &&  ds.size() == 1)
			{
				RandomString rndStr = new RandomString();
				sPrint = rndStr.getString(10,"a");
				
				sqlj.removeArray();
				//sqlj.setArray(Security.MD5encrypt(sPrint));         
				sqlj.setArray(Security.SHA256encrypt(sPrint));         
				sqlj.setArray(id);
				sqlj.setArray(name);
				sqlj.setArray(email);
				sqlj.updateData("searchPW");
			}
			else
			{
				sPrint = ds.getString("userid");			
			}
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+"]:" + e.toString());
			return 200;
		} 
		
		if( ds.size() == 1)
		{
			String _sUrl = "http://www.nicedocu.com";
			String sFromName = "나이스다큐";
			String sToName = name;
			String sToEmail = email;
			
			String strContents = "<html>"
			+"<head>"
			+"<title>나이스다큐(NiceDocu)</title>"
			+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
			+"<style>"
			+"table, tr, td, div, INPUT, SELECT, form, Textarea"
			+"{"
			+"	font-size:9pt;"
			+"	font-family:굴림,굴림체;"
			+"	line-height: 120%;"
			+"}"
			+"</style>"
			+"</head>"
			+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
			+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
			+"  <tr>"
			+"    <td><img src='"+ _sUrl + "/images/email/20100403/top.gif' width='700' height='80' /></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sUrl + "/images/email/20100403/bg1.gif'><br/>"
			+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>";
			
			if(sType.equals("id"))
			{
				
			strContents += "      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NiceDocu) 홈페이지의 아이디(ID)를 안내해 드립니다.<br><br>"
			+"		아이디(ID) : <strong>"+sPrint+"</strong> </p>"
			+"        </td>"
			+"      </tr>";
			} else {
			strContents +="      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NiceDocu) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.<br><br>"
			+"		임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
			+"		<p>로그인 후 [내 정보관리]메뉴의 [담당자정보변경]에서 비밀번호를 변경하실 수 있습니다.</p>"
			+"        </td>"
			+"      </tr>";
			}
			strContents +="	</table>"
			+"    <br/><br/></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td>"
			+"		<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
			+"		<tr>"
			+"			<td width='125'><img src='"+ _sUrl + "/images/email/20100403/bottom.gif' height='65' /></td>"
			+"			<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
			+"					Copyright(c) 2010 NICE D&B All Rights Reserved"
			+"			</td>"
			+"			<td width='10'></td>"
			+"		</tr>"
			+"		</table>"
			+"	</td>"
			+"  </tr>"
			+"</table>"
			+"</body>"
			+"</html>";
			
			//out.print(strContents);
			
			String[] strTo = {"\"" + sToName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;//{"drought@dreamwiz.com"};
			String[] strBcc= null;//{"drought@dreamwiz.com"};
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = "["+ sFromName + "] " + sToName + "님이 요청하신 회원 정보입니다.";
			String attchFile= "";
			OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
		}
		else
		{
			return 300;
		}
		
		return 400;
	}		

	/**
	 * 일반기업용 아이디/비밀번호 찾기
	 * @param id 아이디
	 * @param vendcd 사업자번호 또는 주민등록번호
	 * @param name 이름
	 * @param email 이메일
	 * @return 100: 정상적인 입력값이 아닙니다.
	 *         200: 시스템 오류가 발생하였습니다.
	 *         300: 입력하신 사업자번호, 이름, 이메일은\n시스템에 등록된 정보와 일치하지 않습니다.\n\n다시한번 확인하여 주시기 바랍니다.
	 *         400: 정상적인 발송
	 */
	public int sendIdPwB(String id, String vendcd, String name, String email)
	{
		String sType = "";
		String sPrint = "";
		
		if( (id.equals("") && vendcd.equals("")) || name.equals("") || email.equals("") )
			return 100;
		
		DataSetValue ds = new DataSetValue();
		try {
			SQLJob sqlj = new SQLJob("email.xml", true);

			if(!vendcd.equals(""))  // 아이디 찾기
			{
				sType = "id";
				sqlj.setParam("vendcd", vendcd);  
				sqlj.setParam("user_name", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchBID");
			}
			else if(!id.equals(""))	// 비밀번호 찾기
			{
				sType = "pw";
				sqlj.setParam("user_id", id);  
				sqlj.setParam("user_name", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchBPW");
			}
			else
			{
				return 100;
			}
			
			if(sType.equals("pw") &&  ds.size() == 1)
			{
				RandomString rndStr = new RandomString();
				sPrint = rndStr.getString(10,"a");
				
				sqlj.removeArray();
				//sqlj.setArray(Security.MD5encrypt(sPrint));            
				sqlj.setArray(Security.SHA256encrypt(sPrint));            
				sqlj.setArray(id);
				sqlj.updateData("searchBPW");
			}
			else
			{
				sPrint = ds.getString("user_id");			
			}
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+"]:" + e.toString());
			return 200;
		} 
		
		if( ds.size() == 1)
		{
			String _sUrl = "http://www.nicedocu.com";
			String sFromName = "나이스다큐(일반기업용)";
			String sToName = name;
			String sToEmail = email;
			
			String strContents = "<html>"
			+"<head>"
			+"<title>나이스다큐(일반기업용)</title>"
			+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
			+"<style>"
			+"table, tr, td, div, INPUT, SELECT, form, Textarea"
			+"{"
			+"	font-size:9pt;"
			+"	font-family:굴림,굴림체;"
			+"	line-height: 120%;"
			+"}"
			+"</style>"
			+"</head>"
			+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
			+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
			+"  <tr>"
			+"    <td><img src='"+ _sUrl + "/images/email/20100403/top.gif' width='700' height='80' /></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sUrl + "/images/email/20100403/bg1.gif'><br/>"
			+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>";
			
			if(sType.equals("id"))
			{
				
			strContents += "      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NICEDocu) 홈페이지의 아이디(ID)를 안내해 드립니다.<br><br>"
			+"		아이디(ID) : <strong>"+sPrint+"</strong> </p>"
			+"        </td>"
			+"      </tr>";
			} else {
			strContents +="      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NICEDocu) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.<br><br>"
			+"		임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
			+"		<p>로그인 후 [회원정보수정] - [내정보수정]에서 비밀번호를 변경하실 수 있습니다.</p>"
			+"        </td>"
			+"      </tr>";
			}
			strContents +="	</table>"
			+"    <br/><br/></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td>"
			+"		<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
			+"		<tr>"
			+"			<td width='125'><img src='"+ _sUrl + "/images/email/20100403/bottom.gif' height='65' /></td>"
			+"			<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
			+"					Copyright(c) 2010 NICE D&B All Rights Reserved"
			+"			</td>"
			+"			<td width='10'></td>"
			+"		</tr>"
			+"		</table>"
			+"	</td>"
			+"  </tr>"
			+"</table>"
			+"</body>"
			+"</html>";
			
			//out.print(strContents);
			
			String[] strTo = {"\"" + sToName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;
			String[] strBcc= null;
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = "["+ sFromName + "] " + sToName + "님이 요청하신 회원 정보입니다.";
			String attchFile= "";
			OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
		}
		else
		{
			return 300;
		}
		
		return 400;
	}

	
	/**
	 * 프랜차이즈 아이디/비밀번호 찾기
	 * @param id 아이디
	 * @param vendcd 사업자번호 또는 주민등록번호
	 * @param name 이름
	 * @param email 이메일
	 * @return 100: 정상적인 입력값이 아닙니다.
	 *         200: 시스템 오류가 발생하였습니다.
	 *         300: 입력하신 사업자번호, 이름, 이메일은\n시스템에 등록된 정보와 일치하지 않습니다.\n\n다시한번 확인하여 주시기 바랍니다.
	 *         400: 정상적인 발송
	 */
	public int sendIdPwF(String id, String vendcd, String name, String email)
	{
		String sType = "";
		String sPrint = "";
		
		if( (id.equals("") && vendcd.equals("")) || name.equals("") || email.equals("") )
			return 100;
		
		DataSetValue ds = new DataSetValue();
		try {
			SQLJob sqlj = new SQLJob("email.xml", true);

			if(!vendcd.equals(""))  // 아이디 찾기
			{
				sType = "id";
				sqlj.setParam("vendcd", vendcd);  
				sqlj.setParam("user_name", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchFID");
			}
			else if(!id.equals(""))	// 비밀번호 찾기
			{
				sType = "pw";
				sqlj.setParam("user_id", id);  
				sqlj.setParam("user_name", name);  
				sqlj.setParam("email", email);
				ds = sqlj.getOneRow("searchFPW");
			}
			else
			{
				return 100;
			}
			
			if(sType.equals("pw") &&  ds.size() == 1)
			{
				RandomString rndStr = new RandomString();
				sPrint = rndStr.getString(10,"a");
				
				sqlj.removeArray();
				//sqlj.setArray(Security.MD5encrypt(sPrint));            
				sqlj.setArray(Security.SHA256encrypt(sPrint));            
				sqlj.setArray(id);
				sqlj.updateData("searchFPW");
			}
			else
			{
				sPrint = ds.getString("user_id");			
			}
			
			sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+"]:" + e.toString());
			return 200;
		} 
		
		if( ds.size() == 1)
		{
			String _sUrl = "http://www.nicedocu.com";
			String sFromName = "나이스다큐(프랜차이즈)";
			String sToName = name;
			String sToEmail = email;
			
			String strContents = "<html>"
			+"<head>"
			+"<title>나이스다큐(프랜차이즈)</title>"
			+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
			+"<style>"
			+"table, tr, td, div, INPUT, SELECT, form, Textarea"
			+"{"
			+"	font-size:9pt;"
			+"	font-family:굴림,굴림체;"
			+"	line-height: 120%;"
			+"}"
			+"</style>"
			+"</head>"
			+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
			+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
			+"  <tr>"
			+"    <td><img src='"+ _sUrl + "/images/email/20100403/top.gif' width='700' height='80' /></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sUrl + "/images/email/20100403/bg1.gif'><br/>"
			+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>";
			
			if(sType.equals("id"))
			{
				
			strContents += "      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NICEDocu) 홈페이지의 아이디(ID)를 안내해 드립니다.<br><br>"
			+"		아이디(ID) : <strong>"+sPrint+"</strong> </p>"
			+"        </td>"
			+"      </tr>";
			} else {
			strContents +="      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(NICEDocu) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.<br><br>"
			+"		임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
			+"		<p>로그인 후 [회원정보수정] - [내정보수정]에서 비밀번호를 변경하실 수 있습니다.</p>"
			+"        </td>"
			+"      </tr>";
			}
			strContents +="	</table>"
			+"    <br/><br/></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td>"
			+"		<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
			+"		<tr>"
			+"			<td width='125'><img src='"+ _sUrl + "/images/email/20100403/bottom.gif' height='65' /></td>"
			+"			<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
			+"					Copyright(c) 2010 NICE D&B All Rights Reserved"
			+"			</td>"
			+"			<td width='10'></td>"
			+"		</tr>"
			+"		</table>"
			+"	</td>"
			+"  </tr>"
			+"</table>"
			+"</body>"
			+"</html>";
			
			//out.print(strContents);
			
			String[] strTo = {"\"" + sToName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;
			String[] strBcc= null;
			String strFrom = Startup.conf.getString("email.mailFrom");
			String strSubject = "["+ sFromName + "] " + sToName + "님이 요청하신 회원 정보입니다.";
			String attchFile= "";
			OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
		}
		else
		{
			return 300;
		}
		
		return 400;
	}	
	
	/**
	 * 물류 아이디/비밀번호 찾기
	 * @param id 아이디
	 * @param vendcd 사업자번호 또는 주민등록번호
	 * @param name 이름
	 * @param email 이메일
	 * @return 100: 정상적인 입력값이 아닙니다.
	 *         200: 시스템 오류가 발생하였습니다.
	 *         300: 입력하신 사업자번호, 이름, 이메일은\n시스템에 등록된 정보와 일치하지 않습니다.\n\n다시한번 확인하여 주시기 바랍니다.
	 *         400: 정상적인 발송
	 */
	public String sendIdPwL(String id, String vendcd, String name)
	{
		String 	sType 	= 	"";
		String 	sPrint 	= 	"";
		String	sRtnMsg	=	"";
		
		System.out.println("id["+id+"]");
		System.out.println("vendcd["+vendcd+"]");
		System.out.println("name["+name+"]");
		
		DataSetValue ds = new DataSetValue();
		try {
			SQLJob sqlj = new SQLJob("email.xml", true);
			if(id == null || id.length() < 1)	//	아이디찾기
			{
				sType = "id";
				sqlj.setParam("vendcd", vendcd);  
				sqlj.setParam("user_name", name);
				ds = sqlj.getOneRow("searchLID");
				sPrint = ds.getString("user_id");
			}else	//	비밀번호 찾기
			{
				sType = "pw";
				sqlj.setParam("user_id", id);  
				sqlj.setParam("user_name", name);
				ds = sqlj.getOneRow("searchLPW");
				
				if(ds != null && ds.size() > 0)
				{
					RandomString rndStr = new RandomString();
					sPrint = rndStr.getString(10,"a");
					
					sqlj.removeArray();
					//sqlj.setArray(Security.MD5encrypt(sPrint));
					sqlj.setArray(Security.SHA256encrypt(sPrint));					
					sqlj.setArray(id);
					sqlj.updateData("searchLPW");
				}
			}
			sqlj.close();
			
			if(ds == null || ds.size() < 1)	//	데이타가 존재하지 않는 경우
			{
				sRtnMsg	=	"나이스다큐(물류) 회원으로 등록되어 있지 않습니다.\\n\\n다시한번 입력값을 확인하시기 바랍니다.";
			}else
			{
				String _sUrl = "http://logis.nicedocu.com";
				String sFromName = "나이스다큐";
				String sToName = name;
				String sToEmail = ds.getString("email");
				
				String strContents = "<html>"
				+"<head>"
				+"<title>나이스다큐(NiceDocu)</title>"
				+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
				+"<style>"
				+"table, tr, td, div, INPUT, SELECT, form, Textarea"
				+"{"
				+"	font-size:9pt;"
				+"	font-family:굴림,굴림체;"
				+"	line-height: 120%;"
				+"}"
				+"</style>"
				+"</head>"
				+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
				+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
				+"  <tr>"
				+"    <td><img src='"+ _sUrl + "/images/email/20100403/top.gif' width='700' height='80' /></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sUrl + "/images/email/20100403/bg1.gif'><br/>"
				+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>";
				
				if(sType.equals("id"))	//	ID 찾기 메일 내용
				{
					strContents += "      <tr>"
					+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(물류) 홈페이지의 아이디(ID)를 안내해 드립니다.<br><br>"
					+"		아이디(ID) : <strong>"+sPrint+"</strong> </p>"
					+"        </td>"
					+"      </tr>";
				} else 	//	비밀번호 찾기 메일 내용
				{
					strContents +="      <tr>"
					+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 나이스다큐(물류) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.<br><br>"
					+"		임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
					+"		<p>로그인 후 [회원정보수정]메뉴의 [담당자정보변경]에서 비밀번호를 변경하실 수 있습니다.</p>"
					+"        </td>"
					+"      </tr>";
				}
				strContents +="	</table>"
				+"    <br/><br/></td>"
				+"  </tr>"
				+"  <tr>"
				+"    <td>"
				+"		<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
				+"		<tr>"
				+"			<td width='125'><img src='"+ _sUrl + "/images/email/20100403/bottom.gif' height='65' /></td>"
				+"			<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
				+"					Copyright(c) 2010 NICE D&B All Rights Reserved"
				+"			</td>"
				+"			<td width='10'></td>"
				+"		</tr>"
				+"		</table>"
				+"	</td>"
				+"  </tr>"
				+"</table>"
				+"</body>"
				+"</html>";
				
				//out.print(strContents);
				
				String[] strTo = {"\"" + sToName + "\" <"+ sToEmail + ">"};
				String[] strCc= null;//{"drought@dreamwiz.com"};
				String[] strBcc= null;//{"drought@dreamwiz.com"};
				String strFrom = Startup.conf.getString("email.mailFrom");
				String strSubject = "["+ sFromName + "] " + sToName + "님이 요청하신 회원 정보입니다.";
				String attchFile= "";
				OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
				
				sRtnMsg	=	"["+sToName+"]님의 메일["+sToEmail+"]로 요청하신 회원정보를 전송하였습니다";
			}
		} catch (Exception e) {
		
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+"]:" + e.toString());
			sRtnMsg	=	"시스템 오류가 발생하였습니다.\\n고객센터(02-788-9097)에 문의하세요.";
		}
		
		return sRtnMsg;
	}
	
	
	/**
	 * 아파트 아이디/비밀번호 찾기
	 * @param id 아이디
	 * @param vendcd 사업자번호 또는 주민등록번호
	 * @param name 이름
	 * @param email 이메일
	 * @return 100: 정상적인 입력값이 아닙니다.
	 *         200: 시스템 오류가 발생하였습니다.
	 *         300: 입력하신 사업자번호, 이름, 이메일은\n시스템에 등록된 정보와 일치하지 않습니다.\n\n다시한번 확인하여 주시기 바랍니다.
	 *         400: 정상적인 발송
	 */
	public int sendIdPwA(String id, String vendcd, String name, String email)
	{
		String sType = "";
		String sPrint = "";
		
		if( (id.equals("") && vendcd.equals("")) || name.equals("") || email.equals("") ){
			return 100;
		}
		
		DataSetValue ds = new DataSetValue();
		try {
			//SQLJob sqlj = new SQLJob("email.xml", true);

			if(!vendcd.equals("")){  // 아이디 찾기
				sType = "id";
				//sqlj.setParam("vendcd", vendcd);  
				//sqlj.setParam("user_name", name);  
				//sqlj.setParam("email", email);
				//ds = sqlj.getOneRow("searchAID");
				
				DataObject tca_memberDao = new DataObject("tca_member");
				DataSet tca_member = tca_memberDao.query(
					 " select tp.user_id from tca_member tm inner join tca_person tp on tm.member_no = tp.member_no     "
					+" where tm.vendcd = '"+vendcd+"'    																"
					+" and tp.user_name = '"+name+"' 	 																"
					+" and tp.email = '"+email+"' 			 															"
				);
				
				while(!tca_member.next()){
					return 100;
				}
				ds.put("size", tca_member.size());
				
			}else if(!id.equals("")){	// 비밀번호 찾기
			
				sType = "pw";
				//sqlj.setParam("user_id", id);  
				//sqlj.setParam("user_name", name);  
				//sqlj.setParam("email", email);
				//ds = sqlj.getOneRow("searchAPW");
				DataObject tca_personDao = new DataObject("tca_person");
				DataSet tca_person = tca_personDao.query(
					 " select user_id from tca_person                "
					+" where user_id = '"+id+"'        				 "
					+" and user_name = '"+name+"'       			 "
					+" and email = '"+email+"'  					 "
				);
				while(!tca_person.next()){
					return 100;
				}
				ds.put("size", tca_person.size());
				
			}else{
				return 100;
			}
			
			if(sType.equals("pw") &&  ds.size() == 1){
				RandomString rndStr = new RandomString();
				sPrint = rndStr.getString(10,"a");
				
				//sqlj.removeArray();
				//sqlj.setArray(Security.MD5encrypt(sPrint));            
				//sqlj.setArray(Security.SHA256encrypt(sPrint));            
				//sqlj.setArray(id);
				//sqlj.updateData("searchAPW");
				
				DB db = new DB();
				DataObject tca_personDao = new DataObject("tca_person");
				tca_personDao.item("passwd", Security.SHA256encrypt(sPrint));
				db.setCommand(tca_personDao.getUpdateQuery("user_id='"+id+"'"),tca_personDao.record);
				if(!db.executeArray()){
					return 200;
				}
			}
			else
			{
				sPrint = ds.getString("user_id");			
			}
			
			//sqlj.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass()+"]:" + e.toString());
			return 200;
		} 
		
		if( ds.size() == 1){
			
/*			String _sUrl = "http://www.niceaptbid.com";
			String sFromName = "아파트 전자 입찰";
			String sToName = name;
			String sToEmail = email;
			
			String strContents = "<html>"
			+"<head>"
			+"<title>아파트 전자 입찰</title>"
			+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=euc-kr\">"
			+"<style>"
			+"table, tr, td, div, INPUT, SELECT, form, Textarea"
			+"{"
			+"	font-size:9pt;"
			+"	font-family:굴림,굴림체;"
			+"	line-height: 120%;"
			+"}"
			+"</style>"
			+"</head>"
			+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
			+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
			+"  <tr>"
			+"    <td><img src='"+ _sUrl + "/images/email/20100403/top.gif' width='700' height='80' /></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sUrl + "/images/email/20100403/bg1.gif'><br/>"
			+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>";
			
			if(sType.equals("id"))
			{
				
			strContents += "      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 아파트 전자 입찰(niceaptbid) 홈페이지의 아이디(ID)를 안내해 드립니다.<br><br>"
			+"		아이디(ID) : <strong>"+sPrint+"</strong> </p>"
			+"        </td>"
			+"      </tr>";
			} else {
			strContents +="      <tr>"
			+"        <td align='center'><p><strong>"+name+"</strong> 님 안녕하세요?<br>요청하신 아파트 전자 입찰(niceaptbid) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.<br><br>"
			+"		임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
			+"		<p>로그인 후 [정보관리] - [기본정보관리]에서 비밀번호를 변경하실 수 있습니다.</p>"
			+"        </td>"
			+"      </tr>";
			}
			strContents +="	</table>"
			+"    <br/><br/></td>"
			+"  </tr>"
			+"  <tr>"
			+"    <td>"
			+"		<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
			+"		<tr>"
			+"			<td width='125'><img src='"+ _sUrl + "/images/email/20100403/bottom.gif' height='65' /></td>"
			+"			<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
			+"					Copyright(c) 2010 NICE D&B All Rights Reserved"
			+"			</td>"
			+"			<td width='10'></td>"
			+"		</tr>"
			+"		</table>"
			+"	</td>"
			+"  </tr>"
			+"</table>"
			+"</body>"
			+"</html>";*/
			
			String _sUrl = "http://www.niceaptbid.com";
			String sFromName = "아파트 전자 입찰";
			String sToName = name;
			String sToEmail = email;
			
			String strContents = "<!doctype html>"
			+"<html lang=\"ko\">																								"
			+"<head>																											"
			+"<meta charset=\"UTF-8\">																							"
			+"<title>NICE ART BID</title>																						"
			+"<meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge,chrome=1\" />												"
			+"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no, target-densityDpi=medium-dpi\" />				"
			+"<style type=\"text/css\">																																							"
			+"html, body, div, span, object, iframe,																			"
			+"h1, h2, h3, h4, h5, h6, p, blockquote, pre,																		"
			+"abbr, address, cite, code,																						"
			+"del, dfn, em, img, ins, kbd, q, samp,																				"
			+"small, strong, var,																								"
			+"b, i,																												"
			+"dl, dt, dd, ol, ul, li,																							"
			+"fieldset, form, label, legend,																					"
			+"table { border: 0px solid #ffffff; }																				"
			+", caption, tbody, tfoot, thead, tr, th, td,																		"
			+"article, aside, canvas, details, figcaption, figure,																"
			+"footer, header, hgroup, menu, nav, section, summary,																"
			+"time, mark, audio, video {margin:0; padding:0; border:0; font-size:100%; font-family:\"맑은 고딕\", \"돋움\", Dotum, AppleSDGothicNeo ,Droid Sans, arial, sans-serif; vertical-align:baseline; background:transparent; list-style:none;}	"
			+"body {line-height:1; -webkit-text-size-adjust:none; font-family:\"맑은 고딕\", \"돋움\", Dotum, AppleSDGothicNeo ,Droid Sans, arial, sans-serif; color:#4d4d4d; font-size:12px;}				"
			+"article, aside, details, figcaption, figure,																		"
			+"footer, header, hgroup, menu, nav, section {display:block;}														"
			+"fieldset, img, abbr, acronym {border:0;}																			"
			+"img {vertical-align:middle;}																						"
			+"	"
			+"#mailForm {width:750px;}	"
			+".m_head {position:relative; height:60px; border-bottom:solid 1px #376092;}	"
			+".m_head h1 {float:left; position:relative; left:10px; top:10px;}	"
			+".m_body {position:relative; margin:10px; padding:0 15px 10px 15px; border:solid 2px #b0cbeb;}	"
			+".m_body h2 {font-size:20px; color:#333; text-align:center; padding:20px 0;}	"
			+".m_content {position:relative; background:#eee; border-bottom:solid 1px #ddd; border-top:solid 1px #ddd; padding:20px; line-height:18px;}	"
			+"</style>"
			+"</head>"
			+"<body>"
			+"<table width=\"750px\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">"
			+"	<colgroup>"
			+"  	<col width=\"50%\">"
			+"  	<col width=\"50%\">"
			+"  </colgroup>"
			+"  <tr>"
			+"  	<td align=\"left\" style=\"height:60px;border-bottom:solid 1px #376092;\">"
			+"  		<h1 style=\"left:10px; top:10px;\"><img src=\"http://www.niceaptbid.com/web/apt/html/images/mail/top_logo.gif\"></h1>"
			+"  	</td>"
			+"  	<td align=\"right\" style=\"height:60px;border-bottom:solid 1px #376092;\">"
			+"  		<img src=\"http://www.niceaptbid.com/web/apt/html/images/mail/mail_top.gif\">"
			+"  	</td>"
			+"  </tr>"
			+"  <tr>"
			+"  	<td colspan=\"2\">"
			+"  		<p style=\"text-align:right; line-height:24px; padding-right:10px; font-size:14px;\"><a href=\"http://www.niceaptbid.com/\">www.niceaptbid.com</a></p>"
			+"    		<div style=\"position:relative; margin:10px; padding:0 15px 10px 15px; border:solid 2px #b0cbeb;\">"
			+"      		<h2 style=\"font-size:20px; color:#333; text-align:center; padding:20px 0;\">임시비밀번호</h2>"
			+"      		<div style=\"position:relative; background:#eee; border-bottom:solid 1px #ddd; border-top:solid 1px #ddd; padding:20px; line-height:18px;\">";
			
			if(sType.equals("id"))
			{
				
			strContents += "      <p>"+name+" 회원님의 <br>요청하신 아파트 전자 입찰(niceaptbid) 홈페이지의 아이디(ID)를 안내해 드립니다.</p>"
			+"        			  <p>아이디(ID) : <strong>"+sPrint+"</strong> </p>"
			+"					  <br>"
			+"      			  <br>";
			} else {
			strContents +="      <p>"+name+" 회원님의 <br>요청하신 아파트 전자 입찰(niceaptbid) 홈페이지의 임시비밀번호(PW)를 안내해 드립니다.</p>"
			+"        			 <p>임시비밀번호(PW) : <strong>"+sPrint+"</strong> </p>"
			+"		             <p>로그인 후 정보관리 페이지에서 비밀번호를 변경해 주시기 바랍니다.</p>"
			+"		             <br>"
			+"		             <p>-비밀번호 변경방법-</p>"
			+"		             <p>홈페이지 접속 -> 로그인(아이디/임시비밀번호 입력) -> 우측 상단 정보관리 클릭</p>"
			+"		             <p>-> 기본정보관리 하단 수정하기 클릭 -> 변경할 비밀번호 설정 및 확인 -> 저장</p>"
			+"					 <br>"
			+"      			 <br>";
			}
			strContents +="	"
			+"          	</div>"
			+"          	<p style=\"text-align:center; margin:20px 0;\"><a href=\"http://www.niceaptbid.com/\"><img src=\"http://www.niceaptbid.com/web/apt/html/images/mail/btn_goHome.gif\" ></a></p>"
			+"          	<div class=\"m_footer\">고객센터 02-788-9029 / 이용시간-평일:09:00~18:00(토.일요일 및 법정공휴일 휴무)</div>"
			+"  		</div>"
			+"    	</td>"
			+"	</tr>"
			+"</table>"
			+"</body>"
			+"</html>";
			
			
			
			String[] strTo = {"\"" + sToName + "\" <"+ sToEmail + ">"};
			String[] strCc= null;
			String[] strBcc= null;
			String strFrom = Startup.conf.getString("email.mailFrom"); //"niceaptbid@nicednb.com";
			String strSubject = "["+ sFromName + "] " + sToName + "님이 요청하신 회원 정보입니다.";
			String attchFile= "";
			
			System.out.print("strTo["+strTo+"]");
			System.out.print("sToName["+sToName+"]");
			System.out.print("sToEmail["+sToEmail+"]");
			System.out.print("strSubject["+strSubject+"]");
			
			
			OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "아파트전자입찰", strSubject, strContents, attchFile);
		}
		else
		{
			return 300;
		}
		
		return 400;
	}
	
	
	
	/**
	 * 메일 전송
	 * @param request			HttpServletRequest
	 * @param sFrom				전송자 이메일 주소
	 * @param sWriter			전송자 명
	 * @param sTo					받는이 이메일 주소
	 * @param sMailTitle	전송 메일 제목
	 * @param sPage				템플릿주소
	 * @param sTitle			메일내용(제목)
	 * @param sContent		메일내용(내용)
	 * @param aSubTitle		메일내용(소제목)
	 * @param aSubContent	메일내용(소제목의 내용)
	 * @return
	 */
	public boolean sendMail(HttpServletRequest request, String sFrom, String sWriter, String sTo, String sMailTitle, String sPage
												  ,String sTitle, String sContent, ArrayList aSubTitle, ArrayList aSubContent)
	{
		boolean	bSend	=	true;
		//try {
			
			//Properties 	pt 				= System.getProperties();
			//String 			sCharSet	=	"";
			//if(pt.getProperty("user.language").equals("en"))	sCharSet	=	"8859_1";
			//else	sCharSet	=	"KSC5601";
			/*String	sHost			=	this.ccf.getString("mail.host");		//	send mail host
			
			String	sParams	=	"";	//	파라메타값
			
			
			System.out.println("sendMail mCompanyType : " + mCompanyType);
			
			
			if(mCompanyType.length() > 0) sParams	+=	"company_type=" + java.net.URLEncoder.encode(this.mCompanyType.toString(),"EUC-KR") + "&";
			
			if(sTitle.length() > 0)	sParams		+=	"title="	+	java.net.URLEncoder.encode(sTitle,"EUC-KR") + "&";
			if(sContent.length() > 0)	sParams	+=	"content="	+	java.net.URLEncoder.encode(sContent,"EUC-KR") + "&";
			
			if(aSubTitle != null)
			{
				for(int i=0; i < aSubTitle.size(); i++)
				{
					sParams		+=	"sub_title="	+	java.net.URLEncoder.encode(aSubTitle.get(i).toString(),"EUC-KR") + "&";
					sParams		+=	"sub_content="	+	java.net.URLEncoder.encode(aSubContent.get(i).toString(),"EUC-KR") + "&";
				}
			}
			
			
			sParams	=	"?" + sParams.substring(0, sParams.length()-1);
			
			String	sCurUrl	=	request.getRequestURL().toString(); // 현재페이지 경로
			sCurUrl	=	sCurUrl.substring(0,sCurUrl.indexOf("/web")) + sPage + sParams; 
			
			//sCurUrl	=	"http://srm.kolon-kesco.com"+ sPage + sParams;
		
			System.out.println("sCurUrl["+sCurUrl+"]");
			
			URL 		url 		= 	new	URL(sCurUrl);
			String	sMailContent	=	this.getHtmlSouce(url);
			
			//Authenticator auth = new PopupAuthenticator();
			
			//System.out.println("sHost["+sHost+"]");
			
			
			/*Properties props = new Properties();
			props.put("mail.transport.protocol", "smtp");
			//props.put("mail.smtp.host", "127.0.0.1");
			props.put("mail.smtp.host", "mail.ilsungconst.co.kr");
			props.put("mail.smtp.port", "25");
			props.put("mail.smtp.auth", "true");
			
			
			
			// 기본 Session을 생성하고 할당합니다.
			Session msgSession = Session.getDefaultInstance(props, auth);*/
			
			/*Properties props = new Properties();
			props.put("mail.smtp.host", "211.41.51.131"); 
			Session msgSession = Session.getDefaultInstance(props, null);
			
			
			MimeMessage		msg		= new MimeMessage(msgSession);

			InternetAddress	from	= new InternetAddress(sFrom,sWriter,"KSC5601");
			
			msg.setFrom(from);

			InternetAddress to = new InternetAddress(sTo);
			msg.setRecipient(Message.RecipientType.TO, to);
			
			System.out.println("sMailTitle["+sMailTitle+"]");

			msg.setSubject(sMailTitle,"KSC5601"); 

			MimeBodyPart	mbpContent	=	new	MimeBodyPart();
			
			mbpContent.setContent(sMailContent, "text/html; charset=EUC-KR");
			
			Multipart	mp	=	new	MimeMultipart();
			mp.addBodyPart(mbpContent);
			/*
			if(hmFileInfo != null)
			{				
				ArrayList		aFileInfo	=	this.getMultipart(hmFileInfo);
				MimeBodyPart	mbpFile		=	null;
				for(int i=0; i < aFileInfo.size(); i++)
				{
					mbpFile	=	(MimeBodyPart)aFileInfo.get(i);
					mp.addBodyPart(mbpFile);
				}
			}
			*/
			
			/*msg.setContent(mp);

			Transport.send(msg);
			
			//Transport transport = session.getTransport("smtp");
			//Transport.connect(sHost, "Administrator", "rjstjfadmin@12");
			//Transport.sendMessage(msg, msg.getAllRecipients());
			//Transport.close();
		} 
		catch (MessagingException me)
		{
			me.printStackTrace();
			Exception ex = me;
			
			if( ex instanceof SendFailedException )
			{
				SendFailedException sfex = (SendFailedException)ex;
				Address[] invalid = sfex.getInvalidAddresses();
				if(invalid == null)
				{
					System.out.println("*** Invalid Addresses");
				}
				else
				{
					for(int i=0; i<invalid.length; i++)
						System.out.println(" " + invalid[i]);
				}
			}
			
		} catch (MalformedURLException e) {
			bSend	=	false;
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
		} catch (Exception e) {
			bSend	=	false;
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
		}*/
		return bSend;
	}


	/**
	 * SMS 전송
	 * @param sSenderName    보내는사람 이름
	 * @param sSenderPhoneNo 보내는사람 전화번호
	 * @param sReceiverCpNo1 받는사람 휴대전화 서비스번호
	 * @param sReceiverCpNo2 받는사람 휴대전화 국번
	 * @param sReceiverCpNo3 받는사람 휴대전화 번호
	 * @param sSmsMsg        전송 메시지
	 * @return
	 */
	public boolean sendSMS(String sSenderName, String sSenderPhoneNo, String sReceiverCpNo1, String sReceiverCpNo2, String sReceiverCpNo3, String sSmsMsg)
	{
		boolean bSuccess = false;
		
		
		// 전달된 값이 정상적 일때만 처리
		if ( 	(sSenderName != null)
			 &&	(sSenderPhoneNo != null) && !sSenderPhoneNo.equals("")
			 &&	(sReceiverCpNo1 != null) && (sReceiverCpNo1.length() == 3)
			 &&	(sReceiverCpNo2 != null) && (sReceiverCpNo2.length() >= 3)
			 &&	(sReceiverCpNo3 != null) && (sReceiverCpNo3.length() >= 3) && !sReceiverCpNo3.equals("0000")
			 && (sSmsMsg != null) && !sSmsMsg.equals("")
			 && (sReceiverCpNo1.equals("010") || sReceiverCpNo1.equals("011") || sReceiverCpNo1.equals("016") || sReceiverCpNo1.equals("017") || sReceiverCpNo1.equals("018") || sReceiverCpNo1.equals("019"))
			)
		{
			String sHmCallbackNo = "027889097"; // sSenderPhoneNo;	// "-" 제거한 12자리 보내는사람 전화번호 (우측에 공백추가)
			String sHmPhoneNo = sReceiverCpNo1 + sReceiverCpNo2 + sReceiverCpNo3;		// 받는사람 휴대전화 번호 합친것
			String sHmHp1 = sReceiverCpNo1;			// 4자리 받는사람 휴대전화 서비스번호 (우측에 공백추가)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // 실서버만 sms 보냄
				{
					DB db = new DB();
					//db.setDebug(out);
					DataObject sms = new DataObject("em_tran");
					sms.item("tran_phone", sHmPhoneNo.trim());
					sms.item("tran_callback", sHmCallbackNo.trim());					
					sms.item("tran_status", "1");
					//sms.item("tran_date", Util.getTimeString("yyyyMMddHHmmss"));
					sms.item("tran_msg", sSmsMsg);
					sms.item("tran_type", "4");
					sms.item("tran_id", "NDD002");
					
					String query = 
					 " INSERT INTO em_tran       "
					+"          (                "
					+"            tran_pr        "
					+"          , tran_phone     "
					+"          , tran_callback  "
					+"          , tran_status    "
					+"          , tran_date      "
					+"          , tran_msg       "
					+"          , tran_type      "
					+"          , tran_id        "
					+"          ) VALUES (       "
					+"          seq_sms.nextval  "
					+"          , $tran_phone$   "
					+"          , $tran_callback$"
					+"          , $tran_status$  "
					+"			, SYSDATE        "
					+"		    , $tran_msg$     "
					+"		    , $tran_type$    "
					+"		    , $tran_id$      "
					+"          )                ";
					System.out.println(query);
					db.setCommand(query, sms.record);
					if(!db.executeArray()){
						System.out.println("//-------------------- [SMS전송 오류] --------------------//");
						System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
						System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
						System.out.println("  - 전송 메시지 : " + sSmsMsg);
						System.out.println("//--------------------------------------------------//");
					} 
					else
					{
						System.out.println("//-------------------- [SMS전송] --------------------//");
						System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
						System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
						System.out.println("  - 전송 메시지 : " + sSmsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					bSuccess = true;					
				}
				else
				{
					System.out.println("//-------------------- [가상 SMS전송:개발용] --------------------//");
					System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
					System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
					System.out.println("  - 전송 메시지 : " + sSmsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}
		
				
			} catch (Exception e) {
				e.printStackTrace();
			}			

		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendSMS()] : 전달된 parmater에 오류가 있습니다.");
		}
		
		return bSuccess;
		
	}

	/**
	 * SMS 전송
	 * @param sSenderName    보내는사람 이름
	 * @param sSenderPhoneNo 보내는사람 전화번호
	 * @param sReceiverCpNo1 받는사람 휴대전화 서비스번호
	 * @param sReceiverCpNo2 받는사람 휴대전화 국번
	 * @param sReceiverCpNo3 받는사람 휴대전화 번호
	 * @param sSmsMsg        전송 메시지
	 * @return 
	 */
	public boolean sendSMS_apt(String sSenderName, String sSenderPhoneNo, String sReceiverCpNo1, String sReceiverCpNo2, String sReceiverCpNo3, String sSmsMsg)
	{
		boolean bSuccess = false;
		
		// 전달된 값이 정상적 일때만 처리
		if ( 	(sSenderName != null)
				&&	(sSenderPhoneNo != null) && !sSenderPhoneNo.equals("")
				&&	(sReceiverCpNo1 != null) && (sReceiverCpNo1.length() == 3)
				&&	(sReceiverCpNo2 != null) && (sReceiverCpNo2.length() >= 3)
				&&	(sReceiverCpNo3 != null) && (sReceiverCpNo3.length() >= 3)
				&& (sSmsMsg != null) && !sSmsMsg.equals("")
				)
		{
			HashMap<String, String> hm = new HashMap<String, String>();
			
			String sHmCallbackNo = "027889029";//sSenderPhoneNo;	// "-" 제거한 12자리 보내는사람 전화번호 (우측에 공백추가)
			String sHmPhoneNo = sReceiverCpNo1 + sReceiverCpNo2 + sReceiverCpNo3;		// 받는사람 휴대전화 번호 합친것
			String sHmHp1 = sReceiverCpNo1;			// 4자리 받는사람 휴대전화 서비스번호 (우측에 공백추가)
			
			try {
				String sHostName;
				sHostName = java.net.InetAddress.getLocalHost().getHostName();
				if(sHostName.equals("docu01") || sHostName.equals("docu02")) // 실서버만 sms 보냄
				{
					DB db = new DB();
					//db.setDebug(out);
					DataObject sms = new DataObject("em_tran");
					sms.item("tran_phone", sHmPhoneNo.trim());
					sms.item("tran_callback", sHmCallbackNo.trim());					
					sms.item("tran_status", "1");
					//sms.item("tran_date", Util.getTimeString("yyyyMMddHHmmss"));
					sms.item("tran_msg", sSmsMsg);
					sms.item("tran_type", "4");
					sms.item("tran_id", "NDD002");
					
					String query = 
					 " INSERT INTO em_tran       "
					+"          (                "
					+"            tran_pr        "
					+"          , tran_phone     "
					+"          , tran_callback  "
					+"          , tran_status    "
					+"          , tran_date      "
					+"          , tran_msg       "
					+"          , tran_type      "
					+"          , tran_id        "
					+"          ) VALUES (       "
					+"          seq_sms.nextval  "
					+"          , $tran_phone$   "
					+"          , $tran_callback$"
					+"          , $tran_status$  "
					+"			, SYSDATE        "
					+"		    , $tran_msg$     "
					+"		    , $tran_type$    "
					+"		    , $tran_id$      "
					+"          )                ";
					System.out.println(query);
					db.setCommand(query, sms.record);
					if(!db.executeArray()){						
						System.out.println("//-------------------- [SMS전송 오류] --------------------//");
						System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
						System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
						System.out.println("  - 전송 메시지 : " + sSmsMsg);
						System.out.println("//--------------------------------------------------//");
					} 
					else
					{
						System.out.println("//-------------------- [SMS전송] --------------------//");
						System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
						System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
						System.out.println("  - 전송 메시지 : " + sSmsMsg);
						System.out.println("//--------------------------------------------------//");
					}
					bSuccess = true;						
				}
				else
				{
					System.out.println("//-------------------- [가상 SMS전송:개발용] --------------------//");
					System.out.println("  - 보내는사람 전화번호 : " + sHmCallbackNo);
					System.out.println("  - 받는사람 휴대전화 : " + sHmPhoneNo);
					System.out.println("  - 전송 메시지 : " + sSmsMsg);
					System.out.println("//--------------------------------------------------//");
					bSuccess = true;
				}			
				
			} catch (Exception e) {
				e.printStackTrace();
			}		
		}
		else
		{
			System.out.println("[ERROR "+this.getClass()+".sendSMS()] : 전달된 parmater에 오류가 있습니다.");
		}
		
		return bSuccess;
		
	}	
	

	/**
	 * MimeBodyPart 파일첨부
	 * @param sFullUrl		파일포함 전체경로
	 * @param sReNameFile	파일명
	 * @return
	 * @throws Exception
	 */
	public MimeBodyPart getMultipart(String sFullUrl, String sReNameFile)
	{
		MimeBodyPart	mbpFile	=	null;
		try {
			/*	메일 파일 첨부 */
			mbpFile	=	new	MimeBodyPart();
			FileDataSource	fds	=	new	FileDataSource(sFullUrl);
			mbpFile.setDataHandler(new DataHandler(fds));

			mbpFile.setFileName(MimeUtility.encodeText(sReNameFile,"KSC5601","B"));
			mbpFile.setDisposition("attachment; filename=\"" + sReNameFile + "\"");
		} catch (MessagingException e) {
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
		}
		return mbpFile;
	}



	/**
	 * MimeBodyPart 배열 반환
	 * @param hm	key : 가져올 파일 전제 경로(파일명 포함), value: rename file 명
	 * @throws Exception
	 */
	public ArrayList getMultipart(HashMap hm)
	{
		ArrayList	al	=	null;
		try {
			Iterator	it	=	hm.keySet().iterator();

			String	sFullUrl	=	"";	//	경로명
			String	sReNameFile	=	"";	//	rename file name

			al	=	new	ArrayList();
			while(it.hasNext())
			{
				sFullUrl	=	it.next().toString();

				sReNameFile	=	hm.get(sFullUrl).toString();

				sFullUrl	=	StrUtil.replace(sFullUrl,"\\",File.separator);

				MimeBodyPart	mbp	=	this.getMultipart(sFullUrl, sReNameFile);
				al.add(mbp);
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getMultipart()] :" + e.toString());
		}
		return al;
	}

	/**
	 * HTML 소스가져와 String으로 만들기
	 * @param url
	 * @return
	 * @throws Exception
	 */
	public String getHtmlSouce(URL url)
	{
		HttpURLConnection	huc	=	null;
		StringBuffer		sb	=	new	StringBuffer();
		
		try{
			huc	= (HttpURLConnection) url.openConnection();
			huc.setRequestMethod("POST");
			huc.setDoOutput(true);
			huc.setDoInput(true);
			
			BufferedReader reader = new BufferedReader( new InputStreamReader( url.openStream()));

			String line = "";
			while( (line = reader.readLine()) != null )
			{
				sb.append(line);
			}
		}catch ( Exception e )
		{
			System.out.println("[ERROR "+this.getClass()+".getHtmlSouce()] :" + e.toString());
		}
		return	sb.toString();
	}

	/**
	 * parameter 값 만들기
	 * @param hm
	 * @return
	 * @throws Exception
	 */
	public	String makeParameters(HashMap hm)
	{
		StringBuffer	sb	=	null;
		try {
			sb	=	new	StringBuffer();
			Iterator	it	=	hm.keySet().iterator();

			String	sKey	=	"";
			String	sVal	=	"";

			int	i =	1;
			while(it.hasNext())
			{
				sKey	=	it.next().toString();
				sVal	=	hm.get(sKey).toString();

				if(i == 1)
				{
					sb.append("?" + sKey + "=" + java.net.URLEncoder.encode(sVal,"UTF-8"));
				}else
				{
					sb.append("&" + sKey + "=" + java.net.URLEncoder.encode(sVal,"UTF-8"));
				}
				i++;
			}

		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".makeParameters()] :" + e.toString());
		}
		return sb.toString();
	}
	
	
	// 전자입찰 메일
	public boolean sendBidMail(int mailType, DataSetValue mailInfo){// mailType 1:현설 2:입찰공고 3:연기공고 4:정정공고 5:취소공고
		boolean succes = false;
		
		try{
			String _sUrl = Startup.conf.getString("domain");
			String _sImg = _sUrl + "/images/email/20110620/"; 
			
			String title = "";
			String content = "";
			String subject = "";
			if(mailType == 1){
				title = "현설공고";
				content = "현장설명 참석을 요청 하였습니다.";
				subject = "["+mailInfo.getString("mainVendNm")+"] 현장 설명 참석요청 안내";
			}else if(mailType == 2){
				title = "입찰공고";
				content = "견적서 제출을 요청 하였습니다.";
				subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 견적서 제출 요청 안내";
			}else if(mailType == 3){
				title = "연기공고";
				content = "연기공고 알려드립니다.";
				subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 마감시간 연기 안내";
			}else if(mailType == 4){
				title = "정정공고 확인을";
				content = "정정공고 알려드립니다.";
				subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 정정 안내";
			}else if(mailType == 5){
				title = "취소공고";
				content = "공고취소 알려드립니다.";
				subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 취소 안내";
			}
			
			String html = "";
			html+="	<html>																																		";						
			html+="	<head>                                                                                                                                      ";
			html+="	<title>"+title+" 정보 안내</title>                                                                                                         ";
			html+="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
			html+="	<style type=\"text/css\">                                                                                                                   ";
			html+="	<!--                                                                                                                                        ";
			html+="	td {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; line-height: normal; color: #5B5B5B}       ";
			html+="	.b {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; font-weight: bold; color: #3662B8}         ";
			html+="	-->                                                                                                                                         ";
			html+="	</style>                                                                                                                                    ";
			html+="	</head>                                                                                                                                     ";
		    html+="                                                                                                                                             ";
			html+="	<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">                           ";
			html+="	<table width=\"700\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td ><img src=\""+_sImg+"mail_top.gif\" width=\"700\" height=\"119\"></td>                                                              ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td  height=\"50\">&nbsp;</td>                                                                                                          ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td align=\"right\">                                                                                                                    ";
			html+="	      <table width=\"100%\" border=\"0\" cellspacing=\"5\" cellpadding=\"15\" bgcolor=\"90AAC7\">                                           ";
			html+="	        <tr>                                                                                                                                ";
			html+="	          <td bgcolor=\"#FFFFFF\" align=\"center\"><br>                                                                                     ";
			html+="	            <img src=\""+_sImg+"sub_title"+mailType+".gif\" width=\"104\" height=\"19\"><br>                                                ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"1\" cellpadding=\"10\" bgcolor=\"B5C6D9\">                                      ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td bgcolor=\"#fafafa\">                                                                                                    ";
			html+="	                  <table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"3\">                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td width=\"15%\" align=\"center\"><b>발주자</b></td>                                                                 ";
			html+="	                      <td>: "+mailInfo.getString("mainVendNm")+"</td>                                                                       ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>현장명</b></td>                                                                               ";
			html+="	                      <td>: "+mailInfo.getString("fieldNm")+"</td>                                                                          ";
			html+="	                    </tr>                                                                                                                   ";
			html+="	                    <tr>                                                                                                                    ";
			html+="	                      <td align=\"center\"><b>공고명</b></td>                                                                               ";
			html+="	                      <td>: "+mailInfo.getString("bidNm")+"</td>                                                                            ";
			html+="	                    </tr>                                                                                                                   ";
			if(mailType == 1){
				html+="	                    <tr>                                                                                                                ";
				html+="	                      <td align=\"center\"><b>현설일시</b></td>                                                                         ";
				html+="	                      <td>: "+mailInfo.getString("field_expl_ymd")+"</td>                                                               ";
				html+="	                    </tr>                                                                                                               ";
			}else{
				html+="	                    <tr>                                                                                                                ";
				html+="	                      <td align=\"center\"><b>공고일자</b></td>                                                                         ";
				html+="	                      <td>: "+mailInfo.getString("noti_date")+"</td>                                                                    ";
				html+="	                    </tr>                                                                                                               ";
			}
			html+="	                  </table>                                                                                                                  ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                                                         ";
			html+="	              <tr>                                                                                                                          ";
			html+="	                <td><span class=\"b\">"+mailInfo.getString("mainVendNm")+"</span>님이 <span class=\"b\">"+mailInfo.getString("suppNm")+"</span>                                                       ";
			html+="	                  님께 "+content+"                                                                                         ";
			html+="	                  <p>아래 '상세보기' 버튼을 클릭하여 확인 하시기 바랍니다.<br>                                                              ";
			html+="	                  </p>                                                                                                                      ";
			html+="	                </td>                                                                                                                       ";
			html+="	              </tr>                                                                                                                         ";
			html+="	            </table>                                                                                                                        ";
			html+="	            <br>                                                                                                                            ";
			html+="	            <a href=\"http://www.nicedocu.com/web/supplier/sindex.jsp\" target=\"_blank\"><img src=\""+_sImg+"btn_detail.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";
			html+="	          </td>                                                                                                                             ";
			html+="	        </tr>                                                                                                                               ";
			html+="	      </table>                                                                                                                              ";
			html+="	    </td>                                                                                                                                   ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td >&nbsp;</td>                                                                                                                        ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	  <tr>                                                                                                                                      ";
			html+="	    <td ><img src=\""+_sImg+"copyright.gif\" width=\"700\" height=\"120\"></td>                                                             ";
			html+="	  </tr>                                                                                                                                     ";
			html+="	</table>                                                                                                                                    ";
			html+="	</body>                                                                                                                                     ";
			html+="	</html>                                                                                                                                     ";
			
			String strRtn[] = OkkiMail.sendJavaMail(mailInfo.getString("mail_to"), null, Startup.conf.getString("email.mailFrom"),"나이스다큐", subject, html);
			System.out.println("메일 전송 결과 : " + strRtn[0]);
			if(strRtn[0].equals("ok"))
				succes = true;  //성공 
			else
				succes = false;  // 실패
		}catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".sendBidMail()] :" + e.toString());
		}
		
		
		return succes;
	}
	
	// 전자입찰 메일
		public boolean sendNoBuildBidMail(String _sUrl, int mailType, DataSetValue mailInfo){// mailType 1:현설 2:입찰공고 3:연기공고 4:정정공고 5:취소공고
			boolean succes = false;
			
			try{
				//String _sUrl = Startup.conf.getString("domain");
				String _sImg = "http://" +_sUrl + "/images/email/20110620/"; 
				
				String title = "";
				String content = "";
				String subject = "";
				if(mailType == 1){
					title = "현설공고";
					content = "현장설명 참석을 요청 하였습니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 현장 설명 참석요청 안내";
				}else if(mailType == 2){
					title = "입찰공고";
					content = "견적서 제출을 요청 하였습니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 견적서 제출 요청 안내";
				}else if(mailType == 3){
					title = "연기공고";
					content = "연기공고 알려드립니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 마감시간 연기 안내";
				}else if(mailType == 4){
					title = "정정공고 확인을";
					content = "정정공고 알려드립니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 정정 안내";
				}else if(mailType == 5){
					title = "취소공고";
					content = "공고취소 알려드립니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 입찰공고 취소 안내";
				}else if(mailType == 6){
					title = "입찰결과";
					content = "입찰결과  알려드립니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 입찰결과  안내";
				}else if(mailType == 7){
					title = "재입찰공고";
					content = "재입찰공고 알려드립니다.";
					subject = "["+mailInfo.getString("mainVendNm")+"] 재입찰공고 안내";
				}
				
				String html = "";
				html+="	<html>																																		";						
				html+="	<head>                                                                                                                                      ";
				html+="	<title>"+title+" 정보 안내</title>                                                                                                         ";
				html+="<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">";
				html+="	<style type=\"text/css\">                                                                                                                   ";
				html+="	<!--                                                                                                                                        ";
				html+="	td {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; line-height: normal; color: #5B5B5B}       ";
				html+="	.b {  font-family: \"돋움\", \"Helvetica\", \"sans-serif\"; font-size: 12px; font-style: normal; font-weight: bold; color: #3662B8}         ";
				html+="	-->                                                                                                                                         ";
				html+="	</style>                                                                                                                                    ";
				html+="	</head>                                                                                                                                     ";
			    html+="                                                                                                                                             ";
				html+="	<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">                           ";
				html+="	<table width=\"700\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\" align=\"center\">                                                     ";
				html+="	  <tr>                                                                                                                                      ";
				html+="	    <td ><img src=\""+_sImg+"mail_top.gif\" width=\"700\" height=\"119\"></td>                                                              ";
				html+="	  </tr>                                                                                                                                     ";
				html+="	  <tr>                                                                                                                                      ";
				html+="	    <td  height=\"50\">&nbsp;</td>                                                                                                          ";
				html+="	  </tr>                                                                                                                                     ";
				html+="	  <tr>                                                                                                                                      ";
				html+="	    <td align=\"right\">                                                                                                                    ";
				html+="	      <table width=\"100%\" border=\"0\" cellspacing=\"5\" cellpadding=\"15\" bgcolor=\"90AAC7\">                                           ";
				html+="	        <tr>                                                                                                                                ";
				html+="	          <td bgcolor=\"#FFFFFF\" align=\"center\"><br>                                                                                     ";
				html+="	            <img src=\""+_sImg+"sub_title"+mailType+".gif\" width=\"104\" height=\"19\"><br>                                                ";
				html+="	            <br>                                                                                                                            ";
				html+="	            <br>                                                                                                                            ";
				html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"1\" cellpadding=\"10\" bgcolor=\"B5C6D9\">                                      ";
				html+="	              <tr>                                                                                                                          ";
				html+="	                <td bgcolor=\"#fafafa\">                                                                                                    ";
				html+="	                  <table width=\"100%\" border=\"0\" cellspacing=\"1\" cellpadding=\"3\">                                                   ";
				html+="	                    <tr>                                                                                                                    ";
				html+="	                      <td width=\"15%\" align=\"center\"><b>발주자</b></td>                                                                 ";
				html+="	                      <td>: "+mailInfo.getString("mainVendNm")+"</td>                                                                       ";
				html+="	                    </tr>                                                                                                                   ";
				html+="	                    <tr>                                                                                                                    ";
				html+="	                      <td align=\"center\"><b>공고명</b></td>                                                                               ";
				html+="	                      <td>: "+mailInfo.getString("bidNm")+"</td>                                                                            ";
				html+="	                    </tr>                                                                                                                   ";
				if(mailType == 1){
					html+="	                    <tr>                                                                                                                ";
					html+="	                      <td align=\"center\"><b>현설일시</b></td>                                                                         ";
					html+="	                      <td>: "+mailInfo.getString("field_expl_ymd")+"</td>                                                               ";
					html+="	                    </tr>                                                                                                               ";
					html+="	                    <tr>                                                                                                                ";
					html+="	                      <td align=\"center\"><b>현설장소</b></td>                                                                         ";
					html+="	                      <td>: "+mailInfo.getString("field_place")+"</td>                                                               ";
					html+="	                    </tr>                                                                                                               ";
				}else{
					html+="	                    <tr>                                                                                                                ";
					html+="	                      <td align=\"center\"><b>공고일자</b></td>                                                                         ";
					html+="	                      <td>: "+mailInfo.getString("noti_date")+"</td>                                                                    ";
					html+="	                    </tr>                                                                                                               ";
					if(mailType == 2||mailType == 3||mailType == 7){
						html+="	                    <tr>                                                                                                                ";
						html+="	                      <td align=\"center\"><b>마감일시</b></td>                                                                         ";
						html+="	                      <td>: <b><span style='color:#75baff'>"+mailInfo.getString("submit_edate")+"</span></b></td>                   ";
						html+="	                    </tr>                                                                                                               ";	
					}
				}
				html+="	                  </table>                                                                                                                  ";
				html+="	                </td>                                                                                                                       ";
				html+="	              </tr>                                                                                                                         ";
				html+="	            </table>                                                                                                                        ";
				html+="	            <br>                                                                                                                            ";
				html+="	            <br>                                                                                                                            ";
				html+="	            <table width=\"80%\" border=\"0\" cellspacing=\"0\" cellpadding=\"0\">                                                         ";
				html+="	              <tr>                                                                                                                          ";
				html+="	                <td><span class=\"b\">"+mailInfo.getString("mainVendNm")+"</span>님이 <span class=\"b\">"+mailInfo.getString("suppNm")+"</span>                                                       ";
				html+="	                  님께 "+content+"                                                                                         ";
				html+="	                  <p>아래 '상세보기' 버튼을 클릭하여 확인 하시기 바랍니다.<br>                                                              ";
				html+="	                  </p>                                                                                                                      ";
				html+="	                </td>                                                                                                                       ";
				html+="	              </tr>                                                                                                                         ";
				html+="	            </table>                                                                                                                        ";
				html+="	            <br>                                                                                                                            ";
				html+="	            <a href=\"http://"+_sUrl+"/web/buyer/index.jsp\" target=\"_blank\"><img src=\""+_sImg+"btn_detail.gif\" width=\"128\" height=\"38\" vspace=\"10\" border=\"0\"></a>                           ";
				html+="	          </td>                                                                                                                             ";
				html+="	        </tr>                                                                                                                               ";
				html+="	      </table>                                                                                                                              ";
				html+="	    </td>                                                                                                                                   ";
				html+="	  </tr>                                                                                                                                     ";
				html+="	  <tr>                                                                                                                                      ";
				html+="	    <td >&nbsp;</td>                                                                                                                        ";
				html+="	  </tr>                                                                                                                                     ";
				html+="	  <tr>                                                                                                                                      ";
				html+="	    <td ><img src=\""+_sImg+"copyright.gif\" width=\"700\" height=\"120\"></td>                                                             ";
				html+="	  </tr>                                                                                                                                     ";
				html+="	</table>                                                                                                                                    ";
				html+="	</body>                                                                                                                                     ";
				html+="	</html>                                                                                                                                     ";
				
				String strRtn[] = OkkiMail.sendJavaMail(mailInfo.getString("mail_to"), null, Startup.conf.getString("email.mailFrom"),"나이스다큐", subject, html);
				System.out.println("메일 전송 결과 : " + strRtn[0]);
				if(strRtn[0].equals("ok"))
					succes = true;  //성공 
				else
					succes = false;  // 실패
			}catch (Exception e) {
				System.out.println("[ERROR "+this.getClass()+".sendBidMail()] :" + e.toString());
			}
			
			
			return succes;
		}
		
		/****************************************
		 * 전자계약서 확인요청  메일 전송
		 *
		 * @param sFromCompanyName 전송업체명
		 * @param sToCompanyName 받는업체명  
		 * @param sToPersonName 받는업체 담담자명
		 * @param sToPersonEmail 받는업체 담당자 이메일
		 * @return 
		 *         500 : 이메일 전송 시스템 에러
		 *         200 : 이메일 전송 성공
		 *         400 : 이메일 전송 에러
		 */
		public int sendRejectContMail(String sFromCompanyName, String sToCompanyName, String sToPersonName, String sToPersonEmail)
		{
			int sReturn = 500;
			
			try {		
				
				String _sUrl = Startup.conf.getString("domain");
				String _sImg = _sUrl + "/images/email/20100403/";
				String _sEmailRet = _sUrl+"/web/supplier/sindex.jsp";
				
				
				String strContents = "<html>"
					+"<head>"
					+"<title>나이스다큐(NiceDocu)</title>"
					+"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
					+"<style>"
					+"table, tr, td, div, INPUT, SELECT, form, Textarea"
					+"{"
					+"	font-size:9pt;"
					+"	font-family:굴림,굴림체;"
					+"	line-height: 120%;"
					+"}"
					+"</style>"
					+"</head>"
					+"<body bgcolor=\"#FFFFFF\" text=\"#000000\" leftmargin=\"0\" topmargin=\"0\" marginwidth=\"0\" marginheight=\"0\">"
					+"<table width='700' border='0' align='center' cellpadding='0' cellspacing='1' bgcolor='#66CCCC'>"
					+"  <tr>"
					+"    <td><img src='"+ _sImg + "top.gif' width='700' height='80' /></td>"
					+"  </tr>"
					+"  <tr>"
					+"    <td height='200' align='center' bgcolor='#FFFFFF' background='"+ _sImg + "bg1.gif'><br/>"
					+"      <table width='600' border='0' cellspacing='0' cellpadding='2'>"
					+"      <tr>"
					+"        <td align='center'><p><strong>" + sFromCompanyName + "</strong> 님이 <strong>" + sToCompanyName + "</strong> 님께 <br />"
					+"          전자계약서 확인 요청 하였습니다.</p>"
					+"          <p>아래 <span style='color: #3333FF;font-weight: bold'>“확인하기” </span>버튼을 눌러 계약서를 검토하시기 바랍니다.<br />"
					+"              <br />"
					+"          </p></td>"
					+"      </tr>"
					+"      <tr>"
					+"        <td align='center'><a href='"+_sEmailRet +"'><img src='"+ _sImg + "btn_view3.gif' border='0'/></a><br />"
					+"          <br /></td>"
					+"      </tr>"
					+"      </table>"
					+"    </td>"
					+"  </tr>"
					+"  <tr>"
					+"    <td>"
					+"  	<table width='100%' border='0' cellpadding='0' cellspacing='0' bgcolor='#EBF3F4'>"
					+"  	  <tr>"
					+"  		<td width='125'><img src='"+ _sImg + "bottom.gif' height='65' /></td>"
					+"  		<td align='right' style='font-size:11px'>서울특별시 영등포구 국회대로 66길 9 (여의도동,NICE2사옥) 9층&nbsp; 고객센터 (02)788-9097<br>"
					+"  						Copyright(c) 2010 NICE D&B All Rights Reserved"
					+"  		</td>"
					+"  		<td width='10'></td>"
					+"  	  </tr>"
					+"  	</table>"
					+"    </td>"
					+"  </tr>"
					+"</table>"
					+"</body>"
					+"</html>";  		

			
				String[] strTo = {"\"" + sToPersonName + "\" <"+ sToPersonEmail + ">"};
				String[] strCc= null;//{"drought@dreamwiz.com"};
				String[] strBcc= null;//{"drought@dreamwiz.com"};
				String strFrom = Startup.conf.getString("email.mailFrom");
				String strSubject = sFromCompanyName + "님이 " + sToPersonName + "님에게 전자계약서를 확인 요청 하였습니다.";
				String attchFile= "";
				
				String strRtn[] = OkkiMail.sendJavaMail(strTo, strCc,strBcc,strFrom, "나이스다큐", strSubject, strContents, attchFile);
				System.out.println("메일 전송 결과 : " + strRtn[0]);
		
				if(strRtn[0].equals("ok"))
					sReturn = 200;  //성공 
				else
					sReturn = 400;  //실패
				
			} catch (Exception e) {
				e.printStackTrace();
				System.out.println("[ERROR "+this.getClass()+".sendMail()] :" + e.toString());
				return 500;
			}
			return sReturn;		
		}	
		
}
