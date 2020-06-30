<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%><%@ include file="init.jsp"%>
<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ page import="	 java.util.*
					,nicelib.db.*
					,nicelib.util.*
"%>
<%

	String grid = u.request("grid");
	if(!grid.equals("")){
		grid = URLDecoder.decode(grid,"UTF-8");
	}
	DataSet data = new DataSet();
	DataSet loop = u.grid2dataset(grid);

	data = setDeptData(data,loop);

	data.first();
	DB db = new DB();

	DataObject  deptDao = new DataObject("tcb_field");
	deptDao.find(" member_no = '"+ _member_no+"'");
	db.setCommand("delete from tcb_field where  member_no = '"+ _member_no+"'", null);

	while(data.next()){
		deptDao = new DataObject("tcb_field");
		deptDao.item("member_no", _member_no);
		deptDao.item("field_seq", data.getString("dept_cd"));
		deptDao.item("p_field_seq", data.getString("p_dept_cd"));
		deptDao.item("field_name", data.getString("dept_name"));
		deptDao.item("status","10");
		deptDao.item("field_gubun","01");
		deptDao.item("use_yn", data.getString("use_yn"));
		db.setCommand(deptDao.getInsertQuery(),deptDao.record);
	}


	if(!db.executeArray()){
		out.print("0");
		return;
	}
	out.print("1");

%>
<%!
	public DataSet setDeptData(DataSet data, DataSet loop){
		while(loop.next()){
			data.addRow();
			data.put("dept_cd", loop.getString("dept_cd"));
			data.put("p_dept_cd", loop.getString("p_dept_cd"));
			data.put("p_real_field_seq", loop.getString("p_real_field_seq"));
			data.put("depth", loop.getString("depth"));
			data.put("dept_name", loop.getString("dept_name"));
			data.put("end_node_yn", loop.getString("end_node_yn"));
			data.put("use_yn", loop.getString("use_yn"));
			if(loop.getDataSet("rows")!= null){
				setDeptData(data, loop.getDataSet("rows"));
			}
		}
		return data;
	}
%>