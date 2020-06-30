<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.Jsoup"%>
<%@ page import="org.jsoup.nodes.Document"%>
<%@ page import="org.jsoup.nodes.Element"%>
<%@ page import="org.jsoup.select.Elements"%>
<%

String asse_no = u.request("asse_no", "");
if(asse_no.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

boolean modify = true;
DataObject assessmentDao = new DataObject("tcb_assemaster a  inner join tcb_assedetail b on a.asse_no = b.asse_no and b.div_cd = 'E'");
DataSet assessment = assessmentDao.find(" a.asse_no = '"+asse_no+"'", "a.*, b.div_cd, b.asse_html, b.asse_subhtml, b.sub_point, b.status as dstatus");
if(!assessment.next()){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

if(u.isPost() && f.validate()){
	
	String email = f.get("email");
	String asseNo = f.get("asse_no");
	String div_cd = f.get("div_cd");	
	String ratingDate = f.get("date");
	String point = f.get("point");
	String rating = f.get("rating");
	String doc_html = new String(Base64Coder.decode(f.get("doc_html")),"UTF-8");;
		
	//���� ����
	p.clear();
	p.setVar("title", "������ ��� ");
	p.setVar("member_name", assessment.getString("member_name"));
	p.setVar("project_name", assessment.getString("project_name"));
	p.setVar("asse_year", assessment.getString("asse_year"));
	p.setVar("reg_date", u.getTimeString("yyyy-MM-dd"));
	//p.setVar("resultParam", u.aseEnc(asseNo));
	//p.setVar("img_url", webUrl+"/images/email/20110620/");
	//p.setVar("ret_url", webUrl+"/web/buyer/");
	//p.setVar("resultParam1", "E");
	p.setVar("server_name", request.getServerName());
	p.setVar("return_url", "web/buyer/cust/assessment_result.jsp?param="+u.aseEnc(asseNo)+"&param1=E");
	u.mail(email, "[������ ���] " +  assessment.getString("member_name") + " �� ����Դϴ�.", p.fetch("mail/assessment_mail.html"));
	u.jsAlertReplace("������� �Ͽ����ϴ�.","asse_purchase_list.jsp?"+u.getQueryString());
	return;
}

p.setLayout("cust");
//p.setDebug(out);
p.setBody("cust.assessment_s_checkSheet_new");
p.setVar("nevi","Ȩ &gt; �ŷ���ü���� &gt; ��ü �򰡰��� &gt; ��ü �򰡻�");
p.setVar("title_img","asse_chk_detail");
p.setVar("modify", modify);
p.setVar("assessment", assessment);
p.setVar("form_script", f.getScript());
p.display(out);
%>