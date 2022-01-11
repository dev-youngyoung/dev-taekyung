<%@page import="java.net.URLDecoder
				,org.jsoup.Jsoup
				,org.jsoup.nodes.Document
				,org.jsoup.nodes.Element
				,org.jsoup.select.Elements"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}

DataSet data = u.grid2dataset(grid);

// 계약기본정보
String w_member_no = auth.getString("_MEMBER_NO");  // 작성자 회원번호
String w_template_cd = "2015016";  // 양식코드 (청구서2)
String w_user_id = auth.getString("_USER_ID"); // 작성자아이디
String w_cust_sign_seq = "1";	// sign_seq
String w_display_seq = "1";		//

// 작성자
String w_vendcd = "";      // 사업자번호
String w_member_name = ""; // 회사명
String w_boss_name = ""; // 대표자명
String w_cust_gubun = ""; // 사업자, 개인 구분
String w_address = ""; // 주소
String w_post_code = "";	 // 우편번호

String w_field_seq = ""; // 담당자 부서코드
String w_user_name = ""; // 담당자명
String w_tel_num = ""; // 전화번호
String w_hp1 = "";	 // 휴대번호
String w_hp2 = "";
String w_hp3 = "";
String w_email = "";  // 이메일

String cont_date = "";
String cont_year = "";
String cont_month = "";
String cont_day = "";


// 작성업체 및 작성자 정보 (작성자 1명이 생성하는 자동계약이다.)
DataObject daoWMember = new DataObject("tcb_member");
DataObject daoWPerson = new DataObject("tcb_person");

// 작성업체 정보 조회
DataSet dsWMember = daoWMember.find("member_no = '"+w_member_no+"'");
if(!dsWMember.next())
{
	System.out.println("작성업체 정보가 없습니다. 작성업체 회원번호 : " + w_member_no);
	return;
}
w_vendcd = dsWMember.getString("vendcd");
w_member_name = dsWMember.getString("member_name");
w_boss_name = dsWMember.getString("boss_name");
w_cust_gubun = dsWMember.getString("member_gubun")=="04" ? "02" : "01";  // 01:사업자, 02:개인
w_address = dsWMember.getString("address");
w_post_code = dsWMember.getString("post_code");

// 작성자 정보 조회
DataSet dsWPerson = daoWPerson.find("user_id = '"+w_user_id+"'");
if(!dsWPerson.next())
{
	System.out.println("작성자 정보가 없습니다. 작성자 아이디 : " + w_user_id);
	return;
}
w_field_seq = dsWPerson.getString("field_seq");
w_user_name = dsWPerson.getString("user_name");
w_tel_num = dsWPerson.getString("tel_num");
w_hp1 = dsWPerson.getString("hp1");
w_hp2 = dsWPerson.getString("hp2");
w_hp3 = dsWPerson.getString("hp3");
w_email = dsWPerson.getString("email");

// 계약서 정보 조회
String[] cont_html = new String[2];
String[] cont_sub_name = new String[2];
String[] cont_sub_style = new String[2];
String[] gubun = new String[2];
String[] option_yn = new String[2];

int cont_i = 0;
// 서식정보 조회
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find("template_cd ='"+w_template_cd+"'");
if(!template.next()){
	System.out.println("계약서 양식이 존재하지 않습니다.");
	return;
} else {
	cont_html[cont_i] = template.getString("template_html");
	cont_sub_name[cont_i] = template.getString("template_name");
	cont_sub_style[cont_i] = template.getString("template_style");
	gubun[cont_i] = "00";
	option_yn[cont_i] = "A";

	cont_i++;
}

DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet dsSignTemplate= signTemplateDao.find("template_cd ='"+w_template_cd+"'", "sign_seq, signer_name, signer_max, member_type, cust_type");
if(!dsSignTemplate.next()){
	System.out.println("계약서 서명 순서(tcb_cont_sign_template)가 존재하지 않습니다.");
	return;
}

