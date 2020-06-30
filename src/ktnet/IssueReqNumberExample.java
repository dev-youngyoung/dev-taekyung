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
 * ���ι�ȣ ��û
 */
public class IssueReqNumberExample {

    /**
     * ���ι�ȣ ���� ��û (�ű�, �߰�)
     */
    public static void main(String args[]) throws EtsConfigurationException, ValidationException, IOException, URISyntaxException, ProtocolException, NoSuchAlgorithmException, KeyStoreException, KeyManagementException {

        Map<String, String> paramMap = new HashMap<String, String>();
        
        paramMap.put("contractNo", "20170900037-1");                //����ȣ

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getIssueReqNumber(paramMap);

        System.out.println("# resultMap : " + resultMap);
    }

}
