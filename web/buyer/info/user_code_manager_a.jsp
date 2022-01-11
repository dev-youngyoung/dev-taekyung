<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String l_cd = u.request("l_cd");
String mode = u.request("mode");
if(l_cd.equals("") || mode.equals("")){
	out.print("0");
	return;
}
String code = f.get("l_cd")+f.get("m_cd")+f.get("s_cd")+f.get("d_cd");
String code_nm = new String(Base64Coder.decode(f.get("code_nm")), "UTF-8");

DB db = new DB();
DataObject itemInfoDao = null;
if(mode.equals("I")) {
	itemInfoDao = new DataObject("tcb_user_code");
	DataSet item = itemInfoDao.find("member_no='" + _member_no + "' and code='" + code + "' ");
	if (item.next()) {
		out.print("-1");
		return;
	}

	itemInfoDao = new DataObject("tcb_user_code");
	itemInfoDao.item("member_no", _member_no);
	itemInfoDao.item("code", code);
	itemInfoDao.item("l_cd", f.get("l_cd"));
	itemInfoDao.item("m_cd", f.get("m_cd"));
	itemInfoDao.item("s_cd", f.get("s_cd"));
	itemInfoDao.item("d_cd", f.get("d_cd"));
	itemInfoDao.item("depth", f.get("depth"));
	itemInfoDao.item("code_nm", code_nm);
	itemInfoDao.item("use_yn", f.get("use_yn"));

	db.setCommand(itemInfoDao.getInsertQuery(), itemInfoDao.record);
} else if(mode.equals("U")) {
	itemInfoDao = new DataObject("tcb_user_code");
	itemInfoDao.item("code_nm", code_nm);
	itemInfoDao.item("use_yn", f.get("use_yn"));

	db.setCommand(itemInfoDao.getUpdateQuery("member_no='"+_member_no+"' and code='"+code+"'"), itemInfoDao.record);
} else if(mode.equals("D")) {
	itemInfoDao = new DataObject("tcb_user_code");
	db.setCommand(itemInfoDao.getDeleteQuery("member_no='"+_member_no+"' and code='"+code+"'"), itemInfoDao.record);
}

if(!db.executeArray()){
	out.print("0");
	return;
}
out.print("1");
%>