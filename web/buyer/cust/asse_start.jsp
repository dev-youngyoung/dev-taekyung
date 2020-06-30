<%@ page import="org.jsoup.Jsoup,org.jsoup.nodes.Document,org.jsoup.nodes.Element,org.jsoup.select.Elements"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String asse_no = u.request("asse_no");
if(asse_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject asseDao = new DataObject("tcb_assemaster");
DataSet asse = asseDao.find("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' and status = '10'");
if(!asse.next()){
	u.jsError("�򰡰�ȹ ������ �����ϴ�.");
	return;
}

DataObject detailDao = new DataObject("tcb_assedetail");
DataSet detail = detailDao.find("asse_no = '"+asse_no+"' and div_cd = 'Q'");
if(detail.next()){
}




DB db = new DB();
asseDao = new DataObject("tcb_assemaster");
asseDao.item("status", "20");
asseDao.item("reg_id", auth.getString("_USER_ID"));
asseDao.item("reg_date", u.getTimeString());
db.setCommand(asseDao.getUpdateQuery("main_member_no = '"+_member_no+"' and asse_no = '"+asse_no+"' "), asseDao.record);


if(u.inArray(detail.getString("template_cd"), new String[]{"2017002","2017003"})){
	DataSet info = new DataSet();
	info.addRow();
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.query(
		 "select a.member_no, a.member_name, a.address, a.boss_name, a.vendcd,"
		+"       b.user_name, b.tel_num, b.hp1, b.hp2, b.hp3, b.email         "
		+"   from tcb_member a, tcb_person b                                  "
		+"  where a.member_no = b.member_no                                   "
		+"    and b.default_yn = 'Y'                                          "
		+"    and a.member_no = '"+asse.getString("member_no")+"'             "
			);
	if(member.next()){
		info.put("boss_name_2", member.getString("boss_name"));	
		info.put("user_name_2", member.getString("user_name"));	
	}
	DataSet bid = memberDao.query(
			 "select b.total_cost, b.cont_no                    "
			+"   from tcb_bid_master a, tcb_bid_supp b          "
			+" where a.main_member_no= b.main_member_no         "
			+"     and a.bid_no = b.bid_no                      "
			+"     and a.bid_deg = b.bid_deg                    "
			+"     and a.status = '07'                          "
			+"     and b.bid_succ_yn= 'Y'                       "
			+"     and a.main_member_no = '"+_member_no+"'      "
			+"     and a.bid_no = '"+asse.getString("bid_no")+"'"
			+"     and a.bid_deg = '"+asse.getString("bid_deg")+"'"
			 );
	if(bid.next()){
		info.put("cont_total", u.numberFormat(bid.getString("total_cost")) );
	}
	if(!bid.getString("cont_no").equals("")){
		DataObject contDao = new DataObject("tcb_contmaster");
		DataSet cont = contDao.find(
				 "     cont_no = '"+bid.getString("cont_no")+"'         "
				+" and cont_chasu = (                                   "
				+"		 select max(cont_chasu)                         "
				+"		   from tcb_contmaster                          "
				+"		  where cont_no = '"+bid.getString("cont_no")+"'"
				+"		 )"
				);
		if(cont.next()){
			info.put("cont_total", u.numberFormat(cont.getString("cont_total")));
			info.put("cont_year", u.getTimeString("yyyy", cont.getString("cont_date")));
			info.put("cont_month", u.getTimeString("MM", cont.getString("cont_date")));
			info.put("cont_day", u.getTimeString("dd", cont.getString("cont_date")));
			info.put("cont_syear", u.getTimeString("yyyy", cont.getString("cont_sdate")));
			info.put("cont_smonth", u.getTimeString("MM", cont.getString("cont_sdate")));
			info.put("cont_sday", u.getTimeString("dd", cont.getString("cont_sdate")));
			info.put("cont_eyear", u.getTimeString("yyyy", cont.getString("cont_edate")));
			info.put("cont_emonth", u.getTimeString("MM", cont.getString("cont_edate")));
			info.put("cont_eday", u.getTimeString("dd", cont.getString("cont_edate")));
		}
	}
	
	
	String asse_html = setHtmlValue(detail.getString("asse_html"), info);
	detailDao = new DataObject("tcb_assedetail");
	detailDao.item("asse_html", asse_html );
	db.setCommand(detailDao.getUpdateQuery("asse_no = '"+asse_no+"' and div_cd = 'Q' "), detailDao.record);
}


if(!db.executeArray()){
	u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
	return;
}

//sms, email�߼� ó��

u.jsAlertReplace("�򰡽��� ó�� �Ͽ����ϴ�.\\n\\n������ �޴����� �� ����ڰ� �򰡰� ���� �˴ϴ�.","asse_plan_list.jsp?"+u.getQueryString());

%>
<%!
//��Ŀ� �� ä���ֱ�
public String setHtmlValue(String html, DataSet info)
{
	String cont_html = "";

	// DB��
	Document cont_doc = Jsoup.parse(html);
	
	// input box �� ä���
	cont_doc.select("input[name=cont_syear]").attr("value", info.getString("cont_syear"));	// ���Ⱓ���۳�
	cont_doc.select("input[name=cont_smonth]").attr("value", info.getString("cont_smonth"));	// ���Ⱓ���ۿ�
	cont_doc.select("input[name=cont_sday]").attr("value", info.getString("cont_sday"));		// ���Ⱓ������
	cont_doc.select("input[name=cont_eyear]").attr("value", info.getString("cont_eyear"));	// ���Ⱓ�����
	cont_doc.select("input[name=cont_emonth]").attr("value", info.getString("cont_emonth"));	// ���Ⱓ�����
	cont_doc.select("input[name=cont_eday]").attr("value", info.getString("cont_eday"));		// ���Ⱓ������
	cont_doc.select("input[name=cont_total]").attr("value", info.getString("cont_total"));		// ����ݾ�
	cont_doc.select("input[name=finish_amt]").attr("value", info.getString("cont_total"));		// ����Ϸ�ݾ�
	
	// span���� �� �κ� �� ä���
	for( Element elem : cont_doc.select("span.boss_name_2") ){ elem.text(info.getString("boss_name_2")); }
	for( Element elem : cont_doc.select("span.user_name_2") ){ elem.text(info.getString("user_name_2")); }
	for( Element elem : cont_doc.select("span.cont_year") ){ elem.text(info.getString("cont_year")); }
	for( Element elem : cont_doc.select("span.cont_month") ){ elem.text(info.getString("cont_month")); }
	for( Element elem : cont_doc.select("span.cont_day") ){ elem.text(info.getString("cont_day")); }
	if(info.getString("cont_year").equals("")){
		if(cont_doc.getElementById("cont_date_area")!=null){
			cont_doc.getElementById("cont_date_area").remove();
		}
	}
	cont_html =cont_doc.getElementsByTag("body").html();
  	cont_html = "<script>\n"+cont_doc.getElementsByTag("script").html()+"</script>\n"+cont_html;
	return cont_html;
}

%>