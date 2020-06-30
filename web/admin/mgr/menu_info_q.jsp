<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%		

String query=
 "  select *                            "
+"   from tcc_menu                      "
+"   start with  p_menu_cd = '000000'   "
+" connect by prior menu_cd = p_menu_cd "
+"   order siblings by display_seq asc  ";

DataObject menuDao = new DataObject("tcc_menu");

DataSet ds = menuDao.query(query);

DataSet loop = new DataSet(); 
while(ds.next()){
	if(ds.getString("depth").equals("1")){
		loop.addRow();
		loop.put("icon",1);
		loop.put("menu_cd",ds.getString("menu_cd"));
		loop.put("p_menu_cd",ds.getString("p_menu_cd"));
		loop.put("menu_nm",ds.getString("menu_nm"));
		loop.put("depth",ds.getString("depth"));
		loop.put("dir",ds.getString("dir"));
		loop.put("menu_path",ds.getString("menu_path"));
		loop.put("display_seq",ds.getString("display_seq"));
		loop.put("btn_auth_cds",ds.getString("btn_auth_cds"));
		loop.put("etc",ds.getString("etc"));
		loop.put(".rows", new DataSet());
	}
	if(ds.getString("depth").equals("2")){
		DataSet m_loop = (DataSet)loop.getRow().get(".rows");
		m_loop.addRow();
		m_loop.put("icon",1);
		m_loop.put("menu_cd",ds.getString("menu_cd"));
		m_loop.put("p_menu_cd",ds.getString("p_menu_cd"));
		m_loop.put("menu_nm",ds.getString("menu_nm"));
		m_loop.put("depth",ds.getString("depth"));
		m_loop.put("dir",ds.getString("dir"));
		m_loop.put("menu_path",ds.getString("menu_path"));
		m_loop.put("display_seq",ds.getString("display_seq"));
		m_loop.put("btn_auth_cds",ds.getString("btn_auth_cds"));
		m_loop.put("etc",ds.getString("etc"));
		m_loop.put(".rows", new DataSet());
	}
	if(ds.getString("depth").equals("3")){
		DataSet m_loop = (DataSet)loop.getRow().get(".rows");
		DataSet s_loop = (DataSet)m_loop.getRow().get(".rows");
		s_loop.addRow();
		s_loop.put("icon",2);
		s_loop.put("menu_cd",ds.getString("menu_cd"));
		s_loop.put("p_menu_cd",ds.getString("p_menu_cd"));
		s_loop.put("menu_nm",ds.getString("menu_nm"));
		s_loop.put("depth",ds.getString("depth"));
		s_loop.put("dir",ds.getString("dir"));
		s_loop.put("menu_path",ds.getString("menu_path"));
		s_loop.put("display_seq",ds.getString("display_seq"));
		s_loop.put("btn_auth_cds",ds.getString("btn_auth_cds"));
		s_loop.put("etc",ds.getString("etc"));
	}
}
out.println("{\"rows\":"+u.loop2json(loop)+"}");

%>