<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");

DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsErrClose("모집공고 정보가 없습니다.");
	return;
}
if(recruit.getInt("s_date")>Integer.parseInt(u.getTimeString("yyyyMMdd"))|| recruit.getInt("e_date")<Integer.parseInt(u.getTimeString("yyyyMMdd"))){
	u.jsErrClose("모집기간이 아닙니다.");
	return;
}

DataObject categoryDao =  new DataObject("tcb_recruit_category");
DataSet category = categoryDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");


f.addElement("vendcd1", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'3' ");
f.addElement("vendcd2", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'2'");
f.addElement("vendcd3", null, "hname:'사업자등록번호', required:'Y',option:'number',fixbyte:'5'");
f.addElement("vendnm", null, "hname:'업체명',required:'Y'");
f.addElement("boss_name", null, "hname:'대표자명',required:'Y'");
f.addElement("worker_cnt", null, "hname:'종업원수',required:'Y'");
f.addElement("capital", null, "hname:'자본금',required:'Y'");
f.addElement("sales_amt", null, "hname:'년매출액', required:'Y'");
f.addElement("post_code1", null, "hname:'우편번호',required:'Y', option:'number'");
f.addElement("post_code2", null, "hname:'우편번호',required:'Y', option:'number'");
f.addElement("address", null, "hname:'주소', required:'Y'");
f.addElement("category_cds", null, "hname:'취급분야', required:'Y'");

f.addElement("user_name", null, "hname:'담당자명',required:'Y'");
f.addElement("position", null, "hname:'직위',requried:'Y'");
f.addElement("dept_name", null, "hname:'부서', required:'Y'");
f.addElement("hp1", null, "hname:'휴대전화', required:'Y'");
f.addElement("hp2", null, "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", null, "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("tel_num", null, "hname:'전화번호', required:'Y'");
f.addElement("fax_num", null, "hname:'팩스'");
f.addElement("passwd", null, "hname:'비밀번호',required:'Y', match:'passwd2', minbyte:'4', mixbyte:'20'");

if(u.isPost()&&f.validate()){
	DB db = new DB();
	String vendcd = f.get("vendcd1")+f.get("vendcd2")+f.get("vendcd3");
	DataObject suppDao = new DataObject("tcb_recruit_supp");
	suppDao.item("member_no", member_no);
	suppDao.item("seq", seq);
	suppDao.item("vendcd", vendcd);
	suppDao.item("vendnm", f.get("vendnm"));
	suppDao.item("boss_name", f.get("boss_name"));
	suppDao.item("post_code", f.get("post_code1")+f.get("post_code2"));
	suppDao.item("address", f.get("address"));
	suppDao.item("capital", f.get("capital"));
	suppDao.item("sales_amt", f.get("sales_amt"));
	suppDao.item("worker_cnt", f.get("worker_cnt").replaceAll(",", ""));
	suppDao.item("user_name", f.get("user_name"));
	suppDao.item("position", f.get("position"));
	suppDao.item("dept_name", f.get("dept_name"));
	suppDao.item("tel_num", f.get("tel_num"));
	suppDao.item("hp1", f.get("hp1"));
	suppDao.item("hp2", f.get("hp2"));
	suppDao.item("hp3", f.get("hp3"));
	suppDao.item("fax_num", f.get("fax_num"));
	suppDao.item("passwd", f.get("passwd"));
	suppDao.item("reg_date", u.getTimeString());
	suppDao.item("status", "10");
	db.setCommand(suppDao.getInsertQuery(), suppDao.record);
	
	DataObject suppCateDao = null;
	String[] cates = f.get("category_cds").split(",");
	for(int i = 0; i < cates.length ; i++){
		suppCateDao = new DataObject("tcb_recruit_supp_category");
		suppCateDao.item("member_no", member_no);
		suppCateDao.item("seq", seq);
		suppCateDao.item("vendcd", vendcd);
		suppCateDao.item("code", cates[i]);
		db.setCommand(suppCateDao.getInsertQuery(), suppCateDao.record);
	}
	
	String[] delivery_year = f.getArr("delivery_year");
	String[] client_name = f.getArr("client_name");
	String[] client_etc = f.getArr("client_etc");
	int client_cnt = client_name==null?0:client_name.length;
	DataObject clientDao = null;
	for(int i=0 ; i < client_cnt; i++){
		clientDao = new DataObject("tcb_recruit_client");
		clientDao.item("member_no", member_no);
		clientDao.item("seq", seq);
		clientDao.item("vendcd", vendcd);
		clientDao.item("client_seq", i+1);
		clientDao.item("delivery_year", delivery_year[i]);
		clientDao.item("client_name", client_name[i]);
		clientDao.item("etc", client_etc[i]);
		db.setCommand(clientDao.getInsertQuery(), clientDao.record);
	}
	
	String[] item_name = f.getArr("item_name");
	String[] item_etc = f.getArr("item_etc");
	int item_cnt = item_name==null?0:item_name.length;
	DataObject itemDao = null;
	for(int i=0 ; i < item_cnt; i++){
		itemDao = new DataObject("tcb_recruit_item");
		itemDao.item("member_no", member_no);
		itemDao.item("seq", seq);
		itemDao.item("vendcd", vendcd);
		itemDao.item("item_seq", i+1);
		itemDao.item("item_name", item_name[i]);
		itemDao.item("etc", item_etc[i]);
		db.setCommand(itemDao.getInsertQuery(), itemDao.record);
	}
	
	
	if(!db.executeArray()){
		u.jsError("신청처리에 실패 하였습니다.\\n\\n고객센터로 문의하세요.");
		return;
	}
	u.jsErrClose("신청처리 하였습니다.");
	return;
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("cust.pop_recruit_modify");
p.setVar("popup_title", recruit.getString("title"));
p.setLoop("category", category);
p.setVar("recruit", recruit);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>