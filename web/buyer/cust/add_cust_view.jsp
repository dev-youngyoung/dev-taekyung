<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
CodeDao code = new CodeDao("tcb_comcode");
String[] code_material = code.getCodeArray("M300");
String[] code_warr = code.getCodeArray("M301");
String[] code_car = code.getCodeArray("M302");
String[] code_wegiht = code.getCodeArray("M303");

String where = "member_no = '"+u.request("member_no")+"'";

DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.find(where, "member_name, boss_name");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}

DataObject addDao = new DataObject("tcb_member_add");
//mdao.setDebug(out);
DataSet memberAdd = addDao.find(where);
if(memberAdd.next()){
	memberAdd.put("setup_date", u.getTimeString("yyyy-MM-dd", memberAdd.getString("setup_date")));
	memberAdd.put("worker_num", u.numberFormat(memberAdd.getInt("worker_num")));

	memberAdd.put("sales_amt", u.numberFormat(memberAdd.getDouble("sales_amt")/1000, 0));
	memberAdd.put("biz_profit", u.numberFormat(memberAdd.getDouble("biz_profit")/1000, 0));
	memberAdd.put("biz_profit_rate", u.numberFormat(memberAdd.getDouble("biz_profit_rate"), 2));
	memberAdd.put("net_profit", u.numberFormat(memberAdd.getDouble("net_profit")/1000, 0));

	memberAdd.put("asset", u.numberFormat(memberAdd.getDouble("asset")/1000, 0));
	memberAdd.put("capital", u.numberFormat(memberAdd.getDouble("capital")/1000, 0));
	memberAdd.put("debt_rate", u.numberFormat(memberAdd.getDouble("debt_rate"), 2));
	memberAdd.put("debt", u.numberFormat(memberAdd.getDouble("debt")/1000, 0));

	memberAdd.put("liquid_asset", u.numberFormat(memberAdd.getDouble("liquid_asset")/1000, 0));
	memberAdd.put("liquid_debt", u.numberFormat(memberAdd.getDouble("liquid_debt")/1000, 0));
	memberAdd.put("liquid_rate", u.numberFormat(memberAdd.getDouble("liquid_rate"), 2));

}

DataObject major_cust_dao = new DataObject("tcb_major_cust");
DataSet major_cust = major_cust_dao.find(where);
while(major_cust.next())
{
	major_cust.put("sales", u.numberFormat(major_cust.getInt("sales")));
}

DataObject material_dao = new DataObject("tcb_material");
DataSet material = material_dao.find(where, "car_cd");
int j=0;
String strMaterial = "";
while(material.next())
{
	material.put("meterial_cd", material.getString("car_cd"));
	if(j==0)
		strMaterial = material.getString("car_cd");
	else
		strMaterial += ","+material.getString("car_cd");
	j++;
}
f.addElement("meterial_cd", strMaterial, "");

// 보유차량조회
DataObject car_dao = new DataObject("tcb_car");
DataSet car1 = car_dao.find(where + " and car_gubun='1'"); // 보유차랑
while(car1.next())
{
	car1.put("car_num1", u.numberFormat(car1.getInt("car_num")));
	car1.put("car_nm1", u.getItem(car1.getString("car_cd"), code_car));
	car1.put("weight_nm1", u.getItem(car1.getString("weight_cd"), code_wegiht));
}

//운영가능차량조회
DataSet car2 = car_dao.find(where + " and car_gubun='2'"); // 보유차랑
while(car2.next())
{
	car2.put("car_num2", u.numberFormat(car2.getInt("car_num")));
	car2.put("car_nm2", u.getItem(car2.getString("car_cd"), code_car));
	car2.put("weight_nm2", u.getItem(car2.getString("weight_cd"), code_wegiht));
}

//보증정보조회
DataObject warrDao = new DataObject("tcb_warr_add");
DataSet warr = warrDao.find(where);
while(warr.next()){
	warr.put("warr_type", u.getItem(warr.getString("warr_type"),code_warr));
	warr.put("warr_date", u.getTimeString("yyyy-MM-dd", warr.getString("warr_date")));
	warr.put("warr_sdate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_sdate")));
	warr.put("warr_edate", u.getTimeString("yyyy-MM-dd", warr.getString("warr_edate")));
	warr.put("warr_amt", u.numberFormat(warr.getDouble("warr_amt"),0));
	warr.put("member_no", u.aseEnc(warr.getString("member_no")));
}

//인허가정보
DataObject certDao = new DataObject("tcb_cert_add");
DataSet cert = certDao.find(where);
while(cert.next()){
	cert.put("cert_sdate", u.getTimeString("yyyy-MM-dd", cert.getString("cert_sdate")));
	cert.put("cert_edate", u.getTimeString("yyyy-MM-dd", cert.getString("cert_edate")));
	cert.put("member_no", u.aseEnc(cert.getString("member_no")));
}

p.setLayout("default");
p.setDebug(out);
p.setBody("cust.add_cust_view");
p.setVar("menu_cd","000084");
p.setVar("auth_select",_authDao.getAuthMenuInfoB( _member_no, auth.getString("_AUTH_CD"), "000084", "btn_auth").equals("10"));
p.setLoop("code_material", u.arr2loop(code_material));
p.setLoop("code_car", u.arr2loop(code_car));
p.setLoop("code_weight", u.arr2loop(code_wegiht));
p.setVar("member", member);
p.setVar("memberAdd", memberAdd);
p.setLoop("major_cust", major_cust);
p.setLoop("car1", car1);
p.setLoop("car2", car2);
p.setLoop("warr", warr);
p.setLoop("cert", cert);
p.setVar("form_script", f.getScript());
p.setVar("list_query", u.getQueryString("member_no"));

p.display(out);
%>