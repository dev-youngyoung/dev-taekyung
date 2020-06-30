<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file="init.jsp" %>
<%

DataObject menuDao = new DataObject("tcc_menu");

String max_menu_seq = menuDao.getOne("select nvl(max(to_number(menu_cd)),0) from tcc_menu");

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.menu_info");
p.setVar("menu_cd","000011");
p.setVar("max_menu_seq",max_menu_seq);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>