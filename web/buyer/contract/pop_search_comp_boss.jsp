<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String search_type = u.request("search_type");  // 사업자, 개인 모두 검색할 수 있는 화면 사용(C:사업자, B:개인,개인사업자대표,P:개인, 공백: 개별)
String sign_seq = u.request("sign_seq");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '"+_member_no+"'");
if(!member.next()){
	u.jsErrClose("사용자 정보가 존재하지 않습니다.");
	return;
}

boolean isKTH = u.inArray(_member_no, new String[]{
		"20150500312" //(주)더블유쇼핑
		,"20171100802" //NICE정보통신
		});

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
list.addWhere("a.member_gubun = '03' ");
list.addWhere("z.member_no = '" + _member_no + "'");
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
		ds.put("vendcd",u.getBizNo(ds.getString("vendcd")));
		DataObject memberBossDao = new DataObject("tcb_member_boss");
		DataSet memberBoss = memberBossDao.find(" member_no = '"+ds.getString("member_no")+"' ");
		if(memberBoss.next()){
			memberBoss.put("boss_birth_date", u.getTimeString("yyyy-MM-dd", memberBoss.getString("boss_birth_date")));
			ds.put("boss_name", memberBoss.getString("boss_name"));
		} 
		ds.put(".memberBoss", memberBoss);
		if(isKTH){
			ds.put("str_cust_detail_code", ds.getString("cust_detail_code").equals("")?"<span style=\"color:red\">[미등록]</span>":ds.getString("cust_detail_code"));
		}
		
	}
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("contract.pop_search_comp_boss");
p.setVar("popup_title","개인사업자 검색");
p.setVar("tab_view_pb", search_type.equals("PB"));
p.setVar("member", member);
p.setLoop("list", ds);
p.setVar("src_l", src_l);
p.setVar("src_m", src_m);
p.setVar("src_s", src_s);
p.setVar("l_src_cd", f.get("l_src_cd"));
p.setVar("m_src_cd", f.get("m_src_cd"));
p.setVar("s_src_cd", f.get("s_src_cd"));
p.setVar("sign_seq", sign_seq);
p.setVar("isKTH", isKTH);   // kth는 거래처 코드 표시
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);


%>