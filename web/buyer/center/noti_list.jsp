<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %><%
boolean sNotiInsert = false;
if (auth.getString("_MEMBER_TYPE").equals("01") || auth.getString("_MEMBER_TYPE").equals("03")) {//갑사
	sNotiInsert = true;
}

f.addElement("s_title",u.request("s_title"), null);
String _menu_cd = "000125";
//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_board d, tcb_person p");
list.setFields("d.*, p.user_name");
list.addWhere(" d.reg_id = p.user_id and category = 'noti' and open_yn= 'Y' and p.member_no = '20201000001'");
list.addSearch("title", f.get("s_title"), "LIKE");
list.setOrderBy(" d.reg_date desc ");

//목록 데이타 수정
DataSet rs = list.getDataSet();

while(rs.next()){
	rs.put("open_date",u.getTimeString("yyyy-MM-dd",rs.getString("open_date")));
	rs.put("reg_date",u.getTimeString("yyyy-MM-dd",rs.getString("reg_date")));
	if(rs.getString("reg_id").equals(auth.getString("_USER_ID"))){
		rs.put("open_detail", "M");
	}else{
		rs.put("open_detail", "V");
	}
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("center.noti_list");
p.setVar("menu_cd","000125");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( auth.getString("_MEMBER_NO"), auth.getString("_AUTH_CD"), _menu_cd, "btn_auth").equals("10"));
p.setVar("member_type", auth.getString("_MEMBER_TYPE"));
p.setLoop("list", rs);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("noti_seq"));
p.setVar("form_script", f.getScript());
p.setVar("noti_insert", sNotiInsert);
p.display(out);
%>