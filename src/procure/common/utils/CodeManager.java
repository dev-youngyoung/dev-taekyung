package procure.common.utils;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.db.SQLManager;
import procure.common.value.ResultSetValue;

/**
 * Code Table�� Management�ϴ� Class
 * 
 * @author Bryan
 */
public class CodeManager {
	private	ResultSetValue	rsv	=	null;
	
	/**
	 * �ڵ����̺��� data ResultSetValue�� ���
	 * @param sCcode	��з� �ڵ�
	 * @return
	 * @throws Exception
	 */
	public ResultSetValue getList(String sCcode) throws Exception{
		ResultSetValue	rsv	=	null;
		try {
			String sQuery =	"SELECT CODE, CNAME\n" +
							"  FROM TCM_COMCODE\n" +
							" WHERE CCODE = '"+sCcode+"'\n" +
							"	AND CODE <> '00'\n" +
							"	AND USE_YN = 'Y'\n" +
							" ORDER BY SORT";
			SQLManager	sqlm	=	new	SQLManager();
			rsv	=	sqlm.getRows(sQuery);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (NamingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		}
		return rsv;
	}

	/**
	 * �ڵ����̺��� data ResultSetValue�� ���
	 * @param sCcode	��з� �ڵ�
	 * @param sWhere	�߰� ����
	 * @return
	 * @throws Exception
	 */
	public ResultSetValue getList(String sCcode, String sWhere) throws Exception{
		ResultSetValue	rsv	=	null;
		try {
			String sQuery =	"SELECT CODE, CNAME\n" +
							"  FROM TCM_COMCODE\n" +
							" WHERE CCODE = '"+sCcode+"'\n" +
							"	AND CODE <> '00'\n" +
							"	AND USE_YN = 'Y'\n" +
							"	AND " + sWhere +
							" ORDER BY SORT";
			SQLManager	sqlm	=	new	SQLManager();
			rsv	=	sqlm.getRows(sQuery);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (NamingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getList()] " + e.toString());
		}
		return rsv;
	}
	
	/**
	 * �ڵ����̺��� data ResultSetValue�� ���
	 * @param sCcode	��з� �ڵ�
	 * @return
	 * @throws Exception
	 */
	public ResultSetValue getExtendList(String sCcode, String sWhere) throws Exception{
		ResultSetValue	rsv	=	null;
		try {
			String sQuery =	"SELECT CODE, CNAME||' ['||ETC1||']' CNAME\n" +
							"  FROM TCM_COMCODE\n" +
							" WHERE CCODE = '"+sCcode+"'\n" +
							"	AND CODE <> '00'\n" +
							"	AND USE_YN = 'Y'\n" +
							"	AND " + sWhere +
							" ORDER BY SORT";
			SQLManager	sqlm	=	new	SQLManager();
			rsv	=	sqlm.getRows(sQuery);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getExtendList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getExtendList()] " + e.toString());
		} catch (NamingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getExtendList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getExtendList()] " + e.toString());
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getExtendList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getExtendList()] " + e.toString());
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getExtendList()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getExtendList()] " + e.toString());
		}
		return rsv;
	}

	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ
	 * @param sCcode	code��
	 * @return
	 * @throws Exception
	 */
	public String	getSelectTag(String sCcode) throws Exception
	{
		try {
			return this.getSelectTag(sCcode, "");
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}
	}

	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ<br>
	 * option Tag ��ü�� String ������ ��� ��ȯ�Ѵ�.
	 * 
	 * @param cd_div
	 * @param defaultValue	option Tag�� default�� selected�� cd_value ��
	 * @param addSql		cd_div���� �̿ܿ� �ʿ��� ��ȸ ����
	 * @return				option Tag String
	 * @throws Exception  
	 */
	public String getSelectTag(String cd_div, String defaultValue) throws Exception{
		String	sOption	=	"";
		try {
			sOption =	this.getSelectTag(cd_div, defaultValue, "", "");
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}
		return sOption;
	}
	
	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ<br>
	 * option Tag ��ü�� String ������ ��� ��ȯ�Ѵ�.
	 * 
	 * @param cd_div
	 * @param defaultValue	option Tag�� default�� selected�� cd_value ��
	 * @param all_name		"��ü","����" �� �̸�
	 * @param all_value		"��ü","����" � �ش��ϴ� ��
	 * @return				option Tag String
	 * @throws Exception 
	 */
	public String getSelectTag(String cd_div, String defaultValue, String all_name, String all_value) throws Exception{
		String retval = "";
		
		try {
			if(defaultValue == null) 	defaultValue 	= "";
			if(defaultValue == null) 	defaultValue 	= "";
			if(all_name 	== null)	all_name 		= "";
			if(all_value 	== null) 	all_value 		= "";

			String selected = "";
			
			if(all_name != null && all_name.length() > 0)
			{
				if(defaultValue.equals(all_value)) 	selected = " selected ";
				else								selected = "";
				retval += "<option value='" + all_value + "'" + selected + ">";
				retval += all_name + "</option>\n";
			}
			
			ResultSetValue	rsv	=	this.getList(cd_div);
			while(rsv.next())
			{
				if(defaultValue.equals(rsv.getString("CODE"))) 	selected 	= " selected ";
				else											selected	=	"";
				
				retval += "<option value='" + rsv.getString("CODE") + "'" + selected + ">";
				retval += rsv.getString("CNAME") + "</option>\n";
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}
		
		return retval;
	}
	
	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ<br>
	 * option Tag ��ü�� String ������ ��� ��ȯ�Ѵ�.
	 * @param rsv			�ڵ�����
	 * @param defaultValue	selected �� ��
	 * @param all_name		��ü, ���õ��� �߰� option ��
	 * @param all_value		��ü, ���õ��� �߰� option ��
	 * @return
	 * @throws Exception
	 */
	public String getSelectTag(ResultSetValue	rsv, String defaultValue, String all_name, String all_value) throws Exception
	{
		String	retval	=	"";
		try {
			if(defaultValue == null) 	defaultValue 	= "";
			if(defaultValue == null) 	defaultValue 	= "";
			if(all_name 	== null)	all_name 		= "";
			if(all_value 	== null) 	all_value 		= "";

			String selected = "";
				
			if(all_name != null && all_name.length() > 0)
			{
				if(defaultValue.equals(all_value)) 	selected = " selected ";
				else								selected = "";
				retval += "<option value='" + all_value + "'" + selected + ">";
				retval += all_name + "</option>\n";
			}
			
			rsv.first();
			while(rsv.next())
			{
				if(defaultValue.equals(rsv.getString("CODE"))) 	selected = " selected ";
				else											selected = "";
				retval += "<option value='" + rsv.getString("CODE") + "'" + selected + ">";
				retval += rsv.getString("CNAME") + "</option>\n";
			}
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}	
		return retval;
	}	
	
	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ<br>
	 * option Tag ��ü�� String ������ ��� ��ȯ�Ѵ�.
	 * @param rsv			�ڵ�����
	 * @param defaultValue	selected �� ��
	 * @return
	 * @throws Exception
	 */
	public String getSelectTag(ResultSetValue	rsv, String defaultValue) throws Exception
	{
		String	sOption	=	"";
		try {
			sOption	=	this.getSelectTag(rsv, defaultValue, "", "");
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}
		return	sOption;
	}
	
	/**
	 * select Tag���� ���Ǵ� option Tag���� ������ ��ȯ<br>
	 * option Tag ��ü�� String ������ ��� ��ȯ�Ѵ�.
	 * @param rsv			�ڵ�����
	 * @param cd_div		code 
	 * @param defaultValue	selected �� ��
	 * @return
	 * @throws Exception
	 */
	public String getSelectTag(ResultSetValue	rsv) throws Exception
	{
		String	sOption	=	"";
		try {
			sOption	=	this.getSelectTag(rsv, "", "", "");
		} catch (Exception e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".getSelectTag()] :" + e.toString());
			throw new Exception("[ERROR "+this.getClass().toString()+".getSelectTag()] " + e.toString());
		}
		return	sOption;
	}
}