package ktnet;
/*중요~~~! 1.발급변호 요청 및 결제  팝업 호출*/
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
 * 신규 발급 테스트
 */
public class ToolkitIssuePurcharseUrlExample {

    /**
     * 신규 발급신청번호 요청
     */
    private static Map<String, String> GetNewIssueReqNo(String contractNo)
            throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {
        Map<String, String> paramMap = new HashMap<String, String>();
        Map<String, String> resultMap = new HashMap<String, String>();

        paramMap.put("contractNo", contractNo);            //계약번호

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
        String issueAmount = "80000";            //전자수입인지 금액
        String mobileNumber = "01012345678";    //연락처
        String email = "java@ktnet.com";        //이메일
        String contractTitle = URLEncoder.encode("제2공구 현장 도급계약", "UTF-8");        //계약명
        String contractParties = URLEncoder.encode("한국무역정보통신", "UTF-8");                //기업명
        String contractDate = "20170914";                        //계약 체결일
        String contractNo = "20170900037-1";                    //계약 번호
        String contractNoSeq = "001";                            //계약 번호 차수
        String contractAmount = "650000000";                    //계약 금액
        String contractType = "030";                            //계약 타입

        // 1단계
        System.out.println("1단계 신규 발급신청번호 요청 진행");
        resultMap = GetNewIssueReqNo(contractNo);

        szResultCode = (String) resultMap.get("resultCode");
        szResultMessage = (String) resultMap.get("resultMessage");
        System.out.println("code : " + szResultCode);
        System.out.println("message : " + szResultMessage);

        // 2단계
        if (szResultCode.equals("900")) {

            System.out.println("2단계 구매요청서 URL 호출 진행");

            String szPurchaseUrl = (String) resultMap.get("purchaseUrl");
            String szIssueDivisionCode = (String) resultMap.get("issueDivisionCode");
            issueReqNo = (String) resultMap.get("issueReqNo");

            System.out.println("# szPurchaseUrl : " + szPurchaseUrl + "?infToolMngNo=" + resultMap.get("infToolMngNo") + "&infToolBizNo=" + resultMap.get("infToolBizNo") + "&issueBizNo=" + issueBizNo + "&issueDivisionCode=" + szIssueDivisionCode + "&issueReqNo=" + issueReqNo + "&contractTitle=" + contractTitle + "&contractDate=" + contractDate + "&contractNo=" + contractNo + "&contractNoSeq=" + contractNoSeq + "&contractParties=" + contractParties + "&contractAmount=" + contractAmount + "&contractType=" + contractType + "&mobileNumber=" + mobileNumber + "&email=" + email + "&issueAmount=" + issueAmount);
            System.out.println("# szIssueDivisionCode : " + szIssueDivisionCode);
            System.out.println("# issueReqNo : " + issueReqNo);

        }

    }
}
