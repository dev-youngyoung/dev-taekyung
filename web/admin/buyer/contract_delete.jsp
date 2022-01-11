<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

DataObject shareDao = new DataObject("tcb_share");
DataObject custSignImgDao = new DataObject("tcb_cust_sign_img");
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataObject efileDao = new DataObject("tcb_efile");
DataObject rfileCustDao = new DataObject("tcb_rfile_cust");	// 업체구비서류
DataObject rfileDao = new DataObject("tcb_rfile");			// 구비서류
DataObject cfileDao = new DataObject("tcb_cfile");			// 계약서류
DataObject emailDao = new DataObject("tcb_cont_email");		// 이메일
DataObject stampDao = new DataObject("tcb_stamp");			// 인지세
DataObject warrDao = new DataObject("tcb_warr");			// 보증서정보
DataObject custDao = new DataObject("tcb_cust");			// 계약업체
DataObject contSignDao = new DataObject("tcb_cont_sign");	// 서명양식
DataObject payDao = new DataObject("tcb_pay");				// 결제정보
DataObject agreeDao = new DataObject("tcb_cont_agree");		// 내부결제
DataObject contAddDao = new DataObject("tcb_cont_add");		// 추가정보
DataObject contLogDao = new DataObject("tcb_cont_log");		// 로그

DataSet cfile = cfileDao.find(where);
while(cfile.next()){
	if(!Startup.conf.getString("file.path.bcont_pdf").equals("") && !cfile.getString("file_path").equals("") && !cfile.getString("file_name").equals(""))
	{
		System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
		u.delFile(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
	}
}	


DB db = new DB();
//db.setDebug(out);

// PB입사지원 계약서 
if("2019112".equals(cont.getString("template_cd"))){
	DataObject applyPersonDao = new DataObject("tcb_apply_person");
	applyPersonDao.item(" status ", "40");
	applyPersonDao.item(" cont_no ", "");
	db.setCommand(applyPersonDao.getUpdateQuery(" cont_no = '"+cont_no+"'"), applyPersonDao.record);
}

db.setCommand(shareDao.getDeleteQuery(where) ,null);
db.setCommand(custSignImgDao.getDeleteQuery(where) ,null);
db.setCommand(contSubDao.getDeleteQuery(where),null);
db.setCommand(efileDao.getDeleteQuery(where),null);
db.setCommand(rfileCustDao.getDeleteQuery(where),null);
db.setCommand(rfileDao.getDeleteQuery(where),null);
db.setCommand(cfileDao.getDeleteQuery(where),null);
db.setCommand(emailDao.getDeleteQuery(where),null);
db.setCommand(stampDao.getDeleteQuery(where),null);
db.setCommand(warrDao.getDeleteQuery(where),null);
db.setCommand(custDao.getDeleteQuery(where),null);
db.setCommand(contSignDao.getDeleteQuery(where),null);
db.setCommand(payDao.getDeleteQuery(where),null);
db.setCommand(agreeDao.getDeleteQuery(where),null);
db.setCommand(contAddDao.getDeleteQuery(where),null);
db.setCommand(contLogDao.getDeleteQuery(where),null);
db.setCommand(contDao.getDeleteQuery(where),null);
if(!db.executeArray()){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}

if(!db.executeArray()){
	u.jsError("삭제처리에 실패 하였습니다.");
	return;
}
u.jsAlertReplace("삭제 처리 하였습니다.","contract_list.jsp?"+u.getQueryString("cont_no,cont_chasu"));
return;
%>