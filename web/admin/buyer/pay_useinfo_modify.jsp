<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no");
if(member_no.equals("")){
	u.jsError("�������� ��η� �����ϼ���.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_pay_type = codeDao.getCodeArray("M006", " and use_yn = 'Y' ");
String[] code_calc_day = codeDao.getCodeArray("M048");
String[] code_allow_ext = {"pdf=>PDF","jpg,jpeg,pdf,png,gif=>�̹�������","xls,xlsx=>����","doc,docx=>����","hwp=>�ѱ�"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("��ü������ �����ϴ�.");
	return;
}


DataObject menuMemberDao = new DataObject("tcb_member_menu");
int bid_cnt = menuMemberDao.findCount(" member_no = '"+member_no+"' and adm_cd in ('010101','010501')");

DataObject useInfoDao = new DataObject("tcb_useinfo");
DataSet useInfo = useInfoDao.find("member_no = '"+member_no+"' ");
if(!useInfo.next()){
	u.jsError("�̿������� �����ϴ�.");
	return;
}
useInfo.put("usestartday", u.getTimeString("yyyy-MM-dd", useInfo.getString("usestartday")));
useInfo.put("useendday", u.getTimeString("yyyy-MM-dd", useInfo.getString("useendday")));
useInfo.put("modifydate", u.getTimeString("yyyy-MM-dd", useInfo.getString("modifydate")));
useInfo.put("paper_amt", u.numberFormat(useInfo.getDouble("paper_amt"), 0));
File stamp_file = new File(Startup.conf.getString("file.path.bcont_proof_stamp") + member_no + "/pdf_stamp_writing.gif");
useInfo.put("stamp_file_yn",stamp_file.exists());

DataObject rfileDao = new DataObject("tcb_client_rfile_template");
DataSet rfile = rfileDao.find("member_no = '"+ member_no +"'");
while(rfile.next()){
	rfile.put("checked", rfile.getString("attch_yn").equals("Y")?"checked":"");
	DataSet code_allow = u.arr2loop(code_allow_ext);
	while(code_allow.next()){
		code_allow.put("selected", code_allow.getString("id").equals(rfile.getString("allow_ext"))?"selected":"");
	}
	rfile.put(".code_allow", code_allow);
}

DataObject pDaoAdd = new DataObject("tcb_useinfo_add ta inner join tcb_cont_template tt on ta.template_cd=tt.template_cd");
//pDaoAdd.setDebug(out);
DataSet lds = pDaoAdd.find("ta.member_no='"+member_no+"' and useseq=1", "ta.*, nvl(tt.display_name,tt.template_name) template_name");
while(lds.next())
{
	lds.put("recpmoneyamt", u.numberFormat(lds.getString("recpmoneyamt")));
	lds.put("suppmoneyamt", u.numberFormat(lds.getString("suppmoneyamt")));
	lds.put("insteadyn", lds.getString("insteadyn").equals("Y") ? "������� ����" : "���޻���� ����");
}

DataObject calcPersonDao = new DataObject("tcb_calc_person");
DataSet calcPerson = calcPersonDao.find(" member_no = '"+member_no+"' ", "*", " seq asc");
while(calcPerson.next()){
	if(calcPerson.getString("field_seq").equals("")){
		calcPerson.put("field_name", "��ü" );
	}else {
		String field_name = calcPersonDao.getOne("select wm_concat(field_name) from tcb_field where member_no = '" + member_no + "' and field_seq in (" + calcPerson.getString("field_seq") + ")");
		calcPerson.put("field_name", field_name );
	}
}

f.addElement("paytypecd", useInfo.getString("paytypecd"), "hname:'�̿�����', required:'Y'");
f.addElement("calc_day", useInfo.getString("calc_day"), "hname:'��꼭������'");
f.addElement("usestartday", useInfo.getString("usestartday"), "hname:'�̿�Ⱓ', required:'Y'");
f.addElement("useendday", useInfo.getString("useendday"), "hname:'�̿�Ⱓ', required:'Y'");
f.addElement("recpmoneyamt", u.numberFormat(useInfo.getString("recpmoneyamt")), "hname:'������ڿ��', required:'Y'");
f.addElement("suppmoneyamt", u.numberFormat(useInfo.getString("suppmoneyamt")), "hname:'���޻���ڿ��', required:'Y'");
f.addElement("insteadyn", useInfo.getString("insteadyn"), "hname:'���޻���� ��� ó��', required:'Y'");
f.addElement("paper_amt", useInfo.getString("paper_amt"), "hname:'��������'");
f.addElement("bid_amt", u.numberFormat(useInfo.getString("bid_amt")), "hname:'�������', requred:'Y'");
f.addElement("proof_yn", useInfo.getString("proof_yn"), "hname:'���������뿩��'");
f.addElement("stampyn", useInfo.getString("stampyn"), "hname:'�������������� �������'");
f.addElement("etc", null, "hname:'���'");

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
	//dao.item("biduseyn", f.get("biduseyn").equals("Y")?"Y":"N");
	dao.item("biduseyn", bid_cnt>0?"Y":"N");
	dao.item("stampyn", f.get("stampyn").equals("Y")?"Y":"N");
	dao.item("modifydate", u.getTimeString());
	dao.item("etc", f.get("etc"));
	dao.item("proof_yn",f.get("proof_yn"));
	dao.item("bid_amt", f.get("bid_amt").replaceAll(",",""));
	dao.item("calc_day", f.get("calc_day"));
	db.setCommand(dao.getUpdateQuery("member_no='"+member_no+"' "), dao.record);


	// �ŷ�ó ��� ÷������
	db.setCommand("delete from tcb_client_rfile where member_no = '"+member_no+"'", null);
	db.setCommand("delete from tcb_client_rfile_template where member_no = '"+member_no+"'", null);
	int base_seq = rfileDao.getOneInt("select nvl(max(rfile_seq),0)+1 rfile_seq from tcb_client_rfile_template where member_no = '"+member_no+"'");

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
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("useInfo", useInfo);
p.setVar("bid_use", bid_cnt>0?"�������":"�����̻��");
p.setLoop("code_calc_day", u.arr2loop(code_calc_day));
p.setLoop("code_pay_type", u.arr2loop(code_pay_type));
p.setLoop("code_allow_ext", u.arr2loop(code_allow_ext));
p.setLoop("calcPerson",calcPerson);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("member_no"));
p.setVar("form_script",f.getScript());
p.setLoop("rfile", rfile);
p.setLoop("lds", lds);
p.display(out);
%>