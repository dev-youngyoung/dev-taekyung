package procure.common.wisegrid;

import java.util.ArrayList;
import java.util.HashMap;

import procure.common.value.ResultSetValue;

import xlib.cmc.GridData;
import xlib.cmc.GridHeader;

public class WiseGridManager 
{
	private	int				iRowCnt	=	0;
	private	GridData		gdReq	=	null;
	private	GridHeader[]	aGh		=	null;
	private	ArrayList		aKey	=	null;
	private	ResultSetValue	rData	=	null;
	
	public WiseGridManager(GridData	gdReq)
	{
		try {
			this.gdReq	=	gdReq;
			this.aGh	=	this.gdReq.getHeaders();
			
			/* 키값, row size구하기 */
			for(int i=0; i < this.aGh.length; i++)
			{
				if(i == 0)
				{
					this.aKey		=	new	ArrayList();
					this.iRowCnt	=	this.gdReq.getHeader(aGh[i].getID()).getRowCount();
				}
				this.aKey.add(this.aGh[i].getID());
			}
			
			HashMap		hm	=	null;
			ArrayList	al	=	null;
			if(this.iRowCnt > 0)
			{
				al			=	new	ArrayList();
				this.rData	=	new	ResultSetValue();
				
				String	sKey	=	"";
				String	sVal	=	"";
				for(int i=0; i < this.iRowCnt; i++)
				{
					hm	=	new	HashMap();
					for(int j=0; j < this.aKey.size(); j++)
					{
						sKey	=	this.aKey.get(j).toString();
						sVal	=	this.gdReq.getHeader(sKey).getValue(i);
						
						hm.put(sKey.toUpperCase(), sVal);
					}
					al.add(hm);
				}
			}
			
			if(al != null && al.size() > 0)
			{
				this.rData.getData(al);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public int getRowCnt()
	{
		return this.iRowCnt;
	}
	
	public GridData getGridData()
	{
		return this.gdReq;
	}
	
	public GridHeader[] getGridHeader()
	{
		return this.aGh;
	}
	
	public ArrayList getArrKey()
	{
		return this.aKey;
	}
	
	public ResultSetValue getResultSetValue()
	{
		return this.rData;
	}
	
	public String getString(String sKey, int iIdx)
	{
		String	sVal	=	"";
		try {
			sVal =	this.gdReq.getHeader(sKey).getValue(iIdx);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return sVal;
	}
	
	public boolean	chkJobType(String sDiv, int iIdx)
	{
		boolean	bChk		=	false;
		try {
			String 	sHiddenVal	=	this.gdReq.getHeader("CRUD").getHiddenValue(iIdx);
			
			if(sDiv.equals("INSERT") && sHiddenVal.equals("C"))
			{
				bChk	=	true;
			}else if(sDiv.equals("UPDATE") && sHiddenVal.equals("U"))
			{
				bChk	=	true;
			}else if(sDiv.equals("DELETE") && sHiddenVal.equals("D"))
			{
				bChk	=	true;
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return bChk;
	}
}
