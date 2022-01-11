<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}

DataSet data = new DataSet();

DataSet loop = u.grid2dataset(grid);

DataSet m_loop = null;
DataSet s_loop = null;
while(loop.next()){//대메뉴
	data.addRow();
	data.put("menu_cd", loop.getString("menu_cd"));
	data.put("p_menu_cd", loop.getString("p_menu_cd"));
	data.put("depth", loop.getString("depth"));
	data.put("dir", loop.getString("dir"));
	data.put("menu_path", loop.getString("menu_path"));
	data.put("menu_nm", loop.getString("menu_nm"));
	data.put("display_seq", loop.getString("display_seq"));
	data.put("btn_auth_cds", loop.getString("btn_auth_cds"));
	data.put("etc", loop.getString("etc"));
	if(loop.getDataSet("rows")!=null){
		m_loop = loop.getDataSet("rows");//증메뉴
		m_loop.first();
		while(m_loop.next()){
			data.addRow();
			data.put("menu_cd", m_loop.getString("menu_cd"));
			data.put("p_menu_cd", m_loop.getString("p_menu_cd"));
			data.put("depth", m_loop.getString("depth"));
			data.put("dir", m_loop.getString("dir"));
			data.put("menu_path", m_loop.getString("menu_path"));
			data.put("menu_nm", m_loop.getString("menu_nm"));
			data.put("display_seq", m_loop.getString("display_seq"));
			data.put("btn_auth_cds", m_loop.getString("btn_auth_cds"));
			data.put("etc", m_loop.getString("etc"));
			if(m_loop.getDataSet("rows")!=null){
				s_loop = m_loop.getDataSet("rows");//소메뉴
				s_loop.first();
				while(s_loop.next()){
					data.addRow();
					data.put("menu_cd", s_loop.getString("menu_cd"));
					data.put("p_menu_cd", s_loop.getString("p_menu_cd"));
					data.put("depth", s_loop.getString("depth"));
					data.put("dir", s_loop.getString("dir"));
					data.put("menu_path", s_loop.getString("menu_path"));
					data.put("menu_nm", s_loop.getString("menu_nm"));
					data.put("display_seq", s_loop.getString("display_seq"));
					data.put("btn_auth_cds", s_loop.getString("btn_auth_cds"));
					data.put("etc", s_loop.getString("etc"));
				}
			}
		}
	}
}


data.first();
DB db = new DB();
db.setCommand("delete from tcc_menu", null);
DataObject menuDao = null;
while(data.next()){
	menuDao = new DataObject("tcc_menu");
	menuDao.item("menu_cd", data.getString("menu_cd"));
	menuDao.item("p_menu_cd", data.getString("p_menu_cd"));
	menuDao.item("depth", data.getString("depth"));
	menuDao.item("dir", data.getString("dir"));
	menuDao.item("menu_path", data.getString("menu_path"));
	menuDao.item("menu_nm", data.getString("menu_nm"));
	menuDao.item("display_seq", data.getString("display_seq"));
	menuDao.item("btn_auth_cds", data.getString("btn_auth_cds"));
	menuDao.item("etc", data.getString("etc"));
	db.setCommand(menuDao.getInsertQuery() ,menuDao.record);
}

if(!db.executeArray()){
	out.print("0");
	return;
}  
out.print("1"); 
%>