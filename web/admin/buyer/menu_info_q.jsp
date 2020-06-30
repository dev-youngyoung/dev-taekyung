<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
DataObject menuDao = new DataObject("tcb_menu");

DataSet menu =menuDao.find(" 1=1 ", "*","display_seq asc");
DataSet loop = getmenuLoop(menu, "000000");

out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
public DataSet getmenuLoop( DataSet menu , String p_menu_cd){
	DataSet loop = new DataSet();
	DataObject menuDao = new DataObject("tcf_menu");
	menu.first();
	while(menu.next()){
		if(menu.getString("p_menu_cd").equals(p_menu_cd)){
			loop.addRow();
			loop.put("icon", menu.getString("depth").equals("3")?2:1);
			loop.put("menu_cd", menu.getString("menu_cd"));
			loop.put("p_menu_cd", menu.getString("p_menu_cd"));
			loop.put("depth", menu.getString("depth"));
			loop.put("dir", menu.getString("dir"));
			loop.put("menu_path", menu.getString("menu_path"));
			loop.put("menu_nm", menu.getString("menu_nm"));
			loop.put("gap_yn", menu.getString("depth").equals("3")? menu.getString("gap_yn").equals("Y")?"Y":"N" :"");
			loop.put("eul_yn", menu.getString("depth").equals("3")? menu.getString("eul_yn").equals("Y")?"Y":"N" :"");
			loop.put("use_yn", menu.getString("depth").equals("3")? menu.getString("use_yn").equals("Y")?"Y":"N" :"" );
			loop.put("select_auth_cds", menu.getString("select_auth_cds"));
			loop.put("btn_auth_cds", menu.getString("btn_auth_cds"));
			loop.put("display_seq", menu.getString("display_seq"));
			loop.put("etc", menu.getString("etc"));
			loop.put("adm_cd", menu.getString("adm_cd"));
			if(!menu.getString("depth").equals("3")){
				loop.put(".rows", getmenuLoop(menu.getCloneDataSet(),menu.getString("menu_cd")));
			}
		}
	}
	return loop;
}
%>