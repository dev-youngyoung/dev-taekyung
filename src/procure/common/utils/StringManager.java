package procure.common.utils;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

/**
 * 
 *
 * @author  <A Href="mailto:imkms77@empal.com">김민석</A>
 * @version 1.0
 * @since       1.0
 * 
 * History<br>
 * 1.0  2005.05.19      김민석          initial version
 */
public final class StringManager {
 
    /*
     * Constructor
     */ 
    private StringManager(){
        
    }
    
    /**
     * Null인 경우 "" 처리 메소드
     * 
     * @param   java.lang.String
     * @return  fixed string
     * @since   1.0
     */
    public static String fixNull (String str) {
        String value = null ;
        if ( str == null ){ 
            value = "" ;
        }else{
            value = str ;
        }
        return value ;
    }
    
    

    /**
     * Null인 경우 "" 처리 메소드
     * 
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String fixNull(Object obj) {
        String value = "" ;
        
        if(obj != null)
        {
        	if(obj != null && obj.getClass().getName().equals("String"))
        	{
        		value	=	(String)obj;;
        	}else
        	{
        		value	=	obj.toString();
        	}
        }
        return value;
    }
    
    /**
     * Null인 경우 "0" 처리 메소드
     * 
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String fixZero(String str) {
        String value = null ;
        if ( str == null ){ 
            value = "0" ;
        }else{
            value = str.trim() ;
            if (value.equals("")) value = "0" ;
        }
        return value ;
        
    }
    
    
    /**
     * Null인 경우 "0" 처리 메소드
     * 
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String fixZero(Object obj) {
        String value = null ;
        
        if (obj == null) return "0" ;
        
        if (obj.getClass().getName().equals("String")) {
            value = ((String)obj).trim() ;
            if (value.equals("")) value = "0" ;
        } else {
            value = (obj.toString()).trim() ;
            if (value.equals("")) value = "0" ;
        }
        return value ;
    }
    

    
    /**
     * 소수점 이하 처리 메소드
     * double -> int 형의 String 으로 반환 (반올림)
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String doubleToIntString(double dVal) {
        DecimalFormat df = new DecimalFormat("###################0") ;
        String sNum = "" ;
        sNum = df.format(dVal) ;
        return sNum ;
    }
    
    
    
    /**
     * 소수점 이하 처리 메소드
     * double -> 소숫점 이하를 int만큼 처리하여 double 형으로 반환 (반올림)
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static double doubleFormat(double dVal, int iCnt) {
        String sFormat  = "##############0." ;
        for(int i=0 ; i < iCnt ; i++) {
            sFormat += "#" ;
        }
        
        DecimalFormat df = new DecimalFormat(sFormat) ;
        String sNum = "" ;
        sNum = df.format(dVal) ;
        return new Double(sNum).doubleValue() ;
    }
    
    
    
    /**
     * 소수점 이하 처리 메소드
     * double -> 소숫점 이하를 Format 처리하여 double 형으로 반환 (반올림)
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static double doubleFormat(double dVal, String sFormat) {
        DecimalFormat df = new DecimalFormat(sFormat) ;
        String sNum = "" ;
        sNum = df.format(dVal) ;
        return new Double(sNum).doubleValue() ;
    }
    
    
    /**
     * 소수점 이하 처리 메소드
     * double -> 소숫점 이하를 int만큼 처리하여 String 형으로 반환 (반올림)
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String doubleToFormatString(double dVal, int iCnt) {
        String sFormat  = "##############0." ;
        for(int i=0 ; i < iCnt ; i++) {
            sFormat += "#" ;
        }
        
        DecimalFormat df = new DecimalFormat(sFormat) ;
        String sNum = "" ;
        sNum = df.format(dVal) ;
        return sNum ;
    }
    
    
    
    /**
     * 소수점 이하 처리 메소드
     * double -> 소숫점 이하를 Format 처리하여 String 형으로 반환 (반올림)
     * @param   java.lang.Object
     * @return  fixed string
     * @since   1.0
     */
    public static String doubleToFormatString(double dVal, String sFormat) {
        DecimalFormat df = new DecimalFormat(sFormat) ;
        String sNum = "" ;
        sNum = df.format(dVal) ;
        return sNum ;
    }
    
