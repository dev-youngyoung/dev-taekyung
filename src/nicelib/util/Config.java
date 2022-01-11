package nicelib.util;

import java.util.Enumeration;
import java.util.Hashtable;

import javax.servlet.GenericServlet;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import procure.common.conf.Startup;

public class Config extends GenericServlet {
	
	private static String docRoot=Startup.conf.getString("nicelib.document_root");
	private static String tplRoot;
	private static String dataDir;
	private static String logDir;
	private static String webUrl = Startup.conf.getString("domain");
	private static String jndi = Startup.conf.getString("db.datasource");
	private static String queryFormat =  Startup.conf.getString("db.queryformat");
	private static String queryDelimiter = "$";
	private static String mailHost = Startup.conf.getString("email.mailHost"); // smtp.nsgportal.net
	private static String mailFrom = Startup.conf.getString("email.mailFrom"); // ecs@nongshim.com
	private static String approvalAction = Startup.conf.getString("approval.action");
	private static String approvalUrl = Startup.conf.getString("approval.url");
	private static String approvalDocumentType = Startup.conf.getString("approval.documentType");
	private static String approvalCreateSystem = Startup.conf.getString("approval.createSystem");
	private static String approvalCreateServer = Startup.conf.getString("approval.createServer");
	private static String approvalSystemCd = Startup.conf.getString("approval.systemCd");
	private static String secretId = "nicednb-23ywx-20x05-s7399";
	private static String was = "weblogic";
	private static String encoding = "UTF-8";
	private static Hashtable data = new Hashtable();

	public void init() throws ServletException {
		ServletContext sc = getServletContext();

		//docRoot = sc.getRealPath("/").replace('\\', '/');
		tplRoot = docRoot + "/html";
		dataDir = docRoot + "/data";
		logDir = dataDir + "/log";

		Enumeration e = sc.getInitParameterNames();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			data.put(key, sc.getInitParameter(key));
		}
		
		if (data.containsKey("docRoot")) docRoot = get("docRoot");
		if (data.containsKey("webUrl")) webUrl = get("webUrl");
		if (data.containsKey("tplRoot")) tplRoot = get("tplRoot");
		if (data.containsKey("dataDir")) dataDir = get("dataDir");
		if (data.containsKey("logDir")) logDir = get("logDir");
		if (data.containsKey("jndi")) jndi = get("jndi");
		if (data.containsKey("mailHost")) mailHost = get("mailHost");
		if (data.containsKey("mailFrom")) mailFrom = get("mailFrom");
		if (data.containsKey("was")) was = get("was");
		if (data.containsKey("encoding")) encoding = get("encoding");
		if (data.containsKey("secretId")) secretId = get("secretId");
		if (data.containsKey("approvalAction")) approvalAction = get("approvalAction");
		if (data.containsKey("approvalUrl")) approvalUrl = get("approvalUrl");
		if (data.containsKey("approvalDocumentType")) approvalDocumentType = get("approvalDocumentType");
		if (data.containsKey("approvalCreateSystem")) approvalCreateSystem = get("approvalCreateSystem");
		if (data.containsKey("approvalCreateServer")) approvalCreateServer = get("approvalCreateServer");
		if (data.containsKey("approvalSystemCd")) approvalSystemCd = get("approvalSystemCd");
	}

	public void service(ServletRequest req, ServletResponse res) throws ServletException {

	}

	public static String getSecretId() {
		return secretId;
	}

	public static String getDocRoot() {
		return docRoot;
	}

	public static String getWebUrl() {
		return webUrl;
	}

	public static String getTplRoot() {
		return tplRoot;
	}

	public static String getDataDir() {
		return dataDir;
	}
	
	public static String getLogDir() {
		return logDir;
	}

	public static String getJndi() {
		return jndi;
	}
	
	public static String getQueryDelimiter(){
		return queryDelimiter;
	}
	
	public static String getQueryFormat(){
		return queryFormat;
	}

	public static String getMailHost() {
		return mailHost;
	}
	
	public static String getMailFrom() {
		return mailFrom;
	}

	public static String getWas() {
		return was;
	}

	public static String getEncoding() {
		return encoding;
	}
	
	public static String getApprovalAction() {
		return approvalAction;
	}

	public static String getApprovalUrl() {
		return approvalUrl;
	}

	public static String getApprovalDocumentType() {
		return approvalDocumentType;
	}

	public static String getApprovalCreateSystem() {
		return approvalCreateSystem;
	}

	public static String getApprovalCreateServer() {
		return approvalCreateServer;
	}

	public static String getApprovalSystemCd() {
		return approvalSystemCd;
	}

	public static void set(String key, String value) {
		data.put(key, value);
	}

	public static String get(String key) {
		return (String)data.get(key);
	}

}