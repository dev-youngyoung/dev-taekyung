<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%

//top menu ����
DataSet menu = new DataSet();
if(auth.isValid()){	//	�α����� ���
	if(u.inArray(auth.getString("_MEMBER_TYPE"), new String[]{"01","03"}) ){// ����ۼ� ��ü
		DataObject menuDao = new DataObject("tcb_menu");
		DataSet temp = new DataSet();
		if(auth.getString("_DEFAULT_YN").equals("Y")){
			temp = menuDao.query(                                                 
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			       select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn = 'Y'                                                                                            "
					+" 				  and aa.dir <> 'guide'                                                                                          "
					+" 				  and (                                                                                                          "
					+" 				  menu_cd in (select menu_cd from tcb_menu_member where member_no= '"+auth.getString("_MEMBER_NO")+"' and menu_cd = aa.menu_cd)"
					+" 				   or (depth = 3 and gap_yn is null and eul_yn is null and use_yn = 'Y')                                         "
					+" 				   )                                                                                                             "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			  connect by prior  menu_cd = p_menu_cd                                                                              "
					+" 			    )  cnt                                                                                                           "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with p_menu_cd = '000000'                                                                                            "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0                                                                                                                "
					);
		}else{
			temp = menuDao.query(                                                 
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			   select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn = 'Y'                                                                                            "
					+" 				  and aa.dir <> 'guide'                                                                                          "
					+"                and (                                                                                                          "
					+"                    menu_cd in (                                                                                               "
					+"					select a2.menu_cd                                                                                            "
					+"					  from tcb_menu_member a1, tcb_auth_menu a2                                                                  "
					+"					 where a1.member_no = a2.member_no                                                                           "
					+"					   and a1.menu_cd = a2.menu_cd                                                                               "
					+"					   and a1.member_no = '"+auth.getString("_MEMBER_NO")+"'                                                     "
					+"					   and a2.auth_cd = '"+auth.getString("_AUTH_CD")+"'                                                         "
					+"					   and a2.menu_cd = aa.menu_cd                                                                               "
					+"		              )                                                                                                          "
					+"		           or  (depth = 3 and gap_yn is null and eul_yn is null and use_yn = 'Y')                                        "
					+"		           )                                                                                                             "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			  connect by prior  menu_cd = p_menu_cd                                                                              "
					+"		         )  cnt                                                                                                          "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with p_menu_cd = '000000'                                                                                            "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0                                                                                                                "
					);
		}
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
				m_menu.put(".s_menu", new DataSet());
			}
			if(temp.getString("depth").equals("3")){
				DataSet m_menu = (DataSet)menu.getRow().get(".m_menu");
				DataSet s_menu = (DataSet)m_menu.getRow().get(".s_menu");
				s_menu.addRow();
				s_menu.put("menu_cd",temp.getString("menu_cd"));
				//s_menu.put("name",temp.getString("menu_nm")+"("+temp.getString("menu_cd")+")");
				s_menu.put("name",temp.getString("menu_nm"));
				s_menu.put("href",temp.getString("menu_path"));
			}
		}
	}else{// ��� ���� ��ü
		DataObject menuDao = new DataObject("tcb_menu");
		DataSet temp = new DataSet();
		if(!auth.getString("_MEMBER_GUBUN").equals("04")){//�� �����
			String not_in_menu = "'000119'";
			if(!auth.getString("_DEFAULT_YN").equals("Y")){
				not_in_menu = "'000119','000108','000120','000109'";
			}
			temp= menuDao.query(
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			       select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn = 'Y'                                                                                            "
					+" 				  and aa.dir <> 'guide'                                                                                          "
					+" 				  and menu_cd in (                                                                                               "
					+" 				           select menu_cd                                                                                        "
					+" 				             from tcb_menu                                                                                       "
					+" 				            where depth = 3                                                                                      "
					+" 				              and ( eul_yn = 'Y' or ( gap_yn is null and eul_yn is null and use_yn = 'Y') )                      "
					+" 				              and menu_cd = aa.menu_cd and menu_cd not in ("+not_in_menu+")                                      "
					+" 				             )                                                                                                   "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
					+" 			    ) cnt                                                                                                            "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with p_menu_cd = '000000'                                                                                            "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0                                                                                                                "
					);
			
		}else{// �� ����
			temp = menuDao.query(
					 " select *                                                                                                                      "
					+"   from (                                                                                                                      "
					+" 	 select menu_cd, depth, menu_nm, menu_path                                                                                   "
					+" 			   ,(                                                                                                                "
					+" 			       select count(*)                                                                                               "
					+" 				 from tcb_menu aa                                                                                                "
					+" 				where aa.use_yn = 'Y'                                                                                            "
					+" 				  and aa.dir <> 'guide'                                                                                           "
					+" 				  and menu_cd in (                                                                                               "
					+" 				     select menu_cd                                                                                              "
					+" 				       from tcb_menu                                                                                             "
					+" 				     where depth = 3                                                                                             "
					+" 				       and (eul_yn = 'Y' or (gap_yn is null and eul_yn is null and use_yn = 'Y') )                               "
					+" 				       and menu_cd = aa.menu_cd and (dir  <> 'info' or (dir = 'info' and menu_cd in('000109','000118','000135') )) ) "
					+" 				start with menu_cd = a.menu_cd                                                                                   "
					+" 			      connect by prior  menu_cd = p_menu_cd                                                                          "
					+" 			    ) cnt                                                                                                            "
					+" 	   from tcb_menu a                                                                                                           "
					+" 	  start with p_menu_cd = '000000'                                                                                            "
					+" 	connect by prior  menu_cd = p_menu_cd                                                                                        "
					+" 	  order siblings by  display_seq asc                                                                                         "
					+"        )                                                                                                                      "
					+"  where cnt > 0                                                                                                                "
					);
		}
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
				m_menu.put(".s_menu", new DataSet());
			}
			if(temp.getString("depth").equals("3")){
				DataSet m_menu = (DataSet)menu.getRow().get(".m_menu");
				DataSet s_menu = (DataSet)m_menu.getRow().get(".s_menu");
				s_menu.addRow();
				s_menu.put("menu_cd",temp.getString("menu_cd"));
				//s_menu.put("name",temp.getString("menu_nm")+"("+temp.getString("menu_cd")+")");
				s_menu.put("name",temp.getString("menu_nm"));
				s_menu.put("href",temp.getString("menu_path"));
			}
		}
	}
}else{//�α��� ���� ���
	DataObject menuDao = new DataObject("tcb_menu");
	DataSet temp = menuDao.query(
		  " select *                                       "
		 +"   from tcb_menu                                "
		 +"  where menu_cd in (                            "
		 +"  '000001','000002','000003','000004','000007','000009'  " // ��з�
		 +"  ,'000028','000029','000125','000126'                   " // ������
		 +"  ,'000030','000130','000131','000132','000133' " // ���� �̿�ȳ�
		 +"  ,'000127','000128','000129'                                      "
		 +"  )                                             "
		 +"  start with p_menu_cd = '000000'               "
		 +"connect by prior menu_cd = p_menu_cd            "
		 +"  order siblings by  display_seq asc            "
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
			m_menu.put(".s_menu", new DataSet());
		}
		if(temp.getString("depth").equals("3")){
			DataSet m_menu = (DataSet)menu.getRow().get(".m_menu");
			DataSet s_menu = (DataSet)m_menu.getRow().get(".s_menu");
			s_menu.addRow();
			s_menu.put("menu_cd",temp.getString("menu_cd"));
			s_menu.put("name",temp.getString("menu_nm"));
			s_menu.put("href",temp.getString("menu_path"));
		}
	}
}

p.setLoop("menu", menu);
out.print(p.fetch("../html/layout/topMenu.html"));
%>
	
	