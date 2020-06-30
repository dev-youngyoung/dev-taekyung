<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String item_cd = u.request("item_cd");

if(item_cd.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject dao = new DataObject("tcb_item_unit a");

DataSet ds = dao.find(
		"member_no = '"+_member_no+"' and item_cd = '"+item_cd+"' "
	  , "a.*, (select member_name from tcb_member where member_no = a.unit_member_no ) unit_member_name"
					);
int seq = 1;
while(ds.next()){
	ds.put("__ord",seq++);
	ds.put("unit_reg_date", u.getTimeString("yyyy-MM-dd", ds.getString("unit_reg_date")));
	ds.put("unit_amt", u.numberFormat(ds.getLong("unit_amt")));
}


if(u.isPost()&&f.validate()){
	DB db = new DB();
	
	db.setCommand("delete from tcb_item_unit where member_no='"+_member_no+"' and item_cd = '"+item_cd+"'", null);
	
	String[] unit_member_no = u.reqArr("unit_member_no");
	String[] unit_reg_date = u.reqArr("unit_reg_date");
	String[] unit_amt = u.reqArr("unit_amt");
	int cnt = unit_member_no==null?0: unit_member_no.length;
	
	for(int i = 0 ; i < cnt; i ++){
		dao = new DataObject("tcb_item_unit");
		dao.item("member_no", _member_no);
		dao.item("item_cd", item_cd);
		dao.item("seq", i+1);
		dao.item("unit_reg_date", unit_reg_date[i].replaceAll("-", ""));
		dao.item("unit_amt", unit_amt[i].replaceAll(",", ""));
		dao.item("unit_member_no", unit_member_no[i]);
		db.setCommand(dao.getInsertQuery(), dao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.","ifm_item_unit.jsp?"+u.getQueryString());
	return;
}


p.setLayout("blank");
//p.setDebug(out);
p.setBody("info.ifm_item_unit");
p.setLoop("unit", ds);
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString(""));
p.display(out);
%>