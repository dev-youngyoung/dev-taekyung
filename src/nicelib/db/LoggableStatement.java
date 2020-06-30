package nicelib.db;

import java.sql.*;
import java.io.InputStream;
import java.io.Reader;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URL;
import java.util.ArrayList;
import java.util.Calendar; 
import java.sql.Date;
import java.util.StringTokenizer;
import	oracle.sql.CLOB;

/**
 * A <code>LoggableStatement<code> is a {@link java.sql.PreparedStatement PreparedStatement} with added logging capability.
 * <p>
 * In addition to the methods declared in <code>PreparedStatement</code>,
 * <code>LoggableStatement<code> provides a method {@link #getQueryString} which can be used to get the query string in a format
 * suitable for logging.
 *
 * @author Jens Wyke (jens.wyke@se.ibm.com)
 * 
 */
public class LoggableStatement implements PreparedStatement { 

	/**
	 * used for storing parameter values needed for producing log
	 */
	private ArrayList parameterValues;

	/**
	 *the query string with question marks as parameter placeholders
	 */
	private String sqlTemplate;

	/**
	 *  a statement created from a real database connection
	 */
	private	ResultSet					rs		=	null;
	private PreparedStatement	ps		=	null;
	private	CallableStatement	cs		=	null;
	private	boolean						bCall	=	false;

