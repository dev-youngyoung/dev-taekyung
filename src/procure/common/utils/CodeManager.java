package procure.common.utils;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;

import javax.naming.NamingException;

import org.apache.commons.configuration.ConfigurationException;

import procure.common.db.SQLManager;
import procure.common.value.ResultSetValue;

/**
 * Code Table을 Management하는 Class
 * 
 * @author Bryan
 */
public class CodeManager {
	private	ResultSetValue	rsv	=	null;
	
	/**
	 * 코드테이블의 data ResultSetValue에 담기
	 * @param sCcode	대분류 코드
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
	 * 코드테이블의 data ResultSetValue에 담기
	 * @param sCcode	대분류 코드
	 * @param sWhere	추가 조건
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
	 * 코드테이블의 data ResultSetValue에 담기
	 * @param sCcode	대분류 코드
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환
	 * @param sCcode	code값
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환<br>
	 * option Tag 자체를 String 변수에 담아 반환한다.
	 * 
	 * @param cd_div
	 * @param defaultValue	option Tag에 default로 selected될 cd_value 값
	 * @param addSql		cd_div조건 이외에 필요한 조회 조건
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환<br>
	 * option Tag 자체를 String 변수에 담아 반환한다.
	 * 
	 * @param cd_div
	 * @param defaultValue	option Tag에 default로 selected될 cd_value 값
	 * @param all_name		"전체","선택" 등 이름
	 * @param all_value		"전체","선택" 등에 해당하는 값
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환<br>
	 * option Tag 자체를 String 변수에 담아 반환한다.
	 * @param rsv			코드정보
	 * @param defaultValue	selected 할 값
	 * @param all_name		전체, 선택등의 추가 option 명
	 * @param all_value		전체, 선택등의 추가 option 값
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환<br>
	 * option Tag 자체를 String 변수에 담아 반환한다.
	 * @param rsv			코드정보
	 * @param defaultValue	selected 할 값
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
	 * select Tag내에 사용되는 option Tag들을 생성해 반환<br>
	 * option Tag 자체를 String 변수에 담아 반환한다.
	 * @param rsv			코드정보
	 * @param cd_div		code 
	 * @param defaultValue	selected 할 값
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