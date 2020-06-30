<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String auth_cd = u.request("auth_cd");
if(auth_cd.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_select_auth = codeDao.getCodeArray("M045");
String[] code_btn_auth = codeDao.getCodeArray("M046");

//권한조회
DataObject authDao = new DataObject("tcb_auth");
DataSet authInfo = authDao.find("member_no = '"+_member_no+"' and auth_cd=" + auth_cd);
if(!authInfo.next()){
	u.jsError("선택하신 권한이 존재하지 않습니다.");
	return;
}

DataObject personDao = new DataObject("tcb_person");
//personDao.setDebug(out);
int user_cnt  = personDao.findCount(" member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"' and status > 0  ");
authInfo.put("user_cnt", user_cnt);

DataSet person = personDao.query(
		 " select a.member_no "
		+"      , a.field_seq " 
		+"      , (select field_name from tcb_field where member_no = a.member_no and field_seq = a.field_seq ) field_name "
		+"      , listagg(a.user_name , ', ') within group ( order by a.user_level , a.person_seq) user_names "
		+"   from tcb_person a"
		+"  where a.member_no = '"+_member_no+"' "
		+"    and a.auth_cd = '"+auth_cd+"' "
		+"    and a.status > 0  "
		+"  group by a.member_no, a.field_seq "
		+"  order by a.field_seq asc "
		);

//메뉴권한조회
DataObject authMenuDao = new DataObject("tcb_auth_menu");
DataSet authMenu = authMenuDao.find("member_no = '"+_member_no+"' and auth_cd='" + auth_cd+"'");

//메뉴정보 조회
DataObject menuDao = new DataObject("tcb_menu");
//menuDao.setDebug(out);
DataSet menu = menuDao.query(
		 "	select p_menu_cd                                    "
		+"	    ,  menu_cd                                      "
		+"	    , depth                                         "
		+"	    , dir                                           "
		+"	    , menu_nm                                       "
		+"	    ,(select count(*)                               "
		+"	        from tcb_menu                               "
		+"	       where depth=3                                "
		+"	         and menu_cd in (                           "
		+"         select distinct menu_cd                      "
		+"           from tcb_menu                              "
		+"          start with menu_cd in (                     "
		+"                select menu_cd                        "
		+"                  from tcb_menu_member                "
		+"                where member_no = '"+_member_no+"'    "
		+"                  and menu_cd in (select menu_cd from tcb_menu where use_yn = 'Y') "
		+"          )                                           "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"	          )                                         "
		+"	        start with p_menu_cd = a.menu_cd            "
		+"	      connect by prior menu_cd=p_menu_cd            "
		+"        ) row_span                                    "
		+"       , select_auth_cds                              "
		+"       , btn_auth_cds                                 "
		+"	   from tcb_menu a                                  "
		+"	  where menu_cd in (                                "
		+"         select distinct menu_cd                      "
		+"           from tcb_menu                              "
		+"          start with menu_cd in (                     "
		+"                select menu_cd                        "
		+"                  from tcb_menu_member                "
		+"                where member_no = '"+_member_no+"'    "
		+"                  and menu_cd in (select menu_cd from tcb_menu where use_yn = 'Y') "
		+"          )                                           "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"	       )                                            "
		+"	  start with p_menu_cd = '000000'                   "
		+"	 connect by prior  menu_cd = p_menu_cd              "
		+"	 order siblings by  display_seq asc                 "
		);

String depth = "";
DataSet treeMenu = new DataSet();
while(menu.next()){
	if(!depth.equals(menu.getString("depth"))){
		treeMenu.addRow();
		treeMenu.put(".code_select_auth",new DataSet());
		treeMenu.put(".code_btn_auth",new DataSet());
		
		if(menu.getString("depth").equals("1")){
			depth = menu.getString("depth");
			treeMenu.put("l_menu_nm", menu.getString("menu_nm"));
			treeMenu.put("l_row_span", menu.getString("row_span"));
			menu.next();
		}else{
			treeMenu.put("l_menu_nm", "");
			treeMenu.put("l_row_span", "");
		}
		
		if(menu.getString("depth").equals("2")){
			depth = menu.getString("depth");
			treeMenu.put("m_menu_nm", menu.getString("menu_nm"));
			treeMenu.put("m_row_span", menu.getString("row_span"));
			menu.next();
		}else{
			treeMenu.put("m_menu_nm", "");
			treeMenu.put("m_row_span", "");
		}
		
		if(menu.getString("depth").equals("3")){
			depth = menu.getString("depth");
			treeMenu.put("s_menu_nm", menu.getString("menu_nm"));
			treeMenu.put("menu_cd", menu.getString("menu_cd"));
			if(!menu.getString("select_auth_cds").equals("")) treeMenu.put(".code_select_auth", u.arr2loop(menu.getString("select_auth_cds").split(","))); 
			if(!menu.getString("btn_auth_cds").equals("")) treeMenu.put(".code_btn_auth", u.arr2loop(menu.getString("btn_auth_cds").split(",")));
		}
	}else{
		if(menu.getString("depth").equals("3")){
			treeMenu.addRow();
			treeMenu.put(".code_select_auth",new DataSet());
			treeMenu.put(".code_btn_auth",new DataSet());
			treeMenu.put("l_menu_nm", "");
			treeMenu.put("l_row_span", "");
			treeMenu.put("m_menu_nm", "");
			treeMenu.put("m_row_span", "");
			treeMenu.put("s_menu_nm", menu.getString("menu_nm"));
			treeMenu.put("menu_cd", menu.getString("menu_cd"));
			if(!menu.getString("select_auth_cds").equals("")) treeMenu.put(".code_select_auth", u.arr2loop(menu.getString("select_auth_cds").split(","))); 
			if(!menu.getString("btn_auth_cds").equals("")) treeMenu.put(".code_btn_auth", u.arr2loop(menu.getString("btn_auth_cds").split(",")));
		}
	}
}

DataSet menuCnt = menuDao.query(
		 " select  (select count(*) from tcb_menu_member where member_no = '"+_member_no+"' and menu_cd = '000033' ) esti_cnt "  
		+"       , (select count(*) from tcb_menu_member where member_no = '"+_member_no+"' and menu_cd = '000036' ) bid_cnt  "
		+"       , (select count(*) from tcb_menu_member where member_no = '"+_member_no+"' and menu_cd = '000059' ) cont_cnt "
		+"   from dual "
		);
if(!menuCnt.next()){
}
menuCnt.put("esti_yn", menuCnt.getInt("esti_cnt")>0);
menuCnt.put("bid_yn", menuCnt.getInt("bid_cnt")>0);
menuCnt.put("cont_yn", menuCnt.getInt("cont_cnt")>0);

DataObject fieldDao = new DataObject("tcb_field");
DataSet field = fieldDao.find(" member_no = '"+_member_no+"' and use_yn = 'Y'  and status > '0' ");


DataObject authFieldDao = new DataObject("tcb_auth_field");
DataSet authField = authFieldDao.query(
   " select a.*                                                                 "
  +"        ,  (select listagg(menu_nm,'>') WITHIN GROUP(ORDER BY  depth asc )  "
  +"              from tcb_menu                                                 "
  +"             start with menu_cd = a.menu_cd                                 "
  +"           connect by prior p_menu_cd = menu_cd                             "
  +"           ) full_menu_nm                                                   "
  +"        , (select btn_auth_cds from tcb_menu where menu_cd = a.menu_cd) btn_auth_cds   "
  +"  from tcb_auth_field a                                                     "
  +" where member_no = '"+_member_no+"'                                         "
  +"   and auth_cd = '"+auth_cd+"'                                              "
		);
while(authField.next()){
	authField.put(".code_btn_auth", u.arr2loop(authField.getString("btn_auth_cds").split(",")));
}

f.addElement("auth_nm", authInfo.getString("auth_nm") , "hname:'권한명', required:'Y'");
f.addElement("etc", null, "hname:'비고'");


// 입력수정
if(u.isPost() && f.validate())
{
	DB db = new DB();
	
	authDao = new DataObject("tcb_auth");
	authDao.item("auth_cd", auth_cd);
	authDao.item("auth_nm", f.get("auth_nm"));
	authDao.item("etc", f.get("etc"));
	authDao.item("mod_date", u.getTimeString());
	authDao.item("mod_id", auth.getString("_USER_ID"));
	db.setCommand(authDao.getUpdateQuery("member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"' "), authDao.record);
	
	db.setCommand("delete from tcb_auth_menu where member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"'",null);
	String[] chkMenuCd = f.get("arr_menu_cd").split(",");
	if(chkMenuCd.length > 0){
		for(int i = 0; i< chkMenuCd.length;i ++){
			authMenuDao = new DataObject("tcb_auth_menu");
			authMenuDao.item("member_no", _member_no);
			authMenuDao.item("auth_cd", auth_cd);
			authMenuDao.item("menu_cd", chkMenuCd[i]);
			authMenuDao.item("select_auth", f.get("select_auth_"+chkMenuCd[i]));
			authMenuDao.item("btn_auth", f.get("btn_auth_"+chkMenuCd[i]));
			db.setCommand(authMenuDao.getInsertQuery(), authMenuDao.record);
		}
	}
	
	
	db.setCommand(authFieldDao.getDeleteQuery(" member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"' "), null);
	String[] afield_field_seqs = f.getArr("afield_field_seq");
	String[] afield_menu_cds = f.getArr("afield_menu_cd");
	String[] afield_btn_auth = f.getArr("afield_btn_auth");
	int seq = 1;
	int afield_cnt = afield_field_seqs== null? 0 :afield_field_seqs.length; 
	for(int i =0 ; i< afield_cnt ; i++){
		authFieldDao = new DataObject("tcb_auth_field");
		authFieldDao.item("member_no", _member_no);
		authFieldDao.item("auth_cd", auth_cd);
		authFieldDao.item("seq", seq++);
		authFieldDao.item("field_seq", afield_field_seqs[i]);
		authFieldDao.item("menu_cd", afield_menu_cds[i]);
		authFieldDao.item("btn_auth", afield_btn_auth[i]);
		db.setCommand(authFieldDao.getInsertQuery()	, authFieldDao.record);
	}
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 되었습니다.", "./auth_modify.jsp?"+u.getQueryString());	
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.auth_modify");
p.setVar("menu_cd","000139");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000139", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setLoop("treeMenu", treeMenu);
p.setVar("authInfo", authInfo);
p.setVar("menuCnt", menuCnt);
p.setLoop("person", person);
p.setLoop("authMenu", authMenu);
p.setLoop("authField", authField);
p.setLoop("field", field);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("auth_cd"));
p.display(out);
%>