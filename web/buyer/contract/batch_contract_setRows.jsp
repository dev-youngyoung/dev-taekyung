<%@page import="net.sf.json.JSONArray"%>
<%@page import="net.sf.json.JSONObject"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%
String templateCd = u.request("template_cd");
String _menu_cd = "000059";

String sTable = "tcb_contmaster a inner join tcb_cust b on a.cont_no = b.cont_no and a.cont_chasu = b.cont_chasu ";
String sColumn = "a.cont_no, a.cont_chasu, a.template_cd, a.cont_name, a.cont_date, a.status, nvl(a.cont_userno,a.cont_no) cont_userno, a.paper_yn, b.member_no, b.member_name, b.cust_detail_code, a.sign_types, "
				+ "( SELECT COUNT(member_no) cnt FROM tcb_cust WHERE cont_no = a.cont_no AND cont_chasu= a.cont_chasu ) cust_cnt, "
				+ "NVL((SELECT cname FROM tcb_comcode WHERE CCODE = 'M009' AND CODE = a.APPR_STATUS ), '임시저장') appr_status_name ";

DataObject dataObj = new DataObject(sTable);
String findStr = "STATUS = '10'" + " AND TEMPLATE_CD = '" + templateCd + "'" 
				+" AND b.list_cust_yn = 'Y' "
				+" AND a.APPR_YN = 'N' "
				+" AND a.member_no = '" + _member_no + "' ";

//list.addSearch("b.member_name", f.get("s_cust_name"), "LIKE");
//list.addSearch("b.vendcd", f.get("s_vendcd").replaceAll("-", ""), "LIKE");

// 조회권한
if (!auth.getString("_DEFAULT_YN").equals("Y")) {
	// 10:담당조회  20:부서조회 
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("10")) {
		findStr = findStr + " AND a.reg_id = '" + auth.getString("_USER_ID") + "' ";
	}
	if (_authDao.getAuthMenuInfoB(_member_no, auth.getString("_AUTH_CD"), _menu_cd, "select_auth").equals("20")) {
		findStr = findStr + " AND a.field_seq in ( select field_seq from tcb_field start with member_no = '" + _member_no + "' and field_seq = '" + auth.getString("_FIELD_SEQ") + "' connect by prior member_no = member_no and prior field_seq = p_field_seq) ";
	}
}

DataSet contList = dataObj.find(findStr,sColumn,"a.reg_date desc");
JSONArray objArr = new JSONArray();

while(contList.next()){
	contList.put("cont_no", u.aseEnc(contList.getString("cont_no")));
	if (contList.getInt("cust_cnt") - 2 > 0) {
		contList.put("cust_name", contList.getString("member_name") + "외" + (contList.getInt("cust_cnt") - 2) + "개사");
	} else {
		contList.put("cust_name", contList.getString("member_name"));
	}
	JSONObject obj = new JSONObject();
	Enumeration keys = contList.getRow().keys();
	for(int k=0; keys.hasMoreElements(); k++) {
		String key = (String)keys.nextElement();
		if(!"__ord".equals(key) && !"__last".equals(key)){
			obj.put(key, contList.getRow().get(key));
		}
	}
	objArr.add(obj);
}
//String data = "{data : " + objArr + "}";
out.print(objArr);
%>