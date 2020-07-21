<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
int noti_cnt = 9;
DataObject boardDao = new DataObject("tcg_board");
boardDao.setDebug(out);
DataSet noti = boardDao.find("open_yn = 'Y' and open_date <= '"+u.getTimeString("yyyyMMdd")+"' ","*","open_date desc", noti_cnt);
while(noti.next()){
	noti.put("open_date", u.getTimeString("yyyy-MM-dd",noti.getString("open_date")));
}
p.setLayout("main");
p.setDebug(out);
p.setBody("main.test");
p.setLoop("noti", noti);
p.display(out);
%>