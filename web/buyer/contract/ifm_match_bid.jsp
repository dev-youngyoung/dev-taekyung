<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String supp_member_no = u.request("supp_member_no");
String type = u.request("type");
if(bid_no.equals("")||bid_deg.equals("")){
	return;
}

String where = "main_member_no = '"+_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' ";
DataObject bidDao = new DataObject("tcb_bid_master a");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where, "a.* , (select project_name from tcb_project where member_no = '"+_member_no+"' and project_seq = a.project_seq ) as project_name ");
if(!bid.next()){
	return;
}


String etc = "";


//금액정보
DataObject suppDao = new DataObject("tcb_bid_supp");
DataSet supp = new DataSet();;
//suppDao.setDebug(out);
if(bid.getString("succ_method").equals("03") || bid.getString("succ_method").equals("06")) // 협상에 의한 낙찰가격 결정
{
	if(bid.getString("vat_yn").equals("Y")){
		String nego_amt = bid.getString("nego_amt");
		supp = suppDao.find(where+" and bid_succ_yn='Y' and member_no = '"+supp_member_no+"' ", nego_amt+" cont_total, floor("+ nego_amt+"*(10/11)) supp_tax, "+ nego_amt+" - floor("+ nego_amt+"*(10/11)) supp_vat " );
	}else{
		String nego_amt = bid.getString("nego_amt");
		supp = suppDao.find(where+" and bid_succ_yn='Y' and member_no = '"+supp_member_no+"' ", nego_amt+"+FLOOR("+nego_amt+"/10) cont_total, "+nego_amt+" supp_tax, FLOOR("+nego_amt+"/10) supp_vat");	
	}
	
}
else
{
	if(bid.getString("vat_yn").equals("Y")){
		supp = suppDao.find(where+" and bid_succ_yn='Y' and member_no = '"+supp_member_no+"'"," total_cost cont_total,  floor(total_cost*(10/11)) supp_tax, total_cost - floor(total_cost*(10/11)) supp_vat ");
	}else{
		supp = suppDao.find(where+" and bid_succ_yn='Y' and member_no = '"+supp_member_no+"'"," total_cost+FLOOR(total_cost/10) cont_total, total_cost supp_tax, FLOOR(total_cost/10) supp_vat");
	}
}
if(supp.next()){
	etc+="<input type=\"hidden\" name=\"cont_total\" value=\""+u.numberFormat(supp.getString("cont_total"))+"\"> \n";
	etc+="<input type=\"hidden\" name=\"supp_tax\" value=\""+u.numberFormat(supp.getString("supp_tax"))+"\"> \n";
	etc+="<input type=\"hidden\" name=\"supp_vat\" value=\""+u.numberFormat(supp.getString("supp_vat"))+"\"> \n";
}
etc+="<input type=\"hidden\"  name=\"bid_name\" value=\""+ bid.getString("bid_name")+"\"> \n";
etc+="<input type=\"hidden\"  name=\"project_name_area\" value=\""+ bid.getString("project_name")+"\"> \n";
etc+="<input type=\"hidden\"  name=\"bid_no_deg\" value=\""+ bid.getString("bid_no")+"-"+bid.getString("bid_deg")+"\"> \n";
etc+="<input type=\"hidden\"  name=\"bid_method\" value=\""+ bid.getString("bid_method")+"\"> \n";


//추가 정보

if(u.inArray(_member_no, new String[]{"20120500023"})){
etc+="<input type='hidden' name='bid_name' value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"' > \n";
etc+="<script>parent.document.forms['form1']['cont_name'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
long div_amt = supp.getLong("cont_total")/10;
etc+="<script>parent.payment_grid.delRow(1);parent.payment_grid.delRow(1);parent.payment_grid.delRow(1);</script> \n";
	for(int i = 1 ; i<= 4; i ++ ){
		String field_name = "etc"+i;
		if(!bid.getString(field_name).equals("")&&field_name.equals("etc1")){
			etc+="<script>parent.setPay('계약금','"+ u.numberFormat((long)Math.floor((supp.getLong("supp_tax")*bid.getLong(field_name))*0.01))+"','/체결 (00)일 이내 청구/(00)일 이내 현급지급');</script> \n";
		}
		if(!bid.getString(field_name).equals("")&&field_name.equals("etc2")){
			etc+="<script>parent.setPay('중도금(1차)','"+ u.numberFormat((long)Math.floor((supp.getLong("supp_tax")*bid.getLong(field_name))*0.01))+"','/목적물 입고후시/(00)일 이내 현금지급');</script> \n";
		}
		if(!bid.getString(field_name).equals("")&&field_name.equals("etc3")){
			etc+="<script>parent.setPay('중도금(2차)','"+ u.numberFormat((long)Math.floor((supp.getLong("supp_tax")*bid.getLong(field_name))*0.01))+"','/목적물 검수후시/(00)일 이내 현금지급');</script> \n";
		}
		if(!bid.getString(field_name).equals("")&&field_name.equals("etc4")){
			etc+="<script>parent.setPay('잔금','"+ u.numberFormat((long)Math.floor((supp.getLong("supp_tax")*bid.getLong(field_name))*0.01))+"','/체결 (00)일 이내 청구/(00)일 이내 현급지급');</script> \n";
		}
	}
}else if(u.inArray(_member_no, new String[]{"20151101243"})){//NH개발
	etc+="<input type='hidden' name='bid_name' value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"' > \n";
	etc+="<script>parent.document.forms['form1']['cont_name'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
	etc+="<script>parent.document.forms['form1']['cont_name_str'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
	etc+="<script>parent.replaceInput('"+bid.getString("bid_name").replaceAll("'","&#39;")+"', 'cont_name', document.all.__html);</script> \n";
}else if(u.inArray(_member_no, new String[]{"20121200116"})){//한국제지
	etc+="<input type='hidden' name='bid_name' value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"' > \n";
	etc+="<script>parent.document.forms['form1']['cont_name'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
	etc+="<script>parent.replaceInput('"+bid.getString("bid_name").replaceAll("'","&#39;")+"', 'cont_name', document.all.__html);</script> \n";
	etc+="<script>parent.document.forms['form1']['bid_user_no'].value='"+bid.getString("user_no")+"';</script> \n";
}else if(u.inArray(_member_no, new String[]{"20160901598"})){//NH투자증권
	etc+="<input type='hidden' name='bid_name' value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"' > \n";
	etc+="<script>parent.document.forms['form1']['cont_name'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
	etc+="<script>if(parent.document.forms['form1']['cont_name_str'])parent.document.forms['form1']['cont_name_str'].value='"+bid.getString("bid_name").replaceAll("'","&#39;")+"';</script> \n";
	etc+="<script>parent.replaceInput('"+bid.getString("bid_name").replaceAll("'","&#39;")+"', 'cont_name', document.all.__html);</script> \n";
}else{
	for(int i = 1 ; i<= 4; i ++ ){
		String field_name = "etc"+i;
		if(bid.getString(field_name).equals("")){
			etc+="<input type=\"hidden\" name=\""+field_name+"\" value=\""+bid.getString(field_name)+"\"> \n";
		}
	}
}


//if(!type.equals("cont")){
	bid.put("bid_html", bid.getString("bid_html")+etc);
//}
if(bid.getString("bid_html").equals("")){
	return;
}



p.setLayout("blank");
//p.setDebug(out);
p.setBody("contract.ifm_match_bid");
p.setVar("_html", bid.getString("bid_html"));
p.display(out);
%>