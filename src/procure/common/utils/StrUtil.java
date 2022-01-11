package procure.common.utils;

import javax.servlet.http.HttpSession; 

import java.io.UnsupportedEncodingException;
import java.util.Enumeration;
import java.util.Properties;
import java.util.StringTokenizer;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 *<pre>
 *
 * 파일명 : StrUtil
 * 기   능 : 문자열 관련 처리 유틸
 *</pre>
 */

public class StrUtil
{

    /** null을 체크하여 빈문자열이나 &nbsp;로 변환 */
    public static String chkNull(String str, boolean bEdit)
    {
        if (str == null)
        {
            if (bEdit) return "";
            else return "&nbsp;";
        }
        else return str;
    }

    /** null이면 주어진 res 초기값으로 변경 */
    public static String chkNull(String str, String res)
    {
    	if (str == null)
        {
            if (res!=null) return res;
            else return "";
        }
        else return str.trim();
    }
    
    /**
     * null이면 ""으로 반환
     * @param str
     * @return
     */
    public static String chkNull(String str)
    {
    	return StrUtil.chkNull(str, "");
    }
    
    
    /**세션 가지고 오는것의 널값 처리**/
    public static String getSession(HttpSession session,String sessionID){
        String getSession = "";
        if(session.getAttribute(sessionID) != null){
            getSession = session.getAttribute(sessionID).toString();
        }
        return getSession;
    }
    /**세션값 넣기**/
    public static void setSession(HttpSession session , String sessionID , String sessionValue ){
        session.setAttribute(sessionID,sessionValue);
    }


    /** 8859_1를 KSC5601로 인코딩 
     * @throws UnsupportedEncodingException */
    public static String a2k(String sStr) throws UnsupportedEncodingException
    {
        String sResult = "";

        try {
        	if(sStr != null && sStr.length() > 0)
        	{
        		sResult = new String(sStr.getBytes("8859_1"), "KSC5601");
        	}
		} catch (UnsupportedEncodingException e) {
			throw new UnsupportedEncodingException("[ERROR StrUtil.a2k()] :" + e.toString());
		}
                    
        return sResult; 
    }

    /** KSC5601를 8859_1로 인코딩 
     * @throws UnsupportedEncodingException */
    public static String k2a(String sStr) throws UnsupportedEncodingException
    {
        String sResult = "";
        
        try {
        	if(sStr != null && sStr.length() > 0)
        	{
        		sResult = new String(sStr.getBytes("KSC5601"), "8859_1");
        	}
		} catch (UnsupportedEncodingException e) {
			throw new UnsupportedEncodingException("[ERROR StrUtil.k2a()] :" + e.toString());
		}
        
        return sResult;
    }
    
