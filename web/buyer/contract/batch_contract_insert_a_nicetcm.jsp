 <%@page import="org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element
				,java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String template_cd = u.request("template_cd"); 
String reg_id = auth.getString("_USER_ID");

/**
 * B2B
 * 2020902 : [영업] 거래약정서_직거래점
 * 2020903 : [영업] 거래약정서_특약점
 * 2020904 : [영업] 자금이체 약정서
 * 2020905 : [영업] 판매장려금 약정서_상품
 * 2020906 : [영업] 판매장려금 약정서_제품종합
 * 2020907 : [영업] 판매장려금 약정서_직거래점
 * 2020908 : [영업] 판매장려금 약정서_판매
 * 2020909 : [구매] 기술자료 요구서
 * 2020917 : [구매] 2020년도 (하도급)공정거래 협약서
 * 2020928 : [영업] 공정거래및상생협력 협약서(대리점분야)
 */
 
String jobGubun = "B2C";	//B2B, B2C 구분
String ifGubn = "01"; //영업(01), 구매(02) 구분
if("2020902".equals(template_cd) || "2020903".equals(template_cd) || "2020904".equals(template_cd) || "2020905".equals(template_cd) || "2020906".equals(template_cd) ||
   "2020907".equals(template_cd) || "2020908".equals(template_cd) || "2020909".equals(template_cd) || "2020917".equals(template_cd) || "2020928".equals(template_cd)
   ){
	jobGubun = "B2B";
}

if("2020909".equals(template_cd) || "2020917".equals(template_cd)){
	ifGubn = "02";
}

int loop_cnt=0;

String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}

Security security = new	Security();

DataSet data = u.grid2dataset(grid);
data.first();

//서식 정보
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find(" status > 0 and template_cd = '" + template_cd + "'");
if(!template.next()){
	out.println("0");
	return;
}

// 추가 서식정보 조회
DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub = templateSubDao.find("template_cd = '"+template_cd+"' ","*"," sub_seq asc");
while (templateSub.next()) {
	templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20", "30"}));
	// 자동 생성해야 하는 양식
	//if (templateSub.getString("option_yn").equals("A")) templateSub.put("option_yn", false);
}

//서명정보 조회
DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet signTemplate = signTemplateDao.find("template_cd = '"+template_cd+"' ","*"," sign_seq asc");
/* String default_sign_seq = "";
String r_default_sign_seq = "";
while (signTemplate.next()) {
	// cust_type - 01:갑, 02:을, 00:연대보증
	// member_type - 01:작성업체, 02:수신업체
	if (signTemplate.getString("cust_type").equals("01")) default_sign_seq = signTemplate.getString("sign_seq");
	if (signTemplate.getString("cust_type").equals("02")) r_default_sign_seq = signTemplate.getString("sign_seq");
} */

// 구비서류, 내부관리 서류 조회 x

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

String error_message = "";
String gbizNo = "";	//사업자번호

