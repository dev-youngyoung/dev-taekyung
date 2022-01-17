package nicelib.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.StringTokenizer;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.jsp.JspWriter;
import javax.sql.DataSource;

import nicelib.util.Config;

import com.ibatis.sqlmap.client.SqlMapException;

public class DB {

	private static final int DEFAULT_TIMEOUT = 1000;
	private static Hashtable dsTable = new Hashtable();
	private static Hashtable dbTypes = new Hashtable();

	private Connection _conn = null;
	private Statement _stmt = null;
	private PreparedStatement _pstmt = null;

	private JspWriter out = null;
	private boolean debug = false;
	private boolean queryPrient = true;

	private String jndi = Config.getJndi();
	private String was = Config.getWas();
	private String delimiter = Config.getQueryDelimiter();
	private String queryFormat = Config.getQueryFormat();
	
	
	public String errMsg = null;
	public String query = null;
	
	public ArrayList arrQuery = null;
	public ArrayList arrRecord = null;

	public DB() {

	}

	public DB(String jndi) {
		this.jndi = jndi;
	}

	public void setDebug(JspWriter out) {
		this.debug = true;
		this.out = out;
	}

	public void setError(String msg) {
		this.errMsg = msg;
		if(debug == true && out != null) {
			try {
				out.println("<hr>" + msg + "<hr>");
			} catch(Exception e) {}
		}
	}

	public String getQuery() {
		return this.query;
	}

	public String getError() {
		return this.errMsg;
	}

	public static DataSource getDataSource(String jndi) {
		return (DataSource)dsTable.get(jndi);
	}

	public Connection getConnection() throws Exception {
		if(dsTable == null) {
			dsTable = new Hashtable();
		}

		Connection conn = null;
		DataSource ds = (DataSource)dsTable.get(jndi);
		if(ds == null) {
			Context ctx = null;
			try {
				ctx = new InitialContext();

				if("resin".equals(was) || "tomcat".equals(was)) {
					
					ctx  = (Context)ctx.lookup("java:/comp/env");
					ds = (DataSource)ctx.lookup("jdbc/econt");
					
//					ds = (DataSource)ctx.lookup("java:comp/env/" + jndi);
//					ds = (DataSource)ctx.lookup(jndi);
				} else {
					ds = (DataSource)ctx.lookup(jndi);
				}
				conn = ds.getConnection();
				dsTable.put(jndi, ds);

				return conn;
			} catch(Exception e) {
				setError(e.getMessage());
			} finally {
				if(ctx != null) try { ctx.close(); } catch(Exception e) {}
			}
		} else {
			try {
				conn = ds.getConnection();
			} catch(Exception e) {
				setError(e.getMessage());
			}
		}
		return conn;
	}
	
	
	public String getDBType() throws Exception {
		String dbType = (String)dbTypes.get(this.jndi);
		if(dbType == null) {
			Connection conn = this.getConnection();
			try {
				String connURL = conn.getMetaData().getURL();
				if(connURL.indexOf("jdbc:oracle") != -1) dbType = "oracle";
				else if(connURL.indexOf("jdbc:sqlserver") != -1) dbType = "mssql";
				else if(connURL.indexOf("jdbc:mysql") != -1) dbType = "mysql";
				else if(connURL.indexOf("jdbc:db2") != -1) dbType = "db2";
				else if(connURL.indexOf("jdbc:informix") != -1) dbType = "informix";
				dbTypes.put(this.jndi, dbType);
			} catch(Exception e) {
				setError(e.getMessage());
			} finally {
				if(conn != null) try { conn.close(); } catch(Exception e) {}
			}
		}
		return dbType;
	}

	public void close() {
		if(_stmt != null) try { _stmt.close(); } catch(Exception e) {} finally { _stmt = null; }
		if(_pstmt != null) try { _pstmt.close(); } catch(Exception e) {} finally { _pstmt = null; }
		if(_conn != null) try { _conn.close(); } catch(Exception e) {} finally { _conn = null; }
	}

	public void begin() throws Exception {
		if(_conn == null) _conn = this.getConnection();
		_conn.setAutoCommit(false);
	}

	public void commit() throws SQLException {
		if(_conn != null) {
			if(this.errMsg == null) _conn.commit();
			else _conn.rollback();
			_conn.setAutoCommit(false);
			this.close();
		}
	}

