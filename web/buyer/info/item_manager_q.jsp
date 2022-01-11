<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="init.jsp"%>
<%
DataObject itemDao = new DataObject("tcb_item_info");

DataSet item = itemDao.query("select tb.*								"
		+ "	,case when depth=4 then 0 									"
		+ "    when depth=3 then (select count(item_cd) from tcb_item_info where member_no=tb.member_no and item_cd like substr(tb.item_cd, 1, 7)||'%')	"
		+ "    when depth=2 then (select count(item_cd) from tcb_item_info where member_no=tb.member_no and item_cd like substr(tb.item_cd, 1, 4)||'%')	"
		+ "    when depth=1 then (select count(item_cd) from tcb_item_info where member_no=tb.member_no and item_cd like substr(tb.item_cd, 1, 1)||'%')	"
		+ "    end end_node_cnt											"
		+ "    ,(select count(seq) from tcb_item_unit where member_no = tb.member_no and item_cd = tb.item_cd) unit_cnt	"
		+ "    ,case when (length(p_item_cd_tmp)-length(item_cd)) > 0 then substr(p_item_cd_tmp, 1, length(item_cd)) else p_item_cd_tmp end	p_item_cd "
		+ "    from ( 														"
		+ "    		select a.* 												"
		+ "    		,case when depth=4 then substr(item_cd, 1, 7)||'00000' 	"
		+ "    		when depth=3 then substr(item_cd, 1, 4)||'00000000' 	"
		+ "    		when depth=2 then substr(item_cd, 1, 1)||'00000000000' 	"
		+ "    		when depth=1 then '' 						"
		+ "    		end p_item_cd_tmp 										"
		+ "			from tcb_item_info a									"
		+ "			where member_no='"+_member_no+"'						"
		+ " ) tb															");

DataSet loop = getItemLoop(item, "");
out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
public DataSet getItemLoop( DataSet item , String p_item_cd){
	DataSet loop = new DataSet();
	item.first();
	while(item.next()){
		if(item.getString("p_item_cd").equals(p_item_cd)){
			loop.addRow();
			loop.put("icon", Integer.parseInt(item.getString("end_node_cnt"))<1?2:1);
			loop.put("l_cd", item.getString("l_cd"));
			loop.put("m_cd", item.getString("m_cd"));
			loop.put("s_cd", item.getString("s_cd"));
			loop.put("d_cd", item.getString("d_cd"));
			loop.put("item_cd", item.getString("item_cd"));
			loop.put("p_item_cd", item.getString("p_item_cd"));
			loop.put("item_nm", item.getString("item_nm"));
			loop.put("standard", item.getString("standard"));
			loop.put("mat_cd", item.getString("mat_cd"));
			loop.put("unit", item.getString("unit"));
			loop.put("depth", item.getString("depth"));
			loop.put("use_yn", item.getString("use_yn"));
			loop.put("end_node_yn", Integer.parseInt(item.getString("end_node_cnt"))<1?"Y":"N");

			if(Integer.parseInt(item.getString("end_node_cnt")) > 0){
				loop.put(".rows", getItemLoop(item.getCloneDataSet(), item.getString("item_cd")));
			}
		}
	}
	return loop;
}
%>