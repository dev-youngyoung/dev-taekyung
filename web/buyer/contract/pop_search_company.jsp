<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // 씨제이대한통운
boolean isKTH = u.inArray(_member_no, new String[]{
		"20150500312" //(주)더블유쇼핑
		,"20171100802" //NICE정보통신
		});
boolean isPeple = u.inArray(_member_no, new String[]{
		 "20180101074"//유한회사 피아이솔루션즈
		,"20180101078"//유한회사 퍼스트에프에스
		,"20181200231"//유한회사 얼리페이
		,"20181201402"//유한회사 위커머스		
});  // SPC사업자 위메프 거래처 검색 가능하도록
boolean bInitSrcGrLink = !u.inArray(_member_no, new String[]{"20121203661","20121203661","20130400011","20130400010","20130400009","20130400008"} );

String search_type = u.request("search_type");  // 사업자, 개인 모두 검색할 수 있는 화면 사용(C:사업자, P:개인, B:개인사업자 대표자, 공백: 개별) CP, CP로 구분 하용 사용
String sign_seq = u.request("sign_seq");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '"+_member_no+"'");
if(!member.next()){
	u.jsErrClose("사용자 정보가 존재하지 않습니다.");
	return;
}

boolean src_l = false;
boolean src_m = false;
boolean src_s = false;
if(member.getString("src_depth").equals("01")){
	src_l = true;
}
if(member.getString("src_depth").equals("02")){
	src_l = true;
	src_m = true;
}
if(member.getString("src_depth").equals("03")){
	src_l = true;
	src_m = true;
	src_s = true;
}

if(isKTH){
	f.addElement("s_cust_detail_code",null, null);
}
f.addElement("s_member_name",null, null);
f.addElement("s_vendcd",null, null);


//목록 생성
ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(5);
if(isKTH){
	list.setTable(
		 "tcb_member a "
		+ " inner join tcb_client z on a.member_no=z.client_no "
		+ "	left outer join (select * from tcb_src_member where member_no = '"+_member_no+"') b "
		+ "   on b.src_member_no = a.member_no "
		+ "	 left outer join (select * from tcb_client where member_no = '"+_member_no+"' ) c "
	    + "   on a.member_no = c.client_no "
		+ "  left outer join (select * from tcb_client_detail where member_no = '"+_member_no+"' ) d "
		+ "   on c.client_seq= d.client_seq "
	);
	list.setFields("distinct a.*, d.cust_detail_code");
}else{
	list.setTable(
			 "tcb_member a "
			+ " inner join tcb_client z on a.member_no=z.client_no "
			+ "	left outer join (select * from tcb_src_member where member_no = '"+_member_no+"') b "
			+ "   on b.src_member_no = a.member_no "
		);
		list.setFields("distinct a.*");
}
list.addWhere("z.client_reg_cd = '1' ");
list.addWhere("a.member_gubun <> '04' ");
if(isPeple) {
	list.addWhere("z.member_no in ('20130500619', '" + _member_no + "')"); // 피플펀드는 위메프 거래처 검색 가능하도록
} else {
	list.addWhere("z.member_no = '" + _member_no + "'");
}
list.addWhere("nvl(a.status, 'z')<>'90'");
list.addWhere(" lower(a.member_name) like lower('%" + f.get("s_member_name") + "%')");
list.addSearch("a.vendcd", f.get("s_vendcd"));
if((!f.get("l_src_cd").equals(""))||(!f.get("m_src_cd").equals(""))||(!f.get("s_src_cd").equals(""))){
	list.addWhere(" b.src_cd like '"+f.get("l_src_cd")+f.get("m_src_cd")+f.get("s_src_cd")+"%' ");
}
if(isKTH&&!f.get("s_cust_detail_code").equals("")){
	list.addSearch("d.cust_detail_code", f.get("s_cust_detail_code"));
}
list.setOrderBy("a.member_name asc ");

DataSet ds = null;
if(!u.request("search").equals("")){
	//목록 데이타 수정
	ds = list.getDataSet();
	while(ds.next()){
		if(isCJT && ds.getString("member_gubun").equals("03")){  // 개인사업자
			ds.put("jumin_no", ds.getString("member_slno"));
		}else{
			ds.put("jumin_no", "");
		}
		
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
		DataObject personDao = new DataObject("tcb_person a");
		DataSet person = personDao.find(" member_no = '"+ds.getString("member_no")+"' and status > 0 ", "person_seq, user_name, tel_num, email, hp1, hp2, hp3 ");
		ds.put(".person", person);
		if(isKTH){
			ds.put("str_cust_detail_code", ds.getString("cust_detail_code").equals("")?"<span style=\"color:red\">[미등록]</span>":ds.getString("cust_detail_code"));
		}
	}
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_company");
p.setVar("popup_title","사업자 검색");
p.setVar("tab_view_cp", search_type.equals("CP"));
p.setVar("member", member);
p.setLoop("list", ds);
p.setVar("src_l", src_l);
p.setVar("src_m", src_m);
p.setVar("src_s", src_s);
p.setVar("l_src_cd", f.get("l_src_cd"));
p.setVar("m_src_cd", f.get("m_src_cd"));
p.setVar("s_src_cd", f.get("s_src_cd"));
p.setVar("sign_seq", sign_seq);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.setVar("isKTH", isKTH);   // kth는 거래처 코드 표시
p.setVar("bInitSrcGrLink", bInitSrcGrLink);   // 계약작성시 선택한 소싱그룹으로 초기 필터링 할지 여부
p.setVar("view_btn_member_insert", !_member_no.equals("20151101243"));//농협네트웍스는 비회원 업체 추가 기능 사용 안함.
p.display(out);


%>