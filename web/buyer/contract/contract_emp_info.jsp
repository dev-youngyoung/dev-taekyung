<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%
String reqEmpNo = u.request("emp_no");
String contDate = u.request("cont_date");

DataObject empDao = new DataObject("v_nhpet000_ecs");
DataSet emp = empDao.query(
		"select * from v_nhpet000_ecs " + 
		" where emp_no = '" + reqEmpNo + "' " + 
		"   and '" + contDate + "' between sta_date and end_date " + 
		"   and rank_no = 1");

System.out.println("size : " + emp.size());

emp.next();

String rankNo = emp.getString("rank_no");
String staDate = emp.getString("sta_date");
String endDate = emp.getString("end_date");
String empNo = emp.getString("emp_no");
String hanName = emp.getString("han_name");
String persNo = emp.getString("pers_no");
String addr = emp.getString("addr");
String birthDate = emp.getString("birth_date");
String celaTel = emp.getString("cela_tel");
String empGubn = emp.getString("emp_gubn");
String deptCode = emp.getString("dept_code");
String deptName = emp.getString("dept_name");
String auttCode = emp.getString("autt_code");
String auttName = emp.getString("autt_name");
String locaName = emp.getString("loca_name");
String jwrkName = emp.getString("jwrk_name");
String jobName = emp.getString("job_name");
String entrComDate = emp.getString("entr_com_date");
String contStaDate = emp.getString("cont_sta_date");
String contEndDate = emp.getString("cont_end_date");
String jevaAmt = emp.getString("jeva_amt");
String workMonthTime = emp.getString("work_month_time");
String workMonthAmt = emp.getString("work_month_amt");
String overTime = emp.getString("over_time");
String overLaboAlow = emp.getString("over_labo_alow");
String workDayTime = emp.getString("work_day_time");
String workWeekTime = emp.getString("work_week_time");
String payAmt = emp.getString("pay_amt");
String dayPay = emp.getString("day_pay");
String wdayAmt = emp.getString("wday_amt");
String etcAmtYn = emp.getString("etc_amt_yn");
String etcAmt = emp.getString("etc_amt");
String etcCont = emp.getString("etc_cont");

//입사일자(entr_com_date)
String contStaYear = "";
String contStaMonth = "";
String contStaDay = "";

if(entrComDate.length() == 8){
	contStaYear = entrComDate.substring(0, 4);
	contStaMonth = entrComDate.substring(4, 6);
	contStaDay = entrComDate.substring(6);
}

//계약시작일자(cont_sta_date)
String contSyear = "";
String contSmonth = "";
String contSday = "";
if(contStaDate.length() == 8){
	contSyear = contStaDate.substring(0, 4);
	contSmonth = contStaDate.substring(4, 6);
	contSday = contStaDate.substring(6);
}

//계약종료일자(cont_end_date)
String contEyear = "";
String contEmonth = "";
String contEday = "";
if(contEndDate.length() == 8){
	contEyear = contEndDate.substring(0, 4);
	contEmonth = contEndDate.substring(4, 6);
	contEday = contEndDate.substring(6);
}

//제수당유무 check
String etcAmtY = "";
String etcAmtN = "";
if(etcAmtYn != null && !etcAmtYn.equals("")){
	if(etcAmtYn.equals("Y")){
		etcAmtY = "O";
		etcAmtN = "";
	}else{
		etcAmtY = "";
		etcAmtN = "O";
	}
}else{
	etcAmtY = "";
	etcAmtN = "O";
}

String empInfo = 
"{" +
	"\"rank_no\" : \"" + rankNo + "\", " +
	"\"sta_date\" : \"" + staDate + "\", " +
	"\"end_date\" : \"" + endDate + "\", " +
	"\"emp_no\" : \"" + empNo + "\", " +
	"\"han_name\" : \"" + hanName + "\", " +
	"\"pers_no\" : \"" + persNo + "\", " +
	"\"addr\" : \"" + addr + "\", " +
	"\"birth_date\" : \"" + birthDate + "\", " +
	"\"cela_tel\" : \"" + celaTel + "\", " +
	"\"emp_gubn\" : \"" + empGubn + "\", " +
	"\"dept_code\" : \"" + deptCode + "\", " +
	"\"dept_name\" : \"" + deptName + "\", " +
	"\"autt_code\" : \"" + auttCode + "\", " +
	"\"autt_name\" : \"" + auttName + "\", " +
	"\"loca_name\" : \"" + locaName + "\", " +
	"\"jwrk_name\" : \"" + jwrkName + "\", " +
	"\"job_name\" : \"" + jobName + "\", " +
	"\"entr_com_date\" : \"" + entrComDate + "\", " +
	"\"cont_sta_date\" : \"" + contStaDate + "\", " +
	"\"cont_end_date\" : \"" + contEndDate + "\", " +
	"\"jeva_amt\" : \"" + jevaAmt + "\", " +
	"\"work_month_time\" : \"" + workMonthTime + "\", " +
	"\"work_month_amt\" : \"" + workMonthAmt + "\", " +
	"\"over_time\" : \"" + overTime + "\", " +
	"\"over_labo_alow\" : \"" + overLaboAlow + "\", " +
	"\"work_day_time\" : \"" + workDayTime + "\", " +
	"\"work_week_time\" : \"" + workWeekTime + "\", " +
	"\"pay_amt\" : \"" + payAmt + "\", " +
	"\"day_pay\" : \"" + dayPay + "\", " +
	"\"wday_amt\" : \"" + wdayAmt + "\", " +
	"\"etc_amt_yn\" : \"" + etcAmtYn + "\", " +
	"\"etc_amt\" : \"" + etcAmt + "\", " +
	"\"etc_cont\" : \"" + etcCont + "\", " +
	"\"cont_sta_year\" : \"" + contStaYear + "\", " +
	"\"cont_sta_month\" : \"" + contStaMonth + "\", " +
	"\"cont_sta_day\" : \"" + contStaDay + "\", " +
	"\"cont_syear\" : \"" + contSyear + "\", " +
	"\"cont_smonth\" : \"" + contSmonth + "\", " +
	"\"cont_sday\" : \"" + contSday + "\", " +
	"\"cont_eyear\" : \"" + contEyear + "\", " +
	"\"cont_emonth\" : \"" + contEmonth + "\", " +
	"\"cont_eday\" : \"" + contEday + "\", " +
	"\"etc_amt_y\" : \"" + etcAmtY + "\", " +
	"\"etc_amt_n\" : \"" + etcAmtN + "\"" +
"}";
System.out.println("empInfo :: " + empInfo);

out.print(empInfo);
%>