<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
DataSet ds = new DataSet();
ds.addRow();
ds.put("member_no", _member_no);

DataObject doTSM = new DataObject("tcb_src_member");
int iClientCnt	=	doTSM.getOneInt("select count(*) icnt \n"+
		"  from tcb_member a \n"+
		" 			,(select distinct client_no \n"+
		"						from tcb_client \n"+
		" 				 where member_no = '"+_member_no+"' and (client_reg_cd = '1' or client_reg_cd is null)) b \n"+
		" where a.member_no = b.client_no \n"+
		"   and a.member_type in ('02','03')");	//	협력업체수

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.src_comp_list");
p.setVar("menu_cd","000093");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000093", "btn_auth").equals("10"));
p.setVar("client_cnt", iClientCnt);
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.setVar(ds);
p.display(out);
%>