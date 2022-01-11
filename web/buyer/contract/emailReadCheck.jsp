<%
/*************************************************************************
* 파 일 명 : emailReadCheck.jsp
* 작 업 자 : 유성훈
* 작 업 일 : 2014-08-21
* 기    능 : 이메일 수신 확인(일반기업용)
*            이메일 안에 <img width="0" height="0" src="http://www.nicedocu.com/web/buyer/contract/emailReadCheck.jsp?cont_no=200810020001&cont_chasu=xxx&member_no=xxxxxxx&num=1" /> 추가
* ---------------------------- 변 경 이 력 -------------------------------
* 번호 작 업 자   작      업     일   변경내용                       비고
* ------------------------------------------------------------------------
*   1  유성훈     2014-08-21          신규작성
*************************************************************************/
%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>

<%
	boolean bSuccess = false;
    String cont_no = u.request("cont_no");
    String cont_chasu = u.request("cont_chasu");
    String member_no = u.request("member_no");
    String email_seq = u.request("num");

	if(!cont_no.equals("") && !cont_chasu.equals("") && !member_no.equals("") && !email_seq.equals(""))
	{
		System.out.println("이메일 수신 확인");
		System.out.println("cont_no : " + cont_no);
		System.out.println("cont_chasu : " + cont_chasu);
		System.out.println("member_no : " + member_no);
		System.out.println("email_seq : " + email_seq);

		DataObject emailDao = new DataObject("tcb_cont_email");

		emailDao.item("recv_dete", u.getTimeString());
		emailDao.item("status", "03");
		if(!emailDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+member_no+"' and email_seq = '"+email_seq+"' and recv_dete is null"))
			System.out.print("일반기업용 전자계약 이메일 수신 확인 에러 - cont_no : " + cont_no + ", cont_chasu : " + cont_chasu);
		else
			System.out.print("일반기업용 전자계약 이메일 수신 확인 성공");
	}

%>

