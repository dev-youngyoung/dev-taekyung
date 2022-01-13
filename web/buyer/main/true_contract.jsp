<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %><%


f.addElement("cont_no", null, "hname:'관리번호', required:'Y', maxbyte:'11'");
f.addElement("cont_chasu", null, "hname:'관리번호', required:'Y', maxbyte:'2'");
f.addElement("true_random", null, "hname:'관리번호', required:'Y', maxbyte:'5'");

if(u.isPost() && f.validate())
{
	DataObject pDao = new DataObject("tcb_contmaster cont INNER JOIN tcb_cust cust ON cont.cont_no = cust.cont_no AND cont.cont_chasu = cust.cont_chasu and cont.member_no = cust.member_no");

	pDao.setFields("cont.cont_no"			// 계약관리번호
					+",cont.cont_chasu"		// 변경차수
					+",cont.cont_name"		// 계약명
					+",cont.cont_date"		// 계약일자 (yyyyMMdd)
					+",cont.status"			// 계약진행상태 코드
					+",cust.member_name first_cust_name"			// 원사업자 업체명
					+",(SELECT member_name"
					+"	FROM tcb_cust"
					+"	WHERE cont_no = cont.cont_no"
					+"	  AND cont_chasu = cont.cont_chasu"
					+"	  AND display_seq = (select max(display_seq) from tcb_cust where cont_no = cont.cont_no AND cont_chasu = cont.cont_chasu and member_no <> cont.member_no)"
					+" ) second_cust_name"  // 수급사업자 업체명
					);
					
	DataSet ds = pDao.find("cont.cont_no='" + f.get("cont_no") + "' and cont.cont_chasu = '"+ f.get("cont_chasu") +"' and cont.true_random = '" + f.get("true_random") + "'");

	if(!ds.next()){
		u.jsError("해당 계약이 존재하지 않습니다.");
		return;
	}
	
	String msg = "";
	CodeDao code = new CodeDao("tcb_comcode");
	String[] status_code = code.getCodeArray("M008");	// 계약진행상태 코드	
	String status_name = u.getItem(ds.getString("status"), status_code);
	if(status_name.equals(""))
		msg = "이 계약은 <b><font color=\"red\">[폐기된]</font></b> 계약입니다.";
	else
		msg = "전자계약으로 <b><font color=\"blue\">["+u.getItem(ds.getString("status"), status_code)+"]</font></b>인 계약서 입니다.";
	
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")) );
	p.setVar("ds", ds);
	p.setVar("msg", msg);
}

p.setLayout("popup");
//p.setDebug(out);
p.setBody("main.true_contract");
p.setVar("popup_title","전자계약 진위확인");
p.setVar("form_script",f.getScript());
p.display(out);
%>