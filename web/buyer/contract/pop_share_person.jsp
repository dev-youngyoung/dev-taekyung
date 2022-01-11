<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로로 접근하세요.");
	return;
}

f.addElement("s_user_name",null, null);

DataObject filedDao = new DataObject("tcb_field");
DataSet field = filedDao.find("member_no = '"+_member_no+"' and status > '0' and use_yn = 'Y' and field_seq <> '"+auth.getString("_FIELD_SEQ")+"'  ", "field_seq, field_name");

DataObject personDao = new DataObject("tcb_person");

while(field.next()){
	DataSet person = personDao.find(
			 "     member_no = '"+_member_no+"' " 
			+" and field_seq = '"+field.getString("field_seq")+"' " 
			+" and use_yn = 'Y'  "
			+" and user_id <> '"+auth.getString("_USER_ID")+"' "  
			+" and status > '0'  "
			+" and user_name like '%"+f.get("s_user_name")+"%' "); 
	field.put(".person", person);
}

if(u.isPost()&&f.validate()&&!f.get("gubun").equals("")){
	String gubun =f.get("gubun");
	String field_seq = f.get("field_seq");
	String field_name = f.get("field_name");
	String user_id = f.get("user_id");
	String user_name = f.get("user_name");
	
	DataObject shareDao = new DataObject("tcb_share");
	
	if(gubun.equals("field")){
		if(shareDao.findCount("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and recv_field_seq='"+field_seq+"' and status > 0 ")>0){
			u.jsError("이 계약은 "+ f.get("field_name") +"에게 이미 공람되어 있습니다.");
			return;		
		}
	}
	if(gubun.equals("person")){
		if(shareDao.findCount("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and (recv_field_seq='"+field_seq+"' or recv_user_id = '"+user_id+"') and status > 0 ")>0){
			u.jsError("이 계약은 "+ f.get("user_name") +"에게 이미 공람되어 있습니다.");
			return;		
		}
	}
	
	String seq = shareDao.getOne(" select nvl(max(seq),0)+1 from tcb_share where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  ");
	if(seq.equals("")){
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}
	
	shareDao.item("cont_no", cont_no);
	shareDao.item("cont_chasu", cont_chasu);
	shareDao.item("seq", seq);
	shareDao.item("send_user_id", auth.getString("_USER_ID"));
	shareDao.item("send_user_name", auth.getString("_USER_NAME"));
	shareDao.item("send_date", u.getTimeString());
	if(gubun.equals("field")){
		shareDao.item("recv_field_seq", field_seq);
		shareDao.item("recv_field_name", field_name);
	}
	shareDao.item("recv_user_id", user_id);
	shareDao.item("recv_user_name", user_name);
	shareDao.item("status", "10");
	
	if(!shareDao.insert()){
		u.jsError("처리중 오류가 발생 하였습니다. ");
		return;
	}

	out.println("<script>");
	out.println("alert('공람처리 하였습니다.');");
	out.println("opener.location.reload();");
	out.println("self.close();");
	out.println("</script>");
	return;	
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("contract.pop_share_person");
p.setVar("popup_title","사용자 선택");
p.setLoop("field", field);
p.setVar("form_script",f.getScript());
p.display(out);


%>