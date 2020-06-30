<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = u.request("main_member_no");
if(main_member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

DataObject userCodeDao = new DataObject("tcb_user_code");
DataSet userCode = userCodeDao.query(
  " select code                            "
 +"      , code_nm                         "
 +"      , (select code_nm                 "
 +"           from tcb_user_code           "
 +"          where depth = '3'             "
 +"            and member_no = a.member_no "
 +"            and l_cd = a.l_cd           "
 +"            and m_cd = a.m_cd           "
 +"            and s_cd = a.s_cd)  s_nm    "
 +"  from tcb_user_code a                  "
 +" where member_no = '"+main_member_no+"' "
 +"   and depth = '4'                      "
 +"   and use_yn = 'Y'                     "
 +" order by a.code asc		               "
		);
while(userCode.next()){
	userCode.put("code_nm", userCode.getString("s_nm")+">"+userCode.getString("code_nm"));
}


String where = "member_no = '"+main_member_no+"' and client_no = '"+_member_no+"'";

int seq = 1;
DataObject techDao = new DataObject("tcb_client_tech");
DataSet tech = techDao.find(where, "*", "seq asc");
seq=1;
while(tech.next()){
	tech.put("seq", seq);
	seq++;
}

if(u.isPost()&&f.validate()){
	//글내용
	DB db = new DB();
	
	//보유면허
	techDao = new DataObject("tcb_client_tech");
	db.setCommand(techDao.getDeleteQuery(where), null);
	String[] tech_cd = f.getArr("t_tech_cd");
	String[] tech_expl = f.getArr("t_tech_expl");
	int tech_cnt = tech_cd == null?0:tech_cd.length;
	for(int i =0; i < tech_cnt; i++){
		techDao = new DataObject("tcb_client_tech");
		techDao.item("member_no", main_member_no);
		techDao.item("client_no", _member_no);
		techDao.item("seq", i+1);
		techDao.item("tech_cd", tech_cd[i]);
		techDao.item("tech_expl", tech_expl[i]);
		db.setCommand(techDao.getInsertQuery(), techDao.record);
	}
	
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("정상 처리하였습니다.","build_license_info.jsp?"+u.getQueryString());
	return;	
}

p.setLayout("default");
p.setDebug(out);
p.setBody("info.build_license_info");
p.setVar("modify", false);
p.setLoop("userCode", userCode);
p.setLoop("tech", tech);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("main_member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>