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
	 * �ý��� ����� �α�������
	 * @return
	 */
	public RecordSet getSysLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_sys_login_menu", hm);
			
			//��� ����
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
	 * ������� �α����� �޴�����
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
			
			//��� ����
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
	 * ���޻���� �α����� �޴�����
	 * @return
	 */
	public RecordSet getSooLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_soo_login_menu", hm);
			
			//��� ����
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
	 * ������� �α����� �޴�����
	 * @return
	 */
	public RecordSet getNotLoginMenu() 
	{
		RecordSet	rs	=	null;
		
		try {
			QueryManager	qm	=	new	QueryManager("query/MenuManager.xml");
			HashMap			hm	=	new	HashMap();
			
			String	sQuery	=	qm.getSelectQuery("get_not_login_menu", hm); 
			
			//��� ����
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
	 * �������翩�� Ȯ��
	 * @return
	 */
	public boolean isSession()
	{
		return this.isSession("_RS");
	}
	
	/**
	 * session ���翩��
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
	 * session ���� ���
	 * @param sKey
	 * @param oj
	 */
	public void setSession(String sKey, Object oj)
	{
		this.session.setAttribute(sKey, oj);
	}
	
	/**
	 * RecordSet ��ȯ
	 * @param sKey
	 * @return
	 */
	public RecordSet getRecordSet(String sKey)
	{
		return (RecordSet)this.getObject(sKey);
	}
	
	/**
	 * Object ��ü ��ȯ
	 * @param sKey
	 * @return
	 */
	public Object getObject(String sKey)
	{
		return this.session.getAttribute(sKey);
	}
	
	/**
	 * String ��ü ��ȯ
	 * @param sKey
	 * @return
	 */
	public String getString(String sKey)
	{
		return (String)this.getObject(sKey);
	}
	
	/**
	 * �޴����� ��������
	 * @return
	 */
	public RecordSet getMenu() throws Exception
	{		
		if(this.auth.isValid())	//	�α����� ���
		{
			if(this.auth.getString("_USER_ID").equals(Startup.conf.getString("adminid")))	//	�ý��� �������� ���
			{
				if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("SYSTEM_LOGIN"))
				{
					this.setSession("RS", this.getSysLoginMenu());
					this.setSession("LOGIN_STATUS","SYSTEM_LOGIN");
				}
			}else
			{
				if(this.auth.getString("_MEMBER_TYPE").equals("01"))	//	��������� ���
				{
					if(this.getString("LOGIN_STATUS") == null || !this.getString("LOGIN_STATUS").equals("WON_LOGIN"))
					{
						this.setSession("RS", this.getWonLoginMenu());
						this.setSession("LOGIN_STATUS","WON_LOGIN");
					}
				}else	//	���޻������ ���
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
	 * �����޴� ��������
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
							ds.put("href","javascript:alert('�α��� �� �̿� ���� �մϴ�.');");
						}else
						{
							ds.put("href","javascript:alert('�̿������ ���� ����Ͻ� �� �����ϴ�.');");
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
	 * ��������
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
