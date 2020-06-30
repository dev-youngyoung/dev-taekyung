<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp"%>
<%

String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}
 
DataSet data = new DataSet();
DataSet loop = u.grid2dataset(grid);

data = setMenuData(data,loop);
data.first();

DB db = new DB();
db.setCommand("delete from tcb_menu where 1=1", null);

DataObject  menuDao = new DataObject("tcb_menu");
while(data.next()){
	menuDao = new DataObject("tcb_menu");
	menuDao.item("menu_cd", data.getString("menu_cd"));
	menuDao.item("p_menu_cd", data.getString("p_menu_cd"));
	menuDao.item("depth", data.getString("depth"));
	menuDao.item("dir", data.getString("dir"));
	menuDao.item("menu_path", data.getString("menu_path"));
	menuDao.item("menu_nm", data.getString("menu_nm"));
	if(data.getString("depth").equals("3")){
		menuDao.item("gap_yn", data.getString("gap_yn").equals("Y")?"Y":"");
		menuDao.item("eul_yn", data.getString("eul_yn").equals("Y")?"Y":"");
		menuDao.item("use_yn", data.getString("use_yn").equals("Y")?"Y":"");
		menuDao.item("select_auth_cds", data.getString("select_auth_cds") );
		menuDao.item("btn_auth_cds", data.getString("btn_auth_cds") );
	}
	menuDao.item("display_seq", data.getString("display_seq"));
	menuDao.item("etc", data.getString("etc"));
	menuDao.item("adm_cd", data.getString("adm_cd"));
	db.setCommand(menuDao.getInsertQuery(), menuDao.record); 
}

if(!db.executeArray()){
	out.print("0");
	return;
}    
out.print("1"); 

%>
<%!
public DataSet setMenuData(DataSet data, DataSet loop){
	while(loop.next()){
		data.addRow();
		data.put("menu_cd", loop.getString("menu_cd"));
		data.put("p_menu_cd", loop.getString("p_menu_cd"));
		data.put("depth", loop.getString("depth"));
		data.put("dir", loop.getString("dir"));
		data.put("menu_path", loop.getString("menu_path"));
		data.put("menu_nm", loop.getString("menu_nm"));
		data.put("gap_yn", loop.getString("gap_yn"));
		data.put("eul_yn", loop.getString("eul_yn"));
		data.put("use_yn", loop.getString("use_yn"));
		data.put("display_seq", loop.getString("display_seq"));
		data.put("select_auth_cds", loop.getString("select_auth_cds"));
		data.put("btn_auth_cds", loop.getString("btn_auth_cds"));
		data.put("etc", loop.getString("etc"));
		data.put("adm_cd", loop.getString("adm_cd"));
		if(loop.getDataSet("rows")!= null){
			setMenuData(data, loop.getDataSet("rows"));
		}
	}
	return data;
}
%>