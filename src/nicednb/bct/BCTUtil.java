package nicednb.bct;

import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import nicednb.cert.CertUtil;
import procure.common.value.SQLJob;

public class BCTUtil {


	
	public static void printRequestParams(HttpServletRequest request){
		Enumeration<String> e = request.getParameterNames();
		
		String key = null;
		while(e.hasMoreElements()){
			key = e.nextElement();
			System.out.println("["+key+"]=["+request.getParameter(key)+"]");
		}
	}
	
	/**
	 * request로부터 SQLJob에 파라미터 셋팅
	 * @param request
	 * @param sqlJob
	 * @return
	 */
	public static SQLJob setParameters(HttpServletRequest request, SQLJob sqlJob, String[] numberCols){
		
		Map paramMap = CertUtil.getParameterMap(request);
		
		Map tmpMap = new HashMap();
		
		if(numberCols == null) numberCols = new String[0];
		
		for(int i=0;i<numberCols.length;i++){
			tmpMap.put(numberCols[i], "");
		}

		java.util.Iterator it = paramMap.keySet().iterator();
		String key = null;
		while(it.hasNext()){
			key = String.valueOf(it.next());
			
			if(tmpMap.containsKey(key)){
				sqlJob.setParam(key, request.getParameter(key).replaceAll("[^0-9]", ""));
			}else{
				sqlJob.setParam(key, request.getParameter(key));
			}
			System.out.println(key+"=["+request.getParameter(key)+"]");
		}
		
		return sqlJob;
	}
	
	public static SQLJob setParameters(HttpServletRequest request, SQLJob sqlJob){
		return setParameters(request, sqlJob, null);
	}
	
	/**
	 * left padding
	 * @param str
	 * @param len
	 * @param paddingStr
	 * @return
	 */
	public static String lpad(String str, int len, String paddingStr){
		if(str != null){
			if(str.length() > len) return str;
			
			while(str.length() <= len){
				str = paddingStr + str;
			}
		}
		
		return str;
	}
}
