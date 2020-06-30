<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%!
	public static String cutString(String str, int len) throws Exception {
		try  {
			byte[] by = str.getBytes("KSC5601");
			if(by.length <= len) return str;
			int count = 0;
			for(int i = 0; i < len; i++) {
				if((by[i] & 0x80) == 0x80) count++;
			}
			if((by[len - 1] & 0x80) == 0x80 && (count % 2) == 1) len--;
			len = len - (int)(count / 2);
			return str.substring(0, len);
		} catch(Exception e) {
			return "";
		}
	}
%>
<%
	String[] tcode;
	String _member_no = "";
	String template_cd = "";

	try {

		System.out.println("-- ��û�� ���� ���� --");
		System.out.println("tcode["+u.request("tcode")+"]");
		tcode = u.aseDec(u.request("tcode")).split("\\|");
		_member_no = tcode[0];
		template_cd = tcode[1];
		System.out.println("_member_no["+_member_no+"]");
		System.out.println("template_cd["+template_cd+"]");

		if(_member_no.equals("")||template_cd.equals("")||!u.isPost()){
			u.jsAlert("�������� ��η� ���� �ϼ���.");
			return;
		}
	}
	catch(Exception e)
	{
		u.jsAlert("�������� ��η� ���� �ϼ���.");
		return;
	}

//�������� ��ȸ
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
		u.jsAlert("�������� ��η� ���� �ϼ���.");
		return;
	}

	DataObject signTemplateDao = new DataObject("tcb_cont_sign_template");
	DataSet signTemplate = signTemplateDao.find(" template_cd = '"+template_cd+"'","*","sign_seq asc");
	if(!signTemplate.next()){
		u.jsAlert("�������� ��η� ���� �ϼ���.");
		return;
	}

//������ ���� ��ȸ
	DataObject recvDao = new DataObject("tcb_subscription");
	DataSet recv_user = recvDao.query(
			"	select b.user_id, c.member_no, c.vendcd, c.post_code, c.member_slno, c.address, c.member_name, c.boss_name, c.member_gubun"
					+"	        ,b.user_name, b.email ,b.tel_num, b.hp1, b.hp2,b.hp3, b.field_seq, b.division "
					+"	  from tcb_subscription a "
					+"	       inner join tcb_person b on a.recv_userid=b.user_id "
					+"	       inner join tcb_member c on b.member_no=c.member_no "
					+"	 where a.template_cd = '"+ template_cd +"'"
	);
	if(!recv_user.next()){
		u.jsAlert("������ ������ �������� �ʽ��ϴ�.");
		return;
	}

