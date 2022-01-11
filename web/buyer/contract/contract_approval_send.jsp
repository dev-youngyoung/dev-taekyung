<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%@ page import="nicelib.groupware.*"%>
<%
String jobID = u.request("jobID"); 
String cont_no = u.aseDec(u.request("cont_no"));
String cont_chasu = u.request("cont_chasu", "0");
String agree_seq = u.request("agree_seq");
if (jobID.equals("") || cont_no.equals("") || cont_chasu.equals("")) {
	u.jsError("정상적인 경로로 접근하여 주십시오.");
	return;
}

DataObject memberDao = new DataObject("tcb_member");
DataSet member = memberDao.find("member_no = '"+_member_no+"' ");
if (!member.next()) {
	u.jsError("사용자 정보가 존재하지 않습니다.");
	return;
}

String where = " cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "'";
ContractDao contDao = new ContractDao();
DataSet cont = contDao.find(where+" and member_no = '" + _member_no + "'");
if (!cont.next()) {
	u.jsError("계약건이 존재 하지 않습니다.");
	return;
}

// 서식정보 조회
String template_cd = cont.getString("template_cd");
DataObject templateDao = new DataObject("tcb_cont_template");
DataSet template = templateDao.find(" template_cd ='" + template_cd + "'");
template.next();

// 결재 정보
String now_agree_seq = "";
DataObject agreeDao = new DataObject("tcb_cont_agree");
DataSet agree = agreeDao.find("cont_no = '" + cont_no + "' and cont_chasu = '" + cont_chasu + "' and r_agree_person_id is null and agree_cd='1'", "agree_seq", "agree_seq asc", 1);
agree.next();
now_agree_seq = agree.getString("agree_seq");
if (!now_agree_seq.equals("")) {
	if (!agree_seq.equals(now_agree_seq)) {
		u.jsError("결재자가 올바르지 않습니다.");
		return;
	}
}

// 담당자/거래처 정보
DataObject custDao = new DataObject();
DataSet cust = custDao.query(
		"select a.cont_no as cont_no, decode(b.division, b.division, d.division) as division, b.user_name as user_name, b.tel_num as tel_num, c.member_name as member_name, c.vendcd as vendcd, c.boss_name as boss_name, a.cont_sdate as cont_sdate, a.cont_edate as cont_edate " +
		"from tcb_contmaster a, tcb_cust b, tcb_cust c, tcb_person d " +
		"where a.cont_no = '" + cont_no + "' " +
		"  and a.cont_chasu = '" + cont_chasu + "' " +
		"  and a.cont_no = b.cont_no " +
		"  and a.cont_chasu = b.cont_chasu " +
		"  and a.member_no = b.member_no " +
		"  and a.cont_no = c.cont_no " +
		"  and a.cont_chasu = c.cont_chasu " +
		"  and a.member_no != c.member_no " +
		"  and a.member_no = d.member_no " +
		"  and a.reg_id = d.user_id ");
cust.next();

if (cont.getString("appr_yn").equals("Y")) {
	if (!u.inArray(cont.getString("status"), new String[]{"10", "11"})) { // 작성중, 검토중 전송 가능
		u.jsError("계약건은 계약상태가 작성중,내부결재중 상태에서만 결재상신 가능 합니다.");
		return;
	} else {
		if (!u.inArray(cont.getString("appr_status"), new String[]{"10", "40"})) { // 상신대기, 기안취소/반려 전송 가능
			u.jsError("계약건은 결재상태가 상신대기,기안취소/반려 상태에서만 결재상신 가능 합니다.");
			return;
		}
	}
} else {
	u.jsError("결재상신이 필요하지 않은 계약입니다.");
	return;
}

String approval = "";

