<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String user_id = u.aseDec(u.request("user_id"));
//String user_id = "2021027";

if (user_id.equals("")) {
	u.jsError("정상적인 경로로 접근 하세요.");
	return;
}

// SSO User
DataObject ssoUserDao = new DataObject("sso_user_info");
DataSet ssoUser = ssoUserDao.find("user_id = '" + user_id + "' ");

// 일용직 User
DataObject kUserDao = new DataObject("k_user_info");
DataSet kUser = kUserDao.find("user_id = '" + user_id + "' ");

// 계약직 User
DataObject nComt005Dao = new DataObject("NCOMT005");
DataSet nComt005User = nComt005Dao.find("emp_no = '" + user_id + "' ");

if (!ssoUser.next()) 
{
	if (!kUser.next()) 
	{
		if (!nComt005User.next()) 
		{
			u.jsError("사용자 정보가 존재하지 않습니다.");
			return;
		}
	}	
}

ssoUser.next();
kUser.next();
nComt005User.next();

String mamberName = null;
String celNo = null;
String celNo1 = null;
String celNo2 = null;
String celNo3 = null;

mamberName = ssoUser.getString("user_name");
celNo = ssoUser.getString("cel_no");

// 사용자 이름이 sso user에 없으면 일용직 user에서 check
if(mamberName.length() == 0 || mamberName == null)
{
	mamberName = kUser.getString("user_name");
}

// 사용자 이름이  일용직 user에도 없으면 계약직 User 에서 check
if(mamberName.length() == 0 || mamberName == null)
{
	mamberName = nComt005User.getString("han_name");
}

// 휴대폰 번호가 sso user에 없으면 일용직 user에서 check
if(celNo.length() == 0 || celNo == null)
{
	celNo = kUser.getString("cel_no");
}

// 휴대폰 번호가 sso user에 없으면 일용직 user에서 check
if(celNo.length() == 0 || celNo == null)
{
	celNo = nComt005User.getString("cela_tel");
}

if(celNo.length() > 0)
{
	celNo1 = celNo.replaceAll("-", "").substring(0, 3);
	celNo2 = celNo.replaceAll("-", "").substring(3, 7);
	celNo3 = celNo.replaceAll("-", "").substring(7);
}

String sTable = "tcb_contmaster cont, tcb_cust cust, tcb_person ps "; // 계약정보, 결재정보, 담당자정보
String sColumn = "cont.cont_no, cont.cont_chasu, cont.member_no, cont.cont_name, cont.cont_date, "
			   + "cust.member_name as cust_name, "
			   + "ps.user_name, ps.division ";

ListManager list = new ListManager();
list.setRequest(request);
//list.setDebug(out);
list.setListNum(15);
list.setTable(sTable);
list.setFields(sColumn);
list.addWhere("cont.status in ('50', '91', '99') ");
list.addWhere("cont.cont_no = cust.cont_no ");
list.addWhere("cont.cont_chasu = cust.cont_chasu ");
list.addWhere("cont.member_no <> cust.member_no ");
list.addWhere("cust.member_name = '" + mamberName + "'");
list.addWhere("cust.hp1 = '" + celNo1 + "'");
list.addWhere("cust.hp2 = '" + celNo2 + "'");
list.addWhere("cust.hp3 = '" + celNo3 + "'");
list.addWhere("cont.member_no = ps.member_no ");
list.addWhere("cont.reg_id = ps.user_id");
list.setOrderBy("cont.cont_no desc ");

DataSet ds = list.getDataSet();

while (ds.next()) {
	ds.put("cont_no_enc", u.aseEnc(ds.getString("cont_no")));
	ds.put("cont_date", u.getTimeString("yyyy-MM-dd", ds.getString("cont_date")));
}

p.setLayout("view");
p.setBody("contract.contract_list_by_user");
p.setLoop("list", ds);
p.setVar("pagerbar", list.getPaging());
p.setVar("query", u.getQueryString());
p.setVar("list_query", u.getQueryString("cont_no, cont_chasu"));
p.setVar("form_script", f.getScript());
p.display(out);
%>