// ���� üũ (�˾����� �̵�)
/*
	String bankName = f.get("c_bankname"); // �����
	String bankNo = f.get("c_bankno").trim(); // ���¹�ȣ
	String bankUser = f.get("c_bankuser").trim(); // �����ָ�

	if(!bankName.equals("") && !bankNo.equals("") && !bankUser.equals(""))
	{
		String[] bankCode = {"�ѱ�����=>001","�������=>002","�������=>003","��������=>004","�ϳ�(��ȯ)����=>005","�����߾�ȸ=>007","����������=>008","�����߾�ȸ=>011","����ȸ������=>012","�츮����=>020","SC��������=>023","�ѱ���Ƽ����=>027","�뱸����=>031","�λ�����=>032","��������=>034","��������=>035","��������=>037","�泲����=>039","�������ݰ���ȸ=>045","�����߾�ȸ=>048","��ȣ��������=>050","��ǽ��ĸ�����=>052","HSBC����=>054","����ġ����=>055","���̺񿣾Ϸ�����=>056","�����Ǹ�ü�̽�����=>057","����ȣ���۷���Ʈ����=>058","�̾���õ���UFJ����=>059","BOA=>060","������ź� ��ü��=>071","�ſ뺸�����=>076","����ſ뺸�����=>077","�ϳ�����=>081","��������=>088","�ѱ����ñ�������=>093","���ﺸ������=>094","����û=>095","����������=>099","�������ձ�������=>209","��������=>218","�̷���������=>230","�������=>238","�Ｚ����=>240","�ѱ���������=>243","�츮��������=>247","��������=>261","������������=>262","����ġ������������=>263","Ű������=>264","��Ʈ���̵�����=>265","������������=>266","�������=>267","�ַθ���������=>268","��ȭ����=>269","�ϳ���������=>270","�¸�׽�������=>278","��������=>279","������������=>280","�޸�������=>287","������ġ��������=>289","�α�����=>290","�ſ�����=>291","����������������=>292"};

		Http hp = new Http();
		hp.setEncoding("euc-kr");
		hp.setUrl("https://web.nicepay.co.kr/api/checkBankAccountAPI.jsp");
		hp.setParam("mid", "nicedocu1m");
		hp.setParam("merchantKey", "Q1h4Zo1gtPrDVGU/6kWxb/4j0oCIAaYJAO35vM/huB4FLWOszTRVTSdxG64kat2QC4qhcpp9zOXTW03xbsovwA==");
		hp.setParam("inAccount", bankNo);

		System.out.println("bankName : " + bankName);
		System.out.println("bankCode : " + u.getItem(bankName, bankCode));

		hp.setParam("inBankCode", u.getItem(bankName, bankCode));
		String ret = hp.sendHTTPS();
		// ������ : PG=NICE|respCode=0000|errMsg=����ó��|receiverName=������|NICE=PG|RegDate=20171025
		// ���н� : PG=NICE|respCode=V454|errMsg=�ش���¿���|receiverName=|NICE=PG|RegDate=20171025

		String[] retArr = ret.split("\\|");
		DataSet retBank = new DataSet();
		retBank.addRow();
		for(int i=0; i<retArr.length; i++) {
			String[] tmp = retArr[i].split("=");
			retBank.put(tmp[0], tmp.length==2 ? tmp[1] : "");
		}
		System.out.println("[respCode]"+retBank.getString("respCode"));
		System.out.println("[receiverName]"+retBank.getString("receiverName"));
		System.out.println("[bankUser]"+cutString(bankUser,16));

		if(!retBank.getString("respCode").equals("0000")) {
			u.jsAlert("���� ������ �ùٸ��� �ʽ��ϴ�.["+retBank.getString("errMsg")+"]");
			return;
		}
		if(!cutString(retBank.getString("receiverName"),16).equals(cutString(bankUser,16))) {  // ���� ������� 16byte�� ����
			u.jsAlert("������ �����ڸ��� ��ġ���� �ʽ��ϴ�.");
			return;
		}
	}
*/

//��༭ ����
	ContractDao cont = new ContractDao();

	boolean isModify = false;
	String cont_no = "";
	int cont_chasu = 0;
	String random_no = "";
	if(f.get("cont_no").equals("") && f.get("cont_chasu").equals("") && f.get("random_no").equals("")) {
		cont_no = cont.makeContNo();
		cont_chasu = 0;
		random_no = Util.strpad(u.getRandInt(0,99999)+"",5,"0");
	} else {
		cont_no = f.get("cont_no");
		cont_chasu = f.getInt("cont_chasu");
		random_no = f.get("random_no");
		isModify = true;

		// ��û �� �ٽ� ���� ��ư �������� Ȯ��(��ǻ�Ͱ� ������ 2�� �����ô� ���� �ֳ� �̤�)
		DataSet chkDuplicate = cont.find("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu, "status");
		if(chkDuplicate.getString("status").equals("30")) {  // ��û���̸� ����
			System.out.println("isDuplicate: �ߺ� ���� �߻�");
		    return;
		}
	}

	System.out.println("isModify : " + isModify);
	System.out.println("cont_no : " + cont_no);
	System.out.println("cont_chasu : " + cont_chasu);
	System.out.println("random_no : " + random_no);


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
		if(gubun[i].equals("10")){
			cont_html_rm_str += cont_html_rm[i];
		}
	}
	System.out.println("cont_html_rm.length : " + cont_html_rm.length);


	String cont_userno = "";
	if(_member_no.equals("20120600068")){  // ���̽����̸���
		String[] wUserNo = {"2012014=>kspo", "2017331=>nhome", "2018168=>makesoho","2019266=>hspo","2020172=>imweb1","2020173=>imweb2"};

		String sHeader = u.getItem(template_cd, wUserNo)+"-"+u.getTimeString("yyyyMMdd")+"-";
		int pos = sHeader.length();
 
		DataObject tmpDao = new DataObject();
		String userNoSeq = tmpDao.getOne("select nvl(max(to_number(substr(cont_userno,"+(pos+1)+"))),0)+1 from tcb_contmaster where status<>'00' and member_no = '"+_member_no+"' and template_cd = '"+template_cd+"' and substr(cont_userno,0,"+pos+")='"+sHeader+"'");
		if(userNoSeq.equals("")){
			u.jsError("����ȣ ������ ���� �Ͽ����ϴ�.");
			return;
		}
		cont_userno =sHeader+u.strrpad(userNoSeq, 4, "0");
		System.out.println("cont_userno["+cont_userno+"]");
	}


	ArrayList autoFiles = new ArrayList();
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
	pdfInfo.put("doc_type", "3");
	pdfInfo.put("file_seq", file_seq++);

	DataSet pdf = cont.makePdf(pdfInfo);
	if(pdf==null){
		u.jsAlert("��༭ ���� ������ ���� �Ͽ����ϴ�.");
		return;
	}

