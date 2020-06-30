<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="include_cont_push.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu","0");
String agree_seq = u.request("agree_seq");
int prev_seq = Integer.parseInt(agree_seq)-1;
if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")){
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


DB db = new DB();

// ���� ���� ���
DataObject agreeDao = new DataObject("tcb_cont_agree");
agreeDao.item("ag_md_date", "");
agreeDao.item("r_agree_person_id", "");
agreeDao.item("r_agree_person_name", "");
db.setCommand(agreeDao.getUpdateQuery(where + " and agree_seq="+prev_seq), agreeDao.record);

int nagreeCnt = agreeDao.findCount(where +" and agree_cd='2' and agree_seq="+agree_seq);  // ��ü ���� �� ���� ����� ��� ���δ��� ����
if(nagreeCnt==1)
{
	contDao.item("status", "21");  // ���δ��
	db.setCommand(contDao.getUpdateQuery(where), contDao.record);
}

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "�������",  "", nagreeCnt==1?"21":cont.getString("status"),"20");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("���� ��ҿ� ���� �Ͽ����ϴ�.");
	return;
}

DataSet agree = agreeDao.find(where +" and agree_seq = " + agree_seq, "*", "agree_seq", 1); // ���� �����ڿ��� ��� �˸�
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
		u.mail(to_email, "[���� ��� �˸�] \"" +  cont.getString("cont_name") + "\" ��� ������ ��� �Ͽ����ϴ�.", p.fetch("mail/cont_agree_cancel.html"));
	}

}

//��༭ push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore ������� ���� ����!!!\npage:contract_agree_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:contract_agree_cancel.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsAlertReplace("���� ��� �Ͽ����ϴ�.\\n\\n�������ΰ�� ��Ͽ��� ������ Ȯ�� �� �� �ֽ��ϴ�.","contract_send_list.jsp?"+u.getQueryString("cont_no, cont_chasu, agree_seq"));

%>