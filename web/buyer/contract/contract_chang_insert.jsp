<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%@ page import="org.jsoup.*" %>
<%@ page import="org.jsoup.nodes.*" %>
<%@ page import="org.jsoup.select.*" %>
<%
Security	security	=	new	Security();
// ���� �̿� �Ⱓ üũ
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("���� �̿�Ⱓ�� ���� �Ǿ����ϴ�.\\n\\n���̽���ť ������[02-788-9097]�� �����ϼ���.");
	return;
}

boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ�������
String template_cd = u.request("template_cd");
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
if(template_cd.equals("")||cont_no.equals("")||cont_chasu.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ �������� �ʽ��ϴ�.");
	return;
}

//����� ����ȣ �ڵ� ���� ����
boolean bAutoContUserNo = u.inArray(
		_member_no
		, new String[]{
				 "20150400367"	//�������(��)
				,"20170100166"	//�ֽ�ȸ�� �Ż���ī����
				,"20170100165"	//�ֽ�ȸ�� ����å�Ż��
				,"20160401012"	//������Ÿġ���ͼַ�� �ֽ�ȸ��
				,"20150900434"	//������۽��� �ֽ�ȸ��
				,"20150500312"	//(��)����������
				,"20140900004"	//(��)����Ƽ���ؿ���
				,"20130400011"	//�ѱ����������Ǿ��� ����ȸ��
				,"20130400010"	//�ѱ������� Ʈ���̵� ����ȸ��
				,"20130400009"	//�ѱ�������������ũ ����ȸ��
				,"20130400008"	//�ֽ�ȸ�� ���������̿���Ƽ
				,"20121203661"	//�ѱ�������(��)
				,"20180203437"	//���̿���
				,"20121200073"	//������Ǯ
				,"20181201176"	//īī�� Ŀ�ӽ�
				,"20190205651"	//���λ�� �ֽ�ȸ��
				,"20190205653"	//�̼���� �ֽ�ȸ��
				,"20190205654"	//(��) ����������
				,"20190205649"	//������� (��)
				,"20190205652"	//���밳���ֽ�ȸ��
				,"20191101572"  //�������(��) 
				,"20200203416"  //����̿�����
				,"20200203478"  //�������
				,"20200203481"  //�������(��)
				}
);

if(_member_no.equals("20150900434") && !template_cd.equals("2015106")) // ������۽��� ��ǰ���ް�༭ �ܴ� �ڵ�ä�� �ƴ�.
	bAutoContUserNo = false;

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = codeDao.getCodeArray("M010"," AND code <> '90' ");

// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"' and template_type in ('00','20','30')");  // 00: ������=���ʾ��, 10:�������� ������ �����ϴ� ���ʾ��, 20:������, 30:��Ҿ��
if(!template.next()){
}

if(u.inArray(_member_no, new String[]{"20121203661","20130400011","20130400010","20130400009","20130400008"}) ) // 3M
{
	code_change_gubun = new String[]{"08=>��������","99=>��Ÿ"};
}

// �߰� �������� ��ȸ
DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub= templateSubDao.find("template_cd ='"+template_cd+"'");

while(templateSub.next()){
	templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20","30"}) );
		
	if(templateSub.getString("option_yn").equals("A")) // �ڵ� �����ؾ� �ϴ� ���
		templateSub.put("option_yn", false);
}


//������༭ ���� ����
ContractDao contDao = new ContractDao();
//contDao.setDebug(out);
DataSet tempCont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' "
								,"tcb_contmaster.* "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,3) = substr(tcb_contmaster.src_cd,0,3) and depth='1') l_src_nm "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and substr(src_cd,0,6) = substr(tcb_contmaster.src_cd,0,6) and depth='2') m_src_nm "
							   +" ,(select src_nm from tcb_src_adm where member_no = tcb_contmaster.member_no and src_cd = tcb_contmaster.src_cd and depth='3') s_src_nm "
								);
if(!tempCont.next()){
}

if(!tempCont.getString("src_cd").equals(""))
tempCont.put("src_nm", tempCont.getString("l_src_nm")+">"+tempCont.getString("m_src_nm")+">"+tempCont.getString("s_src_nm"));
//������Ʈ���� ���� //���̿��� ��� 
if(!tempCont.getString("project_seq").equals("")){
	DataObject projectDao = new DataObject("tcb_project");
	DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+tempCont.getString("project_seq")+"' ");
	if(project.next()){
		tempCont.put("project_name", project.getString("project_name"));
		tempCont.put("project_cd", project.getString("project_cd"));
	}
}



