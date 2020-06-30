<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String vendcd = u.request("vendcd");
String sign_seq = u.request("sign_seq");
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
	if(member.getString("status").equals("01")){  // 정회원

		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and default_yn = 'Y' ");
		if(!person.next()){
		}

		DataObject clientDao = new DataObject("tcb_client");
		int client_cnt = clientDao.findCount("member_no = '"+_member_no+"' and  client_no = '"+member.getString("member_no")+"' ");
		if(client_cnt>0){
			out.println("<script>");
			out.println("alert('이미 거래처로 등록되어 있는 업체 입니다.')");
			out.println(" var data = { ");
			out.println(" 	 'member_no':'"+member.getString("member_no")+"'");
			out.println(" 	,'member_name':'"+member.getString("member_name")+"'");
			out.println(" 	,'vendcd':'"+member.getString("vendcd")+"'");
			out.println(" 	,'post_code':'"+member.getString("post_code")+"'");
			out.println(" 	,'address':'"+member.getString("address")+"'");
			out.println(" 	,'boss_name':'"+member.getString("boss_name")+"'");
			out.println(" 	,'member_gubun':'"+member.getString("member_gubun")+"'");
			out.println(" 	,'user_name':'"+person.getString("user_name")+"'");
			out.println(" 	,'hp1':'"+person.getString("hp1")+"'");
			out.println(" 	,'hp2':'"+person.getString("hp2")+"'");
			out.println(" 	,'hp3':'"+person.getString("hp3")+"'");
			out.println(" 	,'email':'"+person.getString("email")+"'");
			out.println(" 	,'sign_seq':'"+sign_seq+"'");
			out.println("};");
			out.println("opener.addClientInfo(data); ");
			out.println(" self.close(); ");
			out.println("</script>");
			return;
		}		
		
		out.print("<script>");
		out.print("if(confirm('이미 정회원으로 가입되어 있는 업체입니다.\\n\\n거래처로 등록 하시겠습니까?')) {");
		out.print(" document.forms['form1']['chk_vendcd'].value='3';");
		out.print("	document.forms['form1']['chk_member_no'].value='"+member.getString("member_no")+"';");
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
		out.print("	document.forms['form1'].submit();");
		out.print("	}");
		out.print("</script>");
		return;
	}
	else if(member.getString("status").equals("02")) //비회원으로 업체 정보 존재
	{
		DataObject clientDao = new DataObject("tcb_client");
		int client_cnt = clientDao.findCount("member_no = '"+_member_no+"' and  client_no = '"+member.getString("member_no")+"' ");
		if(client_cnt>0){
			out.print("<script>");
			out.print("alert('이미 거래처로 등록된 업체 입니다.\\n\\n업체를 검색하신 후 선택해주세요.'); self.close();");
			out.print("</script>");
			return;
		}
		String post_code1 = "";
		String post_code2 = "";
		if(!member.getString("post_code").equals("")){
			post_code1 = member.getString("post_code").substring(0,3);
			post_code2 = member.getString("post_code").substring(3);
		}

		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find(" member_no = '"+member.getString("member_no")+"' and default_yn = 'Y' ");
		if(!person.next()){
		}
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='2';");
		out.print(" if(confirm('기존에 등록된 업체 정보가 있습니다.\\n\\n기존 정보를 자동으로 불러 오시겠습니까?')){");
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
	else if(member.getString("status").equals("00"))  //DB로 안보이게 처리 한놈
	{
		out.print("<script>");
		out.print(" document.forms['form1']['chk_vendcd'].value='';");
		out.print(" alert('등록할 수 없는 업체 입니다.\\n\\n고객센터(02-788-9097)로 문의해 주세요.');");
		out.print("</script>");
	}

}




%>