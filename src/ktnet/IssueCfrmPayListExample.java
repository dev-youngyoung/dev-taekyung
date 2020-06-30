package ktnet;
/*�߿�~~~! 2.���� ���� Ȯ��*/
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
 * ���� ���� Ȯ�� ��ȸ
 */
public class IssueCfrmPayListExample {

    public static void main(String args[]) throws URISyntaxException, NoSuchAlgorithmException, IOException,
            ValidationException, KeyStoreException, KeyManagementException, ProtocolException, EtsConfigurationException {

        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put("contractNo", "435200000004");                        //����ȣ
        paramMap.put("contractNoSeq", "0");                                //����ȣ����

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getIssueCfrmPayList(paramMap);

        System.out.println("# resultMap : " + resultMap);
        
        ArrayList resultList = JsonUtil.toObject(resultMap.get("resultList"), ArrayList.class);
        
        System.out.println("# size : " + resultList.size());
        
        for(int i = 0 ; i < resultList.size() ; i++){
            Map map = (Map)resultList.get(i);
            
            System.out.println("# [ " +i+ " ] " + map);
        }
    }

}
