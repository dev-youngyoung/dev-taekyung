package ktnet;
/*중요~~~! 3.PDF에 구매 직인 찍기*/
import com.ktnet.ets.hub.common.util.JsonUtil;
import com.ktnet.ets.hub.inf.manager.EtsHubManager;

import java.util.HashMap;
import java.util.Map;

/**
 * 전자수입인지 변경발급
 */
public class ToolkitIssueChangeExample {

    public static void main(String args[]) throws Exception {

        Map<String, String> paramMap = new HashMap<String, String>();
        
        // 계약번호
        paramMap.put("contractNo", "20170900037-1");
        // 거래(계약)명
        paramMap.put("contractTitle", "공사&인지세테스트(자체)");
        // 거래(계약)체결일
        paramMap.put("contractDate", "20170913");

        // 거래(계약) 타입
        paramMap.put("contractType", "030");
        // 거래(계약)금액
        paramMap.put("contractAmount", "650000000");
        // 계약 원본파일 경로
        paramMap.put("contractFilePath", "D:/nicedata/nicedocu/file/supplier/contract/20150100001/0000/00000000000/00000000000_0_0.pdf");
        // 전자수입인지 발급 전자문서 파일 경로
        paramMap.put("stampPdfPath", "D:/nicedata/nicedocu/file/supplier/contract/20150100001/0000/00000000000/00000000000_0_0_stamp.pdf");

        EtsHubManager etsHubManager = new EtsHubManager();
        Map<String, String> resultMap = etsHubManager.stampIssueChange(paramMap);

        System.out.println("# resultMap : " + JsonUtil.toFormatJson(resultMap));
    }

}
