<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
f.addElement("s_title", null, null);

//��� ����
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_field");
list.setFields("*");
list.addWhere(" member_no = '" + _member_no + "' and status > 0 ");
list.addSearch("field_name", f.get("s_title"), "LIKE");
list.setOrderBy("field_seq desc ");

//��� ����Ÿ ����
DataSet rs = list.getDataSet();
while(rs.next()){
	rs.put("field_gubun", rs.getString("field_gubun").equals("01")?"�μ�":"����");
	rs.put("use_yn", rs.getString("use_yn").equals("Y")?"�����":"�������");
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.place_list");
p.setVar("menu_cd","000110");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000110", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", rs);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("id"));
p.setVar("form_script",f.getScript());
p.display(out);
%>