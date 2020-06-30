<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String cont_no = u.request("cont_no");
String cont_chasu = u.request("cont_chasu");
if(cont_no.equals("")||cont_chasu.equals("")){
	u.jsErrClose("정상적인 경로 접근하세요.");
	return;
}

CodeDao codeDao = new CodeDao("tcb_comcode");
String[] code_warr = codeDao.getCodeArray("M007");
String[] code_change_gubun = null;
String[] code_auto_type = {"=>자동생성","1=>자동첨부","2=>필수첨부","3=>내부용"};


DataObject cfileDao = new DataObject("tcb_cfile");
DataSet cfile = cfileDao.find(" cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ","*" );
while(cfile.next()){
	if(cfile.getString("auto_yn").equals("Y")){
		cfile.put("auto_str", u.getItem(cfile.getString("auto_type"), code_auto_type));
		if(cfile.getString("auto_type").equals("")){
				cfile.put("auto_type","0");
			}
	}else{
		cfile.put("auto_str", "직접첨부");
	}
	if(cfile.getString("file_ext").toLowerCase().equals("pdf")){
        cfile.put("btn_name", "조회(인쇄)");
        cfile.put("down_script","contPdfViewer('"+u.request("cont_no")+"','"+cont_chasu+"','"+cfile.getString("cfile_seq")+"')");
    }else{
        cfile.put("btn_name", "다운로드");
        cfile.put("down_script","filedown('file.path.bcont_pdf','"+cfile.getString("file_path")+cfile.getString("file_name")+"','"+cfile.getString("doc_name")+"."+cfile.getString("file_ext")+"')");
    }
	cfile.put("file_size_str", u.getFileSize(cfile.getLong("file_size")));
}


p.setLayout("popup");
//p.setDebug(out);
p.setBody("buyer.pop_contract_view");
p.setVar("popup_title","계약서 조회");
p.setLoop("list", cfile);
p.display(out);
%>