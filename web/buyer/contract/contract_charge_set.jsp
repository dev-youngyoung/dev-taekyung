<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%


if(u.isPost()&&f.validate()){
	
	String cont_no = f.get("cont_no");
	String cont_chasu = f.get("cont_chasu");
	String agree_seq = f.get("agree_seq");
	String person_id = f.get("person_id");
	String person_name = f.get("person_name");
	if(cont_no.equals("")||cont_chasu.equals("")||agree_seq.equals("")||person_id.equals("")||person_name.equals("")){
		u.jsError("�������� ��η� �����ϼ���.");
		return;
	}
	cont_no = u.aseDec(cont_no);
	
	// �μ� �ڵ� �˻�
	DataObject fieldDao = new DataObject();
	String sFieldSeq = fieldDao.getOne("select field_seq from tcb_person where user_id='"+person_id+"'");
	
	// ��� ���缱 �μ����� ����
	DB db = new DB();
	DataObject contractDao = new DataObject("tcb_contmaster");
	String sContFieldSeqs = contractDao.getOne("select agree_field_seqs from tcb_contmaster where cont_no='"+cont_no+"' and cont_chasu="+cont_chasu);
	String sChangeFieldSeqs = "";
	
	//0|5|5|5|16|
	String[] arrFieldSeqs = sContFieldSeqs.split("\\|");
	
	arrFieldSeqs[Integer.parseInt(agree_seq)-1] = sFieldSeq;
	for(int i=0; i<arrFieldSeqs.length; i++) {
		sChangeFieldSeqs += arrFieldSeqs[i] + "|";
	}
	
	contractDao.item("agree_field_seqs", sChangeFieldSeqs);
	db.setCommand(contractDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), contractDao.record);
	
	// ���缱 ���� ���� 
	DataObject agreeDao = new DataObject("tcb_cont_agree");
	agreeDao.item("agree_person_name", person_name);
	agreeDao.item("agree_person_id", person_id);
	agreeDao.item("agree_field_seq", sFieldSeq);
	db.setCommand(agreeDao.getUpdateQuery("agree_seq="+agree_seq+" and cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), agreeDao.record);

	System.out.println("org agree_field_seqs : " + sContFieldSeqs);
	System.out.println("aft agree_field_seqs : " + sChangeFieldSeqs);
	
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
		return;
	}

	u.jsAlertReplace("���� �Ͽ����ϴ�.", "contract_charge_list.jsp?"+u.getQueryString());	
}
%>