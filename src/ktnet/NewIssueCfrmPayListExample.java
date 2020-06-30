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
 * ���� ���� Ȯ�� ��ȸ(������ �°� �������� ������ �ݾ׵� ����)
 */
public class NewIssueCfrmPayListExample {

    public static void main(String args[]) throws URISyntaxException, NoSuchAlgorithmException, IOException,
            ValidationException, KeyStoreException, KeyManagementException, ProtocolException, EtsConfigurationException {
			
				Map<String, String> paramMap = new HashMap<String, String>();
				String sContractNoSeq = "0";      //����ȣ����
				
		        paramMap.put("contractNo", "435200000004");        //����ȣ
				
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
				taxParamMap.put("contractType", "030");                       //�ŷ�(���)�����ڵ� - ���������ڵ�
		        taxParamMap.put("contractAmount", "11000000");    //���ݾ�
		
		        Map<String, String> taxResultMap = etsHubManager.getIssueTaxAmount(taxParamMap); //������ �ݾ� ���ϱ�
		        String taxAmount = (String)  taxResultMap.get("taxAmount") ;  //���ݾ׿� ���� ������ �ݾ�
		        
		        
				//������ŭ ���γ��� ��ȸ�Ͽ� �ջ��ϱ� 
		        for(int j = 1; j <= iContractNoSeq; j++)
		        {
		        	
		        	//�ڸ����� ��ü �ý��ۿ� ���缭 ���� �ڵ� ���� ����(3�ڸ� ����)
		        	/*if(sContractNoSeq.length() != 3)// seq is length = 3
					{
		        		tempContractNoSeq = "0" + j;
		        		
			        	if(sContractNoSeq.length() != 3)// seq is length = 3
						{
			        		tempContractNoSeq = "0" + tempContractNoSeq;
			        		
						}
					}*/
		        	
		        	//�ڸ����� ��ü �ý��ۿ� ���缭 ���� �ڵ� ���� ����(2�ڸ� ����)
//		        	if(sContractNoSeq.length() != 2)// seq is length = 2
//					{
//		        		tempContractNoSeq = "0" + j;
//		        		
//					}
		        	
		        	
//			        Logger.info("################################### [ sContractNoSeq ] " + tempContractNoSeq);
			        paramMap.put("contractNoSeq", tempContractNoSeq);         
			        Map<String, String> resultMap = etsHubManager.getIssueCfrmPayList(paramMap); //���γ��� ��ȸ�ϱ�
	
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
		        
		        //�ϳ����ο� ���� ��ü �ý��ۿ� �°� ���μ����� �����Ѵ�.
		        if(Integer.parseInt(taxAmount) <= sum)  //�������� �ϳ��߰ų� �ʰ� ������ ���
		        {
		        	System.out.println("������ �ϳ��Ǿ����ϴ� �߱��� �����ϼ���");
		        }else {
		        	System.out.println("������ �ϳ����� �ʾҽ��ϴ�. ���ſ�û���� �߰� ���� ���ּ���.");
		        }
		        
    }

}
