package ktnet;

import com.ktnet.ets.hub.exception.EtsConfigurationException;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

import java.io.IOException;
import java.util.Map;

/**
 * 연계서비스 환경설정파일 Read
 */
public class EtsHubConfigExample {

    public static void main(String args[]) throws IOException, EtsConfigurationException {

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.getEtsHubConfig();

        System.out.println("# resultMap : " + resultMap);
    }
}
