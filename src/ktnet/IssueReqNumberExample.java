package ktnet;

import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.exception.ValidationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;
import org.apache.http.ProtocolException;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

/**
 * 납부번호 요청
 */
public class IssueReqNumberExample {

    /**
     * 납부번호 통합 요청 (신규, 추가)
     */
    public static void main(String args[]) throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {

        Map<String, String> paramMap = new HashMap<String, String>();
        
        paramMap.put("contractNo", "20170900037-1");                //계약번호

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getIssueReqNumber(paramMap);

        System.out.println("# resultMap : " + resultMap);
    }

}
