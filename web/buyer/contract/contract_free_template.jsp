<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
// 서비스 이용 기간 체크
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("서비스 이용기간이 종료 되었습니다.\\n\\n나이스다큐 고객센터[02-788-9097]에 문의하세요.");
	return;
}

if(_member_no.equals("20130900194")) // 카카오
	code_signer = new String[]{"11=>다음카카오","12=>서비스제공자","13=>양도인","14=>양수인","15=>광고주"};


if(auth.getString("_FIELD_SEQ")== null || auth.getString("_FIELD_SEQ").equals("")){
	if(auth.getString("_DEFAULT_YN").equals("Y")){
		u.jsError("담당부서 정보가 없습니다.\\n\\n상단의 회사정보수정 -> 담당자 관리 메뉴에서 부서 정보를 입력 하여 주세요.");
		return;
	}else{
		u.jsError("담당부서 정보가 없습니다.\\n\\n기본 관리자에게 부서 정보 입력을 요청 하세요.");
		return;
	}
}

// 담당자 정보 조회
DataObject memberDao = new DataObject("tcb_member");
DataSet cust = memberDao.query(
 "	select a.member_no, a.vendcd, a.post_code, a.member_slno, a.address, a.member_name, a.boss_name, "
+"	        b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq "
+"	  from tcb_member a, tcb_person b "
+"	 where a.member_no = b.member_no "
+"	  and a.member_no = '"+_member_no+"' "
+"	  and b.person_seq = '"+auth.getString("_PERSON_SEQ")+"'	 "
);
if(!cust.next()){
	u.jsError("사용자 정보가 존재 하지 않습니다.");
	return;
}

// 자유서식 내부 결재 양식 목록조회

DataObject agreeTemplateDao = new DataObject();
DataSet agreeTemplate= agreeTemplateDao.query("select distinct template_cd from tcb_agree_user where user_id = '"+_member_no+"' order by template_cd");//회원번호로 저장해둠.
if(agreeTemplate.size()==0){
	agreeTemplate= agreeTemplateDao.query("select distinct template_cd from tcb_agree_user where user_id = '"+auth.getString("_USER_ID")+"' order by template_cd");
}

if(agreeTemplate.size() > 0)
{
	String[] arrTemplateName = null;
	String[] pacific_member ={
			 "20150700962"//태평양물산 주식회사
			,"20150900434"//나디아퍼시픽 주식회사
			,"20161200051"//리탠다드 주식회사
			,"20170101568"//와이즈퍼시픽(주)
			,"20170200181"//태평양물산(주) 서울지점
			,"20180602065"//웰라이스 주식회사	
			,"20190600751"//플레이퍼시픽
			,"20180600778"//로지스올 주식회사
	};
	if(u.inArray(_member_no, pacific_member)) // 태평양물산
	{
		if(_member_no.equals("20150700962")||_member_no.equals("20170200181")){//태평양물산, 태평양물산 서울지점
			arrTemplateName = new String[] {"작성자→부서담당자(결재)→법무(합의)→협력사(서명)→작성자(서명)","작성자→부서담당자(결재)→법무(합의)→협력사(서명)→법무(서명)"};
		}else{
			arrTemplateName = new String[] {"작성자→부서담당자(결재)→법무(합의)→협력사(서명)→작성자(서명)"};
		}
	}
	else if(_member_no.equals("20131000184")) // 덕양산업
		arrTemplateName = new String[] {"작성자→거래처 서명→팀장(승인)→부문장(승인)→본사 서명"};
	else if(_member_no.equals("20181101476")){
		arrTemplateName = new String[] {"작성자→협력사 서명→경영지원팀 서명"};
	}else if(_member_no.equals("20180600778")){
		arrTemplateName = new String[] {"작성자→팀장→협력사 서명→본사서명(작성자)"};
	}
	else
	{
		arrTemplateName = new String[agreeTemplate.size()];
		for(int j=0; j<arrTemplateName.length; j++)
			arrTemplateName[j] = "결재선_"+(j+1);
	}
	
	int z=0;
	while(agreeTemplate.next()){
		agreeTemplate.put("agree_template_name", arrTemplateName[z++]);
	}
}


if(u.isPost()&&f.validate()){

	DB db = new DB();
	db.setDebug(out);
	DataObject custDao = new DataObject("tcb_cust_temp");
	//custDao.setDebug(out);
	//temp저장 채번
	int temp_seq = custDao.getOneInt(" select nvl(max(temp_seq),0)+1 from tcb_cust_temp where main_member_no = '"+_member_no+"'");

// 업체 저장
	String[] member_no = f.getArr("member_no");
	String[] signer_name = f.getArr("signer_name");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] member_name = f.getArr("member_name");
	String[] boss_name = f.getArr("boss_name");
	String[] post_code = f.getArr("post_code");
	String[] address = f.getArr("address");
	String[] tel_num = f.getArr("tel_num");
	String[] member_slno = f.getArr("member_slno");
	String[] user_name = f.getArr("user_name");
	String[] hp1 = f.getArr("hp1");
	String[] hp2 = f.getArr("hp2");
	String[] hp3 = f.getArr("hp3");
	String[] email = f.getArr("email");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		custDao = new DataObject("tcb_cust_temp");
		custDao.item("main_member_no", _member_no);
		custDao.item("member_no",member_no[i]);
		custDao.item("temp_seq", temp_seq);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("signer_name", signer_name[i]);
		custDao.item("cust_gubun", "01");//01:사업자 02:개인
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-",""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i]);
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}

	if(!db.executeArray()){
		u.jsError("작성중 오류가 발생 하였습니다.");
		return;
	}
	u.redirect("contract_free_insert.jsp?temp_seq="+temp_seq+"&first_cont_no="+f.get("first_cont_no")+"&first_cont_chasu="+f.get("first_cont_chasu")+"&template_cd="+f.get("template_cd"));
	return;
}


p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_free_template");
p.setVar("menu_cd","000055");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000055", "btn_auth").equals("10"));
p.setLoop("code_signer", u.arr2loop(code_signer));
p.setLoop("cust", cust);
p.setLoop("agreeTemplate", agreeTemplate);
p.setVar("detail_person", auth.getString("_MEMBER_NO").equals("20121000046") ? true : false );   // 파렛트폴은 담당자 세부정보 표시
p.setVar("form_script", f.getScript());
p.display(out);
%>