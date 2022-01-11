/*
 * Created on 2005-12-12
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package procure.common.db;

import procure.common.utils.StrUtil;
import procure.common.value.DataSetValue;
import procure.common.value.ResultSetValue;

import java.io.IOException;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

import oracle.sql.CLOB;

import org.apache.commons.configuration.ConfigurationException;

import	procure.common.conf.Startup;

/**
 * @author 이종환
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SQLManager{
	private	String				sDataSourceName	=	"";		//DataSource 명
	private	boolean				bContinueConn	=	false;	//Connection 여부
	private	ArrayList			saColNames		=	null;	//	컬럼명
	private	LoggableStatement	ls				=	null;
	
	private	Connection			conn			=	null;
	private	ResultSet			rs				=	null;
	
	/**
	 * SQLManager 생성
	 * @throws ConfigurationException
	 * @throws NamingException
	 * @throws SQLException
	 */
	public SQLManager() throws ConfigurationException, NamingException, SQLException{
		try {
			this.init();

			if(this.conn == null)
			{
				this.conn	=	this.getConnection();
			}else 
			{
				if(this.conn.isClosed())
				{
					this.conn	=	this.getConnection();
				}
			}
		
			
		} catch (ConfigurationException e) {
			this.close();
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());	
		} catch (NamingException e) {
			this.close();  
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
			throw new NamingException("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());	
		} catch (SQLException e) {
			this.close();  
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());	
		}
	}
	
	/**
	 * SQLManager 생성자
	 * @param sDataSourceName	Data Source 명
	 * @throws NamingException
	 * @throws SQLException
	 */
	public SQLManager(String sDataSourceName) throws NamingException, SQLException
	{
		boolean	bConn	=	true;
		try {
			this.sDataSourceName	=	sDataSourceName;
			
			if(this.conn == null)
			{
				bConn	=	false;
			}else
			{
				if(this.conn.isClosed())	bConn	=	false;
			}
			
			if(!bConn)	this.conn				=	this.getConnection();
		} catch (NamingException e) {
			this.close();
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
			throw new NamingException("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
		} catch (SQLException e) {
			this.close();  
			System.out.println("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".SQLManager()] :" + e.toString());
		}
	}
	
	/**
	 * 초기화
	 * @throws ConfigurationException
	 */
	private void init() throws ConfigurationException
	{
		if(this.sDataSourceName == null || this.sDataSourceName.length() < 1)
		{
			//CompositeConfiguration ccf 	= Config.getInstance("conf.xml");
			//this.sDataSourceName		=	ccf.getString("datasource");
			this.sDataSourceName		=	Startup.conf.getString("db.datasource");
		}
	}
	
	/**
	 * Connection 얻기
	 * @return
	 * @throws NamingException 
	 * @throws SQLException 
	 */
	public Connection getConnection() throws NamingException, SQLException
	{
		boolean	bConn	=	true;
		
		try {			
			if(this.conn	== null)
			{
				bConn	=	false;
			}else
			{
				if(this.conn.isClosed())	bConn	=	false;
			}
				
			if(!bConn)
			{
				Context 	ctx = new InitialContext();
				DataSource	ds 	= (DataSource) ctx.lookup(this.sDataSourceName);
				this.conn 		= ds.getConnection();
				
				// 인포믹스 디를 위한 설정
				//this.setLockWait(this.conn);
				//this.conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED); // db lock이 된 commit 되지 않은 데이터도 읽을 수 있음. dirty read (웬만하면 안쓰는게 좋음)
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getConnection()] :" + e.toString());
			throw new NamingException("[ERROR "+this.getClass().getName() + ".getConnection()] :" + e.toString());
		} 
		return	this.conn;
	}
	
	/**
	 * informix 에서 Lock Mode 설정하는 부분
	 * Lock Mode : 다른 사용자에 의해 lock이 걸려있는 데이터에 접근할 때 default로 기다리지 않고 error를 return 한다.
	 * SET LOCK MODE TO WAIT;  (lock이 해제 될 때까지 무한정 기다림)
	 * SET LOCK MODE TO NOT WAIT; (lock이 해제 될 때까지 기다리지 않고 즉시 error를 리턴:  default)
	 * SET LOCK MODE TO WAIT 20;  (lock이 해제 될 때까지 20초 동안 기다림)
	 * 
	 * @param con
	 * @throws Exception
	 */
	private void setLockWait(Connection con) throws Exception
	{
		PreparedStatement ps = null;
		String sql = null;
		
		sql = "SET LOCK MODE TO WAIT 10";

		try
		{
			ps = con.prepareStatement(sql);
			ps.execute();
		}
		catch(Exception e)
		{
			System.out.println("[ERROR "+this.getClass().getName() + ".setLockWait()] :" + e.toString());
		}
		finally
		{
			if(ps != null)
				ps.close();
		}
		
	}
	
	/**
	 * 컬럼명 얻기
	 * @param rs
	 * @return
	 * @throws SQLException
	 */
	private void setColumNames() throws SQLException
	{
		try {
			ResultSetMetaData	rsmd	=	this.ls.getMetaData();
			int					iColCnt	=	rsmd.getColumnCount();
			this.saColNames	=	new	ArrayList();
			for(int i = 0 ; i < iColCnt; i++)
			{
				this.saColNames.add(rsmd.getColumnName(i+1).toString().toUpperCase());
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".setColumNames()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".setColumNames()] :" + e.toString());
		}
	}
	
	/**
	 * Procedure Query 문 생성
	 * @param sProcedureName
	 * @param aData
	 * @return
	 */
	public String getProcedureQuery(String sProcedureName, ArrayList aData){
		String sSql	=	"{call "+sProcedureName+"(";
		for(int i=0; i<aData.size(); i++){
			if(i == aData.size()-1)	sSql	+= 	"?";
			else					sSql	+=	"?,";  
		}
		sSql	=	")}";
		return sSql;
	}
	
	/**
	 * insert query문 만들기
	 * @param sTableName	테이블명
	 * @param hData	HashMap	
	 * @return
	 */
	public String getInsertQuery(String sTableName, HashMap hData){
		String sSql	=	"";
		
		if(sTableName != null && sTableName.length() > 0)
		{
			sSql = "INSERT INTO "+sTableName.toUpperCase()+"(\n";
		}
		
		if(hData != null && hData.size() > 0)
		{	
			Iterator 	iterator 	=	hData.keySet().iterator();
			
			for(int i=0; iterator.hasNext(); i++)
			{
				if(i == 0)	sSql	= 	sSql + "	" + iterator.next().toString().toUpperCase();
				else		sSql	=	sSql + "," + iterator.next().toString().toUpperCase();	
			}
			sSql	=	sSql	+	"\n)VALUES(\n";
			for(int i=0; iterator.hasNext(); i++)
			{
				if(i == 0)	sSql	= 	sSql + "	?";
				else		sSql	=	sSql + ", ?";	
			}
			sSql	=	sSql	+	"\n)";
		}
		return	sSql;
	}
	
	/**
	 * 여러행 반환
	 * @param sSql			쿼리문
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public ResultSetValue getRows(String sSql, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		ResultSetValue	rsv	=	null;
		try {
			rsv	=	new	ResultSetValue();
			
			this.ls	=	new	LoggableStatement(this.conn, sSql);
			this.rs	=	this.ls.executeQuery();

			this.setColumNames();
			
			HashMap		hData		=	null;	//한줄데이타
			ArrayList	aData		=	new	ArrayList();
			String		sColName	=	"";
			
			String		sClobName	=	"";
			
			ResultSetMetaData	rsmd	=	rs.getMetaData();
			for(int i = 1; i <= rsmd.getColumnCount(); i++)
			{
				if(rsmd.getColumnTypeName(i).compareTo("CLOB") == 0)
				{
					sClobName	=	rsmd.getColumnName(i);
				}
			}
			
			while(this.rs.next())
			{
				hData	=	new HashMap();
				for(int i=0; i<this.saColNames.size(); i++)
				{
					sColName	=	this.saColNames.get(i).toString();
					
					//System.out.println("sColName["+sColName+"]");
					
					if(sColName.equals(sClobName))
					{
						//System.out.println("sClobName["+sClobName+"]");
						
						CLOB	clob	=	null;
						
						clob = (oracle.sql.CLOB)rs.getClob(sColName);
						
						if(clob != null)
						{
							Reader is = clob.getCharacterStream();
							StringBuffer sb = new StringBuffer();
							int c	=	0;
							while ((c = is.read()) != -1)
							{
								sb.append((char)c);
							}
							
							hData.put(sColName,sb.toString());
						}else
						{
							hData.put(sColName,"");
						}
					}else
					{
						hData.put(sColName,this.rs.getString(sColName));
					}
				}
				aData.add(hData);
			}
			rsv.getData(aData);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		} catch (IOException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return rsv;
	}
	
	/**
	 * 여러행 반환
	 * @param sSql	쿼리문
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public ResultSetValue getRows(String sSql) throws SQLException, UnsupportedEncodingException
	{
		ResultSetValue	rsv	=	null;
		try {
			rsv	=	this.getRows(sSql,false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getRows()] :" + e.toString());
		} 
		return rsv;
	}
	
	/**
	 * 한줄 데이터 가져오기
	 * @param sSql			쿼리문
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public DataSetValue getOneRow(String sSql, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		DataSetValue	dsv	=	null;
		try {
			dsv	=	new	DataSetValue();
			
			this.ls	=	new	LoggableStatement(this.conn, sSql);
			//this.ls.getQueryString();
			this.rs	=	this.ls.executeQuery();
			this.setColumNames();

			String		sColName	=	"";
			while(this.rs.next()){
				for(int i=0; i<this.saColNames.size(); i++){
					sColName	=	this.saColNames.get(i).toString();
					dsv.put(sColName,StrUtil.ConfCharsetRev(this.rs.getString(sColName))); 
				}
			}

		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRows()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getOneRows()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRows()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getOneRows()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return dsv;
	}
	
	/**
	 * 한줄 데이터 가져오기
	 * @param sSql
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public DataSetValue getOneRow(String sSql) throws SQLException, UnsupportedEncodingException
	{
		DataSetValue	dsv	=	null;
		try {
			dsv	=	this.getOneRow(sSql,false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getOneRow()] :" + e.toString());
		}
		return dsv;
	}
	
	
	/**
	 * 프로시져 실행하기
	 * @param sProcedureName	프로시져명
	 * @param aData				데이타
	 * @param bContinueConn		Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean getProcedure(String sProcedureName, ArrayList aData, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		boolean bSuccess	= 	false;
		try {
			String	sQuery	=	this.getProcedureQuery(sProcedureName,aData);	
			this.ls			=	new	LoggableStatement(this.conn, sQuery);
			
			for(int i=1; i<=aData.size(); i++){
				this.ls.setObject(i, aData.get(i));
			}
			
			this.ls.getQueryString();
			if(this.ls.executeUpdate() != -1)	bSuccess = true;
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		return	bSuccess;
	}
	
	/**
	 * 프로시져 실행하기
	 * @param sProcedureName	프로시져명
	 * @param aData				데이타
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean getProcedure(String sProcedureName, ArrayList aData) throws SQLException, UnsupportedEncodingException
	{
		boolean	bSuccess	=	false;
		try {
			bSuccess	=	this.getProcedure(sProcedureName, aData, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} 
		return bSuccess;
	}
	
	/**
	 * 프로시져 실행 하기
	 * @param sQuery		프로시져 쿼리
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean getProcedure(String sQuery,	boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		boolean bSuccess	= 	false;
		try {
			this.ls	=	new	LoggableStatement(this.conn, sQuery);
			this.ls.getQueryString();
			
			if(this.ls.executeUpdate() != -1)	bSuccess = true;
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return	bSuccess;
	}
	
	/**
	 * 프로시져 실행 하기
	 * @param sQuery	프로시져 쿼리
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean getProcedure(String sQuery) throws SQLException, UnsupportedEncodingException
	{
		boolean bSuccess	= 	false;
		try {
			bSuccess	=	this.getProcedure(sQuery, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getProcedure()] :" + e.toString());
		} 
		return bSuccess;
	}
	
	/**
	 * insert 실행
	 * @param sTableName	테이블명
	 * @param hData			입력값
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean insertData(String sTableName, HashMap hData,	boolean bContinueConn) throws SQLException, UnsupportedEncodingException{ 
		boolean bInsert = 	false;
		
		try {
			String	sQuery	=	this.getInsertQuery(sTableName,hData);
			
			this.ls	=	new	LoggableStatement(this.conn, sQuery);
			
			Iterator	iterator	=	hData.keySet().iterator();
			String		sColName	=	"";
			for(int i=1; iterator.hasNext(); i++)
			{
				sColName	=	iterator.next().toString();
				this.ls.setObject(i, hData.get(sColName));
			}
			
			this.ls.getQueryString();
			
			if(this.ls.executeUpdate() != -1)	bInsert	=	true;
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return bInsert;
	}
	
	/**
	 * insert 실행
	 * @param sTableName	테이블명
	 * @param hData			입력값
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean insertData(String sTableName, HashMap hData) throws SQLException, UnsupportedEncodingException
	{
		boolean bInsert = 	false;
		try {
			bInsert	=	this.insertData(sTableName, hData, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} 
		return bInsert;
	}

	/**
	 * DATA INSERT
	 * @param sSql			쿼리문
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean insertData(String sSql,	boolean bContinueConn) throws SQLException, UnsupportedEncodingException{ 
		boolean bInsert = false;
		try {
			this.ls	=	new	LoggableStatement(this.conn, sSql);
			this.ls.getQueryString();
			
			if(this.ls.executeUpdate() != -1)	bInsert	=	true;
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return bInsert; 
	}
	
	/**
	 * DATA INSERT
	 * @param sSql	쿼리문
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean insertData(String sSql) throws SQLException, UnsupportedEncodingException
	{
		boolean bInsert = false;
		try {
			bInsert	=	this.insertData(sSql, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".insertData()] :" + e.toString());
		} 
		return bInsert;
	}
	
	/**
	 * data update
	 * @param sSql			쿼리문
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean	updateData(String sSql,	boolean bContinueConn) throws SQLException, UnsupportedEncodingException
	{
		boolean	bUpdate	=	false;
		try {
			bUpdate	=	this.insertData(sSql, bContinueConn);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		return bUpdate;
	}
	
	/**
	 * data update
	 * @param sSql
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean	updateData(String sSql) throws SQLException, UnsupportedEncodingException
	{
		boolean	bUpdate	=	false;
		try {
			bUpdate	=	this.updateData(sSql, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".updateData()] :" + e.toString());
		} 
		return bUpdate;
	}
	
	/**
	 * DATA INSERT or UPDATE
	 * @param sSql			쿼리문
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean inUpArrayData(String[] sSql,	boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		boolean bInsert = true;
		try {
			this.conn.setAutoCommit(false);
			
			for(int i=0; i<sSql.length;i++)
			{
				this.ls	=	new	LoggableStatement(this.conn, sSql[i]);
				this.ls.getQueryString();
				
				if(this.ls.executeUpdate() < 0)
				{
					bInsert	=	false;
					break;
				}					
			}
			
			if(bInsert)	this.conn.commit();
			else		this.conn.rollback();
		} catch (SQLException e) {
			this.conn.rollback();
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			this.conn.rollback();
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
				
		return bInsert;
	}
	
	/**
	 * DATA INSERT or UPDATE
	 * @param sSql
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean inUpArrayData(String[] sSql) throws SQLException, UnsupportedEncodingException
	{
		boolean bInsert = true;
		try {
			bInsert	=	this.inUpArrayData(sSql, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} 
		
		return bInsert;
	}
	
	/**
	 * DATA INSERT or UPDATE
	 * @param arrQuery		쿼리문배열
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	public boolean inUpArrayData(ArrayList arrQuery, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		boolean bInsert = true;
		
		try {
			this.conn.setAutoCommit(false);
			
			for(int i=0; i<arrQuery.size(); i++){
				this.ls	=	new	LoggableStatement(this.conn, arrQuery.get(i).toString());
				this.ls.getQueryString();
				
				if(this.ls.executeUpdate() < 0)
				{
					bInsert	=	false;
					break;
				}
			}
			
			if(bInsert)	this.conn.commit();
			else		this.conn.rollback();
		} catch (SQLException e) {
			this.conn.rollback();
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			this.conn.rollback();
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} finally
		{
			this.bContinueConn	=	bContinueConn;
			this.close();
		}
		
		return bInsert; 
	}
	
	/**
	 * DATA INSERT or UPDATE
	 * @param arrQuery
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public boolean inUpArrayData(ArrayList arrQuery) throws SQLException, UnsupportedEncodingException
	{
		boolean bInsert = false;
		try {
			bInsert	=	this.inUpArrayData(arrQuery, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".inUpArrayData()] :" + e.toString());
		} 
		return bInsert;
	}
	
	/**
	 * Max값 가져오기
	 * @param sColum		컬럼명
	 * @param sTable		table명 가져오기
	 * @param sWhere		where 조건절
	 * @param bContinueConn	Connection 끊을지 여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public int getMaxNo(String sColum, String sTable, String sWhere, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		int iMax = 0;									
		
		try {
			String sSql =	"SELECT NVL(MAX("+sColum.toUpperCase()+"),0) MAX\n" +
							"  FROM "+sTable.toUpperCase()+"\n" +
							" WHERE 1 = 1\n" +	sWhere;
			
			DataSetValue dsv = this.getOneRow(sSql,bContinueConn);
			
			if(dsv != null && dsv.size() > 0)
			{
				iMax	=	dsv.getInt("MAX");
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
		} 
		
		return iMax;
	}
	
	/**
	 * Max값 가져오기
	 * @param sColum	컬럼명
	 * @param sTable	table명 가져오기
	 * @param sWhere	where 조건절
	 * @return
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	public int getMaxNo(String sColum, String sTable, String sWhere) throws SQLException, UnsupportedEncodingException
	{
		int iMax = 0;
		try {
			iMax	=	this.getMaxNo(sColum, sTable, sWhere, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getMaxNo()] :" + e.toString());
		} 
		return iMax;
	}
	
	/**
	 * 갯수세기
	 * @param sColum		컬럼명
	 * @param sTable		테이블명
	 * @param sWhere		조건절
	 * @param bContinueConn	Connection 종료여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public int getCount(String sColum, String sTable, String sWhere, boolean bContinueConn) throws SQLException, UnsupportedEncodingException{
		int iCnt = 0;

		try {
			String sSql =	"SELECT COUNT("+sColum.toUpperCase()+") CNT\n" +
							"  FROM "+sTable.toUpperCase()+"\n" +
							" WHERE 1 = 1\n" + sWhere;
			
			DataSetValue dsv = this.getOneRow(sSql,bContinueConn);
			
			if(dsv != null && dsv.size() > 0)
			{
				iCnt	=	dsv.getInt("CNT");
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		} 
		
		return iCnt;
	}
	
	/**
	 * 갯수세기
	 * @param sColum	컬럼명
	 * @param sTable	테이블명
	 * @param sWhere	조건절
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public int getCount(String sColum, String sTable, String sWhere) throws SQLException, UnsupportedEncodingException
	{
		int iCnt = 0;
		try {
			iCnt	=	this.getCount(sColum, sTable, sWhere, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getCount()] :" + e.toString());
		}
		return iCnt;
	}
	
	/**
	 * 다음 순번 구하기
	 * @param sColumn		컬럼명
	 * @param bContinueConn	Connection 종료여부
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public	int	getNextVal(String	sColumn, boolean bContinueConn) throws SQLException, UnsupportedEncodingException
	{
		int iSeq = 0;

		try {
			String sSql =	"SELECT "+sColumn+".NEXTVAL SEQ\n" +
							"  FROM DUAL";
			
			DataSetValue dsv = this.getOneRow(sSql,bContinueConn);
			
			if(dsv != null && dsv.size() > 0)
			{
				iSeq	=	dsv.getInt("SEQ");
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
		} 
		
		return iSeq;
	}
	
	/**
	 * 다음 순번 구하기
	 * @param sColumn
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public	int	getNextVal(String	sColumn) throws SQLException, UnsupportedEncodingException
	{
		int iSeq = 0;
		try {
			iSeq	=	this.getNextVal(sColumn, false);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass().getName() + ".getNextVal()] :" + e.toString());
		}
		return iSeq;
	}
	
	/**
	 * Connection 종료
	 * @param conn	Connection
	 * @throws SQLException 
	 */
	public void close(Connection conn) throws SQLException
	{
		try {
			if(this.rs != null)						this.rs.close();
			if(this.ls != null)						this.ls.close();
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
		} finally
		{
			if(conn != null && !conn.isClosed())	conn.close();
		}
	}
	
	/**
	 * close
	 * @throws SQLException 
	 */
	public void close() throws SQLException
	{
		try {
			if(this.ls != null)		this.ls.close();
			if(this.rs != null)		this.rs.close();
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass().getName() + ".close()] :" + e.toString());
		} finally
		{
			if(!this.bContinueConn)
			{
				if(this.conn != null && !this.conn.isClosed())	this.conn.close();
			}
		}
		
	}
}