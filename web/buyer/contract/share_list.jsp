<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");

String s_sdate = u.request("s_sdate",u.getTimeString("yyyy-MM-dd",u.addDate("Y",-1)));
String s_edate = u.request("s_edate",u.getTimeString("yyyy-MM-dd"));


f.addElement("s_sdate", s_sdate, null);
f.addElement("s_edate", s_edate, null);
f.addElement("s_status",null, null);
f.addElement("s_cont_name",null, null);
f.addElement("s_cust_name",null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_contmaster a, tcb_cust b , tcb_share c");
list.setFields(
		 "  a.cont_no, a.cont_chasu, a.cont_name, a.cont_date, a.status "
		+", b.member_no, b.member_name "
		+", c.seq, c.send_user_name, c.send_date, c.recv_field_name, c.recv_user_id, c.recv_user_name, c.recv_date"
		+", ( SELECT  COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt  "
		);
list.addWhere("a.cont_no = b.cont_no");
list.addWhere("a.cont_chasu = b.cont_chasu");
list.addWhere("a.cont_no = c.cont_no");
list.addWhere("a.cont_chasu = c.cont_chasu");
list.addWhere("b.list_cust_yn = 'Y'" );
list.addWhere(" a.member_no = '"+_member_no+"' ");
list.addWhere(" ( c.recv_field_seq = '"+auth.getString("_FIELD_SEQ")+"' or  c.recv_user_id = '"+auth.getString("_USER_ID")+"') ");
list.addWhere(" a.status <> '00' ");
list.addWhere(" c.status > 0 ");

if(!s_sdate.equals("")) {
	list.addWhere(" a.cont_date >= '"+s_sdate.replaceAll("-","")+"'");
}
if(!s_edate.equals("")) {
	list.addWhere(" a.cont_date <= '"+s_edate.replaceAll("-","")+"'");
}

list.addSearch("a.cont_name", f.get("s_cont_name"), "LIKE");
list.addSearch("b.member_name",  f.get("s_cust_name"), "LIKE");
list.addSearch("a.status",  f.get("s_status"));
list.setOrderBy(" c.send_date desc, a.cont_date desc, a.cont_no desc, a.cont_chasu desc");

DataSet ds = list.getDataSet();
while(ds.next()){
    ds.put("cont_no", u.aseEnc(ds.getString("cont_no")));
	if(ds.getInt("cont_chasu")>0){
		ds.put("cont_name", "<img src='../html/images/re.jpg' align='absmiddle'> " +ds.getString("cont_name") + " ("+ds.getString("cont_chasu")+"차)");
	}
	if(ds.getInt("cust_cnt")-2>0){
		ds.put("cust_name", ds.getString("member_name")+ "외"+(ds.getInt("cust_cnt")-2)+"개사");
	}else{
		ds.put("cust_name", ds.getString("member_name"));
	}
	ds.put("status", u.getItem(ds.getString("status"), code_status));
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd",ds.getString("cont_date")));
	ds.put("send_date", u.getTimeString("yyyy-MM-dd HH:mm",ds.getString("send_date")));
	ds.put("recv_date", ds.getString("recv_date").equals("")?"<span style='color:red'>미확인</span>":u.getTimeString("yyyy-MM-dd HH:mm",ds.getString("recv_date")));
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.share_list");
p.setVar("menu_cd","000077");
p.setLoop("code_status", u.arr2loop(code_status));
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu,share_seq"));
p.setVar("form_script", f.getScript());
p.display(out);
%>
