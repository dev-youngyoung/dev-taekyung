<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String main_member_no = auth.getString("_MEMBER_NO");
String bid_no = u.request("bid_no");
String bid_deg = u.request("bid_deg");
if (bid_no.equals("")) {
	u.jsError("�������� ��� �����ϼ���.");
	return;
}

String where = "main_member_no = '"+ main_member_no +"' and bid_no = '"+bid_no+"' and bid_deg = '"+bid_deg+"'";

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_bid_status = {"05=>�������","06=>�����Ϸ�"};

DataObject bidDao = new DataObject("tcb_bid_master");
//bidDao.setDebug(out);
DataSet bid = bidDao.find(where+" and status in('05','06')");
if(bid.next()){
	if (!auth.getString("_USER_ID").equals(bid.getString("open_user_id"))) {
		u.jsAlertReplace("�ش� �������� ������ ������ �ƴմϴ�.\\n\\n�α��� ������ Ȯ���ϼ���.", "logout.jsp?" + u.getQueryString());
		return;
	}
} else {
	u.jsError("���������� �����ϴ�.");
	return;
}

//���������
DataObject chargeDao = new DataObject("tcb_bid_charge");
//chargeDao.setDebug(out);
DataSet charge = chargeDao.find(where+" and charge_cd in ('02','03')");
while(charge.next()){
	if(charge.getString("charge_cd").equals("02")){// ���������
		bid.put("bid_charge", charge.getString("charge_name"));
		bid.put("bid_tel_num", charge.getString("tel_num"));
	}
}

bid.put("open_yn", bid.getString("status").equals("06"));

/*����ü*/
DataObject suppDao = new DataObject("tcb_bid_supp a");
int submit_cnt = suppDao.findCount(where+ " and status = '30'");
bid.put("btn_open", bid.getString("status").equals("05")&&submit_cnt> 0 );

DataSet supp = new DataSet();
//������
if(bid.getString("status").equals("05")) {
	supp = suppDao.find(where + "  and a.status not in ('91')", "a.*", " a.display_seq asc");
	while(supp.next()){
		supp.put("vendcd",u.getBizNo(supp.getString("vendcd")));
		if(supp.getString("status").equals("30")){	//	�������������ڵ�[����������]
			supp.put("status_nm","<font color='#75BAFF'><b>����</b></font>");
		}else if(supp.getString("status").equals("92")){	//	�������������ڵ�[��������]
			supp.put("status_nm","<font color='#FF0000'><b>��������</b></font>");
		}else{
			supp.put("status_nm","<font color='#E08036'>������</font>");
		}
		//������ȸ���� '-' ���� ���� ���� data�̴�.
		if(!supp.getString("bid_view_date").equals("-")){
			supp.put("bid_view_date", supp.getString("bid_view_date").equals("")?"��ȸ����":u.getTimeString("yyyy-MM-dd", supp.getString("bid_view_date")));
		}
	}
}

// ������
if(bid.getString("status").equals("06")) {
	p.setVar("open_after_view", true);
	bid.put("vat_info", bid.getString("vat_yn").equals("Y") ? "(VAT����)":"(VAT����)");
	bid.put("btn_esti_comp", bid.getString("item_form_gubun").equals("20"));

	supp = suppDao.find(where + " and a.status not in ('91')","a.*, decode(a.status,'30',1,2) status_order ","status_order asc, a.total_cost asc");
	while(supp.next()){
		supp.put("vendcd",u.getBizNo(supp.getString("vendcd")));
		if(supp.getString("status").equals("30")){	//	�������������ڵ�[����������]
			supp.put("status_nm", "<font color='#75BAFF'><b>"+u.numberFormat(supp.getString("total_cost"))+"&nbsp;</b></font>");
			supp.put("align","right");
		}else if(supp.getString("status").equals("92")){	//	�������������ڵ�[��������]
			supp.put("status_nm","<font color='#FF0000'><b>��������</b></font>");
			supp.put("align","center");
		}else{
			supp.put("status_nm","<font color='#E08036'>������</font>");
			supp.put("align","center");
		}
	}
}

