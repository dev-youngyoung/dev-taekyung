package nicelib.db;

import java.util.Date;
import java.util.Random;
import java.sql.ResultSet;
import java.util.Enumeration;
import java.util.Hashtable;
import javax.servlet.jsp.JspWriter;

import nicelib.db.RecordSet;
import nicelib.db.DB;
import nicelib.util.*;

public class DataObject {

	public int limit = 1000;
	public String PK = "id";
	public String dbType = "oracle";
	public String fields = "*";
	public String table = "";
	public String using_table  = "";
	public String join = "";
	public String jndi = Config.getJndi();
	private String delimiter = Config.getQueryDelimiter();
	public String sql = "";
	public String id = "-1";
	public Hashtable record = new Hashtable();
	public String errMsg = null;
	private JspWriter out = null;
	private boolean debug = false;

	public DataObject() {
		
	}

	public DataObject(String table) {
		this.table = table;
	}
	
	public DataObject(String table, String using_table) {
		this.table = table;
		this.using_table = using_table;
	}

	public void setDebug(JspWriter out) {
		debug = true;
		this.out = out;
	}

	public void setFields(String f) {
		this.fields = f;
	}

	public void setTable(String tb) {
		this.table = tb;
	}

	public void setError(String msg) throws Exception {
		this.errMsg = msg;
		if(this.debug == true && this.out != null) {
			out.print("<hr>" + msg + "<hr>");
		}
	}

	public void addJoin(String tb, String type, String cond) {
		this.join += " " + type + " JOIN " + tb + " ON " + cond;
	}

	public void setLimit(int limit) {
		this.limit = limit;
	}
	
	public void item(String name, Object obj) {
		if(obj instanceof Date) {
			record.put(name, new java.sql.Timestamp(((Date)obj).getTime()));
	    } else {
			record.put(name, obj);
		}
	}

	public void item(String name, int obj) {
		record.put(name, new Integer(obj));
	}

	public void item(String name, long obj) {
		record.put(name, new Long(obj));
	}

	public void item(String name, double obj) {
		record.put(name, new Double(obj));
	}

	public void item(Hashtable obj) {
		this.item(obj, "");
	}

	public void item(Hashtable obj, String exceptions) {
		Enumeration e = obj.keys();
		String[] arr = exceptions.split(",");
		while(e.hasMoreElements()) {
			String key = ((String)e.nextElement()).trim();
			if(Util.inArray(key, arr)) continue;
			this.item(key, null != obj.get(key) ? obj.get(key) : "");
		}
	}

	public void clear() {
		record.clear();
	}

	public RecordSet get(int i) {
		this.id = "" + i;
		return find(this.PK + " = " + i);
	}

	public RecordSet get(String id) {
		this.id = id;
		return find(this.PK + " = '" + id + "'");
	}

	public int getOneInt(String query) {
		String str = getOne(query);
		if(str.matches("^[0-9]+$")) {
			return Integer.parseInt(str);
		}
		return 0;
	}

	public String getOne(String query) {
		DataSet info = this.selectLimit(query, 1);
		if(info.next()) {
			Enumeration e = info.getRow().keys();
			while(e.hasMoreElements()) {
				String key = (String)e.nextElement();
				if(key.length() > 0 && "_".equals(key.substring(0, 1))) continue;
				return info.getString(key);
			}
		}
		return "";
	}

	public RecordSet find(String where) {
		return find(where, this.fields, null);
	}

	public RecordSet find(String where, String fields) {
		return find(where, fields, null);
	}

	public RecordSet find(String where, String fields, int limit) {
		return find(where, fields, null, limit);
	}

	public RecordSet find(String where, String fields, String sort) {
		String sql = "SELECT " + fields + " FROM " + this.table + this.join;
		if(where != null && !"".equals(where)) sql = sql + " WHERE " + where;
		if(sort != null && !"".equals(sort)) sql = sql + " ORDER BY " + sort;
		return query(sql);
	}
	
