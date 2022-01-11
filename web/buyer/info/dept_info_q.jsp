<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="init.jsp"%>
<%
	DataObject fieldDao = new DataObject("tcb_field");

	DataSet field = fieldDao.query("select tb.*, decode(end_node_yn, 'Y', 2, 1) icon from (select "
			+ " a.field_seq dept_cd , a.p_field_seq p_dept_cd ,a.field_name dept_name, a.use_yn "
			+ " ,level depth, case when (select count(field_seq) from tcb_field where member_no = a.member_no and a.field_seq=p_field_seq ) < 1 then 'Y' else 'N' END end_node_yn "
			+ "from tcb_field a "
			+ "where member_no='"+_member_no+"' "
			+ "  and status > 0  "
			+ "start with p_field_seq = 9999 "
			+ "connect by prior field_seq=p_field_seq and prior member_no = member_no) tb");

	DataSet loop = getDeptLoop(field, "9999");
	out.println("{\"rows\":" + u.loop2json(loop) +"}");
%>
<%!
	public DataSet getDeptLoop( DataSet dept , String p_dept_cd){
		DataSet loop = new DataSet();
		dept.first();
		while(dept.next()){
			if(dept.getString("p_dept_cd").equals(p_dept_cd)){
				loop.addRow();
				loop.put("icon", dept.getString("end_node_yn").equals("Y")?2:1);
				loop.put("dept_cd", dept.getString("dept_cd"));
				loop.put("p_dept_cd", dept.getString("p_dept_cd"));
				loop.put("dept_name", dept.getString("dept_name"));
				loop.put("depth", dept.getString("depth"));
				loop.put("use_yn", dept.getString("use_yn"));
				loop.put("end_node_yn", dept.getString("end_node_yn"));

				if(!dept.getString("end_node_yn").equals("Y")){
					loop.put(".rows", getDeptLoop(dept.getCloneDataSet(),dept.getString("dept_cd")));
				}
			}
		}
		return loop;
	}
%>