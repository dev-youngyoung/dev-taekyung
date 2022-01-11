<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String auth_cd = u.request("auth_cd");
String default_yn= u.request("default_yn");

CodeDao  codeDao = new CodeDao("tcb_comcode");
String[] code_select_auth = codeDao.getCodeArray("M045");
String[] code_btn_auth = codeDao.getCodeArray("M046");


if(auth_cd.equals("")&&!default_yn.equals("Y")){
	return;
}

DataObject menuDao = new DataObject("tcb_menu");
DataSet menu = null;
DataSet treeMenu = new DataSet();
String auth_nm = "전체관리자"; 
if(default_yn.equals("Y")){
	 menu = menuDao.query(
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
}else{
	
	DataObject authDao = new DataObject("tcb_auth");
	DataSet authInfo = authDao.find(" member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"' ");
	if(!authInfo.next()){
		u.jsAlert("권한정보가 없습니다.");
		return;
	}
	auth_nm = authInfo.getString("auth_nm");
	
	menu = menuDao.query(
			 "	select a.p_menu_cd                                  "
			+"	    ,  a.menu_cd                                    "
			+"	    ,  a.depth                                      "
			+"	    ,  a.dir                                        "
			+"	    ,  a.menu_nm                                    "
			+"	    ,(select count(*)                               "
			+"	        from tcb_menu                               "
			+"	       where depth=3                                "
			+"	         and menu_cd in (                           "
			+"         select distinct menu_cd                      "
			+"           from tcb_menu                              "
			+"          start with menu_cd in (                     "
			+"                select menu_cd                        "
			+"                  from tcb_auth_menu                  "
			+"                where member_no = '"+_member_no+"'    "
			+"                  and auth_cd = '"+auth_cd+"'         "
			+"                  and menu_cd in (select menu_cd from tcb_menu where use_yn = 'Y') "
			+"          )                                           "
			+"         connect by prior p_menu_cd = menu_cd         "
			+"            )                                         "
			+"          start with p_menu_cd = a.menu_cd            "
			+"        connect by prior menu_cd=p_menu_cd            "
			+"        ) row_span                                    "
			+"       ,b.select_auth                                 "
			+"       ,b.btn_auth                                    "
			+"     from tcb_menu a, (select* from tcb_auth_menu where member_no = '"+_member_no+"' and auth_cd = '"+auth_cd+"') b  "
			+"    where a.menu_cd = b.menu_cd(+)                    "
			+"      and a.menu_cd in (                              "
			+"         select distinct menu_cd                      "
			+"           from tcb_menu                              "
			+"          start with menu_cd in (                     "
			+"                select menu_cd                        "
			+"                  from tcb_auth_menu                  "
			+"                where member_no = '"+_member_no+"'    "
			+"                  and auth_cd = '"+auth_cd+"'         "
			+"                  and menu_cd in (select menu_cd from tcb_menu where use_yn = 'Y') "
			+"          )                                           "
			+"         connect by prior p_menu_cd = menu_cd         "
			+"	       )                                            "
			+"	  start with p_menu_cd = '000000'                   "
			+"	 connect by prior  a.menu_cd = a.p_menu_cd          "
			+"	 order siblings by  a.display_seq asc               "
			);
}
String depth = "";
while(menu.next()){
	if(!depth.equals(menu.getString("depth"))){
		treeMenu.addRow();
		
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
			treeMenu.put("select_auth",default_yn.equals("Y")?"전체조회":u.getItem(menu.getString("select_auth"), code_select_auth));
			treeMenu.put("btn_auth",default_yn.equals("Y")?"기능사용":u.getItem(menu.getString("btn_auth"), code_btn_auth));
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
			treeMenu.put("select_auth",default_yn.equals("Y")?"전체조회":u.getItem(menu.getString("select_auth"), code_select_auth));
			treeMenu.put("btn_auth",default_yn.equals("Y")?"기능사용":u.getItem(menu.getString("btn_auth"), code_btn_auth));
			
		}
	}
}


DataObject authFieldDao = new DataObject("tcb_auth_field");
DataSet authField = authFieldDao.query(
   " select a.*                                                                 "
  +"        ,  (select listagg(menu_nm,'>') WITHIN GROUP(ORDER BY  depth asc )  "
  +"              from tcb_menu                                                 "
  +"             start with menu_cd = a.menu_cd                                 "
  +"           connect by prior p_menu_cd = menu_cd                             "
  +"           ) full_menu_nm                                                   "
  +"        , (select btn_auth_cds from tcb_menu where menu_cd = a.menu_cd) btn_auth_cds   "
  +"        , (select field_name from tcb_field where member_no = a.member_no and field_seq= a.field_seq ) field_name  "
  +"  from tcb_auth_field a                                                     "
  +" where member_no = '"+_member_no+"'                                         "
  +"   and auth_cd = '"+auth_cd+"'                                              "
  +" order by  seq asc                                                          "
		);
while(authField.next()){
	String[] btn_auth_cds = authField.getString("btn_auth_cds").split(",");
	authField.put("btn_auth_nm", u.getItem(authField.getString("btn_auth"), code_btn_auth));
}


p.setVar("auth_nm", auth_nm);
p.setLoop("treeMenu", treeMenu);
p.setLoop("authField", authField);
out.print(p.fetch("../html/info/call_auth_info.html"));


%>