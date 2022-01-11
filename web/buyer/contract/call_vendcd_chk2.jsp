<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String vendcd = u.request("vendcd");
if(vendcd.equals("")){
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao .find(" vendcd = '"+vendcd+"' ");
if(!member.next()){
	out.print("<script language=\"javascript\">");
	out.print(" alert('등록가능한 사업자 등록 번호 입니다.');");
	out.print(" document.forms['form1']['chk_vendcd'].value='1';");
	out.print("</script>");
}else{
	if(member.getString("status").equals("01") || member.getString("status").equals("02")){  // 정회원 또는 비회원으로 업체 정보 존재.
		/*
		DataObject clientDao = new DataObject("tcb_client");
		int client_cnt = clientDao.findCount(" client_no = '"+member.getString("member_no")+"' ");
		if(client_cnt > 0){
			out.print("<script>");
			out.print("alert('협력업체로 등록된 업체 입니다.\\n\\n업체검색을 통해 업체를 추가해 주세요.'); self.close();");
			out.print("</script>");
			return;
		}
		*/


		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and default_yn = 'Y' ");
		if(!person.next()){
		}
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='2';");
		out.print(" if(confirm('기존에 등록된 업체 정보가 있습니다.\\n\\n기존 정보를 자동으로 입력 하시겠습니까?')){");
		out.print("	document.forms['form1']['chk_member_no'].value='"+member.getString("member_no")+"';");
		out.print("	document.forms['form1']['member_name'].value='"+member.getString("member_name")+"';");
		out.print("	document.forms['form1']['boss_name'].value='"+member.getString("boss_name")+"';");
		out.print("	document.forms['form1']['post_code'].value='"+member.getString("post_code")+"';");
		out.print("	document.forms['form1']['address'].value='"+member.getString("address")+"';");
		out.print("	document.forms['form1']['user_name'].value='"+person.getString("user_name")+"';");
		out.print("	document.forms['form1']['tel_num'].value='"+person.getString("tel_num")+"';");
		out.print("	document.forms['form1']['hp1'].value='"+person.getString("hp1")+"';");
		out.print("	document.forms['form1']['hp2'].value='"+person.getString("hp2")+"';");
		out.print("	document.forms['form1']['hp3'].value='"+person.getString("hp3")+"';");
		out.print("	document.forms['form1']['email'].value='"+person.getString("email")+"';");
		out.print("	}");
		out.print("</script>");
	}
	if(member.getString("status").equals("00")){//DB로 안보이게 처리 한놈
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='';");
		out.print(" alert('등록할 수 없는 업체 입니다.\\n\\n고객센터로 문의해 주세요.');");
		out.print("</script>");
	}

}




%>