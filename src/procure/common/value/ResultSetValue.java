/*
 * Created on 2005-12-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package procure.common.value; 

import java.io.File;
import java.util.ArrayList;   
import java.util.HashMap;

import procure.common.utils.StrUtil;

/**
 * 
 * @author ����ȯ
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ResultSetValue 
{ 
	ArrayList 	aData	=	null; 
	HashMap		hData	= 	null;		
	int			iCur	=	-1;		//������ �ټ�
	
	/**
	 * ����Ÿ ��������
	 * @param al
	 */
	public void getData(ArrayList al){
		this.aData		=	al; 
	}
	
	/**
	 * ó������ �ǵ���
	 *
	 */
	public void first() 
	{
		if(this.aData != null && this.aData.size() > 0)
		{
			iCur = -1;
			hData = (HashMap)this.aData.get(0);
		}
	}
	
	/**
	 * ��ü ����Ÿ �б�
	 * @return
	 */
	public boolean next(){
		if(this.aData	!=	null)
		{
			if(this.aData.size()-1>iCur){
				iCur++;
				this.hData	=	(HashMap)this.aData.get(iCur);
				return true;
			}else{
				return false;
			}		
		}else
		{
			return false;
		}
	}
	
	/**
	 * ��ü ��ϼ��� ����( �ݵ�� ������ COUNT(*) OVER() CNT ���)
	 * @return
	 */
	public int getDataCount()
	{
		int iRowCnt	=	0;
		try {
			if(this.aData != null && this.size() > 0)
			{
				for(int i=0; this.next(); i++)
				{
					if(i == 0)	iRowCnt	=	this.getInt("CNT");
					else 		break;
				}
				this.first();
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getDataCount()] :" + e.toString());
		}
		return iRowCnt;
	}
	
	/**
	 * ����Ÿ �ټ�
	 * @return
	 */
	public int size(){
		return	this.aData.size();
	}
	
	/**
	 * ������ ��(HashMap) 
	 * @return
	 */
	public HashMap getHashMap(){ 
		try {
			if(iCur == -1){
				throw new Exception("[ResultSetValue getString()] : Must execute method of next() before call getHashMap()...!");
			}
		}catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getHashMap()] :" + e.toString());
		}
		return hData; 
	}
	
	/**
	    *��� : ������ row���� �־��� Ű���� ���� �����͸� double������ casting�Ͽ� �����Ѵ�.
	    *       (Key���� ��ҹ��ڸ� �������� �ʴ´�.)
	    *@param   key      key ��
	    *@return  String   Value
	    */
	    public Object getObject(String key) throws Exception {
	        try {
	            //Ű���� ��� �빮�ڷ� ġȯ�Ͽ� ����ڷ� �Ͽ��� ��ҹ��� ���о��� ���������� �Ѵ�.
	            if(key!=null && key.length()!=0) {
	                key = key.toUpperCase();
	            }

	            if(iCur == -1){
	            	throw	new	Exception("[ERROR "+this.getClass()+".getObject()] : Object�� �������� �ʽ��ϴ�.");
	            }
	            else {
	                return hData.get(key);
	            }
	        }
	        catch(Exception e) {
				System.out.println("[ERROR "+this.getClass().getName() + ".getObject()] :" + e.toString());
	            throw e;
	        }
	    }
	
	/**
	 * ������ ��(String) 
	 * @param sKey
	 * @return
	 * @throws Exception 
	 */
	public String getString(String sKey) throws Exception
	{
		String sVal	=	"";
		try {
			if(this.getObject(sKey) != null)
			{
				sVal	=	StrUtil.ConfCharsetRev((String)this.getObject(sKey)).trim();
			}	 
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getString()] :" + e.toString());
			throw	new	Exception("[ERROR "+this.getClass()+".getString()] :" + e.toString());
		}
		return sVal;
	}
	
	/**
	 * ���ϰ�� '/'�� ��ȯ
	 * @param sFileUrl	���� ���
	 * @return
	 * @throws Exception
	 */
	public String	getReFileUrl(String sFileUrl) throws Exception
	{
		String	sVal	=	"";
		try {
			if(this.getString(sFileUrl) != null && this.getString(sFileUrl).length() > 0)
			{
				sVal	=	StrUtil.replace(this.getString(sFileUrl),File.separator,"/");
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getReFileUrl()] :" + e.toString());
			throw	new	Exception("[ERROR "+this.getClass()+".getReFileUrl()] :" + e.toString());
		}
		return sVal;
	}
	
	/**
	 * ������ ��(int) 
	 * @param sKey
	 * @return
	 * @throws Exception 
	 */
	public int getInt(String sKey) throws Exception
	{
		try {
			return Integer.parseInt(this.getString(sKey));
		} catch (NumberFormatException e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".getInt()] :" + e.toString());
			throw	new	NumberFormatException("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
		} catch (Exception e) { 
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".getInt()] :" + e.toString());
			throw	new	Exception("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
		}
	}
	
	/**
	 * ������ ��(long)
	 * @param sKey
	 * @return
	 * @throws Exception 
	 */
	public long	getLong(String	sKey) throws Exception 
	{
		try {
			return	Long.parseLong(getString(sKey));
		} catch (NumberFormatException e) { 
			System.out.println("[ERROR "+this.getClass().getName() + ".getLong()] :" + e.toString());
			throw	new	NumberFormatException("[ERROR "+this.getClass()+".getLong()] :" + e.toString());
		} catch (Exception e) {  
			System.out.println("[ERROR "+this.getClass().getName() + ".getLong()] :" + e.toString());
			throw	new	Exception("[ERROR "+this.getClass()+".getLong()] :" + e.toString());
		}
	}
	
	/**
	 * ������ ��(double)
	 * @param sKey
	 * @return
	 * @throws Exception
	 */
	public double getDouble(String sKey) throws Exception 
	{
		try {
			if(this.getString(sKey) != null && this.getString(sKey).length() > 0)
			{
				return	Double.parseDouble(this.getString(sKey));
			}else
			{
				return 0;
			}
		} catch (NumberFormatException e) { 
			System.out.println("[ERROR "+this.getClass().getName() + ".getDouble()] :" + e.toString());
			throw	new	NumberFormatException("[ERROR "+this.getClass()+".getDouble()] :" + e.toString());
		} catch (Exception e) { 
			System.out.println("[ERROR "+this.getClass().getName() + ".getDouble()] :" + e.toString());
			throw	new	Exception("[ERROR "+this.getClass()+".getDouble()] :" + e.toString());
		}
	}
}	
