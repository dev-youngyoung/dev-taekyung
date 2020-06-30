package ktnet;

import java.util.HashMap;
import java.util.Map;

import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

/**
 * ���ڼ������� �߱޿�û
 */
public class ToolkitIssueExample {

    public static void main(String[] args) throws Exception {

        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put("contractNo", "20170900037-1");            //����ȣ
        
        // ��� �������� ���
        paramMap.put("contractFilePath", "data/test/contract.docx");
        // ���ڼ������� �߱� ���ڹ��� ���� ���
        paramMap.put("stampPdfPath", "data/test/issuedContract.pdf");

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.stampIssueProc(paramMap);

        System.out.println("# resultMap : " + JsonUtil.toFormatJson(resultMap));
    }
}
