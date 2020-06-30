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
 * @author 이종환
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ResultSetValue 
{ 
	ArrayList 	aData	=	null; 
	HashMap		hData	= 	null;		
	int			iCur	=	-1;		//현재의 줄수
	
	/**
	 * 데이타 가져오기
	 * @param al
	 */
	public void getData(ArrayList al){
		this.aData		=	al; 
	}
	
	/**
	 * 처음으로 되돌림
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
	 * 전체 데이타 읽기
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
	 * 전체 목록수를 구함( 반드시 쿼리에 COUNT(*) OVER() CNT 명시)
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
	 * 데이타 줄수
	 * @return
	 */
	public int size(){
		return	this.aData.size();
	}
	
	/**
	 * 페이지 값(HashMap) 
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
	    *기능 : 지정된 row에서 주어진 키값을 가진 데이터를 double형으로 casting하여 리턴한다.
	    *       (Key값은 대소문자를 구분하지 않는다.)
	    *@param   key      key 값
	    *@return  String   Value
	    */
	    public Object getObject(String key) throws Exception {
	        try {
	            //키값을 모두 대문자로 치환하여 사용자로 하여금 대소문자 구분없이 가져오도록 한다.
	            if(key!=null && key.length()!=0) {
	                key = key.toUpperCase();
	            }

	            if(iCur == -1){
	            	throw	new	Exception("[ERROR "+this.getClass()+".getObject()] : Object가 존재하지 않습니다.");
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
	 * 페이지 값(String) 
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
	 * 파일경로 '/'로 변환
	 * @param sFileUrl	파일 경로
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
	 * 페이지 값(int) 
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
	 * 페이지 값(long)
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
	 * 페이지 값(double)
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