String userID = auth.getString("_USER_ID"); // 사원번호
// userID = "9711730"; // TODO :: 테스트를 위해 임시 하드코딩
String creator = auth.getString("_USER_NAME"); // 사용자이름
// creator = "유환홍"; // TODO :: 테스트를 위해 임시 하드코딩
String docID = cont_no; // 계약번호
String cmpID = "CN";
String workName = u.request("work_name"); // ECS12, ECS13에서 '상신명'
String workItem = u.request("work_item"); // ECS12에서 '상신내용'
String division = cust.getString("division"); // ECS13에서 '신청부서:부서'
String userName = cust.getString("user_name"); // ECS13에서 '신청부서:담당자'
String telNum = cust.getString("tel_num"); // ECS13에서 '신청부서:전화번호'
String memberName = cust.getString("member_name"); // ECS13에서 '거래처:상호'

// 개인 자유서식인 경우 사업자번호 null 처리(2020.12.11, swplus)
String vendCd = "";
if(cust.getString("vendcd") != null && cust.getString("vendcd").length() >= 6 )
{
	vendCd = cust.getString("vendcd").substring(0, 3) + "-" + cust.getString("vendcd").substring(3, 5) + "-" + cust.getString("vendcd").substring(5); // ECS13에서 '거래처:사업자번호'
}
//String vendCd = cust.getString("vendcd").substring(0, 3) + "-" + cust.getString("vendcd").substring(3, 5) + "-" + cust.getString("vendcd").substring(5); // ECS13에서 '거래처:사업자번호'

String bossName = cust.getString("boss_name"); // ECS13에서 '거래처:사업자'
String contSdate = u.getTimeString("yyyy-MM-dd", cust.getString("cont_sdate")); // 계약시작일자
String contEdate = u.getTimeString("yyyy-MM-dd", cust.getString("cont_edate")); // 계약종료일자
String contDate = ""; // ECS13에서 '계약정보:계약기간'
if (!contSdate.equals("") || !contEdate.equals("")) {
	contDate = contSdate + " ~ " + contEdate;
}
String contName = u.request("cont_name"); // ECS13에서 '계약명'
String endRdate = u.request("end_rdate"); // ECS13에서 '완료요구일'
String contItem = u.request("cont_item"); // ECS13에서 '계약내용'
String reqItem = u.request("req_item"); // ECS13에서 '요청사항'

DataSet approvalInfo = new DataSet();
approvalInfo.addRow();
approvalInfo.put("userID", userID); // 사원번호
approvalInfo.put("creator", creator);
approvalInfo.put("jobID", jobID);
approvalInfo.put("contNo", cont_no);
approvalInfo.put("contChasu", cont_chasu);
approvalInfo.put("docID", docID);
approvalInfo.put("cmpID", cmpID);
approvalInfo.put("workName", workName); // for ECS12, ECS13
approvalInfo.put("workItem", workItem); // for ECS12
approvalInfo.put("division", division); // for ECS13
approvalInfo.put("userName", userName); // for ECS13
approvalInfo.put("telNum", telNum); // for ECS13
approvalInfo.put("memberName", memberName); // for ECS13
approvalInfo.put("vendCd", vendCd); // for ECS13
approvalInfo.put("bossName", bossName); // for ECS13
approvalInfo.put("contDate", contDate); // for ECS13
approvalInfo.put("contName", contName); // for ECS13
approvalInfo.put("endRdate", endRdate); // for ECS13
approvalInfo.put("contItem", contItem); // for ECS13
approvalInfo.put("reqItem", reqItem); // for ECS13

if (u.isPost() && f.validate()) {
	ApprovalSender approvalSender = new ApprovalSender();
	boolean sendResult = approvalSender.sendApprovalSave(approvalInfo);
			
	if (sendResult) {
		approval = "Y";
	} else {
		approval = "N";
	}
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("contract.contract_approval_send");
p.setVar("menu_cd", "000059");
p.setVar("member", member);
p.setVar("cont", cont);
p.setVar("template", template);
p.setVar("approval", approval);
p.setVar("approvalInfo", approvalInfo);
p.setVar("jobID", jobID);
p.setVar("docID", docID);
p.setVar("cmpID", cmpID);
p.setVar("userID", userID);
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no, cont_chasu, jobID"));
p.setVar("form_script", f.getScript());
p.display(out);
%>