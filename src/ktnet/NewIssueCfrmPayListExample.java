package ktnet;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.ProtocolException;

import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.exception.ValidationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

/**
 * 결제 납부 확인 조회(차수에 맞게 가져오고 인지세 금액도 구함)
 */
public class NewIssueCfrmPayListExample {

    public static void main(String args[]) throws URISyntaxException, NoSuchAlgorithmException, IOException,
            ValidationException, KeyStoreException, KeyManagementException, ProtocolException, EtsConfigurationException {
			
				Map<String, String> paramMap = new HashMap<String, String>();
				String sContractNoSeq = "0";      //계약번호차수
				
		        paramMap.put("contractNo", "435200000004");        //계약번호
				
				/*if(sContractNoSeq != null || sContractNoSeq.isEmpty())
				{
					if("0".equals(sContractNoSeq.substring(0, 1))) {
						sContractNoSeq = sContractNoSeq.substring(1, sContractNoSeq.length());
						
						if("0".equals(sContractNoSeq.substring(0, 1))) {
							sContractNoSeq = sContractNoSeq.substring(1, sContractNoSeq.length());
						}
					}
				}*/
		        		
				int iContractNoSeq = Integer.parseInt(sContractNoSeq);		
		        int sum = 0;
		        int listNum = 0;
		        
		        String tempContractNoSeq = "";

		        EtsHubManager etsHubManager = new EtsHubManager();
		        
				Map<String, String> taxParamMap = new HashMap<String, String>();
				taxParamMap.put("contractType", "030");                       //거래(계약)종류코드 - 과세종류코드
		        taxParamMap.put("contractAmount", "11000000");    //계약금액
		
		        Map<String, String> taxResultMap = etsHubManager.getIssueTaxAmount(taxParamMap); //인지세 금액 구하기
		        String taxAmount = (String)  taxResultMap.get("taxAmount") ;  //계약금액에 따른 인지세 금액
		        
		        
				//차수만큼 납부내역 조회하여 합산하기 
		        for(int j = 1; j <= iContractNoSeq; j++)
		        {
		        	
		        	//자릿수는 자체 시스템에 맞춰서 별도 코딩 수정 요함(3자리 기준)
		        	/*if(sContractNoSeq.length() != 3)// seq is length = 3
					{
		        		tempContractNoSeq = "0" + j;
		        		
			        	if(sContractNoSeq.length() != 3)// seq is length = 3
						{
			        		tempContractNoSeq = "0" + tempContractNoSeq;
			        		
						}
					}*/
		        	
		        	//자릿수는 자체 시스템에 맞춰서 별도 코딩 수정 요함(2자리 기준)
//		        	if(sContractNoSeq.length() != 2)// seq is length = 2
//					{
//		        		tempContractNoSeq = "0" + j;
//		        		
//					}
		        	
		        	
//			        Logger.info("################################### [ sContractNoSeq ] " + tempContractNoSeq);
			        paramMap.put("contractNoSeq", tempContractNoSeq);         
			        Map<String, String> resultMap = etsHubManager.getIssueCfrmPayList(paramMap); //납부내역 조회하기
	
	//		        Logger.info("# resultMap : " + resultMap);
			        ArrayList resultList = JsonUtil.toObject(resultMap.get("resultList"), ArrayList.class);
	//		        Logger.info("# size : " + resultList.size());
			        

			        
			        for(int i = 0 ; i < resultList.size() ; i++){
			        	
			            Map map = (Map)resultList.get(i);
			            sum = sum + Integer.parseInt((String) map.get("paymentAmount"));
			            
			            System.out.println("PAYMENT_DIVISION_NAME"+listNum + " : " + (String) map.get("paymentDivisionName") );
			            System.out.println("PAYMENT_DTTM"+listNum + " : " + (String) map.get("paymentDttm") );
			            System.out.println("PAYMENT_AMOUNT"+listNum + " : " + (String) map.get("paymentAmount") );
			            System.out.println("ISSUE_REQ_NO"+listNum + " : " + (String) map.get("issueReqNo") );
			            System.out.println("PAYMENT_ORGAN_NAME"+listNum + " : " + (String) map.get("paymentOrganName") );
			            System.out.println("UNIQUE_ID"+listNum + " : " + (String) map.get("uniqueId") );

			            System.out.println("# [ " +listNum+ " ] " + map);
			            listNum++;
			        }
		        }
		        System.out.println("PAYMENT_LIST_CNT" + " : " + Integer.toString(listNum) );
		        System.out.println("AMOUNT_SUM" + " : " + Integer.toString(sum) );
		        System.out.println("TAX_AMOUNT" + " : " + taxAmount );
		        
		        //완납여부에 따라 자체 시스템에 맞게 프로세스를 수행한다.
		        if(Integer.parseInt(taxAmount) <= sum)  //인지세를 완납했거나 초과 구매한 경우
		        {
		        	System.out.println("결제가 완납되었습니다 발급을 진행하세요");
		        }else {
		        	System.out.println("결제가 완납되지 않았습니다. 구매요청서로 추가 결제 해주세요.");
		        }
		        
    }

}
