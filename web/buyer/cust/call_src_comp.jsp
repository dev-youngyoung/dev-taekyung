<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
DataObject clientDao = new DataObject("tcb_client");

int	iMapCnt	=	clientDao.getOneInt(
		 "select count(*)                      "
		+" from (                              "
		+"	select distinct src_member_no      "
		+"	  from tcb_src_member              "
		+"	 where member_no = '"+_member_no+"'" 
		+"	)                                  "
		);	//	Çù·Â¾÷Ã¼¼ö

out.println(iMapCnt);
%>