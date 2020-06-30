package ktnet;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.http.ProtocolException;

import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.exception.ValidationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

import nicelib.db.DB;
import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.pdf.PDFMaker;
import nicelib.util.Page;
import nicelib.util.Util;
import procure.common.conf.Startup;

/**
 * ���� ���� Ȯ�� ��ȸ(������ �°� �������� ������ �ݾ׵� ����)
 */
public class StampManager {
	         
	/**
     * ����ȣ�� ���� ���� ��ȣ ��û
     */
    private static Map<String, String> getIssueReqNo(String contractNo)
            throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        Map<String, String> paramMap = new HashMap<String, String>();
        Map<String, String> resultMap = new HashMap<String, String>();

        paramMap.put("contractNo", contractNo);            //����ȣ

        EtsHubManager etsHubManager = new EtsHubManager();
        resultMap = etsHubManager.getIssueReqNumber(paramMap);

        return resultMap;
    }
	/*
	 * �����ݾ�Ȯ��
	 * if(dCont_total <= 10000000) // 1000���� ����
			dstamp_amt = 0;
		else if(dCont_total > 10000000 && dCont_total <= 30000000) // 1000���� ����
			dstamp_amt = 20000;
		else if(dCont_total > 30000000 && dCont_total <= 50000000) // 5000���� ����
			dstamp_amt = 40000;
		else if(dCont_total > 50000000 && dCont_total <= 100000000) // 1�� ����
			dstamp_amt = 70000;
		else if(dCont_total > 100000000 && dCont_total <= 1000000000) // 10�� ����
			dstamp_amt = 150000;
		else if(dCont_total > 1000000000) // 10�� �ʰ�
			dstamp_amt = 350000;
	 * */
    public static String getTaxAmount(String cont_total) throws Exception {
		/*Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("contractType", "030");
		paramMap.put("contractAmount", cont_total);
		
		EtsHubManager etsHubManager = new EtsHubManager();
		Map<String, String> resultMap = etsHubManager.getIssueTaxAmount(paramMap);
		
		String taxAmount = resultMap.get("taxAmount");*/
    	if(cont_total.equals(""))return"";
    	String taxAmount = "";
    	double dCont_total = Double.parseDouble(cont_total);
    	if(dCont_total <= 10000000) // 1000���� ����
    		taxAmount = "0";
		else if(dCont_total > 10000000 && dCont_total <= 30000000) // 1000���� ����
			taxAmount = "20000";
		else if(dCont_total > 30000000 && dCont_total <= 50000000) // 5000���� ����
			taxAmount = "40000";
		else if(dCont_total > 50000000 && dCont_total <= 100000000) // 1�� ����
			taxAmount = "70000";
		else if(dCont_total > 100000000 && dCont_total <= 1000000000) // 10�� ����
			taxAmount = "150000";
		else if(dCont_total > 1000000000) // 10�� �ʰ�
			taxAmount = "350000";
		
		return taxAmount;
	}
    
    
    public static DataSet getPayList(String cont_no, String cont_chasu) throws Exception {
    	DataSet ds = new DataSet();
    	
    	Map<String, String> paramMap = new HashMap<String, String>();
        paramMap.put("contractNo", cont_no);                        //����ȣ
        paramMap.put("contractNoSeq", cont_chasu);                                //����ȣ����

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getIssueCfrmPayList(paramMap);

        //System.out.println("# resultMap : " + resultMap);
        ArrayList resultList = JsonUtil.toObject(resultMap.get("resultList"), ArrayList.class);
         
        //System.out.println("# size : " + resultList.size());
         
        for(int i = 0 ; i < resultList.size() ; i++){
        	ds.addRow();
            Map map = (Map)resultList.get(i);
            Iterator<String> keys = map.keySet().iterator();
            while(keys.hasNext()) {
            	String key = keys.next();
            	ds.put(key, map.get(key));
            }
            //System.out.println("# [ " +i+ " ] " + map);
        }
        ds.first();
        return ds;
    }
    
    
    /*
     * ������ ���� ���� URL���� ���� ��û ��ȣ�� ��ȸ�� ��û ��ȣ��.
     * */
    public static String getPurchaseUrl_K(String cont_no, String cont_chasu,String cont_name, String cont_date, String cont_total,  String vendcd, String member_name, String hp_no, String email, String stamp_amt) throws Exception{
    	
    	String url = "";
        
        //1�ܰ� ��û��ȣ ���ϱ�
    	Map<String, String> resultMap =  getIssueReqNo(cont_no);
    	
    	String resultCode = (String) resultMap.get("resultCode");
        String resultMessage = (String) resultMap.get("resultMessage");
        // 2�ܰ� ���� URL����
        if (!resultCode.equals("900")) {
        	System.out.println("code : " + resultCode);
	        System.out.println("message : " + resultMessage);
        	return "";
        }
    	String purchaseUrl = (String) resultMap.get("purchaseUrl");
    	String issueDivisionCode = (String) resultMap.get("issueDivisionCode");
    	String issueReqNo = (String) resultMap.get("issueReqNo");
		
    	url =  
    		purchaseUrl //��������  URL
    		+ "?infToolMngNo=" + resultMap.get("infToolMngNo")//??? 
    		+ "&infToolBizNo=" + resultMap.get("infToolBizNo") //???
    		+ "&issueDivisionCode=" + (String) resultMap.get("issueDivisionCode") //???
    		+ "&issueReqNo=" + (String) resultMap.get("issueReqNo")//���� ��ȣ
    		+ "&issueAmount=" + stamp_amt //������ �������� �ݾ�
    		+ "&inAmtDisable=Y"//��ü �ݾ� ���� ���� ��Ȱ��ȭ
    		//�������
    		+ "&contractType=" + "030"//���Ÿ��
    		+ "&contractNo=" + cont_no //����ȣ
    		+ "&contractNoSeq=" + cont_chasu //����ȣ ����
    		+ "&contractTitle=" + URLEncoder.encode(cont_name, "UTF-8") //����
    		+ "&contractDate=" + cont_date //�������
    		+ "&contractAmount=" + cont_total//���ݾ�
    		//������ ����
    		+ "&contractParties=" +  URLEncoder.encode(member_name, "UTF-8")// ������ �����
    		+ "&issueBizNo=" + vendcd //������ ����� ��Ϲ�ȣ
    		+ "&mobileNumber=" + hp_no //������ �޴�����ȣ
    		+ "&email=" + email//������ �̸��� 
    		;
    	
    	return url;
    }
    
    /*
     * �ش� �������� �����ݾ��� �ϳ��̵Ǿ����� Ȯ��
     * */
    public static boolean chkPayComplete_K(String cont_no , String cont_chasu)throws Exception {
		int stamp_amt_sum = 0;//�����ѱݾ�
		String cont_total = "";
		DataObject contDao = new DataObject("tck_contmaster");
    	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu <='"+cont_chasu+"' ","*","cont_chasu asc");
    	while(cont.next()) {
    		if(cont.getString("cont_chasu").equals(cont_chasu)) {
    			cont_total = cont.getString("cont_total");
    		}
    		DataSet info = getPayList(cont.getString("cont_no"), cont.getString("cont_chasu"));
    		while(info.next()) {
    			stamp_amt_sum += info.getInt("paymentAmount");
    		}
    	}
    	
    	String stamp_tax = getTaxAmount(cont_total);
    	if(stamp_tax.equals(stamp_amt_sum+"")) {
    		return true;
    	}
    	
    	return false;
    }
    
    /*
     * ������ �ϳ����θ� Ȯ�� �ϰ� ��༭ �������� Ȯ�μ� ����
     * ��༭������ ������ �߱޵ȴ�.
     * */
    public static boolean makeStampPdf_K(String cont_no, String cont_chasu) throws Exception {
    	
    	//�ϳ����� Ȯ��
    	int stamp_amt_sum = 0;//�����ѱݾ�
		String cont_total = "";
		String status = "";
		String stamp_file_path = "";
		
		DataObject contDao = new DataObject("tck_contmaster");
    	DataSet cont = contDao.find("cont_no = '"+cont_no+"' and cont_chasu <='"+cont_chasu+"' ","*","cont_chasu asc");
    	
    	DataObject custDao = new DataObject("tck_cust");
    	DataSet cust = custDao.find("cont_no = '"+cont_no+"' and cont_chasu <='"+cont_chasu+"' ","*","cont_chasu asc");
    	
    	DataSet stamp = new DataSet();
    	
    	while(cont.next()) {
    		if(cont.getString("cont_chasu").equals(cont_chasu)) {
    			cont_total = cont.getString("cont_total");
    			status = cont.getString("status");
    			stamp_file_path = cont.getString("stamp_file_path");
    		}
    		System.out.println("----------------------------------------------------------------------getPayList START");
    		DataSet info = getPayList(cont.getString("cont_no"), cont.getString("cont_chasu"));
    		System.out.println("----------------------------------------------------------------------getPayList END");
    		while(info.next()) {
    			stamp.addRow();
    			stamp.put("cont_no", cont.getString("cont_no"));
    			stamp.put("cont_chasu", cont.getString("cont_chasu"));
    			stamp.put("cont_chasu_nm", cont.getString("cont_chasu").equals("0")?"����":"����"+cont.getString("cont_chasu")+"��");
    			String member_name ="";
    			cust.first();
    			while(cust.next()) {
    				if(cont.getString("cont_chasu").equals(cust.getString("cont_chasu")) && cust.getString("vendcd").equals(info.getString("issueBizNo"))) {
    					member_name = cust.getString("member_name");
    					break;
    				}
    			}
    			stamp.put("member_name", member_name);
    			stamp.put("cert_no", info.getString("uniqueId"));
    			stamp.put("issue_date", Util.getTimeString("yyyy-MM-dd HH:mm",info.getString("paymentDttm")));
    			stamp.put("stamp_amt", Util.numberFormat(info.getInt("paymentAmount")));
    			stamp_amt_sum += info.getInt("paymentAmount");
    		}
    	}
    	
    	if(!Util.inArray(status, new String[] {"50","60","70"})) {
    		return false;
    	}
    	if(!stamp_file_path.equals("")) {
    		return false;
    	}
    	
    	System.out.println(stamp.toString());
    	System.out.println("----------------------------------------------------------------------getTaxAmount START");
    	String stamp_tax = getTaxAmount(cont_total);
    	System.out.println("----------------------------------------------------------------------getTaxAmount END");
    	
    	System.out.println("----------������ �߱� ���� START----------------");
    	System.out.println("cont_total => "+ cont.getString("cont_total"));
    	System.out.println("stamp_tax => "+ stamp_tax);
    	System.out.println("stamp_amt_sum => "+ stamp_amt_sum);
    	System.out.println("----------������ �߱� ���� END----------------");
    	
    	
    	if(Double.parseDouble(stamp_tax) > Double.parseDouble(stamp_amt_sum+"")) {
    		return false;
    	}
    	
    	DataObject fieldDao = new DataObject("tck_field");
    	DataSet field = fieldDao.find(" member_no = '"+cont.getString("member_no")+"' and field_seq = '"+cont.getString("field_seq")+"'");
    	if(!field.next()) {
    		return false;
    	}
    	cont.put("order_field_name", field.getString("order_field_name"));
    	cont.put("field_name", field.getString("field_name"));
    	cont.put("cont_date", Util.getTimeString("yyyy-MM-dd", cont.getString("cont_date")));
    	cont.put("cont_total", Util.numberFormat(cont.getString("cont_total")));
    	cont.put("stamp_tax", Util.numberFormat(stamp_tax));
    	cont.put("stamp_amt_sum", Util.numberFormat(stamp_amt_sum));
    	
    	DataSet cust1 = custDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and cust_gubun in ('10','11')");
    	while(cust1.next()) {
    		cust1.put("vendcd",cust1.getString("vendcd").substring(0, 3) + "-" + cust1.getString("vendcd").substring(3, 5) + "-" + cust1.getString("vendcd").substring(5));
    	}
    	
    	DataSet cust2 = custDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' and cust_gubun in ('20','21')");
    	while(cust2.next()) {
    		cust2.put("vendcd",cust2.getString("vendcd").substring(0, 3) + "-" + cust2.getString("vendcd").substring(3, 5) + "-" + cust2.getString("vendcd").substring(5));
    	}
    	
    	
    	//���������� Ȯ�μ� ����
    	Page p = new Page(Startup.conf.getString("nicelib.supplier_root")+"/html"); 
    	p.setVar("cont",cont);
    	p.setLoop("stamp", stamp);
    	p.setLoop("cust1", cust1);
    	p.setLoop("cust2", cust2);
    	String stamp_html = p.fetch("../html/contract/stamp_doc.html");
    	System.out.println(stamp_html);
    	String pdfDir = procure.common.conf.Startup.conf.getString("file.path.supplier.contract");
    	DataObject cfileDao = new DataObject("tck_cfile");
    	DataSet cfile = cfileDao.find("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ","*","cfile_seq asc");
    	if(!cfile.next()) {
    		return false;
    	}
    	
    	String stamp_file_name = cfile.getString("file_name").substring(0,cfile.getString("file_name").lastIndexOf("."))+"_stamp."+cfile.getString("file_ext");
    	String stamp_file = pdfDir+cfile.getString("file_path")+  stamp_file_name;
    	
    	System.out.println("stamp_file_path=>"+stamp_file);
    	PDFMaker pdfMaker = new PDFMaker();
    	String fontSize = "12px";
    	StringBuffer documentContentsBefore = new StringBuffer();
		documentContentsBefore.append("<!DOCTYPE html>");
		documentContentsBefore.append("<html lang=\"ko\">");
		documentContentsBefore.append("<head>");
		documentContentsBefore.append("<meta charset=\"EUC-KR\">");
		documentContentsBefore.append("<meta http-equiv=\"Content-Type\" content=\"text/html; charset=EUC-KR\">");
		documentContentsBefore.append("<style type=\"text/css\">");
		documentContentsBefore.append("<!--");
		documentContentsBefore.append("		td {  font-family: \"�������\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
		documentContentsBefore.append("		.lineTable { border-collapse:collapse; border:1 solid black }");
		documentContentsBefore.append("		.lineTable td { border:1px solid black }");
		documentContentsBefore.append("		.lineTable .noborder { border:0px }");	
		documentContentsBefore.append("-->");
		documentContentsBefore.append("</style>");
		documentContentsBefore.append("</head><body>");
		documentContentsBefore.append(stamp_html);
		documentContentsBefore.append("</body></html>");
		
		pdfMaker.setContNo(cont.getString("cont_no"), cont.getString("cont_chasu"), cont.getString("random_no"));
		pdfMaker.setHtmlWidth(750);
		pdfMaker.setFooter("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">*�� ������ ���̽���ť(http://www.nicedocu.com)�� ���� ���� �Ǿ����ϴ�.</font></span>");
		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString(), pdfDir+cfile.getString("file_path"), stamp_file_name);
		if(!result){
			return false;
		}
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("contractNo", cont_no);// ����ȣ
		paramMap.put("contractTitle", cont.getString("cont_name"));// �ŷ�(���)��
		paramMap.put("contractDate", cont.getString("cont_date").replaceAll("-", ""));// �ŷ�(���)ü����
		paramMap.put("contractType", "030");// �ŷ�(���) Ÿ��
		paramMap.put("contractAmount", cont.getString("cont_total").replaceAll(",", ""));// �ŷ�(���)�ݾ�
		paramMap.put("contractFilePath", stamp_file);// ���� ���ϸ� �Է� API�� ���� �� ���ؼ� ��� �ִ� �Ķ���Ͷ�� ��.
		paramMap.put("stampPdfPath", stamp_file);// ���ڼ������� �߱� ���ڹ��� ���� ���
		
		System.out.println("������ ���� �߱�ó�� START");
		EtsHubManager etsHubManager = new EtsHubManager();
		Map<String, String> resultMap = etsHubManager.stampIssueChange(paramMap);
		String resultCode = (String) resultMap.get("resultCode");
		System.out.println(resultMap);
		if(!resultCode.equals("900")) {
			return false;
		}
		System.out.println("������ ���� �߱�ó�� END");
		
		contDao = new DataObject("tck_contmaster");
		contDao.item("stamp_file_path", cfile.getString("file_path")+  stamp_file_name);
		if(!contDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ")){
			return false;
		}
		
		return true;
    }
    
    
    
    
    
}