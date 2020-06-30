<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String person_seq = u.request("person_seq");
String l_div_cd = u.request("l_div_cd");
if(person_seq.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

String addWhere ="";
String addSubWhere ="";
if(auth.getString("_USER_LEVEL").equals("20")){
	addWhere = " and a.adm_cd in (select adm_cd from tcb_person_auth where read_yn = 'Y' and member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"')";
	addSubWhere = " and adm_cd in (select adm_cd from tcb_person_auth where read_yn = 'Y' and member_no = '"+_member_no+"' and person_seq = '"+auth.getString("_PERSON_SEQ")+"')";
}


DataObject menuDao = new DataObject("tcb_menu_info");
//menuDao.setDebug(out);
DataSet mauth = menuDao.query(                                                                                                 
	 "  select (select menu_nm                                                                                                 "
	+"            from tcb_menu_info                                                                                           "
	+"           where l_div_cd = a.l_div_cd                                                                                   "
	+"             and m_div_cd = '00'                                                                                         "
	+"             and s_div_cd = '00') l_div_nm                                                                               "
	+"        ,(select count(adm_cd)                                                                                           "
	+"            from tcb_menu_info                                                                                           "
	+"           where l_div_cd = a.l_div_cd                                                                                   "
	+"             and depth = '3'                                                                                             "
	+"             and adm_cd in (select adm_cd from tcb_member_menu where member_no= '"+_member_no+"')          			   "
	+addSubWhere
	+"             and (default_yn is null or default_yn <> 'Y')															   "
	+"         ) l_div_cnt                                                                                                     "
	+"        ,(select menu_nm                                                                                                 "
	+"            from tcb_menu_info                                                                                           "
	+"           where l_div_cd = a.l_div_cd                                                                                   "
	+"             and m_div_cd = a.m_div_cd                                                                                   "
	+"             and s_div_cd = '00') m_div_nm                                                                               "
	+"        , (select count(adm_cd)                                                                                          "
	+"            from tcb_menu_info                                                                                           "
	+"           where l_div_cd = a.l_div_cd                                                                                   "
	+"             and m_div_cd = a.m_div_cd                                                                                   "
	+"             and depth = '3'                                                                                             "
	+"             and adm_cd in (select adm_cd from tcb_member_menu where member_no= '"+_member_no+"') 					   "
	+addSubWhere
	+"             and (default_yn is null or default_yn <> 'Y')															   "
	+"          ) m_div_cnt                                                                                                    "
	+"        , a.*                                                                                                            "
	+"        , b.read_yn                                                                                                      "
	+"        , b.save_yn                                                                                                      "
	+"        , b.print_yn                                                                                                     "
	+"        , b.all_read_yn                                                                                                  "
	+"   from tcb_menu_info a                                                                                                  "
	+"    left outer join (select *                                                                                            "
	+"                       from tcb_person_auth                                                                              "
	+"                      where member_no = '"+_member_no+"'                                                                 "
	+"                        and person_seq = '"+person_seq+"'                                                                "
	+"                     ) b                                                                             					   "
	+"      on a.adm_cd = b.adm_cd																							   "
	+"  where a.adm_cd in (select adm_cd from tcb_member_menu where member_no= '"+_member_no+"')                               "
	+"    and (a.default_yn is null or a.default_yn <> 'Y')																		"
	+(l_div_cd.equals("")?"":" and a.l_div_cd = '"+l_div_cd+"' ")                                                              
	+ addWhere
	+"  order by a.l_div_cd, decode(a.depth,2,seq||'00',(select seq from tcb_menu_info where l_div_cd= a.l_div_cd and m_div_cd= a.m_div_cd and s_div_cd = '00')||lpad(a.seq,2,'0')) "
);
                              

String temp_l_div = "";
String temp_m_div = "";
while(mauth.next()){
	if(!temp_l_div.equals(mauth.getString("l_div_cd"))){
		mauth.put("l_first", true);
		temp_l_div = mauth.getString("l_div_cd");
		temp_m_div = "";
	}else{
		mauth.put("l_first", false);
	}
	if(!temp_m_div.equals(mauth.getString("m_div_cd"))){
		mauth.put("m_first", true);
		temp_m_div = mauth.getString("m_div_cd");
	}else{
		mauth.put("m_first", false);
	}
	mauth.put("read_check", mauth.getString("read_yn").equals("Y")?"checked":"");
	mauth.put("save_check", mauth.getString("save_yn").equals("Y")?"checked":"");
	mauth.put("print_check", mauth.getString("print_yn").equals("Y")?"checked":"");
	mauth.put("all_read_check", mauth.getString("all_read_yn").equals("Y")?"checked":"");
	
	if(			mauth.getString("adm_cd").equals("020201")	//	전자계약/계약진행/진행중인계약
				||	mauth.getString("adm_cd").equals("020301")	//	전자계약/계약완료/완료된계약
				||	mauth.getString("adm_cd").equals("020303")	//	전자계약/계약완료/만료예정 계약서
				||	mauth.getString("adm_cd").equals("020304")	//	전자계약/계약완료/보증보험증권관리
				||	mauth.getString("adm_cd").equals("020402")	//	전자계약/계약현황/계약진행현황
				||	mauth.getString("adm_cd").equals("010105")	//	전자입찰/구매관리/낙찰업체선정
				||	mauth.getString("adm_cd").equals("010106")	//	전자입찰/구매관리/입찰결과
				||	mauth.getString("adm_cd").equals("010301")	//	전자입찰/입찰현황/입찰진행현황
				||	mauth.getString("adm_cd").equals("010501")	//	전자입찰/견적관리/견적요청현황
				||	mauth.getString("adm_cd").equals("010502")	//	전자입찰/견적관리/견적결과
		)
	{
		mauth.put("all_read_disabled", "");
	}else
	{
		mauth.put("all_read_disabled", "disabled style='display:none' ");
	}
	
	if(mauth.getString("all_read_yn").equals("Y")&&!u.inArray(mauth.getString("adm_cd"), new String[]{"010105","010501","010502"}))
	{
		mauth.put("save_disabled", "disabled style='display:none'");
	}else
	{
		mauth.put("save_disabled", "");
	}
}

if(u.isPost()&&f.validate()){

	DB db = new DB();
	String delQuery ="delete from tcb_person_auth where member_no = '"+_member_no+"' and person_seq = '"+person_seq+"' ";
	if(l_div_cd.equals("")){ 
		db.setCommand(delQuery,null);
	}else{
		db.setCommand(delQuery+" and adm_cd like '"+l_div_cd+"%'",null);
	}
	
	String[] adm_cd = f.getArr("adm_cd");
	String[] read = f.getArr("read");
	String[] save = f.getArr("save");
	String[] print = f.getArr("print");
	String[] all_read = f.getArr("all_read");
	
	int read_seq 			= 0 ;
	int save_seq 			= 0 ; 
	int print_seq 		= 0;
	int all_read_seq 	= 0 ;
	
	if(adm_cd == null){
		u.jsError("저장할 메뉴가 없습니다.");
		return;
	}
	
	DataSet personAuth = new DataSet();
	for(int i=0; i < adm_cd.length; i ++){
		String read_yn 			= "N";
		String save_yn	 		= "N";
		String print_yn 		= "N";
		String all_read_yn	= "N";
		if(read != null&&read_seq<read.length){
			if(adm_cd[i].equals(read[read_seq])){
				read_yn = "Y";
				read_seq++;
			}
		}
		if(save != null&&save_seq<save.length){
			if(adm_cd[i].equals(save[save_seq])){
				save_yn = "Y";
				save_seq++;
			}
		}
		if(print != null&&print_seq<print.length){
			if(adm_cd[i].equals(print[print_seq])){
				print_yn = "Y";
				print_seq++;
			}
		}
		if(all_read != null	&&	all_read_seq	<	all_read.length){
			if(adm_cd[i].equals(all_read[all_read_seq])){
				all_read_yn = "Y";
				all_read_seq++;
			}
		}
		if((!read_yn.equals("N"))||!save_yn.equals("N")||!print_yn.equals("N")	||	!all_read_yn.equals("N")){
			personAuth.addRow();
			personAuth.put("adm_cd",			adm_cd[i]);
			personAuth.put("read_yn", 		read_yn);			
			personAuth.put("save_yn", 		save_yn);			
			personAuth.put("print_yn", 		print_yn);			
			personAuth.put("all_read_yn", all_read_yn);			
		}
	}
	
	DataObject authDao = null;
	personAuth.first();
	while(personAuth.next()){
		authDao = new DataObject("tcb_person_auth");
		authDao.item("member_no", _member_no);
		authDao.item("person_seq", person_seq);
		authDao.item("adm_cd", 			personAuth.getString("adm_cd"));
		authDao.item("read_yn", 		personAuth.getString("read_yn"));
		authDao.item("save_yn", 		personAuth.getString("save_yn"));
		authDao.item("print_yn", 		personAuth.getString("print_yn"));
		authDao.item("all_read_yn", personAuth.getString("all_read_yn"));
		db.setCommand(authDao.getInsertQuery(),authDao.record);
	}
	
	// 현재 선택된 사용자를 기준으로 나머지 권한 복사
	if(!u.request("multi_person_seq").equals(""))
	{
		String insQuery="";
		String[] arrPersonSeq = u.request("multi_person_seq").split(",");
		for(int i=0; i<arrPersonSeq.length; i++)
		{
			if(!arrPersonSeq[i].equals("") && !arrPersonSeq[i].equals(person_seq))
			{
				delQuery ="delete from tcb_person_auth where member_no = '"+_member_no+"' and person_seq="+arrPersonSeq[i];
				db.setCommand(delQuery,null);
				insQuery = "insert into tcb_person_auth(member_no, person_seq, adm_cd, read_yn, save_yn, print_yn, all_read_yn)" 
							+"select member_no, "+arrPersonSeq[i]+", adm_cd, read_yn, save_yn, print_yn, all_read_yn from tcb_person_auth where member_no = '"+_member_no+"' and person_seq="+person_seq;
				db.setCommand(insQuery,null);
				//System.out.println("insQuery : " + delQuery);
				//System.out.println("insQuery : " + insQuery);
			}
		}
	}
	
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.","ifm_person_auth.jsp?"+u.getQueryString());
	return;
}


p.setLayout("black");
//p.setDebug(out);
p.setBody("info.ifm_person_auth");
p.setLoop("mauth", mauth);
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString(""));
p.display(out);
%>