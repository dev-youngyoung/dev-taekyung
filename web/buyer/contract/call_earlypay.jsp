<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import  = " net.sf.json.JSONObject"%>
<%
//String connect_module = "D:\\nicedata\\https_client\\earlypay.bat";
String connect_module = "/application/nicesh/earlypay.sh";
String vendcd = u.request("vendcd");
String template_cd = u.request("template_cd");

if(vendcd.equals("")) {
	return;
}


/*
	{
		"loan_id": "403",                       # Loan ID
		"business_number": "3716012095",        # 사업자 번호
		"company_name": "유한회사 대건균",      # 회사명
		"representative_name": "망절솔람",      # 대표자 이름
		"representative_phone": "0439526988",   # 대표자 휴대전화
		"manager": "선우명",                    # 담당자 이름
		"manager_phone": "0527368311",          # 담당자 휴대전화
		"email": "saseon@hanmail.net",          # 이메일 주소
		"wmp_id": "heo55",                      # 위메프 아이디
		"max_amount": "34210000",               # 선정산 한도
		"service_fee": "0.00048",               # 서비스 이용료
		"bank_name": "기업",                    # 정산 계좌 은행명
		"bank_account": "01928374650192",       # 정산 계좌 번호
	}
*/

JSONObject retJSON = null;
try {
	String buffer = null;
	String ret = "";

	String connServer = "";

	System.out.println("_member_no : " + _member_no);

	String[] cmd =  null;

	if(_member_no.equals("20180101074")) {// 유한회사 피아이솔루션즈
		connServer = "https://earlypay-admin.peoplefund.co.kr";
		cmd = new String[] {connect_module,"G", connServer, vendcd};
	} else if(u.inArray(_member_no, new String[]{"20180101078", "20181200231","20181201402","20191002081"})) {  // 펀다 (20180101078), 20181200231(얼리페이), 20181201402(유한회사 위커머스),20191002081(이세틀 유한회사)
		if (template_cd.equals("2019294")) {
			connServer = "https://wecommerce.co.kr/Nice/getAccno";
			//cmd = new String[]{connect_module, "G2", connServer, vendcd};
			String param = u.aseEnc("bizRegNo=>"+vendcd+"||conNo=>"+u.request("cont_userno"));
			cmd = new String[]{connect_module, "COMMON", connServer, "-", param };
		} else if (template_cd.equals("2019319")){
			connServer = "http://ebokjimall.co.kr/Nice/getAccno";
			String param = u.aseEnc("bizRegNo=>"+vendcd+"||conNo=>"+u.request("cont_userno"));
			cmd = new String[]{connect_module, "COMMON", connServer, "-", param };
		}else{
			connServer = "https://earlypay.funda.kr";
			cmd = new String[] {connect_module,"G", connServer, vendcd};
		}

	}  else if(_member_no.equals("20180200294")) {  // 주식회사 피플펀드대부
		connServer = "https://www.peoplefund.co.kr";
		//connServer = "https://doutside.peoplefund.co.kr/";
		if(template_cd.equals("2019057")){
			cmd = new String[] {connect_module,"U", connServer, vendcd};
		}else if(template_cd.equals("2019105")){
			cmd = new String[] {connect_module,"APT", connServer, vendcd};
		}else{
			cmd = new String[] {connect_module,"T", connServer, vendcd};
		}
	}

	//  개발시 막음
	Process process = new ProcessBuilder(cmd).start();
	BufferedReader stdOut = new BufferedReader( new InputStreamReader(process.getInputStream()) );

	// 표준출력 상태를 출력
	while( (buffer = stdOut.readLine()) != null ) {
		ret += buffer;
	}
	System.out.println("ret - "+ret);
	/*
	ret = "{\n" +
			"   \"tranche_id\": \"23\",\n" +
			"   \"creditor_corporate_number\": \"2018-금감원-1359(P2P연계대부업)\",\n" +
			"   \"debtor_business_number\": \"28586-00982\",\n" +
			"   \"total_loan_amount\": 1000000000,\n" +
			"   \"a_loan_amount\": 900000000,\n" +
			"   \"a_loan_interest_rate\": 10.1,\n" +
			"   \"a_loan_month\": 12,\n" +
			"   \"b_loan_amount\": 70000000,\n" +
			"   \"b_loan_interest_rate\": 10.2,\n" +
			"   \"b_loan_month\": 13,\n" +
			"   \"c_loan_amount\": 30000000,\n" +
			"   \"c_loan_interest_rate\": 10.3,\n" +
			"   \"c_loan_month\": 14,\n" +
			"   \"interest_rate\": 25,\n" +
			"   \"underlying_loans\": [\n" +
			"      {\n" +
			"         \"seq\": 1,\n" +
			"         \"code\": \"SR-218\",\n" +
			"         \"investment_amount\": 100000000,\n" +
			"         \"pledge_amount\": 100000000,\n" +
			"         \"interest_rate\": 15,\n" +
			"         \"loan_month\": 10\n" +
			"      },\n" +
			"      {\n" +
			"         \"seq\": 2,\n" +
			"         \"code\": \"SR-218\",\n" +
			"         \"investment_amount\": 110000000,\n" +
			"         \"pledge_amount\": 110000000,\n" +
			"         \"interest_rate\": 16,\n" +
			"         \"loan_month\": 11\n" +
			"      }\n" +
			"   ],\n" +
			"   \"total_loan_amounts\": [\n" +
			"      {\n" +
			"         \"total_loan_amount\": 500000\n" +
			"      },\n" +
			"      {\n" +
			"         \"total_loan_amount\": 55500000\n" +
			"      }\n" +
			"   ],\n" +
			"   \"total_underlying_loan_pledge_amount\": 1200000000\n" +
			"}";
*/
	retJSON = JSONObject.fromObject(ret.substring(ret.indexOf("{")));  // json 값만 가져오기

	System.out.println("retJSON - "+retJSON);

	if(!u.inArray(template_cd, new String[]{"2019294","2019319"})) {
		if (ret.indexOf("message") > 0) {// 에러 메시지
			String message = retJSON.getString("message");
			System.out.println("통신 에러 :" + message);
			u.jsAlert("연동시 정보를 가져올 수 없어 기본정보만 설정합니다.\\n\\n[Error message] " + message);
			return;
		}
	}

} catch(Exception ex) {
	System.out.println("통신 에러 :" + ex.getMessage());
	u.jsAlert("연동시 정보를 가져올 수 없어 기본정보만 설정합니다.\\n\\n[Error message] " + ex.getMessage().replaceAll("'","").replaceAll("\"",""));
	return;
}

