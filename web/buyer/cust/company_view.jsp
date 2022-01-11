<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String member_no = u.request("member_no"); // 원사업자 회원번호
if(member_no.equals("")){
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

String member_slno1= "";
String member_slno2= "";


DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find(" member_no = '"+member_no+"' ");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}
member.put("vendcd", u.getBizNo(member.getString("vendcd")));
member.put("member_gubun_name", u.getItem(member.getString("member_gubun"),code_member_gubun));
if(member.getString("member_slno").length()==13){
	member_slno1= member.getString("member_slno").substring(0,6);
	member_slno2= member.getString("member_slno").substring(6);
	member.put("member_slno", member_slno1+" - "+member_slno2);
}
member.put("post_code", member.getString("post_code").trim());

DataObject personDao = new DataObject("tcb_person");
DataSet person = personDao.find(" member_no = '"+member_no+"'", "*"," person_seq asc ");


DataObject clientDao = new DataObject("tcb_client");
DataSet client = clientDao.find("member_no = '"+member_no+"' and client_no = '"+_member_no+"' ");
if(!client.next()){
	u.jsError("등록된 거래처가 아닙니다.");
	return;
}


DataObject rfileDao = new DataObject();
String rfileQuery = "  select a.attch_yn, a.doc_name, a.rfile_seq, a.allow_ext, b.file_path, b.file_name, b.file_ext, b.file_size, b.member_no "
		+"    from tcb_client_rfile_template a  "
		+"    left outer join  tcb_client_rfile b "
		+"      on a.member_no = b.member_no  "
		+"     and a.rfile_seq = b.rfile_seq  "
		+"     and b.client_no = '"+_member_no+"'"
		+"   where a.member_no = '"+member_no+"'";

//rfileDao.setDebug(out);
DataSet rfile = rfileDao.query(rfileQuery);
while(rfile.next()){
	rfile.put("attch", rfile.getString("attch_yn").equals("Y")?"checked":"");
	rfile.put("file_size", u.getFileSize(rfile.getLong("file_size")));
}

//NH투자증권 협력업체>등록업체 전환 신청
DataSet recruitNoti = new DataSet();
if(!client.getString("client_type").equals("1")&&!client.getString("status").equals("10")){
	if(member_no.equals("20160901598")){
		DataObject notiDao = new DataObject("tcb_recruit_noti");
		recruitNoti  = notiDao.find("member_no = '20160901598' and req_sdate <= '"+u.getTimeString("yyyyMMdd")+"' and req_edate >= '"+u.getTimeString("yyyyMMdd")+"' and status = '10'");
		if(recruitNoti.next()){
			String[] code_status = {"10=>임시저장","20=>신청중","30=>수정요청","31=>수정신청","40=>심사완료","50=>완료"};
			DataObject recruitCustDao = new DataObject("tcb_recruit_cust");
			DataSet recruitCust = recruitCustDao.find("member_no = '20160901598' and noti_seq = '"+recruitNoti.getString("noti_seq")+"' and client_no = '"+_member_no+"' ");
			if(recruitCust.next()){
				if(u.inArray(recruitCust.getString("status"), new String[]{"10","20","30","31"})   ){
					String btn = " <button type=\"button\" class=\"btn color\" onclick=\"OpenWindows('pop_nhqv_recruit_req.jsp?noti_seq="+recruitNoti.getString("noti_seq")+"','pop_nhqv_recruit_req','1000','700');\">등록업체전환신청서("+u.getItem(recruitCust.getString("status"), code_status)+")</button>";
					recruitNoti.put("btn", btn);
				}
			}else{
				String btn = " <button type=\"button\" class=\"btn color\" onclick=\"OpenWindows('pop_nhqv_recruit_req.jsp?noti_seq="+recruitNoti.getString("noti_seq")+"','pop_nhqv_recruit_req','1000','700');\">등록업체전환평가신청</button>";
				recruitNoti.put("btn", btn);
			}
		}
	}
}

if(u.isPost()&& f.validate()){
	
	
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("cust.company_view");
p.setVar("menu_cd","000099");
p.setVar("member",member);
p.setLoop("rfile", rfile);
p.setVar("btn_reg_doc", u.inArray(member_no, new String[]{"20151101243"})&&client.getString("client_reg_cd").equals("1"));//농협네트웍스 정식등록업체만
p.setVar("recruitNoti", recruitNoti);
p.setVar("list", u.getQueryString("member_no"));
p.setVar("query", u.getQueryString());
p.setVar("form_script", f.getScript());
p.display(out);
%>