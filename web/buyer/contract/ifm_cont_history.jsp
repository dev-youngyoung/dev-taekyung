<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%
String cont_no = u.aseDec(u.request("cont_no"));
if(cont_no.equals("")){
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_status = code.getCodeArray("M008");

DataObject contDao = new DataObject("tcb_contmaster");
DataSet list = contDao.find("member_no = '"+_member_no+"' and cont_no = '"+cont_no+"' and status <> '00' ", "*" , "cont_chasu asc");

while(list.next()){
	list.put("cont_chasu_nm", "0".equals(list.getString("cont_chasu")) ? "최초" : list.getString("cont_chasu"));
	list.put("cont_date", u.getTimeString("yyyy-MM-dd", list.getString("cont_date")));
	list.put("cont_status_nm", u.getItem(list.getString("status"), code_status));
	
	String link = "";
	if(list.getString("sign_types").equals("")){//일반적인 계약
		if(!list.getString("template_cd").equals("")) {
			if (list.getString("status").equals("10")) {
				link = "contract_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu") + "&template_cd=" + list.getString("template_cd");
			} else if (u.inArray(list.getString("status"), new String[]{"11", "12", "20", "21", "30", "40", "41"})) {
				link = "contract_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu");
			} else if (list.getString("status").equals("50")) {
				link = "contend_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu");
			}
		}else{
			if (list.getString("status").equals("10")) {
				link = "contract_free_modify.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu") + "&template_cd=" + list.getString("template_cd");
			} else if (u.inArray(list.getString("status"), new String[]{"11", "12", "20", "21", "30", "40", "41"})) {
				link = "contract_free_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu");
			} else if (list.getString("status").equals("50")) {
				link = "contend_free_sendview.jsp?cont_no=" + u.aseEnc(cont_no) + "&cont_chasu=" + list.getString("cont_chasu");
			}
		}
	}else{//패드 서명 계약
		if(list.getString("status").equals("10")){
			link = "contract_msign_modify.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+list.getString("cont_chasu")+"&template_cd="+list.getString("template_cd");
		}else if(u.inArray(list.getString("status"), new String[]{"11","12","20","21","30","40","41"})){
			link = "contract_msign_sendview.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+list.getString("cont_chasu");
		}else if(list.getString("status").equals("50")){
			link = "contend_msign_sendview.jsp?cont_no="+u.aseEnc(cont_no)+"&cont_chasu="+list.getString("cont_chasu");
		}
	}
	list.put("link", link);
}

p.setLayout("blank");
p.setDebug(out);
p.setBody("contract.ifm_cont_history");
p.setLoop("list", list);
p.setVar("query",u.getQueryString());
p.setVar("list_query",u.getQueryString("cont_chasu,template_cd,page"));
p.display(out);

%>