try{

	// 엑셀에서 입력받는 값
	String r_data = ""; // 양식데이터

	String r_member_no = "";  //  거래처 회원번호
	String r_member_gubun = "";	 // 회원구분 (01 : 법인(본사), 02 : 법인(지사), 03 : 개인사업자)

	String r_vendcd = "";      // 사업자번호
	String r_cust_code = "";      // 업체코드
	String r_member_name = ""; // 업체명
	String r_boss_name = "";	 // 대표자명
	String r_post_code = "";	 // 우편번호
	String r_address = "";     // 주소
	String r_cust_gubun = "01";	// 사업자(01), 개인(02)
	String r_cust_sign_seq = "2";	// sign_seq
	String r_display_seq = "2";		//

	String r_person_seq = "";
	String r_user_name = "";	 //	담당자명
	String r_tel_num = "";	 //	전화번호
	String r_hp1 = "";	 //	휴대번호
	String r_hp2 = "";	 //
	String r_hp3 = "";	 //
	String r_email = "";	 //	이메일

	String[] arr = {"81","82","83","84","86","87","88"};  // 법인사업자 구분

	System.out.println("realGrid.getRowCnt["+data.size()+"]");

	while(data.next()){

		DB db = new DB();

		// 초기화
		String r_cont_date = data.getString("r_cont_date");
		String[] arr_cont_date = r_cont_date.split("-");
		cont_date = r_cont_date.replaceAll("-","");
		if(arr_cont_date.length == 3)
		{
			cont_year = arr_cont_date[0];
			cont_month = arr_cont_date[1];
			cont_day = arr_cont_date[2];
		}
		else
		{
			cont_year = cont_date.substring(0,4);
			cont_month = cont_date.substring(4,6);
			cont_day = cont_date.substring(6);
		}

		r_member_no = "";  //  거래처 회원번호
		r_member_gubun = "";
		r_person_seq = "";

		String cont_name = "";//wgs.getString("r_cont_name",i);

		r_user_name = data.getString("r_user_name").trim();	 //	담당자명
		r_hp1 = data.getString("r_hp1");	 //	휴대번호
		r_hp2 = data.getString("r_hp2");	 //
		r_hp3 = data.getString("r_hp3");	 //
		r_tel_num = r_hp1+"-"+r_hp2+"-"+r_hp3;
		r_email = data.getString("r_email");	 //	이메일


		// html input 값 자동 셋팅을 위한 데이터
		DataSet dsCustData = new DataSet();
		dsCustData.addRow();

		dsCustData.put("cont_year", cont_year); // 계약일
		dsCustData.put("cont_month", cont_month);
		dsCustData.put("cont_day", cont_day);
		dsCustData.put("r_req_month", data.getString("r_req_month"));
		dsCustData.put("r_req_count", data.getString("r_req_count"));
		dsCustData.put("r_item", data.getString("r_item"));
		dsCustData.put("r_cust_code", data.getString("r_cust_code"));

		dsCustData.put("r_sup", data.getString("r_sup"));
		dsCustData.put("r_pro", data.getString("r_pro"));
		dsCustData.put("r_sum", data.getString("r_sum"));

		// 1. 회원인지 체크
		DataObject daoRMember = new DataObject("tcb_member");
		DataSet dsRMember = daoRMember.find("vendcd = '"+data.getString("r_vendcd").replaceAll("-","")+"'");
		if(dsRMember.next()) // 회원
		{
			r_member_no = dsRMember.getString("member_no");
			r_vendcd = dsRMember.getString("vendcd");
			r_member_name = dsRMember.getString("member_name");
			r_address = dsRMember.getString("address");
			r_post_code = dsRMember.getString("post_code");
			r_boss_name = dsRMember.getString("boss_name");

			dsCustData.put("r_vendcd1", dsRMember.getString("vendcd").substring(0,3));
			dsCustData.put("r_vendcd2", dsRMember.getString("vendcd").substring(3,5));
			dsCustData.put("r_vendcd3", dsRMember.getString("vendcd").substring(5));
			dsCustData.put("r_member_name", r_member_name);
			dsCustData.put("r_boss_name", dsRMember.getString("boss_name"));
			dsCustData.put("r_address",r_address);

			/*
			DataObject daoRPerson = new DataObject("tcb_person");
			int nUserCnt = 0;
			
			
			
			if(!r_user_name.equals("") && !r_hp1.equals("") && !r_hp2.equals("") && !r_hp3.equals("") && !r_email.equals("")) {
				nUserCnt = daoRPerson.findCount("member_no = '"+r_member_no+"' and user_name='"+r_user_name+"'");
			}
			
			if(nUserCnt == 0) // 담당자가 없는 경우 기본 담당자로 설정
			{
				DataSet dsRperson = daoRPerson.find("member_no = '"+r_member_no+"' and default_yn='Y'");
				if(!dsRperson.next())
				{
					Util.log(r_vendcd + "\t기본 담당자가 존재하지 않습니다");
					continue;
				}
				else
				{
					r_person_seq = dsRperson.getString("person_seq");
					r_user_name = dsRperson.getString("user_name");
					r_tel_num = dsRperson.getString("tel_num");
					r_hp1 = dsRperson.getString("hp1");
					r_hp2 = dsRperson.getString("hp2");
					r_hp3 = dsRperson.getString("hp3");
					r_email = dsRperson.getString("email");
				}
			}
			*/
			
		}
		else
		{
			// 미가입회원 로그 출력
			Util.log(data.getString("r_vendcd") + "\t회사 정보가 존재하지 않습니다");
			continue;
		}

		// 4월2차 청구서_아이플
		cont_name = data.getString("r_req_month") + "월" + data.getString("r_req_count")+"차 청구서_"+ r_member_name;

		//---------------------- 계약서 생성 ---------------------


		// 서식정보 조회
		DataSet dsContract = new DataSet();
		String cont_html_input = "";
		String cont_html_noinput = "";

		for(int j=0; j<cont_html.length; j++)
		{
			if(gubun[j]==null) break;

			dsContract.addRow();
			cont_html_input = setHtmlValue(cont_html[j], dsCustData);		// 양식에 input, span값 셋팅
			cont_html_noinput = removeHtml(cont_html_input);	// input값 제거
			
			System.out.println(cont_html_noinput);

			dsContract.put("cont_html", cont_html_input);
			dsContract.put("cont_html_rm", cont_html_noinput);
			dsContract.put("template_name", cont_sub_name[j]);
			dsContract.put("template_style", cont_sub_style[j]);
			dsContract.put("gubun", gubun[j]);
			dsContract.put("option_yn", option_yn[j]);
		}

		String cont_html_rm_str = "";  // pdf 생성을 위해 태그들을 remove 한 값들.
		int z = 0;
		dsContract.first();
		while(dsContract.next())
		{
			if(z==0)
				cont_html_rm_str = dsContract.getString("cont_html_rm");
			else if(z > 0)
				cont_html_rm_str += "<pd4ml:page.break>";

			if(dsContract.getString("gubun").equals("10")){  // 여러개 탭을 1개 파일로 만드는 경우에만 실행
				cont_html_rm_str += dsContract.getString("cont_html_rm");
			}
			z++;
		}

		//System.out.println("cont_html_rm_str -> " + cont_html_rm_str);

		ContractDao cont = new ContractDao();
		String cont_no = cont.makeContNo();
		int cont_chasu = 0;
		String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");

		ArrayList autoFiles = new ArrayList();
		int file_seq = 1;


		String cont_userno = "";


		// 계약서 갑지 파일 생성
		DataSet pdfInfo = new DataSet();
		pdfInfo.addRow();
		pdfInfo.put("member_no",w_member_no);
		pdfInfo.put("cont_no", cont_no);
		pdfInfo.put("cont_chasu", cont_chasu);
		pdfInfo.put("random_no", random_no);
		pdfInfo.put("html", cont_html_rm_str);
		pdfInfo.put("file_seq", file_seq++);
		DataSet pdf = cont.makePdf(pdfInfo);
		if(pdf==null){
			System.out.println("계약서 파일 생성에 실패 하였습니다.");
			break;
		}

		// 계약정보 저장
		dsContract.first();
		dsContract.next();

		cont.item("cont_no", cont_no);
		cont.item("cont_chasu", cont_chasu);
		cont.item("member_no", w_member_no);
		cont.item("field_seq", w_field_seq);
		cont.item("template_cd", w_template_cd);
		cont.item("cont_name", cont_name);
		cont.item("cont_date", cont_date);
		//cont.item("cont_sdate", cont_sdate);
		//cont.item("cont_edate", cont_edate);
		cont.item("supp_tax", "");
		cont.item("supp_taxfree", "");
		cont.item("supp_vat", "");
		cont.item("cont_total", "");
		cont.item("cont_userno", cont_userno);
		cont.item("cont_html", dsContract.getString("cont_html"));
		cont.item("reg_date", u.getTimeString());
		cont.item("true_random", random_no);
		cont.item("reg_id", w_user_id);
		cont.item("status", "10");
		String file_hash = pdf.getString("file_hash");
		cont.item("cont_hash", file_hash);

		db.setCommand(cont.getInsertQuery(), cont.record);

		// 서명 서식 저장
		dsSignTemplate.first();
		while(dsSignTemplate.next())
		{
			DataObject cont_sign = new DataObject("tcb_cont_sign");
			cont_sign.item("cont_no",cont_no);
			cont_sign.item("cont_chasu",cont_chasu);
			cont_sign.item("sign_seq", dsSignTemplate.getString("sign_seq"));
			cont_sign.item("signer_name", dsSignTemplate.getString("signer_name"));
			cont_sign.item("signer_max", dsSignTemplate.getString("signer_max"));
			cont_sign.item("member_type", dsSignTemplate.getString("member_type"));  // 01:나이스와 계약한 업체 02:나이스 미계약업체
			cont_sign.item("cust_type", dsSignTemplate.getString("cust_type"));      // 01:갑 02:을
			db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
		}

		// 작성업체 저장
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",w_member_no);
		custDao.item("sign_seq", w_cust_sign_seq);
		custDao.item("cust_gubun", w_cust_gubun);  //01:사업자 02:개인
		custDao.item("vendcd", w_vendcd);
		custDao.item("member_name", w_member_name);
		custDao.item("boss_name", w_boss_name);
		custDao.item("post_code", w_post_code.replaceAll("-",""));
		custDao.item("address", w_address);
		custDao.item("tel_num", w_tel_num);
		//custDao.item("member_slno", w_member_slno.replaceAll("-",""));
		custDao.item("user_name", w_user_name);
		custDao.item("hp1", w_hp1);
		custDao.item("hp2", w_hp2);
		custDao.item("hp3", w_hp3);
		custDao.item("email", w_email);
		custDao.item("display_seq", 0);
		db.setCommand(custDao.getInsertQuery(), custDao.record);


		// 거래처 저장
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",r_member_no);
		custDao.item("sign_seq", r_cust_sign_seq);
		custDao.item("cust_gubun", r_cust_gubun);  //01:사업자 02:개인
		custDao.item("vendcd", r_vendcd);
		custDao.item("member_name", r_member_name);
		custDao.item("boss_name", r_boss_name);
		custDao.item("post_code", r_post_code.replaceAll("-",""));
		custDao.item("address", r_address);
		custDao.item("tel_num", r_tel_num);
		//custDao.item("member_slno", r_member_slno.replaceAll("-",""));
		custDao.item("user_name", r_user_name);
		custDao.item("hp1", r_hp1);
		custDao.item("hp2", r_hp2);
		custDao.item("hp3", r_hp3);
		custDao.item("email", r_email);
		custDao.item("display_seq", 1);
		db.setCommand(custDao.getInsertQuery(), custDao.record);

		
		db.setCommand(
				 " update tcb_cust "
				+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
				+"  where cont_no = '"+cont_no+"' "
				+"    and cont_chasu = '"+cont_chasu+"' "	 
						,null);
		
		// 계약서류 DB 저장
		int cfile_seq_real = 1;


		// 계약서류 갑지
		DataObject cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", cont_sub_name[0]);
		cfileDao.item("file_path", pdf.getString("file_path"));
		cfileDao.item("file_name", pdf.getString("file_name"));
		cfileDao.item("file_ext", pdf.getString("file_ext"));
		cfileDao.item("file_size", pdf.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		cfileDao.item("auto_type", "");
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		
		
		/* 계약로그 START*/
		ContBLogDao logDao = new ContBLogDao();
		logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), template.getString("template_name")+"생성",  "", "10","10");
		/* 계약로그 END*/
		
		
		db.executeArray();
	}

	out.print("1");

}catch(Exception e){
	out.print("0");
	return;
}
%>
<%!
// input box 등을 제거
public String removeHtml(String html)
{
	String cont_html_rm = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);


	// PDF용
	for( Element elem : cont_doc.select("input[type=text]") ){ if(elem.val().equals("")) elem.parent().text("\u00a0"); else elem.parent().text(elem.val());}  // input box 값 모두 제거
	//for( Element elem : cont_doc.select("input[type=checkbox]") ){ if(elem.hasAttr("checked")) elem.parent().text("▣"); else elem.parent().text("□");  }  // 체크박스
	//for( Element elem : cont_doc.select("input[type=radio]") ){ if(elem.hasAttr("checked")) elem.parent().text("▣"); else elem.parent().text("□"); }  // 라디오
	//for( Element elem : cont_doc.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }

	//cont_doc.select("#pdf_comment").attr("style", "display:none"); // pdf 버전에 보여야 안되는것

	cont_html_rm = cont_doc.toString();

	return cont_html_rm;
}

