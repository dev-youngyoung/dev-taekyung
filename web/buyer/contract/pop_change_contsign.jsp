<%@page import="com.sun.mail.imap.Utility.Condition"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  and member_no != '"+_member_no+"'");

if(cust.next()){
	
	String member_no =  cust.getString("member_no");		//f.get("member_no");
	String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
	
	ContractDao contDao = new ContractDao();
	DataSet cont = contDao.find(where);
	if(!cont.next()){
		u.jsErrClose("��� ������ �������� �ʽ��ϴ�.");
		return;
	}
	
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find(" member_no = '"+member_no+"'");
	if(!member.next()){
		u.jsErrClose("ȸ�� ������ �������� �ʽ��ϴ�.");
		return;
	}
	
	if("03".equals(member.getString("member_gubun"))){
		u.jsErrClose(" ����ȸ���� �ƴմϴ�. ����ȸ���� ����Ÿ�� ��ȯ�� �����մϴ�. ");
		return;
	}
	
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find("member_no = '"+member_no+"' and default_yn = 'Y' ");
	if(!person.next()){
		u.jsErrClose("ȸ�� ������ �������� �ʽ��ϴ�.");
		return;
	}
	
	DataObject templateDao = new DataObject(" tcb_cont_template ");
	DataSet template = templateDao.find(" template_cd ='"+cont.getString("template_cd")+"' ", "doc_type");
	
	DB db = new DB();
	String cont_html_rm_str = removeSign(cont.getString("cont_html"));
	String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
	
	
	int file_seq = 1;
	
		// ��༭���� ����
		DataSet pdfInfo = new DataSet();
		pdfInfo.addRow();
		pdfInfo.put("member_no",_member_no);
		pdfInfo.put("cont_no", cont_no);
		pdfInfo.put("cont_chasu", cont_chasu);
		pdfInfo.put("random_no", random_no);
		pdfInfo.put("cont_userno", cont.getString("cont_userno"));
		pdfInfo.put("html", removeHtml(cont_html_rm_str));
		pdfInfo.put("doc_type", template.getString("doc_type"));
		pdfInfo.put("file_seq", file_seq++);
		DataSet pdf = contDao.makePdf(pdfInfo);
		if(pdf==null){
			u.jsErrClose("��༭ ���� ������ ���� �Ͽ����ϴ�.");
			return;
		}
		
		DataObject cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("file_path", pdf.getString("file_path"));
		cfileDao.item("file_name", pdf.getString("file_name"));
		cfileDao.item("file_ext", pdf.getString("file_ext"));
		cfileDao.item("file_size", pdf.getString("file_size"));
		db.setCommand(cfileDao.getUpdateQuery(where + " and cfile_seq = 1 "), cfileDao.record);

		String file_hash = pdf.getString("file_hash");

		DataObject contSubDao = new DataObject("tcb_cont_sub");
		DataSet contSub = contSubDao.find(where);
		
		int subSeq = 1;
		while(contSub.next()){
			
			cfileDao = new DataObject("tcb_cfile");
			
			String cont_sub_html_rm_str = removeSign(contSub.getString("cont_sub_html"));
			
			DataSet pdfInfo2 = new DataSet();
			pdfInfo2.addRow();
			pdfInfo2.put("member_no",_member_no);
			pdfInfo2.put("cont_no", cont_no);
			pdfInfo2.put("cont_chasu", cont_chasu);
			pdfInfo2.put("html", removeHtml(cont_sub_html_rm_str));
			pdfInfo2.put("random_no", random_no);
			pdfInfo2.put("cont_userno", cont.getString("cont_userno"));
			pdfInfo2.put("doc_type", template.getString("doc_type"));
			pdfInfo2.put("file_seq", file_seq++);
			DataSet pdf2 = contDao.makePdf(pdfInfo2);

			contSubDao = new DataObject("tcb_cont_sub");
			contSubDao.item("cont_sub_html", cont_sub_html_rm_str);
			db.setCommand(contSubDao.getUpdateQuery(where + " and sub_seq = "+ subSeq++), contSubDao.record);
			
			cfileDao.item("file_path", pdf2.getString("file_path"));
			cfileDao.item("file_name", pdf2.getString("file_name"));
			cfileDao.item("file_ext", pdf2.getString("file_ext"));
			cfileDao.item("file_size", pdf2.getString("file_size"));
			db.setCommand(cfileDao.getUpdateQuery(where + " and cfile_seq = "+ (file_seq-1)), cfileDao.record);
			
			file_hash += "|"+pdf2.getString("file_hash");
		}
		
		contDao.item("sign_types","");
		contDao.item("cont_hash", file_hash);
		contDao.item("true_random",random_no);
		contDao.item("cont_html", cont_html_rm_str);
		custDao.item("jumin_no", person.getString("jumin_no"));
		//custDao.item("member_no", member_no);
		String email_random = u.getRandString(20);
		custDao.item("email_random", email_random);
	
		db.setCommand(contDao.getUpdateQuery(where), contDao.record);
		db.setCommand(custDao.getUpdateQuery(where + " and member_no != '"+_member_no+"' "),custDao.record);
		
		if(!u.inArray(cont.getString("template_cd"), new String[] {"2017021","2017023","2017024","2017025","2017048"})){//�Ѽ���ũ������ ������༭ ���� ����.

			SmsDao smsDao= new SmsDao();
			
			//SMS����
			if(!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
				String mail_site = cust.getString("email").split("@")[1];
				String cust_name = auth.getString("_MEMBER_NAME");
				if(member.getString("status").equals("02")){//��ȸ�� ������ ���
	                smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name+"���� ��༭ �����û-www.nicedocu.com(�Ϲݱ����)����>ȸ������ �� ���");
				}else{
					if(u.inArray(_member_no, new String[] {"20180101078","20180101074"})) {
						cust_name = "������";
					}
	                smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), cust_name+"���� ��༭ �����û-www.nicedocu.com(�Ϲݱ����)����>�α��� �� ���");
				}
			}
			
			//�̸��� ����
			if(!cust.getString("email").equals("")){
				DataObject contEmailDao = new DataObject("tcb_cont_email");
				String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cust.getString("member_no")+"' ");
				contEmailDao.item("cont_no", cont_no);
				contEmailDao.item("cont_chasu", cont_chasu);
				contEmailDao.item("member_no", member_no);
				contEmailDao.item("email_seq", email_seq);
				contEmailDao.item("send_date", u.getTimeString());
				contEmailDao.item("user_name", cust.getString("user_name"));
				contEmailDao.item("email", cust.getString("email"));
				contEmailDao.item("status", "01");
				
				db.setCommand(contEmailDao.getInsertQuery(),contEmailDao.record);
				
				String return_url = "";
				if(member.getString("status").equals("02")){  // ��ȸ��
					return_url = "web/buyer/member/join_agree.jsp";
				}else{  // ȸ��
					return_url =  "web/buyer/index.jsp";
				}
				
				DataSet mailInfo = new DataSet();
				mailInfo.addRow();
				mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
				mailInfo.put("cont_name", cont.getString("cont_name"));
				mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
				mailInfo.put("member_name", cust.getString("member_name"));
				p.setVar("info", mailInfo);
				p.setVar("server_name", request.getServerName());
				p.setVar("return_url", return_url);
				p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
				String mail_body = p.fetch("../html/mail/cont_send_mail.html");
				u.mail(cust.getString("email"), "[���̽���ť] "+auth.getString("_MEMBER_NAME")+"���� ��༭ �����û", mail_body );
			}
		}
		
		if(!db.executeArray()){
			u.jsErrClose("��༭ ���� ��ȯ�� �����Ͽ����ϴ�.");
			return;
		}
	
		out.print("<script>");
		out.print(" alert('����Ÿ���� �����Ͽ����ϴ�. \\n���� ����ڴ� �α��� �� ������ �����մϴ�.'); ");
		out.print(" window.opener.location.href='./contract_sendview.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+cont_chasu+"' ; ");
		out.print(" self.close(); ");
		out.print("</script>");
		return; 

	}

 
%>


<%!

public String removeSign(String html){
	String cont_html_rm = "";
	Document cont_doc = Jsoup.parse(html);
	cont_doc.select(".sign_area").attr("style", "display:none");
	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
	return cont_html_rm;
}

//input box ���� ����
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB��
	Document cont_doc = Jsoup.parse(html);

	// PDF��
	for( Element elem : cont_doc.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box �� ��� ����
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }
	cont_doc.select(".no_pdf").attr("style", "display:none"); // pdf ������ ������ �ȵǴ°�
	
	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
	
	return cont_html_rm;
}

%>
