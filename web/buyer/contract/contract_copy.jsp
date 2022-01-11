<%@ page import="javax.xml.crypto.Data" %>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String s_cont_no = u.aseDec(u.request("cont_no"));
String s_cont_chasu = u.request("cont_chasu");
String template_cd = u.request("template_cd");
if(s_cont_no.equals("")||s_cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

ContractDao contDao = new ContractDao();

String cont_no = contDao.makeContNo();
String cont_chasu = "0";

String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");

String cont_userno = "";

DataSet cont = contDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
if(!cont.next()){
	u.jsError("계약정보가 없습니다.");
	return;
}

DataObject attCfileDao = new DataObject("tcb_att_cfile");
if(attCfileDao.findCount("template_cd = '"+cont.getString("template_cd")+"' and  member_no = '"+cont.getString("member_no")+"' and auto_type = '1' ") > 0 ){
	u.jsError("계약서류 자동 첨부를 이용하는 계약건은 복사 기능을 사용 할 수 없습니다.");
	return;
}

//사용자 계약번호 자동 설정 여부
boolean bAutoContUserNo = u.inArray(
		_member_no
		, new String[]{
				"20150400367"	//유진기업(주)
				,"20170100166"	//주식회사 신사고아카데미
				,"20170100165"	//주식회사 좋은책신사고
				,"20160401012"	//엘지히타치워터솔루션 주식회사
				,"20150900434"	//나디아퍼시픽 주식회사
				,"20150500312"	//(주)더블유쇼핑
				,"20140900004"	//(주)케이티엠앤에스
				,"20130400011"	//한국쓰리엠보건안전 유한회사
				,"20130400010"	//한국쓰리엠 트레이딩 유한회사
				,"20130400009"	//한국쓰리엠하이테크 유한회사
				,"20130400008"	//주식회사 쓰리엠에이에스티
				,"20121203661"	//한국쓰리엠(주)
				,"20180203437"	//하이엔텍
				,"20121200073"	//로지스풀
				,"20181201176"	//카카오 커머스
				,"20131000506"	//에스케이하이스텍주식회사
				,"20190205651"	//남부산업 주식회사
				,"20190205653"	//이순산업 주식회사
				,"20190205654"	//(주) 지구레미콘
				,"20190205649"	//당진기업 (주)
				,"20190205652"	//현대개발주식회사
				,"20180100028"	//피비파트너즈
				,"20190300598"	//우아한형제들
				,"20190600117"	//에스피씨네트웍스
				,"20191101572"  //대원강업(주)
				,"20200203416"  //대륜이엔에스
				,"20200203478"  //대륜발전
				,"20200203481"  //대원강업(주)
				,"20180100684"	//교보문고
		});
if(_member_no.equals("20150900434") && !template_cd.equals("2015106")) // 나디아퍼시픽 물품공급계약서 외는 자동채번 아님.
	bAutoContUserNo = false;

if(bAutoContUserNo){
	if(u.inArray(_member_no, new String[] {"20120200001","20150400367","20190205651","20190205653","20190205654","20190205649","20190205652"})){
		
		DataObject templateDao = new DataObject("tcb_cont_template");
		DataSet template = templateDao.find(" template_cd = '"+cont.getString("template_cd")+"'", "field_seq");
		
		if(template.next()){
		}
		String dept_name ="";
		if(!"".equals(template.getString("field_seq"))){
			DataObject deptDao = new DataObject("tcb_field");
			DataSet dept = deptDao.find(" member_no = '"+_member_no+"' and field_seq =  '"+template.getString("field_seq")+"'" , " field_name");
			if(!dept.next()){
				u.jsError("부서가 설정되지 않아 계약번호를 생성할 수 없습니다.\\n고객센터로 문의해주세요.");
				return;
			}
			dept_name = dept.getString("field_name");
			cont_userno = contDao.getOne(
					  " select '"+dept_name+" '||'"+u.getTimeString("yyyyMM")+"-'||lpad(nvl(max(to_number(substr(cont_userno,-3))),0)+1,3,'0') cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no like '%"+_member_no+"%'                                                                                               "
					 +"    and cont_userno like '"+dept_name+" "+u.getTimeString("yyyyMM")+"-%'                                                            "
			);
		}else{
			u.jsError("부서가 설정되지 않아 계약번호를 생성할 수 없습니다.\\n고객센터로 문의해주세요.");
			return;
		}
		
	}else if(_member_no.equals("20170100165")){//좋은책 신사고
		cont_userno = contDao.getOne(
				 " select  'TB"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'TB"+u.getTimeString("yyMM")+"%'                                                "
				);
	}else if(_member_no.equals("20170100166")){//신사고 아카데미
		cont_userno = contDao.getOne(
				 " select  'AC"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'AC"+u.getTimeString("yyMM")+"%'                                                "
				);
	}else if(_member_no.equals("20140900004")) // 케이티엠앤에스
	{
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if(field_name.equals("")){
			u.jsError("부서가 설정되지 않아 계약번호를 생성할 수 없습니다.");
			return;
		}
		field_name = field_name + "-" + u.getTimeString("yyyy");

		int substr_pos = field_name.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '20140900004' and field_seq="+auth.getString("_FIELD_SEQ"));
		if(userNoSeq.equals("")){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno = field_name + u.strrpad(userNoSeq, 4, "0");
	}else if(_member_no.equals("20150500312")){  // 더블유쇼핑 계약번호 자동체번
		String[] wUserNo = {"2015036=>표준","2015037=>업무제휴","2015038=>상품개별","2016108=>부속","2017257=>직매입","2017259=>직매입개별"};

		String sHeader = "W쇼핑_"+ u.getItem(template_cd, wUserNo)+"_"+u.getTimeString("yy")+"_";
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 8, "0");
	}else if(_member_no.equals("20150900434")){  // 나디아 퍼시픽 계약번호 자동체번
		String[] pacificUserNo = {"2015106=>NPPO"};

		String sHeader = u.getItem(template_cd, pacificUserNo)+u.getTimeString("yyyyMM");
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");
	}else if(_member_no.equals("20160401012")){  // 엘지히타치 계약번호 자동체번 (엘지히타치 -> 테크로스 워터앤에너지) 
		String[] wUserNo = {"2016141=>GA","2016053=>CU","2016054=>GA","2016055=>PO","2016056=>PU","2018030=>PU","2018149=>CA","2018228=>SU","2018062=>PU","2018160=>PU","2020118=>GA","2020127=>BU"};
		String temp = u.getItem(template_cd, wUserNo);
		if(temp.equals("")){ 
			u.jsError("계약번호 체번 규칙이 설정 되지 않았습니다.");
			return;
		}
		String sHeader = "TWE-"+u.getTimeString("yyyy")+"-"+u.getTimeString("MM")+ temp;    
		int pos = sHeader.length();

		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),99)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");

	}else if(_member_no.equals("20180203437")){//하이엔텍 
		String[] template_gubun1 = {
				"2018063"//용역계약서
				,"2018064"//자문계약서
				,"2018065"//폐기물처리위탁계약서
				,"2018066"//폐기물처리위탁계약서
				,"2018072"//소프트웨어(시스템) 라이센스 계약
				,"2019192"//오염물질 측정 및 분석 용역계약서
				,"2019199"//(공정위) 엔지니어링활동업종 표준하도급계약서
				,"2020117" //건강검진계약서 
		};// TES-0000(년도)-00(월)-001~100 0 번대 부서
		String[] template_gubun2 = {
				 "2018062"//물품공급 계약서
				,"2018073"//건설업종 표준하도급계약서
				,"2018074"//건설자재 표준하도급계약서
				,"2018075"//기계(기타기계장비) 표준하도급 기본계약서
				,"2019202" //(공정위)화학업종 표준하도급 기본계약서
		};//TES-0000(년도)-00(월)-101~200 100번 대 부터 고객사에 변경 권고 했지만 기존사용 체게로 그냥 쓰겠다고 함. 18181818
		String[] template_gubun3 = {
			 "2018061"//공사하도급계약서
			,"2018073"//건설업종 표준하도급계약서
			,"2019200" //(공정위)전기공사업종 표준하도급계약서
			,"2019201" //(공정위)해외건설업종 표준하도급계약서
			,"2019235" //수선계약서
		};//TES-0000(년도)-00(월)-201~300 
		String query = "";
		if(u.inArray(template_cd, template_gubun1)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-0'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-0%'                                           ";
					
		}
		if(u.inArray(template_cd, template_gubun2)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-1'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-1%'                                           ";
					
		}
		if(u.inArray(template_cd, template_gubun3)){
			query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-2'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
					+"   from tcb_contmaster                                                                                                           "
					+"  where member_no = '20180203437'                                                                                                "
					+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-2%'                                           ";
					
		}
		if(!query.equals("")){
			cont_userno = contDao.getOne(query);
		}
		
	}else if(_member_no.equals("20121200073")){
		
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if("".equals(field_name)){
			u.jsError("부서가 설정되지 않아 계약번호를 생성할 수 없습니다.");
			return;
		}
		
		String[] code_logis_deptnm = {"1=>시운","2=>체인","3=>공마","4=>네운","5=>운송","6=>MHE","7=>솔루션","8=>얼라이","9=>강원","10=>경북","11=>경인",
				"12=>부산","13=>수북","14=>충북","15=>경남","16=>수남","17=>수동","18=>수서","19=>충남","20=>호남","21=>경영","22=>컨설팅","23=>법무","24=>영업1"
				,"25=>영업2","26=>임원","27=>한국로지스풀"};

		field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
		
		if("".equals(field_name)){
			u.jsError("부서 약어가 등록되지 않아 계약번호를 생성할 수 없습니다.\\n고객센터를 통해 부서약어 등록을 신청해주세요.");
			return; 
		}
		
		cont_userno = "KLP-"+field_name + "-" + u.getTimeString("yyyy-MM")+"-";
		 
		int substr_pos = cont_userno.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+cont_userno+"%'  " );
		if("".equals(userNoSeq)){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");
		 
	}else if(_member_no.equals("20181201176")){// 카카오 커머스
		cont_userno = contDao.getOne(
				  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
				 +"   from tcb_contmaster                                                                                                          "
				 +"  where member_no = '20181201176'                                                                                               "
					);
		cont_userno = u.getTimeString("yyMMdd")+cont_userno;//업체 요청사항으로 일련번호 월단위 구분 안함.
	
	}else if(_member_no.equals("20131000506")){//에스케이하이스텍주식회사
		cont_userno = contDao.getOne(
				  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
				 +"   from tcb_contmaster                                                                                                          "
				 +"  where member_no = '20131000506'                                                                                               "
				 +"    and length(cont_userno) = 13 "
				 +"    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-"+"%'  "
					);
		cont_userno = u.getTimeString("yyyy-MM")+"-"+cont_userno;
	
	}else if("20180100028".equals(_member_no)){
		
		if("2019112".equals(template_cd)){
			cont_userno = contDao.getOne(
				" select lpad(nvl(max(to_number(substr(cont_userno,6,4))),0) + 1,4,'0') as cont_userno "
				+"  from tcb_contmaster "
				+" where member_no = '"+_member_no+"' and cont_userno like '"+u.getTimeString("yyyy")+"%' "
			);
			cont_userno = u.getTimeString("yyyy") + "-" + cont_userno;
		}
	}else if(_member_no.equals("20190300598")){	//우아한형제들 2020-02-MHKCON-0008
		if("2019240".equals(template_cd) || "2019151".equals(template_cd)|| "2020068".equals(template_cd)){	// 양식 : 만화 컨텐츠 제공 계약서(법인용) <-> 만화 컨텐츠 제공 계약서(개인)(template_cd:2019151)  과 동일한 규칙 
			
			// 2019-07-MHKCON-0001
			
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKCON-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2019151','2019240','2020068')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKCON-%'"
						);
		
		}else if("2019290".equals(template_cd)){ //프리랜서 표준계약서  2019-08-MHKFRE-0001 (년도-월- MHKFRE-순번 )
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKFRE-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2019290')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKFRE-%'"
						);   
		}else if("2020106".equals(template_cd)){ //매니지먼트 위임 계약서 (년도-날짜-MHKMAG-0001 ) 
			cont_userno = contDao.getOne(
					  " select  '"+u.getTimeString("yyyy-MM")+"-MHKMAG-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '"+_member_no+"'                                                                                               "
					 +"   and template_cd in( '2020106')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKMAG-%'"
						);   
		}else{	
			bAutoContUserNo = false;
		} 
	}else if("20190600117".equals(_member_no)) {
		
		String cont_text = "'PG-'";
		if("2019173".equals(cont.getString("template_cd"))){
			cont_text = "'AG-'";
		} 
		
		cont_userno = contDao.getOne(
			  " select  "+cont_text+"  ||  '"+u.getTimeString("yyMM")+"-' || lpad(nvl(max(to_number(substr(cont_userno,10,3))),0)+1,2,'0') as cont_userno "
			 +"   from tcb_contmaster                                                                                                          "
			 +"  where member_no = '"+_member_no+"'                                                                                               "
			 +"   and template_cd in( '"+cont.getString("template_cd")+"')    and cont_userno like  "+cont_text+" ||  '"+u.getTimeString("yy-MM")+"-%'"
		);
	}else if(_member_no.equals("20191101572")){ //대원강업(주)
		
		DataObject fieldDao = new DataObject();
		String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
		if("".equals(field_name)){
			u.jsError("부서가 설정되지 않아 계약번호를 생성할 수 없습니다.");
			return;
		}
		 
		//  부서명 기준, 괄호 내 알파벳 : 연구소(R), 창원1공장(C), 창원2공장(J), 천안공장(N), 성환공장(L), 통합구매팀(H) 
		String[] code_logis_deptnm = {"1=>H","3=>R","4=>C","5=>J","6=>N","7=>L","8=>H"};

		field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
		
		if("".equals(field_name)){
			u.jsError("부서 약어가 등록되지 않아 계약번호를 생성할 수 없습니다.\\n고객센터를 통해 부서약어 등록을 신청해주세요.");
			return; 
		}
		cont_userno =  field_name + "-" + u.getTimeString("yyyy")+"-"; 
		 
		int substr_pos = cont_userno.length()+1;
		String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+cont_userno+"%'  " );
		if("".equals(userNoSeq)){
			u.jsError("계약번호 생성에 실패 하였습니다.");
			return;
		}
		cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");
		
	}else if(_member_no.equals("20200203416")){ //대륜이엔에스  DR20200001
		cont_userno = contDao.getOne(
				 " select  'DR"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'DR"+u.getTimeString("yyyy")+"%'                                                "
				); 
	}else if(_member_no.equals("20200203478")){ //대륜발전	 
		cont_userno = contDao.getOne( 
				 " select  'DP"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'DP"+u.getTimeString("yyyy")+"%'                                                "
				);  
	}else if(_member_no.equals("20200203481")){ //별내에너지		
		cont_userno = contDao.getOne(
				 " select  'BE"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
				+"    from tcb_contmaster                                                                                   "
				+"  where member_no = '"+_member_no+"'                                                                      "
				+"     and cont_userno like 'BE"+u.getTimeString("yyyy")+"%'                                                "
				);   
	}else if(_member_no.equals("20180100684")){//교보문고
		cont_userno = contDao.getOne(
				" select  '"+u.getTimeString("yyMMdd")+"' || lpad(nvl(max(to_number(substr(cont_userno,7,10))),0)+1,4,'0') as cont_userno "
						+"   from tcb_contmaster                                                                                          "
						+"  where member_no = '"+_member_no+"'                                                                            "
						+"    and cont_userno like '"+u.getTimeString("yyMMdd")+"%'"
		);
	}else {
		cont_userno = cont_no + "-" + cont_chasu;
	}

}else{
	cont_userno = "";
}

