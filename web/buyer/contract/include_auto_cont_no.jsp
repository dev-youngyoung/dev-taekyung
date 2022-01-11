<%!

public boolean isAutoMember(String member_no){
	boolean result = Util.inArray(
			member_no
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
					,"20191101572"  //대원강업(주)
					,"20200203416"  //대륜이엔에스
			    	,"20200203478"  //대륜발전
				    ,"20200203481"  //대원강업(주)
					}
			);
	return result;
}

public String getAutoContUserNo(String member_no, String template_cd, Auth auth){
	String cont_userno = "";
	
	// 부서명 기준으로 규칙 생성
			if(u.inArray(_member_no, new String[] {"20150400367","20190205651","20190205653","20190205654","20190205649","20190205652"})){
				
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
			}else if(_member_no.equals("20160401012")){  // 엘지히타치 계약번호 자동체번
				String[] wUserNo = {"2016141=>GA","2016053=>CU","2016054=>GA","2016055=>PO","2016056=>PU","2018030=>PU","2018149=>CA","2018228=>SU","2018062=>PU","2018160=>PU","2020118=>GA","2020127=>BU"};
				String temp = u.getItem(template_cd, wUserNo);
				if(temp.equals("")){
					u.jsError("계약번호 체번 규칙이 설정 되지 않았습니다.");
					return;
				}
				String sHeader = "TWE-" + u.getTimeString("yyyy")+"-"+u.getTimeString("MM")+ temp; // LHWS 삭제
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
						,"2020117" //건강검진계약서 
				};// TES-0000(년도)-00(월)-001~100 0 번대 부서
				String[] template_gubun2 = {
						 "2018062"//물품공급 계약서
						,"2018074"//건설자재 표준하도급계약서
						,"2018075"//기계(기타기계장비) 표준하도급 기본계약서
				};//TES-0000(년도)-00(월)-101~200 100번 대 부터 고객사에 변경 권고 했지만 기존사용 체게로 그냥 쓰겠다고 함. 18181818
				String[] template_gubun3 = {
					 "2018061"//공사하도급계약서
					,"2018073"//건설업종 표준하도급계약서
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
				if("".equals(field_name) ){
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
				String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
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
				
			}else if(_member_no.equals("20191101572")){ //대원강업(주)
				
				DataObject fieldDao = new DataObject();
				String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
				if("".equals(field_name) ){
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
				String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
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
			
			}else {
				cont_userno = cont_no + "-" + cont_chasu;
			} 
	return cont_no;
}


%>