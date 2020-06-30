package ktnet;

import java.util.HashMap;
import java.util.Map;

import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

/**
 * 전자수입인지 발급요청
 */
public class ToolkitIssueExample {

    public static void main(String[] args) throws Exception {

        Map<String, String> paramMap = new HashMap<String, String>();

        paramMap.put("contractNo", "20170900037-1");            //계약번호
        
        // 계약 원본파일 경로
        paramMap.put("contractFilePath", "data/test/contract.docx");
        // 전자수입인지 발급 전자문서 파일 경로
        paramMap.put("stampPdfPath", "data/test/issuedContract.pdf");

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.stampIssueProc(paramMap);

        System.out.println("# resultMap : " + JsonUtil.toFormatJson(resultMap));
    }
}
