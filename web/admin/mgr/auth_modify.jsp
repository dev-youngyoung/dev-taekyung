<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String auth_cd = u.request("auth_cd");
if(auth_cd.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

//권한조회
DataObject authDao = new DataObject("tcc_auth");
DataSet authInfo = authDao.find("auth_cd=" + auth_cd);
if(!authInfo.next()){
	u.jsError("선택하신 권한이 존재하지 않습니다.");
	return;
}

DataObject personDao = new DataObject("tcc_admin");
//personDao.setDebug(out);
int user_cnt  = personDao.findCount(" auth_cd = '" + auth_cd + "'");
authInfo.put("user_cnt", user_cnt);

DataSet person = personDao.query(
		 " select a.admin_id "
		+"      , a.admin_name "
		+"   from tcc_admin a"
		+"  where a.auth_cd = '"+auth_cd+"' "
		+"  order by a.admin_id asc "
		);

//메뉴권한조회
DataObject authMenuDao = new DataObject("tcc_auth_menu");
DataSet authMenu = authMenuDao.find("auth_cd='" + auth_cd+"'");

//메뉴정보 조회
DataObject menuDao = new DataObject("tcc_menu");
//menuDao.setDebug(out);
DataSet menu = menuDao.query(
		 "	select p_menu_cd                                    "
		+"	    ,  menu_cd                                      "
		+"	    , depth                                         "
		+"	    , dir                                           "
		+"	    , menu_nm                                       "
		+"	    ,(select count(*)                               "
		+"	        from tcc_menu                               "
		+"	       where depth=3                                "
		+"	         and menu_cd in (                           "
		+"         select distinct menu_cd                      "
		+"           from tcc_menu                              "
		+"	          )                                         "
		+"	        start with p_menu_cd = a.menu_cd            "
		+"	      connect by prior menu_cd=p_menu_cd            "
		+"        ) row_span                                    "
		+"       , select_auth_cds                              "
		+"       , btn_auth_cds                                 "
		+"	   from tcc_menu a                                  "
		+"	  where menu_cd in (                                "
		+"         select distinct menu_cd                      "
		+"           from tcc_menu                              "
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

f.addElement("auth_nm", authInfo.getString("auth_nm") , "hname:'권한명', required:'Y'");
f.addElement("etc", null, "hname:'비고'");


// 입력수정
if(u.isPost() && f.validate())
{
	DB db = new DB();
	
	authDao = new DataObject("tcc_auth");
	authDao.item("auth_cd", auth_cd);
	authDao.item("auth_nm", f.get("auth_nm"));
	authDao.item("etc", f.get("etc"));
	authDao.item("mod_date", u.getTimeString());
	authDao.item("mod_id", auth.getString("_ADMIN_ID"));
	db.setCommand(authDao.getUpdateQuery("auth_cd = '"+auth_cd+"' "), authDao.record);
	
	db.setCommand("delete from tcc_auth_menu where auth_cd = '"+auth_cd+"'",null);
	String[] chkMenuCd = f.get("arr_menu_cd").split(",");
	if(chkMenuCd.length > 0){
		for(int i = 0; i< chkMenuCd.length;i ++){
			authMenuDao = new DataObject("tcc_auth_menu");
			authMenuDao.item("auth_cd", auth_cd);
			authMenuDao.item("menu_cd", chkMenuCd[i]);
			authMenuDao.item("select_auth", f.get("select_auth_"+chkMenuCd[i]));
			authMenuDao.item("btn_auth", f.get("btn_auth_"+chkMenuCd[i]));
			db.setCommand(authMenuDao.getInsertQuery(), authMenuDao.record);
		}
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
p.setBody("mgr.auth_modify");
p.setVar("menu_cd","000071");
//p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000139", "btn_auth").equals("10"));
p.setVar("modify", true);
p.setLoop("treeMenu", treeMenu);
p.setVar("authInfo", authInfo);
//p.setVar("menuCnt", menuCnt);
p.setLoop("person", person);
p.setLoop("authMenu", authMenu);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("auth_cd"));
p.display(out);
%>