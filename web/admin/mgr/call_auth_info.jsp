<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String auth_cd = u.request("auth_cd");
String default_yn= u.request("default_yn");

if(auth_cd.equals("")&&!default_yn.equals("Y")){
	return;
}

String[] code_btn_auth = {"10=>단순조회", "20=>기능사용"};

DataObject menuDao = new DataObject("tcc_menu");
DataSet menu = null;
DataSet treeMenu = new DataSet();
	
DataObject authDao = new DataObject("tcc_auth");
DataSet authInfo = authDao.find(" auth_cd = '"+auth_cd+"' ");
if(!authInfo.next()){
	u.jsAlert("권한정보가 없습니다.");
	return;
}
String auth_nm = authInfo.getString("auth_nm");

menu = menuDao.query(
		 "	select a.p_menu_cd                                  "
		+"	    ,  a.menu_cd                                    "
		+"	    ,  a.depth                                      "
		+"	    ,  a.dir                                        "
		+"	    ,  a.menu_nm                                    "
		+"	    ,(select count(*)                               "
		+"	        from tcc_menu                               "
		+"	       where depth=3                                "
		+"	         and menu_cd in (                           "
		+"         select distinct menu_cd                      "
		+"           from tcc_menu                              "
		+"          start with menu_cd in (                     "
		+"                select menu_cd                        "
		+"                  from tcc_auth_menu                  "
		+"                where auth_cd = '" + auth_cd + "'         "
		+"          )                                           "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"            )                                         "
		+"          start with p_menu_cd = a.menu_cd            "
		+"        connect by prior menu_cd=p_menu_cd            "
		+"        ) row_span                                    "
		+"       ,b.select_auth                                 "
		+"       ,b.btn_auth                                    "
		+"     from tcc_menu a, (select* from tcc_auth_menu where auth_cd = '" + auth_cd + "') b  "
		+"    where a.menu_cd = b.menu_cd(+)                    "
		+"      and a.menu_cd in (                              "
		+"         select distinct menu_cd                      "
		+"           from tcc_menu                              "
		+"          start with menu_cd in (                     "
		+"                select menu_cd                        "
		+"                  from tcc_auth_menu                  "
		+"                where auth_cd = '" + auth_cd + "'         "
		+"          )                                           "
		+"         connect by prior p_menu_cd = menu_cd         "
		+"	       )                                            "
		+"	  start with p_menu_cd = '000000'                   "
		+"	 connect by prior  a.menu_cd = a.p_menu_cd          "
		+"	 order siblings by  a.display_seq asc               "
		);
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
			treeMenu.put("btn_auth",default_yn.equals("Y")?"기능사용":u.getItem(menu.getString("btn_auth"), code_btn_auth));
			
		}
	}
}

p.setLoop("treeMenu", treeMenu);
p.setVar("auth_nm", auth_nm);
out.print(p.fetch("../html/mgr/call_auth_info.html"));


%>