//�ڵ��������� ����
	for(int i = 0 ; i < cont_html_rm.length; i ++){
		if(    gubun[i].equals("20")
				|| gubun[i].equals("50")  // �ۼ���ü�� ���� �μ��ϴ� ���(������ X)
				|| ( gubun[i].equals("40") && arrOption_yn[i].equals("A") || arrOption_yn[i].equals("Y")) // �ڵ����� �����Ǵ� ��� �Ǵ� üũ�� ����� ���
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
			DataSet pdf2 = cont.makePdf(pdfInfo2);
			pdf2.put("cont_sub_name", cont_sub_name[i]);
			pdf2.put("gubun", gubun[i]);
			autoFiles.add(pdf2);
		}
	}


	DB db = new DB();
//db.setDebug(out);

	cont = new ContractDao();
	cont.item("cont_no", cont_no);
	cont.item("cont_chasu", cont_chasu);
	cont.item("member_no", _member_no);
	cont.item("true_random", random_no);
	cont.item("template_cd", template_cd);
	cont.item("cont_userno", cont_userno);
	cont.item("subscription_yn", "Y");
	if(!isModify) { // �ݷ��� ��� ���°��� �ٲ��� �ʴ´�.
		cont.item("status", "00"); // �ӽ�����
	}
	cont.item("reg_date", Util.getTimeString());
	if(isModify)
		db.setCommand(cont.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu), cont.record);
	else
		db.setCommand(cont.getInsertQuery(), cont.record);

	int cfile_seq_real = 1;
	String file_hash = pdf.getString("file_hash");
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+pdf.getString("file_path");
//��༭�� ����
	DataObject cfileDao = new DataObject("tcb_cfile");
	cfileDao.item("cont_no", cont_no);
	cfileDao.item("cont_chasu", cont_chasu);
	cfileDao.item("doc_name", template.getString("template_name"));
	cfileDao.item("file_path", pdf.getString("file_path"));
	cfileDao.item("file_name", pdf.getString("file_name"));
	cfileDao.item("file_ext", pdf.getString("file_ext"));
	cfileDao.item("file_size", pdf.getString("file_size"));
	cfileDao.item("auto_yn","Y");
	cfileDao.item("auto_type", "");
	if(isModify) {
		db.setCommand(cfileDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and cfile_seq="+cfile_seq_real++), cfileDao.record);
	} else {
		cfileDao.item("cfile_seq", cfile_seq_real++);
		db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
	}

//�ڵ���������
	for(int i=0; i <autoFiles.size(); i ++){
		DataSet temp = (DataSet)autoFiles.get(i);
		cfileDao = new DataObject("tcb_cfile");
		cfileDao.item("cont_no", cont_no);
		cfileDao.item("cont_chasu", cont_chasu);
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
		if(isModify) {
			db.setCommand(cfileDao.getUpdateQuery("cont_no='"+cont_no+"' and cont_chasu="+cont_chasu+" and cfile_seq="+cfile_seq_real++), cfileDao.record);
		} else {
			cfileDao.item("cfile_seq", cfile_seq_real++);
			db.setCommand(cfileDao.getInsertQuery(), cfileDao.record);
		}
	}

	if(!db.executeArray()){
		u.jsAlert("��û�� ������ ���� �Ͽ����ϴ�.");
		return;
	}

	System.out.println("file_hash : " + file_hash);
	System.out.println("random_no : " + random_no);

	out.println("<script>");
	out.println("var f = parent.document.forms['form1'];");
	out.println("f['cont_hash'].value='"+file_hash+"';");
	out.println("f['cont_no'].value='"+cont_no+"';");
	out.println("f['cont_chasu'].value='"+cont_chasu+"';");
	out.println("f['random_no'].value='"+random_no+"';");
	out.println("parent.fSign();");
	out.println("</script>");

%>