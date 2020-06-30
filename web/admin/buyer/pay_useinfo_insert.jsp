<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

CodeDao codeDao = new CodeDao("tcm_comcode");
String[] code_pay_type = codeDao.getCodeArray("M006");
String[] code_calc_day = codeDao.getCodeArray("M048");
String[] code_allow_ext = {"pdf=>PDF","jpg,jpeg,pdf,png,gif=>�̹�������","xls,xlsx=>����","doc,docx=>����","hwp=>�ѱ�"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}

DataObject menuMemberDao = new DataObject("tcb_member_menu");
int bid_cnt = menuMemberDao.findCount(" member_no = '"+member_no+"' and adm_cd = '000015'");

f.addElement("paytypecd", null, "hname:'�̿�����', required:'Y'");
f.addElement("calc_day", null, "hname:'��꼭������'");
f.addElement("usestartday", null, "hname:'�̿�Ⱓ', required:'Y'");
f.addElement("useendday", null, "hname:'�̿�Ⱓ', required:'Y'");
f.addElement("recpmoneyamt", null, "hname:'������ڿ��', required:'Y'");
f.addElement("suppmoneyamt", null, "hname:'���޻���ڿ��', required:'Y'");
f.addElement("insteadyn", null, "hname:'���޻���� ��� ó��', required:'Y'");
f.addElement("paper_amt", null, "hname:'��������'");
f.addElement("stampyn", null, "hname:'�������������� �������'");
f.addElement("bid_amt",null, "hname:'�������', requred:'Y'");
f.addElement("etc", null, "hname:'���'");
f.addElement("proof_yn", null, "hname:'���������뿩��'");

if(u.isPost()&&f.validate()){
	DB db = new DB();
	DataObject dao = new DataObject("tcb_useinfo");

	dao.item("member_no", member_no);
	dao.item("useseq", "1");
	dao.item("paytypecd", f.get("paytypecd"));
	dao.item("usestartday", f.get("usestartday").replaceAll("-", ""));
	dao.item("useendday", f.get("useendday").replaceAll("-", ""));
	dao.item("recpmoneyamt", f.get("recpmoneyamt").replaceAll(",", ""));
	dao.item("suppmoneyamt", f.get("suppmoneyamt").replaceAll(",", ""));
	dao.item("paper_amt", f.get("paper_amt").replaceAll(",", ""));
	dao.item("insteadyn", f.get("insteadyn"));
	dao.item("biduseyn", f.get("biduseyn").equals("Y")?"Y":"N");
	dao.item("stampyn", f.get("stampyn").equals("Y")?"Y":"N");
	dao.item("modifydate", u.getTimeString());
	dao.item("etc", f.get("etc"));
	dao.item("bid_amt", f.get("bid_amt").replaceAll(",",""));
	dao.item("calc_day", f.get("calc_day"));
	db.setCommand(dao.getInsertQuery(), dao.record);

	DataObject rfileDao = new DataObject("tcb_client_rfile_template");
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] allow_ext = f.getArr("allow_ext");
	int doc_cnt = rfile_doc_name==null?0:rfile_doc_name.length;
	for(int i = 0 ; i < doc_cnt; i ++){
		rfileDao = new DataObject("tcb_client_rfile_template");
		rfileDao.item("member_no", member_no);
		rfileDao.item("rfile_seq", i+1);
		rfileDao.item("doc_name", rfile_doc_name[i]);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfileDao.item("allow_ext", allow_ext[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);
	}

	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�. �����ͷ� ���� �Ͽ� �ֽʽÿ�.");
		return;
	}

	u.jsAlertReplace("�����Ͽ����ϴ�.", "pay_useinfo_modify.jsp?"+u.getQueryString());
	return;
}

p.setLayout("default");
p.setBody("buyer.pay_useinfo_modify");
p.setVar("menu_cd", "000045");
p.setVar("modify", false);
p.setVar("member", member);
p.setLoop("code_calc_day", u.arr2loop(code_calc_day));
p.setLoop("code_pay_type", u.arr2loop(code_pay_type));
p.setLoop("code_allow_ext", u.arr2loop(code_allow_ext));
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.display(out);
%>