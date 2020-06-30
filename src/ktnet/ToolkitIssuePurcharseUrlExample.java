package ktnet;
/*�߿�~~~! 1.�߱޺�ȣ ��û �� ����  �˾� ȣ��*/
import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URLEncoder;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.ProtocolException;

import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.exception.ValidationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

/**
 * �ű� �߱� �׽�Ʈ
 */
public class ToolkitIssuePurcharseUrlExample {

    /**
     * �ű� �߱޽�û��ȣ ��û
     */
    private static Map<String, String> GetNewIssueReqNo(String contractNo)
            throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        Map<String, String> paramMap = new HashMap<String, String>();
        Map<String, String> resultMap = new HashMap<String, String>();

        paramMap.put("contractNo", contractNo);            //����ȣ

        EtsHubManager etsHubManager = new EtsHubManager();
        resultMap = etsHubManager.getIssueReqNumber(paramMap);

        return resultMap;
    }


    public static void main(String args[]) throws EtsConfigurationException, IOException, ValidationException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException, URISyntaxException {

        Map<String, String> resultMap = new HashMap<String, String>();
        String szResultCode = "";
        String szResultMessage = "";

        String issueBizNo = "1148300603";
        String issueReqNo = "";
        String issueAmount = "80000";            //���ڼ������� �ݾ�
        String mobileNumber = "01012345678";    //����ó
        String email = "java@ktnet.com";        //�̸���
        String contractTitle = URLEncoder.encode("��2���� ���� ���ް��", "UTF-8");        //����
        String contractParties = URLEncoder.encode("�ѱ������������", "UTF-8");                //�����
        String contractDate = "20170914";                        //��� ü����
        String contractNo = "20170900037-1";                    //��� ��ȣ
        String contractNoSeq = "001";                            //��� ��ȣ ����
        String contractAmount = "650000000";                    //��� �ݾ�
        String contractType = "030";                            //��� Ÿ��

        // 1�ܰ�
        System.out.println("1�ܰ� �ű� �߱޽�û��ȣ ��û ����");
        resultMap = GetNewIssueReqNo(contractNo);

        szResultCode = (String) resultMap.get("resultCode");
        szResultMessage = (String) resultMap.get("resultMessage");
        System.out.println("code : " + szResultCode);
        System.out.println("message : " + szResultMessage);

        // 2�ܰ�
        if (szResultCode.equals("900")) {

            System.out.println("2�ܰ� ���ſ�û�� URL ȣ�� ����");

            String szPurchaseUrl = (String) resultMap.get("purchaseUrl");
            String szIssueDivisionCode = (String) resultMap.get("issueDivisionCode");
            issueReqNo = (String) resultMap.get("issueReqNo");

            System.out.println("# szPurchaseUrl : " + szPurchaseUrl + "?infToolMngNo=" + resultMap.get("infToolMngNo") + "&infToolBizNo=" + resultMap.get("infToolBizNo") + "&issueBizNo=" + issueBizNo + "&issueDivisionCode=" + szIssueDivisionCode + "&issueReqNo=" + issueReqNo + "&contractTitle=" + contractTitle + "&contractDate=" + contractDate + "&contractNo=" + contractNo + "&contractNoSeq=" + contractNoSeq + "&contractParties=" + contractParties + "&contractAmount=" + contractAmount + "&contractType=" + contractType + "&mobileNumber=" + mobileNumber + "&email=" + email + "&issueAmount=" + issueAmount);
            System.out.println("# szIssueDivisionCode : " + szIssueDivisionCode);
            System.out.println("# issueReqNo : " + issueReqNo);

        }

    }
}
