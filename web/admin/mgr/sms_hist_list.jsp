<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] gubun = {"0=>성공", "1=>타임아웃", "2=>잘못된 전화번호", "v=>발신번호 사전 등록제에 의한 미등록 차단", "w=>발신번호 사전 등록제 번호규칙 위반",
		"a=>단말기 일시 서비스 정지", "b=>기타 단말기 문제", "c=>단말기에서 착실 거절", "d=>기타", "e=>망 에러", "f>SMTS 포맷에러", "g=>SMS 서비스 불가 단말기",
		"h=>착신 측의 호불가 상태", "i=>SMS 운영자가 삭제한 메시지", "j=>스케줄러와 ASE 사이의 메시지 큐", "k=>이통사에서 SPAM 처리",
		"l=>www.nospam.go.kr에 등록된 수신거부 번호", "m=>메시지 SPAM 차단", "p=>폰 번호가 형식에 어긋난 경우", "t=>2개 이상의 SPAM 차단",
		"q=>필드 형식이 잘못된 경우(예:메시지 내용없음)", "s=>메시지 스팸차단", "A=>핸드폰 호 처리중", "B=>음영지역", "C=>단말기 POWER OFF",
		"z=>그 외 오류"};

String s_tran_date = u.request("s_tran_date", u.getTimeString("yyyyMM"));

f.addElement("s_tran_date", s_tran_date, "hname:'기준년월', required:'Y', fixbyte:'6'");
f.addElement("s_tran_rslt", null, null);
f.addElement("s_tran_phone", null, null);
f.addElement("s_tran_msg", null, null);

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum("excel".equals(u.request("mode")) ? -1 : 25);
list.setTable("labor.em_log_" + s_tran_date + " a, labor.em_tran_mms b");
list.setFields("a.tran_phone, to_char(a.tran_date, 'YYYY-MM-DD HH24:MI:SS') tran_date, to_char(a.tran_reportdate, 'YYYY-MM-DD HH24:MI:SS') tran_reportdate, a.tran_net, a.tran_rslt, decode(a.tran_msg, null, b.mms_body, a.tran_msg) tran_msg ");
list.addWhere("a.tran_id = 'NDD002'");
list.addWhere("a.tran_etc4 = b.mms_seq(+)");
if (!"".equals(f.get("s_tran_rslt"))) {
	list.addWhere("0".equals(f.get("s_tran_rslt")) ? "a.tran_rslt = '0'" : "a.tran_rslt != '0'");
}
list.addWhere("(a.tran_msg like '%" + f.get("s_tran_msg") + "%' or b.mms_body like '%" + f.get("s_tran_msg") + "%')");
list.addSearch("a.tran_phone", f.get("s_tran_phone").replaceAll("-", ""), "LIKE");
list.setOrderBy("a.tran_id desc");

//목록 데이타 수정
DataSet ds = list.getDataSet();

while(ds.next()){
	ds.put("tran_msg", u.nl2br(ds.getString("tran_msg")));
	ds.put("tran_rslt_nm", u.getItem(ds.getString("tran_rslt"), gubun));
}

p.setLoop("list", ds);

if (u.request("mode").equals("excel")) {
	response.setContentType("application/vnd.ms-excel");
	response.setHeader("Content-Disposition", "attachment; filename=\"" + new String("SMS전송이력.xls".getBytes("KSC5601"),"8859_1") + "\"");
	out.println(p.fetch("../html/mgr/sms_hist_list_excel.html"));
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("mgr.sms_hist_list");
p.setVar("menu_cd","000074");
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("form_script",f.getScript());
p.display(out);
%>