	public void rollback() throws SQLException {
		if(_conn != null) _conn.rollback();
	}

	public RecordSet selectLimit(String sql, int limit) throws Exception {
		String dbType = getDBType();
		if("informix".equals(dbType)){
			sql = "SELECT FIRST "+limit+" * FROM (" + sql + ") ";
		}else if("oracle".equals(dbType)) {
			sql = "SELECT * FROM (" + sql + ") WHERE rownum  <= " + limit;
		} else if("mssql".equals(dbType)) {
			sql = sql.replaceAll("(?i)^(SELECT)", "SELECT TOP(" + limit + ")");
		} else if("db2".equals(dbType)) {
			sql += " FETCH FIRST " + limit + " ROWS ONLY";
		} else {
			sql += " LIMIT " + limit;
		}
		return query(sql);
	}
	public RecordSet selectRandom(String sql, int limit) throws Exception {
		String dbType = getDBType();
		if("oracle".equals(dbType)) {
			sql = "SELECT * FROM (" + sql + " ORDER BY dbms_random.value) WHERE rownum  <= " + limit;
		} else if("mssql".equals(dbType)) {
			sql = sql.replaceAll("(?i)^(SELECT)", "SELECT TOP(" + limit + ")") + " ORDER BY NEWID()";
		} else if("db2".equals(dbType)) {
			sql = sql.replaceAll("(?i)^(SELECT)", "SELECT RAND() as IDXX, ") + " ORDER BY IDXX FETCH FIRST " + limit + " ROWS ONLY";
		} else {
			sql += " ORDER BY RAND() LIMIT " + limit; 
		}
		return query(sql);
	}

	public RecordSet query(String query) throws Exception {
		return query(query, true);
	}
	
	public RecordSet query(String query, boolean keyLower) throws Exception {
		Connection conn = this.getConnection();
		if(conn == null) return new RecordSet(null);

		this.query = query;
		ResultSet rs = null;
		Statement stmt = null;
		RecordSet records = null;

		try {
			setError(query);
			stmt = conn.createStatement();
			stmt.setQueryTimeout(DEFAULT_TIMEOUT);
			rs = stmt.executeQuery(query);
			records = new RecordSet(rs,keyLower);
			
			
			System.out.println("**********query**************");
			System.out.println(queryFormat.equals("true")?SqlFormatter.format(query):query);
			System.out.println("**********query**************");
			
		} catch(Exception e) {
			System.out.println("**********error query**************");
			System.out.println(SqlFormatter.format(query));
			System.out.println(e.getMessage());
			System.out.println("**********error query**************");
			setError(e.getMessage());
		} finally {
			if(rs != null) try { rs.close(); } catch(Exception e) {}
			if(stmt != null) try { stmt.close(); } catch(Exception e) {}
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}

		if(records == null) records = new RecordSet(null);
		return records;
	}
	
	public RecordSet query(String query, Hashtable record) throws Exception {
		return query(query, record, true);
	}
	public RecordSet query(String query, Hashtable record, boolean keyLower) throws Exception {
		Connection conn = this.getConnection();
		if(conn == null) return new RecordSet(null);

		this.query = query;
		ResultSet rs = null;
		LoggableStatement pstmt = null;
		RecordSet records = null;

		try {
			setError(query);
			ArrayList paramList = getQueryParameter(query, record);
			pstmt = new LoggableStatement(conn,this.query);
			pstmt.setQueryTimeout(DEFAULT_TIMEOUT);
			for(int k = 0; k < paramList.size(); k++){
				if(paramList.get(k)==null){
					pstmt.setObject(k, "");
				}else{
					pstmt.setObject(k+1, record.get((String)paramList.get(k)));
				}
			}
			
			rs = pstmt.executeQuery();
			records = new RecordSet(rs,keyLower);
			
			if(queryPrient){
				System.out.println("*****************query_start*************************");
				System.out.println(queryFormat.equals("true")?SqlFormatter.format(pstmt.getQueryString()):pstmt.getQueryString() );
				System.out.println("*****************query_end***************************");
			}
			
		} catch(Exception e) {
			System.out.println("**********error query**************");
			System.out.println(queryFormat.equals("true")?SqlFormatter.format(query):query);
			System.out.println(e.getMessage());
			System.out.println("**********error query**************");
			setError(e.getMessage());
		} finally {
			if(rs != null) try { rs.close(); } catch(Exception e) {}
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}

		if(records == null) records = new RecordSet(null);
		return records;
	}

