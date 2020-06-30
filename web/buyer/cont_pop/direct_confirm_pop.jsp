<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ include file="../contract/include_cont_push.jsp" %>
<%

String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");

String contstr = u.aseDec(key);  // ���ڵ�
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}
String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

String template_cd = u.request("template_cd");

String agree_seq = u.request("agree_seq");
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

contDao = new ContractDao();
contDao.item("status", "50");
db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

if(!agree_seq.equals("")) // ���� ���� ���μ����� �ִ� ���. ���� ����Ǿ����� ǥ��
{
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("ag_md_date", u.getTimeString());
	agreeDao.item("r_agree_person_id",auth.getString("_USER_ID"));
	agreeDao.item("r_agree_person_name", auth.getString("_USER_NAME"));
	db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
}

if(u.inArray(cont.getString("template_cd"), new String[]{"2015109"}))  // ����Ȯ�༭, �ø����Ʈ���� ���������û��(2016.4������ Ȯ�ξ��ϰ� �ٷ� ��ü �����ϸ� ����)
{
//	status = "50";  // ����Ϸ�
	int iPayAmount = 2000;
	int iVatAmount = iPayAmount/10;
	iPayAmount = iPayAmount+iVatAmount;

	db.setCommand("delete from tcb_pay where cont_no = '"+cont_no+"' and cont_chasu="+cont_chasu, null);

	//tcb_pay insert
	DataObject payDao = new DataObject("tcb_pay");
	payDao.item("cont_no", cont_no);
	payDao.item("cont_chasu", cont_chasu);
	payDao.item("member_no", _member_no);
	payDao.item("cont_name", cont.getString("cont_name")+"(�볳)");
	payDao.item("pay_amount", iPayAmount);
	payDao.item("pay_type", "05");
	payDao.item("accept_date", u.getTimeString());
	payDao.item("receit_type","0");
	db.setCommand(payDao.getInsertQuery(), payDao.record);

	//tcb_cust update
	DataObject custPayDao = new DataObject("tcb_cust");
	custPayDao.item("pay_yn", "Y");
	db.setCommand(custPayDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+_member_no+"' "),custPayDao.record);
}


/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� �Ϸ�",  "", "50", "10");
/* ���α� END*/

if(!db.executeArray()){
	u.jsError("�Ϸ� ó���� ���� �Ͽ����ϴ�.");
	return;
}

//��༭ push
if(u.inArray(cont.getString("member_no"), new String[]{"20171101813","20130500457"})) {  //SK�����, �������̺�ε����� ���
	DataSet result = contPush_skstoa(cont_no, cont_chasu);//���Ϸ� push
	if(!result.getString("succ_yn").equals("Y")){
		u.sp(" skstore ������� ���� ����!!!\npage:direct_confirm_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
		u.mail("nicedocu@nicednr.co.kr","skstore ������� ���� ����!!! ", " skstore ������� ���� ����!!!\npage:direct_confirm_pop.jsp\ncont_no: "+cont_no+"-"+ cont_chasu);
	}
}

u.jsErrClose("����� �Ϸ� �Ǿ����ϴ�.\\n\\n�Ϸ�� ������ ���Ϸ�>�Ϸ�Ȱ�࿡�� Ȯ�� �Ͻ� �� �ֽ��ϴ�.");
return;
%>