<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu");
String warr_seq = u.request("warr_seq");
String sign_member_no = u.request("sign_member_no");
if(cont_no.equals("")||cont_chasu.equals("")||warr_seq.equals("")||sign_member_no.equals("")){
	u.jsErrClose("정상적인 경로로 접근해 주세요.");
	return;
}
String _member_no = sign_member_no;

CodeDao code = new CodeDao("tcb_comcode");
String[] code_warr = code.getCodeArray("M007");
String[] code_office = code.getCodeArray("C104");
String fileDir = "";

ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cont.next()){
	u.jsError("계약정보가 존재하지 않습니다.");
	return;
}

DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
if(!cfile.next()){
	u.jsError("계약서류 저장위치가 없습니다.");
	return;
}else{
	fileDir = cfile.getString("file_path");
}

DataObject warrDao = new DataObject("tcb_warr");
DataSet warr = warrDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ");
if(!warr.next()){
	u.jsError("보증정보가 존재 하지 않습니다.");
	return;
}
warr.put("warr_type_name", u.getItem(warr.getString("warr_type"),code_warr));
warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
warr.put("file_size", u.getFileSize(warr.getLong("file_size")));


f.addElement("warr_office", warr.getString("warr_office"), "hname:'발급기관', required:'Y'");
f.addElement("warr_no", warr.getString("warr_no"), "hname:'증권번호', required:'Y'");
f.addElement("warr_sdate", warr.getString("warr_sdate"), "hname:'보증기간', required:'Y'");
f.addElement("warr_edate", warr.getString("warr_edate"), "hname:'보증기간', required:'Y'");
f.addElement("warr_amt", warr.getString("warr_amt"), "hname:'보증금액', required:'Y', option:'money'");
f.addElement("warr_date", warr.getString("warr_date"), "hname:'발급일', required:'Y'");
if(warr.getString("file_name").equals("")){
	if( u.inArray(cont.getString("member_no"), new String[]{"20120500023","20120100001","20120200001"}) )  // 동희오토 : 서울보증보험 번호만 있으면 조회가능하므로 첨부파일 필수가 아님.
		f.addElement("warr_file", null, "hname:'첨부파일', func:'warrCheck', allow:'jpg|gif|png|pdf|zip'");
	else
		f.addElement("warr_file", null, "hname:'첨부파일', required:'Y', allow:'jpg|gif|png|pdf|zip'");
}

if(u.isPost()&&f.validate()){
	f.uploadDir = Startup.conf.getString("file.path.bcont_pdf")+fileDir;
	warrDao.item("warr_office", f.get("warr_office"));
	warrDao.item("warr_no", f.get("warr_no"));
	warrDao.item("warr_sdate", f.get("warr_sdate").replaceAll("-",""));
	warrDao.item("warr_edate", f.get("warr_edate").replaceAll("-",""));
	warrDao.item("warr_amt", f.get("warr_amt").replaceAll(",",""));
	warrDao.item("warr_date", f.get("warr_date").replaceAll("-",""));
	
	File attFile = f.saveFileTime("warr_file");
	if(attFile != null)
	{
		warrDao.item("doc_name", f.getFileName("warr_file"));
		warrDao.item("file_path", fileDir);
		warrDao.item("file_name", attFile.getName());
		warrDao.item("file_ext", u.getFileExt(attFile.getName()));
		warrDao.item("file_size", attFile.length());
	}
	warrDao.item("reg_date", u.getTimeString());
	warrDao.item("reg_id", "");
	if(cont.getString("member_no").equals(_member_no)){//갑
		warrDao.item("status","30");
	}else{
		if(warr.getString("status").equals("10")){//을
			warrDao.item("status","20");
		}
	}
	
	if(!warrDao.update(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and warr_seq = '"+warr_seq+"' ")){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	
	//확인대기 변경시 갑에게 문자 보낸다.
	if(!cont.getString("member_no").equals(_member_no)){//을
		if(warr.getString("status").equals("10")){//
			String warr_name = u.getItem(warr.getString("warr_type"),code_warr);
			SmsDao smsDao= new SmsDao();
			String sender_name = auth.getString("_MEMBER_NAME");
			DataObject custDao = new DataObject("tcb_cust");
			DataSet cust = custDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ");
			while(cust.next()){
				if(!cust.getString("member_no").equals(_member_no)){
					// sms 전송
					smsDao.sendSMS("buyer", cust.getString("hp1"), cust.getString("hp2"), cust.getString("hp3"), auth.getString("_MEMBER_NAME")+" 에서 전자계약 "+warr_name+" 확인요청- 나이스다큐(일반기업용)");
				}
			}
		}
	}
	
	
	
	out.print("<script>");
	out.print("alert(\"저장하였습니다.\");");
	out.print("opener.location.reload();");
	out.print("self.close();");
	out.print("</script>");
	return;
}


boolean btn = false;
boolean haja_yn = warr.getString("warr_type").equals("20");
boolean cont_ing =  u.inArray(cont.getString("status"),new String[]{"20","30","40","41"});
boolean gap_yn = cont.getString("member_no").equals(_member_no);

if(cont_ing){//계약진행중
	if(!gap_yn){
		btn = true;
	}
}else{//계약완료
	if(haja_yn){
		if(warr.getString("warr_no").equals("")){
			btn = true;
		}else{
			if(u.inArray(warr.getString("status"), new String[]{"","10","20"})){//직접첨부,요청중,확인대기
				btn = true;
			}
		}
	}else{
		if(warr.getString("warr_no").equals("")){
			btn = true;
		}else{
			if(u.inArray(warr.getString("status"), new String[]{"10","20"})){//요청중,확인대기
				btn = true;
			} else if (gap_yn && auth.getString("_DEFAULT_YN").equals("Y")) { // 갑 관리자인 경우
				btn = true;
			}
		}	
	}
}

p.setLayout("popup_email_contract");
p.setDebug(out);
if(warr.getString("warr_no").equals("")){
	p.setBody("sdd.pop_warr_modify");
} else {
	p.setBody("sdd.pop_warr_view");
}
p.setVar("popup_title","보증서 정보");
p.setLoop("code_office", u.arr2loop(code_office));
p.setVar("btn",btn);
p.setVar("btn_confirm", warr.getString("status").equals("20")&&gap_yn&&!warr.getString("warr_no").equals(""));
p.setVar("warr", warr);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString(""));
p.setVar("form_script",f.getScript());
p.display(out);
%>