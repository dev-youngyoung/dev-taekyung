<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="init.jsp" %>
<%

CodeDao code = new CodeDao("tcb_comcode");
String[] code_material = code.getCodeArray("M300");
String[] code_warr = code.getCodeArray("M301");
String[] code_car = code.getCodeArray("M302");
String[] code_wegiht = code.getCodeArray("M303");


String where = "member_no = '"+_member_no+"'";

DataObject mdao = new DataObject("tcb_member");
//mdao.setDebug(out);
DataSet member = mdao.find(where, "member_name, boss_name");
if(!member.next()){
	u.jsError("회원정보가 없습니다.");
	return;
}

DataObject addDao = new DataObject("tcb_member_add");
//mdao.setDebug(out);
DataSet memberAdd = addDao.find(where, "post_address");
boolean bAddInsert = true;
if(memberAdd.next()){
	bAddInsert = false;
	f.addElement("post_address", memberAdd.getString("post_address"), "");
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
	car1.put("car_cd1", car1.getString("car_cd"));
	car1.put("weight_cd1", car1.getString("weight_cd"));
}

//운영가능차량조회
DataSet car2 = car_dao.find(where + " and car_gubun='2'"); // 보유차랑
while(car2.next())
{
	car2.put("car_num2", u.numberFormat(car2.getInt("car_num")));
	car2.put("car_cd2", car2.getString("car_cd"));
	car2.put("weight_cd2", car2.getString("weight_cd"));
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

if(u.isPost()&& f.validate()){
	DB db = new DB();

	addDao = new DataObject("tcb_member_add");
	addDao.item("post_address", f.get("post_address"));
	System.out.println("bAddInsert " + bAddInsert);
	if(bAddInsert)	{
		addDao.item("member_no", _member_no);
		db.setCommand(addDao.getInsertQuery(), addDao.record);
	}
	else {
		db.setCommand(addDao.getUpdateQuery(where), addDao.record);
	}
	
	major_cust_dao = new DataObject("tcb_major_cust");
	db.setCommand(major_cust_dao.getDeleteQuery(where), null);
	
	String[] major_cust_name = f.getArr("major_cust_name");
	String[] major_sales = f.getArr("major_sales");
	int major_cust_cnt = major_cust_name==null?0:major_cust_name.length;
	for(int i=0; i<major_cust_cnt; i++)
	{
		major_cust_dao = new DataObject("tcb_major_cust");
		major_cust_dao.item("member_no", _member_no);
		major_cust_dao.item("seq", i+1);
		major_cust_dao.item("cust_name", major_cust_name[i]);
		major_cust_dao.item("sales", major_sales[i]);
		db.setCommand(major_cust_dao.getInsertQuery(), major_cust_dao.record);
	}

	String[] meterial_cd = f.getArr("meterial_cd");
	db.setCommand(material_dao.getDeleteQuery(where), null);
	int material_cnt = meterial_cd==null?0:meterial_cd.length;
	for(int i=0; i<material_cnt; i++)
	{
		material_dao = new DataObject("tcb_material");
		material_dao.item("member_no", _member_no);
		material_dao.item("car_cd", meterial_cd[i]);
		db.setCommand(material_dao.getInsertQuery(), material_dao.record);		
	}

	String[] car_cd1 = f.getArr("car_cd1");
	String[] weight_cd1 = f.getArr("weight_cd1");
	String[] car_num1 = f.getArr("car_num1");
	db.setCommand(car_dao.getDeleteQuery(where), null);
	int car_cd1_cnt = car_cd1==null?0:car_cd1.length;
	int cnt=1;
	for(int i=0; i<car_cd1_cnt; i++)
	{
		car_dao = new DataObject("tcb_car");
		car_dao.item("member_no", _member_no);
		car_dao.item("seq", cnt++);
		car_dao.item("car_cd", car_cd1[i]);
		car_dao.item("weight_cd", weight_cd1[i]);
		car_dao.item("car_num", car_num1[i]);
		car_dao.item("car_gubun", "1");  // 차종(1:보유차량, 2:최대 운영가능 차량)
		db.setCommand(car_dao.getInsertQuery(), car_dao.record);
	}	
	
	String[] car_cd2 = f.getArr("car_cd2");
	String[] weight_cd2 = f.getArr("weight_cd2");
	String[] car_num2 = f.getArr("car_num2");
	int car_cd2_cnt = car_cd2==null?0:car_cd2.length;
	for(int i=0; i<car_cd2_cnt; i++)
	{
		car_dao = new DataObject("tcb_car");
		car_dao.item("member_no", _member_no);
		car_dao.item("seq", cnt++);
		car_dao.item("car_cd", car_cd2[i]);
		car_dao.item("weight_cd", weight_cd2[i]);
		car_dao.item("car_num", car_num2[i]);
		car_dao.item("car_gubun", "2");  // 차종(1:보유차량, 2:최대 운영가능 차량)
		db.setCommand(car_dao.getInsertQuery(), car_dao.record);
	}		
	
	if(!db.executeArray()){
		u.jsError("처리에 실패 하였습니다.");
		return;
	}
	//u.redirect("./company_modify.jsp");
	u.jsAlertReplace("저장 하였습니다.", "company_add_info.jsp");
	return;
}

p.setLayout("default");
//p.setDebug(out);
p.setBody("info.company_add_info");
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
p.display(out);
%>