<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
//top menu 설정

String[] menu_font_color = {"supplier=>#c6c6c6","buyer=>#90E4FF","fc=>#FFBA85","logis=>#86E57F"};


DataSet menu = new DataSet();

DataObject menuDao = new DataObject("tcc_menu");
DataSet temp = menuDao.query(
		"select  *                                                                            "
	   +"  from tcc_menu                                                                      "
	   +"    start with p_menu_cd = '000000'                                                  "
	   +"  connect by prior menu_cd = p_menu_cd                                               "
	   +"    order siblings by display_seq asc                                                "
		);

while(temp.next()){

	if(temp.getString("depth").equals("1")){
		menu.addRow();
		menu.put("menu_cd",temp.getString("menu_cd"));
		menu.put("name",temp.getString("menu_nm"));
		menu.put(".m_menu", new DataSet());
	}
	if(temp.getString("depth").equals("2")){
		DataSet m_menu = (DataSet)menu.getRow().get(".m_menu");
		m_menu.addRow();
		m_menu.put("menu_cd",temp.getString("menu_cd"));
		m_menu.put("name",temp.getString("menu_nm"));
		m_menu.put("font_color", u.getItem(temp.getString("dir"),menu_font_color));
		m_menu.put(".s_menu", new DataSet());
	}
	if(temp.getString("depth").equals("3")){
		DataSet m_menu = (DataSet)menu.getRow().get(".m_menu");
		DataSet s_menu = (DataSet)m_menu.getRow().get(".s_menu");
		s_menu.addRow();
		s_menu.put("menu_cd",temp.getString("menu_cd"));
		s_menu.put("name",temp.getString("menu_nm"));
		s_menu.put("href",temp.getString("menu_path"));
		s_menu.put("font_color", u.getItem(temp.getString("dir"),menu_font_color));
	}
}

//depth title
String l_dir = "";
String l_menu_cd = "";
String menu_cd = u.request("menu_cd");
boolean view_nav = true;
if(menu_cd.equals("000000")){
	view_nav =  false;
	menu_cd = "";
}

DataSet dtitle = new DataSet();
DataSet dmenu = new DataSet();
if(!menu_cd.equals("")){

		menuDao = new DataObject("tcc_menu");
		dtitle = menuDao.query(
				"  select menu_cd, depth, menu_nm, menu_path, dir "
						+ "    from tcc_menu                           "
						+ "   start with menu_cd = '" + menu_cd + "'       "
						+ " connect by prior  p_menu_cd = menu_cd      "
						+ "   order by depth  asc 			          "
				);

		while(dtitle.next()){
			if(dtitle.getString("depth").equals("1")){
				l_menu_cd = dtitle.getString("menu_cd");
				l_dir =  dtitle.getString("dir");
			}
			dtitle.put("depth3",dtitle.getString("depth").equals("3"));
		}

}

if(!l_menu_cd.equals("")){
	menu.first();
	while(menu.next()){
		if(menu.getString("menu_cd").equals(l_menu_cd)){
			dmenu = ((DataSet)menu.getRow().get(".m_menu"));
			break;
		}
	}
}

p.setLoop("menu", menu);
p.setVar("view_nav", view_nav);
p.setLoop("dtitle", dtitle);
if(l_dir.equals("supplier")) {
	p.setVar("nav_background", "#5b5f7d");
	p.setVar("nav_background_highlight", "#1a1f42");
}else if(l_dir.equals("buyer")) {
	p.setVar("nav_background", "#0d6cbe");
	p.setVar("nav_background_highlight", "#054c7d");
}else if(l_dir.equals("fc")) {
	p.setVar("nav_background", "#ec7064");
	p.setVar("nav_background_highlight", "#d44234");
}else if(l_dir.equals("logis")) {
	p.setVar("nav_background", "#33afb1");
	p.setVar("nav_background_highlight", "#066d6e");
} else {
	p.setVar("nav_background", "#5b5f7d");
	p.setVar("nav_background_highlight", "#1a1f42");
}
p.setLoop("dmenu", dmenu);
p.setVar("logo_img", auth.getString("_LOGO_IMG_PATH"));
p.setVar("use_string", auth.getString("_USE_STRING"));
out.print(p.fetch("../html/layout/topMenu.html"));
%>
