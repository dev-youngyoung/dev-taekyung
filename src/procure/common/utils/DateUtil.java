package procure.common.utils;

import java.io.*;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.TimeZone;
import java.text.*;
import java.sql.*;
import javax.naming.NamingException;
import org.apache.commons.configuration.ConfigurationException;

import procure.common.db.SQLManager;

/**
 * <pre>
 * 
 * 
 *  파일명 : DateUtil
 *  기   능 : 날짜처리 관련 유틸
 *   최초 작성일  : 2000. 06. 08
 *  Comments : 날짜처리 관련 유틸
 *  @version : 1.0
 *  @author      : 박 병 태
 *  수정내역     : 
 * 
 * 
 * </pre>
 */

public class DateUtil {
	private static java.util.Date d1;

	private static long today = new java.util.Date().getTime();

	public static final long ONEDAY = 1000 * 60 * 60 * 24;

	public DateUtil() {
	}

	/** MiliSecond로 환산한 하루 */

	/** 오늘날짜를 YYYY-MM-DD로 돌려준다. */
	public static String getToday() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(new java.util.Date());
		//java.util.Date d1 = new java.util.Date();
		//return (d1.getYear()+1900) + "-" + (sAdd0(d1.getMonth()+1)) + "-" +
		// sAdd0(d1.getDate());
	}
	
	public static String getYear()
	{
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy");
		return formatter.format(new java.util.Date());
	}

	/** 오늘날짜를 YYYY-MM-DD로 돌려준다. */
	public static String getToMonth() {
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMM");
		return formatter.format(new java.util.Date());
		//java.util.Date d1 = new java.util.Date();
		//return (d1.getYear()+1900) + "-" + (sAdd0(d1.getMonth()+1)) + "-" +
		// sAdd0(d1.getDate());
	}

	public static String getCurSysDate(String argForm) throws ConfigurationException, NamingException, SQLException, UnsupportedEncodingException
	{
		String sdate = "";
		SQLManager		sqlm	=	null;
		try {
			String sQuery =	"SELECT TO_CHAR(SYSDATE, '"+argForm+"') CUR_DATE FROM DUAL";
			sqlm	=	new	SQLManager();
			sdate = sqlm.getOneRow(sQuery).getString("CUR_DATE");
		} catch (SQLException e) {
			throw new SQLException("[ERROR DateUtil.getToday()] :" + e.toString());
		} finally{
			//sqlm.close();
		}
		
		return sdate;
	}

	public static String getCurAddMonth(String argForm, String argNum) throws ConfigurationException, NamingException, SQLException, UnsupportedEncodingException
	{
		String sdate = "";
		SQLManager		sqlm	=	null;
		try {
			String sQuery =	"SELECT TO_CHAR(CURRENT + ("+argNum+") units month, '"+argForm+"') CUR_DATE        FROM dual ";
			sqlm	=	new	SQLManager();
			sdate = sqlm.getOneRow(sQuery).getString("CUR_DATE");
		} catch (SQLException e) {
			throw new SQLException("[ERROR DateUtil.getToday()] :" + e.toString());
		} finally{
			//sqlm.close();
		}
		
		return sdate;
	}
	
	public static String getCurDateAdd(String sPattern, int nAddMonth, int nAddDay)
	{
    	GregorianCalendar 	cal = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"));
    	
    	int iYear	=	cal.get(GregorianCalendar.YEAR);
    	int	iMonth	=	cal.get(GregorianCalendar.MONTH);
    	int	iDay	=	cal.get(GregorianCalendar.DAY_OF_MONTH);
    	
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	cal.set(iYear, iMonth, iDay);
    	cal.add(GregorianCalendar.MONTH, nAddMonth);
    	cal.add(GregorianCalendar.DAY_OF_MONTH, nAddDay);
    	return	sdf.format(cal.getTime());
		
	}

	public static String getDateAdd(String sPattern, String orgDate, int nAddYear, int nAddMonth, int nAddDay) throws ParseException
	{
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT+09:00")); 
    	cal.setTime(sdf.parse(orgDate)); 
    	
    	cal.add(Calendar.YEAR, nAddYear);
    	cal.add(Calendar.MONTH, nAddMonth);
    	cal.add(Calendar.DAY_OF_MONTH, nAddDay);
    	
    	return	sdf.format(cal.getTime());
	}	
	
	/**
	 * 	오늘날짜에 대해 년,월,일별 조건을 받아 처리하여 YYYY-MM-DD로 돌려준다. --kyj(2004.02.14) 
	 * @throws SQLException 
	 * @param out
	 * @param stmt
	 * @param type
	 * @param ymd
	 * @param num
	 * @return
	 * @throws SQLException
	 */
	public static String getToday(PrintWriter out, Statement stmt, String type, String ymd, int num) throws SQLException {
		
		String 		sdate 	= "";
		ResultSet 	rs 		= null;
		try {
			
			String 		sql 	= "";
			
			if (type.equals("+")) 
			{
				if (ymd.equals("D")) {
					sql = " select to_char(next_day(getdate()," + num
							+ "),'yyyy-mm-dd') ymd from dual";
				} else if (ymd.equals("M")) {
					sql = " select to_char(add_months(getdate()," + num
							+ "),'yyyy-mm-dd') ymd from dual";
				} else if (ymd.equals("Y")) {
					sql = " select to_char(add_months(getdate()," + (12 * num)
							+ "),'yyyy-mm-dd') ymd from dual";
				}
			} else {
				if (ymd.equals("D")) {
					sql = " select to_char(getdate()-" + num
							+ ",'yyyy-mm-dd') ymd from dual";
				} else if (ymd.equals("M")) {
					sql = " select to_char(add_months(getdate(),-" + num
							+ "),'yyyy-mm-dd') ymd from dual";
				} else if (ymd.equals("Y")) {
					sql = " select to_char(add_months(getdate()," + (12 * num)
							+ "),'yyyy-mm-dd') ymd from dual";
				}
			}
			rs = stmt.executeQuery(sql);
			
			rs.next();
			sdate = rs.getString("ymd");
		} catch (SQLException e) {
			throw new SQLException("[ERROR DateUtil.getToday()] :" + e.toString());
		} finally
		{
			if (rs != null)
			{
				try {
					rs.close();
				} catch (SQLException e) {
					throw new SQLException("[ERROR DateUtil.getToday()] :" + e.toString());
				}
			}
		}
		
		return sdate;
	}

	/** 어떤날짜를 YYYY-MM-DD로 돌려준다. */
	public static String getSomeday(long day) {
		d1 = new java.util.Date(today + day * ONEDAY);
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
		return formatter.format(d1);
		//return (d1.getYear()+1900) + "-" + (sAdd0(d1.getMonth()+1)) + "-" +
		// sAdd0(d1.getDate());
	}

	/** YYYYMMDD를 YYYY-MM-DD로 돌려준다. */
	public static String formatYmd(String str, boolean bEdit) {
		if (str == null) {
			if (bEdit)
				return "";
			else
				return "&nbsp;";
		}
		if (str.length() != 8)
			return str;
		return str.substring(0, 4) + "-" + str.substring(4, 6) + "-"
				+ str.substring(6, 8);
	}

	/** 7월 9일 추가(김경미) */
	/** YYYYMM을 YYYY-MM으로 돌려준다. */
	public static String formatYmm(String str, boolean bEdit) {
		if (str == null) {
			if (bEdit)
				return "";
			else
				return "&nbsp;";
		}
		if (str.length() != 6)
			return str;
		return str.substring(0, 4) + "-" + str.substring(4, 6);
	}

	/** 자바의 디폴트 날짜구분자를 변환 */
	public static String getYymmdd(Date date1) {
		if (date1 == null)
			return "&nbsp;";
		else
			return date1.toString().replace('-', '/');
	}

	/** n->0n */
	public static String sAdd0(int nNum) {
		if (nNum < 10)
			return "0" + nNum;
		else
			return nNum + "";
	}

	/** 다음 순번(10자리)을 구한다.(순번규칙:년도(4)+순번(6)) */
	public static String getSeq10(String str) {
		String sResult = "";
		java.util.Calendar cal = java.util.Calendar.getInstance();
		String sYear = cal.get(java.util.Calendar.YEAR) + "";
		if (str == null)
			sResult = sYear + "000001";
		else {
			sResult = (Integer.parseInt(sYear + str.substring(4, 10)) + 1) + "";
		}
		return sResult;
	}

	/** 날짜 간격구하기. */
	public static long compareDay(String strDate, String strComp) {
		Calendar cal1 = Calendar.getInstance();
		Calendar cal2 = Calendar.getInstance();
		int year = Integer.parseInt(strDate.substring(0, 4));
		int month = Integer.parseInt(strDate.substring(4, 6));
		int day = Integer.parseInt(strDate.substring(6, 8));
		int compYear = Integer.parseInt(strComp.substring(0, 4));
		int compMonth = Integer.parseInt(strComp.substring(4, 6));
		int compDay = Integer.parseInt(strComp.substring(6, 8));
		cal1.set(year, month - 1, day);
		cal2.set(compYear, compMonth - 1, compDay);
		long cal1sec = cal1.getTime().getTime();
		long cal2sec = cal2.getTime().getTime();
		long gap = cal2sec - cal1sec;
		long gapday = (gap / 86400) / 1000;
		return gapday;
	}

	//인사에서 사용한다
	//마지막 날 구하기
	public static int getMonthLastDay(PrintWriter out, int year, int month) {
		int mon = 0;
		mon = month + 1;

		switch (mon) {
		case 1:
		case 3:
		case 5:
		case 7:
		case 8:
		case 10:
		case 12:
			return (31);
		case 4:
		case 6:
		case 9:
		case 11:
			return (30);

		default:
			if (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0))
				return (29); // 2월 윤년계산을 위해서
			else
				return (28);
		}
	}

	/*
	 * 오늘 날짜를 pattern 형식으로 반환 
	 * pattern : yyyyMMdd, yyyy.MM.dd, yyyyMMddHHmmss
	 * @author : 박정출
	 */

	public static String getFormatString(String pattern) {
		SimpleDateFormat dateFormat = new SimpleDateFormat(pattern);

		Calendar calVal = Calendar.getInstance();
		String formStr = dateFormat.format(calVal.getTime());

		return formStr;
	}
	
	/*
	 * 날짜차이를 구한다. (일수)
	 * @author : 박정출
	 */
    public static int getDiffDate(String frDate, String toDate) {
        int f_year  = Integer.parseInt(frDate.substring(0,4));
        int f_month = Integer.parseInt(frDate.substring(4,6));
        int f_day   = Integer.parseInt(frDate.substring(6,8));

        int t_year  = Integer.parseInt(toDate.substring(0,4));
        int t_month = Integer.parseInt(toDate.substring(4,6));
        int t_day   = Integer.parseInt(toDate.substring(6,8));

        Calendar cal1 = Calendar.getInstance();
        cal1.set(f_year, f_month-1, f_day);

        Calendar cal2 = Calendar.getInstance();
        cal2.set(t_year, t_month-1, t_day);

        return (int)Math.floor((Math.abs(cal2.getTime().getTime() - cal1.getTime().getTime())) / (1000*60*60*24));
    }	

	/*
	 * Date 형태로 만들기
	 * @author : 유성훈
	 */   
    public static java.util.Date check(String s, String format) throws java.text.ParseException {
		if ( s == null )
			throw new java.text.ParseException("date string to check is null", 0);
		if ( format == null )
			throw new java.text.ParseException("format string to check date is null", 0);

		java.text.SimpleDateFormat formatter =
            new java.text.SimpleDateFormat (format, java.util.Locale.KOREA);
		java.util.Date date = null;
		try {
			date = formatter.parse(s);
		}
		catch(java.text.ParseException e) {
            throw new java.text.ParseException(" wrong date:\"" + s +
            "\" with format \"" + format + "\"", 0);
		}

		if ( ! formatter.format(date).equals(s) )
			throw new java.text.ParseException(
				"Out of bound date:\"" + s + "\" with format \"" + format + "\"",
				0
			);
        return date;
	}

	/*
	 * 날짜차이를 구한다.(월수)
	 * @author : 유성훈
	 */    
    public static int monthsBetween(String from, String to) throws java.text.ParseException {
        return monthsBetween(from, to, "yyyyMMdd");
    }

    public static int monthsBetween(String from, String to, String format) throws java.text.ParseException {
 		java.text.SimpleDateFormat formatter =
		    new java.text.SimpleDateFormat (format, java.util.Locale.KOREA);
        java.util.Date fromDate = check(from, format);
        java.util.Date toDate = check(to, format);

        // if two date are same, return 0.
        if (fromDate.compareTo(toDate) == 0) return 0;

 		java.text.SimpleDateFormat yearFormat =
		    new java.text.SimpleDateFormat("yyyy", java.util.Locale.KOREA);
 		java.text.SimpleDateFormat monthFormat =
		    new java.text.SimpleDateFormat("MM", java.util.Locale.KOREA);
 		java.text.SimpleDateFormat dayFormat =
		    new java.text.SimpleDateFormat("dd", java.util.Locale.KOREA);

        int fromYear = Integer.parseInt(yearFormat.format(fromDate));
        int toYear = Integer.parseInt(yearFormat.format(toDate));
        int fromMonth = Integer.parseInt(monthFormat.format(fromDate));
        int toMonth = Integer.parseInt(monthFormat.format(toDate));
        int fromDay = Integer.parseInt(dayFormat.format(fromDate));
        int toDay = Integer.parseInt(dayFormat.format(toDate));

        int result = 0;
        result += ((toYear - fromYear) * 12);
        result += (toMonth - fromMonth);

        // ceil과 floor의 효과
        if (((toDay - fromDay) > 0) ) result += toDate.compareTo(fromDate);

        return result;
    }    
    
    /**
     * 다음 달을 yyyymm 포맷으로 반환한다
     * @param ym yyyymm 이상의 데이타
     * @return
     */
    public static String nextMonth(String ym){
    	if(ym == null || ym.length() < 6){
    		System.out.println("날짜 형식이 잘 못 되었습니다");
    		return ym;
    	}
    	
    	ym = ym.substring(0,6);
    	String sYear = ym.substring(0,4);
    	String sMonth = ym.substring(4);
    	
    	if(sMonth.equals("12")){
    		sYear = String.valueOf(Integer.parseInt(sYear) + 1);
    		sMonth = "01";
    	}else if(sMonth.equals("11")){
    		sMonth = "12";
    	}else{
    		int nextMonth = Integer.parseInt(sMonth.substring(1)) + 1;
    		sMonth = "0" + String.valueOf(nextMonth);
    	}
    	
    	return sYear + sMonth;
    }

    /*
	 * 마지막 날짜 구하기
	 * date : 검색년월 (ex : 201011)
	*/
	public static String maxDay(String date){
		GregorianCalendar gc = new GregorianCalendar();
		gc.set(Integer.parseInt(date.substring(0,4)), Integer.parseInt(date.substring(4,6))-1, 1);		
		return date + Integer.toString(gc.getActualMaximum((gc.DAY_OF_MONTH )));
	}    
    
    /**
     * 현년 현월의 1일 구하기
     * @param sPattern	format
     * @return
     */
    public static String getMonthOfFirstDay(String sPattern)
    {
    	GregorianCalendar 	cal = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"));
    	
    	int iYear	=	cal.get(GregorianCalendar.YEAR);
    	int	iMonth	=	cal.get(GregorianCalendar.MONTH);
    	
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	
    	cal.set(iYear, iMonth, 1);
    	return	sdf.format(cal.getTime());
    }

     
    public static String getMonthOfFirstDay(String sPattern, int nAddMonth)
    {
    	GregorianCalendar 	cal = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"));
    	
    	int iYear	=	cal.get(GregorianCalendar.YEAR);
    	int	iMonth	=	cal.get(GregorianCalendar.MONTH);
    	
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	
    	cal.set(iYear, iMonth, 1);
    	cal.add(GregorianCalendar.MONTH, nAddMonth);
    	return	sdf.format(cal.getTime());
    }    
    
    /**
     * 현년 현월의 말일 구하기
     * @param sPattern	format
     * @return
     */
    public static String getMonthOfLastDay(String sPattern)
    {
    	GregorianCalendar 	cal = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"));
    	
    	int iYear	=	cal.get(GregorianCalendar.YEAR);
    	int	iMonth	=	cal.get(GregorianCalendar.MONTH);
    	
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	
    	cal.set(iYear, iMonth+1, 0);
    	return	sdf.format(cal.getTime());
    }

    public static String getMonthOfLastDay(String sPattern, int nAddMonth)
    {
    	GregorianCalendar 	cal = new GregorianCalendar(TimeZone.getTimeZone("GMT+09:00"));
    	
    	int iYear	=	cal.get(GregorianCalendar.YEAR);
    	int	iMonth	=	cal.get(GregorianCalendar.MONTH);
    	
    	SimpleDateFormat 	sdf = new SimpleDateFormat(sPattern); 
    	
    	
    	cal.set(iYear, iMonth+nAddMonth+1, 0);
    	return	sdf.format(cal.getTime());
    }    
    
    /**
     * 오늘날짜 구하기
     * @param sPattern	날짜 패턴
     * @return
     */
    public static String getCurDay(String sPattern)
    {    	
    	SimpleDateFormat sdf = new SimpleDateFormat(sPattern);
	 	Calendar cal =	GregorianCalendar.getInstance(TimeZone.getTimeZone("GMT+09:00"));
	 	
	 	return sdf.format(cal.getTime());
    }
    
    
    public static String getBfDate(String gijun_date, int rng) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        Calendar calVal = Calendar.getInstance();

        if("".equals(gijun_date)) gijun_date = getFormatString("yyyyMMdd");
        calVal.set(Calendar.YEAR, Integer.parseInt(gijun_date.substring(0,4)));
        calVal.set(Calendar.MONTH, (Integer.parseInt(gijun_date.substring(4,6))-1));
        calVal.set(Calendar.DAY_OF_MONTH,Integer.parseInt(gijun_date.substring(6,8)));

        calVal.add(Calendar.DATE, rng);
        String bfday = dateFormat.format(calVal.getTime());
        return bfday;
    }   
    
    /* YYYYMMDD형식의 날짜를 특정 날짜 포맷으로 변환하여 리턴 */
    public static String getFormatDate(String	YYYYMMDD, String	sFormat)
	{
		String	_sYYYYMMDD	=	"";
		try
		{
			int	iYear		=	0;
			int	iMonth	=	0;
			int	iDate		=	0;
		
			if(YYYYMMDD.length() == 8)
			{		
				iYear		=	Integer.parseInt(YYYYMMDD.substring(0,4));
				iMonth	=	Integer.parseInt(YYYYMMDD.substring(4,6));
				iDate		=	Integer.parseInt(YYYYMMDD.substring(6));
				
				java.text.SimpleDateFormat 	_sdf = new java.text.SimpleDateFormat(sFormat);
				
				java.util.Calendar 					_cal = java.util.Calendar.getInstance();
				_cal.set(iYear,iMonth-1,iDate);
				
				_sYYYYMMDD	=	_sdf.format(_cal.getTime());
			}else
			{
				_sYYYYMMDD	=	YYYYMMDD;
			}
		}catch (java.lang.NumberFormatException e)
		{
			e.printStackTrace();
		}finally
		{
			if(_sYYYYMMDD.length() < 1)
			{
				_sYYYYMMDD	=	YYYYMMDD;
			}
			return	_sYYYYMMDD;
		}
	}
    
    public static void main(String[] args) throws Exception{
    	System.out.println(getDateAdd("yyyyMMdd", "20120301", 1, 0, -1));
    }
}