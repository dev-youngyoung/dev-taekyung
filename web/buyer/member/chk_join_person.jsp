<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
if(u.isPost()){
	String birth_date = f.get("birth_date").replaceAll("-", "");
	String gender = f.get("gender");
	String member_name = f.get("member_name");
	String hp1 = f.get("hp1");
	String hp2 = f.get("hp2");
	String hp3 = f.get("hp3");
	
	Security security = new	Security();
	
	DataObject personDao = new DataObject("tcb_person");
	
	if(Integer.parseInt(f.get("birth_date").substring(0,4)) >= 2000){
		gender = f.get("gender").equals("1") ? "3" : "4";
	} else {
		gender = f.get("gender");
	}
	
	String jumin_no = birth_date.substring(2)+gender;
	DataSet person = personDao.query(
			  "select a.member_no, a.status, c.boss_ci                 "
			 +"  from tcb_member a, tcb_person b, tcb_member_boss c    "
			 +" where a.member_no = b.member_no                        "
			 +"   and a.member_no = c.member_no(+)                     "
			 +"   and a.member_gubun = '04'                            "
			 +"   and b.jumin_no = '"+security.AESencrypt(jumin_no)+"' "
			 +"   and a.member_name = '"+member_name+"'                "
			 +"   and b.hp1 = '"+hp1+"'                                "
			 +"   and b.hp2 = '"+hp2+"'                                "
			 +"   and b.hp3 = '"+hp3+"'                                "
			);
	if(!person.next()){
		out.println("<script>");
		out.println("if(confirm('입력하신 정보로 회원가입을 진행 하시겠습니까?')){");
		out.println("parent.document.forms['form1'].target='';");
		out.println("parent.document.forms['form1'].action='';");
		out.println("parent.document.forms['form1'].submit();");
		out.println("}");
		out.println("</script>");
		return;
	}
	if(person.getString("status").equals("01")||person.getString("status").equals("03")){
		out.print("<script>");
		out.print("alert('"+member_name+"님은 이미 회원가입이 되어 있습니다.\\n\\n로그인후 이용 하세요.');");
		out.print("pareint.location.href='/web/buyer/';");
		out.print("</script>");
		return;
	}
	if(person.getString("status").equals("00")){
		out.print("<script>");
		out.print("alert('회원탈퇴 상태 입니다.');");
		out.print("pareint.location.href='/web/buyer/';");
		out.print("</script>");
		return;
	}
	if(person.getString("status").equals("02")){
		out.print("<script>");
		out.print("alert('비회원 상태 입니다.\\n\\n휴대폰 본인 인증을 진행 하세요');");
		out.print("parent.document.forms['form1']['member_no'].value = '"+person.getString("member_no")+"' ;");
		if(!person.getString("boss_ci").equals("")){
			out.print("parent.document.forms['form1']['boss_ci'].value = '"+person.getString("boss_ci")+"' ;");
		}
		out.print("parent.OpenIdentifyCheckplus('"+person.getString("member_no")+"');");
		out.print("</script>");
		return;
	}
}
%>