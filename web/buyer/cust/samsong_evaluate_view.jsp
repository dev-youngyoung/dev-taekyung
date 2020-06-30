<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp" %>
<%
String[] code_status = {"10=>�ۼ���","20=>Ȯ��"};

String yyyymm = u.request("yyyymm");
String mode =  u.request("mode");
DataObject evaluateDao = new DataObject("tcb_samsong_evaluate");
DataSet evaluate = new DataSet();
if(!mode.equals("new")){
	evaluate = evaluateDao.find(" yyyymm = '" + yyyymm + "' ");
	if(!evaluate.next()){
		u.jsError("�������� �����ϴ�.");
		return;
	}
	evaluate.put("status_nm", u.getItem(evaluate.getString("status"),code_status));
	evaluate.put("end_yn", evaluate.getString("status").equals("20"));
}else{
	evaluate.addRow();
	evaluate.put("status_nm", "�ۼ���");
	yyyymm=u.getTimeString("yyyyMM");
}



f.addElement("yyyymm", yyyymm, "required:'Y',hname:'���س��',fixbyte:'6'");
if (u.isPost()&&f.validate()) {
	
	String grid = URLDecoder.decode(f.get("data"),"UTF-8"); 
			
	DB db = new DB();
	
	if(mode.equals("new")&&evaluateDao.findCount("yyyymm='"+f.get("yyyymm")+"'")>0){
		u.jsError("�̵̹�ϵ� �򰡳���Դϴ�.\\n\\n�ش���� �˻��Ͽ� �����ϼ���.");
		return;
	}
	
	evaluateDao = new DataObject("tcb_samsong_evaluate");
	if(evaluateDao.findCount("yyyymm='"+f.get("yyyymm")+"'")<1){
		evaluateDao.item("yyyymm", f.get("yyyymm"));
		evaluateDao.item("reg_date", u.getTimeString());
		evaluateDao.item("reg_id", auth.getString("_USER_ID"));
		evaluateDao.item("mod_date", u.getTimeString());
		evaluateDao.item("mod_id", auth.getString("_USER_ID"));
		evaluateDao.item("status", "10");
		db.setCommand(evaluateDao.getInsertQuery(), evaluateDao.record);
	}else{
		evaluateDao.item("mod_date", u.getTimeString());
		evaluateDao.item("mod_id", auth.getString("_USER_ID"));
		db.setCommand(evaluateDao.getUpdateQuery("yyyymm='"+f.get("yyyymm")+"' "), evaluateDao.record);
		DataObject evaluateSuppDao = new DataObject("tcb_samsong_evaluate_supp");
		db.setCommand(evaluateSuppDao.getDeleteQuery("yyyymm='"+f.get("yyyymm")+"' "), null);
	}
	
	DataSet data =  u.grid2dataset(grid);
    
    while (data.next()) {
        DataObject evaluateSuppDao = new DataObject("tcb_samsong_evaluate_supp");
        evaluateSuppDao.item("yyyymm", f.get("yyyymm"));
        evaluateSuppDao.item("vendcd", data.getString("vendcd").replaceAll("-", ""));
        evaluateSuppDao.item("q_point", data.getString("q_point"));
        evaluateSuppDao.item("s_point", data.getString("s_point"));
        evaluateSuppDao.item("t_point", data.getString("t_point"));
        evaluateSuppDao.item("status", "10");
        evaluateSuppDao.item("member_name", data.getString("member_name"));
        db.setCommand(evaluateSuppDao.getInsertQuery(), evaluateSuppDao.record);
    }

    if(!db.executeArray()){
    	u.jsError("����ó���� �����Ͽ����ϴ�.");
    	return;
    }
    u.jsAlertReplace("�����Ͽ����ϴ�", "./samsong_evaluate_view.jsp?yyyymm="+f.get("yyyymm")+"&"+u.getQueryString("yyyymm,mode"));
    return;
}



p.setLayout("default");
p.setBody("cust.samsong_evaluate_view");
p.setVar("menu_cd","000184");
p.setVar("modify", !u.request("yyyymm").equals(""));
p.setVar("query", u.getQueryString());
p.setVar("evaluate", evaluate);
p.setVar("list_query", u.getQueryString("yyyymm,mode"));
p.setVar("form_script", f.getScript());
p.display(out);
%>