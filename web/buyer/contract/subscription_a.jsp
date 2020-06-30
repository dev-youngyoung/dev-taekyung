<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
	/*
    ��ȿ�� URL���� Ȯ�� �ʿ�

    ���URL�� [���� ȸ����ȣ + "|" + ����ڵ�]�� AES ��ȣȭ�ؼ� ����, �ɼ����� ���� ���� URL�� ���ߴ� ��ȵ� ���
    �� : http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=566c5baac06349aef96234e0a4b39bfc91b1917129c916bb4075dd76bb01916f
 	SDD��û�� 
  	NICEPAY �����������̿�� �̿��û�� (2012014)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=689663dfeeb0441e795e80a2e03fdf2e11e6be24e09a3ae6772099a5167a7f5d
  	NICEPAY ��ǥ��༭ (2017331)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=1dcdd471686090c83a6d90ca0d67412b053531eb22aacd61066714d5c3655ec4
  	NICEPAY ��༭ makeshop(soho) (2018168)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=566c5baac06349aef96234e0a4b39bfc91b1917129c916bb4075dd76bb01916f
  	Link ADX ���� ���� ��û��
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de2780556973b41ce434a38c146c458d60c6075f
  	Linkprice ���� ���� ��û��
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de278055fc7c24b1c7af372b5828ca69389ffcb7

  	NICEPAY ��������_�Ľ��� (2019129)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312fe341bfd111fd19cd19c1c95d665fa4dd

  	NICEPAY ����ιٿ�ó ���ڰ�༭ (2019266)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312f4f2dd4aa162b0ec44eeaf97be56c762e
	
 	NICE������� ���̽����� ���� ���� ��û�� (2019285)   20171100802
	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=f457a0124c5a4d0f042a0ecd4c9d630a35c1c8d49e60948c19e422d18141ad5b
	  
	
	
    */
	String[] tcode;
	String _member_no = "";
	String template_cd = "";

	try {
		tcode = u.aseDec(u.request("tcode")).split("\\|");
		_member_no = tcode[0];
		template_cd = tcode[1];
		System.out.println("tcode["+tcode+"]");
		System.out.println("_member_no["+_member_no+"]");
		System.out.println("template_cd["+template_cd+"]");

		if(_member_no.equals("")||template_cd.equals("")){
			u.jsError("�������� ��η� ���� �ϼ���.");
			return;
		}
	}
	catch(Exception e)
	{
		u.jsError("�������� ��η� ���� �ϼ���.");
		return;
	}

	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(!member.next()){
		u.jsError("�������� ��η� ���� �ϼ���.");
		return;
	}

//�������� ��ȸ
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
		u.jsError("�������� ��η� ���� �ϼ���.");
		return;
	}
	

	f.addElement("dc_info_check", null, "hname:'�����ĺ����� ó���� ���� ����', required:'Y'");
	f.addElement("vendcd1", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y', minbyte:3, maxlength:3");
	f.addElement("vendcd2", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y', minbyte:2, maxlength:2");
	f.addElement("vendcd3", null, "hname:'����ڵ�Ϲ�ȣ', required:'Y', minbyte:5, maxlength:5");

	if(u.isPost() && f.validate()){

		String vendcd = f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3");

		if(!u.inArray(template_cd, new String[] {"2017331", "2018168","2020172","2020173","2020202"})) // �ߺ���û ��� (��ǥ��༭) 
		{
			DataObject contDao = new DataObject("tcb_contmaster tm inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu");
			DataSet cont = contDao.find("tm.subscription_yn='Y' and tm.template_cd='" + template_cd + "' and tc.vendcd='" + vendcd + "'");

			if (cont.next()) {
				u.jsError("�̹� ��û�� ��û���� �ֽ��ϴ�.");
				return;
			}
		} 

		u.redirect("subscription.jsp?"+u.getQueryString()+"&vendcd="+vendcd);

		return;
	}

	p.setLayout("subscription");
//p.setDebug(out);
	p.setBody("contract.subscription_a");
	p.setVar("member_name", member.getString("member_name"));
	p.setVar("template", template);
	p.setVar("template_name", template.getString("template_name"));
	p.setVar("query", u.getQueryString());
	p.setVar("form_script", f.getScript());
	p.display(out);
%>