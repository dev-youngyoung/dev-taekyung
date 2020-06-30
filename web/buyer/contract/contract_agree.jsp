<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = "+_member_no+" ");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}
if(!cont.getString("status").equals("10")){// �ۼ��߸� ���� ����
	u.jsError("������ �ۼ��� ���¿����� �����û ���� �մϴ�.");
	return;
}

DB db = new DB();
//db.setDebug(out);

// ��ü ������ ���� ��������� ����
contDao.item("mod_req_date","");
contDao.item("mod_req_reason","");
contDao.item("mod_req_member_no","");
contDao.item("reg_date", u.getTimeString());
contDao.item("status","11");  // ���� ���� ��
db.setCommand( contDao.getUpdateQuery(where), contDao.record);

DataObject agreeDao = new DataObject("tcb_cont_agree");
agreeDao.item("r_agree_person_id","");
agreeDao.item("r_agree_person_name","");
agreeDao.item("ag_md_date","");
agreeDao.item("mod_reason","");
db.setCommand(agreeDao.getUpdateQuery(where),agreeDao.record);

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "�����û",  "", "11","20");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("�����û�� ���� �Ͽ����ϴ�.");
	return;
}

//DataSet agree = agreeDao.find(where+" and length(r_agree_person_id)=0 and agree_cd='1' and length(agree_person_id) > 0"); // ��Ʈ�� ������ �����ڰ� �ְ� �� �����ڰ� �μ��� �ƴ� 1���� ��� ó�� �����ڿ��� ���� ���� ����
DataSet agree = agreeDao.find(where+" and r_agree_person_id is null and agree_cd='1' and agree_person_id is not null"); // ����Ŭ ���� ������ ���Ͽ� query ���� skl 20161205

if(agree.next())
{
	// �̸��� �˸�.
	String to_member_name = ""; // ����ü��
	String to_email = "";		// ������ �̸���

	DataObject custDao = new DataObject("tcb_cust");
	DataSet dsCust = custDao.find("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq=2");	// ��ü����
	while(dsCust.next())
		to_member_name = dsCust.getString("member_name");

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// ������ ����
	if(dsPerson.next()){
		
		to_email = dsPerson.getString("email");

		//System.out.println("to_member_name : " + to_member_name);
		//System.out.println("to_email : " + to_email);

		p.clear();
		p.setVar("from_user_name", auth.getString("_MEMBER_NAME"));
		p.setVar("cust_name", to_member_name);
		p.setVar("cont_name", cont.getString("cont_name"));
		p.setVar("server_name", request.getServerName());
		p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
		p.setVar("img_url", webUrl+"/images/email/20110620/");
		p.setVar("ret_url", webUrl+"/web/buyer/");
		u.mail(to_email, "[��� ���� �˸�] \"" +  cont.getString("cont_name") + "\" ��� ���並 ��û�Ͽ����ϴ�.", p.fetch("mail/cont_agree_req.html"));
		
		SmsDao smsDao= new SmsDao();
		smsDao.sendSMS("buyer", dsPerson.getString("hp1"), dsPerson.getString("hp2"), dsPerson.getString("hp3"), auth.getString("_USER_NAME")+"���� ��� ���並 ��û�Ͽ����ϴ�. - ���̽���ť(�Ϲݱ����)");
	}

}

u.jsAlertReplace("��༭�� ����ڿ��� �����û �Ͽ����ϴ�.\\n\\n�������ΰ�� ��Ͽ��� ������ ������ Ȯ�� �� �� �ֽ��ϴ�."
,"contract_writing_list.jsp?"+u.getQueryString("cont_no, cont_chasu"));
%>