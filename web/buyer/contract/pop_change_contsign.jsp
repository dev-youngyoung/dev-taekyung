<%@page import="com.sun.mail.imap.Utility.Condition"%>
<%@page import="org.jsoup.Jsoup"%>
<%@page import="org.jsoup.nodes.Element"%>
<%@page import="org.jsoup.nodes.Document"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
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
		u.jsErrClose("계약 정보가 존재하지 않습니다.");
		return;
	}
	
	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find(" member_no = '"+member_no+"'");
	if(!member.next()){
		u.jsErrClose("회원 정보가 존재하지 않습니다.");
		return;
	}
	
	if("03".equals(member.getString("member_gubun"))){
		u.jsErrClose(" 개인회원이 아닙니다. 개인회원만 서명타입 전환이 가능합니다. ");
		return;
	}
	
	DataObject personDao = new DataObject("tcb_person");
	DataSet person = personDao.find("member_no = '"+member_no+"' and default_yn = 'Y' ");
	if(!person.next()){
		u.jsErrClose("회원 정보가 존재하지 않습니다.");
		return;
	}
	
	DataObject templateDao = new DataObject(" tcb_cont_template ");
	DataSet template = templateDao.find(" template_cd ='"+cont.getString("template_cd")+"' ", "doc_type");
	
	DB db = new DB();
	String cont_html_rm_str = removeSign(cont.getString("cont_html"));
	String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
	
	
	int file_seq = 1;
	
		// 계약서파일 생성
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
			u.jsErrClose("계약서 파일 생성에 실패 하였습니다.");
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
		
		SmsDao smsDao= new SmsDao();
		
		//SMS전송
		if(!cust.getString("hp2").equals("0000") && !cust.getString("hp1").equals("") && !cust.getString("hp2").equals("")){
			String mail_site = cust.getString("email").split("@")[1];
			String cust_name = auth.getString("_MEMBER_NAME");
			String subject = "농심 전자계약 안내";
			String message = "[전자계약][농심] " + auth.getString("_MEMBER_NAME") + " 안내\n"
					+ auth.getString("_MEMBER_NAME") + "에서 전자계약서 서명요청\n"
					+ "http://ecs.nongshim.com 접속 > 회원가입/로그인 후 계약진행";
			// smsDao.sendKakaoTalk
			// 서명요청(농심>을) B2B
			// B2C(모바일)에서 B2B(공인인증서이메일)로 전환된 것임
			smsDao.sendKakaoTalk(cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), "ESC-SD-0002", subject, message, message);
		}
		
		//이메일 전송
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
			if(member.getString("status").equals("02")){  // 비회원
				return_url = "web/buyer/member/join_agree.jsp";
			}else{  // 회원
				return_url =  "web/buyer/index.jsp";
			}
			
			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("send_member_name", auth.getString("_MEMBER_NAME"));
			mailInfo.put("cont_name", cont.getString("cont_name"));
			mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
			mailInfo.put("member_name", cust.getString("member_name"));
			p.setVar("info", mailInfo);
			p.setVar("server_name", Config.getWebUrl());
			p.setVar("return_url", return_url);
			p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+cust.getString("member_no")+"&num="+email_seq);
			String mail_body = p.fetch("../html/mail/cont_send_mail.html");
			u.mail(cust.getString("email"), "[나이스다큐] "+auth.getString("_MEMBER_NAME")+"에서 계약서 서명요청", mail_body );
		}
		
		if(!db.executeArray()){
			u.jsErrClose("계약서 서명 전환에 실패하였습니다.");
			return;
		}
	
		out.print("<script>");
		out.print(" alert('서명타입을 변경하였습니다. \\n서명 대상자는 로그인 후 서명이 가능합니다.'); ");
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

//input box 등을 제거
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);

	// PDF용
	for( Element elem : cont_doc.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box 값 모두 제거
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }
	cont_doc.select(".no_pdf").attr("style", "display:none"); // pdf 버전에 보여야 안되는것
	
	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
	
	return cont_html_rm;
}

%>
