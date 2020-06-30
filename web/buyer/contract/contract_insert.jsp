<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
// ���� �̿� �Ⱓ üũ
DataObject useinfoDao = new DataObject("tcb_useinfo");
DataSet useinfo = useinfoDao.find("member_no='"+_member_no+"' and usestartday <='"+u.getTimeString("yyyyMMdd")+"' and useendday>='"+u.getTimeString("yyyyMMdd")+"' ");
if( !useinfo.next() )
{
	u.jsError("���� �̿�Ⱓ�� ���� �Ǿ����ϴ�.\\n\\n���̽���ť ������[02-788-9097]�� �����ϼ���.");
	return;
}

Security	security	=	new	Security();

String template_cd = u.request("template_cd");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
String supp_member_no = u.request("supp_member_no");
if(template_cd.equals("")){
	u.jsError("�������� ��η� ���� �ϼ���.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("����� ������ ���� ���� �ʽ��ϴ�.");
	return;
}

DataSet cont = new DataSet();
cont.addRow();
cont.put("view_project", u.inArray(_member_no, new String[]{"20180203437","20180800860","20160401012"}));
cont.put("btn_select_project", true);
// ����� ����ȣ �ڵ� ���� ����
// ����� ����ȣ �ڵ� ���� ����
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
				,"20131000506"	//�����������̽����ֽ�ȸ��
				,"20190205651"	//���λ�� �ֽ�ȸ��
				,"20190205653"	//�̼���� �ֽ�ȸ��
				,"20190205654"	//(��) ����������
				,"20190205649"	//������� (��)
				,"20190205652"	//���밳���ֽ�ȸ��
				,"20190300598"	//�����������
				,"20190600117"	//�����Ǿ���Ʈ����
				,"20191101572"  //�������(��)
				,"20200203416"  //����̿�����
				,"20200203478"  //�������
				,"20200203481"  //�������(��)
				}
);
if(_member_no.equals("20150900434") && !template_cd.equals("2015106")) // ������۽��� ��ǰ���ް�༭ �ܴ� �ڵ�ä�� �ƴ�.
	bAutoContUserNo = false;


// īī���� �������Ŀ��� �߰� ������ �Է��� �� �ִ� ����� ����
boolean bIsKakao = u.inArray(_member_no, new String[]{"20130900194","20181201176"});
boolean isCJT = u.inArray(_member_no, new String[]{"20130400333"}); // CJ�������

// �������� ��ȸ
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
if(!template.next()){
}

// �߰� �������� ��ȸ
DataObject templateSubDao = new DataObject("tcb_cont_template_sub");
DataSet templateSub= templateSubDao.find("template_cd ='"+template_cd+"'", "*", "sub_seq");
while(templateSub.next()){
	templateSub.put("hidden", u.inArray(templateSub.getString("gubun"), new String[]{"20","30"}) );
	if(templateSub.getString("option_yn").equals("A")) // �ڵ� �����ؾ� �ϴ� ���
		templateSub.put("option_yn", false);

}

// �������� ��ȸ
DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'","*","sign_seq asc");
String default_sign_seq = "";
while(signTemplate.next()){
	if(signTemplate.getString("cust_type").equals("01"))   // cust_type -  01:��, 02:��, 00:���뺸��      member_type - 01:�ۼ���ü, 02:���ž�ü
	default_sign_seq = signTemplate.getString("sign_seq");
}

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
DataSet rfile = rfileDao.find("template_cd = '"+template_cd+"' and member_no ='"+_member_no+"'", "*"," rfile_seq asc");
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
		rfile.put("attch_disabled_btn", "");
		rfile.put("attch_disabled","");
		rfile.put("doc_name_class", "");
		rfile.put("doc_name_readonly", "");
		rfile.put("del_btn_yn", true);
	}
}


//���� ���� ���� ��ȸ
String[] code_reg_type = {"10=><span class='caution-text'>�ʼ�÷��</span>","20=>����÷��","30=>�߰�÷��"};
DataObject efileDao = new DataObject("tcb_efile_template");
DataSet efile = new DataSet();
if(template.getString("efile_yn").equals("Y")){
	efile = efileDao.find(" template_cd = '"+template_cd+"' and member_no = '"+_member_no+"' ");
	while(efile.next()){
		efile.put("str_reg_type", u.getItem(efile.getString("reg_type"), code_reg_type));
		efile.put("required", u.inArray(efile.getString("reg_type"), new String[]{"10","30"})?"required='Y'":"");
		efile.put("doc_name_readonly", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"readonly":"");
		efile.put("doc_name_class", u.inArray(efile.getString("reg_type"), new String[]{"10","20"})?"in_readonly":"label");
	}
}