    /**
     * 설정파일(conf.xml)에 정의된 charset
     * @param sStr	값
     * @return
     * @throws Exception
     */
    public static String ConfCharset(String sStr)
    {
    	String sResult = "";
    	try {
    		Properties props = System.getProperties();
    		String sCharSet	=	props.getProperty("user.language");
    		
    		if(sCharSet.equals("en"))
    		{
    			sResult	=	StrUtil.k2a(sStr);
    		}else
    		{
    			sResult	=	sStr;
    			
    		}
    	}catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR StrUtil.ConfCharset()] :" + e.toString());
		}
    	
    	return sResult;
    }

    /**
     * 설정파일(conf.xml)에 정의된 charset 반대 적용
     * @param sStr	값
     * @return
     * @throws Exception
     */
    public static String ConfCharsetRev(String sStr)
    {
    	String sResult = "";
    	try {
    		Properties props = System.getProperties();
    		String sCharSet	=	props.getProperty("user.language");
    		
    		if(sCharSet.equals("en"))
    		{
    			sResult	=	StrUtil.a2k(sStr);
    		}else
    		{
    			sResult	=	sStr;
    			
    		}
    	}catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR StrUtil.ConfCharset()] :" + e.toString());
		}
    	
    	return sResult;
    }
    
    /** 문자열에서 특정 문자열 치환 */
    public static String replace(String sSource, String sOld, String sNew)
    {
        if(sSource==null) return "";

        String sTarget = sSource;
        String sOldStr = sOld;
        String sNewStr = sNew;
        int nPos, nOffset=0;

        if (sOldStr == null || sOldStr.length() == 0)   return sTarget;
        if (sNewStr == null)    sNewStr = "";

        while ((nPos = (sTarget.substring(nOffset, sTarget.length())).indexOf(sOldStr)) > -1)
        {
            sTarget = sTarget.substring(0, nOffset + nPos) + sNewStr + sTarget.substring(nOffset + nPos + sOldStr.length(), sTarget.length());
            nOffset = nOffset + nPos + sNewStr.length();
        }

        return sTarget;
    }

    /** 문자열에서 특정 문자제거 */
    public static String remove(String str, char tok)
    {
        String sResult="";
        if (str == null) return sResult;

        for(int i = 0; i < str.length(); i++)
        {
            if(str.charAt(i) != tok) sResult = sResult + str.charAt(i);
        }
        return sResult;
    }


    /** 특정문자열 길이 맞추기 */
    public static String formatLen(String str, int nLen)
    {
        String sResult =  str;
        if (str == null || str.equals("")) return sResult;

        if (str.length() > nLen)
        {
            sResult = str.substring(0, nLen);
        }
        return sResult;
    }


    /** 홑,쌍따옴표 --> 특수문자로 변환 */
    public static String cvtQuot(String str)
    {
        String sResult="";
        if (str == null) return sResult;

        for(int i = 0; i < str.length(); i++)
        {
            if(str.charAt(i) == '\"') sResult = sResult + "&quot;" ;
            else if(str.charAt(i) == '\'') sResult = sResult + "&#39;" ;
            else sResult = sResult + str.charAt(i);
        }
        return sResult;
    }


    /** 우편번호에 XXX-XXX로 돌려준다. */
    public static String formatPost(String post)
    {
        if (post == null)
        {
            return "";
        }
        if (post.length() != 6) return post;
        return post.substring(0,3) + "-" + post.substring(3,6);
    }

    public double decimal_ctl(double value, int place, int type) {
        //place 값이 변경할 값의 자리수를 벗어날때 처리 추가해야함
        if(value == 0)
            return 0 ;
        double multi = 1 ;
        if(place < 0 ) {        //소수점 이하
            place = place+1 ;
            while (place++ < 0)
                multi *= 10.0;
        }else{                  //소수점 이상
            while (place-- > 0)
                multi /= 10.0;
        }
        switch(type) {
            case 1 :            //반올림
                return Math.round(value * multi)/ multi;    //리턴받는 쪽에서 int형으로 형변환 필요
            case 2 :                    //올림
                return Math.ceil(value * multi)/ multi;
            case 3 :                    //버림
                return Math.floor(value * multi)/ multi;
            default :                   //아무것도 아닐때
                return value ;
        }
    }


    public double dDivide(double dNum1,double dNum2){
        if (dNum1==0.0) return 0.0;
        return dNum1/dNum2;
    }


    public static String st_RPAD(String set_value,int int_length,char tmp){
        StringBuffer strTemp = new StringBuffer(set_value);
        for(int i = set_value.getBytes().length ; i < int_length;i++){
            strTemp.append(tmp);
        }

        return strTemp.toString();
    }

    public static String st_LPAD(String set_value,int int_length,char tmp){
        StringBuffer strTemp = new StringBuffer(set_value);
        for(int i = set_value.getBytes().length ; i < int_length;i++){
            strTemp.insert(0,tmp);
        }
        return strTemp.toString();
    }
    
    //콤마 넣어주기
	public static String sAddComma(String sData, boolean bEdit) 
	{		
		if (sData==null) 
		{
			if (bEdit) return "";
			else return "&nbsp;";
		}
		
		String sSumdata = "";          
		int j=0 ;
		
		if ((sData != "") && (sData.indexOf(",") < 0) && (sData.length() > 3)) 
		{
			for (int i = sData.length()-1; i >= 0 ; i-- ) 
			{
				if (sData.substring(i,i+1).equals(".") || sData.substring(i,i+1).equals("-")) 	j=-1;		
				else if (j == 3) 
				{
					sSumdata = "," + sSumdata ;
					j = 0 ;
				}
				sSumdata = sData.substring(i,i+1) + sSumdata ;
				j++ ;
			}
			return sSumdata ;
		}   
		else { return sData ; }
	}
    
	/** 사업자번호번호에 XXX-XX-XXXXX로 돌려준다. */
	public static String formatBsno(String str, boolean bEdit) 
	{    	
		if (str == null) 
		{
			if (bEdit) return "";
			else return "&nbsp;";
		}
		if (str.length() < 10) return str;
		return str.substring(0,3) + "-" + str.substring(3,5) + "-" + str.substring(5);
	}   
	
	/**
	 * 오늘 날짜 구하기
	 * @return
	 */
	public static String getToday()
	{
		return	DateUtil.getToday();
	}

	
	
	/**
	 * 오늘 날짜 구하기
	 * @return
	 */
	public static String GetStringToAsciiString(String str)
	{
		String sRet = "";

		for ( int i = 0; i < str.length(); ++i ) {
			char c = str.charAt( i );
			int j = (int) c;
			sRet += j;
		} 	

		return sRet;
	}	
	
	// 핸드폰 - 붙이기
	public static String GetFormPhone(String src, String format){
		if(src==null ) return "";
		if(src!=null && src.length() != 10) return src;
		
		String first = src.substring(0, 3);
		String temp = src.substring(3);
		int tempPo = temp.length()==8?7:6;
		String second = src.substring(3, tempPo);
		String third = src.substring(tempPo);
		return first + format + second + format + third;
	}
	
	public static String getHpForm(String sPhone){
		if(sPhone ==null) return "";
		
		int po = sPhone.indexOf("-");
		if(po > 0) return sPhone;
		
		int sPhoneLength = sPhone.length();
		
		if(sPhoneLength == 10) return sPhone.substring(0,3) + "-" + sPhone.substring(3,6) + "-" + sPhone.substring(6);
		else if(sPhoneLength == 11) return sPhone.substring(0,3) + "-" + sPhone.substring(3,7) + "-" + sPhone.substring(7);
		else if(sPhoneLength > 11) return sPhone.substring(0,3) + "-" + sPhone.substring(3,7) + "-" + sPhone.substring(7,11);
		else if(sPhoneLength > 0 && sPhoneLength <= 3) return sPhone.substring(0,3) + "-";
		else if(sPhoneLength > 3 && sPhoneLength <=6)  return sPhone.substring(0,3) + "-" + sPhone.substring(3);
		else if(sPhoneLength > 6 && sPhoneLength < 10)  return sPhone.substring(0,3) + "-" + sPhone.substring(3,6) + "-" + sPhone.substring(6);
		
		return "";
	}	

	// 전화번호(휴대폰번호포함) 분리
    public static String[] getSplitTellNo(String noStr) {
        Pattern tellPattern = Pattern.compile( "^(01\\d{1}|02|0505|0502|0506|0\\d{1,2})-?(\\d{3,4})-?(\\d{4})");
        if(noStr == null) return new String[]{ "", "", ""};
        Matcher matcher = tellPattern.matcher( noStr);
        if(matcher.matches()) {
            return new String[]{ matcher.group( 1), matcher.group( 2), matcher.group( 3)};
        } else {
            return new String[]{ "", "", ""};
        }
    }

	
	public static String getFormPhone(String src){
		return GetFormPhone(src, "-");
	}
	
	// 사업자 번호 반환0:원래번호,1:첫째, 2:둘째, 3:셋째
	public static String [] getBizNum4Arr(String sBizNum){
		String [] returnVal = new String[4];
		if(sBizNum == null || sBizNum.length() != 10){
			returnVal[0]=sBizNum;
			returnVal[1]="";
			returnVal[2]="";
			returnVal[3]="";
			
			return returnVal;
		}
		
		returnVal[0]=sBizNum;
		returnVal[1]=returnVal[0].substring(0, 3);
		returnVal[2]=returnVal[0].substring(3, 5);
		returnVal[3]=returnVal[0].substring(5); 
		
		return returnVal;
	}
	
	public static String getBizNum4Dis(String sBizNum, String mask){
		String[] biznumArr = getBizNum4Arr(sBizNum);
		
		return biznumArr[1] + mask + biznumArr[2] + mask + biznumArr[3];
	}	
	
	public static String getTaxIssueNumParent(String issueNum){
		//String sToday = StrUtil.getToday().replaceAll("-", "") + "/";
		if(issueNum == null || issueNum.length() < 18) return issueNum;
		String sPath = issueNum.substring(10,18) + "/";
		return sPath;
	}
	
	
	// 오라클 decode랑 비슷한 함수
	// 
	public static String decode(String... sDecStrs)
	{
		String retStr = "";
		String sBaseVal = "";
		
		int nLen = sDecStrs.length;
		if(nLen%2 == 0) return retStr;  // 짝수면 오류므로 그냥 공백 리턴 
		
		sBaseVal = sDecStrs[0];
		for(int i=1; i<nLen; i=i+2 )
		{
			if(sDecStrs[i].trim().equals(sBaseVal))
			{
				retStr = sDecStrs[i+1];
				break;
			}
		}
		
		return retStr;
	}

	/**
	 * 한글 원하는 byte수로 자르기
	 * @param inputStr 한글을 포함하는 문자열
	 * @param limit 자르기 원하는 bytes수
	 * @param fixStr 초과될경우 붙이는 문자열 ex)...
	 * @return 잘려진 문자열
	 */
	public static String lengthLimit(String inputStr, int limit, String fixStr) {
		if (inputStr == null)
			return "";
		if (limit <= 0)
			return inputStr;
		byte[] strbyte = null;
		strbyte = inputStr.getBytes();

		if (strbyte.length <= limit) {
			return inputStr;
		}
		char[] charArray = inputStr.toCharArray();
		int checkLimit = limit;
		for (int i = 0; i < charArray.length; i++) {
			if (charArray[i] < 256) {
				checkLimit -= 1;
			} else {
				checkLimit -= 2;
			}
			if (checkLimit <= 0) {
				break;
			}
		}
		// 대상 문자열 마지막 자리가 2바이트의 중간일 경우 제거함
		byte[] newByte = new byte[limit + checkLimit];
		for (int i = 0; i < newByte.length; i++) {
			newByte[i] = strbyte[i];
		}
		if (fixStr == null) {
			return new String(newByte);
		} else {
			return new String(newByte) + fixStr;
		}
	}	
	
	
	public static void main(String[] args){
		// System.out.println(decode("02",
		// "99","일반","01","수정","02","수정","03","수정","04","수정","05","수정"));
		// System.out.println(decode("50"
		// ,"10","작성중","20","확인요청","30","확인완료","40","반려","50","취소","60","전송성공","61","전송실패","70","수신성공","71","수신실패"));

		//String sTel = "023844535";
		//String[] tel = getSplitTellNo(sTel);
		
		//System.out.println(sTel + " == "+ tel[0] + "-" +tel[1]+ "-" +tel[2]);
		String sBidNm = "[0620] 외주 메일 testfsdafsdfadfdfafasdfasfr32542323 fdsfasfasd f34r3 fsdf asdf sd fds ";
		sBidNm = lengthLimit(sBidNm, 55, "...") + "\n-나이스다큐에서 확인";
		System.out.println("bytes : " + sBidNm);
	}

}