// 양식에 값 채워넣기
public String setHtmlValue(String html, DataSet dsCustData)
{
	String cont_html = "";

	// DB용
	Document cont_doc = Jsoup.parse(html);

	// input box 값 채우기
	cont_doc.select("input[name=cust_code]").attr("value", dsCustData.getString("r_cust_code"));	// 업체코드
	cont_doc.select("input[name=req_month]").attr("value", dsCustData.getString("r_req_month"));	// 청구월
	cont_doc.select("input[name=req_count]").attr("value", dsCustData.getString("r_req_count"));	// 청구차수
	cont_doc.select("input[name=cont_total]").attr("value", dsCustData.getString("r_sum"));			// 합계금액
	cont_doc.select("input[name=item_1]").attr("value", dsCustData.getString("r_item"));			// 합계금액
	cont_doc.select("input[name=sup_1]").attr("value", dsCustData.getString("r_sup"));			// 합계금액
	cont_doc.select("input[name=pro_1]").attr("value", dsCustData.getString("r_pro"));			// 합계금액
	cont_doc.select("input[name=sum_1]").attr("value", dsCustData.getString("r_sum"));			// 합계금액


	// span으로 된 부분 값 채우기
	for( Element elem : cont_doc.select("span.cust_name_area_2") ){ elem.text(dsCustData.getString("r_member_name")); }
	for( Element elem : cont_doc.select("span.vendcd1_2") ){ elem.text(dsCustData.getString("r_vendcd1")); }
	for( Element elem : cont_doc.select("span.vendcd2_2") ){ elem.text(dsCustData.getString("r_vendcd2")); }
	for( Element elem : cont_doc.select("span.vendcd3_2") ){ elem.text(dsCustData.getString("r_vendcd3")); }
	for( Element elem : cont_doc.select("span.address_area_2") ){ elem.text(dsCustData.getString("r_address")); }
	for( Element elem : cont_doc.select("span.boss_name_area_2") ){ elem.text(dsCustData.getString("r_boss_name")); }

	for( Element elem : cont_doc.select("span.cont_year_area") ){ elem.text(dsCustData.getString("cont_year")); }
	for( Element elem : cont_doc.select("span.cont_month_area") ){ elem.text(dsCustData.getString("cont_month")); }
	for( Element elem : cont_doc.select("span.cont_day_area") ){ elem.text(dsCustData.getString("cont_day")); }


	for( Element elem : cont_doc.select("span#pro_all") ){ elem.text(dsCustData.getString("r_pro")); }
	for( Element elem : cont_doc.select("span#sum_all") ){ elem.text(dsCustData.getString("r_sum")); }

	cont_html = cont_doc.toString();

	return cont_html;
}

%>
