<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String email_random = u.request("email_random");
String _member_no = "";
String _member_name = "";
String _person_seq = "";
String _user_name = "";


if(cont_no.equals("")||cont_chasu.equals("")||email_random.equals("")){
	u.jsErrClose("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject contDao = new DataObject("tcb_contmaster");
//contDao.setDebug(out);
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'  ","tcb_contmaster.*,(select member_name from tcb_member where member_no = mod_req_member_no) req_member_name");
if(!cont.next()){
	u.jsErrClose("��������� �����ϴ�.");
	return;
}

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and email_random = '"+email_random+"'");
if(!cust.next()){
	u.jsAlert("�������� ������ �����ϴ�.");
	return;
}
_member_no = cust.getString("member_no");
_person_seq = cust.getString("person_seq");
_member_name = cust.getString("member_name");
_user_name =  cust.getString("user_name");

String spliter = "\r\n-------------------------------------------------------\r\n";
	   spliter += cont.getString("req_member_name")+"("+u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date"))+")\r\n";
if(!cont.getString("mod_req_reason").equals(""))
	cont.put("mod_req_reason", spliter+cont.getString("mod_req_reason"));

f.addElement("mod_req_reason", cont.getString("mod_req_reason"), "hname:'����', required:'Y', maxbyte:'1000'");

if(u.isPost()&&f.validate()){
	String next_status = u.inArray(cont.getString("status"),new String[]{"21","30","40"})?"41":"40";
	DB db = new DB();
	ContractDao dao = new  ContractDao();
	//dao.setDebug(out);
	dao.item("mod_req_date", u.getTimeString());
	dao.item("mod_req_member_no", _member_no);
	dao.item("mod_req_reason", f.get("mod_req_reason"));
	dao.item("status", next_status);
	//dao.item("reg_date", u.getTimeString());
	//dao.item("reg_id", auth.getString("_USER_ID"));
	db.setCommand(dao.getUpdateQuery(" cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' "), dao.record);
	db.setCommand("update tcb_cust set sign_date=null, sign_dn=null,sign_data=null where cont_no='"+cont_no+"' and cont_chasu='"+cont_chasu+"' ", null);

	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  _member_no, _person_seq, _user_name, request.getRemoteAddr(), "���ڹ��� ������û",  "", next_status,"20");
	/* ���α� END*/

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}

	//SMS����
	SmsDao smsDao= new SmsDao();
	String sender_name = auth.getString("_MEMBER_NAME");
	custDao = new DataObject("tcb_cust");
	if(u.inArray(cont.getString("status"),new String[]{"20","41"})){//�ݷ� �Ǵ� �����û �����̸� ���� ��û�̴�.
		cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'");
		if(cust.next()){
				// sms ����
				smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), _member_name+" ���� ���ڰ�༭ ������û- ���̽���ť(�Ϲݱ����)");
		}
	}

	if(u.inArray(cont.getString("status"),new String[]{"21","30","40"})){//���� ��û�����̸� �ݷ��̴�.
		String where = "cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"'";
		if(!cont.getString("mod_req_member_no").equals("")) where+=" and member_no = '"+cont.getString("mod_req_member_no")+"'";
		cust = custDao.find(where);
		while(cust.next()){
				// sms ����
				if(!cust.getString("member_no").equals(_member_no)){
					smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), _member_name+" ���� ���ڰ�༭ �ݷ�- ���̽���ť(�Ϲݱ����)");
				}
		}
	}
	out.println("<script language=\"javascript\" >");
	out.println("opener.location.reload();");
	out.println("window.close();");
	out.println("</script>");
	return;
}

p.setLayout("popup_email_contract");
p.setDebug(out);
p.setVar("popup_title", "������û");
p.setBody("sdd.pop_modify_req");
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>