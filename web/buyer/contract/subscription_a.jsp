<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="../init.jsp" %>
<%
	/*
    유효한 URL인지 확인 필요

    양식URL은 [갑사 회원번호 + "|" + 양식코드]를 AES 암호화해서 배포, 옵션으로 구글 단축 URL로 감추는 방안도 고려
    예 : http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=566c5baac06349aef96234e0a4b39bfc91b1917129c916bb4075dd76bb01916f
 	SDD신청서 
  	NICEPAY 스포츠강좌이용권 이용신청서 (2012014)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=689663dfeeb0441e795e80a2e03fdf2e11e6be24e09a3ae6772099a5167a7f5d
  	NICEPAY 대표계약서 (2017331)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=1dcdd471686090c83a6d90ca0d67412b053531eb22aacd61066714d5c3655ec4
  	NICEPAY 계약서 makeshop(soho) (2018168)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=566c5baac06349aef96234e0a4b39bfc91b1917129c916bb4075dd76bb01916f
  	Link ADX 광고 게재 신청서
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de2780556973b41ce434a38c146c458d60c6075f
  	Linkprice 광고 게재 신청서
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=05e88916f7d63f28587b9994de278055fc7c24b1c7af372b5828ca69389ffcb7

  	NICEPAY 가맹점용_식스샵 (2019129)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312fe341bfd111fd19cd19c1c95d665fa4dd

  	NICEPAY 장애인바우처 전자계약서 (2019266)
  	http://www.nicedocu.com/web/buyer/contract/subscription_a.jsp?tcode=ba7f45089f3a9517b85097a35521312f4f2dd4aa162b0ec44eeaf97be56c762e
	
 	NICE정보통신 나이스오더 서비스 가입 신청서 (2019285)   20171100802
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
			u.jsError("정상적인 경로로 접근 하세요.");
			return;
		}
	}
	catch(Exception e)
	{
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}

	DataObject memberDao = new DataObject("tcb_member");
	DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
	if(!member.next()){
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}

//서식정보 조회
	DataObject templateDao = new DataObject("tcb_cont_template");
	DataSet template= templateDao.find(" status > 0 and template_cd ='"+template_cd+"'");
	if(!template.next()){
		u.jsError("정상적인 경로로 접근 하세요.");
		return;
	}
	

	f.addElement("dc_info_check", null, "hname:'고유식별정보 처리에 대한 동의', required:'Y'");
	f.addElement("vendcd1", null, "hname:'사업자등록번호', required:'Y', minbyte:3, maxlength:3");
	f.addElement("vendcd2", null, "hname:'사업자등록번호', required:'Y', minbyte:2, maxlength:2");
	f.addElement("vendcd3", null, "hname:'사업자등록번호', required:'Y', minbyte:5, maxlength:5");

	if(u.isPost() && f.validate()){

		String vendcd = f.get("vendcd1") + f.get("vendcd2") + f.get("vendcd3");

		if(!u.inArray(template_cd, new String[] {"2017331", "2018168","2020172","2020173","2020202"})) // 중복신청 허용 (대표계약서) 
		{
			DataObject contDao = new DataObject("tcb_contmaster tm inner join tcb_cust tc on tm.cont_no=tc.cont_no and tm.cont_chasu=tc.cont_chasu");
			DataSet cont = contDao.find("tm.subscription_yn='Y' and tm.template_cd='" + template_cd + "' and tc.vendcd='" + vendcd + "'");

			if (cont.next()) {
				u.jsError("이미 신청한 신청서가 있습니다.");
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