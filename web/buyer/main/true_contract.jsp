<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%


f.addElement("cont_no", null, "hname:'������ȣ', required:'Y', maxbyte:'11'");
f.addElement("cont_chasu", null, "hname:'������ȣ', required:'Y', maxbyte:'2'");
f.addElement("true_random", null, "hname:'������ȣ', required:'Y', maxbyte:'5'");

if(u.isPost() && f.validate())
{
	DataObject pDao = new DataObject("tcb_contmaster cont INNER JOIN tcb_cust cust ON cont.cont_no = cust.cont_no AND cont.cont_chasu = cust.cont_chasu and cont.member_no = cust.member_no");

	pDao.setFields("cont.cont_no"			// ��������ȣ
					+",cont.cont_chasu"		// ��������
					+",cont.cont_name"		// ����
					+",cont.cont_date"		// ������� (yyyyMMdd)
					+",cont.status"			// ���������� �ڵ�
					+",cust.member_name first_cust_name"			// ������� ��ü��
					+",(SELECT member_name"
					+"	FROM tcb_cust"
					+"	WHERE cont_no = cont.cont_no"
					+"	  AND cont_chasu = cont.cont_chasu"
					+"	  AND display_seq = (select max(display_seq) from tcb_cust where cont_no = cont.cont_no AND cont_chasu = cont.cont_chasu and member_no <> cont.member_no)"
					+" ) second_cust_name"  // ���޻���� ��ü��
					);
					
	DataSet ds = pDao.find("cont.cont_no='" + f.get("cont_no") + "' and cont.cont_chasu = '"+ f.get("cont_chasu") +"' and cont.true_random = '" + f.get("true_random") + "'");

	if(!ds.next()){
		u.jsError("�ش� ����� �������� �ʽ��ϴ�.");
		return;
	}
	
	String msg = "";
	CodeDao code = new CodeDao("tcb_comcode");
	String[] status_code = code.getCodeArray("M008");	// ���������� �ڵ�	
	String status_name = u.getItem(ds.getString("status"), status_code);
	if(status_name.equals(""))
		msg = "�� ����� <b><font color=\"red\">[����]</font></b> ����Դϴ�.";
	else
		msg = "���ڰ������ <b><font color=\"blue\">["+u.getItem(ds.getString("status"), status_code)+"]</font></b>�� ��༭ �Դϴ�.";
	
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")) );
	p.setVar("ds", ds);
	p.setVar("msg", msg);
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("main.true_contract");
p.setVar("popup_title","���ڰ�� ����Ȯ��");
p.setVar("form_script",f.getScript());
p.display(out);
%>