// ����� ���� ��ȸ
memberDao = new DataObject("tcb_member");
DataSet cust = memberDao.query(
 "	select a.member_no, a.vendcd, a.post_code, a.member_slno, a.address, a.member_name, a.boss_name, "
+"	       b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq, b.division, b.position"
+"	     , (select field_name from tcb_field where member_no = '"+_member_no+"' and field_seq = b.field_seq) as field_name "
+"	  from tcb_member a, tcb_person b "
+"	 where a.member_no = b.member_no "
+"	  and a.member_no = '"+_member_no+"' "
+"	  and b.person_seq = '"+auth.getString("_PERSON_SEQ")+"'	 "
);
if(!cust.next()){
	u.jsError("����� ������ ���� ���� �ʽ��ϴ�.");
	return;
}
cust.put("sign_seq", default_sign_seq);


// �������� �˻�
DataSet bid = new DataSet();
if(!bid_no.equals("")&&!bid_deg.equals("")){
	DataObject bidDao = new DataObject("tcb_bid_master");
	//bidDao.setDebug(out);
	bid = bidDao.query(
		"select a.main_member_no, a.bid_no, a.bid_deg, a.bid_html, b.member_no, b.total_cost, a.bid_kind_cd, a.src_cd "
	+   "      ,(select src_nm from tcb_src_adm where member_no = a.main_member_no and substr(src_cd,0,3) = substr(a.src_cd,0,3) and depth = '1') l_src_nm"
	+   "      ,(select src_nm from tcb_src_adm where member_no = a.main_member_no and substr(src_cd,0,6) = substr(a.src_cd,0,6) and depth = '2') m_src_nm"
	+   "      ,(select src_nm from tcb_src_adm where member_no = a.main_member_no and src_cd = a.src_cd and depth = '3') s_src_nm"
	+   "      ,a.project_seq "
	+	"  from tcb_bid_master a, tcb_bid_supp b "
	+	" where a.main_member_no = b.main_member_no "
	+	"	and a.bid_no = b.bid_no "
	+	"	and a.bid_deg = b.bid_deg "
	+	"	and a.status = '07'"
	+	"	and b.bid_succ_yn = 'Y'"
	+	"   and a.main_member_no = '"+_member_no+"'"
	+	"	and a.bid_no = '"+bid_no+"'"
	+	"	and a.bid_deg = '"+bid_deg+"' "
	+   "   and b.member_no = '"+supp_member_no+"'"
	);
	if(!bid.next()){
	}
	if(!bid.getString("src_cd").equals(""))
	bid.put("src_nm", bid.getString("l_src_nm")+" > "+bid.getString("m_src_nm")+" > "+bid.getString("s_src_nm"));

	DataSet supp = bidDao.query(
		 " select a.member_no               "
		+"      , a.vendcd                  "
		+"      , a.post_code               "
		+"      , a.member_slno             "
		+"      , 2 sign_seq                "
		+"      , a.address                 "
		+"      , a.member_name             "
		+"      , a.boss_name               "
		+"      , a.category                "
		+"      , b.user_name               "
		+"      , b.tel_num                 "
		+"      , b.email                   "
		+"      , b.hp1                     "
		+"      , b.hp2                     "
		+"      , b.hp3                     "
		+"  from tcb_member a, tcb_person b "
		+" where a.member_no = b.member_no  "
		+"   and b.default_yn = 'Y'         "
		+"   and a.member_no = '"+bid.getString("member_no")+"' "
	);
	if(!supp.next()){
		u.jsError("������ü ������ �������� �ʽ��ϴ�.");
		return;
	}
	cust.addRow(supp.getRow());

	
	if(!bid.getString("project_seq").equals("")){
		DataObject projectDao = new DataObject("tcb_project");
		DataSet project  = projectDao.find(" member_no = '"+_member_no+"' and project_seq = '"+bid.getString("project_seq")+"' ");
		if(project.next()){
			cont.put("project_seq", project.getString("project_seq"));
			cont.put("project_name", project.getString("project_name"));
			cont.put("project_cd", project.getString("project_cd"));
			cont.put("btn_select_project", false);
		}
	}
	
}

