package procure.common.utils;

import java.io.UnsupportedEncodingException;
import java.text.DecimalFormat;

/**
 * 
 *
 * @author  <A Href="mailto:imkms77@empal.com">��μ�</A>
 * @version 1.0
 * @since       1.0
 * 
 * History<br>
 * 1.0  2005.05.19      ��μ�          initial version
 */
public final class StringManager {
 
    /*
     * Constructor
     */ 
    private StringManager(){
        
    }
    
    /**
     * Null�� ��� "" ó�� �޼ҵ�
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
     * Null�� ��� "" ó�� �޼ҵ�
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
     * Null�� ��� "0" ó�� �޼ҵ�
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
     * Null�� ��� "0" ó�� �޼ҵ�
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
     * �Ҽ��� ���� ó�� �޼ҵ�
     * double -> int ���� String ���� ��ȯ (�ݿø�)
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
     * �Ҽ��� ���� ó�� �޼ҵ�
     * double -> �Ҽ��� ���ϸ� int��ŭ ó���Ͽ� double ������ ��ȯ (�ݿø�)
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
     * �Ҽ��� ���� ó�� �޼ҵ�
     * double -> �Ҽ��� ���ϸ� Format ó���Ͽ� double ������ ��ȯ (�ݿø�)
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
     * �Ҽ��� ���� ó�� �޼ҵ�
     * double -> �Ҽ��� ���ϸ� int��ŭ ó���Ͽ� String ������ ��ȯ (�ݿø�)
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
     * �Ҽ��� ���� ó�� �޼ҵ�
     * double -> �Ҽ��� ���ϸ� Format ó���Ͽ� String ������ ��ȯ (�ݿø�)
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
     * ����(String Type) "," �� ����
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
     * ����(double dVal) "," �� ����
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
       message = "�ش��ڷᰡ �����ϴ�.";
      }else if(errormsg.indexOf("ORA-00001") > 0)
      {
       message = "�ڷ����� �ߺ��Ǿ����ϴ�.";
      }else if(errormsg.indexOf("ORA-00150") > 0)
      {
       message = "�ڷ����� �ߺ��Ǿ����ϴ�.";
      }else if(errormsg.indexOf("ORA-01400") > 0)
      {
       message = "���̺��� NOT NULL�÷��� NULL���� �ԷµǾ����ϴ�.";
      }else if(errormsg.indexOf("ORA-01401") > 0)
      {
       message = "���̺��� �÷�ũ�⺸�� ū �����Ͱ� �ԷµǾ����ϴ�.";
      }else if(errormsg.indexOf("ORA-02292") > 0)
      {
       message = "���õ� �ڷᰡ �־� ������ �� �����ϴ�.";
      }else if(errormsg.indexOf("ORA-00904") > 0)
      {
       message = "���̺� �Ǵ� �÷����� �������� �ʽ��ϴ�.";
      }else{
       message = errormsg;
      }
      return message;
     }
     
    /**
    * �ѱ� ó�� �޼ҵ�
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
	 * ���� null �� ��� ��� ���ڸ� ��ó�ؼ� ����
	 * @param sVal	��
	 * @param sInstead	����� ��  
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	public static String checkString(String	sVal, String sInstead) throws UnsupportedEncodingException  
	{
		String	sRtn	=	"";	//���ϰ�
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
