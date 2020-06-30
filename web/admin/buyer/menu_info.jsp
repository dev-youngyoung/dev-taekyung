<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

DataObject menuDao = new DataObject("tcb_menu");

int max_menu_seq = menuDao.getOneInt("select nvl(max(to_number(menu_cd)),0) from tcb_menu  ");


p.setLayout("default");
p.setDebug(out);
p.setBody("buyer.menu_info");
//p.setLoop("dept", dept);
p.setVar("menu_cd","000056");
p.setVar("max_menu_seq", max_menu_seq);
p.setVar("form_script", f.getScript());
p.display(out);
%> 