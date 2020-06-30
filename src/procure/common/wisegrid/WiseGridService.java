package procure.common.wisegrid;

import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.NamingException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nicelib.db.DataSet;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.db.LoggableStatement;
import procure.common.db.SQLManager;
import procure.common.value.DataSetValue;
import procure.common.value.ResultSetValue;

import xlib.cmc.GridData;
import xlib.cmc.GridHeader;
import xlib.cmc.OperateGridData;

public class WiseGridService {
	private HttpServletRequest	request		=	null;	
	private HttpServletResponse response	=	null;
	private	GridData 			gdReq		=	null;
	private	GridData 			gdRes		=	null;
	private	PrintWriter 		out			=	null;
	private	Connection			conn		=	null;
	private	WiseGridManager		wgm			=	null;
	private	String				sMode		=	"";		//	조회 : Q, 처리 : A	
	private	WiseGridDataManager	wgdm		=	null;
	private	boolean				bCommit		=	true;
	private	SQLManager			sqlm		=	null;
	private	ServletOutputStream	sos			=	null;	
	private	HashMap				hm			=	null;
	
	public WiseGridService(HttpServletRequest request, HttpServletResponse response) throws Exception
	{
		try {
			this.request	=	request;
			this.response	=	response;
			this.init();
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".WiseGridService()] :" + e.toString());
		}
	}
	
	private	void init() throws Exception
	{
		try {			
			this.request.setCharacterEncoding("UTF-8");
			this.response.setContentType("text/html; charset=utf-8");
			String	sRawData	=	this.request.getParameter("WISEGRID_DATA");	
			
			System.out.println("sRawData["+sRawData+"]");
			
			this.out	= 	this.response.getWriter();
			this.sos	=	this.response.getOutputStream();
			this.gdReq	= 	OperateGridData.parse(sRawData);
			this.gdRes	=	new	GridData();
			this.wgm	=	new	WiseGridManager(this.gdReq);
			this.sqlm	=	new	SQLManager();
			
			if(this.conn == null || this.conn.isClosed())
			{
				this.conn	=	this.sqlm.getConnection();
				this.conn.setAutoCommit(false);
			}
			
			this.wgdm	=	new	WiseGridDataManager(this.conn);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".init()] :" + e.toString());
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".init()] :" + e.toString());
		}
	}
	
	public DataSetValue	getOneRow(String sQuery) throws UnsupportedEncodingException, SQLException
	{
		DataSetValue	dsv	=	null;
		try {
			dsv =	this.sqlm.getOneRow(sQuery, true);
		} catch (UnsupportedEncodingException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".getOneRow()] :" + e.toString());
		} catch (SQLException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".getOneRow()] :" + e.toString());
		}
		return dsv;
	}
	
	public ResultSetValue	getRows(String sQuery) throws UnsupportedEncodingException, SQLException
	{
		ResultSetValue	rsv	=	null;
		try {
			rsv =	this.sqlm.getRows(sQuery, true);
		} catch (UnsupportedEncodingException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".getRows()] :" + e.toString());
		} catch (SQLException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".getRows()] :" + e.toString());
		}
		return rsv;
	}
	
	public int getCount(String sColum, String sTable, String sWhere) throws UnsupportedEncodingException, SQLException
	{
		int iCnt	=	0;
		try {
			iCnt	=	this.sqlm.getCount(sColum, sTable, sWhere, true);
		} catch (UnsupportedEncodingException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".getCount()] :" + e.toString());
		} catch (SQLException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".getCount()] :" + e.toString());
		}
		return iCnt;
	}	
	
	public void setHiddenvalue(String sKey, String sHiddenVal)
	{
		if(this.hm == null)
		{
			this.hm	=	new	HashMap();
		}
		this.hm.put(sKey, sHiddenVal);
	}
	
	public void setTreeHiddenvalue(String sKey, String sHiddenVal)
	{
		if(this.hm == null)
		{
			this.hm	=	new	HashMap();
		}
		this.hm.put(sKey, "tree:"+sHiddenVal);
	}
	
	public void selectService(String sQuery) throws Exception
	{
		try {
			WiseGridDataManager	wgdm	=	new	WiseGridDataManager(this.conn);
			this.gdRes					=	wgdm.getGridData(this.gdReq,sQuery,this.hm);
			this.gdRes.setStatus("true");
			this.sMode	=	"Q";
		} catch (Exception e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".selectService()] :" + e.toString());
		}
	}
	
	public void selectService(DataSet ds) throws Exception
	{
		try {
			this.gdRes					=	wgdm.getGridData(this.gdReq,ds,this.hm);
			this.gdRes.setStatus("true");
			this.sMode	=	"Q";
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".selectService()] :" + e.toString());
		} 
		
	}
	
	public void selectJoinBidService(String sQuery, String sServiceDiv, String sDepth) throws Exception
	{
		try {
			WiseGridDataManager	wgdm	=	new	WiseGridDataManager(this.conn);
			this.gdRes					=	wgdm.getGridJoinBidData(this.gdReq,sQuery, sServiceDiv, sDepth);
			this.gdRes.setStatus("true");
			this.sMode	=	"Q";
		} catch (Exception e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".selectService()] :" + e.toString());
		}
	}
	
	public void prepare(String sQuery) throws ConfigurationException, NamingException, SQLException, UnsupportedEncodingException
	{
		try {			
			this.wgdm.prepare(sQuery);
		} catch (SQLException e) 
		{
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		} catch (UnsupportedEncodingException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		}
	}
	
	public void	setObject(int iIdx, Object oj) throws SQLException
	{
		try {
			this.wgdm.setObject(iIdx, oj);
		} catch (SQLException e) {
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		}
	}
	
	public int executeUpdate() throws SQLException
	{	
		int	iVal	=	-1;
		try {
			iVal	=	 this.wgdm.executeUpdate();
			this.sMode	=	"A";
		} catch (SQLException e) 
		{		
			this.bCommit	=	false;
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString());
		}
		return iVal;
	}
	
	
	public void	addParam(String sKey, String sVal) throws Exception
	{
		try {
			this.gdRes.addParam(sKey, sVal);
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".addRaram()] :" + e.toString());
		}
	}
	
	public void setMessage(String sMessage)
	{
		this.gdRes.setMessage(sMessage);
	}
	
	public void setStatus(String sStatus)
	{
		this.gdRes.setStatus(sStatus);
	}
	
	public void end() throws Exception
	{
		try {
			if(this.gdRes == null)
			{	
				this.gdRes	=	new	GridData();
			}
		} catch (Exception e) {
			this.gdRes.setMessage(e.toString());
			this.gdRes.setStatus("ERROR");
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".end()] :" + e.toString());
		} finally
		{			
			try {
				if(this.conn != null && !this.conn.isClosed())
				{
					if(this.bCommit)
					{
						this.conn.commit();
						System.out.println("DATA COMMIT !!");
					}else
					{
						this.conn.rollback();
						System.out.println("DATA ROLLBACK !!");
					}

					this.conn.close();
					this.sqlm.close();
				}
				
				if(this.sMode.equals("Q"))	//	조회의 경우
				{
					System.out.println("this.sMode["+this.sMode+"]");
					OperateGridData.write(this.gdRes, this.sos);
				}else	//	처리의 경우 A
				{
					System.out.println("this.sMode["+this.sMode+"]");
					OperateGridData.write(this.gdRes, this.out);
				}				
			} catch (SQLException e) {
				this.gdRes.setMessage(e.toString());
				this.gdRes.setStatus("ERROR");
				e.printStackTrace();
				throw new SQLException("[ERROR "+this.getClass()+".end()] :" + e.toString());
			} catch (Exception e) {
				this.gdRes.setMessage(e.toString());
				this.gdRes.setStatus("ERROR");
				e.printStackTrace();
				throw new Exception("[ERROR "+this.getClass()+".end()] :" + e.toString());
			}
		}
	}
	
	public int getRowCnt()
	{
		return this.wgm.getRowCnt();
	}
	
	public ArrayList getArrKey()
	{
		return this.wgm.getArrKey();
	}
	
	public ResultSetValue getResultSetValue()
	{
		return this.wgm.getResultSetValue();
	}
	
	public String getString(String sKey, int iIdx)
	{		
		return this.wgm.getString(sKey, iIdx);
	}
	
	public long	getLong(String sKey, int iIdx)
	{
		return Long.parseLong(this.getString(sKey, iIdx));
	}
	
	public int	getInt(String sKey, int iIdx)
	{
		return Integer.parseInt(this.getString(sKey, iIdx));
	}
	
	public boolean	chkJobType(String sDiv, int iIdx)
	{
		return this.wgm.chkJobType(sDiv, iIdx);
	}
	
	public void setBCommit(boolean bCommit)
	{
		this.bCommit	=	bCommit;
	}
	
	public void	setErrorMsg(Exception e) throws Exception
	{				
		this.gdRes.setMessage(e.getMessage());
		this.gdRes.setStatus("ERROR");	
		this.bCommit	=	false;
		throw new Exception("[ERROR "+this.getClass()+".setErrorMsg()] :" + e.toString());
	}
	
	public String getParam(String sKey) throws Exception
	{
		String	sVal	=	"";
		try {
			if(this.gdReq.getParam(sKey) != null)
			{
				sVal =	this.gdReq.getParam(sKey);
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".getParam()] :" + e.toString());
		}
		return sVal;
	}
}