System.out.println("json 파싱 시작");

if( u.inArray(_member_no, new String[] {"20180101074", "20180101078","20181200231","20181201402","20191002081"}) ) {
	if(u.inArray(template_cd, new String[]{"2019294","2019319"})){
		String resultCode = retJSON.getString("resultCode");
		String bank_account = retJSON.getString("accno");
		String message = retJSON.getString("message");
		if(resultCode.equals("01")) {
			out.println("<script>");
			out.println("document.forms['form1']['bank_account'].value='" + bank_account + "';");
			out.println("replaceInput(document.forms['form1']['bank_account'], 'bank_account', document.all.__html);");
			out.println("</script>");
		}else{
			out.println("<script>");
			out.println("alert('연동실패 메세지 : "+message+"');");
			out.println("</script>");
		}
	}else {
		String loan_id = retJSON.getString("loan_id");
		String business_number = retJSON.getString("business_number");
		String company_name = retJSON.getString("company_name");
		String representative_name = retJSON.getString("representative_name");
		String representative_phone = retJSON.getString("representative_phone");
		String manager = retJSON.getString("manager");
		String manager_phone = retJSON.getString("manager_phone");
		String email = retJSON.getString("email");
		String wmp_id = retJSON.getString("wmp_id");
		String max_amount = Util.numberFormat(retJSON.getString("max_amount"));
		String service_fee = retJSON.getString("service_fee");
		String bank_name = retJSON.getString("bank_name");
		String bank_account = retJSON.getString("bank_account");
		String bank_account_holder = retJSON.getString("bank_account_holder");
		out.println("<script>");
		out.println("document.forms['form1']['loan_id'].value='" + loan_id + "';");
		out.println("document.forms['form1']['manager'].value='" + manager + "';");
		out.println("document.forms['form1']['manager_phone'].value='" + manager_phone + "';");
		out.println("document.forms['form1']['boss_email'].value='" + email + "';");
		out.println("document.forms['form1']['representative_phone'].value='" + representative_phone + "';");
		out.println("document.forms['form1']['wmp_id'].value='" + wmp_id + "';");
		out.println("document.forms['form1']['max_amount'].value='" + max_amount + "';");
		out.println("fSetKoreanMoney('" + max_amount + "', 'spn_a1');");
		out.println("document.forms['form1']['service_fee'].value='" + service_fee + "';");
		out.println("document.forms['form1']['bank_name'].value='" + bank_name + "';");
		out.println("document.forms['form1']['bank_account'].value='" + bank_account + "';");
		out.println("document.forms['form1']['bank_account_holder'].value='" + bank_account_holder + "';");
		out.println("</script>");
	}
} else {
	out.println("<script>");
	//out.println("setInfo('1');");
	out.println("document.forms['form1']['creditor_corporate_number'].value='"+retJSON.getString("creditor_corporate_number")+"';");
	
	//대부계약서인 경우 트렌치 대출
	if(retJSON.containsKey("a_loan_amount")){
		if(!retJSON.getString("a_loan_amount").equals("") && !retJSON.getString("a_loan_amount").equals("null")) {
			out.println("document.forms['form1']['a_loan_amount'].value='" + Util.numberFormat(retJSON.getString("a_loan_amount")) + "';");
			out.println("fSetKoreanMoney('" + retJSON.getString("a_loan_amount") + "', 'spn_a_loan_amount');");
			out.println("document.forms['form1']['a_loan_interest_rate'].value='" + retJSON.getString("a_loan_interest_rate") + "';");
			out.println("document.forms['form1']['a_due_date'].value='" + retJSON.getString("a_due_date") + "';");
		}
	}
	if(retJSON.containsKey("b_loan_amount")){
		if(!retJSON.getString("b_loan_amount").equals("") && !retJSON.getString("b_loan_amount").equals("null")) {
			out.println("document.forms['form1']['b_loan_amount'].value='" + Util.numberFormat(retJSON.getString("b_loan_amount")) + "';");
			out.println("fSetKoreanMoney('" + retJSON.getString("b_loan_amount") + "', 'spn_b_loan_amount');");
			out.println("document.forms['form1']['b_loan_interest_rate'].value='" + retJSON.getString("b_loan_interest_rate") + "';");
			out.println("document.forms['form1']['b_due_date'].value='" + retJSON.getString("b_due_date") + "';");
		}
	}
	
	if(retJSON.containsKey("c_loan_amount")){
		if(!retJSON.getString("c_loan_amount").equals("") && !retJSON.getString("c_loan_amount").equals("null") ) {
			out.println("document.forms['form1']['c_loan_amount'].value='" + Util.numberFormat(retJSON.getString("c_loan_amount")) + "';");
			out.println("fSetKoreanMoney('" + retJSON.getString("c_loan_amount") + "', 'spn_c_loan_amount');");
			out.println("document.forms['form1']['c_loan_interest_rate'].value='"+retJSON.getString("c_loan_interest_rate")+"';");
			out.println("document.forms['form1']['c_due_date'].value='"+retJSON.getString("c_due_date")+"';");
		}
	}
	
	out.println("if(typeof setLoanAmt === 'function'){ setLoanAmt();}");
	
	
	//디딤돌인 경우
	if(retJSON.containsKey("loan_amount")){
		if(!retJSON.getString("loan_amount").equals("") && !retJSON.getString("loan_amount").equals("null")) {
			out.println("document.forms['form1']['loan_amount'].value='" + Util.numberFormat(retJSON.getString("loan_amount")) + "';");
			out.println("replaceInput(document.forms['form1']['loan_amount'].value,'loan_amount',document.__html);");
			out.println("fSetKoreanMoney('" + retJSON.getString("loan_amount") + "', 'spn_loan_amount');");
			out.println("document.forms['form1']['loan_interest_rate'].value='" + retJSON.getString("loan_interest_rate") + "';");
			out.println("document.forms['form1']['due_date'].value='" + retJSON.getString("due_date") + "';");
		}
	}

	//System.out.println(retJSON.getJSONArray("underlying_loans").size());
	//out.println("button_delAllRow('table_template_1');");
	//out.println("button_delAllRow('table_template_2', document.form1.s2_code);");
	if(retJSON.getJSONArray("underlying_loans").size()> 0){
		out.println("if(document.getElementById('table_template_1')){");
		out.println("button_delAllRow('table_template_1')");
		out.println("document.getElementsByName('s1_seq')[0].value='';");
		out.println("document.getElementsByName('s1_code')[0].value='';");
		out.println("}");
		out.println("if(document.getElementById('table_template_2')){");
		out.println("button_delAllRow('table_template_2')");
		out.println("document.getElementsByName('s2_seq')[0].value='';");
		out.println("document.getElementsByName('s2_code')[0].value='';");
		out.println("}");
	}
	for(int i=0; i<retJSON.getJSONArray("underlying_loans").size(); i++) {
		//out.println("var r_index = button_addRow('table_template_1',0, document.form1.s1_code.value)-1;");
		//out.println("var r_index = button_addRow('table_template_2',0, document.form1.s2_code.value)-1;");
		out.println("var r_index = button_addRow('table_template_1',0, document.querySelector(\"input[name=s1_code]\").value)-1;");
		out.println("var r_index = button_addRow('table_template_2',0, document.querySelector(\"input[name=s2_code]\").value)-1;");
		JSONObject subJson = (JSONObject) retJSON.getJSONArray("underlying_loans").get(i);

		//System.out.println(subJson);
		//out.println("alert('"+subJson+"');");
		out.println("document.getElementsByName('s1_seq')[r_index].value='"+subJson.getString("seq")+"';");
		out.println("document.getElementsByName('s1_code')[r_index].value='"+subJson.getString("code")+"';");  //채권번호
		
		if(subJson.containsKey("investment_amount")){
			out.println("document.getElementsByName('s1_investment_amount')[r_index].value='"+Util.numberFormat(subJson.getString("investment_amount"))+"';");  //투자원금
		}
		
		if(subJson.containsKey("pledge_amount")){
			out.println("if(document.getElementsByName('s1_pledge_amount')[r_index]){ ");
			out.println("document.getElementsByName('s1_pledge_amount')[r_index].value='"+Util.numberFormat(subJson.getString("pledge_amount"))+"';"); //질권설정액
			out.println("}");
		}
		
		if(subJson.containsKey("bank_loan_account")){
			out.println("document.getElementsByName('s1_bank_loan_account')[r_index].value='"+subJson.getString("bank_loan_account")+"';"); // 은행코드
		}
		if(subJson.containsKey("bank_tmid")){
	        out.println("if(document.getElementsByName('s1_bank_tmid')[r_index] != null) {");
			out.println("document.getElementsByName('s1_bank_tmid')[r_index].value='"+subJson.getString("bank_tmid")+"';"); // 은행식별코드 -2018.12.06 추가
	        out.println("}");
		}

		out.println("document.getElementsByName('s2_seq')[r_index].value='"+subJson.getString("seq")+"';");
		out.println("document.getElementsByName('s2_code')[r_index].value='"+subJson.getString("code")+"';");
		
		if(subJson.containsKey("investment_amount")){
			out.println("document.getElementsByName('s2_investment_amount')[r_index].value='"+Util.numberFormat(subJson.getString("investment_amount"))+"';");
		}
		
		if(subJson.containsKey("pledge_amount")){
			out.println("if(document.getElementsByName('s2_pledge_amount')[r_index]){ ");
			out.println("document.getElementsByName('s2_pledge_amount')[r_index].value='"+Util.numberFormat(subJson.getString("pledge_amount"))+"';");
			out.println("}");
		}
		
		if(subJson.containsKey("bank_loan_account")){
			out.println("document.getElementsByName('s2_bank_loan_account')[r_index].value='"+subJson.getString("bank_loan_account")+"';"); // 은행코드 -2018.12.06 추가
		}
        
		if(subJson.containsKey("bank_tmid")){//디딤돌은 없음.
			out.println("if(document.getElementsByName('s2_bank_tmid')[r_index] != null) {");
			out.println("document.getElementsByName('s2_bank_tmid')[r_index].value='"+subJson.getString("bank_tmid")+"';"); // 은행식별코드 -2018.12.06 추가
	        out.println("}");
        }
	}

	//out.println("button_delAllRow('table_template_3');");
	//out.println("button_delAllRow('table_template_4');");
	if(retJSON.getJSONArray("specific_loan_amounts").size()> 0){
		out.println("if(document.getElementById('table_template_3')){");
		out.println("button_delAllRow('table_template_3')");
		out.println("document.getElementsByName('total_loan_amount')[0].value='';");
		out.println("}");
		out.println("if(document.getElementById('table_template_4')){");
		out.println("button_delAllRow('table_template_4')");
		out.println("document.getElementsByName('total_loan_amount2')[0].value='';");
		out.println("}");
	}
	for(int i=0; i<retJSON.getJSONArray("specific_loan_amounts").size(); i++) {
		JSONObject subJson2 = (JSONObject) retJSON.getJSONArray("specific_loan_amounts").get(i);
		//System.out.println(subJson2);
		out.println("if(document.getElementById('table_template_3')){");
		out.println("var r2_index = button_addRow('table_template_3',0, document.form1.total_loan_amount.value)-1;");
		out.println("document.getElementsByName('total_loan_amount')[r2_index].value='"+Util.numberFormat(subJson2.getString("specific_loan_amount"))+"';"); // 특정근 담보
		out.println("}");
		
		out.println("if(document.getElementById('table_template_4')){");
		out.println("var r3_index = button_addRow('table_template_4',0, document.form1.total_loan_amount2.value)-1;");
		out.println("document.getElementsByName('total_loan_amount2')[r3_index].value='"+Util.numberFormat(subJson2.getString("specific_loan_amount"))+"';"); // 특정근 담보
		out.println("}");
	}


	out.println("chgContDate();");
	out.println("if(document.getElementById('spn_s1_investment_amount')){ sumTotal('s1_investment_amount'); }");
	out.println("if(document.getElementById('spn_s1_pledge_amount')){ sumTotal('s1_pledge_amount'); }");
	out.println("if(document.getElementById('spn_s2_investment_amount')){ sumTotal('s2_investment_amount'); }");
	out.println("if(document.getElementById('spn_s2_pledge_amount')){ sumTotal('s2_pledge_amount'); }");

	out.println("if(document.forms['form1']['collateral_amount']){ ");
	out.println("document.forms['form1']['collateral_amount'].value='"+Util.numberFormat(retJSON.getString("collateral_amount"))+"';"); // 담보한도액
	out.println("fSetKoreanMoney('"+retJSON.getString("collateral_amount")+"', 'spn_collateral_amount');");
	out.println(" } ");

	out.println("if(document.forms['form1']['collateral_amount2']){ ");
	out.println("document.forms['form1']['collateral_amount2'].value='"+Util.numberFormat(retJSON.getString("collateral_amount"))+"';"); // 담보한도액
	out.println("fSetKoreanMoney('"+retJSON.getString("collateral_amount")+"', 'spn_collateral_amount2');");
	out.println(" } ");
	
	out.println("alert('조회를 완료하였습니다');");
	out.println("</script>");
}
%>