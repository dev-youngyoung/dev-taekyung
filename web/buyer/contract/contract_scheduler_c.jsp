<%@page import="nicelib.groupware.KUserList"%>
<%@page import="nicelib.groupware.SsoUserList"%>
<%@page import="nicelib.groupware.SellerList"%>
<%@page import="nicelib.groupware.SupplierList"%>
<%@ page contentType="text/html; charset=UTF-8" %>
<%

String type = request.getParameter("type");
System.out.println("======= BATCH START =======" + type);
if("sup".equals(type)){
	System.out.println("======= SUP =======");
	//공급처(구매시스템) 리스트 갱신
	SupplierList sup = new SupplierList();
	sup.updateSupplierInfoList();
}else if("sel".equals(type)){
	System.out.println("======= SEL =======");
	//판매처(영업시스템) 리스트 갱신
	SellerList selList = new SellerList();
	selList.updateSellerInfoList();
}else if("sso".equals(type)){
	System.out.println("======= SSO =======");
	//SSO 리스트 갱신
	SsoUserList ssoUserList = new SsoUserList();
	ssoUserList.updateSsoUserInfoList();
}else if("kinfo".equals(type)){
	//K_INFO 리스트 갱신
	KUserList kUserList = new KUserList();
	kUserList.updateKUserInfoList();
}
%>