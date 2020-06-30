package ktnet;
/*�߿�~~~! 3.PDF�� ���� ���� ���*/
import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

import java.util.HashMap;
import java.util.Map;

/**
 * ���ڼ������� ����߱�
 */
public class ToolkitIssueChangeExample {

    public static void main(String args[]) throws Exception {

        Map<String, String> paramMap = new HashMap<String, String>();
        
        // ����ȣ
        paramMap.put("contractNo", "20170900037-1");
        // �ŷ�(���)��
        paramMap.put("contractTitle", "����&�������׽�Ʈ(��ü)");
        // �ŷ�(���)ü����
        paramMap.put("contractDate", "20170913");

        // �ŷ�(���) Ÿ��
        paramMap.put("contractType", "030");
        // �ŷ�(���)�ݾ�
        paramMap.put("contractAmount", "650000000");
        // ��� �������� ���
        paramMap.put("contractFilePath", "D:/nicedata/nicedocu/file/supplier/contract/20150100001/0000/00000000000/00000000000_0_0.pdf");
        // ���ڼ������� �߱� ���ڹ��� ���� ���
        paramMap.put("stampPdfPath", "D:/nicedata/nicedocu/file/supplier/contract/20150100001/0000/00000000000/00000000000_0_0_stamp.pdf");

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.stampIssueChange(paramMap);

        System.out.println("# resultMap : " + JsonUtil.toFormatJson(resultMap));
    }

}
