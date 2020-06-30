package dao;

import nicelib.util.*;
import nicelib.db.*;

import java.util.*;

public class CodeDaoApt extends DataObject {

	
	public CodeDaoApt() {
		//this.table = "tcm_comcode";
		this.table = "tca_comcode";
	}
	
	public String[] getCodeArray(String ccode) {
		return getCodeArray(ccode, "");
	}
	
	public String[] getCodeArray(String ccode, String where) {
		DataSet rs = find("code<>'00' and ccode = '" + ccode + "' " +where, "*", "sort ASC");
		int cnt = rs.size();
		if(cnt > 0) {
			String[] arr = new String[cnt];
			int i = 0;
			while(rs.next()) {
				arr[i] = rs.getString("code") + "=>" + rs.getString("cname");
				i++;
			}
			return arr;
		}
		return new String[0];
	}

	public RecordSet getCodes(String ccode) {
		return find("ccode = '" + ccode + "'", "*", "sort ASC");
	}

	public int getWeekNum(String date, String format) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(Util.strToDate(format, date));
		return calendar.get(calendar.DAY_OF_WEEK);
	}

	public int getWeekNum(String date) {
		return getWeekNum(date, "yyyyMMdd");
	}

	public Date getWeekFirstDate(String date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(Util.strToDate("yyyyMMdd", date));
		return Util.addDate("D", -1 * calendar.get(calendar.DAY_OF_WEEK) + 1, calendar.getTime());
	}
	public Date getWeekLastDate(String date) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(Util.strToDate("yyyyMMdd", date));
		return Util.addDate("D", 7 - calendar.get(calendar.DAY_OF_WEEK), calendar.getTime());
	}
	
	
	public Date getMonthLastDate(String date){
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(Util.strToDate("yyyyMMdd", date));
		int lastDay = calendar.getActualMaximum(calendar.DATE);
		return Util.strToDate(Util.getTimeString("yyyyMM", date)+lastDay) ; 
	}
	
	public DataSet getMonthDays(String date) {
		return getMonthDays(date, "yyyy-MM-dd");
	}
	
	public DataSet getMonthDays(String date, String format) {
		int month = Integer.parseInt(Util.getTimeString("MM", date));
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(Util.strToDate(format, date));
		Date startDate = Util.addDate("D", -1, getWeekFirstDate(Util.getTimeString("yyyyMM", date) + "01"));
		Date endDate = getWeekLastDate(Util.getTimeString("yyyyMM", date) + calendar.getActualMaximum(calendar.DAY_OF_MONTH));

		DataSet list = new DataSet(); int d = 0;
		while(true) {
			startDate = Util.addDate("D", 1, startDate);
			list.addRow();
			list.put("date", Util.getTimeString(format, startDate));
			if(Integer.parseInt(Util.getTimeString("MM", startDate)) < month) list.put("type", "1");
			if(Integer.parseInt(Util.getTimeString("MM", startDate)) == month) list.put("type", "2");
			if(Integer.parseInt(Util.getTimeString("MM", startDate)) > month) list.put("type", "3");
			list.put("weekday", (d % 7) + 1);
			list.put("newline", list.getInt("weekday") == 7);
			list.put("__last", false);
			d++;

			if(Util.getTimeString(format, startDate).equals(Util.getTimeString(format, endDate))) break;
		}
		list.put("__last", true);
		list.first();
		return list;
	}


}