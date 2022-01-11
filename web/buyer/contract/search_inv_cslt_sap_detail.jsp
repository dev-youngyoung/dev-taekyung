<%@page import="java.text.DecimalFormat"%>
<%@ page contentType="text/html; charset=UTF-8" %><%@ include file="../init.jsp" %>
<%@ page import="nicelib.sap.*" %>
<%
String investNo = u.request("invest_no");
String investSeq = u.request("invest_seq");
String formId = u.request("form_id");

InvestConsultSap investConsultSap = new InvestConsultSap();
DataSet sapDetail = investConsultSap.getInvestConsultSapDetail(investNo, investSeq, formId);
sapDetail.next();

DecimalFormat formatter = new DecimalFormat("#,##0.0");
String sapDetailInfo = "";
if (formId.equals("1")) {
	String posId = sapDetail.getString("posId"); // contPosId
	String seq = sapDetail.getString("seq"); // contSeq
	String item = sapDetail.getString("item"); // contNameSub
	String empNo = sapDetail.getString("empNo"); // contIputEmpNo
	String lifnr = sapDetail.getString("lifnr"); // contSuplCode
	String lifnrt = sapDetail.getString("lifnrt"); // contSuplName
	String stcd2 = sapDetail.getString("stcd2"); // contBizNo
	String target = sapDetail.getString("target"); // contAttr0101
	String place = sapDetail.getString("place"); // contDeliPlace
	String place2 = sapDetail.getString("place2"); // contDeliFacto
	
	String period = sapDetail.getString("period"); // contAttr0102
	String sdate = sapDetail.getString("sdate"); // contDateFrom
	String edate = sapDetail.getString("edate"); // contDateTo
	String total = sapDetail.getString("total"); // contAmt
	String deposit = sapDetail.getString("deposit"); // contGuarAmt
	String defact = sapDetail.getString("defact"); // contWarrDate
	String def_rate = sapDetail.getString("def_rate"); // contWarrPer
	String defer = sapDetail.getString("defer"); // contDelayRate
	String rate_be = sapDetail.getString("rate_be"); // contPrepPaymRete
	String amt_be = sapDetail.getString("amt_be"); // contAttr0106
	
	String rate_01 = sapDetail.getString("rate_01"); // contAttr0108
	String rate1_01 = sapDetail.getString("rate1_01"); // contAttr0107
	String amt_01 = sapDetail.getString("amt_01"); // contAttr0109
	String rate_02 = sapDetail.getString("rate_02"); // contAttr0111
	String rate1_02 = sapDetail.getString("rate1_02"); // contAttr0110
	String amt_02 = sapDetail.getString("amt_02"); // contAttr0112
	String rate_03 = sapDetail.getString("rate_03"); // contAttr0114
	String rate1_03 = sapDetail.getString("rate1_03"); // contAttr0113
	String amt_03 = sapDetail.getString("amt_03"); // contAttr0115
	
	sapDetailInfo = 
		"{" +
			"\"posId\" : \"" + posId + "\", " +
			"\"seq\" : \"" + seq + "\", " +
			"\"cont_name_sub\" : \"" + item + "\", " +
			"\"empNo\" : \"" + empNo + "\", " +
			"\"lifnr\" : \"" + lifnr + "\", " +
			"\"lifnrt\" : \"" + lifnrt + "\", " +
			"\"stcd2\" : \"" + stcd2 + "\", " +
			"\"cont_attr_01_01\" : \"" + target + "\", " +
			"\"deli_place\" : \"" + place + "\", " +
			"\"deli_facto\" : \"" + place2 + "\", " +
			
			"\"cont_attr_01_02\" : \"" + period + "\", " +
			"\"cont_date_from\" : \"" + sdate + "\", " +
			"\"cont_date_to\" : \"" + edate + "\", " +
			"\"cont_amt\" : \"" + total + "\", " +
			"\"cont_guar_amt\" : \"" + formatter.format(Double.parseDouble(deposit)) + "\", " +
			"\"warr_date\" : \"" + defact + "\", " +
			"\"cont_warr_per\" : \"" + formatter.format(Double.parseDouble(def_rate)) + "\", " +
			"\"delay_rate\" : \"" + formatter.format(Double.parseDouble(defer)) + "\", " +
			"\"prep_paym_rete\" : \"" + formatter.format(Double.parseDouble(rate_be)) + "\", " +
			"\"cont_attr_01_06\" : \"" + amt_be + "\", " +
			
			"\"cont_attr_01_08\" : \"" + formatter.format(Double.parseDouble(rate_01)) + "\", " +
			"\"cont_attr_01_07\" : \"" + formatter.format(Double.parseDouble(rate1_01)) + "\", " +
			"\"cont_attr_01_09\" : \"" + amt_01 + "\", " +
			"\"cont_attr_01_11\" : \"" + formatter.format(Double.parseDouble(rate_02)) + "\", " +
			"\"cont_attr_01_10\" : \"" + formatter.format(Double.parseDouble(rate1_02)) + "\", " +
			"\"cont_attr_01_12\" : \"" + amt_02 + "\", " +
			"\"cont_attr_01_14\" : \"" + formatter.format(Double.parseDouble(rate_03)) + "\", " +
			"\"cont_attr_01_13\" : \"" + formatter.format(Double.parseDouble(rate1_03)) + "\", " +
			"\"cont_attr_01_15\" : \"" + amt_03 + "\", " +
			"\"invest_no\" : \"" + investNo + "\", " +
			"\"invest_seq\" : \"" + investSeq + "\" " +
		"}";
	
} else if (formId.equals("2")) {
	String posId = sapDetail.getString("posId"); // contPosId
	String seq = sapDetail.getString("seq"); // contSeq
	String item = sapDetail.getString("item"); // contNameSub
	String empNo = sapDetail.getString("empNo"); // contIputEmpNo
	String lifnr = sapDetail.getString("lifnr"); // contSuplCode
	String lifnrt = sapDetail.getString("lifnrt"); // contSuplName
	String stcd2 = sapDetail.getString("stcd2"); // contBizNo
	String target = sapDetail.getString("target"); // contAttr0201
	String place = sapDetail.getString("place"); // contDeliPlace
	String total = sapDetail.getString("total"); // contAmt
	
	String deposit = sapDetail.getString("deposit"); // contGuarAmt
	String defact = sapDetail.getString("defact"); // contWarrDate
	String def_rate = sapDetail.getString("def_rate"); // contWarrPer
	String defer = sapDetail.getString("defer"); // contDelayRate
	String rate_be = sapDetail.getString("rate_be"); // contPrepPaymRete
	String amt_be = sapDetail.getString("amt_be"); // contAttr0213
	String rate_01 = sapDetail.getString("rate_01"); // contAttr0216
	String rate1_01 = sapDetail.getString("rate1_01"); // contAttr0218
	String amt_01 = sapDetail.getString("amt_01"); // contAttr0217
	String rate_02 = sapDetail.getString("rate_02"); // contAttr0219
	
	String rate1_02 = sapDetail.getString("rate1_02"); // contAttr0221
	String amt_02 = sapDetail.getString("amt_02"); // contAttr0220
	String rate_03 = sapDetail.getString("rate_03"); // contAttr0222
	String rate1_03 = sapDetail.getString("rate1_03"); // contAttr0224
	String amt_03 = sapDetail.getString("amt_03"); // contAttr0223
	String rate_00 = sapDetail.getString("rate_00"); // contAttr0214
	String amt_00 = sapDetail.getString("amt_00"); // contAttr0215
	String rate_ed = sapDetail.getString("rate_ed"); // contAttr0225
	String amt_ed = sapDetail.getString("amt_ed"); // contAttr0226
	String c_fdate = sapDetail.getString("c_fdate"); // contDateFrom
	
	String c_tdate = sapDetail.getString("c_tdate"); // contDateTo
	String r_fdate = sapDetail.getString("r_fdate"); // contAttr0206
	String r_tdate = sapDetail.getString("r_tdate"); // contAttr0207
	String v_fdate = sapDetail.getString("v_fdate"); // contAttr0208
	String v_tdate = sapDetail.getString("v_tdate"); // contAttr0209
	String standa = sapDetail.getString("standa"); // contAttr0202
	String condi = sapDetail.getString("condi"); // contAttr0203
	
	sapDetailInfo = 
		"{" +
			"\"posId\" : \"" + posId + "\", " +
			"\"seq\" : \"" + seq + "\", " +
			"\"cont_name_sub\" : \"" + item + "\", " +
			"\"empNo\" : \"" + empNo + "\", " +
			"\"lifnr\" : \"" + lifnr + "\", " +
			"\"lifnrt\" : \"" + lifnrt + "\", " +
			"\"stcd2\" : \"" + stcd2 + "\", " +
			"\"cont_attr_02_01\" : \"" + target + "\", " +
			"\"deli_place\" : \"" + place + "\", " +
			"\"cont_amt\" : \"" + total + "\", " +
			
			"\"cont_guar_amt\" : \"" + formatter.format(Double.parseDouble(deposit)) + "\", " +
			"\"warr_date\" : \"" + defact + "\", " +
			"\"cont_warr_per\" : \"" + formatter.format(Double.parseDouble(def_rate)) + "\", " +
			"\"delay_rate\" : \"" + formatter.format(Double.parseDouble(defer)) + "\", " +
			"\"prep_paym_rete\" : \"" + formatter.format(Double.parseDouble(rate_be)) + "\", " +
			"\"cont_attr_02_13\" : \"" + amt_be + "\", " +
			"\"cont_attr_02_16\" : \"" + formatter.format(Double.parseDouble(rate_01)) + "\", " +
			"\"cont_attr_02_18\" : \"" + formatter.format(Double.parseDouble(rate1_01)) + "\", " +
			"\"cont_attr_02_17\" : \"" + amt_01 + "\", " +
			"\"cont_attr_02_19\" : \"" + formatter.format(Double.parseDouble(rate_02)) + "\", " +
			
			"\"cont_attr_02_21\" : \"" + formatter.format(Double.parseDouble(rate1_02)) + "\", " +
			"\"cont_attr_02_20\" : \"" + amt_02 + "\", " +
			"\"cont_attr_02_22\" : \"" + formatter.format(Double.parseDouble(rate_03)) + "\", " +
			"\"cont_attr_02_24\" : \"" + formatter.format(Double.parseDouble(rate1_03)) + "\", " +
			"\"cont_attr_02_23\" : \"" + amt_03 + "\", " +
			"\"cont_attr_02_14\" : \"" + formatter.format(Double.parseDouble(rate_00)) + "\", " +
			"\"cont_attr_02_15\" : \"" + amt_00 + "\", " +
			"\"cont_attr_02_25\" : \"" + formatter.format(Double.parseDouble(rate_ed)) + "\", " +
			"\"cont_attr_02_26\" : \"" + amt_ed + "\", " +
			"\"cont_date_from\" : \"" + c_fdate + "\", " +
			
			"\"cont_date_to\" : \"" + c_tdate + "\", " +
			"\"cont_attr_02_06\" : \"" + r_fdate + "\", " +
			"\"cont_attr_02_07\" : \"" + r_tdate + "\", " +
			"\"cont_attr_02_08\" : \"" + v_fdate + "\", " +
			"\"cont_attr_02_09\" : \"" + v_tdate + "\", " +
			"\"cont_attr_02_02\" : \"" + standa + "\", " +
			"\"cont_attr_02_03\" : \"" + condi + "\", " +
			"\"invest_no\" : \"" + investNo + "\", " +
			"\"invest_seq\" : \"" + investSeq + "\" " +
		"}";
}
System.out.println("sapDetailInfo ::: " + sapDetailInfo);
out.print(sapDetailInfo);
%>