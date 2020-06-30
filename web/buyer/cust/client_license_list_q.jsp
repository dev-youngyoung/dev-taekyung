<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp"%>
<%
DataObject userCodeDao = new DataObject("tcb_user_code");

DataSet userCode = userCodeDao.query("select tb.*						"
		+ "	,case when depth=4 then 0									"
		+ "	   when depth=3 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 7)||'%')		"
		+ "    when depth=2 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 4)||'%')	 	"
		+ "    when depth=1 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 1)||'%')	 	"
		+ "    end end_node_cnt																														"
		+ "	,case when depth=4 then (select count(client_no) from tcb_client_tech where member_no=tb.member_no and tech_cd=tb.code) 					 		"
		+ "    when depth=3 then (select count(client_no) from tcb_client_tech where member_no=tb.member_no and tech_cd like substr(tb.code, 1, 7)||'%')	 	"
		+ "    when depth=2 then (select count(client_no) from tcb_client_tech where member_no=tb.member_no and tech_cd like substr(tb.code, 1, 4)||'%')	 	"
		+ "    when depth=1 then (select count(client_no) from tcb_client_tech where member_no=tb.member_no and tech_cd like substr(tb.code, 1, 1)||'%')	 	"
		+ "    end code_cnt													"
		+ "    from ( 														"
		+ "    		select a.* 												"
		+ "    		,case when depth=4 then substr(code, 1, 7)||'000' 		"
		+ "    		when depth=3 then substr(code, 1, 4)||'000000' 			"
		+ "    		when depth=2 then substr(code, 1, 1)||'000000000' 		"
		+ "    		when depth=1 then '' 									"
		+ "    		end p_code 												"
		+ "			from tcb_user_code a									"
		+ "			where member_no='"+_member_no+"'						"
		+ "			and  l_cd = 'A'										    "
		+ " ) tb															");

DataSet loop = getUserCodeLoop(userCode, "");
out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
public DataSet getUserCodeLoop( DataSet userCode , String p_code){
	DataSet loop = new DataSet();
	userCode.first();
	while(userCode.next()) {
		if (userCode.getString("p_code").equals(p_code)) {
			loop.addRow();
			loop.put("icon", Integer.parseInt(userCode.getString("end_node_cnt")) < 1 ? 2 : 1);
			loop.put("l_cd", userCode.getString("l_cd"));
			loop.put("m_cd", userCode.getString("m_cd"));
			loop.put("s_cd", userCode.getString("s_cd"));
			loop.put("d_cd", userCode.getString("d_cd"));
			loop.put("code", userCode.getString("code"));
			loop.put("p_code", userCode.getString("p_code"));
			loop.put("code_nm", userCode.getString("code_nm"));
			loop.put("depth", userCode.getString("depth"));
			loop.put("use_yn", userCode.getString("use_yn"));
			loop.put("code_cnt", userCode.getString("code_cnt"));
			loop.put("member_no", userCode.getString("member_no"));
			loop.put("end_node_yn", Integer.parseInt(userCode.getString("end_node_cnt")) < 1 ? "Y" : "N");
			if (Integer.parseInt(userCode.getString("end_node_cnt")) > 0) {
				loop.put(".rows", getUserCodeLoop(userCode.getCloneDataSet(), userCode.getString("code")));
			}
		}
	}
	return loop;
}
%>