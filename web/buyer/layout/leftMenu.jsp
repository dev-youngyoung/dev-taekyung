<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String menu_cd = u.request("menu_cd");
if(menu_cd.equals("")){
	return;
}

DataObject menuDao = new DataObject("tcb_menu");
DataSet title = menuDao.query(
		 " select menu_cd, depth, menu_nm        "
		+"    from tcb_menu                      "     
		+"   start with menu_cd = '"+menu_cd+"'  "
		+" connect by prior  p_menu_cd = menu_cd "     
		+"   order by depth  asc 			     "
		);
String l_menu_cd = "";
String l_menu_nm = "";
while(title.next()){
	if(title.getString("depth").equals("1")){
		l_menu_cd = title.getString("menu_cd");
		l_menu_nm = title.getString("menu_nm");
	}
}

DataSet menu = new DataSet();
if(auth.isValid()){ // 로그인 한경우
		
	if(u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"}) ){// 계약작성 업체
		if("Y".equals(auth.getString("_DEFAULT_YN"))){
	 		menu = menuDao.query(
			 " select *                                                                                                                      "
			+"   from (                                                                                                                      "
			+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
			+" 			  , (                                                                                                                "
			+" 			       select count(*)                                                                                               "
			+" 				 from tcb_menu aa                                                                                                "
			+" 				where aa.use_yn = 'Y'                                                                                            "
			+" 				  and menu_cd in (select menu_cd from tcb_menu_member where member_no= '"+auth.getString("_MEMBER_NO")+"' and menu_cd = aa.menu_cd)"
			+" 				   or (depth = 3 and gap_yn is null and eul_yn is null and use_yn = 'Y')                                         "
			+" 				start with menu_cd = a.menu_cd                                                                                   "
			+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
			+" 			    ) cnt                                                                                                            "
			+" 	   from tcb_menu a                                                                                                           "
			+" 	  start with menu_cd = '"+l_menu_cd+"'                                                                                       "
			+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
			+" 	  order siblings by  display_seq asc                                                                                         "
			+"        )                                                                                                                      "
			+"  where cnt > 0 and depth in(2,3)                                                                                              "
			);
		}else{
			menu = menuDao.query(
			 " select *                                                                                                                      "
			+"   from (                                                                                                                      "
			+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
			+" 			   ,(                                                                                                                "
			+" 			       select count(*)                                                                                               "
			+" 				 from tcb_menu aa                                                                                                "
			+" 				where aa.use_yn = 'Y'                                                                                            "
			+" 				  and menu_cd in (                                                                                               "
			+"					select a2.menu_cd                                                                                            "
			+"					  from tcb_menu_member a1, tcb_auth_menu a2                                                                  "
			+"					 where a1.member_no = a2.member_no                                                                           "
			+"					   and a1.menu_cd = a2.menu_cd                                                                               "
			+"					   and a1.member_no = '"+auth.getString("_MEMBER_NO")+"'                                                     "
			+"					   and a2.auth_cd = '"+auth.getString("_AUTH_CD")+"'                                                         "
			+"					   and a2.menu_cd = aa.menu_cd                                                                               "
			+"		         )                                                                                                               "
			+"		         or ( depth = 3  and gap_yn is null and eul_yn is null and use_yn = 'Y')                                         "
			+" 				start with menu_cd = a.menu_cd                                                                                   "
			+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
			+" 			    ) cnt                                                                                                            "
			+" 	   from tcb_menu a                                                                                                           "
			+" 	  start with menu_cd = '"+l_menu_cd+"'                                                                                       "
			+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
			+" 	  order siblings by  display_seq asc                                                                                         "
			+"        )                                                                                                                      "
			+"  where cnt > 0 and depth in(2,3)                                                                                              "
			);
		}
	}else{
		if(!auth.getString("_MEMBER_GUBUN").equals("04")){//을 사업자
			String not_in_menu = "'000119'";
			if(!auth.getString("_DEFAULT_YN").equals("Y")){
				not_in_menu = "'000119','000108','000120','000109'";
			}
		  menu = menuDao.query(
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			       select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn  ='Y'                                                                                            "
					+" 				  and menu_cd in (select menu_cd from tcb_menu where depth = 3 and (eul_yn = 'Y' or (gap_yn is null and eul_yn is null) )and menu_cd = aa.menu_cd and menu_cd not in ("+not_in_menu+") ) "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
					+" 			    ) cnt                                                                                                            "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with menu_cd = '"+l_menu_cd+"'                                                                                       "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0 and depth in(2,3)                                                                                              "
					);
			
		}else{// 을 개인
			menu = menuDao.query(
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			       select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn = 'Y'                                                                                            "
					+" 				  and menu_cd in (select menu_cd from tcb_menu where depth = 3 and (eul_yn = 'Y' or (gap_yn is null and eul_yn is null) ) and menu_cd = aa.menu_cd and (dir  <> 'info' or (dir = 'info' and menu_cd in('000109','000118','000135') )) ) "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
					+" 			    ) cnt                                                                                                            "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with menu_cd = '"+l_menu_cd+"'                                                                                       "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0 and depth in(2,3)                                                                                              "
					);
		}
	}

}else{//로그인 안한경우
	menu = menuDao.query(
			 " select *                                                                                                                      "
			+"   from (                                                                                                                      "
			+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
			+" 		 , case                                                                                                                  "
			+" 			 when depth in (1,2) then                                                                                            "
			+" 			    (                                                                                                                "
			+" 			       select count(*)                                                                                               "
			+" 				 from tcb_menu aa                                                                                                "
			+" 				where aa.use_yn = 'Y'                                                                                            "
			+" 				  and menu_cd in (select menu_cd from tcb_menu where depth = '3' and gap_yn is null and eul_yn is null and menu_cd = aa.menu_cd) "
			+" 				start with menu_cd = a.menu_cd                                                                                   "
			+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
			+" 			    )                                                                                                                "
			+" 			  when depth = 3 then (select count(*) from tcb_menu where gap_yn is null and eul_yn is null  and menu_cd = a.menu_cd) "
			+" 		     end cnt                                                                                                             "
			+" 	   from tcb_menu a                                                                                                           "
			+" 	  where nvl(use_yn,'Y') = 'Y'                                                                                                "
			+" 	  start with menu_cd = '"+l_menu_cd+"'                                                                                       "
			+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
			+" 	  order siblings by  display_seq asc                                                                                         "
			+"        )                                                                                                                      "
			+"  where cnt > 0 and depth in(2,3)                                                                                              "
			); 
	
}

String depth = "";
while(menu.next()){
	menu.put("depth2", menu.getString("depth").equals("2"));
	menu.put("depth3", menu.getString("depth").equals("3"));
}
p.setDebug(out);
p.setLoop("menu", menu);
p.setVar("l_menu_nm", l_menu_nm);
out.print(p.fetch("../html/layout/leftMenu.html"));
%>
	
	