if(u.inArray(_member_no, new String[]{"20121203661","20130400011","20130400010","20130400009","20130400008"})){//�ѱ��������� ���ĸ��� ��������
	f.addElement("cont_name",template.getString("template_name"), "hname:'����', required:'Y'");
}else{
	f.addElement("cont_name",null, "hname:'����', required:'Y'");
}
f.addElement("cont_date", null, "hname:'�������', required:'Y'");

if(template.getString("stamp_yn").equals("Y")){
	f.addElement("stamp_type", null, "hname:'������ ���� ���', required:'Y'");
}

f.addElement("cont_userno", null, "hname:'����ȣ', maxbyte:'40'");
if(!member.getString("src_depth").equals(""))
f.addElement("src_cd", bid.getString("src_cd"), "hname:'�ҽ̱׷�'");

if(bIsKakao) {
	f.addElement("cont_etc1", null, "hname:'���ͽ���', maxbyte:'255'");
	f.addElement("cont_etc2", null, "hname:'�絵/����'");
	f.addElement("cont_etc3", null, "hname:'��Ÿ����', maxbyte:'255'");
}


if(u.isPost()&&f.validate()){

	response.setHeader("Cache-Control", "no-Cache, no-store, must-revalidate");
	//��༭ ����
	ContractDao contDao = new ContractDao();

	String cont_no = contDao.makeContNo();
	int cont_chasu = 0;
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

	int file_seq = 1;
	
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
		}else if(_member_no.equals("20160401012")){  // ������Ÿġ ����ȣ �ڵ�ü��  (������Ÿġ -> ��ũ�ν� ���;ؿ�����) 
			String[] wUserNo = {"2016141=>GA","2016053=>CU","2016054=>GA","2016055=>PO","2016056=>PU","2018030=>PU","2018149=>CA","2018228=>SU","2018062=>PU","2018160=>PU","2020118=>GA","2020127=>BU"};
			String temp = u.getItem(template_cd, wUserNo);  
			if(temp.equals("")){
				u.jsError("����ȣ ü�� ��Ģ�� ���� ���� �ʾҽ��ϴ�.");
				return;
			}
			String sHeader = "TWE-" + u.getTimeString("yyyy")+"-"+u.getTimeString("MM")+ temp; 
			int pos = sHeader.length();
 
			String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),99)+1 from tcb_contmaster where member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
			//String userNoSeq = contDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),99)+1 from tcb_contmaster where member_no = '"+_member_no+"'  and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
			if(userNoSeq.equals("")){
				u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
				return;
			} 
			cont_userno =sHeader+u.strrpad(userNoSeq, 3, "0");

		}else if(_member_no.equals("20180203437")){//���̿��� 
			String[] template_gubun1 = {
					"2018063"//�뿪��༭
					,"2018064"//�ڹ���༭
					,"2018065"//��⹰ó����Ź��༭
					,"2018066"//��⹰ó����Ź��༭
					,"2018072"//����Ʈ����(�ý���) ���̼��� ���
					,"2019192"//�������� ���� �� �м� �뿪��༭
					,"2019199"//(������) �����ϾȰ������ ǥ���ϵ��ް�༭
					,"2020117" //�ǰ�������༭ 
			};// TES-0000(�⵵)-00(��)-001~100 0 ���� �μ�
			String[] template_gubun2 = {
					 "2018062"//��ǰ���� ��༭
					,"2018074"//�Ǽ����� ǥ���ϵ��ް�༭
					,"2018075"//���(��Ÿ������) ǥ���ϵ��� �⺻��༭
					,"2019202" //(������)ȭ�о��� ǥ���ϵ��� �⺻��༭
			};//TES-0000(�⵵)-00(��)-101~200 100�� �� ���� ���翡 ���� �ǰ� ������ ������� ü�Է� �׳� ���ڴٰ� ��. 18181818
			String[] template_gubun3 = {
				 "2018061"//�����ϵ��ް�༭
				,"2018073"//�Ǽ����� ǥ���ϵ��ް�༭
				,"2019200" //(������)���������� ǥ���ϵ��ް�༭
				,"2019201" //(������)�ؿܰǼ����� ǥ���ϵ��ް�༭
				,"2019235" //������༭
			};//TES-0000(�⵵)-00(��)-201~300
			String query = "";
			if(u.inArray(template_cd, template_gubun1)){
				query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-0'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
						+"   from tcb_contmaster                                                                                                           "
						+"  where member_no = '20180203437'                                                                                                "
						+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-0%'                                           ";
			}
			if(u.inArray(template_cd, template_gubun2)){
				query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-1'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
						+"   from tcb_contmaster                                                                                                           "
						+"  where member_no = '20180203437'                                                                                                "
						+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-1%'                                           ";
			}
			if(u.inArray(template_cd, template_gubun3)){
				query =  " select 'TES-"+u.getTimeString("yyyy-MM")+"-2'||lpad(nvl(max(to_number(substr(cont_userno,14,2))),0)+1,2,'0')||'-00' cont_userno "
						+"   from tcb_contmaster                                                                                                           "
						+"  where member_no = '20180203437'                                                                                                "
						+"    and cont_userno like 'TES-"+u.getTimeString("yyyy-MM")+"-2%'                                           ";
			}
			if(!query.equals("")){
				cont_userno = contDao.getOne(query);
			}
			
		}else if(_member_no.equals("20121200073")){
			
			DataObject fieldDao = new DataObject();
			String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
			if("".equals(field_name) ){
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
		
		}else if(_member_no.equals("20181201176")){// īī�� Ŀ�ӽ�
			cont_userno = contDao.getOne(
					  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '20181201176'                                                                                               "
						);
			cont_userno = u.getTimeString("yyMMdd")+cont_userno;//��ü ��û�������� �Ϸù�ȣ ������ ���� ����.
		
		}else if(_member_no.equals("20131000506")){//�����������̽����ֽ�ȸ��
			cont_userno = contDao.getOne(
					  " select  lpad(nvl(max(substr(cont_userno,9,5)),0)+1,5,'0') as cont_userno "
					 +"   from tcb_contmaster                                                                                                          "
					 +"  where member_no = '20131000506'                                                                                               "
					 +"    and length(cont_userno) = 13 "
					 +"    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-"+"%'  "
						);
			cont_userno = u.getTimeString("yyyy-MM")+"-"+cont_userno;
			
		}else if(_member_no.equals("20190300598")){	//�����������
			if("2019240".equals(template_cd)|| "2019151".equals(template_cd)|| "2020068".equals(template_cd)){	// ��� : ��ȭ ������ ���� ��༭(���ο�) <-> ��ȭ ������ ���� ��༭(����)(template_cd:2019151)  �� ������ ��Ģ 
				
				// 2019-07-MHKCON-0001
				
				cont_userno = contDao.getOne(
						  " select  '"+u.getTimeString("yyyy-MM")+"-MHKCON-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
						 +"   from tcb_contmaster                                                                                                          "
						 +"  where member_no = '"+_member_no+"'                                                                                               "
						 +"   and template_cd in( '2019151','2019240','2020068')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKCON-%'"
							);
			}else if("2019290".equals(template_cd)){ //�������� ǥ�ذ�༭  2019-08-MHKFRE-0001 (�⵵-��- MHKFRE-���� )
				cont_userno = contDao.getOne(
						  " select  '"+u.getTimeString("yyyy-MM")+"-MHKFRE-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
						 +"   from tcb_contmaster                                                                                                          "
						 +"  where member_no = '"+_member_no+"'                                                                                               "
						 +"   and template_cd in( '2019290')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKFRE-%'"
							); 
			
			}else if("2020106".equals(template_cd)){ //�Ŵ�����Ʈ ���� ��༭ (�⵵-��¥-MHKMAG-0001 )  
				cont_userno = contDao.getOne(
						  " select  '"+u.getTimeString("yyyy-MM")+"-MHKMAG-' || lpad(nvl(max(to_number(substr(cont_userno,16,5))),0)+1,4,'0') as cont_userno "
						 +"   from tcb_contmaster                                                                                                          "
						 +"  where member_no = '"+_member_no+"'                                                                                               "
						 +"   and template_cd in( '2020106')    and cont_userno like '"+u.getTimeString("yyyy-MM")+"-MHKMAG-%'"
							); 
			}else{
				bAutoContUserNo = false;
			}
			
		}else if("20190600117".equals(_member_no)) {
			
			String cont_text = "'PG-'";
			if("2019173".equals(template.getString("template_cd"))){
				cont_text = "'AG-'";
			} 
			
			cont_userno = contDao.getOne(
				  " select  "+cont_text+"  ||  '"+u.getTimeString("yyMM")+"-' || lpad(nvl(max(to_number(substr(cont_userno,10,3))),0)+1,2,'0') as cont_userno "
				 +"   from tcb_contmaster                                                                                                          "
				 +"  where member_no = '"+_member_no+"'                                                                                               "
				 +"   and template_cd in( '"+template.getString("template_cd")+"')    and cont_userno like  "+cont_text+" ||  '"+u.getTimeString("yyMM")+"-%'"
			);
		
		}else if(_member_no.equals("20191101572")){ //�������(��)
			
			DataObject fieldDao = new DataObject();
			String field_name = fieldDao.getOne("select field_name from tcb_field where member_no='"+_member_no+"' and field_seq="+auth.getString("_FIELD_SEQ"));
			if("".equals(field_name) ){
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
		}else{	
			cont_userno = cont_no + "-" + cont_chasu;
		}

	}else{
		cont_userno = f.get("cont_userno");
	}

	// ��༭���� ����
	DataSet pdfInfo = new DataSet();
	pdfInfo.addRow();
	pdfInfo.put("member_no",_member_no);
	pdfInfo.put("cont_no", cont_no);
	pdfInfo.put("cont_chasu", cont_chasu);
	pdfInfo.put("random_no", random_no);
	pdfInfo.put("cont_userno", cont_userno);
	pdfInfo.put("html", cont_html_rm_str);
	pdfInfo.put("doc_type", template.getString("doc_type"));
	pdfInfo.put("file_seq", file_seq++);

	DataSet pdf = contDao.makePdf(pdfInfo);
	if(pdf==null){
		u.jsError("��༭ ���� ������ ���� �Ͽ����ϴ�.");
		return;
	}
	//�ڵ��������� ����
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(gubun[i].equals("10")) continue;
		if(    gubun[i].equals("20")
			|| gubun[i].equals("50")  // �ۼ���ü�� ���� �μ��ϴ� ���(������ X)
			|| ( gubun[i].equals("40") && (arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) ) // �ڵ����� �����Ǵ� ��� �Ǵ� üũ�� ����� ���
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
				pdfInfo2.put("doc_type", template.getString("doc_type"));
				pdfInfo2.put("file_seq", file_seq++);
				DataSet pdf2 = contDao.makePdf(pdfInfo2);
				pdf2.put("cont_sub_name", cont_sub_name[i]);
				pdf2.put("gubun", gubun[i]);
				autoFiles.add(pdf2);
		}
	}


	//���Ⱓ���ϱ�
	String cont_sdate = f.get("cont_sdate").replaceAll("-","");
	String cont_edate = f.get("cont_edate").replaceAll("-","");
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
	if(cont_sdate.equals("") && !cont_edate.equals(""))
		cont_sdate = f.get("cont_date").replaceAll("-","");

	DB db = new DB();
	//db.setDebug(out);
	contDao = new ContractDao();
	contDao.item("cont_no", cont_no);
	contDao.item("cont_chasu", cont_chasu);
	contDao.item("member_no", _member_no);
	contDao.item("field_seq", auth.getString("_FIELD_SEQ"));
	contDao.item("template_cd", f.get("template_cd"));
	contDao.item("cont_name", f.get("cont_name"));
	contDao.item("cont_date", f.get("cont_date").replaceAll("-",""));
	contDao.item("cont_sdate", cont_sdate);
	contDao.item("cont_edate", cont_edate);
	contDao.item("supp_tax", f.get("supp_tax").replaceAll(",",""));
	contDao.item("supp_taxfree", f.get("supp_taxfree").replaceAll(",",""));
	contDao.item("supp_vat", f.get("supp_vat").replaceAll(",",""));
	contDao.item("cont_total", f.get("cont_total").replaceAll(",",""));
	contDao.item("cont_userno", cont_userno);
	contDao.item("cont_html", cont_html[0]);
	contDao.item("org_cont_html", cont_html[0]);
	contDao.item("reg_date", u.getTimeString());
	contDao.item("true_random", random_no);
	contDao.item("reg_id", auth.getString("_USER_ID"));
	contDao.item("status", "10");
	contDao.item("version_seq", template.getString("version_seq"));
	if(template.getString("efile_yn").equals("Y")){
		contDao.item("efile_yn", "Y");
	}
	if(!bid_no.equals("")&&!bid_deg.equals("")){
	contDao.item("bid_kind_cd", bid.getString("bid_kind_cd"));
	contDao.item("bid_no", bid_no);
	contDao.item("bid_deg", bid_deg);
	}
	contDao.item("src_cd", f.get("src_cd"));
	contDao.item("stamp_type", f.get("stamp_type"));
	contDao.item("project_seq", f.get("project_seq"));
	if(bIsKakao) {
		contDao.item("cont_etc1", f.get("cont_etc1"));
		contDao.item("cont_etc2", f.get("cont_etc2"));
		contDao.item("cont_etc3", f.get("cont_etc3"));
	}
	else if(isCJT) {
		contDao.item("cont_etc1", auth.getString("_DIVISION")); // �ۼ����� �ι�
	}
	else if(!f.get("cont_etc1").equals("")) {
		contDao.item("cont_etc1", f.get("cont_etc1"));
	}

	db.setCommand(contDao.getInsertQuery(), contDao.record);

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
			cont_agree.item("ag_md_date", "");
			cont_agree.item("mod_reason", "");
			cont_agree.item("r_agree_person_id","");
			cont_agree.item("r_agree_person_name", "");
			cont_agree.item("agree_cd", agree_cd[i]);	// ���籸���ڵ�(0:��ü������, 1:��ü������)
			db.setCommand(cont_agree.getInsertQuery(), cont_agree.record);
			if(0==i){
				agree_field_seqs += "|";
			}
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
	String[] jumin_no = f.getArr("jumin_no");
	String[] member_gubun = f.getArr("member_gubun");  // 01:����(����), 02:����(����), 03:���λ����
	String[] cust_gubun = f.getArr("cust_gubun");
	String[] cust_detail_code = f.getArr("cust_detail_code");
	int member_cnt = member_no == null? 0: member_no.length;
	for(int i = 0 ; i < member_cnt; i ++){
		signTemplate.first();
		while(signTemplate.next()){
			if(signTemplate.getString("sign_seq").equals(cust_sign_seq[i])){
				break;
			}
		}
		DataObject custDao = new DataObject("tcb_cust");
		custDao.item("cont_no", cont_no);
		custDao.item("cont_chasu",cont_chasu);
		custDao.item("member_no",member_no[i]);
		custDao.item("sign_seq", cust_sign_seq[i]);
		custDao.item("cust_gubun", cust_gubun[i]);//01:����� 02:����
		custDao.item("vendcd", vendcd[i].replaceAll("-",""));
		if(cust_gubun[i].equals("02")&&!jumin_no[i].equals("")){
			custDao.item("jumin_no", security.AESencrypt(jumin_no[i].replaceAll("-","")));
		}
		if(member_gubun[i].equals("03")&&!jumin_no[i].equals("")){  // ���λ���������� ��������� �ִ� ���
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
		custDao.item("cust_detail_code", cust_detail_code[i]);
		if(signTemplate.getString("pay_yn").equals("Y")){
			custDao.item("pay_yn","Y");
		}
		db.setCommand(custDao.getInsertQuery(), custDao.record);

		// �ҽ�ī�װ��� �����ϴ� ��ü�� ��༭ �ۼ��� �ҽ̱׷� ������ �Ǿ� �ִٸ� �ۼ��� ������ �ҽ� �׷����� �ҽ� ������ �Է��Ѵ�. (��, �ҽ� �׷��� 1����ü�� �������� ������ �� �����Ƿ� insert�� �Ѵ�.)
		if( !member.getString("src_depth").equals("") && !f.get("src_cd").equals("") && !member_no[i].equals(_member_no) )
		{
			DataObject srcDao = new DataObject("tcb_src_member");
			if(srcDao.findCount("member_no='"+_member_no+"' and src_member_no='"+member_no[i]+"' and src_cd='"+f.get("src_cd")+"'") == 0)
			{
				srcDao.item("member_no", _member_no);
				srcDao.item("src_member_no", member_no[i]);
				srcDao.item("src_cd",f.get("src_cd"));
				db.setCommand(srcDao.getInsertQuery(), srcDao.record);
			}
		}
	}

	// ���뺸�� ��ü ����
	for(int i = 1 ; i <= 20; i ++){
		String member_name_y = f.get("op_member_name_"+i);	// �̸�

		if(!member_name_y.equals(""))
		{
			String vendcd_y = f.get("op_vendcd_cd1_"+i)+f.get("op_vendcd_cd2_"+i)+f.get("op_vendcd_cd3_"+i);	// ����ڹ�ȣ
			String birthday_y = f.get("op_birthday_"+i);		// �������
			String gender_y = f.get("op_gender_"+i);			// ����
			String address_y = f.get("op_address_"+i);			// �ּ�
			String boss_name_y = f.get("op_boss_name_"+i);		// ��ǥ�ڸ�
			String tel_num_y = f.get("op_telnum_"+i);			// ����ó(�޴���)
			String email_y = f.get("op_email_"+i);				// �̸���

			DataObject custDaoA = new DataObject("tcb_cust");
			custDaoA.item("cont_no", cont_no);
			custDaoA.item("cont_chasu", cont_chasu);
			custDaoA.item("member_no", Util.strrpad(""+i, 11, "0")); // ���뺸������ 0 10�ڸ��� ����
			custDaoA.item("sign_seq", 10+i);			// ������� (���뺸������ 10���� ����)

			if(!birthday_y.equals("")){
				System.out.println("gender_y : " + gender_y);
				if(!gender_y.equals("")) birthday_y += gender_y;
				if(birthday_y.indexOf("-")>0)  // 2014-12-12 ����
					custDaoA.item("jumin_no", security.AESencrypt(birthday_y.replaceAll("-","").substring(2)));
				else // 741212 ����
					custDaoA.item("jumin_no", security.AESencrypt(birthday_y));

				custDaoA.item("cust_gubun", "02");	// ����(������)
			} else {
				custDaoA.item("vendcd", vendcd_y);
				custDaoA.item("cust_gubun", "01");	// �����(������)
			}
			custDaoA.item("member_name", member_name_y);
			custDaoA.item("boss_name", boss_name_y);
			custDaoA.item("address", address_y);
			custDaoA.item("tel_num", tel_num_y);
			custDaoA.item("user_name", member_name_y);
			custDaoA.item("email", email_y);
			//custDaoA.item("display_seq", i);				// ����(�������� ������ ����)
			db.setCommand(custDaoA.getInsertQuery(), custDaoA.record);
		}
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
	cfileDao.item("auto_type", "");
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

	System.out.println("cfile_cnt : " + cfile_cnt);
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
		file_hash +="|"+contDao.getHash("file.path.bcont_pdf",pdf.getString("file_path")+cfile_name);
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
		String[] efile_seq = f.getArr("efile_seq");
		String[] efile_reg_type = f.getArr("efile_reg_type");
		String[] efile_doc_name = f.getArr("efile_doc_name");
		int efile_cnt = efile_seq == null? 0: efile_seq.length;
		for(int i=0 ; i < efile_cnt; i ++){
			efileDao = new DataObject("tcb_efile");
			efileDao.item("cont_no", cont_no);
			efileDao.item("cont_chasu", cont_chasu);
			efileDao.item("efile_seq", efile_seq[i]);
			efileDao.item("doc_name", efile_doc_name[i]);
			File attfile = f.saveFileTime("efile_"+efile_seq[i]);
			if(attfile != null){
				efileDao.item("file_path", pdf.getString("file_path"));
				efileDao.item("file_name", attfile.getName());
				efileDao.item("file_ext", u.getFileExt(attfile.getName()));
				efileDao.item("file_size", attfile.length());
			}
			efileDao.item("reg_type", efile_reg_type[i]);
			efileDao.item("reg_date", u.getTimeString());
			efileDao.item("reg_id", auth.getString("_USER_ID"));
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

	if((!bid_no.equals(""))&&!bid_deg.equals("")&&!supp_member_no.equals("")){
		DataObject bidSuppDao = new DataObject("tcb_bid_supp");
		bidSuppDao.item("cont_no", cont_no);
		db.setCommand(bidSuppDao.getUpdateQuery("main_member_no = '"+_member_no+"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"' and member_no = '"+supp_member_no+"'"),bidSuppDao.record);
	}

	// ��༭ �߰� �Է����� (DBȭ�Ͽ� �˻��� �ʿ��� ���)
	DataObject tempaddDao = new DataObject("tcb_cont_template_add");
	DataSet tempaddDs = tempaddDao.find("template_cd = '"+template_cd+"'", "template_name_en,col_name,mul_yn");

	if(tempaddDs.size()>0){
		DataObject contaddDao = new DataObject("tcb_cont_add"); // Array�� �ƴ� �����ʹ� ������ ������.
		contaddDao.item("cont_no", cont_no);
		contaddDao.item("cont_chasu", cont_chasu);
		contaddDao.item("seq", 1);

		while(tempaddDs.next()){
			if(tempaddDs.getString("mul_yn").equals("Y")) { // ����
				String[] colVals = f.getArr(tempaddDs.getString("template_name_en"));

				System.out.println("template_name_en : " + tempaddDs.getString("template_name_en"));
				System.out.println("colVals.length : " + colVals.length);
				int cnt = colVals == null? 0 : colVals.length;
				String colVal = "";
				for(int i=0; i< cnt ; i++) {
					colVal += colVals[i] + "|";
				}
				contaddDao.item(tempaddDs.getString("col_name"), colVal);
			} else { // �ܼ�
				contaddDao.item(tempaddDs.getString("col_name"), f.get(tempaddDs.getString("template_name_en")));
			}

		}
		db.setCommand(contaddDao.getInsertQuery(), contaddDao.record);
	}

	/* ���α� START*/
	ContBLogDao logDao = new ContBLogDao();
	logDao.setInsert(db, cont_no,  String.valueOf(cont_chasu),  auth.getString("_MEMBER_NO"), auth.getString("_PERSON_SEQ"), auth.getString("_USER_NAME"), request.getRemoteAddr(), "���ڹ��� ����",  "", "10","10");
	/* ���α� END*/

	if(!db.executeArray()){
		u.jsError("���忡 ���� �Ͽ����ϴ�.");
		return;
	}
	u.jsAlertReplace("���� �Ͽ����ϴ�.\\n\\n�ӽ������� �޴��� �̵��մϴ�.","contract_writing_list.jsp?");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_modify");
p.setVar("menu_cd","000053");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000053", "btn_auth").equals("10"));
p.setVar("modify", false);
p.setVar("cont", cont);
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
p.setVar("bid", bid);
p.setVar("supp_member_no", supp_member_no);
p.setVar("kakao", bIsKakao);
p.setVar("detail_person", _member_no.equals("20121000046"));   // �ķ�Ʈ���� ����� �������� ǥ��
p.setVar("form_script", f.getScript());
p.setVar("show_cont_user_no", !bAutoContUserNo);  // �׷���, 3m�� ���� ��������ȣ�� ����� ����ȣ�� �����ϹǷ� �Էº������� �ʵ���
//�η��İ߾�ü�� ���񼭷��� ������ ���� ÷�� �Ҽ� �ִ�.
//needs�� ��غ�� �ŷ��ϴ� ���� ��ü�� �̿��� ���α׷��� ���� �ʰ� �ϵ� �ڵ��� needs�� ����� ���α׷����� gogo~~!
p.setVar("btn_rfile", u.inArray(_member_no, new String[]{"20120400013","20120400014","20120400016","20120400018","20120400019","20121100029","20121100031","20140100807","20140100855"}));

String[] ktmns_etc = {"2014060=>[����/����]+��������+��ü��+(�����ڵ�)+'�ű� ���'<br>�� (ex) [��������]���������� ����ڷ���(1000023456) �ű� ���"
        ,"2014089=>[����/����]+��������+��ü��+(�����ڵ�)+'�ŷ��簳 ���� ���'<br>�� (ex) [��������]���������� ����ڷ���(1000023456) �ŷ��簳 ���� ���"
        ,"2014087=>[����/����]+��������+��ü��+(�����ڵ�)+'��ø�� ä���μ� ���'<br>�� (ex) [��������]���������� ����ڷ���(1000023456) ��ø�� ä���μ� ���"
        };
p.setVar("ktmns_etc", u.getItem(template_cd, ktmns_etc));

p.setVar("warr_yn", template.getString("warr_yn").equals("")||template.getString("warr_yn").equals("Y"));
p.display(out);
%>