if(u.isPost()&&f.validate()){
	//�������� ���ϱ�
	/*����Ŭ ��ȯ�� random select �̿�*/
	if(bid.getString("expect_gubun").equals("20")&&bid.getString("expect_amt").equals("")){

		/*�������� ��ȣ �ο� START*/
		DB db = new DB();
		DataObject multiAmtDao = new DataObject("tcb_bid_multi_amt");
		DataSet multiAmt = multiAmtDao.find(where,"*", " dbms_random.value");
		int display_seq = 1;
		while(multiAmt.next()){
			multiAmtDao = new DataObject("tcb_bid_multi_amt");
			multiAmtDao.item("display_seq", display_seq);
			db.setCommand(multiAmtDao.getUpdateQuery(where +" and amt_seq = '"+multiAmt.getString("amt_seq")+"' ") , multiAmtDao.record);
			display_seq ++;
		}
		if(!db.executeArray()){
			u.jsError("�������� Ȯ���� ���� �Ͽ����ϴ�.");
			return;
		}

		supp = suppDao.find("main_member_no = '"+bid.getString("main_member_no")+"' and bid_no = '"+bid.getString("bid_no")+"' and bid_deg = '"+bid.getString("bid_deg")+"' and status = '30'");
		int[] select_cnt = new int[multiAmt.size()+1];
		for(int i=1; i <= multiAmt.size(); i ++){
			select_cnt[i] = 0 ;
		}
		while(supp.next()){
			String [] nums = supp.getString("multi_select_num").split(",");
			for(int i =0 ; i < nums.length; i ++){
				select_cnt[Integer.parseInt(nums[i])] = select_cnt[Integer.parseInt(nums[i])]+1;
			}
		}

		db = new DB();
		multiAmt = multiAmtDao.find(" main_member_no = '"+bid.getString("main_member_no")+"' and bid_no = '"+bid.getString("bid_no")+"' and bid_deg = '"+bid.getString("bid_deg")+"'","*"," display_seq asc");
		while(multiAmt.next()){
			multiAmtDao = new DataObject("tcb_bid_multi_amt");
			multiAmtDao.item("select_cnt", select_cnt[multiAmt.getInt("display_seq")]);
			db.setCommand(multiAmtDao.getUpdateQuery("main_member_no = '"+bid.getString("main_member_no")+"' and bid_no = '"+bid.getString("bid_no")+"' and bid_deg = '"+bid.getString("bid_deg")+"' and amt_seq = '"+multiAmt.getString("amt_seq")+"' ") , multiAmtDao.record);
		}
		if(!db.executeArray()){
			u.jsError("�������� Ȯ���� ���� �Ͽ����ϴ�.");
			return;
		}
		/*�������� ��ȣ �ο� END*/

		multiAmt = multiAmtDao.find(" main_member_no = '"+bid.getString("main_member_no")+"' and bid_no = '"+bid.getString("bid_no")+"' and bid_deg = '"+bid.getString("bid_deg")+"'","*"," select_cnt desc, multi_amt asc",4);
		double sum_amt = 0D;
		while(multiAmt.next()){
			sum_amt += multiAmt.getDouble("multi_amt");
		}
		long expect_amt =  (long)Math.ceil(sum_amt / 4) ;//NH���� ���������� ���� �Ѵ�. 20170209
		bidDao = new DataObject("tcb_bid_master");
		bidDao.item("expect_amt",expect_amt);
		if(!bidDao.update(where)){
			u.jsError("�������� Ȯ���� ���� �Ͽ����ϴ�.");
			return;
		}
	}

	DB db = new DB();
	//��������data����
	db.setCommand(	"delete from tcb_bid_suppitem where " + where , null);
	/* ÷���������� ���� */
	db.setCommand(	"delete from tcb_bid_estm_file where "+ where, null);

	Crosscert crosscert	= new Crosscert();
	crosscert.setEncoding("UTF-8");

	supp = suppDao.find(where + "and status = '30'");

	String sEncodeSignData = "";
	String sDecodeSignData = "";

	DataObject suppItem	= null;
	while(supp.next()){
		if(!supp.getString("status").equals("30")){	//	������������ ��ü�� ����
			continue;
		}

		sEncodeSignData = StrUtil.ConfCharset(supp.getString("estm_sign_data"));
		sDecodeSignData = crosscert.decryptData(sEncodeSignData);
		if(sDecodeSignData.indexOf("��")<0){//������ ���� �� base64 ���ڵ� �Ѵ�.
			sDecodeSignData = new String(Base64Coder.decode(sDecodeSignData),"UTF-8");
		}

		String sColumDelimiter = "��";
		String sRowDelimiter = "��";
		String sSumDelimiter = "��";
		String sEncDelimiter = "��";

		System.out.println("sDecodeSignData " + sDecodeSignData);
		String sSector[] = sDecodeSignData.split(sEncDelimiter);

		int i,j;
		// ��������, ���ϰ�� �и�
		String sRows1[]  = sSector[0].split(sRowDelimiter);

		//�ݾ����� ����
		if(bid.getString("item_form_gubun").equals("10")){//�Ѿ� ���� NH���� ������ item_form_cd �� check
			// �Ѿ� ����
			String sTotColumns[] = sRows1[0].split(sSumDelimiter);
			//20120200001��201607003��0��20120600094��10000000
			//����ȸ����ȣ��bid_no��������������üȸ����ȣ�������ݾ�
			if(sTotColumns.length == 5)
			{
				suppDao = new DataObject("tcb_bid_supp");
				suppDao.item("stuff_amt", sTotColumns[4]);
				suppDao.item("total_cost", sTotColumns[4]);
				db.setCommand(suppDao.getUpdateQuery(where + " and member_no = '"+sTotColumns[3]+"'"), suppDao.record);
			}
		}else if(bid.getString("item_form_gubun").equals("20")||(!bid.getString("item_form_cd").equals(""))){// ��������
			// �����ܰ� �Է�
			for(i=0; i<sRows1.length - 1; i++){
				System.out.println("insertEstmItem sRows1["+i+"]: " + sRows1[i]);
				String sColumns1[] = sRows1[i].split(sColumDelimiter);

				if(sColumns1.length == 10)
				{
					suppItem = new DataObject("tcb_bid_suppitem");
					suppItem.item("main_member_no", sColumns1[0]);
					suppItem.item("bid_no", sColumns1[1]);
					suppItem.item("bid_deg", sColumns1[2]);
					suppItem.item("member_no", sColumns1[3]);
					suppItem.item("item_cd", sColumns1[4]);
					suppItem.item("item_cnt", sColumns1[5].equals("undefined")?0:sColumns1[5]);
					suppItem.item("stuff_amt", "NaN".equals(sColumns1[6])?0:sColumns1[6]);
					suppItem.item("labor_amt", sColumns1[7]);
					suppItem.item("upkeep_amt", sColumns1[8]);
					suppItem.item("cost_sum", sColumns1[9]);
					db.setCommand(suppItem.getInsertQuery(), suppItem.record);
				}
			}

			// �Ѿ� ����
			String sTotColumns[] = sRows1[i].split(sSumDelimiter);
			System.out.println("insertEstm �Ѿ�["+i+"]: " + sRows1[i]);
			if(sTotColumns.length == 8)
			{
				suppDao = new DataObject("tcb_bid_supp");
				suppDao.item("stuff_amt", "NaN".equals(sTotColumns[4])?0:sTotColumns[4]);
				suppDao.item("labor_amt", sTotColumns[5]);
				suppDao.item("upkeep_amt", sTotColumns[6]);
				suppDao.item("total_cost", "NaN".equals(sTotColumns[7])?0:sTotColumns[7]);
				db.setCommand(suppDao.getUpdateQuery(where + " and member_no = '"+sTotColumns[3]+"'"), suppDao.record);
			}
		}

		// ���ϰ�� ���
		if(sSector.length > 1){
			String sRows2[]  = sSector[1].split(sRowDelimiter);
			for(int m=0; m<sRows2.length; m++){
				System.out.println("insertEstmFile sRows2["+m+"]: " + sRows2[m]);

				String sColumns2[] = sRows2[m].split(sColumDelimiter);
				System.out.println("insertEstmFile sColumns2.length == 10: " + sColumns2.length );
				if(sColumns2.length == 10){
					f.uploadDir =	Startup.conf.getString("file.path.bid.no_build") +	sColumns2[7];

					// ���� �̸��� �ð����ϸ����� ����
					String sOrgFile = f.uploadDir + "/" + sColumns2[5];
					String sTimeFileName = sColumns2[4] + u.getUploadFileName(sColumns2[5]);
					String sNewFile = f.uploadDir + "/" + sTimeFileName;
					System.out.println("���Ϻ���");
					u.copyFile(sOrgFile, sNewFile);
					if(!(new File(sNewFile).exists())){
						u.jsError("��ü�� ������ �ʼ� ÷�������� ������� �ʾҽ��ϴ�.\\n\\n�����ͷ� �����ϼ���.");
						return;
					}

					DataObject suppFile = new DataObject("tcb_bid_estm_file");
					suppFile.item("main_member_no",	sColumns2[0]);
					suppFile.item("bid_no", sColumns2[1]);
					suppFile.item("bid_deg", sColumns2[2]);
					suppFile.item("member_no", sColumns2[3]);
					suppFile.item("seq", sColumns2[4]);
					suppFile.item("file_name", sTimeFileName);
					suppFile.item("doc_name", sColumns2[6]);
					suppFile.item("file_path", sColumns2[7]);
					suppFile.item("file_ext", sColumns2[8]);
					suppFile.item("file_size", sColumns2[9]);
					db.setCommand(suppFile.getInsertQuery(), suppFile.record);
				}
			}
		}
	}

	bidDao = new DataObject("tcb_bid_master");
	bidDao.item("open_date",u.getTimeString());
	bidDao.item("status","06");
	db.setCommand(bidDao.getUpdateQuery( where ), bidDao.record);
	if(!db.executeArray()){
		u.jsError("ó���� ������ �߻� �Ͽ����ϴ�.");
		return;
	}

	//��������ڿ��� �����Ϸ� ���� ������
	bidDao = new DataObject(" tcb_bid_master a");
	bid = bidDao.find(where,"a.*,(select user_name from tcb_person where member_no = a.main_member_no and user_id = a.open_user_id) open_user_name");
	if(!bid.next()){}
	bid.put("bid_date", u.getTimeString("yyyy-MM-dd", bid.getString("bid_date")));
	bid.put("open_date", u.getTimeString("yyyy-MM-dd", bid.getString("open_date")));
	bid.put("submit_sdate", u.getTimeString("yyyy-MM-dd HH:mm", bid.getString("submit_sdate")));
	bid.put("submit_edate", u.getTimeString("yyyy-MM-dd HH:mm", bid.getString("submit_edate")));

	DataObject personDao = new DataObject("tcb_person");
	DataSet bidCharge= personDao.find(" member_no = '"+_member_no+"' and user_id = '"+bid.getString("reg_id")+"'");
	if(!bidCharge.next()){}
	p.clear();
	p.setVar("bid", bid);
	p.setVar("to_bid_charge", true);
	String mail_body = p.fetch("../html/mail/bid_in_noti_mail.html");
	u.mail(bidCharge.getString("email"), "[���̽���ť]�������� ���� �����ڰ� ������ �Ͽ����ϴ�.", mail_body );

	u.jsAlertReplace("�ش��������� ������ �Ϸ��Ͽ����ϴ�.","bid_open_view.jsp?" + u.getQueryString());
	return;
}

p.setLayout("mobile");
//p.setDebug(out);
p.setBody("m.bid_open_view");
p.setVar("rebid", Integer.parseInt(bid_deg)>0);
p.setLoop("supp", supp);
//p.setVar("auth_select", _authDao.getAuthMenuInfoK(_member_no, auth.getString("_AUTH_CD"), "000018", "btn_auth").equals("10"));
p.setVar("open_able",bid.getString("open_user_id").equals(auth.getString("_USER_ID"))&& Long.parseLong(bid.getString("submit_edate"))<Long.parseLong(u.getTimeString()) );
bid.put("bid_date", u.getTimeString("yyyy-MM-dd", bid.getString("bid_date")));
bid.put("submit_edate", u.getTimeString("yyyy-MM-dd HH:mm", bid.getString("submit_edate")));
p.setVar("bid",bid);
p.setVar("query", u.getQueryString());
p.setVar("form_script", f.getScript());
p.display(out);
%>