if(template.getString("template_type").equals("00")){ // �����༭�� ���ʰ���̶� ���� ����� ���� ���� ����� �����´�.
	if(!tempCont.getString("template_cd").equals("")) // ���ʰ� �������İ���� �ƴ� ���
		template.put("template_html", tempCont.getString("cont_html"));
} else {
	String beforeVal = "";
	String rowChar = "`";

	// ��� html ����
	Document doc = Jsoup.parse(tempCont.getString("cont_html"));

	Elements inputs = doc.select("input");
	String type="";
	for(Element input : inputs)
	{
		type = input.attr("type");

		if(type.equals("") || type.equals("text")) // text
		{
			if(!input.attr("name").equals(""))
				beforeVal += rowChar + input.attr("name") + "��" +input.attr("value");
		} else if(type.equals("checkbox"))
		{
			if(!input.attr("name").equals(""))
				if(input.outerHtml().toLowerCase().indexOf("checked")>0){//üũ �Ȱ�츸 �߰�
					beforeVal += rowChar + input.attr("name") + "��" +input.attr("value");
				}
		} else if(type.equals("radio"))
		{
			if(!input.attr("name").equals("") && input.hasAttr("checked"))
				beforeVal += rowChar + input.attr("name") + "��" +input.attr("value");
		}

	}

	Elements selects = doc.select("select");
	for(Element select : selects)
	{
		if(!select.attr("name").equals(""))
		{
			for(Element option : select.children())
			{
				if(option.hasAttr("selected"))
					beforeVal += rowChar + select.attr("name") + "��" +option.attr("value");
			}
		}
	}

	Elements textareas = doc.select("textarea");
	for(Element textarea : textareas)
	{
		if(!textarea.attr("name").equals(""))
			beforeVal += rowChar + textarea.attr("name") + "��" +textarea.text();
	}


	// ��� DB ����
	beforeVal += rowChar + "db_cont_name" + "��" +tempCont.getString("cont_name"); // ����
	beforeVal += rowChar + "db_supp_tax" + "��" +tempCont.getString("supp_tax");  // ���ް���
	beforeVal += rowChar + "db_supp_vat" + "��" +tempCont.getString("supp_vat");  // �ΰ���
	beforeVal += rowChar + "db_cont_total" + "��" +tempCont.getString("cont_total");  // �ΰ���
	beforeVal += rowChar + "db_cont_year" + "��" +u.getTimeString("yyyy",tempCont.getString("cont_date")); // �������
	beforeVal += rowChar + "db_cont_month" + "��" +u.getTimeString("MM",tempCont.getString("cont_date")); // �������
	beforeVal += rowChar + "db_cont_day" + "��" +u.getTimeString("dd",tempCont.getString("cont_date")); // �������
	beforeVal += rowChar + "db_org_cont_chasu" + "��" + tempCont.getString("cont_chasu"); // �����������
	beforeVal += rowChar + "db_cont_userno" + "��" +tempCont.getString("cont_userno"); // ��������ȣ
	p.setVar("beforeVal",java.net.URLEncoder.encode(beforeVal,"UTF-8"));  // java���� ���ڵ��ϰ� javascript���� ���ڵ��ؾ� ���๮�ڵ��� ����� ����
}


//������ ��ȸ
DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'");

// ���� �������� ��ȸ
DataObject agreeTemplateDao = new DataObject("tcb_agree_template");
DataSet agreeTemplate= agreeTemplateDao.find("template_cd ='"+template_cd+"'", "*", "agree_seq");
if(agreeTemplate.size()>0){
	// ����� ����� ��������
	DataObject agreeUserDao = new DataObject("tcb_agree_user");
	DataSet agreeUser= agreeUserDao.find("template_cd ='"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"'", "*", "agree_seq");
	if(agreeUser.size()>0){
		agreeTemplate = agreeUser;
	}
}
while(agreeTemplate.next()){
	agreeTemplate.put("is_cust", agreeTemplate.getString("agree_cd").equals("0"));
	agreeTemplate.put("agree_person_id", agreeTemplate.getString("agree_cd").equals("0")?"-":agreeTemplate.getString("agree_person_id"));
}


