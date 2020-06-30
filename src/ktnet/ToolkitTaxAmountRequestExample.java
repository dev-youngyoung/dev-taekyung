package ktnet;
/*중요~~~! 4.인지 금액 조회*/
import java.io.IOException;
import java.net.URISyntaxException;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.Map;

import org.apache.http.ProtocolException;

import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.exception.ValidationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

public class ToolkitTaxAmountRequestExample {


    public static void main(String args[]) throws NoSuchAlgorithmException, IOException, KeyManagementException,
            KeyStoreException, URISyntaxException, ProtocolException, EtsConfigurationException, ValidationException {

        Map<String, String> paramMap = new HashMap<String, String>();
        paramMap.put("contractType", "030");
        paramMap.put("contractAmount", "1000000000");


        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getIssueTaxAmount(paramMap);

        System.out.println("# resultMap : " + resultMap);

    }
}
