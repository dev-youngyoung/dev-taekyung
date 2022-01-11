<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String callback = u.request("callback");
if(callback.equals("")){
	u.jsError("정상적인 경로로 접근하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsErrClose("회원정보가 없습니다.");
	return;
}

                     //견적결과,입찰결과, 완료계약, 진행중인계약
String conf_menus = "'000034','000043','000063','000060','000120'";


DataObject menuDao = new DataObject("tcb_menu");
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
		+"                  and menu_cd in ("+conf_menus+")     "
		+"          )                                           "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"	          )                                         "
		+"	        start with p_menu_cd = a.menu_cd            "
		+"	      connect by prior menu_cd=p_menu_cd            "
		+"        ) row_span                                    "
		+"       , select_auth_cds                              "
		+"       , btn_auth_cds                                 "
		+"       ,( select listagg(menu_nm,'>') WITHIN GROUP(ORDER BY  depth asc ) " 
		+"            from tcb_menu                             "
		+"           start with menu_cd = a.menu_cd             "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"        )  full_menu_nm                               "
		+"	   from tcb_menu a                                  "
		+"	  where menu_cd in (                                "
		+"         select distinct menu_cd                      "
		+"           from tcb_menu                              "
		+"          start with menu_cd in (                     "
		+"                select menu_cd                        "
		+"                  from tcb_menu_member                "
		+"                where member_no = '"+_member_no+"'    "
		+"                  and menu_cd in ("+conf_menus+")     "
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
		treeMenu.put("select_auth_cds","");
		treeMenu.put("btn_auth_cds","");
		treeMenu.put("full_menu_nm","");
		
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
			if(!menu.getString("full_menu_nm").equals("")) treeMenu.put("full_menu_nm", menu.getString("full_menu_nm")); 
			if(!menu.getString("select_auth_cds").equals("")) treeMenu.put("select_auth_cds", menu.getString("select_auth_cds")); 
			if(!menu.getString("btn_auth_cds").equals("")) treeMenu.put("btn_auth_cds", menu.getString("btn_auth_cds")); 
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
			if(!menu.getString("full_menu_nm").equals("")) treeMenu.put("full_menu_nm", menu.getString("full_menu_nm")); 
			if(!menu.getString("select_auth_cds").equals("")) treeMenu.put("select_auth_cds", menu.getString("select_auth_cds")); 
			if(!menu.getString("btn_auth_cds").equals("")) treeMenu.put("btn_auth_cds", menu.getString("btn_auth_cds"));
		}
	}
}

if(u.isPost()&&f.validate()){
	
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("info.pop_auth_menu");
p.setVar("popup_title","메뉴선택");
p.setLoop("treeMenu", treeMenu);
p.setVar("callback", callback);
p.setVar("form_script",f.getScript());
p.display(out);
%>