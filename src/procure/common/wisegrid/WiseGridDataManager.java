package procure.common.wisegrid;

import java.io.UnsupportedEncodingException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Set;

import nicelib.db.DataSet;

import procure.common.db.LoggableStatement;
import xlib.cmc.GridData;
import xlib.cmc.GridHeader;
import xlib.cmc.OperateGridData;

public class WiseGridDataManager {
	//private	GridData	gdRes	=	null;
	private	Connection			conn	=	null;
	private	LoggableStatement	ls		=	null;
	
	public WiseGridDataManager(Connection conn)
	{
		this.conn	=	conn;
	} 
	
	public GridData getGridData(GridData gdReq, String sQuery, HashMap	hm) throws Exception
	{
		ResultSet	rs		=	null;
		GridData 	gdRes 	=	new GridData();
		try {
			gdRes = OperateGridData.cloneResponseGridData(gdReq); 
			GridHeader[] agh	=	gdRes.getHeaders();
			
			ArrayList	aGridId	=	new	ArrayList();
			for(int i=0; i < agh.length; i++)
			{	
				aGridId.add(agh[i].getID());
			}
			
			this.ls		=	new	LoggableStatement(this.conn,sQuery);
			
			rs	=	ls.executeQuery();
			
			String	sKey			=	"";
			String	sVal			=	"";
			String	sHdnVal			=	"";
			for(int j=1; rs.next(); j++)
			{
				for(int i=0; i < aGridId.size(); i++)
				{	
					sKey	=	aGridId.get(i).toString();
					if(sKey.toUpperCase().equals("CRUD"))
					{
						sVal	=	"";
					}else
					{
						sVal	=	rs.getString(sKey)==null?"":rs.getString(sKey);
						
						if(hm != null && hm.get(sKey) != null)
						{
							sHdnVal	=	hm.get(sKey).toString().replaceAll("#", j+"");
						}else
						{
							sHdnVal	=	"";
						}
					}
					
					gdRes.getHeader(sKey).addValue(sVal, sHdnVal);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".getGridData()] :" + e.toString());
		} finally
		{
			try {
				if(rs != null)	rs.close();
				if(this.ls != null)	this.ls.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new SQLException("[ERROR "+this.getClass()+".getGridData()] :" + e.toString());
			}
		}
		return gdRes;
	}	
	
	public GridData getGridData(GridData gdReq,DataSet ds, HashMap	hm) throws Exception
	{
		GridData 	gdRes 	=	new GridData();
		try {
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			GridHeader[] agh	=	gdRes.getHeaders();
			ArrayList	aGridId	=	new	ArrayList();
			for(int i=0; i < agh.length; i++)
			{					
				aGridId.add(agh[i].getID());
			}
			
			String		sKey	=	"";
			String		sVal	=	"";
			String		sHdnVal	=	"";
			String		sHmVal	=	"";
			String[]	saHmVal	=	null;	
			for(int j=1; ds.next(); j++)
			{
				for(int i=0; i < aGridId.size(); i++)
				{
					sKey	=	aGridId.get(i).toString();
					
					if(sKey.toUpperCase().equals("CRUD"))
					{
						sVal	=	"";
					}else
					{
						sVal	=	ds.getString(sKey);	
						if(hm != null && hm.get(sKey) != null)
						{
							if(hm.get(sKey).toString().indexOf("tree:") != -1)
							{
								sHmVal	=	hm.get(sKey).toString().replaceAll("tree:", "");
								saHmVal	=	sHmVal.split(",");
								
								sHdnVal	=	"";
								for(int k=0; k < saHmVal.length; k++)
								{
									if(k == 0)	sHdnVal	=	sHdnVal	+	ds.getString(saHmVal[k]).trim();
									else		sHdnVal	=	sHdnVal	+	","	+	ds.getString(saHmVal[k]).trim();
								}
							}else
							{
								sHdnVal	=	hm.get(sKey).toString().replaceAll("#", j+"");
							}
						}else
						{
							sHdnVal	=	"";
						}
					}
					
					if(gdRes.getHeader(sKey).getDataType().equals("I"))	// data type t_imagetext 인 경우
					{						
						gdRes.getHeader(sKey).addValue(sVal, sHdnVal,"");
					}else 
					if(gdRes.getHeader(sKey).getDataType().equals("L")){ // data type t_combo 인 경우
						// 콤보 사용 불가. ㅡㅡ;;;
					}else
					{
						gdRes.getHeader(sKey).addValue(sVal, sHdnVal);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".getGridData()] :" + e.toString());
		}
		return gdRes;
	}
	
	/**
	 * 견적서작성데이타 가져오기
	 * @param gdReq
	 * @param sQuery
	 * @param sServiceDiv
	 * @param sDepth
	 * @return
	 * @throws Exception
	 */
	public GridData getGridJoinBidData(GridData gdReq, String sQuery, String sServiceDiv, String sDepth) throws Exception
	{		
		ResultSet	rs		=	null;
		GridData 	gdRes 	=	new GridData();
		try {
			gdRes = OperateGridData.cloneResponseGridData(gdReq);
			GridHeader[] agh	=	gdRes.getHeaders();
			
			ArrayList	aGridId	=	new	ArrayList();
			for(int i=0; i < agh.length; i++)
			{	
				aGridId.add(agh[i].getID());
			}
			
			this.ls		=	new	LoggableStatement(this.conn,sQuery);
			
			rs	=	ls.executeQuery();
			
			String	sKey			=	"";
			String	sVal			=	"";
			String	sHdnVal			=	"";
			
			System.out.println("sServiceDiv["+sServiceDiv+"]");
			System.out.println("sDepth["+sDepth+"]");
			
			for(int j=1; rs.next(); j++)
			{
				for(int i=0; i < aGridId.size(); i++)
				{	
					sKey	=	aGridId.get(i).toString();
					if(sKey.toUpperCase().equals("CRUD"))
					{
						sVal	=	"";
					}else
					{
						sVal	=	rs.getString(sKey)==null?"":rs.getString(sKey);
					}
					
					if(sKey.toUpperCase().equals("STUFF_SUM"))	//	컬럼명[재료비 금액]
					{
						if(sServiceDiv.equals("O"))	//	업무구분[외주]일 경우
						{
							if(sDepth.equals("01"))	//	DEPTH[2]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((E"+j+" * F"+j+");0)";
							}else if(sDepth.equals("02"))	//	DEPTH[3]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((F"+j+" * G"+j+");0)";
							}else		//	DEPTH[3]일 경우
							{	
								sHdnVal	=	"=ROUNDDOWN((G"+j+" * H"+j+");0)";
							}
						}
					}else if(sKey.toUpperCase().equals("LABOR_SUM"))	//	컬럼명[노무비 금액]
					{
						if(sServiceDiv.equals("O"))	//	업무구분[외주]일 경우
						{
							if(sDepth.equals("01"))	//	DEPTH[2]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((E"+j+" * H"+j+");0)";
							}else if(sDepth.equals("02"))	//	DEPTH[3]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((F"+j+" * I"+j+");0)";
							}else		//	DEPTH[3]일 경우
							{	
								sHdnVal	=	"=ROUNDDOWN((G"+j+" * J"+j+");0)";
							}
						}
					}else if(sKey.toUpperCase().equals("UPKEEP_SUM"))	//	컬럼명[경비 금액]
					{
						if(sServiceDiv.equals("O"))	//	업무구분[외주]일 경우
						{
							if(sDepth.equals("01"))	//	DEPTH[2]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((E"+j+" * J"+j+");0)";
							}else if(sDepth.equals("02"))	//	DEPTH[3]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((F"+j+" * K"+j+");0)";
							}else		//	DEPTH[3]일 경우
							{	
								sHdnVal	=	"=ROUNDDOWN((G"+j+" * L"+j+");0)";
							}
						}
					}else if(sKey.toUpperCase().equals("COST_SUM"))	//	컬럼명[합계]
					{
						if(sServiceDiv.equals("O"))	//	업무구분[외주]일 경우
						{
							if(sDepth.equals("01"))	//	DEPTH[2]일 경우
							{
								sHdnVal	=	"=(G"+j+" + I"+j+" + K"+j+")";
							}else if(sDepth.equals("02"))	//	DEPTH[3]일 경우
							{
								sHdnVal	=	"=(H"+j+" + J"+j+" + L"+j+")";
							}else		//	DEPTH[3]일 경우
							{	
								sHdnVal	=	"=(I"+j+" + K"+j+" + M"+j+")";
							}
						}else
						{
							if(sDepth.equals("01"))	//	DEPTH[2]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((E"+j+" * F"+j+");0)";
							}else if(sDepth.equals("02"))	//	DEPTH[3]일 경우
							{
								sHdnVal	=	"=ROUNDDOWN((F"+j+" * G"+j+");0)";
							}else		//	DEPTH[3]일 경우
							{	
								sHdnVal	=	"=ROUNDDOWN((G"+j+" * H"+j+");0)";
							}
						}
					}else
					{
						sHdnVal	=	"";
					}	
					gdRes.getHeader(sKey).addValue(sVal, sHdnVal); 
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			throw new Exception("[ERROR "+this.getClass()+".getGridData()] :" + e.toString());
		} finally
		{
			try {
				if(rs != null)	rs.close();
				if(this.ls != null)	this.ls.close();
			} catch (SQLException e) {
				e.printStackTrace();
				throw new SQLException("[ERROR "+this.getClass()+".getGridData()] :" + e.toString());
			}
		}
		return gdRes;
	}
	
	public void prepare(String sQuery) throws UnsupportedEncodingException, SQLException
	{
		try {
			if(this.ls == null)
			{
				this.ls		=	new	LoggableStatement(this.conn,sQuery);
			}else
			{
				this.ls.prepare(this.conn, sQuery);
			}
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		} catch (SQLException e) {
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		}
	}
	
	public void	setObject(int iIdx, Object oj) throws SQLException
	{
		try {
			this.ls.setObject(iIdx, oj);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		}
	}
	
	public int executeUpdate() throws SQLException
	{
		int iVal	=	0;
		try {
			iVal =	this.ls.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString());
		}
		return iVal;
	}
}
