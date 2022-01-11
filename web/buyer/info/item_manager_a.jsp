<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String l_cd = u.request("l_cd");
String mode = u.request("mode");
if(l_cd.equals("") || mode.equals("")){
	out.print("0");
	return;
}
String item_cd = f.get("l_cd")+f.get("m_cd")+f.get("s_cd")+f.get("d_cd");
String item_nm = new String(Base64Coder.decode(f.get("item_nm")), "UTF-8");
String standard = new String(Base64Coder.decode(f.get("standard")), "UTF-8");
String unit = new String(Base64Coder.decode(f.get("unit")), "UTF-8");

DB db = new DB();
DataObject itemInfoDao = null;
if(mode.equals("I")) {
	itemInfoDao = new DataObject("tcb_item_info");
	DataSet item = itemInfoDao.find("member_no='" + _member_no + "' and item_cd='" + item_cd + "'");
	if (item.next()) {
		out.print("-1");
		return;
	}

	itemInfoDao = new DataObject("tcb_item_info");
	itemInfoDao.item("member_no", _member_no);
	itemInfoDao.item("item_cd", item_cd);
	itemInfoDao.item("l_cd", f.get("l_cd"));
	itemInfoDao.item("m_cd", f.get("m_cd"));
	itemInfoDao.item("s_cd", f.get("s_cd"));
	itemInfoDao.item("d_cd", f.get("d_cd"));
	itemInfoDao.item("depth", f.get("depth"));
	itemInfoDao.item("item_nm", item_nm);
	itemInfoDao.item("standard", standard);
	itemInfoDao.item("unit", unit);
	itemInfoDao.item("use_yn", f.get("use_yn"));
	itemInfoDao.item("mat_cd", f.get("mat_cd"));

	db.setCommand(itemInfoDao.getInsertQuery(), itemInfoDao.record);
} else if(mode.equals("U")) {
	itemInfoDao = new DataObject("tcb_item_info");
	itemInfoDao.item("item_nm", item_nm);
	itemInfoDao.item("standard", standard);
	itemInfoDao.item("unit", unit);
	itemInfoDao.item("use_yn", f.get("use_yn"));
	itemInfoDao.item("mat_cd", f.get("mat_cd"));

	db.setCommand(itemInfoDao.getUpdateQuery("member_no='"+_member_no+"' and item_cd='"+item_cd+"'"), itemInfoDao.record);
} else if(mode.equals("D")) {
	itemInfoDao = new DataObject("tcb_item_info");
	db.setCommand(itemInfoDao.getDeleteQuery("member_no='"+_member_no+"' and item_cd='"+item_cd+"'"), itemInfoDao.record);
}

if(!db.executeArray()){
	out.print("0");
	return;
}
out.print("1");
%>