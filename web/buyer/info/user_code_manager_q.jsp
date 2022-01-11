<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="init.jsp"%>
<%
	DataObject itemDao = new DataObject("tcb_user_code");

	DataSet item = itemDao.query("select tb.*								"
			+ "	,case when depth=4 then 0 									"
			+ "    when depth=3 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 7)||'%')	"
			+ "    when depth=2 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 4)||'%')	"
			+ "    when depth=1 then (select count(code) from tcb_user_code where member_no=tb.member_no and code like substr(tb.code, 1, 1)||'%')	"
			+ "    end end_node_cnt											"
			+ "    from ( 														"
			+ "    		select a.* 												"
			+ "    		,case when depth=4 then substr(code, 1, 7)||'000' 	"
			+ "    		when depth=3 then substr(code, 1, 4)||'000000' 	"
			+ "    		when depth=2 then substr(code, 1, 1)||'000000000' 	"
			+ "    		when depth=1 then '' 						"
			+ "    		end p_code 												"
			+ "			from tcb_user_code a									"
			+ "			where member_no='"+_member_no+"'						"
			+ " ) tb															");

	DataSet loop = getItemLoop(item, "");
	out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
	public DataSet getItemLoop( DataSet item , String p_code){
		DataSet loop = new DataSet();
		item.first();
		while(item.next()){
			if(item.getString("p_code").equals(p_code)){
				loop.addRow();
				loop.put("icon", Integer.parseInt(item.getString("end_node_cnt"))<1?2:1);
				loop.put("l_cd", item.getString("l_cd"));
				loop.put("m_cd", item.getString("m_cd"));
				loop.put("s_cd", item.getString("s_cd"));
				loop.put("d_cd", item.getString("d_cd"));
				loop.put("code", item.getString("code"));
				loop.put("p_code", item.getString("p_code"));
				loop.put("code_nm", item.getString("code_nm"));
				loop.put("depth", item.getString("depth"));
				loop.put("use_yn", item.getString("use_yn"));
				loop.put("end_node_yn", Integer.parseInt(item.getString("end_node_cnt"))<1?"Y":"N");
				if(Integer.parseInt(item.getString("end_node_cnt")) > 0){
					loop.put(".rows", getItemLoop(item.getCloneDataSet(), item.getString("code")));
				}
			}
		}
		return loop;
	}
%>