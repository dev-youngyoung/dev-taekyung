<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
//�޸��� �ڵ��� ���� ������� �ݷ� ó�� �˸� �߼��� ��༭ ���� ���� ȸ�� ���� ���� ó��
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";
DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" and template_cd= '2019269' and status = '30'");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

DataObject payDao = new DataObject("tcb_pay");
DataSet pay = payDao.find(where);
if(pay.next()){
	u.jsError("�ش� �������� ����� ���系���� �ֽ��ϴ�.\\n\\n������ ���� �� �� �����ϴ�.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where+" and sign_seq = '2' ");
if(!cust.next()){
	u.jsError("�ŷ�ó ������ �����ϴ�.");
	return;
}

String subject = "[���̽���ť]"+auth.getString("_MEMBER_NAME")+" �ȳ�";
String longMessage = "�޸���ĳ��Ż ����(�ǸŻ��) ���������� �Ұ����� �˷��帳�ϴ�.\n���λ����� ���� ����(�����)�� ���� ��Ź�帳�ϴ�.\n�����մϴ�.\n-���̽���ť";
SmsDao smsDao = new SmsDao();
smsDao.sendLMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), subject, longMessage);

//�������� ���� ó��
int chk_cnt = custDao.findCount("member_no = '"+cust.getString("member_no")+"' and cont_no <> '"+cont.getString("cont_no")+"'  ");


//������ ó�� ����
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(where+" and cfile_seq=1");
if(cfile.next()){
	if(!Startup.conf.getString("file.path.bcont_pdf").equals("") && !cfile.getString("file_path").equals("") && !cfile.getString("file_name").equals(""))
	{
		//System.out.println("DELETE FILE : " + Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
		//u.delFile(Startup.conf.getString("file.path.bcont_pdf")+cfile.getString("file_path")+cfile.getString("file_name"));
	}
}

DataObject shareDao = new DataObject("tcb_share");
DataObject custSignImgDao = new DataObject("tcb_cust_sign_img");
DataObject contSubDao = new DataObject("tcb_cont_sub");
DataObject efileDao = new DataObject("tcb_efile");
DataObject rfileCustDao = new DataObject("tcb_rfile_cust");
DataObject rfileDao = new DataObject("tcb_rfile");
cfileDao = new DataObject("tcb_cfile");
DataObject StampDao = new DataObject("tcb_stamp");
DataObject warrDao = new DataObject("tcb_warr");
DataObject emailDao = new DataObject("tcb_cont_email");
custDao = new DataObject("tcb_cust");
DataObject contSignDao = new DataObject("tcb_cont_sign");
DataObject contAgreeDao = new DataObject("tcb_cont_agree");
DataObject contAddDao = new DataObject("tcb_cont_add");
DataObject contLogDao = new DataObject("tcb_cont_log");
contDao = new DataObject("tcb_contmaster");

DB db = new DB(); 
contDao.item("status", "00");
contDao.item("reg_date",   u.getTimeString()); 
db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"'"), contDao.record); // APP �������� ���� APP�ʿ��� �����ڵ尡 �ʿ��Ͽ� ����-> ���°� �������� ����

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ����",  "", "00", "20");
/* ���α� END*/
 
//db.setDebug(out); 
if(!db.executeArray()){
	u.jsError("���ް��� ó���� ���� �Ͽ����ϴ�. ");
	return;
}  

u.jsAlertReplace("���� ó�� �Ͽ����ϴ�.","contract_send_list.jsp?"+u.getQueryString("cont_no,cont_chasu,template_cd"));

%>