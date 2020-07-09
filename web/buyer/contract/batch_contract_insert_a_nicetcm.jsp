 <%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element
				,java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String template_cd = u.request("template_cd"); 
String reg_id = auth.getString("_USER_ID");

int loop_cnt=0;

String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}

Security security = new	Security();

DataSet data = u.grid2dataset(grid);
data.first();

//작성자 정보
DataObject memberDao = new DataObject("tcb_member");
DataObject personDao = new DataObject("tcb_person");

DataSet w_member = memberDao.find(" member_no = '"+_member_no+"'  ");
if(!w_member.next()){
	out.println("0");
	return;
}
DataSet w_person = personDao.find(" member_no = '"+_member_no+"' and user_id = '"+reg_id+"'  ");
if(!w_person.next()){
	out.println("0");
	return;
}

//서식 정보
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find(" template_cd = '"+template_cd+"' ");
if(!template.next()){
	out.println("0");
	return;
}

DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub = templateSubDao.find("template_cd = '"+template_cd+"' ","*"," sub_seq asc");

DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet signTemplate = signTemplateDao.find("template_cd = '"+template_cd+"' ","*"," sign_seq asc");

String error_message = "";

try {
	while(data.next()){

		DataSet r_member  = new DataSet();
		r_member.addRow();
		r_member.put("member_no", Util.strrpad("1", 11, "0"));
		r_member.put("member_name", data.getString("member_name"));
		r_member.put("address", data.getString("address"));
		r_member.put("boss_name", data.getString("member_name"));
		r_member.put("tel_num", data.getString("tel_num"));

		DataSet r_person  = new DataSet();
		r_person.addRow();
		r_person.put("user_name", data.getString("member_name"));
		r_person.put("hp1", data.getString("hp1"));
		r_person.put("hp2", data.getString("hp2"));
		r_person.put("hp3", data.getString("hp3"));
		r_person.put("email", data.getString("email"));
		r_person.put("birth_date", data.getString("birth_date"));

		/*계약서 html생성 시작*/
		String cont_html = setHtmldata( template.getString("template_html"), w_member, w_person,r_member,r_person,data, template_cd); 
		String cont_html_rm = removeHtml(cont_html); 
		 
		
		ContractDao contDao = new ContractDao();
		String cont_no = contDao.makeContNo();
		String cont_chasu = "0";
		String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
		String cont_userno = data.getString("cont_userno");
		ArrayList autoFiles = new ArrayList();

		int file_seq = 1;

		// 계약서 갑지 파일 생성
		DataSet pdfInfo = new DataSet();
		pdfInfo.addRow();
		pdfInfo.put("member_no",w_member.getString("member_no"));
		pdfInfo.put("cont_no", cont_no);
		pdfInfo.put("cont_chasu", cont_chasu);
		pdfInfo.put("random_no", random_no);
		pdfInfo.put("cont_userno", cont_userno);
		pdfInfo.put("html", cont_html_rm);
		pdfInfo.put("doc_type", template.getString("doc_type"));
		pdfInfo.put("file_seq", file_seq++);
		DataSet pdf = contDao.makePdf(pdfInfo);
		if(pdf==null){
			error_message += "ERROR => 생년월일:"+data.getString("birth_date")+" 이름: "+data.getString("member_name")+" (계약서파일생성실패.)";
			continue;
		}
 
		//서브서식 pdf파일 생성
		templateSub.first();
		while(templateSub.next()){
			String cont_gubun = templateSub.getString("gubun");
			String cont_option_yn = templateSub.getString("option_yn");
			String cont_sub_html = setHtmldata(templateSub.getString("template_html"), w_member, w_person, r_member, r_person, data, template_cd);
			templateSub.put("cont_sub_html", cont_sub_html);
   
			if(    cont_gubun.equals("20")
					|| ( cont_gubun.equals("30") )
					|| ( cont_gubun.equals("40") && (cont_option_yn.equals("A") || (cont_option_yn.equals("Y") ))) // 자동으로 생성되는 양식 또는 체크된 양식인 경우
					)
			{
				String cont_sub_html_rm = removeHtml(cont_sub_html);
				DataSet pdfInfo2 = new DataSet();
				pdfInfo2.addRow();
				pdfInfo2.put("member_no", w_member.getString("member_no"));
				pdfInfo2.put("cont_no", cont_no);
				pdfInfo2.put("cont_chasu", cont_chasu);
				pdfInfo2.put("random_no", random_no);
				pdfInfo2.put("cont_userno", cont_userno);
				pdfInfo2.put("cont_sub_html", cont_sub_html);
				pdfInfo2.put("doc_type", template.getString("doc_type"));
				pdfInfo2.put("html", cont_sub_html_rm);															

				pdfInfo2.put("file_seq", file_seq++);
				DataSet pdf2 = contDao.makePdf(pdfInfo2);
				pdf2.put("cont_sub_name", templateSub.getString("template_name"));
				pdf2.put("gubun", templateSub.getString("gubun"));
				autoFiles.add(pdf2);
			}
		} 
		 
			
		System.out.println("--------db start -------------");

		DB db = new DB();
 
	 	String cont_name = u.getTimeString("yyyy")+"년 "+template.getString("template_name") + "_" + data.getString("member_name") ; 

		contDao.item("cont_no", cont_no);
		contDao.item("cont_chasu", cont_chasu);
		contDao.item("member_no", w_member.getString("member_no"));
		contDao.item("field_seq", w_person.getString("field_seq"));
		contDao.item("template_cd", template_cd);
		contDao.item("cont_name", cont_name);
		contDao.item("cont_date", data.getString("cont_date").replaceAll("-", "") );
		contDao.item("cont_sdate", data.getString("cont_sdate").replaceAll("-", ""));
		contDao.item("cont_edate", data.getString("cont_edate").replaceAll("-", ""));
		contDao.item("supp_tax", "");
		contDao.item("supp_taxfree", "");
		contDao.item("supp_vat", ""); 
		contDao.item("cont_total", data.getString("cont_total").replaceAll(",", ""));
		contDao.item("cont_userno", cont_userno);
		contDao.item("cont_html", cont_html);
		contDao.item("org_cont_html", cont_html);
		contDao.item("reg_date", u.getTimeString());
		contDao.item("true_random", random_no);
		contDao.item("reg_id", reg_id);
		contDao.item("status", "20");
		contDao.item("sign_types", template.getString("sign_types"));
		contDao.item("version_seq", template.getString("version_seq"));
		contDao.item("src_cd", "");
		contDao.item("efile_yn", template.getString("efile_yn").equals("Y")?"Y":"N");
		contDao.item("batch_grp_cd", "00");
		
		db.setCommand(contDao.getInsertQuery(), contDao.record);
		System.out.println("--------11-------------");
		templateSub.first();
		DataObject contSubDao = null;
		while(templateSub.next()){
			contSubDao = new DataObject("tcb_cont_sub");
			contSubDao.item("cont_no", cont_no);
			contSubDao.item("cont_chasu", cont_chasu);
			contSubDao.item("sub_seq", templateSub.getString("sub_seq"));
			contSubDao.item("cont_sub_html",templateSub.getString("cont_sub_html"));
			contSubDao.item("org_cont_sub_html",templateSub.getString("cont_sub_html"));
			contSubDao.item("cont_sub_name", templateSub.getString("template_name"));
			contSubDao.item("cont_sub_style",templateSub.getString("templte_style"));
			contSubDao.item("gubun", templateSub.getString("gubun"));
			 
			if(templateSub.getString("option_yn").equals("A")){
				contSubDao.item("option_yn", "A");
			}else{
				contSubDao.item("option_yn", templateSub.getString("option_yn").equals("Y")? "Y" : "N");	
			} 
			  
			db.setCommand(contSubDao.getInsertQuery(), contSubDao.record);
		}
		System.out.println("--------22-------------");
		// 서명 서식 저장
		signTemplate.first();
		while(signTemplate.next()){
			if(signTemplate.getString("cust_type").equals("01")) w_member.put("sign_seq", signTemplate.getString("sign_seq"));
			if(signTemplate.getString("cust_type").equals("02")) r_member.put("sign_seq", signTemplate.getString("sign_seq"));
			DataObject contSignDao = new DataObject("tcb_cont_sign");
			contSignDao.item("cont_no",cont_no);
			contSignDao.item("cont_chasu",cont_chasu);
			contSignDao.item("sign_seq", signTemplate.getString("sign_seq"));
			contSignDao.item("signer_name", signTemplate.getString("signer_name"));
			contSignDao.item("signer_max", signTemplate.getString("signer_max"));
			contSignDao.item("member_type", signTemplate.getString("member_type"));  // 01:나이스와 계약한 업체 02:나이스 미계약업체
			contSignDao.item("cust_type", signTemplate.getString("cust_type"));      // 01:갑 02:을
			db.setCommand(contSignDao.getInsertQuery(), contSignDao.record);
		}
		System.out.println("--------33-------------");
		//결제라인 저장


		//작업업체저장
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",w_member.getString("member_no"));
		custDao.item("sign_seq", w_member.getString("sign_seq"));
		custDao.item("cust_gubun", "01");  //01:사업자 02:개인
		custDao.item("vendcd", w_member.getString("vendcd"));
		custDao.item("member_name", w_member.getString("member_name"));
		custDao.item("boss_name", w_member.getString("boss_name"));
		custDao.item("post_code", w_member.getString("post_code").replaceAll("-",""));
		custDao.item("address", w_member.getString("address"));
		custDao.item("member_slno", w_member.getString("member_slno"));
		custDao.item("tel_num", w_person.getString("tel_num"));
		custDao.item("user_name", w_person.getString("user_name"));
		custDao.item("hp1", w_person.getString("hp1"));
		custDao.item("hp2", w_person.getString("hp2"));
		custDao.item("hp3", w_person.getString("hp3"));
		custDao.item("email", w_person.getString("email"));
		custDao.item("display_seq", 0);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
		System.out.println("--------44-------------");
		//수신업체 저장
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no", r_member.getString("member_no"));
		custDao.item("sign_seq", r_member.getString("sign_seq"));
		custDao.item("cust_gubun", "02");  //01:사업자 02:개인
		custDao.item("vendcd", r_member.getString("vendcd"));
		//custDao.item("jumin_no", r_person.getString("jumin_no"));
		custDao.item("member_name", data.getString("member_name"));
		custDao.item("boss_name", data.getString("member_name"));
		custDao.item("post_code", data.getString("post_code").replaceAll("-",""));
		custDao.item("address", data.getString("address"));
		custDao.item("member_slno", r_member.getString("member_slno"));
		custDao.item("tel_num", data.getString("tel_num"));
		custDao.item("user_name", data.getString("member_name"));
		custDao.item("hp1", data.getString("hp1"));
		custDao.item("hp2", data.getString("hp2"));
		custDao.item("hp3", data.getString("hp3"));
		custDao.item("email", data.getString("email"));
		custDao.item("display_seq", 1);
		custDao.item("list_cust_yn", "Y");
		custDao.item("boss_birth_date", data.getString("birth_date").replaceAll("-", ""));
		String email_random = u.getRandString(20);
		custDao.item("email_random", email_random);
		//custDao.item("boss_gender", gender);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
		System.out.println("--------55-------------");
		//계약서류저장
		int cfile_seq_real = 1;
		String file_hash = pdf.getString("file_hash");
		//계약서류 갑지
		DataObject cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", template.getString("template_name"));
		cfileDao.item("file_path", pdf.getString("file_path"));
		cfileDao.item("file_name", pdf.getString("file_name"));
		cfileDao.item("file_ext", pdf.getString("file_ext"));
		cfileDao.item("file_size", pdf.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		cfileDao.item("auto_type", "");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);

		//자동생성파일
		for(int i=0; i <autoFiles.size(); i ++){
			DataSet temp = (DataSet)autoFiles.get(i);
			cfileDao = new DataObject("tcb_cfile");
			cfileDao.item("cont_no", cont_no);
			cfileDao.item("cont_chasu", cont_chasu);
			cfileDao.item("cfile_seq", cfile_seq_real++);
			cfileDao.item("doc_name", temp.getString("cont_sub_name"));
			cfileDao.item("file_path", temp.getString("file_path"));
			cfileDao.item("file_name", temp.getString("file_name"));
			cfileDao.item("file_ext", temp.getString("file_ext"));
			cfileDao.item("file_size", temp.getString("file_size"));
			cfileDao.item("auto_yn","Y");
			if(temp.getString("gubun").equals("50"))	// 작성업체만 보고 인쇄하는 양식은 서명대상이 아님.  gubun[i].equals("50")
				cfileDao.item("auto_type", "3");	// 공백:자동생성, 1:자동첨부, 2:필수첨부, 3:내부용
			else
			{
				file_hash+="|"+temp.getString("file_hash");
				cfileDao.item("auto_type", "");
			}
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		}

		ContractDao cont2 = new ContractDao();
		cont2.item("cont_hash", file_hash);
		db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);

		//자동첨부 파일 처리

		//자동 구비서류 처리


		/* 계약로그 START*/
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  w_member.getString("member_no"), w_person.getString("person_seq"), w_person.getString("user_name"), request.getRemoteAddr(), template.getString("template_name")+ " 생성전송",  "", "20","10");
		/* 계약로그 END*/

		if(!db.executeArray()){
			error_message += "ERROR => 생년월일:"+data.getString("birth_date")+" 이름: "+data.getString("member_name")+" (계약서저장실패.)";
			continue;
		}

		String send_type = template.getString("send_type");

		//SMS전송
		 SmsDao smsDao = new SmsDao();
		if(!data.getString("hp2").equals("0000") && !data.getString("hp1").equals("") && !data.getString("hp2").equals("")&&!data.getString("hp3").equals("")){
			if(send_type.equals("20")) {// 휴대폰 본인 인증 서명
				String linkUrl = request.getRequestURL().substring(0, request.getRequestURL().indexOf("/web/buyer")) + "/web/buyer/sdd/email_msign_callback.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + cont_chasu + "&email_random=" + email_random;
				String subject = "[나이스다큐]"+auth.getString("_MEMBER_NAME")+" 안내";
				String longMessage = "[" + auth.getString("_MEMBER_NAME") + "] 계약서를 전자서명해주세요 \n"
						+ " *안내* \n1.수신받은 계약서에 대해 PC에서도 전자서명이 가능합니다.(" + data.getString("email")
						+ "에서 확인가능) \n2.시스템 이용 문의는 나이스다큐 고객센터로 해주세요. \n3.계약 내용 문의는 계약업체의 계약담당자에게 해주세요.\n"
						+ linkUrl;
				smsDao.sendLMS("buyer", data.getString("hp1"), data.getString("hp2"), data.getString("hp3"), subject,longMessage);
			}
		}
 
		  if(!data.getString("email").equals("")){

			DataObject contEmailDao = new DataObject("tcb_cont_email");
			String email_seq = contEmailDao.getOne("select nvl(max(email_seq),0)+1 from tcb_cont_email where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+r_member.getString("member_no")+"' ");
			contEmailDao.item("cont_no", cont_no);
			contEmailDao.item("cont_chasu", cont_chasu);
			contEmailDao.item("member_no", r_member.getString("member_no"));
			contEmailDao.item("email_seq", email_seq);
			contEmailDao.item("send_date", u.getTimeString());
			contEmailDao.item("user_name", data.getString("user_name"));
			contEmailDao.item("email", data.getString("email"));
			contEmailDao.item("status", "01");
			if(!contEmailDao.insert()){
			}

			String return_url = "";
			if(send_type.equals("20")) {
				return_url = "web/buyer/sdd/email_msign_callback.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+cont_chasu+"&email_random="+email_random;
			}

			DataSet mailInfo = new DataSet();
			mailInfo.addRow();
			mailInfo.put("send_member_name", w_member.getString("member_name"));
			mailInfo.put("cont_name", cont_name);
			mailInfo.put("cont_date", u.getTimeString("yyyy-MM-dd",data.getString("cont_date").replaceAll("-", "")));
			mailInfo.put("member_name", data.getString("member_name"));
			p.setVar("info", mailInfo);
			p.setVar("server_name", request.getServerName());
			p.setVar("return_url", return_url);
			p.setVar("recv_check_url", "/web/buyer/contract/emailReadCheck.jsp?cont_no="+cont_no+"&cont_chasu="+cont_chasu+"&member_no="+r_member.getString("member_no")+"&num="+email_seq);
			String mail_body = p.fetch("../html/mail/cont_send_mail.html");
			u.mail(data.getString("email"), "[나이스다큐] "+w_member.getString("member_name")+"에서 계약서 서명요청", mail_body );
		}  

		loop_cnt ++;
		
		System.out.println("-------------------------------------------------------------한국전자금융 일괄생성 ["+loop_cnt+"]건 생성 중");
		Thread.sleep(500);
	}

	out.clearBuffer();
	if(error_message.equals("")) {
		out.write(loop_cnt+"건 계약서를 전송하였습니다.\n진행중(보낸계약) 메뉴에서 확인하세요.");
	}else {
		out.write(loop_cnt+"건 계약서를 전송하였습니다.\n\n[실패건]\n\n"+error_message);
	}

}catch(Exception e){
	out.print("알수 없는 에러 발생 : " + e.getCause() + "\n" + e.getMessage());
}
%>
<%!

