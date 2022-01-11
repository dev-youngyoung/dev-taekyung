<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
DataObject clientDao = new DataObject("tcb_client");

int	iMapCnt	=	clientDao.getOneInt(
		 "select count(*)                      "
		+" from (                              "
		+"	select distinct src_member_no      "
		+"	  from tcb_src_member              "
		+"	 where member_no = '"+_member_no+"'" 
		+"	)                                  "
		);	//	협력업체수

out.println(iMapCnt);
%>