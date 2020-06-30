<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject templateDao = new DataObject("tcb_cont_template");
//templateDao.setDebug(out);
DataSet template = templateDao.find(" member_no like '%"+_member_no+"%' and status > '0' " ,"*", " template_cd asc ");

int cnt = template.size();
while(template.next()){
	template.put("__ord", cnt--);
	template.put("use_yn", template.getString("use_yn").equals("Y")?"사용":"미사용");
	if(!template.getString("display_name").equals("")){
		template.put("template_name",template.getString("display_name"));	
	}
	
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.cont_template_list");
p.setVar("menu_cd","000115");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000115", "btn_auth").equals("10"));
p.setVar("auht_form", false);
p.setLoop("list", template);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("template_cd"));
p.setVar("form_script",f.getScript());
p.display(out);
%>