	public int execute(String query) throws Exception {
		Connection conn = this.getConnection();
		if(conn == null) return -1;

		this.query = query;
		Statement stmt = null;
		int ret = -1;
		try {
			setError(query);
			stmt = conn.createStatement();
			stmt.setQueryTimeout(DEFAULT_TIMEOUT);
			
			if(queryPrient){
				System.out.println("*****************query_start*************************");
				System.out.println(queryFormat.equals("true")?SqlFormatter.format(query):query);
				System.out.println("*****************query_end***************************");
			}
			
			ret = stmt.executeUpdate(query);
		} catch(Exception e) {
			System.out.println("**********error query**************");
			System.out.println(queryFormat.equals("true")?SqlFormatter.format(query):query);
			setError(e.getMessage());
			System.out.println("**********error query**************");
		} finally {
			if(stmt != null) try { stmt.close(); } catch(Exception e) {}
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}

		return ret;
	}

	public int execute(String query, Hashtable record) throws Exception {
		Connection conn = this.getConnection();
		if(conn == null) return -1;

		this.query = query;
		LoggableStatement pstmt = null;
		int ret = -1;
		try {
			setError(query);
			ArrayList paramList = getQueryParameter(query, record);
			pstmt = new LoggableStatement(conn,this.query);
			pstmt.setQueryTimeout(DEFAULT_TIMEOUT);
			
			for(int k = 0; k < paramList.size(); k++){
				if(paramList.get(k)==null){
					pstmt.setObject(k, "");
				}else{
					pstmt.setObject(k+1, record.get((String)paramList.get(k)));
				}
			}
			
			ret = pstmt.executeUpdate();
			
			if(queryPrient){
				System.out.println("*****************query_start*************************");
				System.out.println(queryFormat.equals("true")?SqlFormatter.format(pstmt.getQueryString()):pstmt.getQueryString());
				System.out.println("*****************query_end***************************");
			}
		} catch(Exception e) {
			System.out.println("**********error query**************");
			System.out.println(queryFormat.equals("true")?SqlFormatter.format(query):query);
			setError(e.getMessage());
			System.out.println("**********error query**************");
			
		} finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
			if(conn != null) try { conn.close(); } catch(Exception e) {}
		}
		return ret;
	}
	
	public boolean executeArray() throws Exception {
		Connection conn = this.getConnection();
		if(conn == null) return false;
		LoggableStatement pstmt = null;
		boolean result = true;
		try {
			conn.setAutoCommit(false);
			for(int i =0 ; i < arrQuery.size(); i ++){
				this.query = (String)arrQuery.get(i);
				Hashtable record = (Hashtable)arrRecord.get(i);
				
				int ret = -1;
				this.setError(query);
				ArrayList paramList = getQueryParameter(query, record);
				pstmt = new LoggableStatement(conn,this.query);
				pstmt.setQueryTimeout(DEFAULT_TIMEOUT);
				
				for(int k = 0; k < paramList.size(); k++){
					if(paramList.get(k)==null){
						pstmt.setObject(k, "");
					}else{
						pstmt.setObject(k+1, record.get((String)paramList.get(k)));
					}
				}
				if(queryPrient){
					System.out.println("*****************query_start*************************");
					System.out.println(queryFormat.equals("true")?SqlFormatter.format(pstmt.getQueryString()):pstmt.getQueryString());
					System.out.println("*****************query_end***************************");
				}
				
				if(result) ret = pstmt.executeUpdate();
				result = ret<0? false : true;
				pstmt.close();
				pstmt = null;
			}
			if(result){
				conn.commit();
			}else{
				conn.rollback();
			}
		} catch(Exception e) {
			conn.rollback();
			result = false;
			setError(e.getMessage());
		} finally {
			if(pstmt != null) try { pstmt.close(); } catch(Exception e) {}
			if(conn != null) try {  conn.setAutoCommit(true); conn.close(); } catch(Exception e) {}
		}
		return result;
	}
	
	public void setCommand(String cmd) throws Exception {
		if(_conn == null) _conn = this.getConnection();

		this.query = cmd;
		try {
			setError(this.query);
			_pstmt = _conn.prepareStatement(this.query);
			_pstmt.setQueryTimeout(DEFAULT_TIMEOUT);
		} catch(Exception e) {
			setError(e.getMessage());
		}
	}
	
	public void setCommand(String query, Hashtable record){
		if(this.arrQuery == null){
			arrQuery = new ArrayList();
		}
		if(this.arrRecord == null){
			arrRecord = new ArrayList();
		}
		arrQuery.add(query);
		arrRecord.add(record);
	}

	public void setParam(int i, String param) throws Exception {
		_pstmt.setString(i, param); 
	}

	public void setParam(int i, int param) throws Exception {
		_pstmt.setInt(i, param); 
	}

	public void setParam(int i, double param) throws Exception {
		_pstmt.setDouble(i, param); 
	}

	public void setParam(int i, long param) throws Exception {
		_pstmt.setLong(i, param); 
	}

	public RecordSet query() throws Exception {
		ResultSet rs = null;
		RecordSet records = null;
		try {
			rs = _pstmt.executeQuery();
			records = new RecordSet(rs);
		} catch(Exception e) {
			setError(e.getMessage());
		} finally {
			try { rs.close(); } catch(Exception e) {}
			try { _pstmt.close(); _pstmt = null; } catch(Exception e) {}
			try { _conn.close(); _conn = null; } catch(Exception e) {}
		}
		if(records == null) records = new RecordSet(null);
		return records;		
	}

	public int execute() throws Exception {
		int ret = -1;
		try {
			ret = _pstmt.executeUpdate();
		} catch(Exception e) {
			setError(e.getMessage());
		} finally {
			try { _pstmt.close(); _pstmt = null; } catch(Exception e) {}
			try { _conn.close(); _conn = null; } catch(Exception e) {}
		}
		return ret;
	}

	public ResultSet executeQuery(String query) throws Exception {
		return executeQuery(query, DEFAULT_TIMEOUT);
	}

	public ResultSet executeQuery(String query, int timeout) throws Exception {
		if(_conn == null) _conn = this.getConnection();

		this.query = query;
		ResultSet rs = null;
		try {
			setError(query);
			if(_stmt == null) {
				_stmt = _conn.createStatement();
				_stmt.setQueryTimeout(timeout);
			}
			rs = _stmt.executeQuery(query);
		} catch(Exception e) {
			setError(e.getMessage());
		}

		return rs;
	}

	public int executeUpdate(String query) throws Exception {
		return executeUpdate(query, DEFAULT_TIMEOUT);
	}

	public int executeUpdate(String query, int timeout) throws Exception {
		if(_conn == null) _conn = this.getConnection();

		this.query = query;
		int ret = -1;
		try {
			setError(query);
			if(_stmt == null) {
				_stmt = _conn.createStatement();
				_stmt.setQueryTimeout(timeout);
			}
			ret = _stmt.executeUpdate(query);
		} catch(Exception e) {
			setError(e.getMessage());
		}

		return ret;
	}
	
	public ArrayList getQueryParameter (String query, Hashtable parameterObject){
		
		ArrayList paramList = new ArrayList();
	    StringTokenizer parser = new StringTokenizer(query, delimiter, true);
	    StringBuffer newSql = new StringBuffer();

	    String token = null;
	    String lastToken = null;
	    while (parser.hasMoreTokens()) {
	      token = parser.nextToken();

	      if (delimiter.equals(lastToken)) {
	        if (delimiter.equals(token)) {
	          newSql.append(delimiter);
	          token = null;
	        } else {

	          Object value = null;
	          if (parameterObject != null) {
	              value = parameterObject.get(token);
	          }
	          if (value != null) {
	            newSql.append("?");
	            paramList.add(token);
	          }

	          token = parser.nextToken();
	          if (!delimiter.equals(token)) {
	            throw new SqlMapException("Unterminated dynamic element in sql (" + query + ").");
	          }
	          token = null;
	        }
	      } else {
	        if (!delimiter.equals(token)) {
	          newSql.append(token);
	        }
	      }

	      lastToken = token;
	    }
	    this.query = newSql.toString();
	    return paramList;
	  }
}
