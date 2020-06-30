package nicednb.cert;

import java.text.NumberFormat;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;

import procure.common.value.DataSetValue;
import procure.common.value.ResultSetValue;
import procure.common.value.SQLJob;

public class CertUtil {
	
	
	public static final int COMBO_CODE = 10;
	public static final int COMBO_NAME = 20;
	
	public static void main(String[] args){
		System.out.println(CertUtil.numToKoreanAmt("99999990000"));
	}
	
	public static String numToKoreanAmt(String num){
		
		int i, j=0, k=0; 
		String[] han1 = new String[]{"","일","이","삼","사","오","육","칠","팔","구"}; 
		String[] han2 = new String[]{"","만","억","조","경","해","시","양","구","간"}; 
		String[] han3 = new String[]{"","십","백","천"}; 
		String result="", hangul = num, pm = ""; 
		String[] str = new String[50];
		String str2 = ""; 
		String[] strTmp = new String[50]; 

		if(Long.parseLong(num)== 0) return "영"; //입력된 숫자가 0일 경우 처리 
		if(hangul.substring(0,1) == "-"){ //음수 처리 
			pm = "마이너스 "; 
			hangul = hangul.substring(1, hangul.length()); 
		} 
		if(hangul.length() > han2.length*4) return "too much number"; //범위를 넘는 숫자 처리 자리수 배열 han2에 자리수 단위만 추가하면 범위가 늘어남. 

		for(i=hangul.length(); i > 0; i=i-4){ 
			int startIdx = i-4 >= 0 ? i-4 : 0;
			str[j] = hangul.substring(startIdx,i); //4자리씩 끊는다. 
			for(k=str[j].length();k>0;k--){ 
				strTmp[k] = Long.parseLong((str[j].substring(k-1,k))) > 0 ? str[j].substring(k-1,k) : "0"; 
				strTmp[k] = han1[Integer.parseInt(strTmp[k])]; 
				if( !"".equals(strTmp[k])) strTmp[k] += han3[str[j].length()-k]; 
				str2 = strTmp[k] + str2; 
			} 
			str[j] = str2; 
			//if(str[j]) result = str[j]+han2[j]+result; 
			//4자리마다 한칸씩 띄워서 보여주는 부분. 우선은 주석처리 
			//result = (str[j])? " "+str[j]+han2[j]+result : " " + result; 
			result = str[j] != null ? " "+str[j]+han2[j]+result : " " + result; 

			j++;
			str2 = ""; 
		} 
		
		System.out.println("resut:"+result);

		return pm + result; //부호 + 숫자값 
	}

	
	public static void printRequestParams(HttpServletRequest request){
		Enumeration<String> e = request.getParameterNames();
		
		String key = null;
		while(e.hasMoreElements()){
			key = e.nextElement();
			System.out.println("["+key+"]=["+request.getParameter(key)+"]");
		}
	}
	