//input box 등을 제거
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);

	// PDF용 
	for (Element elem : cont_doc.select("textarea")) {
		elem.parent().html(elem.text().replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br />"));
	} 
	for( Element elem : cont_doc.select("input[type=text]") ){ if(elem.val().equals("")) elem.parent().text("\u00a0"); else elem.parent().text(elem.val());}
	for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }
	cont_doc.select(".no_pdf").attr("style", "display:none"); // pdf 버전에 보여야 안되는것

	cont_html_rm = cont_doc.getElementsByTag("body").html().toString();
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
	if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;

	return cont_html_rm;
}

//양식에 값 채워넣기
public String setHtmldata(String html, DataSet w_member, DataSet w_person, DataSet r_member, DataSet r_person, DataSet data, String template_cd)
{
	//contract_modify.jsp 에 있는 script 항목들 맞춰가야 할듯.
	String cont_html = "";
	Document cont_doc = Jsoup.parse(html);
	
	//작성자 정보
	replaceInput(cont_doc,"cust_name_area_1", w_member.getString("member_name"));
	replaceInput(cont_doc,"address_area_1", w_member.getString("address"));
	replaceInput(cont_doc,"boss_name_area_1", w_member.getString("boss_name"));
	replaceInput(cont_doc,"telnum_area_1", w_member.getString("tel_num"));
	System.out.println("--------1-------");
	if(w_member.getString("vendcd").length()==10) {
		replaceInput(cont_doc, "vendcd1_1", w_member.getString("vendcd").substring(0, 3));
		replaceInput(cont_doc, "vendcd2_1", w_member.getString("vendcd").substring(3, 5));
		replaceInput(cont_doc, "vendcd3_1", w_member.getString("vendcd").substring(5));
	}
	System.out.println("--------2-------");
	if(w_member.getString("member_slno").length()==13){
		replaceInput(cont_doc,"member_slno1_1", w_member.getString("member_slno").substring(0,6));
		replaceInput(cont_doc,"member_slno2_1", w_member.getString("member_slno").substring(6));
	}

	System.out.println("--------3-------");
	replaceInput(cont_doc,"user_name_area_1", w_person.getString("user_name"));
	replaceInput(cont_doc,"hp1_1", w_person.getString("hp1"));
	replaceInput(cont_doc,"hp2_1", w_person.getString("hp2"));
	replaceInput(cont_doc,"hp3_1", w_person.getString("hp3"));
	replaceInput(cont_doc,"email_area_1", w_person.getString("email"));

	//수신자 정보
	replaceInput(cont_doc,"cust_name_area_2", r_member.getString("member_name"));
	replaceInput(cont_doc,"address_area_2", r_member.getString("address"));
	replaceInput(cont_doc,"boss_name_area_2", r_member.getString("boss_name"));
	replaceInput(cont_doc,"telnum_area_2", r_member.getString("tel_num"));

	replaceInput(cont_doc,"user_name_area_2", r_person.getString("user_name"));
	replaceInput(cont_doc,"hp1_2", r_person.getString("hp1"));
	replaceInput(cont_doc,"hp2_2", r_person.getString("hp2"));
	replaceInput(cont_doc,"hp3_2", r_person.getString("hp3"));
	replaceInput(cont_doc,"email_area_2", r_person.getString("email"));
	replaceInput(cont_doc,"boss_birth_date_2", r_person.getString("birth_date"));

	replaceInput(cont_doc,"cont_year_area", data.getString("cont_date").replaceAll("-", "").substring(0, 4));
	replaceInput(cont_doc,"cont_month_area", data.getString("cont_date").replaceAll("-", "").substring(4, 6));
	replaceInput(cont_doc,"cont_day_area", data.getString("cont_date").replaceAll("-", "").substring(6));
	replaceInput(cont_doc,"cont_name", data.getString("cont_name"));
	  
	
	 
  	if (template_cd.equals("2020020")) {    
  		replaceInput(cont_doc, "cont_syear", data.getString("cont_sdate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_smonth", data.getString("cont_sdate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_sday", data.getString("cont_sdate").replaceAll("-", "").substring(6));
  		replaceInput(cont_doc, "cont_eyear", data.getString("cont_edate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_emonth", data.getString("cont_edate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_eday", data.getString("cont_edate").replaceAll("-", "").substring(6));
  		
  		replaceInput(cont_doc,"cont_total", Util.numberFormat(data.getString("cont_total").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_1", Util.numberFormat(data.getString("a_pay_1").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_2", Util.numberFormat(data.getString("a_pay_2").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_3", Util.numberFormat(data.getString("a_pay_3").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_4", Util.numberFormat(data.getString("a_pay_4").replaceAll(",", "")));   
    
		int a_pay_1 =  Integer.parseInt(data.getString("a_pay_1").replaceAll(",", ""));
		int a_pay_2 =  Integer.parseInt(data.getString("a_pay_2").replaceAll(",", ""));
		int a_pay_3 =  Integer.parseInt(data.getString("a_pay_3").replaceAll(",", ""));
		int a_pay_4 =  Integer.parseInt(data.getString("a_pay_4").replaceAll(",", ""));
	 
 		int cont_total_1 = a_pay_1 + a_pay_2 + a_pay_3 + a_pay_4 ;  
 		replaceInput(cont_doc,"cont_total_1", Util.numberFormat(cont_total_1));  
 		replaceInput(cont_doc,"input_cont_text01", data.getString("input_cont_text01"));  
	
  	}else if(template_cd.equals("2020021")){
  		replaceInput(cont_doc, "cont_syear", data.getString("cont_sdate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_smonth", data.getString("cont_sdate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_sday", data.getString("cont_sdate").replaceAll("-", "").substring(6));
  		replaceInput(cont_doc, "cont_eyear", data.getString("cont_edate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_emonth", data.getString("cont_edate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_eday", data.getString("cont_edate").replaceAll("-", "").substring(6));
  		
		replaceInput(cont_doc,"cont_total", Util.numberFormat(data.getString("cont_total").replaceAll(",", "")));  
		replaceInput(cont_doc,"a_pay_1", Util.numberFormat(data.getString("a_pay_1").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_2", Util.numberFormat(data.getString("a_pay_2").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_3", Util.numberFormat(data.getString("a_pay_3").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_4", Util.numberFormat(data.getString("a_pay_4").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_5", Util.numberFormat(data.getString("a_pay_5").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_6", Util.numberFormat(data.getString("a_pay_6").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_7", Util.numberFormat(data.getString("a_pay_7").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_8", Util.numberFormat(data.getString("a_pay_8").replaceAll(",", ""))); 
 
		int a_pay_1 =  Integer.parseInt(data.getString("a_pay_1").replaceAll(",", ""));
		int a_pay_2 =  Integer.parseInt(data.getString("a_pay_2").replaceAll(",", ""));
		int a_pay_3 =  Integer.parseInt(data.getString("a_pay_3").replaceAll(",", ""));
		int a_pay_4 =  Integer.parseInt(data.getString("a_pay_4").replaceAll(",", ""));
		int a_pay_5 =  Integer.parseInt(data.getString("a_pay_5").replaceAll(",", ""));
		int a_pay_6 =  Integer.parseInt(data.getString("a_pay_6").replaceAll(",", ""));
		int a_pay_7 =  Integer.parseInt(data.getString("a_pay_7").replaceAll(",", ""));
		int a_pay_8 =  Integer.parseInt(data.getString("a_pay_8").replaceAll(",", ""));
		int cont_total_1 = a_pay_1 + a_pay_2 + a_pay_3 + a_pay_4 + a_pay_5 + a_pay_6 + a_pay_7 + a_pay_8 ; 
		
 		replaceInput(cont_doc,"cont_total_1", Util.numberFormat(cont_total_1));   
 		replaceInput(cont_doc,"input_cont_text01", data.getString("input_cont_text01"));  
	
  	}else if(template_cd.equals("2020022")){
  		replaceInput(cont_doc, "cont_syear", data.getString("cont_sdate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_smonth", data.getString("cont_sdate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_sday", data.getString("cont_sdate").replaceAll("-", "").substring(6));
  		replaceInput(cont_doc, "cont_eyear", data.getString("cont_edate").replaceAll("-", "").substring(0, 4));
  		replaceInput(cont_doc, "cont_emonth", data.getString("cont_edate").replaceAll("-", "").substring(4, 6));
  		replaceInput(cont_doc, "cont_eday", data.getString("cont_edate").replaceAll("-", "").substring(6));
  		
		replaceInput(cont_doc,"a_pay_1", Util.numberFormat(data.getString("a_pay_1").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_2", Util.numberFormat(data.getString("a_pay_2").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_3", Util.numberFormat(data.getString("a_pay_3").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_4", Util.numberFormat(data.getString("a_pay_4").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_5", Util.numberFormat(data.getString("a_pay_5").replaceAll(",", ""))); 
		replaceInput(cont_doc,"a_pay_6", Util.numberFormat(data.getString("a_pay_6").replaceAll(",", "")));  
		
		int a_pay_1 =  Integer.parseInt(data.getString("a_pay_1").replaceAll(",", ""));
		int a_pay_2 =  Integer.parseInt(data.getString("a_pay_2").replaceAll(",", ""));
		int a_pay_3 =  Integer.parseInt(data.getString("a_pay_3").replaceAll(",", ""));
		int a_pay_4 =  Integer.parseInt(data.getString("a_pay_4").replaceAll(",", ""));
		int a_pay_5 =  Integer.parseInt(data.getString("a_pay_5").replaceAll(",", ""));
		int a_pay_6 =  Integer.parseInt(data.getString("a_pay_6").replaceAll(",", "")); 
		int cont_total = a_pay_1 + a_pay_2 + a_pay_3 + a_pay_4 + a_pay_5 + a_pay_6  ; 
		
 		replaceInput(cont_doc,"cont_total", Util.numberFormat(cont_total));   
 		replaceInput(cont_doc,"input_cont_text01", data.getString("input_cont_text01"));  
  	}else if(template_cd.equals("2020159")){
  		replaceInput(cont_doc,"input_cont_text01", data.getString("input_cont_text01"));  
  		replaceInput(cont_doc,"input_cont_text02", data.getString("input_cont_text02"));  
  	}
	
	cont_html = cont_doc.getElementsByTag("body").html().toString();
	 
	String style = cont_doc.getElementsByTag("style").html();
	String script = cont_doc.getElementsByTag("script").html();
	if(!style.equals(""))cont_html = "<style>"+style+"</style>\n"+cont_html;
	if(!script.equals(""))cont_html = "<script>"+script+"</script>\n"+cont_html;

	return cont_html; 
}


public void replaceInput(Document cont_doc, String name, String value){ 
	for( Element element : cont_doc.select("."+name+"") ){
		String tag_name = element.tagName().toLowerCase(); 
		
		if(tag_name.equals("span")){ 
			element.text(value); 
		}else if(tag_name.equals("input")){

			String type = element.attr("type").toLowerCase();
			
			if(type.equals("checkbox")||type.equals("radio")){
				if(element.attr("value").equals(value)){
					element.attr("checked","checked");
				}
			}else if(type.equals("text")||type.equals("")){//jsoup 버전 버그 type="text"가 전부 사라진다.
				if(type.equals("")){
					element.attr("type","text");
				}else{
					element.attr("value",value);
				}
			} 
		}else if(tag_name.equals("select")){
			for(Element option : element.children()){
				if(option.tagName().toLowerCase().equals("option")){
					if(option.hasAttr("selected")){
						option.removeAttr("selected");
					}
					if(option.attr("value").equals(value)){
						option.attr("selected", "");
					}
				}
			}
		}else if(tag_name.equals("textarea")){
			element.text(value);
		}
	}
}

public String getBirthHan(String inputBirth, String retType) {

	String sBirthHan = ""; 
	if(Integer.parseInt(inputBirth.substring(0,2)) > 25){
		if(retType.equals("1"))
			sBirthHan = "19" + inputBirth.substring(0,2) + "-" + inputBirth.substring(2,4) + "-" + inputBirth.substring(4,6);
		else
			sBirthHan = "19" + inputBirth.substring(0,2) + "년 " + inputBirth.substring(2,4) + "월 " + inputBirth.substring(4,6) + "일";
	} else {
		if(retType.equals("1"))
			sBirthHan = "20" + inputBirth.substring(0,2) + "-" + inputBirth.substring(2,4) + "-" + inputBirth.substring(4,6);
		else
			sBirthHan = "20" + inputBirth.substring(0,2) + "년 " + inputBirth.substring(2,4) + "월 " + inputBirth.substring(4,6) + "일";
	} 
	return sBirthHan;
}

%>