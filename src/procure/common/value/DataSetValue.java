package procure.common.value; 

import java.util.HashMap; 
import java.util.Iterator;
import java.util.Vector; 

/**
 * HashMap ����� �ϴ� Class�� ����� HashMap�� �����ϳ� 
 * get() Method �̿ܿ� getString(), getInt() ���� Method�� �߰��Ͽ� ���Ǽ��� ������.
 *
 * @author	�̻�
 * @version	1.0  3�� �ҽ�
 */
public class  DataSetValue {

    private HashMap hashMap = new HashMap();

    /**
    *��� : Default ������
    */
    public DataSetValue() {}

    /**
    *��� : �ؽ��ʿ� ls_key ������ String�� value�� �ִ´�.
    *@param  ls_key    key��
    *@param  ls_value  String���� value
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
    *��� : �ؽ��ʿ� ls_key ������ String�� value�� �ִ´�.
    *@param  ls_key    key��
    *@param  ls_value  String���� value
     * @throws UnsupportedEncodingException 
    */
    public void put(String ls_key, String ls_value) {
  		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
    	
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
  		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
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
    *��� : ls_key�� Ű���� ���� Object�� Value�� �����Ѵ�.
    *@param   ls_key  key ��
    *@return  int     Object�� Value
    */
    public Object get(Object ls_key) {
        return this.hashMap.get(ls_key);
    }
    
    public Object get (String ls_key) {
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
		if (ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}
		
		return this.hashMap.get(ls_key);
    }

    /**
    *��� : ls_key�� Ű���� ���� String�� Value�� �����Ѵ�.
    *@param   ls_key  key ��
    *@return  int     String �� Value
    */
    public String getString(String ls_key) {
  		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
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
    *��� : ls_key�� Ű���� ���� String[]�� Value�� �����Ѵ�.
    *@param   ls_key  key ��
    *@return  int     String[] �� Value
    */
    public String[] getStringList(Object ls_key) {
        return (String[])this.hashMap.get(ls_key);
    }

    /**
    *��� : ls_key�� Ű���� ���� Vector�� Value�� �����Ѵ�.
    *@param   ls_key  key ��
    *@return  int     Vector �� Value
    */
    public Vector getVector(Object ls_key) {
        return (Vector)this.hashMap.get(ls_key);
    }

    /**
    *��� : ls_key�� Ű���� ���� �����͸� �����Ѵ�.
    *@param   ls_key  key ��
    *@return  int     Vector �� Value
    */
    public void remove(String ls_key) {
		if (ls_key!=null && ls_key.length()!=0) {
		    ls_key = ls_key.toUpperCase();
		}
        this.hashMap.remove(ls_key);
    }

    /**
    *��� : ls_key�� Ű���� �ִ��� ����
    *@param   ls_key  key ��
    *@return  int     String �� Value
    */
    public boolean containsKey(Object ls_key) {
        return this.hashMap.containsKey(ls_key);
    }

    /**
    *��� : ls_key�� Ű���� �ִ��� ����
    *@param   ls_key  key ��
    *@return  int     String �� Value
    */
    public boolean containsValue(Object ls_value) {
        return this.hashMap.containsValue(ls_value);
    }

    public Iterator keySet() {
        return this.hashMap.keySet().iterator();
    }

    /**
    *��� : ��������� ����� ����ؿ´�.
    *@return  int  ��������� ������
    */
    public int size() {
        return this.hashMap.size();
    }
    
//----------------------------------- �߰� kkm  -------------------------------------//
	/**
	 *��� : �ؽ��ʿ� ls_key ������ String�� value�� �ִ´�.
	 *@param  ls_key    key��
	 *@param  ls_value  String���� value
	 */
	 public void put(String ls_key, int ls_value) {
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
   		
		if ( ls_key!=null && ls_key.length()!=0 )
		{
			this.hashMap.put(ls_key.toUpperCase(), "" + ls_value);
		}
	 }    
    

	 /**
	  *��� : �ؽ��ʿ� ls_key ������ String�� value�� �ִ´�.
	  *@param  ls_key    key��
	  *@param  ls_value  String���� value
	  */
	  public void put(String ls_key, double ls_value) {
			//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
    		
			if ( ls_key!=null && ls_key.length()!=0 )
			{
				this.hashMap.put(ls_key.toUpperCase(), "" + ls_value);
			}
	  } 

	public String getSInt(String ls_key) {
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
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
    	
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
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
    	
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
		if(ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}

		strRtn = (String)this.hashMap.get(ls_key);            	
		if (strRtn==null || (strRtn).equals(""))  strRtn = "0";

		return Double.parseDouble(strRtn);
	}
	
	/**
	 * long type���� �� ��ȯ
	 * @param ls_key		Ű��
	 * @return
	 * @throws Exception
	 */
	public long getLong(String ls_key){
		String strRtn = "";
    	
		//Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
		if(ls_key!=null && ls_key.length()!=0) {
			ls_key = ls_key.toUpperCase();
		}

		strRtn = (String)this.hashMap.get(ls_key);          	
		if (strRtn==null || (strRtn).equals(""))  strRtn = "0";

		return Long.parseLong(strRtn);  
	}
}