	/**
	 * request parameter를 HashMap으로 변환 (key, value)
	 * @param request
	 * @return
	 */
	public static HashMap getParameterMap(HttpServletRequest request){
		
		HashMap hm = new HashMap();
		
		Enumeration<String> e = request.getParameterNames();
		
		String key = null;
		while(e.hasMoreElements()){
			key = e.nextElement();
			hm.put(key, request.getParameter(key));
		}
		
		return hm;
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
			
			System.out.println(key + " -> " + request.getParameter(key));
			
			if(tmpMap.containsKey(key)){
				sqlJob.setParam(key, request.getParameter(key).replaceAll("[^0-9]", ""));
				
			}else{
				sqlJob.setParam(key, request.getParameter(key));
			}
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
	
	public static int random(int min, int max){
		int result;
		
		Random rd = new Random();
		result = rd.nextInt(max);
		if(result < min) result = min + result;
		
		return result;
	}
	
	public static long randomLong(){
		long result;
		
		Random rd = new Random();
		result = rd.nextLong();
		
		return result;
	}
	
	/**
	 * double 형을 String으로 변환 (소수점이하가 0일경우 0 제거한 값만 반환)
	 * @param value
	 * @return
	 */
	public static String doubleToString(double value, boolean useDot){
		String str = Double.toString(value);
		int dotPos = str.indexOf(".");
		
		if(useDot == false){
			return str.substring(0, dotPos);
		}else{
			
			if( Integer.parseInt(str.substring(dotPos+1)) > 0){
				return str;
			}else{
				return str.substring(0, dotPos);
			}
		}
	}

	private static NumberFormat nf = NumberFormat.getNumberInstance();
	public static String convertToKorCurrency(double amt){
	    return nf.format(amt);
	}
	
	/**
	 * 코드를 조회하여 option을 generate한다.
	 * @param code
	 * @return
	 */
	public static String generateCodeOptionHtml(String code){
		return generateCodeOptionHtml(code, COMBO_CODE, true);
	}
	
	/**
	 * 코드를 조회하여 option을 generate한다.
	 * @param code
	 * @param orderColumn COMBO_CODE (code), COMBO_NAME (cname) 코드 값과 이름의 정렬 조건 지정 
	 * @return
	 */
	public static String generateCodeOptionHtml(String code, int orderColumn){
		return generateCodeOptionHtml(code, orderColumn, false);
	}
	
	/**
	 * 코드를 조회하여 option을 generate한다.
	 * @param code
	 * @param useOnly 사용여부가 Y인 것만 할 것인지 여부 (default: true, false이면 사용여부가 'N'인 것도 조회함)
	 * @return
	 */
	public static String generateCodeOptionHtml(String code, boolean useOnly){
		return generateCodeOptionHtml(code, COMBO_CODE, useOnly);
	}
	
	/**
	 * 코드를 조회하여 option을 generate한다.
	 * @param code
	 * @param useOnly
	 * @param orderColumn
	 * @return
	 */
	public static String generateCodeOptionHtml(String code, int orderColumn, boolean useOnly){
		StringBuffer sb = new StringBuffer();
		
		try{
			ResultSetValue rsv = getCode(code, orderColumn, useOnly);
			
			if(rsv != null){
				while(rsv.next()){
					sb.append("<option value='");
					sb.append(rsv.getString("code"));
					sb.append("'>");
					sb.append(rsv.getString("cname"));
					sb.append("</option>");
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		return sb.toString();
	}
	
	public static ResultSetValue getCode(String code){
		return getCode(code, COMBO_CODE, true);
	}
	public static ResultSetValue getCode(String code, int orderColumn){
		return getCode(code, orderColumn, false);
	}
	
	public static ResultSetValue getCode(String code, boolean useOnly){
		return getCode(code, COMBO_CODE, useOnly);
	}
	
	/**
	 * code 조회
	 * @param code
	 * @param orderColumn
	 * @param useOnly
	 * @return
	 */
	public static ResultSetValue getCode(String code, int orderColumn, boolean useOnly) {

		SQLJob sqlj = null;
		ResultSetValue rsv = null;
		try {
			sqlj = new SQLJob("_common.xml", true);	// query 실행후 DB 접속을 유지함
			sqlj.setParam("CCODE", code);
			
			if(orderColumn == COMBO_CODE){
				if(useOnly){
					rsv = sqlj.getRows("common_code_11");
				}else{
					rsv = sqlj.getRows("common_code_12");
				}
			}else{
				if(useOnly){
					rsv = sqlj.getRows("common_code_21");
				}else{
					rsv = sqlj.getRows("common_code_22");
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			if(sqlj != null){
				try { sqlj.close();} catch (Exception e) {}
			}
		}
		return rsv;
	}

	public static DataSetValue getPersonInfo(String userId) {

		SQLJob sqlj = null;
		DataSetValue dsv = null;
		try {
			sqlj = new SQLJob("_common.xml");
			sqlj.setParam("USERID", userId);
			dsv = sqlj.getOneRow("person_info");
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return dsv;
	}
}
