<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

// 메뉴정보 조회
DataObject menuDao = new DataObject("tcc_menu");
DataSet menu = menuDao.query(
		 "	select p_menu_cd                                    "
		+"	    ,  menu_cd                                      "
		+"	    , depth                                         "
		+"	    , dir                                           "
		+"	    , menu_nm                                       "
		+"	    ,(select count(*)                               "
		+"	        from tcc_menu                               "
		+"	       where depth=3                                "
		+"	        start with p_menu_cd = a.menu_cd            "
		+"	      connect by prior menu_cd=p_menu_cd            "
		+"        ) row_span                                    "
		+"       , select_auth_cds                              "
		+"       , btn_auth_cds                                 "
		+"	   from tcc_menu a                                  "
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

f.addElement("auth_nm",null, "hname:'권한명', required:'Y'");

if(u.isPost()&&f.validate()){
	//권한 저장
	DB db = new DB();
	
	DataObject authDao = new DataObject("tcc_auth");

	String auth_cd = authDao.getOne(
		"select lpad(nvl(max(auth_cd),0)+1,4,0) auth_cd "
	 +  "  from tcc_auth "
	);
	
	//authDao.item("member_no", _member_no);
	authDao.item("auth_cd", auth_cd);
	authDao.item("auth_nm", f.get("auth_nm"));
	authDao.item("etc", f.get("etc"));
	authDao.item("reg_date", u.getTimeString());
	authDao.item("mod_date", u.getTimeString());
	authDao.item("reg_id", auth.getString("_ADMIN_ID"));
	authDao.item("mod_id", auth.getString("_ADMIN_ID"));
	authDao.item("status", "10");
	db.setCommand(authDao.getInsertQuery(), authDao.record);
	
	String[] chkMenuCd = f.get("arr_menu_cd").split(",");
	if(chkMenuCd.length > 0){
		for(int i = 0; i< chkMenuCd.length;i ++){
			DataObject authMenuDao = new DataObject("tcc_auth_menu");
				//authMenuDao.item("member_no", _member_no);
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
	u.jsAlertReplace("정상적으로 저장 되었습니다.","./auth_modify.jsp?auth_cd="+auth_cd+"&"+u.getQueryString("auth_cd"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.auth_modify");
p.setVar("menu_cd","000071");
//p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000139", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setLoop("treeMenu", treeMenu);
//p.setVar("menuCnt", menuCnt);
p.setVar("form_script", f.getScript());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("auth_cd"));
p.display(out);
%>