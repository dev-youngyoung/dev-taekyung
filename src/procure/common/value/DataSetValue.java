package procure.common.value; 

import java.util.HashMap; 
import java.util.Iterator;
import java.util.Vector; 

/**
 * HashMap 기능을 하는 Class로 기능은 HashMap과 동일하나 
 * get() Method 이외에 getString(), getInt() 등의 Method를 추가하여 편의성을 높였다.
 *
 * @author	미상
 * @version	1.0  3차 소스
 */
public class  DataSetValue {

    private HashMap hashMap = new HashMap();

    /**
    *기능 : Default 생성자
    */
    public DataSetValue() {}

    /**
    *기능 : 해쉬맵에 ls_key 값으로 String형 value를 넣는다.
    *@param  ls_key    key값
    *@param  ls_value  String형의 value
    */
    public void put(Object ls_key, Object ls_value) {
        this.hashMap.put(ls_key, ls_value);
    }

	public void put(String ls_key, Object ls_value) {
  		if ( ls_key!=null && ls_key.length()!=0 )
  		{
  			ls_key = ls_key.toUpperCase();
  			if ( ls_value!=null )
  				 this.hashMap.put(ls_key, ls_value);
  			else
  				this.hashMap.put(ls_key, "");
  		}
	}

    public HashMap get() {
        return hashMap;
    }

    /**
    *기능 : 해쉬맵에 ls_key 값으로 String형 value를 넣는다.
    *@param  ls_key    key값
    *@param  ls_value  String형의 value
     * @throws UnsupportedEncodingException 
    */
    public void put(String ls_key, String ls_value) {
  		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
    	
    		if ( ls_key!=null && ls_key.length()!=0 )
  			{
    			ls_key = ls_key.toUpperCase();
  			  	if ( ls_value!=null && ls_value.length()!=0 && !ls_value.equals("null") )
  			  	{
  			  		this.hashMap.put(ls_key, ls_value);
  			  	}else
  		  		{
  			  		this.hashMap.put(ls_key, "");
  		  		}
  			}
		
    }

    public void put(String ls_key, String ls_value, boolean is_single_q) 
    {
  		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
  		if ( ls_key!=null && ls_key.length()!=0 )
  		{
  			ls_key = ls_key.toUpperCase();
  			if ( ls_value!=null && ls_value.length()!=0 && !ls_value.equals("null") )
  				 this.hashMap.put(ls_key, ls_value);
  			else
  				this.hashMap.put(ls_key, "");
  		}
    }

    /**
    *기능 : ls_key의 키값을 가진 Object형 Value를 리턴한다.
    *@param   ls_key  key 값
    *@return  int     Object형 Value
    */
    public Object get(Object ls_key) {
        return this.hashMap.get(ls_key);
    }
    
    public Object get (String ls_key) {
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
		if (ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}
		
		return this.hashMap.get(ls_key);
    }

    /**
    *기능 : ls_key의 키값을 가진 String형 Value를 리턴한다.
    *@param   ls_key  key 값
    *@return  int     String 형 Value
    */
    public String getString(String ls_key) {
  		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
    	String	sRtnVal	=	"";
		
    	
    		if (ls_key!=null && ls_key.length()!=0) 
    		{
    			ls_key = ls_key.toUpperCase();
    		}
			
    		if(this.hashMap.get(ls_key)==null)
			{
    			sRtnVal	=	 "";
			}else
			{
				sRtnVal	=	this.hashMap.get(ls_key).toString().trim();
			}
		return sRtnVal;
    }

    /**
    *기능 : ls_key의 키값을 가진 String[]형 Value를 리턴한다.
    *@param   ls_key  key 값
    *@return  int     String[] 형 Value
    */
    public String[] getStringList(Object ls_key) {
        return (String[])this.hashMap.get(ls_key);
    }

    /**
    *기능 : ls_key의 키값을 가진 Vector형 Value를 리턴한다.
    *@param   ls_key  key 값
    *@return  int     Vector 형 Value
    */
    public Vector getVector(Object ls_key) {
        return (Vector)this.hashMap.get(ls_key);
    }

    /**
    *기능 : ls_key의 키값을 가진 데이터를 삭제한다.
    *@param   ls_key  key 값
    *@return  int     Vector 형 Value
    */
    public void remove(String ls_key) {
		if (ls_key!=null && ls_key.length()!=0) {
		    ls_key = ls_key.toUpperCase();
		}
        this.hashMap.remove(ls_key);
    }

    /**
    *기능 : ls_key의 키값이 있는지 조사
    *@param   ls_key  key 값
    *@return  int     String 형 Value
    */
    public boolean containsKey(Object ls_key) {
        return this.hashMap.containsKey(ls_key);
    }

    /**
    *기능 : ls_key의 키값이 있는지 조사
    *@param   ls_key  key 값
    *@return  int     String 형 Value
    */
    public boolean containsValue(Object ls_value) {
        return this.hashMap.containsValue(ls_value);
    }

    public Iterator keySet() {
        return this.hashMap.keySet().iterator();
    }

    /**
    *기능 : 멤버변수의 사이즈를 계산해온다.
    *@return  int  멤버변수의 사이즈
    */
    public int size() {
        return this.hashMap.size();
    }
    
//----------------------------------- 추가 kkm  -------------------------------------//
	/**
	 *기능 : 해쉬맵에 ls_key 값으로 String형 value를 넣는다.
	 *@param  ls_key    key값
	 *@param  ls_value  String형의 value
	 */
	 public void put(String ls_key, int ls_value) {
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
   		
		if ( ls_key!=null && ls_key.length()!=0 )
		{
			this.hashMap.put(ls_key.toUpperCase(), "" + ls_value);
		}
	 }    
    

	 /**
	  *기능 : 해쉬맵에 ls_key 값으로 String형 value를 넣는다.
	  *@param  ls_key    key값
	  *@param  ls_value  String형의 value
	  */
	  public void put(String ls_key, double ls_value) {
			//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
    		
			if ( ls_key!=null && ls_key.length()!=0 )
			{
				this.hashMap.put(ls_key.toUpperCase(), "" + ls_value);
			}
	  } 

	public String getSInt(String ls_key) {
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
		if (ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}
		
		String temp ="";
		
		temp = (String)this.hashMap.get(ls_key);
		
		if ( temp!=null && temp.length()!=0 && !temp.equals("null") )
			return (String)this.hashMap.get(ls_key);
		else 
			return "0";
	}  
	
	public int getInt(String ls_key){		
		String strRtn = "";
    	
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
		if(ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}else
		{
			return	0;
		}
		
		if(this.hashMap.get(ls_key) == null)
		{
			return	0;
		}else
		{
			strRtn = this.hashMap.get(ls_key).toString();
			if(strRtn.length() < 1)
			{
				return	0;
			}else
			{
				return Integer.parseInt(strRtn);
			}
		}
	}

	public double getDouble(String ls_key) throws Exception {
		String strRtn = "";
    	
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
		if(ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}

		strRtn = (String)this.hashMap.get(ls_key);            	
		if (strRtn==null || (strRtn).equals(""))  strRtn = "0";

		return Double.parseDouble(strRtn);
	}
	
	/**
	 * long type으로 값 반환
	 * @param ls_key		키값
	 * @return
	 * @throws Exception
	 */
	public long getLong(String ls_key){
		String strRtn = "";
    	
		//키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
		if(ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}

		strRtn = (String)this.hashMap.get(ls_key);          	
		if (strRtn==null || (strRtn).equals(""))  strRtn = "0";

		return Long.parseLong(strRtn);  
	}
}