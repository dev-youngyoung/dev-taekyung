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
 * 결제 납부 확인 조회(차수에 맞게 가져오고 인지세 금액도 구함)
 */
public class StampManager {
	         
	/**
     * 계약번호에 따른 구매 번호 신청
     */
    private static Map<String, String> getIssueReqNo(String contractNo)
            throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        Map<String, String> paramMap = new HashMap<String, String>();
        Map<String, String> resultMap = new HashMap<String, String>();

        paramMap.put("contractNo", contractNo);            //계약번호

        EtsHubManager etsHubManager = new EtsHubManager();
        resultMap = etsHubManager.getIssueReqNumber(paramMap);

        return resultMap;
    }
	/*
	 * 인지금액확인
	 * if(dCont_total <= 10000000) // 1000만원 이하
			dstamp_amt = 0;
		else if(dCont_total > 10000000 && dCont_total <= 30000000) // 1000만원 이하
			dstamp_amt = 20000;
		else if(dCont_total > 30000000 && dCont_total <= 50000000) // 5000만원 이하
			dstamp_amt = 40000;
		else if(dCont_total > 50000000 && dCont_total <= 100000000) // 1억 이하
			dstamp_amt = 70000;
		else if(dCont_total > 100000000 && dCont_total <= 1000000000) // 10억 이하
			dstamp_amt = 150000;
		else if(dCont_total > 1000000000) // 10억 초과
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
    	if(dCont_total <= 10000000) // 1000만원 이하
    		taxAmount = "0";
		else if(dCont_total > 10000000 && dCont_total <= 30000000) // 1000만원 이하
			taxAmount = "20000";
		else if(dCont_total > 30000000 && dCont_total <= 50000000) // 5000만원 이하
			taxAmount = "40000";
		else if(dCont_total > 50000000 && dCont_total <= 100000000) // 1억 이하
			taxAmount = "70000";
		else if(dCont_total > 100000000 && dCont_total <= 1000000000) // 10억 이하
			taxAmount = "150000";
		else if(dCont_total > 1000000000) // 10억 초과
			taxAmount = "350000";
		
		return taxAmount;
	}
    
    
    public static DataSet getPayList(String cont_no, String cont_chasu) throws Exception {
    	DataSet ds = new DataSet();
    	
    	Map<String, String> paramMap = new HashMap<String, String>();
        paramMap.put("contractNo", cont_no);                        //계약번호
        paramMap.put("contractNoSeq", cont_chasu);                                //계약번호차수

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
     * 인지세 구입 가능 URL생성 구매 요청 번호는 일회성 요청 번호임.
     * */
    public static String getPurchaseUrl_K(String cont_no, String cont_chasu,String cont_name, String cont_date, String cont_total,  String vendcd, String member_name, String hp_no, String email, String stamp_amt) throws Exception{
    	
    	String url = "";
        
        //1단계 신청번호 구하기
    	Map<String, String> resultMap =  getIssueReqNo(cont_no);
    	
    	String resultCode = (String) resultMap.get("resultCode");
        String resultMessage = (String) resultMap.get("resultMessage");
        // 2단계 구매 URL저장
        if (!resultCode.equals("900")) {
        	System.out.println("code : " + resultCode);
	        System.out.println("message : " + resultMessage);
        	return "";
        }
    	String purchaseUrl = (String) resultMap.get("purchaseUrl");
    	String issueDivisionCode = (String) resultMap.get("issueDivisionCode");
    	String issueReqNo = (String) resultMap.get("issueReqNo");
		
    	url =  
    		purchaseUrl //구맹진행  URL
    		+ "?infToolMngNo=" + resultMap.get("infToolMngNo")//??? 
    		+ "&infToolBizNo=" + resultMap.get("infToolBizNo") //???
    		+ "&issueDivisionCode=" + (String) resultMap.get("issueDivisionCode") //???
    		+ "&issueReqNo=" + (String) resultMap.get("issueReqNo")//구매 번호
    		+ "&issueAmount=" + stamp_amt //구매할 수입인지 금액
    		+ "&inAmtDisable=Y"//업체 금액 정보 수정 비활성화
    		//계약정보
    		+ "&contractType=" + "030"//계약타입
    		+ "&contractNo=" + cont_no //계약번호
    		+ "&contractNoSeq=" + cont_chasu //계약번호 차수
    		+ "&contractTitle=" + URLEncoder.encode(cont_name, "UTF-8") //계약명
    		+ "&contractDate=" + cont_date //계약일자
    		+ "&contractAmount=" + cont_total//계약금액
    		//구매자 정보
    		+ "&contractParties=" +  URLEncoder.encode(member_name, "UTF-8")// 구매자 기업명
    		+ "&issueBizNo=" + vendcd //구매자 사업자 등록번호
    		+ "&mobileNumber=" + hp_no //구매자 휴대폰번호
    		+ "&email=" + email//구매자 이메일 
    		;
    	
    	return url;
    }
    
    /*
     * 해당 차수까지 인지금액이 완납이되었는지 확인
     * */
    public static boolean chkPayComplete_K(String cont_no , String cont_chasu)throws Exception {
		int stamp_amt_sum = 0;//납부총금액
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
     * 인지세 완납여부를 확인 하고 계약서 인지납부 확인서 생성
     * 계약서파일은 복사후 발급된다.
     * */
    public static boolean makeStampPdf_K(String cont_no, String cont_chasu) throws Exception {
    	
    	//완납여부 확인
    	int stamp_amt_sum = 0;//납부총금액
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
    			stamp.put("cont_chasu_nm", cont.getString("cont_chasu").equals("0")?"최초":"변경"+cont.getString("cont_chasu")+"차");
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
    	
    	System.out.println("----------인지세 발급 정보 START----------------");
    	System.out.println("cont_total => "+ cont.getString("cont_total"));
    	System.out.println("stamp_tax => "+ stamp_tax);
    	System.out.println("stamp_amt_sum => "+ stamp_amt_sum);
    	System.out.println("----------인지세 발급 정보 END----------------");
    	
    	
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
    	
    	
    	//인지세납부 확인서 생성
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
		documentContentsBefore.append("		td {  font-family: \"나눔고딕\",\"Arial\"; font-size: "+fontSize+"; font-style: normal; letter-spacing:0; color: black;line-height:150%}");
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
		pdfMaker.setFooter("<span><font style=\"font-size:12px\" color=\"#5B5B5B\">*본 문서는 나이스다큐(http://www.nicedocu.com)를 통해 생성 되었습니다.</font></span>");
		boolean result = pdfMaker.generatePDF(documentContentsBefore.toString(), pdfDir+cfile.getString("file_path"), stamp_file_name);
		if(!result){
			return false;
		}
		
		Map<String, String> paramMap = new HashMap<String, String>();
		paramMap.put("contractNo", cont_no);// 계약번호
		paramMap.put("contractTitle", cont.getString("cont_name"));// 거래(계약)명
		paramMap.put("contractDate", cont.getString("cont_date").replaceAll("-", ""));// 거래(계약)체결일
		paramMap.put("contractType", "030");// 거래(계약) 타입
		paramMap.put("contractAmount", cont.getString("cont_total").replaceAll(",", ""));// 거래(계약)금액
		paramMap.put("contractFilePath", stamp_file);// 동일 파일명 입력 API를 제거 를 못해서 살아 있는 파라미터라고 함.
		paramMap.put("stampPdfPath", stamp_file);// 전자수입인지 발급 전자문서 파일 경로
		
		System.out.println("인지세 문서 발급처리 START");
		EtsHubManager etsHubManager = new EtsHubManager();
		Map<String, String> resultMap = etsHubManager.stampIssueChange(paramMap);
		String resultCode = (String) resultMap.get("resultCode");
		System.out.println(resultMap);
		if(!resultCode.equals("900")) {
			return false;
		}
		System.out.println("인지세 문서 발급처리 END");
		
		contDao = new DataObject("tck_contmaster");
		contDao.item("stamp_file_path", cfile.getString("file_path")+  stamp_file_name);
		if(!contDao.update("cont_no = '"+cont_no+"' and cont_chasu = '"+cont_chasu+"' ")){
			return false;
		}
		
		return true;
    }
    
    
    
    
    
}