try {
	while(data.next()){
		DataSet r_member  = new DataSet();
		DataSet r_person  = new DataSet();
		
		r_member.addRow();
		r_person.addRow();
		String vendcd = "";
		String cust_code = "";
		
		// B2C 계약서
		if("B2C".equals(jobGubun)){
			System.out.println("B2C ##########");
			DataObject personObj = new DataObject("tcb_person");
			String email =  personObj.getOne("select email from tcb_person where member_no = '20201000002' and user_empno = '" + data.getString("emp_no") +"'");
			
			String cela_tel = data.getString("cela_tel");
			String cela_tel1 = "";
			String cela_tel2 = "";
			String cela_tel3 = "";
			
			if(cela_tel != null && cela_tel != ""){
				String[] cela = data.getString("cela_tel").split("-");
				System.out.print("cela###########################" + cela);
				if(cela.length == 3){
					cela_tel1 = cela[0];
					cela_tel2 = cela[1];
					cela_tel3 = cela[2];
				}
			}
			
			data.put("cont_date", u.getTimeString("yyyy-MM-dd"));
			data.put("member_name", data.getString("han_name"));
			data.put("address", data.getString("addr"));
			data.put("hp1", cela_tel1);
			data.put("hp2", cela_tel2);
			data.put("hp3", cela_tel3);
			data.put("email", email);
			
			r_member.put("member_no", Util.strrpad("1", 11, "0"));
			r_member.put("member_name", data.getString("member_name"));
			r_member.put("address", data.getString("address"));
			r_member.put("boss_name", data.getString("member_name"));
			r_member.put("tel_num", data.getString("tel_num"));
			
			r_person.put("user_name", data.getString("member_name"));
			r_person.put("hp1", data.getString("hp1"));
			r_person.put("hp2", data.getString("hp2"));
			r_person.put("hp3", data.getString("hp3"));
			r_person.put("email", data.getString("email"));
			r_person.put("birth_date", data.getString("birth_date"));
			
		// B2B 계약서
		}else{
			System.out.println("B2B ##########");
			cust_code = data.getString("cust_code");
			// 거래처정보 조회
			String sTable = "(" +
							"SELECT im.MEMBER_NO, im.COM_NAME, im.COMM_NO, im.BOSS_MOBL, im.HEAD_OFCE_ADRS, replace(im.HEAD_OFCE_POST, '-', '') HEAD_OFCE_POST, im.BOSS_NAME, tp.USER_NAME, tp.HP1, tp.HP2, tp.HP3, tp.EMAIL, tp.TEL_NUM, tp.DIVISION " +
			   				" FROM IF_MMBAT100 im, ( " +
							" SELECT MEMBER_NO, PERSON_SEQ, USER_NAME, HP1, HP2, HP3, EMAIL, TEL_NUM, DIVISION " +
							" FROM ( SELECT ROW_NUMBER() OVER(PARTITION BY MEMBER_NO ORDER BY PERSON_SEQ DESC) RNUM, MEMBER_NO, PERSON_SEQ, USER_NAME, HP1, HP2, HP3, EMAIL, TEL_NUM, DIVISION FROM TCB_PERSON ) " +
							" WHERE RNUM = 1 " +
			   				" ) tp " +
			   				" WHERE im.MEMBER_NO = tp.MEMBER_NO(+) " +
			   				" AND im.IF_GUBN = '" + ifGubn +"' " +
			   				" AND TO_NUMBER(im.CUST_CODE) = " + cust_code +
			   				")";
			
			DataObject clientInfoObj = new DataObject(sTable);
			
			DataSet clientInfo = clientInfoObj.find(null, "*");
			if(!clientInfo.next()){
				error_message += " 거래처 코드 " + cust_code + " 의 정보가 존재하지 않습니다. ";
				continue;
			}
			
			if("".equals(data.getString("cont_date")) || data.getString("cont_date") == null){
				data.put("cont_date", u.getTimeString("yyyy-MM-dd"));
			}
			
			vendcd = clientInfo.getString("comm_no");// 사업자 번호
			// 거래처 정보
			r_member.put("member_no", clientInfo.getString("member_no"));
			/* r_member.put("member_name", data.getString("member_name")); // 업체명(입력값)
			r_member.put("address", data.getString("address")); // 주소(입력값)
			r_member.put("boss_name", data.getString("boss_name")); // 대표자(입력값) */
			r_member.put("member_name", clientInfo.getString("com_name")); // 업체명
			r_member.put("address", clientInfo.getString("head_ofce_adrs"));
			r_member.put("boss_name", clientInfo.getString("boss_name"));
			r_member.put("tel_num", clientInfo.getString("tel_num"));
			r_member.put("vendcd", vendcd);
			
			// 거래처 담당자 정보
			r_person.put("user_name", clientInfo.getString("user_name"));
			r_person.put("hp1", clientInfo.getString("hp1"));
			r_person.put("hp2", clientInfo.getString("hp2"));
			r_person.put("hp3", clientInfo.getString("hp3"));
			r_person.put("email", clientInfo.getString("email"));
			r_person.put("division", clientInfo.getString("division"));
			// r_person.put("birth_date", data.getString("birth_date"));
		}
		
		/*계약서 html생성 시작*/
		String cont_html = setHtmldata( template.getString("template_html"), w_member, w_person,r_member,r_person,data, template_cd, jobGubun); 
		String cont_html_rm = removeHtml(cont_html); 
		 
		// 계약번호, 계약명 생성
		ContractDao contDao = new ContractDao();
		String cont_no = "";
		String cont_name = "";
		if("B2C".equals(jobGubun)){
			cont_no = contDao.makeContNo("C");
			cont_name = u.getTimeString("yyyy")+"년 "+template.getString("template_name") + "_" + data.getString("member_name") ;
		}else{
			cont_no = contDao.makeContNo("B");
			cont_name = template.getString("template_name") + "-" + vendcd;
		}
		String cont_chasu = "0";
		String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
		String cont_userno = cont_no;	//data.getString("cont_userno");
		
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
			if("B2C".equals(jobGubun)){
				error_message += "ERROR => 생년월일: "+data.getString("birth_date")+" 이름: "+data.getString("member_name")+" (계약서파일생성실패.)";
			}else{
				error_message += "ERROR => 사업자번호: "+vendcd+" 업체명: "+r_member.getString("member_name")+" (계약서파일생성실패.)";
			}
			continue;
		}
 
		//서브서식 pdf파일 생성
		templateSub.first();
		while(templateSub.next()){
			String cont_gubun = templateSub.getString("gubun");
			String cont_option_yn = templateSub.getString("option_yn");
			String cont_sub_html = setHtmldata(templateSub.getString("template_html"), w_member, w_person, r_member, r_person, data, template_cd, jobGubun);
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
		 
		// 계약기간구하기 - 자동연장 쓰려면 추가 필요
		
		System.out.println("--------db start -------------");

		DB db = new DB();

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
		contDao.item("status", "10");	//임시저장으로 변경 : 20 -> 10
		contDao.item("sign_types", template.getString("sign_types"));
		contDao.item("version_seq", template.getString("version_seq"));
		contDao.item("efile_yn", template.getString("efile_yn").equals("Y")?"Y":"N");
		contDao.item("batch_grp_cd", "00");
		// 인지세 default N
		contDao.item("stamp_type", "N");
		
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

		String sMemberNo1 = "20201000001";	//사업자
		String sMemberNo2 = "20201000002";	//개인
		
		//작업업체저장
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		//custDao.item("member_no",w_member.getString("member_no"));
		custDao.item("member_no",sMemberNo1);
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
		if("B2C".equals(jobGubun)){
			//custDao.item("boss_birth_date", boss_birth_date[i].replaceAll("-", ""));
			//custDao.item("boss_gender", boss_gender[i]);
		}
		if (signTemplate.getString("pay_yn").equals("Y")) custDao.item("pay_yn", "Y");
		db.setCommand(custDao.getInsertQuery(), custDao.record);
		System.out.println("--------44-------------");
		
		//수신업체 저장
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		//custDao.item("member_no", r_member.getString("member_no"));
		custDao.item("sign_seq", r_member.getString("sign_seq"));
		custDao.item("vendcd", r_member.getString("vendcd"));
		//custDao.item("jumin_no", r_person.getString("jumin_no"));
		if("B2C".equals(jobGubun)){
			custDao.item("member_name", data.getString("member_name"));
			custDao.item("boss_name", data.getString("member_name"));
			custDao.item("hp1", data.getString("hp1"));
			custDao.item("hp2", data.getString("hp2"));
			custDao.item("hp3", data.getString("hp3"));
			custDao.item("email", data.getString("email"));
			custDao.item("tel_num", data.getString("tel_num"));
			custDao.item("cust_gubun", "02");  //01:사업자 02:개인
			custDao.item("address", data.getString("address"));
			custDao.item("member_no",sMemberNo2);
		}else{
			custDao.item("member_name", r_member.getString("member_name"));
			custDao.item("boss_name", r_member.getString("boss_name"));
			custDao.item("division", r_person.getString("division"));
			custDao.item("hp1", r_person.getString("hp1"));
			custDao.item("hp2", r_person.getString("hp2"));
			custDao.item("hp3", r_person.getString("hp3"));
			custDao.item("email", r_person.getString("email"));
			custDao.item("tel_num", r_member.getString("tel_num"));
			custDao.item("cust_gubun", "01");  //01:사업자 02:개인
			custDao.item("address", r_member.getString("address"));
			custDao.item("member_no",r_member.getString("member_no"));
		}
		custDao.item("user_name", r_person.getString("user_name"));
		custDao.item("post_code", data.getString("post_code").replaceAll("-",""));
		custDao.item("member_slno", r_member.getString("member_slno"));
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

		// 계약서 추가 입력정보
		
		/* 계약로그 START*/
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  w_member.getString("member_no"), w_person.getString("person_seq"), w_person.getString("user_name"), request.getRemoteAddr(), template.getString("template_name")+ " 생성전송",  "", "20","10");
		/* 계약로그 END*/

		if(!db.executeArray()){
			if("B2C".equals(jobGubun)){
				error_message += "ERROR => 생년월일:"+data.getString("birth_date")+" 이름: "+data.getString("member_name")+" (계약서저장실패.)";
			}else{
				error_message += "ERROR => 사업자번호: "+vendcd+" 업체명: "+r_member.getString("member_name")+" (계약서저장실패.)";
			}
			continue;
		}

		loop_cnt ++;
		
		System.out.println("------------------------------------------------------------ 일괄생성 ["+loop_cnt+"]건 생성 중");
		Thread.sleep(500);
	}

	out.clearBuffer();
	if(error_message.equals("")) {
		out.write(loop_cnt+"건 계약서를 전송하였습니다.\n일괄계약전송에서 확인 후 서명요청하세요.");
	}else {
		out.write(loop_cnt+"건 계약서를 전송하였습니다.\n\n[실패건]\n\n"+error_message);
	}

}catch(Exception e){
	out.print("알수 없는 에러 발생 : " + e.getCause() + "\n" + e.getMessage());
	e.printStackTrace();
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
public String setHtmldata(String html, DataSet w_member, DataSet w_person, DataSet r_member, DataSet r_person, DataSet data, String template_cd, String jobGubun)
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
	  
    if ("B2C".equals(jobGubun)) {
    	//B2C
  		replaceInput(cont_doc, "loca_name", data.getString("loca_name"));
  		replaceInput(cont_doc, "jwrk_name", data.getString("jwrk_name"));
  		replaceInput(cont_doc, "dept_name", data.getString("dept_name"));
  		replaceInput(cont_doc, "autt_name", data.getString("autt_name"));
  		replaceInput(cont_doc, "job_name", data.getString("job_name"));
  		replaceInput(cont_doc, "etc_cont", data.getString("etc_cont"));
  		
  		replaceInput(cont_doc,"work_month_amt", Util.numberFormat(data.getString("work_month_amt").replaceAll(",", "")));
  		replaceInput(cont_doc,"jeva_amt", Util.numberFormat(data.getString("jeva_amt").replaceAll(",", "")));
  		replaceInput(cont_doc,"over_time", Util.numberFormat(data.getString("over_time").replaceAll(",", "")));
  		replaceInput(cont_doc,"over_labo_alow", Util.numberFormat(data.getString("over_labo_alow").replaceAll(",", "")));
  		replaceInput(cont_doc,"work_month_time", Util.numberFormat(data.getString("work_month_time").replaceAll(",", "")));
  		replaceInput(cont_doc,"work_day_time", Util.numberFormat(data.getString("work_day_time").replaceAll(",", "")));
  		replaceInput(cont_doc,"work_week_time", Util.numberFormat(data.getString("work_week_time").replaceAll(",", "")));
  		replaceInput(cont_doc,"pay_amt", Util.numberFormat(data.getString("pay_amt").replaceAll(",", "")));
  		replaceInput(cont_doc,"day_pay", Util.numberFormat(data.getString("day_pay").replaceAll(",", "")));
  		replaceInput(cont_doc,"wday_amt", Util.numberFormat(data.getString("wday_amt").replaceAll(",", "")));
  		
  		//입사일(entr_com_date)
  		String entrComDate = data.getString("entr_com_date");
  		String contStaYear = "";
  		String contStaMonth = "";
  		String contStaDay = "";

  		if(entrComDate.length() == 8){
  			contStaYear = entrComDate.substring(0, 4);
  			contStaMonth = entrComDate.substring(4, 6);
  			contStaDay = entrComDate.substring(6);
  		}
  		
  		replaceInput(cont_doc,"cont_sta_year", contStaYear);
  		replaceInput(cont_doc,"cont_sta_month", contStaMonth);
  		replaceInput(cont_doc,"cont_sta_day", contStaDay);
  		
  		//계약시작일자(cont_sta_date)
  		String contStaDate = data.getString("cont_sta_date");
  		String contSyear = "";
  		String contSmonth = "";
  		String contSday = "";
  		if(contStaDate.length() == 8){
  			contSyear = contStaDate.substring(0, 4);
  			contSmonth = contStaDate.substring(4, 6);
  			contSday = contStaDate.substring(6);
  		}
  		replaceInput(cont_doc,"cont_syear", contSyear);
  		replaceInput(cont_doc,"cont_smonth", contSmonth);
  		replaceInput(cont_doc,"cont_sday", contSday);

  		//계약종료일자(cont_end_date)
  		String contEndDate = data.getString("cont_end_date");
  		String contEyear = "";
  		String contEmonth = "";
  		String contEday = "";
  		if(contEndDate.length() == 8){
  			contEyear = contEndDate.substring(0, 4);
  			contEmonth = contEndDate.substring(4, 6);
  			contEday = contEndDate.substring(6);
  		}
  		replaceInput(cont_doc,"cont_eyear", contEyear);
  		replaceInput(cont_doc,"cont_emonth", contEmonth);
  		replaceInput(cont_doc,"cont_eday", contEday);
  		
  		//제수당유무 check
  		String etcAmtYn = data.getString("etc_amt_yn");
  		String etcAmtY = "";
  		String etcAmtN = "";
  		if(etcAmtYn != null && !etcAmtYn.equals("")){
  			if(etcAmtYn.equals("Y")){
  				etcAmtY = "O";
  				etcAmtN = "";
  			}else{
  				etcAmtY = "";
  				etcAmtN = "O";
  			}
  		}else{
  			etcAmtY = "";
  			etcAmtN = "O";
  		}
  		replaceInput(cont_doc,"etc_amt_y", etcAmtY);
  		replaceInput(cont_doc,"etc_amt_n", etcAmtN);
  		
  	} else if("B2B".equals(jobGubun)){
  		// B2B
  		if(w_member.getString("vendcd").length()==10) {
  			replaceInput(cont_doc, "vendcd1_2", r_member.getString("vendcd").substring(0, 3));
  			replaceInput(cont_doc, "vendcd2_2", r_member.getString("vendcd").substring(3, 5));
  			replaceInput(cont_doc, "vendcd3_2", r_member.getString("vendcd").substring(5));
  		}
  		replaceInput(cont_doc,"payment_day", Util.numberFormat(data.getString("payment_day").replaceAll(",", "")));
  		String cont_date_from = "";
  		if(data.getString("cont_date_from").length() == 8){
  			cont_date_from = data.getString("cont_date_from").substring(0, 4) + "-" + data.getString("cont_date_from").substring(4, 6) + "-" + data.getString("cont_date_from").substring(6);
  		}
  		replaceInput(cont_doc, "cont_date_from", cont_date_from);
  		replaceInput(cont_doc, "tech_comment", data.getString("tech_comment"));
  		replaceInput(cont_doc, "req_purpose", data.getString("req_purpose"));
  		replaceInput(cont_doc, "keep_secret", data.getString("keep_secret"));
  		replaceInput(cont_doc, "req_purpose", data.getString("req_purpose"));
  		replaceInput(cont_doc, "attr_of_rights", data.getString("attr_of_rights"));
  		replaceInput(cont_doc, "cost", data.getString("cost"));
  		replaceInput(cont_doc, "del_method", data.getString("del_method"));
  		replaceInput(cont_doc, "per_or_use", data.getString("per_or_use"));
  		replaceInput(cont_doc, "discard_method", data.getString("discard_method"));
  		replaceInput(cont_doc, "etc_matters", data.getString("etc_matters"));
  		
  		//기술자료요구서 소속, 전화번호
  		replaceInput(cont_doc, "division_1", w_person.getString("division"));
  		if(!"".equals(w_person.getString("hp1")) && !"".equals(w_person.getString("hp2")) && !"".equals(w_person.getString("hp3"))){
  			replaceInput(cont_doc, "cell_phon_1", w_person.getString("hp1")+"-"+w_person.getString("hp2")+"-"+w_person.getString("hp3"));
  		}
  		replaceInput(cont_doc, "division_2", r_person.getString("division"));
  		if(!"".equals(r_person.getString("hp1")) && !"".equals(r_person.getString("hp2")) && !"".equals(r_person.getString("hp3"))){
  			replaceInput(cont_doc, "cell_phon_2", r_person.getString("hp1")+"-"+r_person.getString("hp2")+"-"+r_person.getString("hp3"));
  		}
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