<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%

CodeDao code = new CodeDao("tcb_comcode");
String[] code_member_gubun = code.getCodeArray("M001");

String vendcd = auth.getString("_VENDCD");
String vendcd1 = vendcd.substring(0,3);
String vendcd2 = vendcd.substring(3,5);
String vendcd3 = vendcd.substring(5,10);

DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.find(" member_no = '"+_member_no+"' ");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}else{
	member.put("member_gubun_name", u.getItem(member.getString("member_gubun"),code_member_gubun));
	member.put("cert_end_date", u.getTimeString("yyyy-MM-dd",member.getString("cert_end_date")));
}
String member_slno1= "";
String member_slno2= "";
if(member.getString("member_slno").length()==13){
	member_slno1= member.getString("member_slno").substring(0,6);
	member_slno2= member.getString("member_slno").substring(6);
}

f.addElement("vendcd1", vendcd1, "hname:'사업자등록번호'");
f.addElement("vendcd2", vendcd2, "hname:'사업자등록번호'");
f.addElement("vendcd3", vendcd3, "hname:'사업자등록번호'");
if(member.getString("memger_gubun").equals("01")){
	f.addElement("member_slno1", member_slno1, "hname:'법인번호', required:'Y', maxbyte:'6'");
	f.addElement("member_slno2", member_slno2, "hname:'법인번호', required:'Y', maxbyte:'7'");
}else{
	f.addElement("member_slno1", member_slno1, "hname:'법인번호', maxbyte:'6'");
	f.addElement("member_slno2", member_slno2, "hname:'법인번호', maxbyte:'7'");
}
f.addElement("member_name", member.getString("member_name"), "hnae:'업체명', required:'Y'");
f.addElement("boss_name", member.getString("boss_name"), "hname:'대표자명', required:'Y'");
f.addElement("condition", member.getString("condition"), "hname:'업태', required:'Y'");
f.addElement("category", member.getString("category"), "hname:'종목', required:'Y'");
f.addElement("post_code", member.getString("post_code") , "hname:'우편번호', required:'Y'");
f.addElement("address", member.getString("address"), "hname:'주소', required:'Y'");

if(u.isPost()&& f.validate()){
	DataObject memberDao = new DataObject("tcb_member");

	memberDao.item("member_name", f.get("member_name"));
	memberDao.item("boss_name", f.get("boss_name"));
	memberDao.item("post_code", f.get("post_code"));
	memberDao.item("address",f.get("address"));
	memberDao.item("member_slno", f.get("member_slno1")+f.get("member_slno2"));
	memberDao.item("condition", f.get("condition"));
	memberDao.item("category", f.get("category"));
	memberDao.item("reg_date", u.getTimeString());  // 회원가입은 join_date, 입력/변경은 reg_date
	memberDao.item("reg_id", f.get("user_id"));
	if(!memberDao.update("member_no = '"+_member_no+"' ")){
		u.jsError("저장에 실패하였습니다.");
		return;
	}
	u.jsAlertReplace("저장 하였습니다.", "company_modify.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.company_modify");
p.setVar("menu_cd","000108");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000108", "btn_auth").equals("10"));
p.setVar("member",member);
p.setVar("sys_date", u.getTimeString());
p.setVar("form_script", f.getScript());
p.display(out);
%>