DB db = new DB();

//계약마스터
contDao = new ContractDao("tcb_contmaster");
cont.removeColumn("__last,__ord");
cont.put("cont_no", cont_no);
cont.put("cont_chasu", "0");
cont.put("member_no", _member_no);
cont.put("field_seq", auth.getString("_FIELD_SEQ"));
cont.put("cont_userno", cont_userno);
cont.put("cont_name", cont.getString("cont_name")+"_복사본");
cont.put("cont_html", cont.getString("org_cont_html"));
cont.put("org_cont_html", "");
cont.put("true_random", cont.getString("true_random"));
cont.put("reg_date", u.getTimeString());
cont.put("reg_id",auth.getString("_USER_ID"));
cont.put("status", "10");
contDao.item(cont.getRow());
db.setCommand(contDao.getInsertQuery(), contDao.record);


//서명 관계 저장
DataObject contSignDao = new DataObject("tcb_cont_sign");
DataSet contSign = contSignDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contSign.removeColumn("__last,__ord");
while(contSign.next()){
	contSign.put("cont_no", cont_no);
	contSign.put("cont_chasu", "0");
	contSignDao = new DataObject("tcb_cont_sign");

	contSignDao.item(contSign.getRow());
	db.setCommand(contSignDao.getInsertQuery(), contSignDao.record);
}


