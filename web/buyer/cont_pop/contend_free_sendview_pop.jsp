<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%@ page import="nicednb.Client" %>
<%
String vcd = u.request("vcd");
String key = u.request("key");
String cert = u.request("cert");

if(vcd.length()!=10) //|| uri.equals("http"))
{
	out.print("No Permission!!");
	return;
}

String contstr = u.aseDec(key);  // ���ڵ�
if(contstr.length() != 12)
{
	out.print("No Permission!!");
	return;
}

String sClientKey = "";

String member_no = "";

Client cs = new Client();
if(vcd.equals("1168150973")){  // ���̵�����Ȩ����
	sClientKey = cs.getClientKey("www.idigitalhomeshopping.com");
	member_no = "20150600110";
}else if(vcd.equals("1208755227")){  // ������
	sClientKey = cs.getClientKey("www.wemakeprice.com");
	member_no = "20130500619";
}else if(vcd.equals("2118819183")){  // �����������ڸ���
	sClientKey = cs.getClientKey("www.wconcept.co.kr");
	member_no = "20140100706"; 
}else if(vcd.equals("4928700855")){  // �������̺�ε���
	sClientKey = cs.getClientKey("www.skbroadband.com");
	member_no = "20171101813"; 
}else if(vcd.equals("1068123810")){  // �Ҵ��ڸ���
	sClientKey = cs.getClientKey("www.sonykorea.com");
	member_no = "20160900378"; 
	//out.print(sClientKey);
}else if(vcd.equals("1348106363")){  // �������
	sClientKey = cs.getClientKey("www.daeduck.com");
	member_no = "20150500269";
}else{
	out.print("No Permission!!");
	return;
}


System.out.println("cert : "+cert);
System.out.println("sClientKey : "+sClientKey);

if(!cert.equals(sClientKey))
{
	out.print("Certfication Key Error!!");
	return;
}


String cont_no = contstr.substring(0,11);
String cont_chasu = contstr.substring(11);

if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}


String file_path = "";
boolean gap_yn = false;// �α����� ��ü�������� ���� cust_type == "01" �̸� ���̴�.
boolean bIsKakao = u.inArray(member_no, new String[]{"20130900194"});

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_status = codeDao.getCodeArray("M008");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_auto_type = {"=>�ڵ�����","1=>�ڵ�÷��","2=>�ʼ�÷��","3=>���ο�"};

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("�ۼ���ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}

ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet cont = contDao.find(
" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and status = '50'",
"tcb_contmaster.*"
+" ,(select user_name from tcb_person where user_id = tcb_contmaster.reg_id ) writer_name "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is not null ) sign_cnt "
+" ,(select count(member_no) from tcb_cust where cont_no = tcb_contmaster.cont_no and cont_chasu=tcb_contmaster.cont_chasu and sign_dn is null ) unsign_cnt "
+" ,(select member_name from tcb_member where member_no = tcb_contmaster.mod_req_member_no ) mod_req_name "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
+" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
);
if(!cont.next()){
	u.jsError("��������� ���� ���� �ʽ��ϴ�.");
	return;
}

String listUrl = "";

if(cont.getString("paper_yn").equals("Y"))
{
	listUrl = "contend_send_write_list.jsp";
}
else
{
	listUrl = "contend_send_list.jsp";
}

p.setVar("listUrl", listUrl);
p.setVar("paper", true);

