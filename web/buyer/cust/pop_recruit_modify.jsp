<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
String vendcd = u.request("vendcd").replaceAll("-", "");
if(member_no.equals("")||seq.equals("")||vendcd.equals("")){
	return;
}
String passwd3 = u.request("passwd3");

DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsErrClose("모집공고 정보가 없습니다.");
	return;
}

DataObject categoryDao =  new DataObject("tcb_recruit_category");
DataSet category = categoryDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");


if(recruit.getInt("s_date")>Integer.parseInt(u.getTimeString("yyyyMMdd"))|| recruit.getInt("e_date")<Integer.parseInt(u.getTimeString("yyyyMMdd"))){
	u.jsErrClose("모집기간이 아닙니다.");
	return;
}


DataObject suppDao = new DataObject("tcb_recruit_supp");
DataSet supp = suppDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ");
if(!supp.next()){
	u.jsErrClose("신청정보가 없습니다.");
	return;
}

if(!f.get("save").equals("1")){
	if(!supp.getString("passwd").equals(passwd3)){
		u.jsError("비밀번호가 일치 하지 않습니다.");
		return;
	}
}

supp.put("vendcd", u.getBizNo(supp.getString("vendcd")));
supp.put("post_code", supp.getString("post_code"));

DataObject suppCateDao = new DataObject("tcb_recruit_supp_category");
DataSet suppCate = suppCateDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ");
String categroy_cds = "";
while(suppCate.next()){
	if(!categroy_cds.equals("")) categroy_cds += ",";
	categroy_cds += suppCate.getString("code");
}
supp.put("category_cds", categroy_cds);

DataObject clientDao = new DataObject("tcb_recruit_client");
DataSet client = clientDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ");

DataObject itemDao = new DataObject("tcb_recruit_item");
DataSet item =  itemDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ");

f.addElement("vendnm", supp.getString("vendnm"), "hname:'업체명',required:'Y'");
f.addElement("boss_name", supp.getString("boss_name"), "hname:'대표자명',required:'Y'");
f.addElement("worker_cnt", u.numberFormat(supp.getLong("worker_cnt")), "hname:'종업원수',required:'Y'");
f.addElement("capital", u.numberFormat(supp.getLong("capital")), "hname:'자본금',required:'Y'");
f.addElement("sales_amt", u.numberFormat(supp.getLong("sales_amt")), "hname:'년매출액', required:'Y'");
f.addElement("post_code", supp.getString("post_code"), "hname:'우편번호',required:'Y', option:'number'");
f.addElement("address", supp.getString("address"), "hname:'주소', required:'Y'");
f.addElement("category_cd", supp.getString("category_cds"), "hname:'취급분야', required:'Y'");

f.addElement("user_name", supp.getString("user_name"), "hname:'담당자명',required:'Y'");
f.addElement("position", supp.getString("position"), "hname:'직책',requried:'Y'");
f.addElement("dept_name", supp.getString("dept_name"), "hname:'부서', required:'Y'");
f.addElement("hp1", supp.getString("hp1"), "hname:'휴대전화', required:'Y'");
f.addElement("hp2", supp.getString("hp2"), "hname:'휴대전화', required:'Y', minbyte:'3', maxbyte:'4'");
f.addElement("hp3", supp.getString("hp3"), "hname:'휴대전화', required:'Y', minbyte:'4', maxbyte:'4'");
f.addElement("tel_num", supp.getString("tel_num"), "hname:'전화번호', required:'Y'");
f.addElement("fax_num", supp.getString("fax_num"), "hname:'팩스'");
f.addElement("passwd", null, "hname:'비밀번호',required:'Y', match:'passwd2', minbyte:'4', mixbyte:'20'");

if(f.get("save").equals("1")){
	if(u.isPost()&&f.validate()){
		DB db = new DB();
		suppDao = new DataObject("tcb_recruit_supp");
		suppDao.item("vendnm", f.get("vendnm"));
		suppDao.item("boss_name", f.get("boss_name"));
		suppDao.item("post_code", f.get("post_code"));
		suppDao.item("address", f.get("address"));
		suppDao.item("capital", f.get("capital").replaceAll(",", ""));
		suppDao.item("sales_amt", f.get("sales_amt").replaceAll(",", ""));
		suppDao.item("worker_cnt", f.get("worker_cnt").replaceAll(",", ""));
		suppDao.item("user_name", f.get("user_name"));
		suppDao.item("position", f.get("position"));
		suppDao.item("dept_name", f.get("dept_name"));
		suppDao.item("tel_num", f.get("tel_num"));
		suppDao.item("hp1", f.get("hp1"));
		suppDao.item("hp2", f.get("hp2"));
		suppDao.item("hp3", f.get("hp3"));
		suppDao.item("fax_num", f.get("fax_num"));
		if(!f.get("passwd").equals("")){
			suppDao.item("passwd", f.get("passwd"));
		}
		suppDao.item("mod_date", u.getTimeString());
		db.setCommand(suppDao.getUpdateQuery("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' "), suppDao.record);
		
		db.setCommand("delete from tcb_recruit_supp_category where member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ", null);
		String[] cates = f.get("category_cds").split(",");
		for(int i = 0; i < cates.length ; i++){
			suppCateDao = new DataObject("tcb_recruit_supp_category");
			suppCateDao.item("member_no", member_no);
			suppCateDao.item("seq", seq);
			suppCateDao.item("vendcd", vendcd);
			suppCateDao.item("code", cates[i]);
			db.setCommand(suppCateDao.getInsertQuery(), suppCateDao.record);
		}
		
		
		db.setCommand("delete from tcb_recruit_client where member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ", null);
		String[] delivery_year = f.getArr("delivery_year");
		String[] client_name = f.getArr("client_name");
		String[] client_etc = f.getArr("client_etc");
		int client_cnt = client_name==null?0:client_name.length;
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
		
		db.setCommand("delete from tcb_recruit_item where member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ", null);
		String[] item_name = f.getArr("item_name");
		String[] item_etc = f.getArr("item_etc");
		int item_cnt = item_name==null?0:item_name.length;
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
			u.jsError("수정처리에 실패 하였습니다.\\n\\n고객센터로 문의하세요.");
			return;
		}
		u.jsErrClose("수정 하였습니다.");
		return;
	}
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_recruit_modify");
p.setVar("modify", true);
p.setVar("supp", supp);
p.setVar("popup_title", recruit.getString("title"));
p.setLoop("category", category);
p.setLoop("client", client);
p.setLoop("item", item);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>