<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

DataObject fieldDao = new DataObject("tcb_field");
int maxFieldSeq = fieldDao.getOneInt("select nvl(max(field_seq),0) from tcb_field where member_no = '"+_member_no+"' ");

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.dept_info");
p.setVar("menu_cd","000111");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000111", "btn_auth").equals("10"));
p.setVar("member_no", _member_no);
p.setVar("maxFieldSeq", maxFieldSeq);
p.setVar("form_script", f.getScript());
p.display(out);
%> 