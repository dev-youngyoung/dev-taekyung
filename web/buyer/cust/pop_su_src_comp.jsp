<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String	src_cd	= u.request("src_cd");
String	sLSrcNm	= u.request("l_src_nm");
String	sMSrcNm	= u.request("m_src_nm");
String	sSSrcNm	= u.request("s_src_nm");

f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);

//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable("tcb_member a \n"+
							",(select distinct client_no \n"+
							"    from tcb_client \n"+
							"		where member_no = '"+_member_no+"') b \n");
list.setFields("a.*");
list.addWhere(" a.member_no = b.client_no \n");
list.addWhere(" a.member_type in ('02','03') \n");
list.addWhere(" lower(a.member_name) like lower('%" + f.get("s_member_name") + "%')");
list.addWhere(" member_no not in (select src_member_no from tcb_src_member where member_no='"+_member_no+"' and src_cd='"+src_cd+"') ");
list.addSearch("a.vendcd", f.get("s_vendcd"));
list.setOrderBy("a.member_name asc ");

DataSet ds = null;
//목록 데이타 수정
ds = list.getDataSet();
while(ds.next()){
	ds.put("vendcd2",ds.getString("vendcd"));
	ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
}

if(u.request("mode").equals("save")){
	DB db = new DB();
	//db.setDebug(out);
	DataObject srcDao = new DataObject("tcb_src_member");
	srcDao.item("member_no", _member_no);
	srcDao.item("src_member_no", f.get("member_no"));
	srcDao.item("src_cd", f.get("src_cd"));
	db.setCommand(srcDao.getInsertQuery(),srcDao.record);

	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	out.print("<script>opener.loadDetailData();</script>");
	u.jsAlertReplace("저장 되었습니다.", "./pop_su_src_comp.jsp?"+u.getQueryString("mode"));
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_su_src_comp");
p.setVar("popup_title","업체검색");
p.setVar("src_cd",src_cd);
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("cate", sLSrcNm + " &gt; " + sMSrcNm + " &gt; " + sSSrcNm);
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>