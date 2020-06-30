<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근 하세요.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsErrClose("회원정보가 없습니다.");
	return;
}

DataObject menuDao = new DataObject("tcb_menu");
DataSet menu = menuDao.query(
		 "	select p_menu_cd                                    "
		+"	    ,  menu_cd                                      "
		+"	    , depth                                         "
		+"	    , dir                                           "
		+"	    , menu_nm                                       "
		+"	    , etc                                           "
		+"	    ,(select count(*)                               "
		+"	        from tcb_menu                               "
		+"	       where depth=3                                "
		+"	         and (gap_yn ='Y' or eul_yn = 'Y')			"
		+"	        start with p_menu_cd = a.menu_cd            "
		+"	      connect by prior menu_cd=p_menu_cd) row_span  "
		+"	   from tcb_menu a                                  "
		+"	  where ( depth in (1,2) or (depth = '3' and (gap_yn ='Y' or eul_yn = 'Y') ) ) "
		+"	    and dir not in ('member')                       "
		+"	  start with p_menu_cd = '000000'                   "
		+"	 connect by prior  menu_cd = p_menu_cd              "
		+"	 order siblings by  display_seq asc                 "
			);

String depth = "";
DataSet treeMenu = new DataSet();
while(menu.next()){
	if(u.inArray(depth , new String[]{"1","2"})&&menu.getInt("row_span")<1) continue;

	if(!depth.equals(menu.getString("depth"))){
		treeMenu.addRow();
		if(menu.getString("depth").equals("1")){
			if(menu.getInt("row_span")<1){
				treeMenu.removeRow();
				continue;
			}
			depth = menu.getString("depth");
			treeMenu.put("l_menu_nm", menu.getString("menu_nm"));
			treeMenu.put("l_row_span", menu.getString("row_span"));
			menu.next();
		}else{
			treeMenu.put("l_menu_nm", "");
			treeMenu.put("l_row_span", "");
		}
		if(menu.getString("depth").equals("2")){
			if(menu.getInt("row_span")<1){
				treeMenu.removeRow();
				continue;
			}
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
			treeMenu.put("etc", menu.getString("etc"));
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
			treeMenu.put("etc", menu.getString("etc"));
		}
	}
}


DataObject menuMemberDao = new DataObject("tcb_menu_member");
DataSet menuMember = menuMemberDao.find("member_no = '"+member_no+"'");
String[] temp_menu_cd = new String[menuMember.size()];
int i=0;
while(menuMember.next()){
	temp_menu_cd[i] = menuMember.getString("menu_cd");
	i++;
}
String member_menu_cds = u.join(",", temp_menu_cd);

if(u.isPost()&&f.validate()){
	
	String menu_cds = f.get("menu_cds");
	DB db = new DB();
	db.setCommand("delete from tcb_menu_member where member_no = '"+member_no+"' ", null);
	if(!menu_cds.equals("")){
		String[] arr_menu_cd = menu_cds.split(",");
		for(int j = 0 ; j < arr_menu_cd.length; j++ ){
			menuMemberDao = new DataObject("tcb_menu_member");
			menuMemberDao.item("member_no", member_no);
			menuMemberDao.item("menu_cd", arr_menu_cd[j]);
			db.setCommand(menuMemberDao.getInsertQuery(),menuMemberDao.record);
		}
	}
	if(!db.executeArray()){
		u.jsError("저장에 실패 하였습니다.");
		return;
	}
	u.jsAlertReplace("저장하였습니다.", "pop_menu_member.jsp?"+u.getQueryString());
	return;
}

p.setLayout("popup");
p.setDebug(out);
p.setBody("buyer.pop_menu_member");
p.setVar("popup_title","메뉴권한 관리");
p.setVar("member", member);
p.setLoop("treeMenu", treeMenu);
p.setVar("member_menu_cds", member_menu_cds);
p.setVar("form_script",f.getScript());
p.display(out);
%>