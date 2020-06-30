<%@ page contentType="text/html; charset=EUC-KR"%><%@ include file="init.jsp" %>
<%@ page import="
				 kr.co.nicepay.module.lite.NicePayWebConnector,
				 nicelib.util.*
                 " %>
<%
request.setCharacterEncoding("euc-kr");

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String insteadyn = u.request("insteadyn");
String member_no = u.request("member_no");
if(cont_no.equals("")||cont_chasu.equals("")||insteadyn.equals("")||member_no.equals("")){
	u.jsErrClose("�������� ��η� �����ϼ���.");
	return;
}

if(!_member_no.equals(member_no)){
	u.jsErrClose("�α��λ���ڰ� ���� �Ǿ����ϴ�.\\n\\n������ �ٽ� ���� �ϼ���.");
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu= '"+cont_chasu+"' ";

//������� Ȯ�� 
ContractDao contDao = new ContractDao("tcb_contmaster");
DataSet cont = contDao.find(where);
if(!cont.next()){
	u.jsAlert("��������� �����ϴ�");
	return;
}

////////////////////////////���� ��� ����///////////////////////////////////////////////

String nicePayHome = "/user2/tax/WEB-INF";
//String nicePayHome = "D:/nicedata_git/git-repository/nicedocu/WEB-INF";

NicePayWebConnector connector = new NicePayWebConnector();

// 1. �α� ���丮 ����
connector.setNicePayHome(nicePayHome);

// 2. ��û ������ �Ķ���� ����
connector.setRequestData(request);

// 3. �߰� �Ķ���� ����
connector.addRequestData("MID", "docu00002m");	// �������̵�
connector.addRequestData("actionType", "PY0");  // actionType : CL0 ���, PY0 ����
connector.addRequestData("MallIP", request.getRemoteAddr());	// ���� ���� ip
connector.addRequestData("CancelPwd", "0140");


// 4. NICEPAY Lite ���� �����Ͽ� ó��
connector.requestAction();

// 5. ��� ó��
String resultCode = connector.getResultData("ResultCode");	// ����ڵ� (���� :3001 , �� �� ����)
String resultMsg = connector.getResultData("ResultMsg");	// ����޽���
String authDate = connector.getResultData("AuthDate");		// �����Ͻ� YYMMDDHH24mmss
String authCode = connector.getResultData("AuthCode");		// ���ι�ȣ
String buyerName = connector.getResultData("BuyerName");	// �����ڸ�
String mallUserID = connector.getResultData("MallUserID");	// ȸ�����ID
String payMethod = connector.getResultData("PayMethod");	// ��������  ('CARD':�ſ�ī��, 'BANK':������ü)
String mid = connector.getResultData("MID");				// ����ID
String tid = connector.getResultData("TID");				// �ŷ�ID
String moid = connector.getResultData("Moid");				// �ֹ���ȣ
String amt = connector.getResultData("Amt");				// �ݾ�

// ī�� ����
String cardCode = connector.getResultData("CardCode");		// ī��� �ڵ�
String cardName = connector.getResultData("CardName");		// ����ī����
String cardQuota = connector.getResultData("CardQuota");	//00:�Ͻú�,02:2����

// �ǽð� ������ü
String bankCode = connector.getResultData("BankCode");		// ���� �ڵ�
String bankName = connector.getResultData("BankName");		// �����
String rcptType = connector.getResultData("RcptType");		// ���� ������ Ÿ�� (0:�����������,1:�ҵ����,2:��������)
String rcptAuthCode = connector.getResultData("RcptAuthCode");	//���ݿ����� ���� ��ȣ
String rcptTID = connector.getResultData("RcptTID");		//���� ������ TID

// �޴��� ����
String carrier = connector.getResultData("Carrier");		// ����籸��
String dstAddr = connector.getResultData("DstAddr");		// �޴�����ȣ

// ������� ����
String vbankBankCode = connector.getResultData("VbankBankCode");	// ������������ڵ�
String vbankBankName = connector.getResultData("VbankBankName");	// ������������
String vbankNum = connector.getResultData("VbankNum");				// ������¹�ȣ
String vbankExpDate = connector.getResultData("VbankExpDate");		// ��������Աݿ�����


boolean paySuccess = false;		// ���� ���� ����

/** ���� ���� ������ �ܿ��� ���� Header�� ������ ������ Get ���� */
if(payMethod.equals("CARD"))	//�ſ�ī��
{
	if(resultCode.equals("3001")) paySuccess = true;	// ����ڵ� (���� :3001 , �� �� ����)
}
else if(payMethod.equals("BANK"))	//������ü
{
	if(resultCode.equals("4000")) paySuccess = true;	// ����ڵ� (���� :4000 , �� �� ����)
}
else if(payMethod.equals("CELLPHONE"))	//�޴���
{
	if(resultCode.equals("A000")) paySuccess = true;	//����ڵ� (���� : A000, �� �� ������)
}
else if(payMethod.equals("VBANK"))	//�������
{
	if(resultCode.equals("4100")) paySuccess = true;	// ����ڵ� (���� :4100 , �� �� ����)
}

//-------------------------  ���⼭���� DB ������ ���� �κ� ---------------------------------

if(!paySuccess){
	u.jsErrClose(resultMsg);
	return;
}

String pay_type = "";  // ���� Ÿ�� �ڵ�

if(payMethod.equals("CARD"))
	pay_type = "01";
else if(payMethod.equals("BANK"))
	pay_type = "02";


DB db = new DB();
//���� ���� �÷�  update
DataObject custDao = new DataObject("tcb_cust");
custDao.item("pay_yn", "Y");
db.setCommand(custDao.getUpdateQuery(where+" and member_no = '"+_member_no+"' "), custDao.record);

//tcb_pay Data�Է�
DataObject payDao = new DataObject("tcb_pay");
payDao.item("cont_no",cont_no);
payDao.item("cont_chasu",cont_chasu);
payDao.item("member_no",_member_no);
if(insteadyn.equals("Y")){
	payDao.item("cont_name","(�볳����)"+cont.getString("cont_name"));
}else{
	payDao.item("cont_name",cont.getString("cont_name"));
}
payDao.item("pay_amount",amt);
payDao.item("pay_type",pay_type);
payDao.item("accept_date","20"+authDate);
payDao.item("pay_number",moid);
if(!rcptTID.equals("")){
	payDao.item("tid",rcptTID);
}else{
	payDao.item("tid",tid);
}
payDao.item("receit_type",rcptType);
db.setCommand(payDao.getInsertQuery(), payDao.record);

if(!db.executeArray()){
	u.jsErrClose("DB �۾��߿� ������ �߻��Ͽ����ϴ�. \\n\\n���̽���ť ������(02-788-9097)�� �����ϼ���.");
	return;
}

out.println("<script>");
out.println("alert('�����Ǿ����ϴ�.\\n\\n��༭�� ������ �ּ���.');");
out.println("opener.focus();");
out.println("opener.fSign();");
out.println("self.close();");
out.println("</script>");
%>