    /**
     * 숫자(String Type) "," 찍어서 리턴
     * @param sVal
     * @return
     */
    public static String toComma(String sVal) {
    	String sNum = "";
    	try
    	{
    		if(sVal.length() < 1)
    		{
    			sVal	=	"0";
    		}
    		
    		sVal = sVal.replaceAll(",", "");
    		
    		DecimalFormat df = new DecimalFormat() ;
    		sNum = df.format(Double.parseDouble(sVal));
    	}catch(IllegalArgumentException e)
    	{
			throw new IllegalArgumentException("[ERROR StringManager.toComma()] :" + e.toString());
    	}
    	return sNum ;
    }
    
    /**
     * 숫자(double dVal) "," 찍어서 리턴
     * @param iVal
     * @return
     */
    public static String toComma(double dVal) {
        DecimalFormat df = new DecimalFormat() ;
        String sNum = "" ;
        sNum = df.format(dVal);
        return sNum ;
    }

    /**
      * @param java.lang.String
      * @return fixed string
      * @since 1.0
      */
     public static String getErrorMsg(String errormsg)
     {
      
      String message = "";

      if(errormsg.indexOf("ORA-00000") > 0)
      {
       message = "해당자료가 없습니다.";
      }else if(errormsg.indexOf("ORA-00001") > 0)
      {
       message = "자료등록이 중복되었습니다.";
      }else if(errormsg.indexOf("ORA-00150") > 0)
      {
       message = "자료등록이 중복되었습니다.";
      }else if(errormsg.indexOf("ORA-01400") > 0)
      {
       message = "테이블의 NOT NULL컬럼에 NULL값이 입력되었습니다.";
      }else if(errormsg.indexOf("ORA-01401") > 0)
      {
       message = "테이블의 컬럼크기보다 큰 데이터가 입력되었습니다.";
      }else if(errormsg.indexOf("ORA-02292") > 0)
      {
       message = "관련된 자료가 있어 삭제할 수 없습니다.";
      }else if(errormsg.indexOf("ORA-00904") > 0)
      {
       message = "테이블 또는 컬럼명이 존재하지 않습니다.";
      }else{
       message = errormsg;
      }
      return message;
     }
     
    /**
    * 한글 처리 메소드
    * @param    java.lang.String
    * @return   fixed string
     * @throws UnsupportedEncodingException 
    * @since    1.0
    */
    public static String strEncoding(String str, String encFr, String encTo) throws UnsupportedEncodingException 
    {
    	String sRtnVal	=	"";
        
        	try {
        		if(str!=null && str.length() > 0)
                {
				sRtnVal	=	new String(str.getBytes(encFr), encTo);
                }
			} catch (UnsupportedEncodingException e) {
				throw new UnsupportedEncodingException("[ERROR StringManager.strEncoding()] :" + e.toString());
			}
        return sRtnVal;
        
    }
	/**
	 * 값이 null 일 경우 대신 문자를 대처해서 보냄
	 * @param sVal	값
	 * @param sInstead	대신할 값  
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	public static String checkString(String	sVal, String sInstead) throws UnsupportedEncodingException  
	{
		String	sRtn	=	"";	//리턴값
		try {
			if(sVal != null && sVal.length() > 0) 
			{
				sRtn	=	new	String(StringManager.strEncoding(sVal, "8859_1", "KSC5601"));
			}
		} catch (UnsupportedEncodingException e) {
			throw new UnsupportedEncodingException("[ERROR StringManager.strEncoding()] :" + e.toString());
		}
		
		return	sRtn;
	}    
}