	/**
		* Constructs a LoggableStatement.
		*
		* Creates {@link java.sql.PreparedStatement PreparedStatement} with the query string <code>sql</code> using
		* the specified <code>connection</code> by calling {@link java.sql.Connection#prepareStatement(String)}.
		* <p>
		* Whenever a call is made to this <code>LoggableStatement</code> it is forwarded to the prepared statment created from
		* <code>connection</code> after first saving relevant parameters for use in logging output.
		*
		* @param connection java.sql.Connection a JDBC-connection to be used for obtaining a "real statement"
		* @param sql java.lang.String thw sql to exectute
	 * @throws UnsupportedEncodingException 
	 * @throws UnsupportedEncodingException 
	 * @throws SQLException 
		* @exception java.sql.SQLException if a <code>PreparedStatement</code> cannot be created
		* using the supplied <code>connection</code> and <code>sql</code>
	 * @throws UnsupportedEncodingException 
	 * @throws SQLException
		*/
	public LoggableStatement(Connection connection, String sql) throws UnsupportedEncodingException, SQLException
	{
		try {
			this.prepare(connection, sql);
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".LoggableStatement()] :" + e.toString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".LoggableStatement()] :" + e.toString());
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".LoggableStatement()] :" + e.toString()+"\n"+sql);
			throw new SQLException("[ERROR "+this.getClass()+".LoggableStatement()] :" + e.toString());
		}
	}
	
	/**
	 * 생성자 선언
	 */
	public LoggableStatement(){}
	
	/**
	 * 
	 * @param sSql
	 */
	public void	setCheckCall(String sSql)
	{
		if(sSql.toUpperCase().toUpperCase().indexOf("{") != -1)
		{
			this.bCall	= true;
		}else
		{
			this.bCall	=	false;
		}
	}
	
	/**
	 * prepareStatement
	 * @param connection
	 * @param sql
	 * @throws SQLException 
	 * @throws UnsupportedEncodingException 
	 */
	public void prepareStatement(Connection connection,String sql) throws SQLException, UnsupportedEncodingException
	{
		try {
			if(this.ps != null)
			{
				this.ps.close();
				this.ps = null;
			}
			sqlTemplate 	= sql;
			parameterValues = new ArrayList();
			this.ps =  connection.prepareStatement(this.sqlTemplate);
		} catch (SQLException e) {
			e.printStackTrace();
			throw new SQLException("[ERROR "+this.getClass()+".prepareStatement()] :" + e.toString());
		}
	}
	
	/**
	 * prepareCall
	 * @param connection
	 * @param sql
	 * @throws SQLException
	 * @throws UnsupportedEncodingException
	 */
	public void prepareCall(Connection connection,String sql) throws SQLException, UnsupportedEncodingException
	{
		try {
			if(this.cs != null)
			{
				this.cs.close();
				this.cs = null;
			}
			sqlTemplate 	= sql;
			parameterValues = new ArrayList();
			this.cs =  connection.prepareCall(this.sqlTemplate);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".prepareCall()] :" + e.toString()+"\n"+this.sqlTemplate);
			throw new SQLException("[ERROR "+this.getClass()+".prepareCall()] :" + e.toString());
		}
	}
	
	/**
	 * 
	 * @param connection
	 * @param sql
	 * @throws UnsupportedEncodingException
	 * @throws SQLException
	 */
	public void prepare(Connection connection, String sql) throws UnsupportedEncodingException, SQLException
	{
		try {			
			this.setCheckCall(sql); 
			
			if(this.bCall)
			{
				this.prepareCall(connection, sql);
			}else
			{
				this.prepareStatement(connection, sql);
			}
		} catch (UnsupportedEncodingException e) {
			System.out.println("[ERROR "+this.getClass()+".prepare()] :" + e.toString()+"\n"+this.getQueryString());
			throw new UnsupportedEncodingException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".prepare()] :" + e.toString()+"\n"+this.getQueryString());
			throw new SQLException("[ERROR "+this.getClass()+".prepare()] :" + e.toString());
		}
	}

	/**
	 * JDBC 2.0
	 *
	 * Adds a set of parameters to the batch.
	 * @throws SQLException 
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 * @see Statement#addBatch
	 */
	public void addBatch() throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.addBatch();
			}else
			{
				this.ps.addBatch();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".addBatch()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".addBatch()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Adds a SQL command to the current batch of commmands for the statement.
	 * This method is optional.
	 *
	 * @param sql typically this is a static SQL INSERT or UPDATE statement
	 * @throws SQLException 
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs, or the
	 * driver does not support batch statements
	 * @throws UnsupportedEncodingException 
	 * @throws UnsupportedEncodingException 
	 */
	public void addBatch(String sql) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.addBatch(sql);
			}else
			{
				this.ps.addBatch(sql);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".addBatch()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".addBatch()] :" + e.toString());
		}
	}
	/**
	 * Cancels this <code>Statement</code> object if both the DBMS and
	 * driver support aborting an SQL statement.
	 * This method can be used by one thread to cancel a statement that
	 * is being executed by another thread.
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 */
	public void cancel() throws SQLException{
		if(this.bCall)
		{
			this.cs.cancel();
		}else
		{
			this.ps.cancel();
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Makes the set of commands in the current batch empty.
	 * This method is optional.
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs or the
	 * driver does not support batch statements
	 */
	public void clearBatch() throws SQLException{
		if(this.bCall)
		{
			this.cs.clearBatch();
		}else
		{
			this.ps.clearBatch();
		}
	}
	/**
	 * Clears the current parameter values immediately.
	 * <P>In general, parameter values remain in force for repeated use of a
	 * Statement. Setting a parameter value automatically clears its
	 * previous value.  However, in some cases it is useful to immediately
	 * release the resources used by the current parameter values; this can
	 * be done by calling clearParameters.
	 * @throws SQLException 
	 *
 * @throws SQLException  @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 */
	public void clearParameters() throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.clearParameters();
			}else
			{
				this.ps.clearParameters();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".clearParameters()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".clearParameters()] :" + e.toString());
		}
	}
	/**
	 * Clears all the warnings reported on this <code>Statement</code>
	 * object. After a call to this method,
	 * the method <code>getWarnings</code> will return
	 * null until a new warning is reported for this Statement.
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 */
	public void clearWarnings() throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.clearWarnings();
			}else
			{
				this.ps.clearWarnings();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".clearWarnings()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".clearWarnings()] :" + e.toString());
		}
	}
	/**
	 * Releases this <code>Statement</code> object's database
	 * and JDBC resources immediately instead of waiting for
	 * this to happen when it is automatically closed.
	 * It is generally good practice to release resources as soon as
	 * you are finished with them to avoid tying up database
	 * resources.
	 * <P><B>Note:</B> A Statement is automatically closed when it is
	 * garbage collected. When a Statement is closed, its current
	 * ResultSet, if one exists, is also closed.
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 */
	public void close() throws SQLException
	{
		try {
			if(this.rs != null)	this.rs.close();
			if(this.ps != null)	this.ps.close();
			if(this.cs != null)	this.cs.close();
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".close()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".close()] :" + e.toString());
		}
	}
	/**
	 * Executes any kind of SQL statement.
	 * Some prepared statements return multiple results; the execute
	 * method handles these complex statements as well as the simpler
	 * form of statements handled by executeQuery and executeUpdate.
	 * @throws SQLException 
	 *
	 * @exception SQLException if a database access error occurs
	 * @see Statement#execute
	 */
	public boolean execute() throws SQLException{
		boolean	bSuccess	=	false;
		try {
			if(this.bCall)
			{
				bSuccess	=	this.cs.execute();	
			}else
			{
				bSuccess	=	this.ps.execute();	
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".execute()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".execute()] :" + e.toString());
		}
		return bSuccess;
	}
	/**
	 * Executes a SQL statement that may return multiple results.
	 * Under some (uncommon) situations a single SQL statement may return
	 * multiple result sets and/or update counts.  Normally you can ignore
	 * this unless you are (1) executing a stored procedure that you know may
	 * return multiple results or (2) you are dynamically executing an
	 * unknown SQL string.  The  methods <code>execute</code>,
	 * <code>getMoreResults</code>, <code>getResultSet</code>,
	 * and <code>getUpdateCount</code> let you navigate through multiple results.
	 *
	 * The <code>execute</code> method executes a SQL statement and indicates the
	 * form of the first result.  You can then use getResultSet or
	 * getUpdateCount to retrieve the result, and getMoreResults to
	 * move to any subsequent result(s).
	 *
	 * @param sql any SQL statement
	 * @return true if the next result is a ResultSet; false if it is
	 * an update count or there are no more results
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @throws UnsupportedEncodingException 
	 * @see #getResultSet
	 * @see #getUpdateCount
	 * @see #getMoreResults
	 */
	public boolean execute(String sql) throws SQLException{
		boolean	bSuccess	=	false;
		try {
			if(this.bCall)
			{
				this.cs.execute(sql);
			}else
			{
				this.ps.execute(sql);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".execute()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".execute()] :" + e.toString());
		} 
		return bSuccess;
	}
	/**
	 * JDBC 2.0
	 *
	 * Submits a batch of commands to the database for execution.
	 * This method is optional.
	 *
	 * @return an array of update counts containing one element for each
	 * command in the batch.  The array is ordered according
	 * to the order in which commands were inserted into the batch.
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs or the
	 * driver does not support batch statements
	 */
	public int[] executeBatch() throws SQLException{
		int[]	ai	=	null;
		try {
			if(this.bCall)
			{
				ai	=	this.cs.executeBatch();
			}else
			{
				ai	=	this.ps.executeBatch();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".executeBatch()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".executeBatch()] :" + e.toString());
		}
		return ai;
	}
	/**
	 * Executes the SQL query in this <code>PreparedStatement</code> object
	 * and returns the result set generated by the query.
	 *
	 * @return a ResultSet that contains the data produced by the
	 * query; never null
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public ResultSet executeQuery() throws SQLException {
		try {
			if(this.bCall)
			{
				this.getQueryString();
				this.rs	=	this.cs.executeQuery();
			}else
			{
				this.getQueryString();
				this.rs	=	this.ps.executeQuery();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".executeQuery()] :" + e.toString() + this.getQueryString());
			throw new SQLException("[ERROR "+this.getClass()+".executeQuery()] :" + e.toString());
		}
		return rs;
	}
	/**
	 * Executes a SQL statement that returns a single ResultSet.
	 *
	 * @param sql typically this is a static SQL SELECT statement
	 * @return a ResultSet that contains the data produced by the
	 * query; never null
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @throws UnsupportedEncodingException 
	 */
	public ResultSet executeQuery(String sql) throws SQLException{
		try {
			if(this.bCall)
			{
				this.rs	=	this.cs.executeQuery(sql);
			}else
			{
				this.rs	=	this.ps.executeQuery(sql);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".executeQuery()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".executeQuery()] :" + e.toString());
		} 
		return rs;
	}
	/**
	 * Executes the SQL INSERT, UPDATE or DELETE statement
	 * in this <code>PreparedStatement</code> object.
	 * In addition,
	 * SQL statements that return nothing, such as SQL DDL statements,
	 * can be executed.
	 *
	 * @return either the row count for INSERT, UPDATE or DELETE statements;
	 * or 0 for SQL statements that return nothing
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int executeUpdate() throws SQLException{
		int	i	=	0;
		try {
			this.getQueryString();
			if(this.bCall)
			{
				i	=	this.cs.executeUpdate();
			}else
			{
				i	=	this.ps.executeUpdate();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString() + "\nERROR QUERY[\n"+this.getQueryString()+"\n]");
			throw new SQLException("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString());
		}
		return i;
	}
	/**
	 * Executes an SQL INSERT, UPDATE or DELETE statement. In addition,
	 * SQL statements that return nothing, such as SQL DDL statements,
	 * can be executed.
	 *
	 * @param sql a SQL INSERT, UPDATE or DELETE statement or a SQL
	 * statement that returns nothing
	 * @return either the row count for INSERT, UPDATE or DELETE or 0
	 * for SQL statements that return nothing
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @throws UnsupportedEncodingException 
	 */
	public int executeUpdate(String sql) throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				 i	=	this.cs.executeUpdate(sql);
			}else
			{
				 i	=	this.ps.executeUpdate(sql);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".executeUpdate()] :" + e.toString());
		}
		return	i; 
	}
	/**
	 * JDBC 2.0
	 *
	 * Returns the <code>Connection</code> object
	 * that produced this <code>Statement</code> object.
	 * @return the connection that produced this statement
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public Connection getConnection() throws SQLException{
		Connection	conn	=	null;
		try {
			if(this.bCall)
			{
				conn	=	this.cs.getConnection();
			}else
			{
				conn	=	this.ps.getConnection();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getConnection()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getConnection()] :" + e.toString());
		}	
		return conn;
	}
	/**
	 * JDBC 2.0
	 *
	 * Retrieves the direction for fetching rows from
	 * database tables that is the default for result sets
	 * generated from this <code>Statement</code> object.
	 * If this <code>Statement</code> object has not set
	 * a fetch direction by calling the method <code>setFetchDirection</code>,
	 * the return value is implementation-specific.
	 *
	 * @return the default fetch direction for result sets generated
	 *          from this <code>Statement</code> object
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int getFetchDirection() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getFetchDirection();
			}else
			{
				i	=	this.ps.getFetchDirection();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getFetchDirection()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getFetchDirection()] :" + e.toString());
		}
		return i;
	}
	/**
	 * JDBC 2.0
	 *
	 * Retrieves the number of result set rows that is the default
	 * fetch size for result sets
	 * generated from this <code>Statement</code> object.
	 * If this <code>Statement</code> object has not set
	 * a fetch size by calling the method <code>setFetchSize</code>,
	 * the return value is implementation-specific.
	 * @return the default fetch size for result sets generated
	 *          from this <code>Statement</code> object
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int getFetchSize() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getFetchSize();
			}else
			{
				i	=	this.ps.getFetchSize();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getFetchSize()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getFetchSize()] :" + e.toString());
		}
		return i;
	}
	/**
	 * Returns the maximum number of bytes allowed
	 * for any column value.
	 * This limit is the maximum number of bytes that can be
	 * returned for any column value.
	 * The limit applies only to BINARY,
	 * VARBINARY, LONGVARBINARY, CHAR, VARCHAR, and LONGVARCHAR
	 * columns.  If the limit is exceeded, the excess data is silently
	 * discarded.
	 *
	 * @return the current max column size limit; zero means unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int getMaxFieldSize() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getMaxFieldSize();
			}else
			{
				i	=	this.ps.getMaxFieldSize();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getFetchSize()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getFetchSize()] :" + e.toString());
		}
		return i;
	}
	/**
	 * Retrieves the maximum number of rows that a
	 * ResultSet can contain.  If the limit is exceeded, the excess
	 * rows are silently dropped.
	 *
	 * @return the current max row limit; zero means unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int getMaxRows() throws SQLException{
		int i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getMaxRows();
			}else
			{
				i	=	this.ps.getMaxRows();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getMaxRows()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getMaxRows()] :" + e.toString());
		}
		return i;
	}
	/**
	 * JDBC 2.0
	 *
	 * Gets the number, types and properties of a ResultSet's columns.
	 *
	 * @return the description of a ResultSet's columns
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public ResultSetMetaData getMetaData() throws SQLException{
		ResultSetMetaData	rsm	=	null;
		try {
			if(this.bCall)
			{
				rsm	=	this.cs.getMetaData();
			}else
			{
				rsm	=	this.ps.getMetaData();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getMetaData()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getMetaData()] :" + e.toString());
		}
		return rsm;
	}
	/**
	 * Moves to a Statement's next result.  It returns true if
	 * this result is a ResultSet.  This method also implicitly
	 * closes any current ResultSet obtained with getResultSet.
	 *
	 * There are no more results when (!getMoreResults() &&
	 * (getUpdateCount() == -1)
	 *
	 * @return true if the next result is a ResultSet; false if it is
	 * an update count or there are no more results
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @see #execute
	 */
	public boolean getMoreResults() throws SQLException{
		boolean	bSuccess	=	false;
		try {
			if(this.bCall)
			{
				bSuccess	=	 this.cs.getMoreResults();
			}else
			{
				bSuccess	=	 this.ps.getMoreResults();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getMoreResults()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getMoreResults()] :" + e.toString());
		}
		return bSuccess;
	}
	/**
	 * Retrieves the number of seconds the driver will
	 * wait for a Statement to execute. If the limit is exceeded, a
	 * SQLException is thrown.
	 *
	 * @return the current query timeout limit in seconds; zero means unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public int getQueryTimeout() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getQueryTimeout();
			}else
			{
				i	=	this.ps.getQueryTimeout();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getQueryTimeout()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getQueryTimeout()] :" + e.toString());
		}
		return i;
	}
	/**
	 *  Returns the current result as a <code>ResultSet</code> object.
	 *  This method should be called only once per result.
	 *
	 * @return the current result as a ResultSet; null if the result
	 * is an update count or there are no more results
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @see #execute
	 */
	public ResultSet getResultSet() throws SQLException{
		try {
			if(this.bCall)
			{
				this.rs	= this.cs.getResultSet();
			}else
			{
				this.rs	= this.ps.getResultSet();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getResultSet()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getResultSet()] :" + e.toString());
		}
		return rs;
	}
	/**
	 * JDBC 2.0
	 *
	 * Retrieves the result set concurrency.
	 * @throws SQLException 
	 */
	public int getResultSetConcurrency() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getResultSetConcurrency();
			}else
			{
				i	=	this.ps.getResultSetConcurrency();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getResultSetConcurrency()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getResultSetConcurrency()] :" + e.toString());
		}
		return i;
	}
	/**
	 * JDBC 2.0
	 *
	 * Determine the result set type.
	 * @throws SQLException 
	 */
	public int getResultSetType() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getResultSetType();
			}else
			{
				i	=	this.ps.getResultSetType();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getResultSetConcurrency()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getResultSetConcurrency()] :" + e.toString());
		}
		return i;
	}
	/**
	 *  Returns the current result as an update count;
	 *  if the result is a ResultSet or there are no more results, -1
	 *  is returned.
	 *  This method should be called only once per result.
	 *
	 * @return the current result as an update count; -1 if it is a
	 * ResultSet or there are no more results
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @see #execute
	 */
	public int getUpdateCount() throws SQLException{
		int	i	=	0;
		try {
			if(this.bCall)
			{
				i	=	this.ps.getUpdateCount();
			}else
			{
				i	=	this.cs.getUpdateCount();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getUpdateCount()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getUpdateCount()] :" + e.toString());
		}
		return i;
	}
	/**
	 * Retrieves the first warning reported by calls on this Statement.
	 * Subsequent Statement warnings will be chained to this
	 * SQLWarning.
	 *
	 * <p>The warning chain is automatically cleared each time
	 * a statement is (re)executed.
	 *
	 * <P><B>Note:</B> If you are processing a ResultSet, any
	 * warnings associated with ResultSet reads will be chained on the
	 * ResultSet object.
	 *
	 * @return the first SQLWarning or null
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public SQLWarning getWarnings() throws SQLException{
		SQLWarning	sqlw	=	null;
		try {
			if(this.bCall)
			{
				sqlw	=	this.cs.getWarnings();
			}else
			{
				sqlw	=	this.ps.getWarnings();
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getWarnings()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getWarnings()] :" + e.toString());
		}
		return sqlw;
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets an Array parameter.
	 *
	 * @param i the first parameter is 1, the second is 2, ...
	 * @param x an object representing an SQL array
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setArray(int i, Array x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setArray(i, x);
			}else
			{
				this.ps.setArray(i, x);
			}
			
			this.saveQueryParamValue(i, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setArray()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setArray()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to the given input stream, which will have
	 * the specified number of bytes.
	 * When a very large ASCII value is input to a LONGVARCHAR
	 * parameter, it may be more practical to send it via a
	 * java.io.InputStream. JDBC will read the data from the stream
	 * as needed, until it reaches end-of-file.  The JDBC driver will
	 * do any necessary conversion from ASCII to the database char format.
	 *
	 * <P><B>Note:</B> This stream object can either be a standard
	 * Java stream object or your own subclass that implements the
	 * standard interface.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the Java input stream that contains the ASCII parameter value
	 * @param length the number of bytes in the stream
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setAsciiStream(int parameterIndex,InputStream x,int length) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setAsciiStream(parameterIndex, x, length);
			}else
			{
				this.ps.setAsciiStream(parameterIndex, x, length);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setAsciiStream()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setAsciiStream()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a java.lang.BigDecimal value.
	 * The driver converts this to an SQL NUMERIC value when
	 * it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setBigDecimal(int parameterIndex, BigDecimal x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setBigDecimal(parameterIndex, x);
			}else
			{
				this.ps.setBigDecimal(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setBigDecimal()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setBigDecimal()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to the given input stream, which will have
	 * the specified number of bytes.
	 * When a very large binary value is input to a LONGVARBINARY
	 * parameter, it may be more practical to send it via a
	 * java.io.InputStream. JDBC will read the data from the stream
	 * as needed, until it reaches end-of-file.
	 *
	 * <P><B>Note:</B> This stream object can either be a standard
	 * Java stream object or your own subclass that implements the
	 * standard interface.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the java input stream which contains the binary parameter value
	 * @param length the number of bytes in the stream
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setBinaryStream(int parameterIndex,InputStream x,int length) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setBinaryStream(parameterIndex, x, length);
			}else
			{
				this.ps.setBinaryStream(parameterIndex, x, length);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setBinaryStream()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setBinaryStream()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets a BLOB parameter.
	 *
	 * @param i the first parameter is 1, the second is 2, ...
	 * @param x an object representing a BLOB
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setBlob(int i, Blob x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setBlob(i, x);
			}else
			{
				this.ps.setBlob(i, x);
			}
			
			this.saveQueryParamValue(i, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setBlob()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setBlob()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java boolean value.  The driver converts this
	 * to an SQL BIT value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setBoolean(int parameterIndex, boolean x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setBoolean(parameterIndex, x);
			}else
			{
				this.ps.setBoolean(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Boolean(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setBoolean()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setBoolean()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java byte value.  The driver converts this
	 * to an SQL TINYINT value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setByte(int parameterIndex, byte x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setByte(parameterIndex, x);
			}else
			{
				this.ps.setByte(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Integer(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setByte()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setByte()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java array of bytes.  The driver converts
	 * this to an SQL VARBINARY or LONGVARBINARY (depending on the
	 * argument's size relative to the driver's limits on VARBINARYs)
	 * when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setBytes(int parameterIndex, byte[] x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setBytes(parameterIndex, x);
			}else
			{
				this.ps.setBytes(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setBytes()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setBytes()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets the designated parameter to the given <code>Reader</code>
	 * object, which is the given number of characters long.
	 * When a very large UNICODE value is input to a LONGVARCHAR
	 * parameter, it may be more practical to send it via a
	 * java.io.Reader. JDBC will read the data from the stream
	 * as needed, until it reaches end-of-file.  The JDBC driver will
	 * do any necessary conversion from UNICODE to the database char format.
	 *
	 * <P><B>Note:</B> This stream object can either be a standard
	 * Java stream object or your own subclass that implements the
	 * standard interface.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param reader the java reader which contains the UNICODE data
	 * @param length the number of characters in the stream
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setCharacterStream(int parameterIndex,Reader reader,int length) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setCharacterStream(parameterIndex, reader, length);
			}else
			{
				this.ps.setCharacterStream(parameterIndex, reader, length);
			}
			
			this.saveQueryParamValue(parameterIndex, reader);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setCharacterStream()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setCharacterStream()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets a CLOB parameter.
	 *
	 * @param i the first parameter is 1, the second is 2, ...
	 * @param x an object representing a CLOB
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setClob(int i, Clob x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setClob(i, x);
			}else
			{
				this.ps.setClob(i, x);
			}
			
			this.saveQueryParamValue(i, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setClob()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setClob()] :" + e.toString());
		}
	}
	/**
	 * Defines the SQL cursor name that will be used by
	 * subsequent Statement <code>execute</code> methods. This name can then be
	 * used in SQL positioned update/delete statements to identify the
	 * current row in the ResultSet generated by this statement.  If
	 * the database doesn't support positioned update/delete, this
	 * method is a noop.  To insure that a cursor has the proper isolation
	 * level to support updates, the cursor's SELECT statement should be
	 * of the form 'select for update ...'. If the 'for update' phrase is
	 * omitted, positioned updates may fail.
	 *
	 * <P><B>Note:</B> By definition, positioned update/delete
	 * execution must be done by a different Statement than the one
	 * which generated the ResultSet being used for positioning. Also,
	 * cursor names must be unique within a connection.
	 *
	 * @param name the new cursor name, which must be unique within
	 *             a connection
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setCursorName(String name) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setCursorName(name);
			}else
			{
				this.ps.setCursorName(name);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setCursorName()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setCursorName()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a java.sql.Date value.  The driver converts this
	 * to an SQL DATE value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setDate(int parameterIndex, Date x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setDate(parameterIndex, x);
			}else
			{
				this.ps.setDate(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setDate()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setDate()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets the designated parameter to a java.sql.Date value,
	 * using the given <code>Calendar</code> object.  The driver uses
	 * the <code>Calendar</code> object to construct an SQL DATE,
	 * which the driver then sends to the database.  With a
	 * a <code>Calendar</code> object, the driver can calculate the date
	 * taking into account a custom timezone and locale.  If no
	 * <code>Calendar</code> object is specified, the driver uses the default
	 * timezone and locale.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @param cal the <code>Calendar</code> object the driver will use
	 *            to construct the date
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setDate(int parameterIndex,Date x,Calendar cal) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setDate(parameterIndex, x, cal);
			}else
			{
				this.ps.setDate(parameterIndex, x, cal);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setDate()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setDate()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java double value.  The driver converts this
	 * to an SQL DOUBLE value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setDouble(int parameterIndex, double x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setDouble(parameterIndex, x);
			}else
			{
				this.ps.setDouble(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Double(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setDouble()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setDouble()] :" + e.toString());
		}
		
	}
	/**
	 * Sets escape processing on or off.
	 * If escape scanning is on (the default), the driver will do
	 * escape substitution before sending the SQL to the database.
	 *
	 * Note: Since prepared statements have usually been parsed prior
	 * to making this call, disabling escape processing for prepared
	 * statements will have no effect.
	 *
	 * @param enable true to enable; false to disable
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setEscapeProcessing(boolean enable) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setEscapeProcessing(enable);
			}else
			{
				this.ps.setEscapeProcessing(enable);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setEscapeProcessing()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setEscapeProcessing()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Gives the driver a hint as to the direction in which
	 * the rows in a result set
	 * will be processed. The hint applies only to result sets created
	 * using this Statement object.  The default value is
	 * ResultSet.FETCH_FORWARD.
	 * <p>Note that this method sets the default fetch direction for
	 * result sets generated by this <code>Statement</code> object.
	 * Each result set has its own methods for getting and setting
	 * its own fetch direction.
	 * @param direction the initial direction for processing rows
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * or the given direction
	 * is not one of ResultSet.FETCH_FORWARD, ResultSet.FETCH_REVERSE, or
	 * ResultSet.FETCH_UNKNOWN
	 */
	public void setFetchDirection(int direction) throws SQLException {
		try {
			if(this.bCall)
			{
				this.cs.setFetchDirection(direction);
			}else
			{
				this.ps.setFetchDirection(direction);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setFetchDirection()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setFetchDirection()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Gives the JDBC driver a hint as to the number of rows that should
	 * be fetched from the database when more rows are needed.  The number
	 * of rows specified affects only result sets created using this
	 * statement. If the value specified is zero, then the hint is ignored.
	 * The default value is zero.
	 *
	 * @param rows the number of rows to fetch
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs, or the
	 * condition 0 <= rows <= this.getMaxRows() is not satisfied.
	 */
	public void setFetchSize(int rows) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setFetchSize(rows);
			}else
			{
				this.ps.setFetchSize(rows);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setFetchSize()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setFetchSize()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java float value.  The driver converts this
	 * to an SQL FLOAT value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setFloat(int parameterIndex, float x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setFloat(parameterIndex, x);
			}else
			{
				this.ps.setFloat(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Float(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setFloat()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setFloat()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java int value.  The driver converts this
	 * to an SQL INTEGER value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setInt(int parameterIndex, int x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setInt(parameterIndex, x);
			}else
			{
				this.ps.setInt(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Integer(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setInt()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setInt()] :" + e.toString());
		}
		
	}
	/**
	 * Sets the designated parameter to a Java long value.  The driver converts this
	 * to an SQL BIGINT value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setLong(int parameterIndex, long x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setLong(parameterIndex, x);
			}else
			{
				this.ps.setLong(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Long(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setLong()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setLong()] :" + e.toString());
		}
	}
	/**
	 * Sets the limit for the maximum number of bytes in a column to
	 * the given number of bytes.  This is the maximum number of bytes
	 * that can be returned for any column value.  This limit applies
	 * only to BINARY, VARBINARY, LONGVARBINARY, CHAR, VARCHAR, and
	 * LONGVARCHAR fields.  If the limit is exceeded, the excess data
	 * is silently discarded. For maximum portability, use values
	 * greater than 256.
	 *
	 * @param max the new max column size limit; zero means unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setMaxFieldSize(int max) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setMaxFieldSize(max);
			}else
			{
				this.ps.setMaxFieldSize(max);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setMaxFieldSize()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setMaxFieldSize()] :" + e.toString());
		}
	}
	/**
	 * Sets the limit for the maximum number of rows that any
	 * ResultSet can contain to the given number.
	 * If the limit is exceeded, the excess
	 * rows are silently dropped.
	 *
	 * @param max the new max rows limit; zero means unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setMaxRows(int max) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setMaxRows(max);
			}else
			{
				this.ps.setMaxRows(max);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setMaxRows()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setMaxRows()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to SQL NULL.
	 *
	 * <P><B>Note:</B> You must specify the parameter's SQL type.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param sqlType the SQL type code defined in java.sql.Types
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setNull(int parameterIndex, int sqlType) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setNull(parameterIndex, sqlType);
			}else
			{
				this.ps.setNull(parameterIndex, sqlType);
			}
			
			this.saveQueryParamValue(parameterIndex, null);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setNull()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setNull()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets the designated parameter to SQL NULL.  This version of setNull should
	 * be used for user-named types and REF type parameters.  Examples
	 * of user-named types include: STRUCT, DISTINCT, JAVA_OBJECT, and
	 * named array types.
	 *
	 * <P><B>Note:</B> To be portable, applications must give the
	 * SQL type code and the fully-qualified SQL type name when specifying
	 * a NULL user-defined or REF parameter.  In the case of a user-named type
	 * the name is the type name of the parameter itself.  For a REF
	 * parameter the name is the type name of the referenced type.  If
	 * a JDBC driver does not need the type code or type name information,
	 * it may ignore it.
	 *
	 * Although it is intended for user-named and Ref parameters,
	 * this method may be used to set a null parameter of any JDBC type.
	 * If the parameter does not have a user-named or REF type, the given
	 * typeName is ignored.
	 *
	 *
	 * @param paramIndex the first parameter is 1, the second is 2, ...
	 * @param sqlType a value from java.sql.Types
	 * @param typeName the fully-qualified name of an SQL user-named type,
	 *  ignored if the parameter is not a user-named type or REF
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setNull(int paramIndex, int sqlType, String typeName) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setNull(paramIndex, sqlType, typeName);
			}else
			{
				this.ps.setNull(paramIndex, sqlType, typeName);
			}
			
			this.saveQueryParamValue(paramIndex, null);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setNull()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setNull()] :" + e.toString());
		}
	}
	/**
	 * <p>Sets the value of a parameter using an object; use the
	 * java.lang equivalent objects for integral values.
	 *
	 * <p>The JDBC specification specifies a standard mapping from
	 * Java Object types to SQL types.  The given argument java object
	 * will be converted to the corresponding SQL type before being
	 * sent to the database.
	 *
	 * <p>Note that this method may be used to pass datatabase-
	 * specific abstract data types, by using a Driver-specific Java
	 * type.
	 *
	 * If the object is of a class implementing SQLData,
	 * the JDBC driver should call its method <code>writeSQL</code> to write it
	 * to the SQL data stream.
	 * If, on the other hand, the object is of a class implementing
	 * Ref, Blob, Clob, Struct,
	 * or Array, then the driver should pass it to the database as a value of the
	 * corresponding SQL type.
	 *
	 * This method throws an exception if there is an ambiguity, for example, if the
	 * object is of a class implementing more than one of those interfaces.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the object containing the input parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @throws UnsupportedEncodingException 
	 */
	public void setObject(int parameterIndex, Object x) throws SQLException{
		try {
			if(x.getClass().toString().indexOf("String") != -1)
			{
				if(this.bCall)
				{
					this.cs.setString(parameterIndex,x.toString());
				}else
				{
					this.ps.setString(parameterIndex,x.toString());
				}
			}else
			{
				if(this.bCall)
				{
					this.cs.setObject(parameterIndex, x);
				}else
				{
					this.ps.setObject(parameterIndex, x);
				}
			}
			saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		} 
	}
	/**
		 * Sets the value of the designated parameter with the given object.
		 * This method is like setObject above, except that it assumes a scale of zero.
		 *
		 * @param parameterIndex the first parameter is 1, the second is 2, ...
		 * @param x the object containing the input parameter value
		 * @param targetSqlType the SQL type (as defined in java.sql.Types) to be
		 *                      sent to the database
	 * @throws SQLException 
		 * @exception SQLException if a database access error occurs
		 */
	public void setObject(int parameterIndex, Object x, int targetSqlType) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setObject(parameterIndex, x, targetSqlType);
			}else
			{
				this.ps.setObject(parameterIndex, x, targetSqlType);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		}
	}
	/**
	 * <p>Sets the value of a parameter using an object. The second
	 * argument must be an object type; for integral values, the
	 * java.lang equivalent objects should be used.
	 *
	 * <p>The given Java object will be converted to the targetSqlType
	 * before being sent to the database.
	 *
	 * If the object has a custom mapping (is of a class implementing SQLData),
	 * the JDBC driver should call its method <code>writeSQL</code> to write it
	 * to the SQL data stream.
	 * If, on the other hand, the object is of a class implementing
	 * Ref, Blob, Clob, Struct,
	 * or Array, the driver should pass it to the database as a value of the
	 * corresponding SQL type.
	 *
	 * <p>Note that this method may be used to pass datatabase-
	 * specific abstract data types.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the object containing the input parameter value
	 * @param targetSqlType the SQL type (as defined in java.sql.Types) to be
	 * sent to the database. The scale argument may further qualify this type.
	 * @param scale for java.sql.Types.DECIMAL or java.sql.Types.NUMERIC types,
	 *          this is the number of digits after the decimal point.  For all other
	 *          types, this value will be ignored.
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @see Types
	 */
	public void setObject(int parameterIndex,Object x,int targetSqlType,int scale) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setObject(parameterIndex, x, targetSqlType, scale);
			}else
			{
				this.ps.setObject(parameterIndex, x, targetSqlType, scale);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		}
	}
	
	/**
	 * procudure outParameter 설정
	 * @param parameterIndex
	 * @param sqlType
	 * @throws SQLException
	 */
	public void registerOutParameter(int parameterIndex, int sqlType) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.registerOutParameter(parameterIndex,sqlType);
				this.saveQueryParamValue(parameterIndex,new Integer(sqlType+""));
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".registerOutParameter()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".registerOutParameter()] :" + e.toString());
		}		
	}
	
	/**
	 * proceducre return 값 가져오기
	 * @param parameterIndex
	 * @return
	 * @throws SQLException
	 */
	public Object getObject(int parameterIndex) throws SQLException{
		Object	ob	=	new	Object();
		try {
			if(this.bCall)
			{
				ob	=	this.cs.getObject(parameterIndex);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getObject()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getObject()] :" + e.toString());
		}
		return ob;
	}
	
	/**
	 * proceducre return 값 가져오기
	 * @param parameterIndex
	 * @return
	 * @throws SQLException
	 */
	public int	getInt(int parameterIndex) throws SQLException
	{
		int	i	=	-1;
		try {
			if(this.bCall)
			{
				i	=	this.cs.getInt(parameterIndex);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
		}
		return i;
	}
	
	/**
	 * clob 객체 리턴
	 * @param parameterIndex
	 * @return
	 * @throws SQLException
	 */
	public CLOB	getClob(int parameterIndex) throws SQLException
	{
		CLOB	clob	=	null;
		try {
			if(this.rs != null)	clob	=	(oracle.sql.CLOB)this.rs.getClob(parameterIndex);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getInt()] :" + e.toString());
		}
		return clob;
	}

	/**
	 * proceducre return 값 가져오기
	 * @param parameterIndex
	 * @return
	 * @throws SQLException
	 */
	public String getString(int parameterIndex) throws SQLException
	{
		String sRtnVal	=	"";
		try {
			if(this.bCall)
			{
				sRtnVal	=	this.cs.getString(parameterIndex);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".getString()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".getString()] :" + e.toString());
		}
		return sRtnVal;
	}
	
	/**
	 * Sets the number of seconds the driver will
	 * wait for a Statement to execute to the given number of seconds.
	 * If the limit is exceeded, a SQLException is thrown.
	 *
	 * @param seconds the new query timeout limit in seconds; zero means
	 * unlimited
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setQueryTimeout(int seconds) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setQueryTimeout(seconds);
			}else
			{
				this.ps.setQueryTimeout(seconds);
			}
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setObject()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets a REF(&lt;structured-type&gt;) parameter.
	 *
	 * @param i the first parameter is 1, the second is 2, ...
	 * @param x an object representing data of an SQL REF Type
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setRef(int i, Ref x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setRef(i, x);
			}else
			{
				this.ps.setRef(i, x);
			}
			
			this.saveQueryParamValue(i, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setRef()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setRef()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java short value.  The driver converts this
	 * to an SQL SMALLINT value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setShort(int parameterIndex, short x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setShort(parameterIndex, x);
			}else
			{
				this.ps.setShort(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, new Integer(x));
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setShort()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setShort()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a Java String value.  The driver converts this
	 * to an SQL VARCHAR or LONGVARCHAR value (depending on the argument's
	 * size relative to the driver's limits on VARCHARs) when it sends
	 * it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @throws UnsupportedEncodingException 
	 */
	public void setString(int parameterIndex, String x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setString(parameterIndex, x);
			}else
			{
				this.ps.setString(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setString()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setString()] :" + e.toString());
		}
	}
	
	/**
	 * Sets the designated parameter to a java.sql.Time value.  The driver converts this
	 * to an SQL TIME value when it sends it to the database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setTime(int parameterIndex, Time x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setTime(parameterIndex, x);
			}else
			{
				this.ps.setTime(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setTime()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setTime()] :" + e.toString());
		}
		
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets the designated parameter to a java.sql.Time value,
	 * using the given <code>Calendar</code> object.  The driver uses
	 * the <code>Calendar</code> object to construct an SQL TIME,
	 * which the driver then sends to the database.  With a
	 * a <code>Calendar</code> object, the driver can calculate the time
	 * taking into account a custom timezone and locale.  If no
	 * <code>Calendar</code> object is specified, the driver uses the default
	 * timezone and locale.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @param cal the <code>Calendar</code> object the driver will use
	 *            to construct the time
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setTime(int parameterIndex,	Time x, Calendar cal) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setTime(parameterIndex, x, cal);
			}else
			{
				this.ps.setTime(parameterIndex, x, cal);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setTime()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setTime()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to a java.sql.Timestamp value.  The driver
	 * converts this to an SQL TIMESTAMP value when it sends it to the
	 * database.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setTimestamp(int parameterIndex, Timestamp x) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setTimestamp(parameterIndex, x);
			}else
			{
				this.ps.setTimestamp(parameterIndex, x);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setTimestamp()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setTimestamp()] :" + e.toString());
		}
	}
	/**
	 * JDBC 2.0
	 *
	 * Sets the designated parameter to a java.sql.Timestamp value,
	 * using the given <code>Calendar</code> object.  The driver uses
	 * the <code>Calendar</code> object to construct an SQL TIMESTAMP,
	 * which the driver then sends to the database.  With a
	 * a <code>Calendar</code> object, the driver can calculate the timestamp
	 * taking into account a custom timezone and locale.  If no
	 * <code>Calendar</code> object is specified, the driver uses the default
	 * timezone and locale.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the parameter value
	 * @param cal the <code>Calendar</code> object the driver will use
	 *            to construct the timestamp
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 */
	public void setTimestamp(int parameterIndex, Timestamp x, Calendar cal) throws SQLException{
		try {
			if(this.bCall)
			{
				this.cs.setTimestamp(parameterIndex, x, cal);
			}else
			{
				this.ps.setTimestamp(parameterIndex, x, cal);
			}
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setTimestamp()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setTimestamp()] :" + e.toString());
		}
	}
	/**
	 * Sets the designated parameter to the given input stream, which will have
	 * the specified number of bytes.
	 * When a very large UNICODE value is input to a LONGVARCHAR
	 * parameter, it may be more practical to send it via a
	 * java.io.InputStream. JDBC will read the data from the stream
	 * as needed, until it reaches end-of-file.  The JDBC driver will
	 * do any necessary conversion from UNICODE to the database char format.
	 * The byte format of the Unicode stream must be Java UTF-8, as
	 * defined in the Java Virtual Machine Specification.
	 *
	 * <P><B>Note:</B> This stream object can either be a standard
	 * Java stream object or your own subclass that implements the
	 * standard interface.
	 *
	 * @param parameterIndex the first parameter is 1, the second is 2, ...
	 * @param x the java input stream which contains the
	 * UNICODE parameter value
	 * @param length the number of bytes in the stream
	 * @throws SQLException 
	 * @exception SQLException if a database access error occurs
	 * @deprecated
	 */
	public void setUnicodeStream(int parameterIndex, InputStream x, int length) throws SQLException{
		try {
			if(this.ps != null)	this.ps.setUnicodeStream(parameterIndex, x, length);
			if(this.cs != null)	this.cs.setUnicodeStream(parameterIndex, x, length);
			
			this.saveQueryParamValue(parameterIndex, x);
		} catch (SQLException e) {
			System.out.println("[ERROR "+this.getClass()+".setUnicodeStream()] :" + e.toString());
			throw new SQLException("[ERROR "+this.getClass()+".setUnicodeStream()] :" + e.toString());
		}
	}

	/**
	 * Returns the sql statement string (question marks replaced with set parameter values)
	 * that will be (or has been) executed by the {@link java.sql.PreparedStatement PreparedStatement} that this
	 * <code>LoggableStatement</code> is a wrapper for.
	 * <p>
	 * @return java.lang.String the statemant represented by this <code>LoggableStatement</code>
	 * @throws UnsupportedEncodingException 
	 */
	public String getQueryString(){
		String	sRtnQuery	=	"";
		StringBuffer buf = new StringBuffer();
		int qMarkCount = 0;
		//ArrayList chunks = new ArrayList();
		StringTokenizer tok = new StringTokenizer(sqlTemplate+" ", "?");
		while (tok.hasMoreTokens()) {
			String oneChunk = tok.nextToken();
			buf.append(oneChunk);

			try {
				Object value;
				if (parameterValues.size() > 1 + qMarkCount) {
					value = parameterValues.get(1 + qMarkCount++);
				} else {
					if (tok.hasMoreTokens()) {
						value = null;
					} else {
						value = "";
					}
				}
				buf.append("" + value);
			} catch (Throwable e) {
				buf.append(
					"ERROR WHEN PRODUCING QUERY STRING FOR LOG."
						+ e.toString());
				// catch this without whining, if this fails the only thing wrong is probably this class
			}
		}
		sRtnQuery	=	buf.toString().trim();
		
		return sRtnQuery;
	}

	/**
	 * Saves the parameter value <code>obj</code> for the specified <code>position</code> for use in logging output
	 *
	 * @param position position (starting at 1) of the parameter to save
	 * @param obj java.lang.Object the parameter value to save
	 */
	private void saveQueryParamValue(int position, Object obj) {
		String strValue;
		
		if (obj instanceof String || obj instanceof Date) {
			// if we have a String or Date , include '' in the saved value
			//strValue = "'" + obj + "'";
			if(obj.toString().length()>255){
				strValue = "'(text)'";
			}else{
				strValue = "'" + obj + "'";
			}
		} else {

			if (obj == null) {
				// convert null to the string null
				strValue = "null";
			} else {
				// unknown object (includes all Numbers), just call toString
				strValue = obj.toString();
			}
		}

		// if we are setting a position larger than current size of parameterValues, first make it larger
		while (position >= parameterValues.size()) {
			parameterValues.add(null);
		}
		// save the parameter
		parameterValues.set(position, strValue);
	}
	 
 	// JDK1.4.2를 위한 일부 함수 구현
	public ParameterMetaData getParameterMetaData() throws SQLException{return (ParameterMetaData)new Object();}
	public void setURL(int parameterIndex, URL x) throws SQLException{}
	public boolean execute(String sql,  int autoGeneratedKeys) throws SQLException{return false;}
	public boolean execute(String sql,  int[] columnIndexes) throws SQLException{return false;}
	public boolean execute(String sql,  String[] columnNames) throws SQLException{return false;}	
	public int executeUpdate(String sql, String[] columnNames) throws SQLException{return 0;}
	public int executeUpdate(String sql, int[] columnIndexes) throws SQLException{return 0;}	
	public int executeUpdate(String sql, int autoGeneratedKeys) throws SQLException{return 0;}
	public ResultSet getGeneratedKeys() throws SQLException{return (ResultSet)new Object();}	
	public boolean getMoreResults(int current) throws SQLException{return false;}
	public int getResultSetHoldability()	throws SQLException{return 0;}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setRowId(int, java.sql.RowId)
	 */
	public void setRowId(int arg0, RowId arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNString(int, java.lang.String)
	 */
	public void setNString(int arg0, String arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNCharacterStream(int, java.io.Reader, long)
	 */
	public void setNCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNClob(int, java.sql.NClob)
	 */
	public void setNClob(int arg0, NClob arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setClob(int, java.io.Reader, long)
	 */
	public void setClob(int arg0, Reader arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setBlob(int, java.io.InputStream, long)
	 */
	public void setBlob(int arg0, InputStream arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNClob(int, java.io.Reader, long)
	 */
	public void setNClob(int arg0, Reader arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setSQLXML(int, java.sql.SQLXML)
	 */
	public void setSQLXML(int arg0, SQLXML arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setAsciiStream(int, java.io.InputStream, long)
	 */
	public void setAsciiStream(int arg0, InputStream arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setBinaryStream(int, java.io.InputStream, long)
	 */
	public void setBinaryStream(int arg0, InputStream arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setCharacterStream(int, java.io.Reader, long)
	 */
	public void setCharacterStream(int arg0, Reader arg1, long arg2) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setAsciiStream(int, java.io.InputStream)
	 */
	public void setAsciiStream(int arg0, InputStream arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setBinaryStream(int, java.io.InputStream)
	 */
	public void setBinaryStream(int arg0, InputStream arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setCharacterStream(int, java.io.Reader)
	 */
	public void setCharacterStream(int arg0, Reader arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNCharacterStream(int, java.io.Reader)
	 */
	public void setNCharacterStream(int arg0, Reader arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setClob(int, java.io.Reader)
	 */
	public void setClob(int arg0, Reader arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setBlob(int, java.io.InputStream)
	 */
	public void setBlob(int arg0, InputStream arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.PreparedStatement#setNClob(int, java.io.Reader)
	 */
	public void setNClob(int arg0, Reader arg1) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.Statement#isClosed()
	 */
	public boolean isClosed() throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}

	/* (non-Javadoc)
	 * @see java.sql.Statement#setPoolable(boolean)
	 */
	public void setPoolable(boolean arg0) throws SQLException {
		// TODO Auto-generated method stub
		
	}

	/* (non-Javadoc)
	 * @see java.sql.Statement#isPoolable()
	 */
	public boolean isPoolable() throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void closeOnCompletion() throws SQLException {

	}

	@Override
	public boolean isCloseOnCompletion() throws SQLException {
		return false;
	}

	/* (non-Javadoc)
	 * @see java.sql.Wrapper#unwrap(java.lang.Class)
	 */
	public Object unwrap(Class arg0) throws SQLException {
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see java.sql.Wrapper#isWrapperFor(java.lang.Class)
	 */
	public boolean isWrapperFor(Class arg0) throws SQLException {
		// TODO Auto-generated method stub
		return false;
	}	
}