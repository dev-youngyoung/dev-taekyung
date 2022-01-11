<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@page import="java.net.URLDecoder"%><%@ include file="init.jsp"%>
<%@ page contentType="text/html; charset=UTF-8" %>
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

data = setCateData(data,loop);

data.first();
DB db = new DB();

DataObject  cateDao = new DataObject("tcb_src_adm");
cateDao.find(" member_no = '"+ _member_no+"'");
db.setCommand("delete from tcb_src_adm where  member_no = '"+ _member_no+"'", null);

while(data.next()){
	cateDao = new DataObject("tcb_src_adm");
	cateDao.item("member_no", _member_no);
	cateDao.item("src_cd", data.getString("src_cd"));
	cateDao.item("l_src_cd", data.getString("l_src_cd"));
	cateDao.item("m_src_cd", data.getString("m_src_cd"));
	cateDao.item("s_src_cd", data.getString("s_src_cd"));
	cateDao.item("src_nm", data.getString("src_nm"));
	cateDao.item("depth",data.getString("depth"));
	cateDao.item("use_yn", data.getString("use_yn"));
	db.setCommand(cateDao.getInsertQuery(),cateDao.record);
}


if(!db.executeArray()){
	out.print("0");
	return;
}
out.print("1");

%>
<%!
public DataSet setCateData(DataSet data, DataSet loop){
	while(loop.next()){
		data.addRow();
		data.put("src_cd", loop.getString("src_cd"));
		data.put("l_src_cd", loop.getString("l_src_cd"));
		data.put("m_src_cd", loop.getString("m_src_cd"));
		data.put("s_src_cd", loop.getString("s_src_cd"));
		data.put("src_nm", loop.getString("src_nm"));
		data.put("depth", loop.getString("depth"));
		data.put("use_yn", loop.getString("use_yn"));
		if(loop.getDataSet("rows")!= null){
			setCateData(data, loop.getDataSet("rows"));
		}
	}
	return data;
}
%>