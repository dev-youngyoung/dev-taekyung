<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>작성중","20=>확정"};


f.addElement("s_yyyymm", null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(10);
list.setTable("tcb_samsong_evaluate a");
list.setFields(" a.*, (select count(*) from tcb_samsong_evaluate_supp where yyyymm = a.yyyymm) as partner_cnt ");
list.addSearch(" a.yyyymm", f.get("s_yyyymm"), "LIKE");
list.setOrderBy("a.yyyymm desc ");

//목록 데이타 수정
DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("yyyymm_str", ds.getString("yyyymm").substring(0,4) + "-" + ds.getString("yyyymm").substring(4,6));
    ds.put("mod_date", u.getTimeString("yyyy-MM-dd", ds.getString("mod_date")));
    ds.put("status_nm", u.getItem(ds.getString("status"), code_status));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.samsong_evaluate_list");
p.setVar("menu_cd","000184");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000082", "btn_auth").equals("10"));
p.setVar("auth_form", false);
p.setLoop("list", ds);
p.setVar("list_query", u.getQueryString("pre_yyyymm"));
p.setVar("pagerbar", list.getPaging());
p.setVar("form_script",f.getScript());
p.display(out);
%>