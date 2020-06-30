<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
DataObject srcCatDao = new DataObject("tcb_src_adm");

DataSet srcCat = srcCatDao.query("select tb.*								"
		+ "	,case when depth=3 then 0											"
		+ "    when depth=2 then (select count(src_cd) from tcb_src_adm where member_no=tb.member_no and src_cd like substr(tb.src_cd, 1, 6)||'%')	 "
		+ "    when depth=1 then (select count(src_cd) from tcb_src_adm where member_no=tb.member_no and src_cd like substr(tb.src_cd, 1, 3)||'%')	 "
		+ "    end end_node_cnt																														 "
		+ "	,case when depth=3 then (select count(src_cd) from tcb_src_member where member_no=tb.member_no and src_cd=tb.src_cd) 					 "
		+ "    when depth=2 then (select count(src_cd) from tcb_src_member where member_no=tb.member_no and src_cd like substr(tb.src_cd, 1, 6)||'%')	 "
		+ "    when depth=1 then (select count(src_cd) from tcb_src_member where member_no=tb.member_no and src_cd like substr(tb.src_cd, 1, 3)||'%')	 "
		+ "    end src_cnt												"
		+ "    from ( 														"
		+ "    		select a.* 												"
		+ "    		,case when depth=3 then substr(src_cd, 1, 6)||'000' 	"
		+ "    		when depth=2 then substr(src_cd, 1, 3)||'000000' 		"
		+ "    		when depth=1 then '999999999' 							"
		+ "    		end p_src_cd 											"
		+ "			from tcb_src_adm a										"
		+ "			where member_no='"+_member_no+"'						"
		+ " ) tb															");

DataSet loop = getSrcCatLoop(srcCat, "999999999");
out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
public DataSet getSrcCatLoop( DataSet srcCat , String p_src_cd){
	DataSet loop = new DataSet();
	srcCat.first();
	while(srcCat.next()){
		if(srcCat.getString("p_src_cd").equals(p_src_cd)){
			loop.addRow();
			loop.put("icon", Integer.parseInt(srcCat.getString("end_node_cnt"))<1?2:1);
			loop.put("l_src_cd", srcCat.getString("l_src_cd"));
			loop.put("m_src_cd", srcCat.getString("m_src_cd"));
			loop.put("s_src_cd", srcCat.getString("s_src_cd"));
			loop.put("src_cd", srcCat.getString("src_cd"));
			loop.put("p_src_cd", srcCat.getString("p_src_cd"));
			loop.put("src_nm", srcCat.getString("src_nm"));
			loop.put("depth", srcCat.getString("depth"));
			loop.put("use_yn", srcCat.getString("use_yn"));
			loop.put("src_cnt", srcCat.getString("src_cnt"));
			loop.put("member_no", srcCat.getString("member_no"));
			loop.put("end_node_yn", Integer.parseInt(srcCat.getString("end_node_cnt"))<1?"Y":"N");
			if(Integer.parseInt(srcCat.getString("end_node_cnt")) > 0){
				loop.put(".rows", getSrcCatLoop(srcCat.getCloneDataSet(), srcCat.getString("src_cd")));
			}
		}
	}
	return loop;
}
%>