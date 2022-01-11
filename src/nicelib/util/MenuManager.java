package nicelib.util;

import java.util.HashMap;
import javax.servlet.http.HttpSession;

import procure.common.conf.Startup;
import procure.common.value.QueryManager;

import nicelib.db.DataSet;
import nicelib.db.ListManager;
import nicelib.db.RecordSet;

public class MenuManager {
	private	HttpSession	session	=	null;
	private	Auth 		auth	=	null;
	
	public MenuManager(Auth auth)
	{
		this.auth		=	auth;
		this.session	=	this.auth.getRequest().getSession();
	}
	
	/**
	 * 시스템 사용자 로그인정보
	 * @return
	 */
	public RecordSet getSysLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_sys_login_menu", hm);
			
			//목록 생성
			ListManager list = new ListManager();

			//list.setDebug(out);
			list.setListQuery(sQuery);
			rs =	list.getRecordSet();
		} catch (Exception e) {
			// TODO Auto-generated catch block 
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * 원사업자 로그인후 메뉴정보
	 * @return
	 */
	public RecordSet getWonLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			hm.put("MEMBER_NO",		this.auth.getString("_MEMBER_NO"));
			hm.put("PERSON_SEQ", 	this.auth.getString("_PERSON_SEQ"));
			
			String	sQuery	=	qm.getSelectQuery("get_won_login_menu", hm);
			
			//목록 생성
			ListManager list = new ListManager();

			//list.setDebug(out);
			list.setListQuery(sQuery);
			rs =	list.getRecordSet();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * 수급사업자 로그인후 메뉴정보
	 * @return
	 */
	public RecordSet getSooLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_soo_login_menu", hm);
			
			//목록 생성
			ListManager list = new ListManager();

			//list.setDebug(out);
			list.setListQuery(sQuery);
			rs =	list.getRecordSet();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * 원사업자 로그인후 메뉴정보
	 * @return
	 */
	public RecordSet getNotLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_not_login_menu", hm); 
			
			//목록 생성
			ListManager list = new ListManager();

			//list.setDebug(out);
			list.setListQuery(sQuery);
			rs =	list.getRecordSet();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return rs;
	}
	
	/**
	 * 세션존재여부 확인
	 * @return
	 */
	public boolean isSession()
	{
		return this.isSession("_RS");
	}
	
	/**
	 * session 존재여부
	 * @param sKey
	 * @return
	 */
	public boolean isSession(String sKey)
	{
		boolean	bSession	=	true;
		if(this.session == null)
		{
			bSession	=	false;
		}else
		{
			if(this.session.getAttribute(sKey) == null)
			{
				return false;
			}
		}
		return bSession;
	}
	
	/**
	 * session 정보 담기
	 * @param sKey
	 * @param oj
	 */
	public void setSession(String sKey, Object oj)
	{
		this.session.setAttribute(sKey, oj);
	}
	
	/**
	 * RecordSet 반환
	 * @param sKey
	 * @return
	 */
	public RecordSet getRecordSet(String sKey)
	{
		return (RecordSet)this.getObject(sKey);
	}
	
	/**
	 * Object 객체 반환
	 * @param sKey
	 * @return
	 */
	public Object getObject(String sKey)
	{
		return this.session.getAttribute(sKey);
	}
	
	/**
	 * String 객체 변환
	 * @param sKey
	 * @return
	 */
	public String getString(String sKey)
	{
		return (String)this.getObject(sKey);
	}
	
	/**
	 * 메뉴정보 가져오기
	 * @return
	 */
	public RecordSet getMenu() throws Exception
	{		
		if(this.auth.isValid())	//	로그인한 경우
		{
			if(this.auth.getString("_USER_ID").equals(Startup.conf.getString("adminid")))	//	시스템 관리자의 경우
			{
				if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("SYSTEM_LOGIN"))
				{
					this.setSession("RS", this.getSysLoginMenu());
					this.setSession("LOGIN_STATUS","SYSTEM_LOGIN");
				}
			}else
			{
				if(this.auth.getString("_MEMBER_TYPE").equals("01"))	//	원사업자의 경우
				{
					if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("WON_LOGIN"))
					{
						this.setSession("RS", this.getWonLoginMenu());
						this.setSession("LOGIN_STATUS","WON_LOGIN");
					}
				}else	//	수급사업자의 경우
				{	
					if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("SOO_LOGIN"))
					{
						this.setSession("RS", this.getSooLoginMenu());
						this.setSession("LOGIN_STATUS","SOO_LOGIN");
					}
				}
			}
		}else
		{			
			if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("NOT_LOGIN"))
			{
				this.setSession("RS", this.getNotLoginMenu());
				this.setSession("LOGIN_STATUS","NOT_LOGIN");
			}
		}
		
		return this.getRecordSet("RS");
	}
	
	/**
	 * 상위메뉴 가져오기
	 * @return
	 */
	public DataSet getTopMenu() throws Exception
	{
		RecordSet	rs	=	null;
		DataSet		ds	=	null;
		
		rs	=	this.getMenu();
		
		String	sDir	=	"";
		
		if(rs != null && rs.size() > 0)
		{
			ds	=	new	DataSet();
			rs.first();
			while(rs.next())
			{
				if(rs.getString("dir").equals("info"))
				{
					continue;
				}
				
				if(!rs.getString("dir").equals(sDir))
				{
					ds.addRow();
					ds.put("name",rs.getString("l_menu_nm"));
					
					if(rs.getInt("l_adm_cnt") > 0 || rs.getString("dir").equals("center"))
					{
						ds.put("href",rs.getString("src_path"));
					}else
					{
						if(this.getString("LOGIN_STATUS").equals("NOT_LOGIN"))
						{
							ds.put("href","javascript:alert('로그인 후 이용 가능 합니다.');");
						}else
						{
							ds.put("href","javascript:alert('이용권한이 없어 사용하실 수 없습니다.');");
						}
					}
					sDir	=	rs.getString("dir");
				}
			}
		}
		return ds;
	}
	
	public DataSet getLeftMenu(String sDir)  throws Exception
	{
		RecordSet	rs	=	null;
		DataSet		ds	=	null;
		
		rs	=	this.getMenu();
		
		String	sMDivCd	=	"";
		if(rs != null && rs.size() > 0)
		{
			ds	=	new	DataSet();
			rs.first();
			while(rs.next())
			{
				if(rs.getString("dir").equals(sDir))
				{
					if(!rs.getString("m_div_cd").equals(sMDivCd))
					{
						ds.addRow();
						ds.put("title", true);
						ds.put("name",rs.getString("m_menu_nm"));
						ds.put("href","");
						sMDivCd	=	rs.getString("m_div_cd");
					}
					ds.addRow();
					ds.put("title", false);
					ds.put("name",rs.getString("s_menu_nm"));
					ds.put("href",rs.getString("src_path"));
				}
			}
		}
		
		return ds;
	}
	
	/**
	 * 세션종류
	 */
	public void clearManu()
	{
		if(!this.isSession())
		{
			this.session.removeAttribute("RS");
			this.session.removeAttribute("LOGIN_STATUS");
			this.session.setMaxInactiveInterval(0);
			this.session	=	null;
		}
	}
}