cont.put("cont_no", u.aseEnc(cont.getString("cont_no")));
cont.put("cont_date",u.getTimeString("yyyy-MM-dd",cont.getString("cont_date")));
cont.put("cont_edate",u.getTimeString("yyyy-MM-dd",cont.getString("cont_edate")));
cont.put("status_name", u.getItem(cont.getString("status"),code_status));
cont.put("reg_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("reg_date")));
cont.put("mod_req_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cont.getString("mod_req_date")));
cont.put("mod_req_reason", u.nl2br(cont.getString("mod_req_reason")));
if(!cont.getString("src_cd").equals(""))
cont.put("src_nm", cont.getString("l_src_nm")+" > "+cont.getString("m_src_nm")+" > "+cont.getString("s_src_nm"));
if(bIsKakao) {
	if(cont.getString("cont_etc2").equals("on"))
		cont.put("cont_etc2", "�� �絵 �� ���� ���");
	else
		cont.put("cont_etc2", "�� �絵 �� ���� ��� �ƴ�");

	cont.put("cont_etc3", u.nl2br(cont.getString("cont_etc3")));
}



//���� �������� ��ȸ
boolean send_able = false;  // ���� ���� ����

//���� �����ؾ� �ϴ� ����(�μ��ڵ� / ���̵�)
DataObject agreeTemplateDao = new DataObject("tcb_cont_agree");
DataSet agreeTemplate= agreeTemplateDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", "agree_seq");
while(agreeTemplate.next()){
 agreeTemplate.put("cont_no", u.aseEnc(agreeTemplate.getString("cont_no")));
	if(!agreeTemplate.getString("mod_reason").equals(""))  // �ݷ������� ������
	{
		agreeTemplate.put("ag_md_date", "�ݷ�<br><font size='1'>"+u.getTimeString("yyyy-MM-dd HH:mm:ss", agreeTemplate.getString("ag_md_date")) + "</font>");
	}
	else if(!agreeTemplate.getString("r_agree_person_id").equals("")) // ������ ���̵� �ִ� ���� Ȯ��
	{
		agreeTemplate.put("ag_md_date", "�Ϸ�<br><font size='1'>"+u.getTimeString("yyyy-MM-dd HH:mm:ss", agreeTemplate.getString("ag_md_date")) + "</font>");
	}

	// ������¿� ���� css ���� �ٸ��� ����
	if(agreeTemplate.getString("r_agree_person_id").equals("")) // Ȯ���� ���̵� �����̹Ƿ� ���� Ȯ�� ���� ����
		agreeTemplate.put("css","_off");
	else // Ȯ���ڰ� Ȯ���� ����
		agreeTemplate.put("css","");

}


DataObject signTemplateDao = new DataObject("tcb_cont_sign");
DataSet signTemplate = signTemplateDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");

// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust a");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'","a.*, (select cust_type from tcb_cont_sign where cont_no = a.cont_no and cont_chasu=a.cont_chasu and sign_seq = a.sign_seq ) cust_type");
if(cust.size()<1){
	u.jsError("����ü ������ ���� ���� �ʽ��ϴ�.");
	return;
}

while(cust.next()){
    cust.put("cont_no", u.aseEnc(cust.getString("cont_no")));
	if(cust.getString("member_no").equals(member_no)&&cust.getString("cust_type").equals("01"))gap_yn = true;
	cust.put("sign_date", u.getTimeString("yyyy-MM-dd HH:mm:ss", cust.getString("sign_date")));
}


//��༭�� ��ȸ
DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(cfile.next()){
    cfile.put("cont_no", u.aseEnc(cfile.getString("cont_no")));
	if(cfile.getString("cfile_seq").equals("1")&&cfile.getString("auto_yn").equals("Y")){
		file_path = cfile.getString("file_path");
	}
	if(cfile.getString("auto_yn").equals("Y")){
		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
			cfile.put("auto_type","0");
		}
	}else{
		cfile.put("auto_str", "����÷��");
	}
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
		cfile.put("btn_name", "��ȸ(�μ�)");
		cfile.put("down_script","contPdfViewer2('"+u.aseEnc(cont_no)+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
	}else{
		cfile.put("btn_name", "�ٿ�ε�");
		cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
	}	
	
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("pdf_yn", cfile.getString("file_ext").toLowerCase().equals("pdf"));
}

//����������ȸ
DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
while(warr.next()){
    warr.put("cont_no", u.aseEnc(warr.getString("cont_no")));
	warr.put("haja", warr.getString("warr_type").equals("20"));
	warr.put("warr_type", u.getItem(warr.getString("warr_type"),code_warr));
	warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
	warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
	warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
}

// ��ü�� ���� ���� ��ȸ
DataObject rfileDao = new DataObject("tcb_rfile");

//custDao.setDebug(out);
DataSet rfile_cust = custDao.query(
 " select a.*  "
+"   from tcb_cust a, tcb_cont_sign b "
+"  where a.cont_no= b.cont_no  "
+"    and a.cont_chasu = b.cont_chasu "
+"    and a.sign_seq = b.sign_seq  "
+"    and a.cont_no = '"+cont_no+"' "
+"    and a.cont_chasu = '"+cont_chasu+"' "
+"    and b.cust_type <> '01' "
);
while(rfile_cust.next()){
	rfile_cust.put("cont_no", u.aseEnc(rfile_cust.getString("cont_no")));
	rfile_cust.put("attch_area", rfile_cust.getString("member_no").equals(member_no));

	//rfileDao.setDebug(out);
	DataSet rfile = rfileDao.query(
	 "  select a.attch_yn, a.doc_name, a.rfile_seq,b.file_path, b.file_name, b.file_ext, file_size "
	+"    from tcb_rfile a  "
	+"    left outer join  tcb_rfile_cust b "
	+"      on a.cont_no = b.cont_no  "
	+"     and a.cont_chasu = b.cont_chasu "
	+"     and a.rfile_seq = b.rfile_seq "
	+"     and b.member_no = '"+rfile_cust.getString("member_no")+"' "
	+"   where  a.cont_no = '"+cont_no+"'  "
	+"     and a.cont_chasu = '"+cont_chasu+"' "
	);
	while(rfile.next()){
		rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
		rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
	}
	rfile_cust.put(".rfile",rfile);
}

if(u.isPost()&&f.validate()){
	// ������� ����
}
p.setLayout("popup");
//p.setDebug(out);
p.setBody("cont_pop.contend_free_sendview_pop");
p.setVar("menu_cd","000063");
p.setVar("popup_title","�Ϸ�(�������)");
p.setVar("modify", true);
p.setVar("member", member);
p.setVar("gap_yn", gap_yn);
p.setVar("kakao", bIsKakao);
p.setVar("cont", cont);
p.setVar("sign_able", cont.getInt("unsign_cnt")==1);// Ÿ�� ���� �Ϸ� �� ���� ����
p.setVar("file_path", file_path);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("warr", warr);
p.setLoop("rfile_cust", rfile_cust);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no,cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>