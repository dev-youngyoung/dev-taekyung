<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String next_page = u.request("next_page");

u.sp("--�ڵ����� ȣ��  contract_auto_sign.jsp ����ȣ: "+cont_no);

String default_url = "contract_recvview.jsp?"+u.getQueryString();
if(!next_page.equals("")){
	next_page = new String(Base64Coder.decode(next_page),"UTF-8");
}else{
	next_page = default_url;
}

if(cont_no.equals("")||cont_chasu.equals("")){
	//u.jsError("�������� ��η� ���� �ϼ���.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

String where = " cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ";

DataObject contDao = new DataObject("tcb_contmaster");
DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	//u.jsError("��������� �����ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

if(!cont.getString("status").equals("30")){
	//u.jsError("��༭ �����̻����� �ڵ� ���� �� �� �����ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

boolean member_check = false;
String gap_pay_yn = "";

String _member_no = auth.getString("_MEMBER_NO")==null?"":auth.getString("_MEMBER_NO");
if(_member_no.equals(""))member_check = true;

DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(where);
while(cust.next()){
	if(cust.getString("member_no").equals(cont.getString("member_no"))){
		gap_pay_yn = cust.getString("pay_yn");
		if(!cust.getString("sign_date").equals("")){
			//u.jsError("�̹̼���� �����Դϴ�.");
			u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
			return;
		}
	}
	if(cust.getString("member_no").equals(_member_no) && !member_check){
		member_check = true;
	}
}
if(!member_check){
	//u.jsError("�ش���ǿ� ���� ������ �����ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", "contract_recvview.jsp?"+u.getQueryString());
	return;
}

String gap_sign_date = custDao.getOne("select max(sign_date) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_date is not null") ;//����ö ����� ��û���� �ڵ�����ð��� �ŷ�ó ���Ѽ����Ͻ�+ 30��
gap_sign_date = u.addDate("S", 30, u.strToDate(gap_sign_date), "yyyyMMddHHmmss");


String[] agree_template_cds = {
			 "20130500619|2016107"// ������ ������� ��༭ >������������
			,"20130500619|2019067"// ������ ������� ��༭(Ư������) > ������������ 2016107=>2019067 �� �����
			,"20130500619|2019189"// ������ ������� ��༭(Ư������) > ������������ 2016107=>2019067=>2019189 �� �����
			
			,"20170501348|2018241"// �ƿ�Ȩ ���� ���ް�༭ >�е弭��
			,"20170501348|2018242"// �ƿ�Ȩ ���� ���ް�༭ >������������
			,"20170501348|2019047" // �ƿ�Ȩ �ٷΰ�༭(�����) > �е弭��
			,"20170501348|2019048" // �ƿ�Ȩ �ٷΰ�༭_������ > �е弭��
			,"20170501348|2019049" // �ƿ�Ȩ �ٷΰ�༭_������ > �е弭��
			,"20170501348|2019060" // �ƿ�Ȩ �ٷΰ�༭_������(����) > �е弭��
			,"20170501348|2019061" // �ƿ�Ȩ �ٷΰ�༭_������(����) > �е弭��
			,"20170501348|2019062" // �ƿ�Ȩ �ٷΰ�༭_�ϱ���(����) > �е弭��
			,"20170501348|2019063" // �ƿ�Ȩ �ٷΰ�༭_�ϱ��� > �е弭��
			,"20170501348|2019064" // �ƿ�Ȩ �ٷΰ�༭_��Ʈ(����) > �е弭��
			,"20170501348|2019065" // �ƿ�Ȩ �ٷΰ�༭_��Ʈ > �е弭��
			
			,"20181002679|2019058"// �����ũ����ũ> �ٷΰ�༭(�Ϲ���) >�е弭��
			,"20181002679|2019059"// �����ũ����ũ> ������༭ >�е弭��
			,"20181002679|2019074"// �����ũ����ũ> �ٷΰ�༭(�����) >�е弭��
			
			,"20150500312|2015037"// (��)����������>������༭(���� ����) > ������������
			,"20150500312|2015038"// (��)����������>��ǰ�Ǹ�(����)��༭ - �񿬵� ��༭ >������������
			,"20150500312|2018211"// (��)����������>��ǰ�Ǹ�(����)��༭(��ü��) >������������
			,"20150500312|2019209"// (��)����������>��ǰ�Ǹ�(����)��༭(��ü��) >������������
			,"20150500312|2018211"// (��)����������>��ǰ�Ǹ�(����)��༭>������������
			,"20150500312|2018212"// (��)����������>��ǰ�Ǹ�(ȥ��)��༭>������������
			,"20150500312|2018213"// (��)����������>����(����)��༭>������������
			
			,"20151100446|2019028"// ���̽���ؾ�> �������ް�༭ >�е弭��
			
			,"20171101813|2019015" //PGM)SK����� ������ ��༭[DB�Ǻ�]
			,"20171101813|2019016" //PGM)SK����� ������ ��༭[���׹��]
			,"20171101813|2019017" //PGM)SK����� �ǸŰ�༭[ȥ�ռ�����]
			,"20171101813|2019018" //PGM)SK����� �ǸŰ�༭[����Ź������]
			,"20171101813|2020192" //PGM)SK����� �ǸŹ�۰�༭[Ư��ȥ�ո���]
					
			,"20190101731|2020053" //Ʈ����� �ֽ�ȸ�� �ٷΰ�༭_3õ�ʰ�
			,"20190101731|2020124" //Ʈ����� �ֽ�ȸ�� �ٷΰ�༭_3õ����
			,"20190101731|2020054" //Ʈ����� �ֽ�ȸ�� ������༭
			
			,"20180100028|2019112" // PBP��Ʈ���� �ٷΰ�༭  
			,"20180100028|2020150" // PBP��Ʈ���� 2020��_���ް�༭_�ű�����
			,"20180100028|2020151" // PBP��Ʈ���� 2020��_���ް�༭_��������
			,"20180100028|2020152" // PBP��Ʈ���� 2020��_���ް�༭_�ű�ī��
			,"20180100028|2020153" // PBP��Ʈ���� 2020��_���ް�༭_����ī��
			,"20180100028|2020154" // PBP��Ʈ���� 2020��_������������������
			
		};

String[] server_cert_passwd = {
	     "20130500619=>wonder#001"//������
		,"20170501348=>ourhome7&&"//�ƿ�Ȩ
		,"20151100446=>nicednr1!@#"//���̽���ؾ�
		,"20181002679=>rudrltp_3010"//�����ũ����ũ
		,"20150500312=>bs220505^^"//(��)����������
		,"20171101813=>skstoa2018!"// SK�����
		,"20190101731=>5dnjf7dlf@" // Ʈ����� �ֽ�ȸ��  
		,"20180100028=>*adel0618*" //PBP��Ʈ����
	 };

if(!u.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), agree_template_cds)){
	//u.jsError("�ڵ����� �������� �ƴմϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

Crosscert crosscert = new Crosscert();
DataSet signInfo = crosscert.serverSign(cont.getString("member_no"), u.getItem(cont.getString("member_no"), server_cert_passwd), cont.getString("cont_hash"));

if(!signInfo.getString("err").equals("")){
	//u.jsError("��༭ ���� �����Ͽ����ϴ�.\\n\\n�����ͷ� ���� �ϼ���.\\n\\n("+signInfo.getString("err")+")");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

String sign_dn = signInfo.getString("signDn");
String sign_data = signInfo.getString("signData");
if(sign_dn.equals("")||sign_data.equals("")){
	//u.jsError("���ڼ��� �ʿ��� �����͸� ã�� �� �����ϴ�.\\n\\n�����ͷ� ���� �ٶ��ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}


if (crosscert.chkSignVerify(sign_data).equals("SIGN_ERROR")){
	//u.jsError("�ڵ����� ������ ���� �Ͽ����ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

if(!crosscert.getDn().equals(sign_dn)){
	//u.jsError("�ڵ���������� DN���� ���� ���� �ʽ��ϴ�.");
	u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
	return;
}

DB db = new DB();
//db.setDebug(out);
custDao = new DataObject("tcb_cust");
custDao.item("sign_dn", sign_dn);
custDao.item("sign_data", sign_data);
custDao.item("sign_date", gap_sign_date);
db.setCommand( custDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no = '"+cont.getString("member_no")+"'"),custDao.record);

contDao = new ContractDao();
contDao.item("status", "50");
db.setCommand(contDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), contDao.record);

String agree_seq = "";
DataObject contAgreeDao = new DataObject("tcb_cont_agree");
DataSet contAgree= contAgreeDao .find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(contAgree.next()){
	agree_seq = contAgree.getString("agree_seq");
}
if(!agree_seq.equals("")){ // ���� ���� ���μ����� �ִ� ���. ���� ����Ǿ����� ǥ��

    DataObject agreeDao = new DataObject("tcb_cont_agree");
    agreeDao.item("ag_md_date", u.getTimeString());
    agreeDao.item("r_agree_person_id","SYSTEM");
    agreeDao.item("r_agree_person_name", "�ý����ڵ�����");
    db.setCommand( agreeDao.getUpdateQuery(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and agree_seq="+agree_seq),agreeDao.record);
}



//���� ����
	//��� ���� ��ȸ
DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+cont.getString("member_no")+"' and useseq = (select max(useseq) from tcb_useinfo where member_no = '"+cont.getString("member_no")+"' )");
if(!useInfo.next()){
    u.jsError("����� ������ �����ϴ�.");
    return;
}

// �ĺ��� ���
if(useInfo.getString("paytypecd").equals("50")&&gap_pay_yn.equals("")){
	DataObject payDao = new DataObject("tcb_pay");
	int iPayAmount = 0;  //���� �ݾ�
	int iVatAmount = 0;
	int iCustNum = 1;
	String payContName = cont.getString("cont_name");
	
	if(useInfo.getString("order_write_type").equals("Y")) { // �����ڸ��� ����
		iCustNum = custDao.getOneInt("select count(*) from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and sign_seq < 10 and member_no <> '"+cont.getString("member_no")+"'");
	}
	
	DataObject useinfoaddDao = new DataObject("tcb_useinfo_add");
	DataSet useInfoAdd = useinfoaddDao.find("template_cd='"+cont.getString("template_cd")+"' and member_no='"+cont.getString("member_no")+"'");
	
	// �ĺ��ε� ��ĺ��� ��� �ΰ��Ұ� �ִٸ�
	if(useInfoAdd.next()) {
		iPayAmount = useInfoAdd.getInt("recpmoneyamt") * iCustNum;
		if(useInfoAdd.getString("insteadyn").equals("Y")){  // ���޾�ü�� �볳�� ���
			iPayAmount += useInfoAdd.getInt("suppmoneyamt");
			payContName += "(�볳����)";
		}
	}else{
		iPayAmount = useInfo.getInt("recpmoneyamt") * iCustNum;
		if(useInfo.getString("insteadyn").equals("Y")){  // ���޾�ü�� �볳�� ���
			iPayAmount += useInfo.getInt("suppmoneyamt");
			payContName += "(�볳����)";
		}
	}
	
	iVatAmount = iPayAmount/10;
	iPayAmount = iPayAmount+iVatAmount;
	
	//tcb_pay insert
	payDao.item("cont_no", cont_no);
	payDao.item("cont_chasu", cont_chasu);
	payDao.item("member_no", cont.getString("member_no"));
	payDao.item("cont_name", payContName);
	payDao.item("pay_amount", iPayAmount);
	payDao.item("pay_type", "05");
	payDao.item("accept_date", u.getTimeString());
	payDao.item("receit_type","0");
	db.setCommand(payDao.getInsertQuery(), payDao.record);
	
	//tcb_cust update
	custDao = new DataObject("tcb_cust");
	custDao.item("pay_yn", "Y");
	db.setCommand(custDao.getUpdateQuery("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no= '"+cont.getString("member_no")+"' "),custDao.record);
}

/* ���α� START*/
ContBLogDao logDao = new ContBLogDao();
logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  cont.getString("member_no"), "0", "�ý����ڵ�����", request.getRemoteAddr(), "���ڼ��� �Ϸ�",  "�ڵ�����", "50","10");
/* ���α� END*/

if(!db.executeArray()){
    //u.jsError("�ڵ����� ���忡 ���� �Ͽ����ϴ�.");
    u.jsAlertReplace("��༭ ����ó�� �Ͽ����ϴ�.", next_page);
    return;
}

if(!u.request("next_page").equals("")){
	u.jsAlertReplace("���Ϸ�ó�� �Ǿ����ϴ�.", next_page);
}else{
	u.jsAlertReplace("���Ϸ�ó�� �Ǿ����ϴ�.\\n\\n�Ϸ�(�������)�޴��� �̵��մϴ�.", "./contend_recv_list.jsp");
}

String[] arr_auto_sign_push = {
		 "20171101813|2019015" //PGM)SK����� ������ ��༭[DB�Ǻ�]
		,"20171101813|2019016" //PGM)SK����� ������ ��༭[���׹��]
		,"20171101813|2019017" //PGM)SK����� �ǸŰ�༭[ȥ�ռ�����]
		,"20171101813|2019018" //PGM)SK����� �ǸŰ�༭[����Ź������]
		,"20171101813|2020192" //PGM)SK����� �ǸŹ�۰�༭[Ư��ȥ�ո���]
		};
if(u.inArray(cont.getString("member_no")+"|"+cont.getString("template_cd"), arr_auto_sign_push) ) {
	 u.redirect("contract_sendpush.jsp?confirm=AUTO&"+u.getQueryString() );
}

%>
