package procure.common.value;

import java.util.HashMap;
import java.util.Map;
import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import procure.common.conf.Config;
import procure.common.utils.StrUtil;

/**
 * query 처리 
 * @author lee jong whan
 *
 */
public class QueryManager {
	
	private	CompositeConfiguration  ccf				=	null; 
	private	String 					sXMLFileName	=	"";		
	
	/**
	 * QueryManager	생성자
	 * @param sXMLFileName	파일경로
	 * @throws ConfigurationException 
	 */
	public QueryManager(String sXMLFileName) throws ConfigurationException{
		try {
			this.ccf	=	Config.getInstance(sXMLFileName);
			this.setXMLFileName(sXMLFileName);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass()+".QueryManager()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass()+".QueryManager()] :" + e.toString());
		}
	}
	
	/**
	 * query 파일 정보 가져오기
	 * @return
	 */
	public String getXMLFileName() {
		return sXMLFileName;
	}
	
	/**
	 * query 파일 정보 담기
	 * @param fileName
	 */
	public void setXMLFileName(String sXMLFileName) {
		this.sXMLFileName = sXMLFileName;
	}

	/**
	 * 쿼리문 CompositeConfiguration 문에 맞게 바꾸기
	 * @param sXQuery	쿼리
	 * @return
	 */
	public String getReplaceXQuery(String sXQuery)
	{
		//System.out.println("QUERY FILE	 ["+this.getXMLFileName()+"]");
		//System.out.println("QUERY NODE ID["+sXQuery+"]");
		
		String[]	saValue		=	sXQuery.split("/");
		String		sAttrNm		=	"";
		int			iIndex		=	-1;
		String		_sXQuery	=	"";
		String 		sNodeNm		=	"";
		Map			map;
		for(int i = 0; i < saValue.length; i++)
		{
			sNodeNm	=	this.getNodeName(saValue[i]);
			map			=	this.getAtrriMap(saValue[i]);
			
			if(map != null && map.size() > 0)
			{
				sAttrNm	=	sNodeNm + "[@" +map.get("key")+ "]";
				
				if(i == 0)
				{
					iIndex		=	this.getNodeIndex(sAttrNm, map.get("value").toString());
					_sXQuery	=	sNodeNm	+ "("+ iIndex +")";
				}else
				{
					iIndex		=	this.getNodeIndex(_sXQuery + "." + sAttrNm, map.get("value").toString());
					_sXQuery	= _sXQuery + "." + sNodeNm	+ "("+ iIndex +")";
				}
			}else
			{
				if(i == 0)	_sXQuery 	=	sNodeNm;
				else		_sXQuery 	= 	_sXQuery + "." + sNodeNm;
			}
		}
		
		return _sXQuery;
	}
	
	/**
	 * XML에서 쿼리에서 가져오기
	 * @param sXQuery	쿼리문
	 * @return
	 * @throws Exception 
	 */
	public String getQuery(String sXQuery)
	{
		System.out.println("QUERY XML NAME : " + this.getXMLFileName());
		System.out.println("QUERY ID : " + sXQuery);
		
		String	sRtnQuery	=	"";
		String	sRtnQuery2	=	"";
		String	sQuery	=	this.getReplaceXQuery(sXQuery);
		
		if(this.ccf.getString(sQuery) != null && this.ccf.getString(sQuery).length() > 0)
		{
			sRtnQuery	=	this.ccf.getString(sQuery);
		}
		
		String[] aRtnQuery = sRtnQuery.split("\n");
		
		int j = 0;
		for(int i=0; i < aRtnQuery.length; i++)
		{			
			if(aRtnQuery[i].trim().length() > 0)
			{
				sRtnQuery2	+=	aRtnQuery[i] + "\n";
			}else
			{
				String[]	saList =	ccf.getStringArray(sQuery+".dynamic");
				if(j==0 && saList.length > 0)
				{
					sRtnQuery2	+=	"__dynamic__\n";
					j = 1;
				}
			}
		}
		
		sRtnQuery	=	sRtnQuery2;
		
		return sRtnQuery;
	}
	
	/**
	 * XML에서 쿼리 가져오기 #변수명# -> '값'으로 대처
	 * @param sXQuery	xml 파일 경로
	 * @param sKey		변수명
	 * @param sVal		변수값
	 * @return
	 * @throws Exception 
	 */
	public String getQuery(String sXQuery, String sKey, String sVal) throws Exception
	{
		String 	sQuery		=	"";
		String	sRtnQuery	=	"";
		
		try {
			if(sVal == null || sVal.length() < 1)
			{
				sVal	=	"qazwsxedcrfvtgbyhnujmik,ol.p";
			}else
			{
				sVal	=	StrUtil.replace(sVal, "$", "pl,okmijnuhb");
				sVal	=	StrUtil.replace(sVal, "\\", "\\\\");	
				sVal	=	sVal.replaceAll("'", "''");
			}
			
			sQuery = this.getQuery(sXQuery);
			if(sQuery.indexOf("__dynamic__\n") > 0)
			{
				String 	sXSubQuery	=	"";
				if(sVal == null || sVal.length() < 1)
				{
					sXSubQuery	=	sXQuery+"/dynamic[@"+sKey+"=ALL]";
				}else
				{
					sXSubQuery	=	sXQuery+"/dynamic[@"+sKey+"="+sVal+"]";
				}
					
				String[]	saList	=	ccf.getStringArray(this.getReplaceXQuery(sXSubQuery));
				
				if(saList.length > 0)
				{
					String sSubQuery	=	this.getQuery(sXSubQuery);
					sQuery	=	sQuery.replaceAll("__dynamic__\n",sSubQuery);
				}
			}
			
			sQuery	=	sQuery.replaceAll("#"+sKey+"#", "'"+sVal+"'");
			sQuery	=	sQuery.replaceAll("\\$"+sKey+"\\$",sVal);
			
			if(	sQuery.toUpperCase().indexOf("INSERT") == -1 &&
				sQuery.toUpperCase().indexOf("UPDATE") == -1 &&
				sQuery.toUpperCase().indexOf("DELETE") == -1)
			{		
				String[] aRtnQuery = sQuery.split("\n"); 
				
				for(int i=0; i < aRtnQuery.length; i++)
				{
					if(aRtnQuery[i].indexOf("qazwsxedcrfvtgbyhnujmik,ol.p") == -1 && aRtnQuery[i].indexOf("__dynamic__") == -1 && aRtnQuery[i].indexOf("#") == -1 && aRtnQuery[i].indexOf("$") == -1)
					{					
						sRtnQuery	+=	aRtnQuery[i] + "\n";
					}
				}
				
				sQuery	=	sRtnQuery;
			}
			sQuery	=	StrUtil.replace(sQuery, "qazwsxedcrfvtgbyhnujmik,ol.p", "");
			sQuery	=	StrUtil.replace(sQuery, "pl,okmijnuhb", "$");
		}  catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getQuery()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass()+".getQuery()] :" + e.toString());
		}
		
		return sQuery;
	}
	
	/**
	 * XML에서 쿼리 가져오기 #변수명# -> '값'으로 대처
	 * @param sXQuery	xml 파일 경로
	 * @param map		[변수명,변수값] Map 구조
	 * @return
	 * @throws Exception 
	 */
	public String getQuery(String sXQuery, Map map) throws Exception
	{
		String sQuery	=	null;
		try {
			sQuery = this.getQuery(sXQuery);
			
			Object[]	oaKey 		= 	map.keySet().toArray();
			String		sKey		=	"";
			String		sVal		=	"";
			String		sRtnQuery	=	"";
			
			for(int i=0; i < oaKey.length; i++)
			{
				sKey 	= 	oaKey[i].toString();
				sVal	=	map.get(sKey).toString();
				
				if(sQuery.indexOf("__dynamic__\n") > 0)
				{
					String 	sXSubQuery	=	"";
					if(sVal == null || sVal.length() < 1)
					{
						sXSubQuery	=	sXQuery+"/dynamic[@"+sKey+"=ALL]";
					}else
					{
						sXSubQuery	=	sXQuery+"/dynamic[@"+sKey+"="+sVal+"]";
					}
						
					String[]	saList	=	ccf.getStringArray(this.getReplaceXQuery(sXSubQuery));
					
					if(saList.length > 0)
					{
						String sSubQuery	=	this.getQuery(sXSubQuery);
						sQuery	=	sQuery.replaceAll("__dynamic__\n",sSubQuery);
					}
				}
				
				if(sVal == null || sVal.length() < 1)
				{
					sVal	=	"qazwsxedcrfvtgbyhnujmik,ol.p";
				}else
				{
					sVal	=	StrUtil.replace(sVal, "$", "pl,okmijnuhb");
					sVal	=	StrUtil.replace(sVal, "\\", "\\\\");
					sVal	=	sVal.replaceAll("'", "''");
				}

				sQuery 	= 	sQuery.replaceAll("#"+sKey+"#","'"+sVal+"'");
				sQuery	=	sQuery.replaceAll("\\$"+sKey+"\\$",sVal);
			}
			
			if(	sQuery.toUpperCase().indexOf("INSERT") == -1 &&
				sQuery.toUpperCase().indexOf("UPDATE") == -1 &&
				sQuery.toUpperCase().indexOf("DELETE") == -1)
			{
				String[] aRtnQuery = sQuery.split("\n");
				
				for(int i=0; i < aRtnQuery.length; i++)
				{
					if(aRtnQuery[i].indexOf("##") > 0)
					{
					  sRtnQuery  +=  aRtnQuery[i] + "\n";
					}else
					{
					  if(aRtnQuery[i].indexOf("qazwsxedcrfvtgbyhnujmik,ol.p") == -1 && aRtnQuery[i].indexOf("__dynamic__") == -1 && aRtnQuery[i].indexOf("#") == -1 && aRtnQuery[i].indexOf("$") == -1)
	          {         
	            sRtnQuery +=  aRtnQuery[i] + "\n";
	          }
					}
				}
				
				sQuery	=	sRtnQuery;
			}
			
			sQuery	=	StrUtil.replace(sQuery, "qazwsxedcrfvtgbyhnujmik,ol.p", "");
			sQuery	=	StrUtil.replace(sQuery, "pl,okmijnuhb", "$");
		}  catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getQuery()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass()+".getQuery()] :" + e.toString());
		}
		return sQuery;
	}
	
	/**
	 * insert 쿼리
	 * @param sId
	 * @return
	 */
	public String getInsertQuery(String sId)
	{
		return this.getQuery("insert[@id="+sId+"]");
	}
	
	/**
	 * insert 쿼리
	 * @param sId
	 * @param sKey	
	 * @param sVal
	 * @return
	 * @throws Exception
	 */
	public String getInsertQuery(String sId, String sKey, String sVal) throws Exception
	{
		return this.getQuery("insert[@id="+sId+"]", sKey, sVal);
	}
	
	/**
	 * insert 쿼리
	 * @param sId
	 * @param map
	 * @return
	 */
	public String getInsertQuery(String sId, Map map)
	{
		String	sQuery	=	"";
		try {
			sQuery	=	this.getQuery("insert[@id="+sId+"]", map);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getInsertQuery()] :" + e.toString());
		}
		return sQuery;
	}
	
	/**
	 * update 쿼리
	 * @param sId
	 * @return
	 */
	public String getUpdateQuery(String sId)
	{
		return this.getQuery("update[@id="+sId+"]");
	}
	
	/**
	 * update 쿼리
	 * @param sId
	 * @param sKey	
	 * @param sVal
	 * @return
	 * @throws Exception
	 */
	public String getUpdateQuery(String sId, String sKey, String sVal) throws Exception
	{
		return this.getQuery("update[@id="+sId+"]", sKey, sVal);
	}
	
	/**
	 * update 쿼리
	 * @param sId
	 * @param map
	 * @return
	 */
	public String getUpdateQuery(String sId, Map map)
	{
		String	sQuery	=	"";
		try {
			sQuery	=	this.getQuery("insert[@id="+sId+"]", map);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getUpdateQuery()] :" + e.toString());
		}
		return sQuery;
	}
	
	/**
	 * delete 쿼리
	 * @param sId
	 * @return
	 */
	public String getDeleteQuery(String sId)
	{
		return this.getQuery("delete[@id="+sId+"]");
	}
	
	/**
	 * delete 쿼리
	 * @param sId
	 * @param sKey	
	 * @param sVal
	 * @return
	 * @throws Exception
	 */
	public String getDeleteQuery(String sId, String sKey, String sVal) throws Exception
	{
		return this.getQuery("delete[@id="+sId+"]", sKey, sVal);
	}
	
	/**
	 * update 쿼리
	 * @param sId
	 * @param map
	 * @return
	 */
	public String getDeleteQuery(String sId, Map map)
	{
		String	sQuery	=	"";
		try {
			sQuery	=	this.getQuery("delete[@id="+sId+"]", map);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getDeleteQuery()] :" + e.toString());
		}
		return sQuery;
	}
	
	/**
	 * select 쿼리
	 * @param sId
	 * @return
	 */
	public String getSelectQuery(String sId)
	{
		return this.getQuery("select[@id="+sId+"]");
	}
	
	/**
	 * select 쿼리
	 * @param sId
	 * @param sKey	
	 * @param sVal
	 * @return
	 * @throws Exception
	 */
	public String getSelectQuery(String sId, String sKey, String sVal) throws Exception
	{
		return this.getQuery("select[@id="+sId+"]", sKey, sVal);
	}
	
	/**
	 * select 쿼리
	 * @param sId
	 * @param map
	 * @return
	 */
	public String getSelectQuery(String sId, Map map)
	{
		String	sQuery	=	"";
		try {
			sQuery	=	this.getQuery("select[@id="+sId+"]", map);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass()+".getSelectQuery()] :" + e.toString());
		}
		return sQuery;
	}
	
	
	
	/**
	 * node명 가져오기
	 * @param sFullNodeName	"/"로 쿼리문 분리
	 * @return
	 */
	public String getNodeName(String sFullNodeName)
	{
		String	sNode	=	"";
		if(sFullNodeName.indexOf("[") > 0)
		{
			sNode	=	sFullNodeName.substring(0,sFullNodeName.indexOf("["));
		}else
		{
			sNode	=	sFullNodeName;
		}
		return sNode;
	}
	
	/**
	 * Attribute MAP에 담기
	 * @param sFullNodeName	노드명
	 * @return
	 */
	public Map getAtrriMap(String sFullNodeName)
	{
		String 	sKey	=	"";
		String	sVal	=	"";
		String	sAttri	=	"";
		Map		map		=	new	HashMap();
		
		if(sFullNodeName.indexOf("@") > 0)
		{
			sAttri	=	sFullNodeName.substring(sFullNodeName.indexOf("@")+1);
			sAttri	=	sAttri.replaceAll("]", "");
			
			String[]	saVal	=	sAttri.split("=");
			sKey	=	saVal[0];
			sVal	=	saVal[1];
			
			map.put("key", sKey);
			map.put("value", sVal);
		}
		
		return map;
	}
	
	/**
	 * 노드에 해당하는 index값 가져오기
	 * @param sSubXQuery
	 * @param sAttriVal
	 * @return
	 */
	public int getNodeIndex(String sSubXQuery, String sAttriVal)
	{
		int			iIndex	=	-1;
		String[]	saList	=	ccf.getStringArray(sSubXQuery);
		
		for(int i=0; i < saList.length; i++)
		{					
			if(saList[i].toString().equals(sAttriVal))
			{
				iIndex	=	i;
				break;
			}
		}
		
		return	iIndex;
	}
}