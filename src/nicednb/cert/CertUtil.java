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
		String[] han1 = new String[]{"","��","��","��","��","��","��","ĥ","��","��"}; 
		String[] han2 = new String[]{"","��","��","��","��","��","��","��","��","��"}; 
		String[] han3 = new String[]{"","��","��","õ"}; 
		String result="", hangul = num, pm = ""; 
		String[] str = new String[50];
		String str2 = ""; 
		String[] strTmp = new String[50]; 

		if(Long.parseLong(num)== 0) return "��"; //�Էµ� ���ڰ� 0�� ��� ó�� 
		if(hangul.substring(0,1) == "-"){ //���� ó�� 
			pm = "���̳ʽ� "; 
			hangul = hangul.substring(1, hangul.length()); 
		} 
		if(hangul.length() > han2.length*4) return "too much number"; //������ �Ѵ� ���� ó�� �ڸ��� �迭 han2�� �ڸ��� ������ �߰��ϸ� ������ �þ. 

		for(i=hangul.length(); i > 0; i=i-4){ 
			int startIdx = i-4 >= 0 ? i-4 : 0;
			str[j] = hangul.substring(startIdx,i); //4�ڸ��� ���´�. 
			for(k=str[j].length();k>0;k--){ 
				strTmp[k] = Long.parseLong((str[j].substring(k-1,k))) > 0 ? str[j].substring(k-1,k) : "0"; 
				strTmp[k] = han1[Integer.parseInt(strTmp[k])]; 
				if( !"".equals(strTmp[k])) strTmp[k] += han3[str[j].length()-k]; 
				str2 = strTmp[k] + str2; 
			} 
			str[j] = str2; 
			//if(str[j]) result = str[j]+han2[j]+result; 
			//4�ڸ����� ��ĭ�� ����� �����ִ� �κ�. �켱�� �ּ�ó�� 
			//result = (str[j])? " "+str[j]+han2[j]+result : " " + result; 
			result = str[j] != null ? " "+str[j]+han2[j]+result : " " + result; 

			j++;
			str2 = ""; 
		} 
		
		System.out.println("resut:"+result);

		return pm + result; //��ȣ + ���ڰ� 
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
	 * request parameter�� HashMap���� ��ȯ (key, value)
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
	 * request�κ��� SQLJob�� �Ķ���� ����
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
	 * double ���� String���� ��ȯ (�Ҽ������ϰ� 0�ϰ�� 0 ������ ���� ��ȯ)
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
	 * �ڵ带 ��ȸ�Ͽ� option�� generate�Ѵ�.
	 * @param code
	 * @return
	 */
	public static String generateCodeOptionHtml(String code){
		return generateCodeOptionHtml(code, COMBO_CODE, true);
	}
	
	/**
	 * �ڵ带 ��ȸ�Ͽ� option�� generate�Ѵ�.
	 * @param code
	 * @param orderColumn COMBO_CODE (code), COMBO_NAME (cname) �ڵ� ���� �̸��� ���� ���� ���� 
	 * @return
	 */
	public static String generateCodeOptionHtml(String code, int orderColumn){
		return generateCodeOptionHtml(code, orderColumn, false);
	}
	
	/**
	 * �ڵ带 ��ȸ�Ͽ� option�� generate�Ѵ�.
	 * @param code
	 * @param useOnly ��뿩�ΰ� Y�� �͸� �� ������ ���� (default: true, false�̸� ��뿩�ΰ� 'N'�� �͵� ��ȸ��)
	 * @return
	 */
	public static String generateCodeOptionHtml(String code, boolean useOnly){
		return generateCodeOptionHtml(code, COMBO_CODE, useOnly);
	}
	
	/**
	 * �ڵ带 ��ȸ�Ͽ� option�� generate�Ѵ�.
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
	 * code ��ȸ
	 * @param code
	 * @param orderColumn
	 * @param useOnly
	 * @return
	 */
	public static ResultSetValue getCode(String code, int orderColumn, boolean useOnly) {

		SQLJob sqlj = null;
		ResultSetValue rsv = null;
		try {
			sqlj = new SQLJob("_common.xml", true);	// query ������ DB ������ ������
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
