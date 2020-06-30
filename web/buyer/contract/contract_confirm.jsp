<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String agree_seq = u.request("agree_seq");
if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
	u.jsError("�������� ��η� �����Ͽ� �ֽʽÿ�.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = '"+_member_no+"' ");
if(!cont.next()){
	u.jsError("������ ���� ���� �ʽ��ϴ�.");
	return;
}

if(!u.inArray(cont.getString("status"), new String[]{"11","21"})){
	u.jsError("���� ���� ���� ���¿����� ������ ���� �մϴ�.");
	return;
}


DB db = new DB();

// ��ü ������ ���� ��������� Ȯ��
DataObject agreeDao = new DataObject("tcb_cont_agree");


int nagreeCnt = agreeDao.findCount(where +" and agree_cd = '2' and (length(trim(r_agree_person_id))=0 or r_agree_person_id is null)");  // ��ü ���� �� �����ڵ� ��
if(nagreeCnt==2) // ������ 1�� ���� ��� (2�� üũ�ϴ� ������ ���� ���ΰ��� DB�� ���� ������Ʈ ���̶� ��)
{
	contDao.item("mod_req_date","");
	contDao.item("mod_req_member_no","");
	contDao.item("mod_req_reason","");
	contDao.item("status", "30");  // ������
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}

agreeDao.item("ag_md_date", u.getTimeString());
agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
db.setCommand(agreeDao.getUpdateQuery(where + " and agree_seq="+agree_seq), agreeDao.record);

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���� ����",  "", nagreeCnt==2?"30":cont.getString("status"), "20");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("���ο� ���� �Ͽ����ϴ�.");
	return;
}


DataSet agree = agreeDao.find(where +" and (length(trim(r_agree_person_id))=0 or r_agree_person_id is null) and length(trim(agree_person_id)) > 0", "*", "agree_seq", 1); // �����ڰ� �ְ� �� �����ڰ� �μ��� �ƴ� 1���� ��� ���� �����ڿ��� ���� ����

if(agree.next())
{
	// �̸��� �˸�.
	String cust_name = ""; // ����ü��
	String to_email = "";		// ������ �̸���

	DataObject custDao = new DataObject("tcb_cust");
	DataSet dsCust = custDao.find(where +" and sign_seq=2");	// ��ü����
	while(dsCust.next())
		cust_name = dsCust.getString("member_name");

	DataObject personDao = new DataObject("tcb_person");
	DataSet dsPerson = personDao.find("user_id='"+agree.getString("agree_person_id")+"'");	// ������ ����
	if(dsPerson.next())
	{
		if(!dsPerson.getString("user_id").equals("mns1135005")){// ktm&s ���� ����� �����δ� �˸� ����  �ϰ���� ������ ����_20141112
			to_email = dsPerson.getString("email");
	
			System.out.println("cust_name : " + cust_name);
			System.out.println("to_email : " + to_email);
			System.out.println("to_name : " + dsPerson.getString("user_name"));
	
			p.clear();
			p.setVar("from_user_name", auth.getString("_USER_NAME"));
			p.setVar("cust_name", cust_name);
			p.setVar("cont_name", cont.getString("cont_name"));
			p.setVar("cont_day", u.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
			p.setVar("img_url", webUrl+"/images/email/20110620/");
			p.setVar("ret_url", webUrl+"/web/buyer/");
			u.mail(to_email, "[��� ���� �˸�] \"" +  cont.getString("cont_name") + "\" ��� ���並 ��û�Ͽ����ϴ�.", p.fetch("mail/cont_agree_req.html"));
	
			SmsDao smsDao= new SmsDao();
			if(!_member_no.equals("20150500312")) // ���������� ����(���ڰ� �ʹ� ���� �´���)
			{
				smsDao.sendSMS("buyer", dsPerson.getString("hp1"), dsPerson.getString("hp2"), dsPerson.getString("hp3"), auth.getString("_USER_NAME")+"���� "+cust_name+" ��� ���� ��û. - ���̽���ť(�Ϲݱ����)");
			}
		}
	}

}

//��༭ push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore ������� ���� ����!!!\npage:contract_confirm.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:contract_confirm.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}


u.jsAlertReplace("��༭�� ���� �Ͽ����ϴ�.\\n\\n�������ΰ�� ��Ͽ��� ������ ������ Ȯ�� �� �� �ֽ��ϴ�.","contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));

%>