//계약양식 서브
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataSet contSub = contSubDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contSub.removeColumn("__last,__ord");
while(contSub.next()){
	contSub.put("cont_no", cont_no);
	contSub.put("cont_chasu", "0");
	contSub.put("cont_sub_html", contSub.getString("org_cont_sub_html"));

	contSubDao = new DataObject("tcb_cont_sub");
	contSubDao.item(contSub.getRow());
	db.setCommand(contSubDao.getInsertQuery(), contSubDao.record);
}

//계약업체
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
cust.removeColumn("__last,__ord");
while(cust.next()){
	cust.put("cont_no", cont_no);
	cust.put("cont_chasu", "0");
	cust.put("sign_date", "");
	cust.put("sign_dn", "");
	cust.put("sign_data","");
	cust.put("email_random","");
	cust.put("pay_yn","");
	if(cust.getString("member_no").equals(cont.getString("member_no"))){
		DataObject memberDao = new DataObject("tcb_member");
		DataSet member = memberDao.find(" member_no = '"+_member_no+"' ");
		if(!member.next()){
		}
		cust.put("member_name", member.getString("member_name"));
		cust.put("vendcd", member.getString("vendcd"));
		cust.put("boss_name", member.getString("boss_name"));
		cust.put("post_code", member.getString("post_code"));
		cust.put("address", member.getString("address"));
		cust.put("member_slno", member.getString("member_slno"));
		DataObject personDao = new DataObject("tcb_person");
		DataSet person = personDao.find("member_no = '"+_member_no+"' and user_id = '"+auth.getString("_USER_ID")+"' ");
		if(!person.next()){
			cust.put("tel_num", person.getString("tel_num"));
			cust.put("user_name", person.getString("user_name"));
			cust.put("hp1", person.getString("hp1"));
			cust.put("hp2", person.getString("hp2"));
			cust.put("hp3", person.getString("hp3"));
			cust.put("email", person.getString("email"));
		}
	}else{
		cust.put("member_no", "00000000000");
		cust.put("vendcd", "0000000000");
		cust.put("jumin_no", "");
		cust.put("member_name", "복사한 계약");
		cust.put("post_code", "");
		cust.put("address", "계약 복사시 업체삭제 후 재선택必");
		cust.put("tel_num", "");
		cust.put("member_slno", "");
		cust.put("user_name", "");
		cust.put("hp1", "");
		cust.put("hp2", "");
		cust.put("hp3", "");
		cust.put("email", "");
		cust.put("cust_detail_code", "");
	}

	custDao = new DataObject("tcb_cust");
	custDao.item(cust.getRow());
	db.setCommand(custDao.getInsertQuery(), custDao.record);
}