	public RecordSet find(String where, String fields, String sort, int limit) {
		String sql = "SELECT " + fields + " FROM " + this.table + this.join;
		if(where != null && !"".equals(where)) sql = sql + " WHERE " + where;
		if(sort != null && !"".equals(sort)) sql = sql + " ORDER BY " + sort;
		return selectLimit(sql, limit);
	}

    public String getDBType() {
        DB db = null;
        try {
            db = new DB(this.jndi);
            return db.getDBType();
        } catch(Exception e) {
            this.errMsg = db.errMsg;
        }       
        return this.dbType;
    }

	public RecordSet selectLimit(String sql, int limit) {
		RecordSet rs = null;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			rs = db.selectLimit(sql, limit);
			if(rs == null) this.errMsg = db.errMsg;
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}
		return rs;
	}
	public RecordSet selectRandom(String sql, int limit) throws Exception {
		RecordSet rs = null;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			rs = db.selectRandom(sql, limit);
			if(rs == null) this.errMsg = db.errMsg;
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}
		return rs;
	}
	
	public int findCount(String where) {
		RecordSet rs = find(where, " COUNT(*) AS count ");
		if(rs == null || !rs.next()) {
			return 0;
		} else {
			return rs.getInt("count");
		}
	}

	public boolean insert() {
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();
		StringBuffer values = new StringBuffer();

		sb.append("INSERT INTO " + this.table + " (");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			sb.append(key);
			values.append(delimiter + key + delimiter);
			if(k < (max - 1)) {
				sb.append(",");
				values.append(",");
			}
		}
		sb.append(") VALUES (");
		sb.append(values);
		sb.append(")");
		String sql = sb.toString();

		int ret = execute(sql, record);
		return ret > 0 ? true : false;
	}

	public boolean update() {
		return update(this.PK + " = '" + id + "'");
	}

	public boolean update(String where) {
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();

		sb.append("UPDATE " + this.table + " SET ");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			//sb.append(key + "= ?");
			sb.append(key + " = " + delimiter + key + delimiter );
			if(k < (max - 1)) sb.append(",");
		}
		sb.append(" WHERE " + where);
		String sql = sb.toString();

		int ret = execute(sql, record);
		return ret > -1 ? true : false;
	}

	public boolean delete() {
		return delete(this.PK + " = '" + this.id + "'");
	}

	public boolean delete(int id) {
		return delete(this.PK + " = " + id);
	}

	public boolean delete(String where) {
		String sql = "DELETE FROM " + this.table + " WHERE " + where;

		int ret = execute(sql);
		return ret > -1 ? true : false;
	}
	
	public boolean deleteAll() {
		String sql = "DELETE FROM " + this.table;

		int ret = execute(sql);
		return ret > -1 ? true : false;
	}

	public int getInsertId() {
		RecordSet rs = query("SELECT MAX("+ this.PK +") AS id FROM "+ table);
		if(rs != null && rs.next()) return rs.getInt("id");
		else return 0;
	}

	public int getSequence() {
		RecordSet rs = query("SELECT seq FROM tb_sequence WHERE id = '"+ table + "'");
		if(rs != null && rs.next()) {
			execute("UPDATE tb_sequence SET seq = seq + 1 WHERE id = '"+ table + "'");
			return rs.getInt("seq");
		}
		else return 1;
	}

	public RecordSet getListData(String where, String orderby, int pageSize, int cPage) {
		orderby = orderby.toLowerCase();
		if(pageSize < 1) pageSize = 10;
		if(cPage < 1) cPage = 1;
		
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * FROM (");
		sb.append(" SELECT TOP " + pageSize + " * FROM (");
		sb.append(" SELECT TOP " + (pageSize * cPage) + " " + this.fields);
		sb.append(" FROM " + this.table); 
		sb.append(" WHERE " + where); 
		sb.append(" ORDER BY " + orderby + ") AS A"); 
		sb.append(" ORDER BY " + orderby.replaceAll("asc", "DESC").replaceAll("desc", "ASC") + ") AS B");
		sb.append(" ORDER BY " + orderby);
		sql = sb.toString();

		return query(sql);
	}

	public RecordSet query(String sql) {
		RecordSet rs = null;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			rs = db.query(sql);
			if(rs == null) this.errMsg = db.errMsg;
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}
		return rs;
	}
	
	public RecordSet query(String sql, Hashtable record) {
		RecordSet rs = null;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			rs = db.query(sql, record);
			if(rs == null) this.errMsg = db.errMsg;
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}
		return rs;
	}

	public RecordSet query(String sql, int limit) {
		return this.selectLimit(sql, limit);
	}

	public int execute(String sql) {
		int ret = -1;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			ret = db.execute(sql);
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}
		return ret;
	}
	
	public int execute(String sql, Hashtable record) {
		int ret = 0;
		DB db = null;
		try {
			long stime = System.currentTimeMillis();

			db = new DB(this.jndi);
			if(debug == true) db.setDebug(out);
			ret = db.execute(sql, record);
			if(ret == -1) this.errMsg = db.errMsg;
			db.close();

			long etime = System.currentTimeMillis();
			if(debug == true) {
				out.print("<hr>Execution Time : " + (etime - stime) + " (1/1000 sec)<hr>");
			}
		} catch(Exception e) {
			this.errMsg = db.errMsg;
		} finally {
			if(db != null) db.close();
		}		
		return ret;
	}

	public String getErrMsg() {
		return this.errMsg;
	}

	public long getNextId() {
		return System.currentTimeMillis() * 1000 + (new Random()).nextInt(999);		
	}

	public String getNextId(String prefix) {
		return prefix + getNextId();
	}
	
	public String getInsertQuery(){
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();
		StringBuffer values = new StringBuffer();

		sb.append("INSERT INTO " + this.table + " (");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			sb.append(key);
			values.append(delimiter + key + delimiter);
			if(k < (max - 1)) {
				sb.append(",");
				values.append(",");
			}
		}
		sb.append(") VALUES (");
		sb.append(values);
		sb.append(")");
		String sql = sb.toString();
		return sql;
	}
	
	public String getUpdateQuery(String where){
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();

		sb.append("UPDATE " + this.table + " SET ");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			//sb.append(key + "= ?");
			sb.append(key + " = " + delimiter + key + delimiter );
			if(k < (max - 1)) sb.append(",");
		}
		sb.append(" WHERE " + where);
		String sql = sb.toString();
		return sql;
	}
	
	public String getDeleteQuery(String where){
		String sql = "DELETE FROM " + this.table + " WHERE " + where;
		return sql;
	}
	
	public boolean merge(String matchQ, String notMatchQ, String onStr){
		boolean result = false;
		StringBuffer sb = new StringBuffer();
		
		sb.append("MERGE INTO " + this.table );
		sb.append(" USING " + this.using_table);
		sb.append(" ON ( ");
		sb.append(onStr);
		sb.append(" )");
		sb.append(" WHEN MATCHED THEN ");
		// MATCHED Query
		sb.append(matchQ);
		sb.append(" WHEN NOT MATCHED THEN ");
		// NOT MATCHED Query
		sb.append(notMatchQ);
		
		int ret = execute(sb.toString());
		if(ret>0){
			result = true;
		}
		
		System.out.println("##########"+ret);
		return result;
	}
	
	public String getMergeUpdateQuery(){
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();
		
		sb.append("UPDATE SET ");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			sb.append(key + " = " + record.get(key) );
			if(k < (max - 1)) sb.append(",");
		}
		String sql = sb.toString();
		return sql;
	}
	
	public String getMergeInsertQuery(){
		int max = record.size();
		Enumeration keys = record.keys();
		StringBuffer sb = new StringBuffer();
		StringBuffer values = new StringBuffer();
	
		sb.append("INSERT (");
		for(int k=0; keys.hasMoreElements(); k++) {
			String key = (String)keys.nextElement();
			sb.append(key);
			values.append(record.get(key));
			if(k < (max - 1)) {
				sb.append(",");
				values.append(",");
			}
		}
		sb.append(") VALUES (");
		sb.append(values);
		sb.append(")");
		String sql = sb.toString();
		return sql;
	}
}
