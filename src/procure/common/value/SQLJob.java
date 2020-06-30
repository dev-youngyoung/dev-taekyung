package procure.common.value;

import java.io.StringReader;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;

import javax.naming.NamingException;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.db.LoggableStatement;
import procure.common.db.SQLManager;

public class SQLJob {
	private HashMap			hm			=	null;
	private	QueryManager	qm			=	null;
	private	SQLManager		sqlm		=	null;
	private	ArrayList		al			=	null;
	private	boolean			bContinue	=	false;
	private	boolean			bGSuccess	=	true;
	private	int				iSize		=	0;
	
	/**
	 * 생성자 (하나의 query xml을 사용할경우, _bContinue가 true이면 connection close안함)
	 * @param sXml
	 * @param _bContinue
	 * @throws Exception
	 */
	public SQLJob(String sXml, boolean _bContinue) throws Exception
	{
		try {
			if(this.qm == null)
			{
				this.qm			=	new	QueryManager("query/"+sXml);
				this.sqlm		=	new	SQLManager();
				this.sqlm.getConnection().setAutoCommit(false);
				this.bContinue	=	_bContinue;
			}
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
		}
	}
	
	/**
	 * 생성자 (하나의 query xml을 사용할경우, connection 자동 close)
	 * @param sXml
	 * @throws Exception
	 */
	public SQLJob(String sXml) throws Exception
	{
		try {
			if(this.qm == null)
			{
				this.qm		=	new	QueryManager("query/"+sXml);
				this.sqlm	=	new	SQLManager();
				this.sqlm.getConnection().setAutoCommit(false);
			}
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
		}
	}
	
	/**
	 * 생성자 (여러개의 query xml을 사용할경우, connection close안함)
	 * @param _bContinue
	 * @throws Exception
	 */
	public SQLJob(boolean _bContinue) throws Exception
	{
		try {
			if(this.qm == null)
			{
				this.sqlm		=	new	SQLManager();
				this.sqlm.getConnection().setAutoCommit(false);
				this.bContinue	=	_bContinue;
			}
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
		}
	}
	