//계약파일
String file_path = u.getTimeString("yyyy")+"/"+_member_no+"/"+cont_no+"/";
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"' and auto_yn = 'Y'");
if(cfile.size() > 0){
	File folder = new File(Startup.conf.getString("file.path.bcont_pdf")+file_path);
	if(!folder.exists()){
		folder.mkdirs();
	}
}
String cont_hash = "";
cfile.removeColumn("__last,__ord");
while(cfile.next()){
	String source = Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name");
	String target = Startup.conf.getString("file.path.bcont_pdf")+ file_path + cfile.getString("file_name");
	u.copyFile(source, target);
	if(!cont_hash.equals(""))cont_hash += "|";
	cont_hash += contDao.getHash("file.path.bcont_pdf",file_path + cfile.getString("file_name"));

	cfile.put("cont_no", cont_no);
	cfile.put("cont_chasu", "0");
	cfile.put("file_path", cfile.getString("auto_type").equals("2")?"":file_path);
	cfile.put("file_name", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_name"));
	cfile.put("file_ext", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_ext"));
	cfile.put("file_size", cfile.getString("auto_type").equals("2")?"":cfile.getString("file_size"));
	cfileDao = new DataObject("tcb_cfile");
	cfileDao.item(cfile.getRow());
	db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
}


// 결제 라인
DataObject contAgreeDao = new DataObject("tcb_cont_agree");
DataSet contAgree = contAgreeDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
contAgree.removeColumn("__last,__ord");
while(contAgree.next()){
	contAgree.put("cont_no", cont_no);
	contAgree.put("cont_chasu", cont_chasu);
	contAgree.put("r_agree_person_id", "");
	contAgree.put("r_agree_person_name", "");
	contAgree.put("ag_md_date", "");

	contAgreeDao = new DataObject("tcb_cont_agree");
	contAgreeDao.item(contAgree.getRow());
	db.setCommand(contAgreeDao.getInsertQuery(), contAgreeDao.record);
}

//보증
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
while(warr.next()){
	warrDao = new DataObject("tcb_warr");
	warrDao.item("cont_no",cont_no);
	warrDao.item("cont_chasu", "0");
	warrDao.item("member_no", warr.getString("member_no"));
	warrDao.item("warr_seq", warr.getString("warr_seq"));
	warrDao.item("warr_type", warr.getString("warr_type"));
	warrDao.item("etc", warr.getString("etc"));
	db.setCommand(warrDao.getInsertQuery(), warrDao.record);
}

//구비서류
DataObject rfileDao = new DataObject("tcb_rfile");
DataSet rfile = rfileDao.find(" cont_no = '"+s_cont_no+"' and cont_chasu = '"+s_cont_chasu+"'");
rfile.removeColumn("__last,__ord");
while(rfile.next()){
	rfileDao = new DataObject("tcb_rfile");
	rfile.put("cont_no", cont_no);
	rfile.put("cont_chasu", "0");
	rfileDao = new DataObject("tcb_rfile");
	rfileDao.item(rfile.getRow());
	db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
}

//계약 hash
contDao = new ContractDao("tcb_contmaster");
contDao.item("cont_hash", cont_hash);
db.setCommand(contDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '0'"), contDao.record);

/* 계약로그 START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "전자문서 생성",  "복사", "10","10");
/* 계약로그 END*/

if(!db.executeArray()){
	u.jsError("처리에 실패하였습니다.");
	return;
}
if(cont.getString("sign_types").equals("")) {
	u.jsAlertReplace("계약서를 생성 하였습니다. \\n\\n임시저장계약 메뉴로 이동 합니다.", "./contract_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=0");
}else{
	u.jsAlertReplace("계약서를 생성 하였습니다. \\n\\n임시저장계약 메뉴로 이동 합니다.", "./contract_msign_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=0");
}
%>


