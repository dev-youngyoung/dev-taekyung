<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_exam_status = {"00=>평가대상","10=>평가중","20=>평가완료"};

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("M",-3)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));

f.addElement("s_sdate",s_sdate, null);
f.addElement("s_edate",s_edate, null);
f.addElement("s_status",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable(
		" (                                                           "
				+" select a.cont_no                                            "
				+"      , a.cont_chasu                                         "
				+"      , a.cont_name                                          "
				+"      , a.cont_date                                          "
				+"      , b.member_name                                        "
				+"      , nvl(c.status,'00') status                            "
				+"      , (select user_name                                    "
				+"           from tcb_person                                   "
				+"          where member_no = a.member_no                      "
				+"            and user_id = c.exam_id) exam_user_name          "
				+"      , c.result_date                                        "
				+"      , to_number(c.result_point) result_point               "
				+"      , c.result_seq                                         "
				+"      , (select grade                                        "
				+"           from tcb_exam_result_grade                        "
				+"          where member_no = a.member_no                      "
				+"            and result_seq = c.result_seq                    "
				+"            and seq = c.grade_seq ) grade_name               "
				+"  from tcb_contmaster a                                      "
				+" inner join tcb_cust b                                       "
				+"    on a.cont_no = b.cont_no                                 "
				+"   and a.cont_chasu = b.cont_chasu                           "
				+"   and b.sign_seq = '2'                                      "
				+"  left outer join tcb_exam_result c                          "
				+"    on a.member_no = c.member_no                             "
				+"   and b.member_no = c.client_no                             "
				+"   and a.cont_no = c.cont_no                                 "
				+"   and a.cont_chasu = c.cont_chasu                           "
				+" where a.cont_chasu = (select max(cont_chasu) from tcb_contmaster where cont_no = a.cont_no) "
				+"   and a.status in ('50')                                    "
				+"   and a.member_no = '"+_member_no+"'                        "
				+"   ) x                        "
);
list.setFields("x.*");
if(!s_sdate.equals(""))list.addWhere(" x.cont_date >= '"+s_sdate.replaceAll("-","")+"' ");
if(!s_edate.equals(""))list.addWhere(" x.cont_date <= '"+s_edate.replaceAll("-","")+"' ");
list.addSearch("x.status",f.get("s_status"));
list.addSearch("x.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("x.member_name", f.get("s_cust_name"), "LIKE");
list.setOrderBy("x.cont_no desc, x.cont_date desc");

DataSet ds = list.getDataSet();
while(ds.next()){
	ds.put("link",ds.getString("result_seq").equals("")?"cont_exam_insert.jsp":"cont_exam_modify.jsp");
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
	ds.put("result_date", u.getTimeString("yyyy-MM-dd", ds.getString("result_date")));
	ds.put("status", u.getItem(ds.getString("status"), code_exam_status));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.cont_exam_list");
p.setVar("menu_cd","000100");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000100", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("code_exam_status", u.arr2loop(code_exam_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>