	/**
	 * 생성자 (여러개의 query xml을 사용할경우, connection 자동 close)
	 * @throws Exception
	 */
	public SQLJob() throws Exception
	{
		try {
			this.sqlm	=	new	SQLManager();
			this.sqlm.getConnection().setAutoCommit(false);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".SQLJob()] :" + e.toString());
		}
	} 

	
	/**
	 * where 조건절 담기
	 * @param sKey	키
	 */
	public void setParam(Map map)
	{
		Object[]	oaKey 		= 	map.keySet().toArray();
		String		sKey		=	"";
		String		sVal		=	"";

		for(int i=0; i < oaKey.length; i++)
		{
			sKey 	= 	oaKey[i].toString();
			sVal	=	map.get(sKey).toString();		
		
			if(this.hm == null)
			{
				this.hm	=	new	HashMap();
			}
			this.hm.put(sKey, sVal);
		}
	}	
	
	/**
	 * where 조건절 담기
	 * @param sKey	키
	 * @param sVal	값
	 */
	public void setParam(String sKey,String sVal)
	{
		if(this.hm == null)
		{
			this.hm	=	new	HashMap();
		}
		this.hm.put(sKey, sVal);
	}
	
	/**
	 * where 조건절 담기
	 * @param sKey	키
	 * @param iVal	값
	 */
	public void setParam(String sKey,int iVal)
	{
		if(this.hm == null)
		{
			this.hm	=	new	HashMap();
		}
		this.hm.put(sKey, iVal+"");
	}
	
	/**
	 * 초기화
	 */
	public void removeHashMap()
	{
		if(this.hm != null)
		{
			this.hm.clear();
			this.hm = null;
		}
	}
	
	/**
	 * arrayList에 담기
	 * @param oj
	 */
	public void setArray(Object oj)
	{		
		if(this.al == null)
		{
			this.al	=	new	ArrayList();
		}
		this.al.add(oj);
	}
	
	/**
	 * arrayList에 담기
	 * @param sVal
	 */
	public void setReaderArray(String sVal)
	{
		if(this.al == null)
		{
			this.al	=	new	ArrayList();
		}
		
		this.iSize	=	+sVal.length();
		StringReader	sr	=	new StringReader(sVal);
		
		this.al.add(sr);
	}
	
	/**
	 * ArrayList 지우기
	 */
	public void removeArray()
	{
		if(this.al != null)
		{
			this.al.clear();
			this.al	=	null;
		}
	}
	
	/**
	 * 여러행 반환
	 * @param sId	id element
	 * @return
	 * @throws Exception
	 */
	public ResultSetValue getRows(String sId) throws Exception
	{
		ResultSetValue	rsv	=	null;
		try {
			String		sQuery	=	"";
			
			if(this.hm != null)
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]", this.hm);
				this.removeHashMap();
			}else
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]");
			}
			
			rsv	=	this.sqlm.getRows(sQuery,this.bContinue);
		} catch (ConfigurationException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		}
		return rsv;
	}
	
	/**
	 * 여러행 반환
	 * @param sId	id element
	 * @return
	 * @throws Exception
	 */
	public ResultSetValue getRows(String sXml, String sId) throws Exception
	{
		ResultSetValue	rsv	=	null;
		try {
			this.qm	=	new	QueryManager("query/"+sXml);
			String		sQuery	=	"";
			
			if(this.hm != null)
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]", this.hm);
				this.removeHashMap();
			}else
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]");
			}
			
			rsv	=	this.sqlm.getRows(sQuery,this.bContinue);
		} catch (ConfigurationException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		}
		return rsv;
	}
	
	/**
	 * 한행 반환
	 * @param sId	query id
	 * @return
	 * @throws Exception
	 */
	public DataSetValue getOneRow(String sId) throws Exception
	{
		DataSetValue	dsv	=	null;
		try {
			String			sQuery	=	"";
			
			if(this.hm != null)
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]", this.hm);
				
				this.removeHashMap();
			}else
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]");
			}
			
			dsv	=	this.sqlm.getOneRow(sQuery,this.bContinue);
		} catch (ConfigurationException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			
			e.printStackTrace();
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			this.close();  // 쿼리를 불러오지 못해서 에러났으면 close() 해주자.
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} 
		return dsv;
	}
	
	/**
	 * 한행 반환
	 * @param sQuery
	 * @return
	 * @throws Exception
	 */
	public DataSetValue	getDataSetValue(String sQuery) throws Exception
	{
		DataSetValue	dsv	=	null;
		try {
			dsv	=	this.sqlm.getOneRow(sQuery,this.bContinue);
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".getDataSetValue()] :" + e.toString());
			this.close();  // 쿼리를 불러오지 못해서 에러났으면 close() 해주자.
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getDataSetValue()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".getDataSetValue()] :" + e.toString());
			this.close();  // 쿼리를 불러오지 못해서 에러났으면 close() 해주자.
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getDataSetValue()] :" + e.toString());
		}
		return dsv;
	}
	
	/**
	 * 해당조건의 수 구하기
	 * @param sColum	컬럼명
	 * @param sTable	테이블명
	 * @param sWhere	조건절 (EX AND xx = xx)
	 * @return
	 * @throws Exception
	 */
	public int getCount(String sColum, String sTable, String sWhere) throws Exception
	{
		int	iCnt	=	0;
		try {
			iCnt	=	this.sqlm.getCount(sColum, sTable, sWhere, this.bContinue);
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		}
		return iCnt;
	}
	
	/**
	 * 해당조건의 최대수 구하기
	 * @param sColum	컬럼명
	 * @param sTable	테이블명
	 * @param sWhere	조건절 (EX AND xx = xx)
	 * @return
	 * @throws Exception
	 */
	public int getMaxNo(String sColum, String sTable, String sWhere) throws Exception
	{
		int	iCnt	=	0;
		try {
			iCnt	=	this.sqlm.getMaxNo(sColum, sTable, sWhere, this.bContinue);
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		}
		return iCnt;
	}
	
	/**
	 * 한행 반환
	 * @param sId	query id
	 * @return
	 * @throws Exception
	 */
	public DataSetValue getOneRow(String sXml, String sId) throws Exception
	{
		DataSetValue	dsv	=	null;
		try {
			this.qm	=	new	QueryManager("query/"+sXml);
			String			sQuery	=	"";
			
			if(this.hm != null)
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]", this.hm);
				this.removeHashMap();
			}else
			{
				sQuery	=	this.qm.getQuery("select[@id="+sId+"]");
			}
			
			dsv	=	sqlm.getOneRow(sQuery,this.bContinue);
		} catch (ConfigurationException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} 
		return dsv;
	}
	
	

	private static final String PARAM_CHAR1 = "#";	//SQL 변수 구분자 ex) #param1#
	private static final String PARAM_CHAR2 = "$";	//SQL 변수 구분자 ex) $param2$
	private ArrayList paramInfoAry = null;			//SQL에서 추출한 파라미터 정보
	
	public String parseQuery(String query) throws Exception{

		this.al = new ArrayList();
		this.paramInfoAry = new ArrayList();
		
		int idx1_1 = query.indexOf(PARAM_CHAR1);
		int idx2_1 = query.indexOf(PARAM_CHAR2);
		
		while(idx1_1 > -1 || idx2_1 > -1){
		
			if(idx1_1 > -1 && ( (idx1_1 < idx2_1) || idx2_1 == -1)){
				query = replaceParamString(query, PARAM_CHAR1, idx1_1);
			}else if(idx2_1 > -1 && ( (idx2_1 < idx1_1) || idx1_1 == -1)){
				query = replaceParamString(query, PARAM_CHAR2, idx2_1);
			}
			
			idx1_1 = query.indexOf(PARAM_CHAR1);
			idx2_1 = query.indexOf(PARAM_CHAR2);
		}
		
		int size = this.paramInfoAry.size();
		String value = null;
		
		for(int i=0; i<size;i++){
			String[] param = (String[])this.paramInfoAry.get(i);
			
			value = ( this.hm.get(param[0]) == null ) ? "" : String.valueOf(this.hm.get(param[0]));
			
			if(param[1] == PARAM_CHAR1){
				//#은 String으로 대체
				this.al.add(value);
				//System.out.println("["+i+"]"+param[0]+"='"+this.hm.get(param[0])+"'");
			}else{
				//$는 숫자로 대체
				this.al.add(new Double( ( value == null || "".equals(value)) ? "0" : value.replaceAll("[^0-9]", "")  ));
				//System.out.println("["+i+"]"+param[0]+"="+this.hm.get(param[0]));
			}
		}
		
		return query;
	}
	
	private String replaceParamString(String srcStr, String str, int startIdx) throws Exception{
		
		int endIdx = srcStr.indexOf(str, startIdx+1);
		
		if(endIdx == -1){
			System.out.println("Error:"+str+"/"+startIdx);
			throw new Exception("Parse Exception");
		}else{
			paramInfoAry.add(new String[]{srcStr.substring(startIdx+1, endIdx), str});
			return srcStr.substring(0, startIdx) + "?" + srcStr.substring(endIdx+1); 
		}
	}
	

	public boolean inUpDeData(String sQueryDiv, String sId){
		return inUpDeData(sQueryDiv, sId, false, null);
	}
	
	/**
	 * insert, update, delete 문 처리
	 * @param 	sQueryDiv	구분자(insert,update,delete)
	 * @param 	sId			query id
	 * @param 	arr			값 ArrayList
	 * @return
	 * @throws Exception
	 */
	public boolean inUpDeData(String sQueryDiv, String sId, boolean usedMap, HashMap hm)
	{
		boolean	bSuccess	=	true;
		LoggableStatement	ls	=	null;
		try {
			if(this.bGSuccess)
			{
				String	sQuery	=	"";
				
				if(hm == null)
				{
					sQuery	=	this.qm.getQuery(sQueryDiv+"[@id="+sId+"]");
				}else
				{
					sQuery	=	this.qm.getQuery(sQueryDiv+"[@id="+sId+"]",hm);
				}
				
				//setParam() 메소드를 이용한 경우 다음에서 array로 변경
				if(usedMap){
					sQuery = parseQuery(sQuery);
				}
				
				ls	=	new	LoggableStatement(this.sqlm.getConnection(), sQuery);
				if(this.al != null && this.al.size() > 0)
				{
					for(int i=0; i < this.al.size(); i++)
					{
						if(this.al.get(i).getClass().getName().equals("java.io.StringReader"))
						{
							ls.setCharacterStream((i+1), (StringReader)this.al.get(i),this.iSize);
						}else
						{
							ls.setObject((i+1),this.al.get(i));	
						}
					}
				}
				
				if(this.al != null) this.removeArray();
				ls.executeUpdate();
			}
		} catch (UnsupportedEncodingException e) {
			bSuccess		=	false;
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			e.printStackTrace();
		} catch (SQLException e) {
			bSuccess		=	false;
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			e.printStackTrace();
		} catch (NamingException e) {
			bSuccess		=	false;
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			e.printStackTrace();
		} catch(Exception e){
			bSuccess		=	false;
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			e.printStackTrace();
		} finally
		{			
			try {
				if(ls != null)
				{
					ls.close();
				}
			} catch (SQLException e) {
				this.bGSuccess	=	false;
				bSuccess		=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			}
			
			try {
				if(!this.bContinue && this.sqlm != null && this.sqlm.getConnection() != null && !this.sqlm.getConnection().isClosed())
				{
					this.sqlm.getConnection().close();
				}
			} catch (Exception e) {
				this.bGSuccess	=	false;
				bSuccess		=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			}
		}
		return bSuccess;
	}
	
	public boolean inUpDeData(String sXml, String sQueryDiv, String sId)
	{
		boolean	bSuccess	=	true;
		LoggableStatement	ls	=	null;
		try {
			if(this.bGSuccess)
			{
				this.qm	=	new	QueryManager("query/"+sXml);
				String	sQuery	=	this.qm.getQuery(sQueryDiv+"[@id="+sId+"]");
				
				ls	=	new	LoggableStatement(this.sqlm.getConnection(), sQuery);
				if(this.al != null && this.al.size() > 0)
				{
					for(int i=0; i < this.al.size(); i++)
					{
						ls.setObject((i+1),this.al.get(i));
					}
					if(this.al != null) this.removeArray();
				}
				ls.executeUpdate();
			}
		} catch (UnsupportedEncodingException e) {
			this.bGSuccess	=	false;
			bSuccess		=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
		} catch (SQLException e) {
			this.bGSuccess	=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
		} catch (NamingException e) {
			this.bGSuccess	=	false;
			bSuccess		=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
		} catch (ConfigurationException e) {
			this.bGSuccess	=	false;
			bSuccess		=	false;
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
		} finally
		{			
			ls.getQueryString();
			
			try {
				if(ls != null)
				{
					ls.close();
				}
			} catch (SQLException e) {
				this.bGSuccess	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			}
			
			try {
				if(!this.bContinue && this.sqlm != null && this.sqlm.getConnection() != null && !this.sqlm.getConnection().isClosed())
				{
					this.sqlm.getConnection().close();
				}
			} catch (Exception e) {
				this.bGSuccess	=	false;
				System.out.println("[ERROR "+this.getClass().getName() + ".inUpDeData()] :" + e.toString());
			}
		}
		return bSuccess;
	}
	

	public boolean insertData(String sId) throws Exception{
		return insertData(sId, false);
	}
	
	public boolean insertData(String sId, HashMap hm)
	{
		return this.insertData(sId, false, hm);
	}
	
	/**
	 * insert 처리
	 * @param sId	query id
	 * @param arr	arr			값 ArrayList
	 * @return
	 * @throws Exception
	 */
	public boolean insertData(String sId, boolean usedMap) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData("insert", sId, usedMap, null);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	public boolean insertData(String sId, boolean usedMap, HashMap hm)
	{
		boolean	bSuccess	=	false;
		bSuccess	=	this.inUpDeData("insert", sId, usedMap, hm);
		return bSuccess;
	}
	
	
	public boolean insertData(String sXml, String sId) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData(sXml, "insert", sId);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	public boolean updateData(String sId) throws Exception{
		return updateData(sId, false);
	}
	
	/**
	 * update 처리
	 * @param sId	query id
	 * @param arr	arr			값 ArrayList
	 * @return
	 * @throws Exception
	 */
	public boolean updateData(String sId, boolean usedMap) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData("update", sId, usedMap, null);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	public boolean updateData(String sXml, String sId) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData(sXml, "update", sId);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	public boolean deleteData(String sId) throws Exception{
		return deleteData(sId, false);
	}
	
	/**
	 * update 처리
	 * @param sId	query id
	 * @param arr	arr			값 ArrayList
	 * @return
	 * @throws Exception
	 */
	public boolean deleteData(String sId, boolean usedMap) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData("delete", sId, usedMap, null);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".deleteData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".deleteData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	public boolean deleteData(String sXml, String sId) throws Exception
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.inUpDeData(sXml, "delete", sId);
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".deleteData()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".deleteData()] :" + e.toString());
		}
		return bSuccess;
	}
	
	/**
	 * false 상태 setting
	 */
	public void setFalse()
	{
		this.bGSuccess	=	false;
	}
	
	/**
	 * close;
	 * @throws Exception
	 */
	public void close() throws Exception
	{
		try {
			if(this.sqlm != null)
			{
				if(this.bGSuccess)
				{
					this.sqlm.getConnection().commit();
				}
				else
				{
					this.sqlm.getConnection().rollback();
				}
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
		} finally
		{
			if(this.sqlm != null && this.sqlm.getConnection() != null && !this.sqlm.getConnection().isClosed())
			{
				this.sqlm.getConnection().close();
			}
		}
	}
	
}