DataObject attCfileDao = new DataObject("tcb_att_cfile");
DataSet cfile = attCfileDao.find("template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ");
while(cfile.next()){
	cfile.put("cfile_seq", cfile.getString("file_seq"));
	cfile.put("auto", true);
	cfile.put("auto_class", "caution-text");
	cfile.put("auto_str",cfile.getString("auto_type").equals("1")?"�ڵ�÷��":"�ʼ�÷��");
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
	cfile.put("doc_name_readonly", "readonly");
	cfile.put("modfiy_file", false);
	cfile.put("btn_name", "�ٿ�ε�");
	cfile.put("down_script","filedown('file.path.bcont_template','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
}

// ���񼭷� ��ȸ
DataObject rfileDao = new DataObject("tcb_rfile_template");
//rfileDao.setDebug(out);
DataSet rfile = rfileDao.find("template_cd = '"+template_cd+"' and member_no ='"+_member_no+"'");
while(rfile.next()){
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	if(rfile.getString("reg_type").equals("10")){
		rfile.put("attch_disabled_btn",rfile.getString("attch_yn").equals("Y")?"disabled":"");
		// �������� �����Ͽ�����,  18.11.15 ����ö����� ��û���� ���� ���׻��·� ������ (���ʼ�->�ʼ� ���� �����ϸ�, �̶� �ʼ� ������ '��������'�Է��ؾ���.)
		rfile.put("attch_disabled",rfile.getString("attch_yn").equals("Y")?"disabled":"");	 
		rfile.put("doc_name_class", "in_readonly");
		rfile.put("doc_name_readonly", "readonly");
		rfile.put("del_btn_yn", false);
	}else{
		rfile.put("attch_disabled_btn","");
		rfile.put("attch_disabled","");
		rfile.put("doc_name_class", "label");
		rfile.put("doc_name_readonly", "");
		rfile.put("del_btn_yn", true);
	}
}


//���� ���� ���� ��ȸ
String[] code_reg_type = {"10=><span class='caution-text'>�ʼ�÷��</span>","20=>����÷��","30=>�߰�÷��"};
DataObject efileDao = new DataObject("tcb_efile");
DataSet efile = new DataSet();
if(tempCont.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		//efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
		efile.put("del_yn10", efile.getString("reg_type").equals("10")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn20", efile.getString("reg_type").equals("20")&&!efile.getString("file_name").equals(""));
		efile.put("del_yn30", efile.getString("reg_type").equals("30"));
		efile.put("file_size_str", u.getFileSize(efile.getInt("file_size")));
		efile.put("down_script","filedown('file.path.bcont_pdf','"+efile.getString("file_path")+efile.getString("file_name")+"','"+efile.getString("doc_name")+"."+efile.getString("file_ext")+"')");
	}
}




// ����ü ��ȸ
DataObject custDao = new DataObject("tcb_cust");
DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", "*", " sign_seq  asc");
while(cust.next()){

	DataSet cust_member = memberDao.find(" member_no = '" + cust.getString("member_no") + "'", "member_name, boss_name, address,member_gubun");
	if(cust_member.next()){
		cust.put("member_name", cust_member.getString("member_name"));
		cust.put("boss_name", cust_member.getString("boss_name"));
		cust.put("address", cust_member.getString("address"));
		cust.put("member_gubun",cust_member.getString("member_gubun"));
		String field_name = "";
		
		// �������� �䱸�������� ���� �ۼ��� �μ����� �Է�. (����ö �����..... �� ��)
		if(_member_no.equals(cust.getString("member_no"))){
			DataObject personDao = new DataObject("tcb_field");
			DataSet person = personDao.find(" member_no = '" +_member_no+ "' and field_seq = '" + auth.getString("_FIELD_SEQ")+"'","field_name");
			if(person.next()){
				cust.put("field_name", person.getString("field_name"));
			}
		}
		
	}else{
		cust.put("member_gubun","04");//ȸ���� �ƴѰ��(��ȸ��) �����̴�.
	}
		
	if(!cust.getString("jumin_no").equals("")){
		cust.put("jumin_no", security.AESdecrypt(cust.getString("jumin_no")));
	}else{
		cust.put("jumin_no", "");
	}
}


f.addElement("cont_name",null, "hname:'����', required:'Y'");
f.addElement("cont_date", null, "hname:'�������', required:'Y'");
f.addElement("cont_userno", null, "hname:'����ȣ', maxbyte:'40'");
f.addElement("src_cd", tempCont.getString("src_cd"), "hname:'�ҽ̱׷�'");
f.addElement("change_gubun", null, "hname:'��౸��', required:'Y'");

if(template.getString("stamp_yn").equals("Y")){
	f.addElement("stamp_type", null, "hname:'������ ���� ���', required:'Y'");
}

if(u.isPost()&&f.validate()){
	//��༭ ����
	ContractDao cont = new ContractDao();

	cont_chasu = String.valueOf(Integer.parseInt(cont_chasu)+1);

	String random_no = u.strpad(u.getRandInt(0,99999)+"",5,"0");
	String cont_html_rm_str = "";
	String[] cont_html_rm = f.getArr("cont_html_rm");
	String[] cont_html = f.getArr("cont_html");
	String[] cont_sub_name = f.getArr("cont_sub_name");
	String[] cont_sub_style = f.getArr("cont_sub_style");
	String[] gubun = f.getArr("gubun");
	String[] sub_seq = f.getArr("sub_seq");
	String arrOption_yn[] = new String[cont_html_rm.length];

	//decodeing ó�� START
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		cont_html_rm[i] = new String(Base64Coder.decode(cont_html_rm[i]),"UTF-8");
	}
	for(int i = 0 ; i < cont_html.length; i ++){
		cont_html[i] =  new String(Base64Coder.decode(cont_html[i]),"UTF-8");
	}
	//decodeing ó�� END
	
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		arrOption_yn[i] = f.get("option_yn_"+i);
	}

	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(i != 0)
			cont_html_rm_str += "<pd4ml:page.break>";
		if(gubun[i].equals("10")&&u.inArray(f.get("option_yn_"+i), new String[]{"A","Y"})){
			cont_html_rm_str += cont_html_rm[i];
		}
	}

	ArrayList autoFiles = new ArrayList();

	String cont_userno = "";
	if(bAutoContUserNo){
		// �μ��� �������� ��Ģ ����
		if(u.inArray(_member_no, new String[] {"20150400367","20190205651","20190205653","20190205654","20190205649","20190205652"})){
			
			String dept_name ="";
			if(!"".equals(template.getString("field_seq"))){
				DataObject deptDao = new DataObject("tcb_field");
				DataSet dept = deptDao.find(" member_no = '"+_member_no+"' and field_seq =  '"+template.getString("field_seq")+"'" , " field_name");
				if(!dept.next()){
					u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����ͷ� �������ּ���.");
					return;
				}
				dept_name = dept.getString("field_name");
				cont_userno = contDao.getOne(
						  " select '"+dept_name+" '||'"+u.getTimeString("yyyyMM")+"-'||lpad(nvl(max(to_number(substr(cont_userno,-3))),0)+1,3,'0') cont_userno "
						 +"   from tcb_contmaster                                                                                                          "
						 +"  where member_no like '%"+_member_no+"%'                                                                                               "
						 +"    and cont_userno like '"+dept_name+" "+u.getTimeString("yyyyMM")+"-%'                                                            "
				);
			}else{
				u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����ͷ� �������ּ���.");
				return;
			}
		}else if(_member_no.equals("20170100165")){//����å �Ż��
			cont_userno = contDao.getOne(
					 " select  'TB"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
					+"    from tcb_contmaster                                                                                   "
					+"  where member_no = '"+_member_no+"'                                                                      "
					+"     and cont_userno like 'TB"+u.getTimeString("yyMM")+"%'                                                "
					);
		}else if(_member_no.equals("20170100166")){//�Ż�� ��ī����
			cont_userno = contDao.getOne(
					 " select  'AC"+u.getTimeString("yyMM")+"'|| lpad(to_number(nvl(max(substr(cont_userno,7)),'000'))+1,3,'0') "
					+"    from tcb_contmaster                                                                                   "
					+"  where member_no = '"+_member_no+"'                                                                      "
					+"     and cont_userno like 'AC"+u.getTimeString("yyMM")+"%'                                                "
					);
		}else if(_member_no.equals("20140900004")) // ����Ƽ���ؿ���
		{
			DataObject fieldDao = new DataObject();
			String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
			if(field_name.equals("")){
				u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
				return;
			}
			field_name = field_name + "-" + u.getTimeString("yyyy");

			int substr_pos = field_name.length()+1;
			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '20140900004' and field_seq="+auth.getString("_FIELD_SEQ"));
			if(userNoSeq.equals("")){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			}
			cont_userno = field_name + u.strrpad(userNoSeq, 4, "0");
		}else if(_member_no.equals("20150500312")){  // ���������� ����ȣ �ڵ�ü��
			String[] wUserNo = {"2015036=>ǥ��","2015037=>��������","2015038=>��ǰ����","2016108=>�μ�","2017257=>������","2017259=>�����԰���"};

			String sHeader = "W����_"+ u.getItem(template_cd, wUserNo)+"_"+u.getTimeString("yy")+"_";
			int pos = sHeader.length();

			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
			if(userNoSeq.equals("")){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			}
			cont_userno =sHeader+u.strrpad(userNoSeq, 8, "0");
		}else if(_member_no.equals("20150900434")){  // ����� �۽��� ����ȣ �ڵ�ü��
			String[] pacificUserNo = {"2015106=>NPPO"};

			String sHeader = u.getItem(template_cd, pacificUserNo)+u.getTimeString("yyyyMM");
			int pos = sHeader.length();

			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
			if(userNoSeq.equals("")){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			}
			cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");
		}else if(_member_no.equals("20160401012")){  // ������Ÿġ ����ȣ �ڵ�ü��
			
			cont_userno = "";
			if(!tempCont.getString("cont_userno").equals("")){
				String temp_cont_userno = tempCont.getString("cont_userno"); 
				if(temp_cont_userno.split("-").length == 4){
					cont_userno = tempCont.getString("cont_userno").substring(0,tempCont.getString("cont_userno").length()-3)+"-"+u.strrpad(cont_chasu, 2, "0");
				}
				if(temp_cont_userno.split("-").length == 3){
					cont_userno = tempCont.getString("cont_userno")+"-"+u.strrpad(cont_chasu, 2, "0");
				}
			}
			
			if(cont_userno.equals("")){
				u.jsError("����ȣ ü���� ���� �Ͽ����ϴ�.\\n\\n�����ͷ� ���� �ϼ���.");
				return;
			}

		}else if(_member_no.equals("20180203437")){//���̿���
			//�������� ������ ���� ����� ����ȣ�� �⺻���� �Ѵ�.
			cont_userno = tempCont.getString("cont_userno");
		}else if(_member_no.equals("20121200073")){
			
		 
			DataObject fieldDao = new DataObject();
			String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
			if("".equals(field_name)){
				u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
				return;
			}
			
			String[] code_logis_deptnm = {"1=>�ÿ�","2=>ü��","3=>����","4=>�׿�","5=>���","6=>MHE","7=>�ַ��","8=>�����","9=>����","10=>���","11=>����",
					"12=>�λ�","13=>����","14=>���","15=>�泲","16=>����","17=>����","18=>����","19=>�泲","20=>ȣ��","21=>�濵","22=>������","23=>����","24=>����1"
					,"25=>����2","26=>�ӿ�","27=>�ѱ�������Ǯ"};

			field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
			
			if("".equals(field_name)){
				u.jsError("�μ� �� ��ϵ��� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����͸� ���� �μ���� ����� ��û���ּ���.");
				return; 
			}
			
			cont_userno = "KLP-"+field_name + "-" + u.getTimeString("yyyy-MM")+"-";
			int substr_pos = cont_userno.length()+1;
			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
			if("".equals(userNoSeq)){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			}
			cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");  
			
		// īī�� Ŀ�ӽ�
		}else if(_member_no.equals("20181201176")){
			cont_userno = contDao.getOne(
					  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '20181201176'                                                                                               "
						);
			cont_userno = u.getTimeString("yyMMdd")+cont_userno;
			
		}else if(_member_no.equals("20191101572")){ //�������(��)
			
			 
			DataObject fieldDao = new DataObject();
			String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
			if("".equals(field_name)){
				u.jsError("�μ��� �������� �ʾ� ����ȣ�� ������ �� �����ϴ�.");
				return;
			}
			
			//  �μ��� ����, ��ȣ �� ���ĺ� : ������(R), â��1����(C), â��2����(J), õ�Ȱ���(N), ��ȯ����(L), ���ձ�����(H) 
			String[] code_logis_deptnm = {"1=>H","3=>R","4=>C","5=>J","6=>N","7=>L","8=>H"};

			field_name = u.getItem(auth.getString("_FIELD_SEQ"), code_logis_deptnm);
			
			if("".equals(field_name)){
				u.jsError("�μ� �� ��ϵ��� �ʾ� ����ȣ�� ������ �� �����ϴ�.\\n�����͸� ���� �μ���� ����� ��û���ּ���.");
				return; 
			}
			
			cont_userno =  field_name + "-" + u.getTimeString("yyyy")+"-";
			
			int substr_pos = cont_userno.length()+1;
			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+substr_pos+"))),0)+1 from tcb_contmaster where member_no = '"+_member_no+"' and cont_userno like '%"+field_name+"%'  " );
			if("".equals(userNoSeq)){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			}
			cont_userno = cont_userno + u.strrpad(userNoSeq, 4, "0");  
			
		}else if(_member_no.equals("20200203416")){ //����̿�����  DR20200001
			cont_userno = contDao.getOne(
					 " select  'DR"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
					+"    from tcb_contmaster                                                                                   "
					+"  where member_no = '"+_member_no+"'                                                                      "
					+"     and cont_userno like 'DR"+u.getTimeString("yyyy")+"%'                                                "
					); 
		}else if(_member_no.equals("20200203478")){ //�������	 
			cont_userno = contDao.getOne( 
					 " select  'DP"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
					+"    from tcb_contmaster                                                                                   "
					+"  where member_no = '"+_member_no+"'                                                                      "
					+"     and cont_userno like 'DP"+u.getTimeString("yyyy")+"%'                                                "
					);  
		}else if(_member_no.equals("20200203481")){ //����������		
			cont_userno = contDao.getOne(
					 " select  'BE"+u.getTimeString("yyyy")+"'|| lpad(nvl(max(substr(cont_userno,7,4)),0)+1,4,'0') as cont_userno "
					+"    from tcb_contmaster                                                                                   "
					+"  where member_no = '"+_member_no+"'                                                                      "
					+"     and cont_userno like 'BE"+u.getTimeString("yyyy")+"%'                                                "
					);  
		// īī�� Ŀ�ӽ�  
		}else {
			cont_userno = cont_no + "-" + cont_chasu;
		}

	}else{
		cont_userno = f.get("cont_userno");
	}

	int file_seq = 1;
	// ��༭���� ����
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",_member_no);
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", random_no);
	pdfInfo.put("cont_userno", cont_userno);
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("file_seq", file_seq++);
	DataSet pdf = cont.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("��༭ ���� ������ ���� �Ͽ����ϴ�.");
		return;
	}
	//�ڵ��������� ����
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(gubun[i].equals("10")) continue;
		if(    gubun[i].equals("20")
			|| ( gubun[i].equals("40") && (arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y"))) // �ڵ����� �����Ǵ� ��� �Ǵ� üũ�� ����� ���
		  )
		{
				DataSet pdfInfo2 = new DataSet();
				pdfInfo2.addRow();
				pdfInfo2.put("member_no",_member_no);
				pdfInfo2.put("cont_no", cont_no);
				pdfInfo2.put("cont_chasu", cont_chasu);
				pdfInfo2.put("random_no", random_no);
				pdfInfo2.put("cont_userno", cont_userno);
				pdfInfo2.put("html", cont_html_rm[i]);
				pdfInfo2.put("file_seq", file_seq++);
				DataSet pdf2 = cont.makePdf(pdfInfo2);
				pdf2.put("cont_sub_name", cont_sub_name[i]);
				autoFiles.add(pdf2);
		}
	}

	//���Ⱓ���ϱ�
	String cont_sdate = f.get("cont_sdate").replaceAll("-","");
	String cont_edate = f.get("cont_edate").replaceAll("-","");;
	if(!f.get("cont_syear").equals("")&&!f.get("cont_smonth").equals("")&&!f.get("cont_sday").equals("")){
		cont_sdate = u.strrpad(f.get("cont_syear"),4,"0")+u.strrpad(f.get("cont_smonth"),2,"0")+u.strrpad(f.get("cont_sday"),2,"0");
	}
	if(!f.get("cont_eyear").equals("")&&!f.get("cont_emonth").equals("")&&!f.get("cont_eday").equals("")){
		cont_edate = u.strrpad(f.get("cont_eyear"),4,"0")+u.strrpad(f.get("cont_emonth"),2,"0")+u.strrpad(f.get("cont_eday"),2,"0");
	}else if(!f.get("cont_term").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("Y",Integer.parseInt(f.get("cont_term")),date,"yyyyMMdd");
	}else if(!f.get("cont_term_month").equals("")){
		Date date = u.addDate("D", -1, u.strToDate("yyyy-MM-dd",f.get("cont_date")));
		cont_sdate = f.get("cont_date").replaceAll("-", "");
		cont_edate = u.addDate("M",Integer.parseInt(f.get("cont_term_month")),date,"yyyyMMdd");
	}

	DB db = new DB();
	//db.setDebug(out);
	cont = new ContractDao();
	cont.item("cont_no", cont_no);
	cont.item("cont_chasu", cont_chasu);
	cont.item("member_no", _member_no);
	cont.item("field_seq", auth.getString("_FIELD_SEQ"));
	cont.item("template_cd", f.get("template_cd"));
	cont.item("cont_name", f.get("cont_name"));
	cont.item("cont_date", f.get("cont_date").replaceAll("-",""));
	cont.item("cont_sdate", cont_sdate);
	cont.item("cont_edate", cont_edate);
	cont.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
	cont.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
	cont.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
	cont.item("cont_total", f.get("cont_total").replaceAll(",",""));
	cont.item("cont_userno", cont_userno);
	cont.item("cont_html", cont_html[0]);
	cont.item("org_cont_html", cont_html[0]);
	cont.item("reg_date", u.getTimeString());
	cont.item("true_random", random_no);
	cont.item("reg_id", auth.getString("_USER_ID"));
	cont.item("status", "10");
	cont.item("change_gubun", f.get("change_gubun"));
	cont.item("bid_kind_cd", tempCont.getString("bid_kind_cd"));
	cont.item("src_cd", tempCont.getString("src_cd"));
	cont.item("stamp_type", f.get("stamp_type"));
	if(template.getString("efile_yn").equals("Y")){
		cont.item("efile_yn", "Y");
	}
	if(isCJT) {
		cont.item("cont_etc1", auth.getString("_DIVISION")); // �ۼ����� �ι�
	}
	cont.item("sign_types", template.getString("sign_types"));
	cont.item("project_seq", tempCont.getString("project_seq"));
	db.setCommand(cont.getInsertQuery(), cont.record);

	for(int i = 1 ; i < cont_html.length; i++) {
		DataObject cont_sub = new DataObject("tcb_cont_sub");
		cont_sub.item("cont_no", cont_no);
		cont_sub.item("cont_chasu", cont_chasu);
		cont_sub.item("sub_seq", i);
		cont_sub.item("cont_sub_html",cont_html[i]);
		cont_sub.item("org_cont_sub_html",cont_html[i]);
		cont_sub.item("cont_sub_name",cont_sub_name[i]);
		cont_sub.item("cont_sub_style",cont_sub_style[i]);
		cont_sub.item("gubun", gubun[i]);
		cont_sub.item("option_yn",arrOption_yn[i]);
		db.setCommand(cont_sub.getInsertQuery(), cont_sub.record);
	}


	// ���� ���� ����
	String[] sign_seq = f.getArr("sign_seq");
	String[] signer_name = f.getArr("signer_name");
	String[] signer_max = f.getArr("signer_max");
	String[] member_type = f.getArr("member_type");
	String[] cust_type  = f.getArr("cust_type");
	for(int i = 0 ; i < sign_seq.length; i ++){
		DataObject cont_sign = new DataObject("tcb_cont_sign");
		cont_sign.item("cont_no",cont_no);
		cont_sign.item("cont_chasu",cont_chasu);
		cont_sign.item("sign_seq", sign_seq[i]);
		cont_sign.item("signer_name", signer_name[i]);
		cont_sign.item("signer_max", signer_max[i]);
		cont_sign.item("member_type", member_type[i]);// 01:���̽��� ����� ��ü 02:���̽� �̰���ü
		cont_sign.item("cust_type", cust_type[i]);// 01:�� 02:��
		db.setCommand(cont_sign.getInsertQuery(), cont_sign.record);
	}

	// ���� ���� ���� ����
	String agree_field_seqs = "";
	String agree_person_ids = "";
	String[] agree_seq = f.getArr("agree_seq");
	int agree_cnt = agree_seq == null? 0: agree_seq.length;
	if(agree_cnt > 0)
	{
		db.setCommand("delete from tcb_cont_agree where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		db.setCommand("delete from tcb_agree_user where template_cd = '"+template_cd+"' and user_id = '"+auth.getString("_USER_ID")+"' ",null);

		String[] agree_name = f.getArr("agree_name");
		String[] agree_field_seq = f.getArr("agree_field_seq");
		String[] agree_person_name = f.getArr("agree_person_name");
		String[] agree_person_id = f.getArr("agree_person_id");
		String[] agree_cd = f.getArr("agree_cd");
		for(int i = 0 ; i < agree_cnt; i ++){
			DataObject cont_agree = new DataObject("tcb_cont_agree");
			cont_agree.item("cont_no",cont_no);
			cont_agree.item("cont_chasu",cont_chasu);
			cont_agree.item("agree_seq", agree_seq[i]);
			cont_agree.item("agree_name", agree_name[i]);
			cont_agree.item("agree_field_seq", agree_field_seq[i]);
			cont_agree.item("agree_person_name", agree_person_name[i]);
			cont_agree.item("agree_person_id", agree_person_id[i]);
			cont_agree.item("agree_cd", agree_cd[i]);	// ���籸���ڵ�(0:��ü������, 1:��ü������)
			db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
			agree_field_seqs += agree_field_seq[i] + "|";
			agree_person_ids += agree_person_id[i] + "|";

			// ���� ���� ���ο� ����
			DataObject cont_agree_user = new DataObject("tcb_agree_user");
			cont_agree_user.item("template_cd", template_cd);
			cont_agree_user.item("user_id", auth.getString("_USER_ID"));
			cont_agree_user.item("agree_seq", agree_seq[i]);
			cont_agree_user.item("agree_name", agree_name[i]);
			cont_agree_user.item("agree_field_seq", agree_field_seq[i]);
			cont_agree_user.item("agree_person_name", agree_person_name[i]);
			cont_agree_user.item("agree_person_id", agree_person_id[i]);
			cont_agree_user.item("agree_cd", agree_cd[i]);	// ���籸���ڵ�(0:��ü������, 1:��ü������)
			db.setCommand(cont_agree_user.getInsertQuery(), cont_agree_user.record);
		}
	}

	// ��ü ����
	String[] member_no = f.getArr("member_no");
	String[] cust_sign_seq = f.getArr("cust_sign_seq");
	String[] vendcd = f.getArr("vendcd");
	String[] member_name = f.getArr("member_name");
	String[] boss_name = f.getArr("boss_name");
	String[] post_code = f.getArr("post_code");
	String[] address = f.getArr("address");
	String[] tel_num = f.getArr("tel_num");
	String[] member_slno = f.getArr("member_slno");
	String[] user_name = f.getArr("user_name");
	String[] hp1 = f.getArr("hp1");
	String[] hp2 = f.getArr("hp2");
	String[] hp3 = f.getArr("hp3");
	String[] email = f.getArr("email");
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] jumin_no = f.getArr("jumin_no");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]);//01:����� 02:����
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		if(cust_gubun[i].equals("01")&&!jumin_no[i].equals("")){  // ���λ���������� ��������� �ִ� ���
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		custDao.item("member_name", member_name[i]);
		custDao.item("boss_name", boss_name[i]);
		custDao.item("post_code", post_code[i].replaceAll("-",""));
		custDao.item("address", address[i]);
		custDao.item("tel_num", tel_num[i]);
		custDao.item("member_slno", member_slno[i].replaceAll("-",""));
		custDao.item("user_name", user_name[i]);
		custDao.item("hp1", hp1[i]);
		custDao.item("hp2", hp2[i]);
		custDao.item("hp3", hp3[i]);
		custDao.item("email", email[i]);
		custDao.item("display_seq", i);
		db.setCommand(custDao.getInsertQuery(), custDao.record);
	}

	db.setCommand(
			 " update tcb_cust "
			+"    set list_cust_yn = decode(display_seq, (select min(display_seq)  from tcb_cust where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and member_no <> '"+_member_no+"' ),'Y') "
			+"  where cont_no = '"+cont_no+"' "
			+"    and cont_chasu = '"+cont_chasu+"' "	 
					,null);


	int cfile_seq_real = 1;
	String file_hash = pdf.getString("file_hash");
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path");
	//��༭�� ����
	DataObject cfileDao = new DataObject("tcb_cfile");
	cfileDao.item("cont_no", cont_no);
	cfileDao.item("cont_chasu", cont_chasu);
	cfileDao.item("cfile_seq", cfile_seq_real++);
	cfileDao.item("doc_name", template.getString("template_name"));
	cfileDao.item("file_path", pdf.getString("file_path"));
	cfileDao.item("file_name", pdf.getString("file_name"));
	cfileDao.item("file_ext", pdf.getString("file_ext"));
	cfileDao.item("file_size", pdf.getString("file_size"));
	cfileDao.item("auto_yn","Y");
	cfileDao.item("auto_type","");
	db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);

	//�ڵ���������
	for(int i=0; i <autoFiles.size(); i ++){
		DataSet temp = (DataSet)autoFiles.get(i);
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq", cfile_seq_real++);
		cfileDao.item("doc_name", temp.getString("cont_sub_name"));
		cfileDao.item("file_path", temp.getString("file_path"));
		cfileDao.item("file_name", temp.getString("file_name"));
		cfileDao.item("file_ext", temp.getString("file_ext"));
		cfileDao.item("file_size", temp.getString("file_size"));
		cfileDao.item("auto_yn","Y");
		if(temp.getString("gubun").equals("50"))	// �ۼ���ü�� ���� �μ��ϴ� ����� �������� �ƴ�.  gubun[i].equals("50")
			cfileDao.item("auto_type", "3");	// ����:�ڵ�����, 1:�ڵ�÷��, 2:�ʼ�÷��, 3:���ο�
		else
		{
			file_hash+="|"+temp.getString("file_hash");
			cfileDao.item("auto_type", "");
		}
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
	}

	String[] cfile_seq = f.getArr("cfile_seq");
	String[] cfile_doc_name = f.getArr("cfile_doc_name");
	String[] cfile_auto_type = f.getArr("cfile_auto_type");
	int cfile_cnt = cfile_doc_name==null? 0 : cfile_doc_name.length;
	for(int i = 0 ;i < cfile_cnt; i ++){
		String cfile_name = "";
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
		cfileDao.item("cfile_seq",cfile_seq_real++);
		cfileDao.item("doc_name", cfile_doc_name[i]);
		cfileDao.item("file_path", pdf.getString("file_path"));
		File attfile = f.saveFileTime("cfile_"+cfile_seq[i]);
		if(attfile == null){
			cfile.first();
			while(cfile.next()){
				if(cfile.getString("cfile_seq").equals(cfile_seq[i])){
					cfileDao.item("file_name", cfile.getString("file_name"));
					cfileDao.item("file_ext", cfile.getString("file_ext"));
					cfileDao.item("file_size", cfile.getString("file_size"));
					String sourceFile = Startup.conf.getString("file.path.bcont_template")+template_cd+"/"+_member_no+"/"+cfile.getString("file_name");
					String targetFile = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path")+cfile.getString("file_name");
					u.copyFile(sourceFile, targetFile);
					cfile_name = cfile.getString("file_name");
				}
			}
		}else{
			cfileDao.item("file_name", attfile.getName());
			cfileDao.item("file_ext", u.getFileExt(attfile.getName()));
			cfileDao.item("file_size", attfile.length());
			cfile_name = attfile.getName();
		}
		if(cfile_name.equals("")){
			u.jsError("���忡 ���� �Ͽ����ϴ�.");
			return;
		}
		cfileDao.item("auto_yn",cfile_auto_type[i].equals("")?"N":"Y");
		cfileDao.item("auto_type", cfile_auto_type[i]);
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		file_hash +="|"+cont.getHash("file.path.bcont_pdf",pdf.getString("file_path")+cfile_name);
	}

	//������
	String[] warr_type = f.getArr("warr_type");
	String[] warr_etc = f.getArr("warr_etc");
	int warr_cnt = warr_type== null? 0: warr_type.length;
	for(int i = 0 ; i < warr_cnt; i ++){
		DataObject warrDao = new DataObject("tcb_warr");
		warrDao.item("cont_no", cont_no);
		warrDao.item("cont_chasu", cont_chasu);
		warrDao.item("member_no", "");
		warrDao.item("warr_seq", i);
		warrDao.item("warr_type", warr_type[i]);
		warrDao.item("etc", warr_etc[i]);
		db.setCommand(warrDao.getInsertQuery(), warrDao.record);
	}

	//���񼭷�
	DataObject rfile_cust = null;
	String[] rfile_seq = f.getArr("rfile_seq");
	String[] attch_yn = f.getArr("attch_yn");
	String[] rfile_doc_name = f.getArr("rfile_doc_name");
	String[] rfile_attch_type = f.getArr("attch_type");
	String[] reg_type = f.getArr("reg_type");
	String[] allow_ext = f.getArr("allow_ext");
	String[] uncheck_text = f.getArr("uncheck_text");
	String[] sample_file_path = f.getArr("sample_file_path");
	String[] sample_file_name = f.getArr("sample_file_name");
	int rfile_cnt = rfile_seq == null? 0: rfile_seq.length;
	for(int i=0 ; i < rfile_cnt; i ++){
		rfileDao = new DataObject("tcb_rfile");
		rfileDao.item("cont_no", cont_no);
		rfileDao.item("cont_chasu", cont_chasu);
		rfileDao.item("rfile_seq", rfile_seq[i]);
		rfileDao.item("attch_yn", attch_yn[i].equals("Y")?"Y":"N");
		rfileDao.item("doc_name", rfile_doc_name[i]);
		rfileDao.item("reg_type", reg_type[i]);
		rfileDao.item("allow_ext", allow_ext[i]);
		rfileDao.item("uncheck_text", uncheck_text[i]);
		rfileDao.item("sample_file_path", sample_file_path[i]);
		rfileDao.item("sample_file_name", sample_file_name[i]);
		db.setCommand(rfileDao.getInsertQuery(), rfileDao.record);

		if(rfile_attch_type[i].equals("2")){//����÷�� �ΰ��
			rfile_cust = new DataObject("tcb_rfile_cust");
			rfile_cust.item("cont_no", cont_no);
			rfile_cust.item("cont_chasu", cont_chasu);
			rfile_cust.item("member_no", _member_no);
			rfile_cust.item("rfile_seq", rfile_seq[i]);
			File file = f.saveFileTime("rfile_"+rfile_seq[i]);
			if(file == null){
				rfile_cust.item("file_path", "");
				rfile_cust.item("file_name", "");
				rfile_cust.item("file_ext", "");
				rfile_cust.item("file_size", "");
				rfile_cust.item("reg_gubun", "");
			}else{
				rfile_cust.item("file_path", pdf.getString("file_path"));
				rfile_cust.item("file_name", file.getName());
				rfile_cust.item("file_ext", u.getFileExt(file.getName()));
				rfile_cust.item("file_size", file.length());
				rfile_cust.item("reg_gubun", "20");
			}
			db.setCommand(rfile_cust.getInsertQuery(), rfile_cust.record);
		}
	}

	
	// ���ΰ�������
	if(template.getString("efile_yn").equals("Y")){
		db.setCommand("delete from tcb_efile where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ",null);
		String[] efile_seq = f.getArr("efile_seq");
		String[] efile_reg_type = f.getArr("efile_reg_type");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		String[] efile_del_yn = f.getArr("efile_del_yn");
		int efile_cnt = efile_seq == null? 0: efile_seq.length;
		for(int i=0 ; i < efile_cnt; i ++){
			efileDao = new DataObject("tcb_efile");
			efileDao.item("cont_no", cont_no);
			efileDao.item("cont_chasu", cont_chasu);
			efileDao.item("efile_seq", efile_seq[i]);
			efileDao.item("doc_name", efile_doc_name[i]);
			File attfile = f.saveFileTime("efile_"+efile_seq[i]);
			String efile_name = "";
			if(attfile == null){
				if(!efile_del_yn[i].equals("Y")){
					efile.first();
					while(efile.next()){
						if(efile_seq[i].equals(efile.getString("efile_seq"))){
							efileDao.item("file_path", pdf.getString("file_path"));
							efileDao.item("file_name", efile.getString("file_name"));
							efileDao.item("file_ext", efile.getString("file_ext"));
							efileDao.item("file_size", efile.getString("file_size"));
							efileDao.item("reg_date", efile.getString("reg_date"));
							efileDao.item("reg_id", efile.getString("reg_id"));
						}
					}	
				}else{
					efileDao.item("file_path", "");
					efileDao.item("file_name", "");
					efileDao.item("file_ext", "");
					efileDao.item("file_size", "");
					efileDao.item("reg_date", efile.getString("reg_date"));
					efileDao.item("reg_id", efile.getString("reg_id"));
				}
				
			}else{
				efileDao.item("file_path", pdf.getString("file_path"));
				efileDao.item("file_name", attfile.getName());
				efileDao.item("file_ext", u.getFileExt(attfile.getName()));
				efileDao.item("file_size", attfile.length());
				efileDao.item("reg_date", u.getTimeString());
				efileDao.item("reg_id", auth.getString("_USER_ID"));
			}
			efileDao.item("reg_type", efile_reg_type[i]);
			db.setCommand(efileDao.getInsertQuery(), efileDao.record);
		}
	}
	
	
	
	// ������
	if(template.getString("stamp_yn").equals("Y")){
		int nStampType = f.getInt("stamp_type");
		for(int i = 0 ; i < member_cnt; i ++){
			if(nStampType==0) break;  // �ش� ���� ����
			if(nStampType==1 && i==1) continue; // ������� ����
			if(nStampType==2 && i==0) continue; // ���޻���� ����
			
			DataObject stampDao = new DataObject("tcb_stamp");
			stampDao.item("cont_no", cont_no);
			stampDao.item("cont_chasu", cont_chasu);
			stampDao.item("member_no", member_no[i]);
			db.setCommand(stampDao.getInsertQuery(), stampDao.record);
		}
	}	
	
	ContractDao cont2 = new ContractDao();
	cont2.item("cont_hash", file_hash);
	if(agree_cnt > 0)
	{
		cont2.item("agree_field_seqs", agree_field_seqs);
		cont2.item("agree_person_ids", agree_person_ids);
	}
	db.setCommand(cont2.getUpdateQuery("cont_no= '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'"), cont2.record);
	
	
	// ��༭ �߰� �Է����� (DBȭ�Ͽ� �˻��� �ʿ��� ���)
	DataObject tempaddDao = new DataObject("tcb_cont_template_add"); 
	DataSet tempaddDs = tempaddDao.find("template_cd = '"+template_cd+"'");
	db.setCommand("delete from tcb_cont_add where cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"'", null);
	
	if(tempaddDs.size()>0){
		DataObject contaddDao = new DataObject("tcb_cont_add"); // Array�� �ƴ� �����ʹ� ������ ������.
		contaddDao.item("cont_no", cont_no);
		contaddDao.item("cont_chasu", cont_chasu);
		contaddDao.item("seq", 1);

		while(tempaddDs.next()){
			if(tempaddDs.getString("mul_yn").equals("Y")) { // ����
				String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));
				String colVal = "";
				for(int i=0; i<colVals.length; i++) {
					colVal += colVals[i] + "|";
				}
				contaddDao.item(tempaddDs.getString("col_name"), colVal);
			} else { // �ܼ�
				contaddDao.item(tempaddDs.getString("col_name"), f.get(tempaddDs.getString("template_name_en")));
			}
			
		}
		db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
	}

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsAlertReplace("�����Ͽ����ϴ�.\\n\\n�ӽ������� �޴��� �̵��մϴ�.","contract_writing_list.jsp?");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_chang_insert");
p.setVar("menu_cd","000058");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000058", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setVar("member", member);
p.setVar("template", template);
p.setLoop("templateSub", templateSub);
p.setLoop("sign_template", signTemplate);
p.setLoop("agreeTemplate", agreeTemplate);
p.setLoop("cust", cust);
p.setLoop("cfile", cfile);
p.setLoop("rfile", rfile);
p.setVar("efile_yn", template.getString("efile_yn").equals("Y"));//���� ���� ���� ��뿩��
p.setLoop("efile", efile);
p.setLoop("code_warr", u.arr2loop(code_warr));
p.setLoop("code_change_gubun", u.arr2loop(code_change_gubun));
p.setVar("tempCont", tempCont);
p.setVar("form_script", f.getScript());
p.setVar("show_cont_user_no", !bAutoContUserNo);  // �׷���, 3m�� ���� ��������ȣ�� ����� ����ȣ�� �����ϹǷ� �Էº������� �ʵ���
p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
p.setVar("view_project", !tempCont.getString("project_seq").equals(""));//���̿���
p.setVar("query", u.getQueryString());
p.display(out);
%>
