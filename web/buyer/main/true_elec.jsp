<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%

String[] elc_status = {"10=>�ۼ���","20=>������","30=>����Ȯ�οϷ�","40=>������û","50=>�Ϸ�"};

f.addElement("doc_no1", null, "hname:'������ȣ', required:'Y', minbyte:'12'" );
f.addElement("doc_no2", null, "hname:'������ȣ', required:'Y', minbyte:'3'" );
f.addElement("true_random", null, "hname:'������ȣ', required:'Y', minbyte:'5'" );


DataSet ds = new DataSet();
if(u.isPost()&&f.validate()){
	String doc_no = f.get("doc_no1")+"-"+f.get("doc_no2");
	DataObject dao = new DataObject("tcb_elcmaster a");
	ds = dao.find(
	" doc_no = '"+doc_no+"' and true_random = '"+f.get("true_random")+"' "// where ��
	,  "a.*, (select member_name from tcb_elc_supp where doc_no = a.doc_no and supp_type='10' ) send_member_name"
	  +", (select member_name from tcb_elc_supp where doc_no = a.doc_no and supp_type='20' ) recv_member_name"
	); 
	
	if(!ds.next()){
		u.jsError("�Է��Ͻ� ��ȣ�� ���� ������ ���� ���� �ʽ��ϴ�.");
		return;
	}
	ds.put("status", u.getItem(ds.getString("status"), elc_status));
}


p.setLayout("popup");
p.setDebug(out);
p.setBody("main.true_elec");
p.setVar("popup_title","���ڹ��� ����Ȯ��");
p.setVar("ds",ds);
p.setVar("form_script",f.getScript());
p.display(out);
%>