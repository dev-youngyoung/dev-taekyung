<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String member_no = u.request("member_no");
String seq = u.request("seq");
String vendcd = u.request("vendcd").replaceAll("-", "");
if(member_no.equals("")||seq.equals("")||vendcd.equals("")){
	return;
}

DataObject recruitDao = new DataObject("tcb_recruit");
DataSet recruit = recruitDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");
if(!recruit.next()){
	u.jsErrClose("모집공고 정보가 없습니다.");
	return;
}

DataObject categoryDao =  new DataObject("tcb_recruit_category");
DataSet category = categoryDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' ");

DataObject suppDao = new DataObject("tcb_recruit_supp");
DataSet supp = suppDao.find("member_no = '"+member_no+"' and seq = '"+seq+"' and vendcd = '"+vendcd+"' ");
if(!supp.next()){
	u.jsErrClose("신청정보가 없습니다.");
	return;
}

supp.put("vendcd", u.getBizNo(supp.getString("vendcd")));
supp.put("post_code1", supp.getString("post_code").substring(0, 3));
supp.put("post_code2", supp.getString("post_code").substring(3));


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

if(u.isPost()&&f.validate()){
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("cust.pop_recruit_view");
p.setVar("popup_title","협력업체 모집공고");
p.setVar("recruit", recruit);
p.setVar("supp", supp);
p.setLoop("category", category);
p.setLoop("client", client);
p.setLoop("item", item);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>