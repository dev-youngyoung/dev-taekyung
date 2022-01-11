package nicelib.util;

import java.io.*;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.net.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.JspWriter;

import javax.mail.*;
import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;
import javax.mail.internet.*;
import javax.activation.FileDataSource;
import javax.activation.DataHandler;
import javax.naming.*;
import javax.naming.directory.*;

import nicelib.db.*;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.Image;
import javax.swing.ImageIcon;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import procure.common.utils.Security;

public class Util {

	public String secretId = "sdhflsdhflsdxxx";
	public String cookieDomain = null;
	public static String logDir = null;
	public static String dataDir = null;
	public static String webUrl = null;
	public static String encoding = "UTF-8";

	// 실서버용(데이터)
	public String mailFrom = Config.getMailFrom(); // ecs@nongshim.com
	public String mailHost = Config.getMailHost(); // smtp.nsgportal.net
	public String mailPassword = "ecsEcs1@";

	private HttpServletRequest request;
	private HttpServletResponse response;
	private HttpSession session;
	private JspWriter out;

	public Util(HttpServletRequest request, HttpServletResponse response, JspWriter out) {
		this.request = request;
		this.response = response;
		this.out = out;
		this.session = request.getSession();
		
		this.logDir = Config.getLogDir();
		this.dataDir = Config.getDataDir();
		this.webUrl = Config.getWebUrl();
		this.encoding = Config.getEncoding();
	}

	public String qstr(String str) {
		return replace(str, "'", "''");
	}

	public String request(String name) {
		return request(name, "");
	}

	public String requestDecode(String name, String decode) {
		return requestDecode(name, decode, "");
	}
	
	public String requestDecode(String name, String decode, String str) {
		
		String value;
		try {
			value = URLDecoder.decode(request.getParameter(name), decode);
		} catch (UnsupportedEncodingException e) {
			return str;
		}
		if(value == null) {
			return str;
		} else {
			//return value.replace('\'', '`');
			return value;
		}
	}
	public String request(String name, String str) {
		String value = request.getParameter(name);
		if(value == null) {
			return str;
		} else {
			return value.replace('\'', '`');
		}
	}

	public String request_n(String name) {
		String value = request.getParameter(name);
		if(Pattern.matches("^[0-9]+$", value)){
			return value;
		}else{
			return "";
		}
	}
	
	public String reqSql(String name) {
		return replace(request(name, ""), "'", "''");
	}

	public String reqSql(String name, String str) {
		return replace(request(name, str), "'", "''");
	}

	public String[] reqArr(String name) {
		return request.getParameterValues(name);
	}

	public String reqEnum(String name, String[] arr) {
		if(arr == null) return null;
		String str = request(name);
		for(int i=0; i<arr.length; i++) {
			if(arr[i].equals(str)) return arr[i];
		}
		return arr[0];
	}

	public int reqInt(String name) {
		return reqInt(name, 0);
	}

	public int reqInt(String name, int i) {
		String str = request(name, i + "");
		if(str.matches("^-?[0-9]+$")) return Integer.parseInt(str);
		else return i;
	}

	public static int parseInt(String str) {
		if(str != null && str.matches("^-?[0-9]+$")) return Integer.parseInt(str);
		else return 0;
	}
	
	public static long parseLong(String str) {
		if(str != null && str.matches("^-?[0-9]+$")) return Long.parseLong(str);
		else return 0;
	}

	public Hashtable reqMap(String name) {
		Hashtable map = new Hashtable();
		int len = name.length();
		try {
			Enumeration e = request.getParameterNames();
			while(e.hasMoreElements()) {
				String key = (String)e.nextElement();
				if(key.matches("^(" + name + ")(.+)$")) {
					map.put(key.substring(len), request.getParameter(key));
				}
			}
		} catch(Exception ex) {}
		return map;
	}

	public void redirect(String url) {
		try {
			response.sendRedirect(url);
		} catch(Exception e) {
			jsReplace(url);
		}
	}

	public boolean isPost() {
		if("POST".equals(request.getMethod())) {
			return true;
		} else {
			return false;
		}
	}

	public void jsAlert(String msg) {
		try {
			out.print("<script>alert('" + msg + "');</script>");
		} catch(Exception e) {}
	}
	
	public void jsAlertReplace(String msg, String url){
		try{
			jsAlert(msg);
			jsReplace(url);
		}catch(Exception e){}
	}
	
	public void jsError(String msg) {
		try {
			out.print("<script>alert('" + msg + "');history.go(-1)</script>");
		} catch(Exception e) {}
	}

	public void jsError(String msg, String target) {
		try {
			out.print("<script>alert('" + msg + "');" + target + ".location.href = " + target + ".location.href;</script>");
		} catch(Exception e) {}
	}

	public void jsErrClose(String msg) {
		try {
			out.print("<script>alert('" + msg + "');window.close()</script>");
		} catch(Exception e) {}
	}

	public void jsReplace(String url) {
		jsReplace(url, "window");
	}

	public void jsReplace(String url, String target) {
		try {
			out.print("<script>"+ target +".location.replace('" + url + "');</script>");
		} catch(Exception e) {}
	}

	// Get Cookie
	public String getCookie(String s) throws Exception {
		Cookie[] cookie = request.getCookies();
		if(cookie == null) return "";
		for(int i = 0; i < cookie.length; i++) {
			if(s.equals(cookie[i].getName())) {
				String value = URLDecoder.decode(cookie[i].getValue(), encoding);
				return value;
			}
		}
		return "";
	}

	// Set Cookie
	public void setCookie(String name, String value) throws Exception {
		Cookie cookie = new Cookie(name, URLEncoder.encode(value, encoding));
		if(cookieDomain != null) cookie.setDomain(cookieDomain);
		cookie.setPath("/");
		response.addCookie(cookie);
	}

	public void setCookie(String name, String value, int time) throws Exception {
		Cookie cookie = new Cookie(name, URLEncoder.encode(value, encoding));
		if(cookieDomain != null) cookie.setDomain(cookieDomain);
		cookie.setPath("/");
		cookie.setMaxAge(time);
		response.addCookie(cookie);
	}

	// Delete Cookie
	public void delCookie(String name) {
		Cookie cookie = new Cookie(name, "");
		if(cookieDomain != null) cookie.setDomain(cookieDomain);
		cookie.setPath("/");
		cookie.setMaxAge(-1);
		response.addCookie(cookie);
	}

	// Get Session
	public String getSession(String s) {
		Object obj = session.getAttribute(s);
		if(obj == null) return "";
		return (String)obj;
	}

	// Set Session
	public void setSession(String name, String value) {
		session.setAttribute(name, value);
	}

	// Set Session
	public void setSession(String name, int value) {
		session.setAttribute(name, ""+value);
	}

	public static String getTimeString() {
		return getTimeString("yyyyMMddHHmmss");
		//return getTimeString("yyyy-MM-dd HH:mm:ss");
	}

	// Get DateTime String
	public static String getTimeString(String sformat) {
		SimpleDateFormat sdf = new SimpleDateFormat(sformat);
		return sdf.format((new GregorianCalendar()).getTime());
	}

	// Get DateTime String
	public static String getTimeString(String sformat, Date date) {
		SimpleDateFormat sdf = new SimpleDateFormat(sformat);
		if(sdf == null || date == null) return "";
		return sdf.format(date);
	}

	// Get DateTime String
	public static String getTimeString(String sformat, String date) {
		Date d = strToDate(date.trim());
		SimpleDateFormat sdf = new SimpleDateFormat(sformat);
		if(sdf == null || d == null) return "";
		return sdf.format(d);
	}

	public static Date addDate(String type, int amount) {
		return addDate(type, amount, new Date());
	}

	public static Date addDate(String type, int amount, Date d) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(d);
		type = type.toUpperCase();
		if(type.equals("Y")) cal.add(cal.YEAR, amount);
		else if(type.equals("M")) cal.add(cal.MONTH, amount);
		else if(type.equals("W")) cal.add(cal.WEEK_OF_YEAR, amount);
		else if(type.equals("D")) cal.add(cal.DAY_OF_MONTH, amount);
		else if(type.equals("H")) cal.add(cal.HOUR_OF_DAY, amount);
		else if(type.equals("I")) cal.add(cal.MINUTE, amount);
		else if(type.equals("S")) cal.add(cal.SECOND, amount);
		return cal.getTime();
	}

	public static String addDate(String type, int amount, Date d, String format) {
		return getTimeString(format, addDate(type, amount, d));
	}

	public static Date strToDate(String format, String source, Locale loc) {
		SimpleDateFormat sdf = new SimpleDateFormat(format, loc);
		Date d = null;
		try {
			d = sdf.parse(source);
		} catch (Exception e) {}
		return d;
	}

	public static Date strToDate(String format, String source) {
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date d = null;
		try {
			d = sdf.parse(source);
		} catch (Exception e) {}
		return d;
	}

	public static Date strToDate(String source) {
		String format = "yyyyMMddHHmmss";

		if(source.matches("^[0-9]{8}$")) format = "yyyyMMdd";
		else if(source.matches("^[0-9]{14}$")) format = "yyyyMMddHHmmss";
		else if(source.matches("^[0-9]{4}-[0-9]{2}-[0-9]{2}$")) format = "yyyy-MM-dd";
		else if(source.matches("^[0-9]{4}-[0-9]{2}-[0-9]{2}$ [0-9]{2}:[0-9]{2}")) format = "yyyy-MM-dd HH:mm";
		else if(source.matches("^[0-9]{4}-[0-9]{2}-[0-9]{2}$ [0-9]{2}:[0-9]{2}:[0-9]{2}")) format = "yyyy-MM-dd HH:mm:ss";

		SimpleDateFormat sdf = new SimpleDateFormat(format);
		Date d = null;
		try {
			d = sdf.parse(source);
		} catch (Exception e) {}
		return d;
	}

	public static double getPercent(int cnt, int total) {
		if(total <= 0) return 0.0;
		return Math.round(((double)cnt / (double)total) * 100);
	}

	public static String md5(String str) {
        StringBuffer buf = new StringBuffer();
        try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			byte[] data = new byte[32];
			md.update(str.getBytes(), 0, str.length());
			data = md.digest();

			for (int i = 0; i < data.length; i++) {
				int halfbyte = (data[i] >>> 4) & 0x0F;
				int two_halfs = 0;
				do {
					if ((0 <= halfbyte) && (halfbyte <= 9))
						buf.append((char) ('0' + halfbyte));
					else
						buf.append((char) ('a' + (halfbyte - 10)));
					halfbyte = data[i] & 0x0F;
				} while(two_halfs++ < 1);
			}
        } catch (Exception e) {}
        return buf.toString();
    }
	
	/**
     * sha256 암호화
     * @param src
     * @return
     */
    public static String sha256(String src)
    {
    	String	sRtnVal	=	"";
    	try {
    		MessageDigest sha256 = null;
			sha256 = MessageDigest.getInstance("SHA-256");
			
			byte[] b	=	sha256.digest(src.getBytes());
			StringBuffer	sb	=	new	StringBuffer();
			String			_s	=	"";	
			for(int i=0; i < b.length; i++)
			{
				_s = Integer.toHexString((int)b[i] & 0x000000ff);
				if(_s.length()<2)
				{
					_s = "0"+_s;
				}
				sb.append(_s);
			}
			sRtnVal	=	sb.toString();
		} catch (NoSuchAlgorithmException e) {
			System.out.println("[ERROR Util.java]:"+e.toString());
		}
		return	sRtnVal;
    }

	public static String sha1(String str) {
        StringBuffer buf = new StringBuffer();
        try {
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			byte[] data = new byte[40];
			md.update(str.getBytes("iso-8859-1"), 0, str.length());
			data = md.digest();

			for (int i = 0; i < data.length; i++) {
				int halfbyte = (data[i] >>> 4) & 0x0F;
				int two_halfs = 0;
				do {
					if ((0 <= halfbyte) && (halfbyte <= 9))
						buf.append((char) ('0' + halfbyte));
					else
						buf.append((char) ('a' + (halfbyte - 10)));
					halfbyte = data[i] & 0x0F;
				} while(two_halfs++ < 1);
			}
        } catch (Exception e) {}
        return buf.toString();
    }

	public static String getFileExt(String filename) {
		int i = filename.lastIndexOf(".");
		if(i == -1) return "";
		else return filename.substring(i+1);
	}

	public static String getUploadUrl(String filename) {
		if("".equals(filename)) return "noimg";
		String ext = getFileExt(filename);
		if("jsp".equals(ext.toLowerCase())) ext = "xxx";
		String md5name = md5(filename + "sdhflsdhflsdxxx") + "." + ext;
		return webUrl + "/data/file/" + md5name.substring(0, 2) + "/" + md5name;
	}

	public static String getUploadPath(String filename) {
		String ext = getFileExt(filename);
		if("jsp".equals(ext.toLowerCase())) ext = "xxx";
		String md5name = md5(filename + "sdhflsdhflsdxxx") + "." + ext;
		return dataDir + "/file/" + md5name.substring(0, 2) + "/" + md5name;
	}
	
	public static String getUploadFileName(String filename) {
		String ext = getFileExt(filename);
		if("jsp".equals(ext.toLowerCase())) ext = "xxx";
		String timeFileName = getTimeString("yyyyMMddHHmmsss")+ "." + ext;
		return timeFileName;
	}

	public String getQueryString(String exception) {
		String query = "";
		if(null != request.getQueryString()) {
			String	sParam	=	request.getQueryString();
			sParam	=	sParam.replaceAll("\\&\\?", "\\&");
			sParam	=	sParam.replaceAll("\\?", "");
			
			String[] exceptions = exception.replaceAll(" +", "").split("\\,");
			String[] queries = sParam.split("\\&");

			for(int i=0; i<queries.length; i++) {
				String[] attributes = queries[i].split("\\=");
				if(attributes.length > 0 && inArray(attributes[0], exceptions)) continue;
				query += "&" + queries[i];
			}
		}

		return query.length() > 0 ? query.substring(1) : "";
	}

	public String getQueryString() {
		return getQueryString("");
	}

	public String getThisURI() {
		String uri = request.getRequestURI();
		String query = request.getQueryString();
		String thisuri = "";

		if(query == null) thisuri = uri;
		else thisuri = uri + "?" + query;

		return thisuri;
	}

	public void log(String prefix, String msg) throws Exception {
		FileWriter logger = new FileWriter(logDir + "/" + prefix + "-" + getTimeString("yyyyMMdd") + ".log", true);
		logger.write("["+getTimeString("yyyy-MM-dd HH:mm:ss")+"] "+request.getRemoteAddr()+" : "+getThisURI()+"\n"+msg+"\n");
		logger.close();
	}

	public static void log(String msg) throws Exception {
		FileWriter logger = new FileWriter(logDir + "/debug-" + getTimeString("yyyyMMdd") + ".log", true);
		logger.write("["+getTimeString("yyyy-MM-dd HH:mm:ss")+"] "+ msg +"\n");
		logger.close();
	}

	public String getMX(String domain) throws Exception {
		Hashtable env = new Hashtable();
		env.put("java.naming.factory.initial", "com.sun.jndi.dns.DnsContextFactory");
		DirContext ictx = new InitialDirContext(env);
		Attributes attrs = ictx.getAttributes(domain, new String[] { "MX" });
		Attribute attr = attrs.get("MX");

		if (( attr == null ) || ( attr.size() == 0 )) {
			attrs = ictx.getAttributes(domain, new String[] { "A" });
			attr = attrs.get("A");
			if( attr == null )
			throw new Exception( "No match for name '" + domain + "'" );
		}

		String x = (String)attr.get(0);
		String[] f = x.split(" ");
		if(f[1].endsWith(".")) f[1] = f[1].substring(0, (f[1].length() - 1));

		return f[1];
	}

	// Send Mail
	public void mail(String mailTo, String subject, String body) throws Exception {
		mail(mailTo, subject, body, null);
	}

	public void mail(String mailTo, String subject, String body, String[] filepath) {
		System.out.println("[Util][mail] START");
		
		try {
			String sHostName = InetAddress.getLocalHost().getHostName();
			System.out.println("[Util][mail] sHostName : " + sHostName);
			
			/*if (sHostName.equals("docu01") || sHostName.equals("docu02")) { // 실서버만 메일발송
				System.out.println("//-------------------- [MAIL SEND] --------------------//");
				System.out.println("  - 받는 사람 : " + mailTo);
				System.out.println("  - 제      목 : " + subject);
				System.out.println("//--------------------------------------------------//");
			} else {
				System.out.println("//-------------------- [가상 이메일전송:개발용] --------------------//");
				System.out.println("  - 받는 사람 : " + mailTo);
				System.out.println("  - 제      목 : " + subject);
				System.out.println(body);
				System.out.println("//--------------------------------------------------//");
				return;
			}*/
			
			if (mailHost == null) {
				String[] arr = mailTo.split("@");
				mailHost = getMX(replace(arr[1], ">", ""));
			}
			System.out.println("[Util][mail] mailHost : " + mailHost);

			Properties props = System.getProperties();
			props.put("mail.smtp.host", mailHost);
			props.put("mail.smtp.auth", "true");

			System.out.println("[Util][mail] mailFrom : " + mailFrom);
			Session msgSession = Session.getDefaultInstance(props, new Authenticator() {
				protected PasswordAuthentication getPasswordAuthentication() {
					return new PasswordAuthentication(mailFrom, mailPassword);
				}
			});
			
			System.out.println("[Util][mail] mailTo : " + mailTo);
			MimeMessage msg = new MimeMessage(msgSession);
			InternetAddress from = new InternetAddress(mailFrom, "농심", "UTF-8");
			InternetAddress to = new InternetAddress(mailTo);
			
			System.out.println("[Util][mail] subject : " + subject);
			msg.setFrom(from);
			msg.setRecipient(Message.RecipientType.TO, to);
			msg.setSubject(subject, "UTF-8");
			msg.setSentDate(new Date());
			
			if (filepath == null || filepath.length == 0) {
				msg.setContent(body, "text/html; charset=" + encoding);
			} else {
				MimeBodyPart mbp1 = new MimeBodyPart();
				mbp1.setContent(body, "text/html; charset=" + encoding);
				
				Multipart mp = new MimeMultipart();
				mp.addBodyPart(mbp1);
				
				for (String path : filepath) {
					System.out.println("[Util][mail] path : " + path);
					MimeBodyPart mbp2 = new MimeBodyPart();
					
					FileDataSource fds = new FileDataSource(path);
					mbp2.setDataHandler(new DataHandler(fds));
					//mbp2.setFileName(fds.getName());
					mbp2.setFileName(new String(fds.getName().getBytes("KSC5601"), "8859_1"));
					
					mp.addBodyPart(mbp2);
				}

				msg.setContent(mp);
			}
			Transport.send(msg);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
	}

	// Send Mail
	public void mail_apt(String mailTo, String subject, String body) throws Exception {
		mail_apt(mailTo, subject, body, null);
	}
	
	public void mail_apt(String mailTo, String subject, String body, String filepath) throws Exception {
		String sHostName;
		sHostName = InetAddress.getLocalHost().getHostName();
		if(!sHostName.equals("docu01") && !sHostName.equals("docu02")) // 실서버만 sms 보냄
		{
			System.out.println("//-------------------- [가상 이메일전송:개발용] --------------------//");
			System.out.println("  - 받는 사람 : " + mailTo);
			System.out.println("//--------------------------------------------------//");
			return;
		}
		
		if(mailHost == null) {
			String[] arr = mailTo.split("@");
			mailHost = getMX(replace(arr[1], ">", ""));
		}
		
		Properties props = System.getProperties();
		props.put("mail.smtp.host", mailHost);
		
		Session msgSession = Session.getDefaultInstance(props, null);
		
		MimeMessage msg = new MimeMessage(msgSession);
		InternetAddress from = new InternetAddress(mailFrom, "나이스 아파트", "UTF-8");
		InternetAddress to = new InternetAddress(mailTo);
		
		msg.setFrom(from);
		msg.setRecipient(Message.RecipientType.TO, to);
		msg.setSubject(subject, "UTF-8");
		msg.setSentDate(new Date());
		
		if(filepath == null) {
			msg.setContent(body, "text/html; charset=" + encoding);
		} else {
			MimeBodyPart mbp1 = new MimeBodyPart();
			mbp1.setContent(body, "text/html; charset=" + encoding);
			MimeBodyPart mbp2 = new MimeBodyPart();
			
			FileDataSource fds = new FileDataSource(filepath);
			mbp2.setDataHandler(new DataHandler(fds));
			mbp2.setFileName(fds.getName());
			
			Multipart mp = new MimeMultipart();
			mp.addBodyPart(mbp1);
			mp.addBodyPart(mbp2);
			
			msg.setContent(mp);
		}
		
		Transport.send(msg);
	}	
	
	// Get Unique ID
	public static String getUniqId() {
		String chars = "abcdefghijklmonpqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
		Random r = new Random();
		char[] buf = new char[10];
		for (int i = 0; i < buf.length; i++) {
			buf[i] = chars.charAt(r.nextInt(chars.length()));
		}
		return new String(buf);
	}

	public static String repeatString(String src, int repeat) {
		StringBuffer buf=new StringBuffer();
		for (int i=0; i<repeat; i++) {
			buf.append(src);
		}
		return buf.toString();
	}

	public static String cutString(String str, int len) throws Exception {
		try  {
			byte[] by = str.getBytes("KSC5601");
			if(by.length <= len) return str;
			int count = 0;
			for(int i = 0; i < len; i++) {
				if((by[i] & 0x80) == 0x80) count++;
			}
			if((by[len - 1] & 0x80) == 0x80 && (count % 2) == 1) len--;
			len = len - (int)(count / 2);
			return str.substring(0, len) + "...";
		} catch(Exception e) {
			return "";
		}
	}

	public static boolean inArray(String str, String[] array) {
		if(str != null && array != null) {
			for(int i=0; i<array.length; i++) {
				if(str.equals(array[i])) return true;
			}
		}
		return false;
	}

	public static String join(String str, Object[] array) {
		if(str != null && array != null) {
			StringBuffer sb = new StringBuffer();
			for(int i=0; i<array.length; i++) {
				sb.append(array[i].toString());
				if(i < (array.length - 1)) sb.append(str);
			}
			return sb.toString();
		}
		return "";
	}

	public static DataSet arr2loop(String[] arr) {
		return arr2loop(arr, false);
	}

	public static DataSet arr2loop(String[] arr, boolean empty) {
		DataSet result = new DataSet();
		for(int i=0; i<arr.length; i++) {
			//String[] tmp = arr[i].split("=>");
			String[] tmp = split("=>", arr[i], 2);
			String id = tmp[0].trim();
			String value = (tmp.length > 1 ? tmp[1] : (empty ? "" : tmp[0])).trim();
			result.addRow();
			result.put("id", id);
			result.put("value", value);
			result.put("name", value);
			result.put("__last", i == arr.length - 1 ? "true" : "false");
			result.put("__idx", i + 1);
			result.put("__ord", arr.length - i);
		}
		result.first();
		return result;
	}

	public static DataSet arr2loop(Hashtable map) {
		DataSet result = new DataSet();
		Enumeration e = map.keys();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			String value = map.get(key) != null ? map.get(key).toString() : "";

			result.addRow();
			result.put("id", key);
			result.put("value", value);
			result.put("name", value);
		}
		result.first();
		return result;
	}
	
	public static String loop2json(DataSet ds){
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		int i = 0 ;
		ds.first();
		while(ds.next()){
			if(i!=0)sb.append(",");
			sb.append("{");
			Hashtable map = ds.getRow();
			Enumeration e = map.keys();
			int j = 0 ;
			while(e.hasMoreElements()) {
				String key = (String)e.nextElement();
				String value = "";
				boolean isDataSet = false;
				if(map.get(key) != null){
					if(map.get(key).getClass().toString().indexOf("DataSet") > -1 || map.get(key).getClass().toString().indexOf("RecordSet") > -1 ){
						isDataSet = true;
						DataSet temp = (DataSet)map.get(key);
							value = loop2json(temp);
					}else{
						value = map.get(key).toString();
					}
				}
				if(j!=0)sb.append(",");
				if(isDataSet){
					sb.append("\""+key.replaceAll("\\.", "")+"\"");
					sb.append(":");
					sb.append(value);
				}else{
					sb.append("\""+key+"\"");
					sb.append(":");
					sb.append("\""+value.replaceAll("\"", "\\\\\"").replaceAll("\\r\\n", "").replaceAll("\n", "")+"\"");
				}
				
				j++;
			}
			sb.append("}");
			i++;
		}
		sb.append("]");
		return sb.toString(); 
	}
	
	public static DataSet json2Dataset(String jsonstr){
		DataSet ds = new DataSet();
		
		if(jsonstr.equals(""))return ds;
		if(!jsonstr.startsWith("[")) jsonstr = "["+jsonstr;
		if(!jsonstr.endsWith("]")) jsonstr = jsonstr+"]";
		JSONArray jarr = JSONArray.fromObject(jsonstr);
		for(int i =0 ;i < jarr.size(); i ++){
			ds.addRow();
			JSONObject json =  jarr.getJSONObject(i);
			Iterator keys = json.keys();
			while(keys.hasNext()){
				String id = (String)keys.next();
				if(json.get(id).getClass().toString().indexOf("JSONArray")>0){
					ds.put(id, json2Dataset(json.getString(id)));
				}else{
					ds.put(id, json.getString(id));
				}
			}
		}
		ds.first();
		return ds;
	}
	
	public static DataSet grid2dataset(String jsonstr){
		DataSet ds = new DataSet();
		
		if(jsonstr.equals(""))return ds;
		
		JSONArray jarr = JSONArray.fromObject(jsonstr);
		for(int i =0 ;i < jarr.size(); i ++){
			ds.addRow();
			JSONObject json =  jarr.getJSONObject(i);
			Iterator keys = json.keys();
			while(keys.hasNext()){
				String id = (String)keys.next();
				if(json.get(id).getClass().toString().indexOf("JSONArray")>0){
					ds.put(id, grid2dataset(json.getString(id)));
				}else{
					ds.put(id, json.getString(id));
				}
			}
		}
		ds.first();
		return ds;
	}

	public static String getItem(int item, String[] arr) {
		return getItem(item + "", arr);
	}

	public static String getItem(String item, String[] arr) {
		for(int i=0; i<arr.length; i++) {
			String[] tmp = split("=>", arr[i], 2);
			String id = tmp[0].trim();
			String value = (tmp.length > 1 ? tmp[1] : tmp[0]).trim();
			if(id.equals(item)) return value;
		}
		return "";
	}

	public static String getItems(String item, String[] arr) {
		String sRet = "";
		String[] items = null;

		if(item.equals("")) return "";
		if(item.indexOf(',')<0) {
			items = new String[1];
			items[0] = item;
		} else {
			items = item.split(",");
		}

		for(int j=0; j<items.length; j++) {
			for(int i=0; i<arr.length; i++) {
				String[] tmp = arr[i].split("=>");
				String id = tmp[0].trim();
				String value = (tmp.length > 1 ? tmp[1] : tmp[0]).trim();
				if(id.equals(items[j])) {
					if(sRet.length()>0) sRet+=",";
					sRet += value;
				}
			}
		}
		return sRet;
	}

	public static String getItem(int item, Hashtable map) {
		return getItem(item + "", map);
	}

	public static String getItem(String item, Hashtable map) {
		Enumeration e = map.keys();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			String value = map.get(key) != null ? map.get(key).toString() : "";
			if(key.equals(item)) return value;
		}
		return "";
	} 

	public static String[] getItemKeys(String[] arr) {
		String[] data = new String[arr.length];
		for(int i=0; i<arr.length; i++) {
			String[] tmp = arr[i].split("=>");
			String id = tmp[0].trim();
			data[i] = id;
		}
		return data;
	}

	public void download(String path, String filename) throws Exception {

		File f = new File(path);
		if(f.exists()){

			try {

				response.setContentType( "application/octet-stream;" );
				response.setContentLength( (int)f.length() );
				response.setHeader( "Content-Disposition", "attachment; filename=\"" + new String(filename.getBytes("KSC5601"),"8859_1") + "\"" );
			//	response.setHeader( "Content-Disposition", "attachment; filename=\"" + filename + "\"" );

				byte[] bbuf = new byte[2048];

				BufferedInputStream fin = new BufferedInputStream(new FileInputStream(f));
				BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());

				int read = 0;
				while ((read = fin.read(bbuf)) != -1){
					outs.write(bbuf, 0, read);
				}

				outs.close();
				fin.close();

			} catch(Exception e) {
				response.setContentType("text/html");
				out.println("File Download Error : "+e.getMessage());
			}
		} else {
			response.setContentType("text/html");
			out.println("File Not Found : " + path);
		}

	}

	public static String iconv(String in, String out, String str) throws Exception {
		return new String(str.getBytes(in), out);
	}

	public static String readFile(String path) throws Exception {
		File f = new File(path);
		if(f.exists()) {

			FileInputStream fin = new FileInputStream(f);
			Reader reader = new InputStreamReader(fin, encoding);
			BufferedReader br = new BufferedReader(reader);

			char[] chars = new char[(int) f.length()];
			br.read(chars);
			br.close();

			return new String(chars);
		} else {
			return "";
		}
	}

	public static void copyFile(String source, String target) throws Exception {
		copyFile(new File(source), new File(target));
	}

	public static void copyFile(File source, File target) throws Exception {
		if(source.isDirectory()){
			if(!target.isDirectory()){
				target.mkdirs();
			}
			String[] children  = source.list();
			for(int i=0; i<children.length; i++){
				copyFile(new File(source, children[i]),new File(target, children[i]));
			}
		}else{
			
			int bufferSize = 8192;//(64 * 1024 * 1024) - (32 * 1024);
			
			ScatteringByteChannel inChannel = new FileInputStream(source).getChannel();
			GatheringByteChannel outChannel = new FileOutputStream(target).getChannel();
			try {
				ByteBuffer byteBuffer = ByteBuffer.allocateDirect(bufferSize);
				while (inChannel.read(byteBuffer) != -1) {
					byteBuffer.flip(); 
					outChannel.write(byteBuffer); 
					byteBuffer.clear(); 
				}
			}catch (Exception e) {
				throw e;
			}finally {
				if (inChannel != null)
					inChannel.close();
				if (outChannel != null)
					outChannel.close();
			}
			

			/*System.out.println("--------start:"+getTimeString("yyyy-MM-dd HH:mm:ss")+"-------");
			FileChannel inChannel = new FileInputStream(source).getChannel();
			FileChannel outChannel = new FileOutputStream(target).getChannel();
			try {
				// magic number for Windows, 64Mb - 32Kb
				int maxCount = (64 * 1024 * 1024) - (32 * 1024);
				long size = inChannel.size();
				long position = 0;
				while (position < size) {
					position += inChannel.transferTo(position, maxCount, outChannel);
				}
			} catch (IOException e) {
				throw e;
			} finally {
				if (inChannel != null)
					inChannel.close();
				if (outChannel != null)
					outChannel.close();
			}
			System.out.println("--------end:"+getTimeString("yyyy-MM-dd HH:mm:ss")+"-------");*/
			
		}
	}

	public static void delFile(String path) throws Exception {
		File f = new File(path);
		if(f.exists()) {
			if(f.isDirectory()) {
				File[] files = f.listFiles();
				for(int i=0; i<files.length; i++) delFile(path + "/" + files[i].getName());
			}
			f.delete();
		} else {
			System.out.print(path + " is not found");
		}
	}
	
	/***************************
		파일정리
	***************************/
	public static void adjFile(String path, ArrayList al)
	{		
		ArrayList	aServFile	=	null;
		ArrayList	aTF			=	null;
		File f = new File(path); 

		if(f.exists()) 
		{
			if(f.isDirectory()) 
			{			
				File[] files = f.listFiles();
				
				if(files != null && files.length > 0)
				{
					aServFile	=	new	ArrayList(); 
					
					for(int i=0; i<files.length; i++)
					{
						if(files[i].isFile())
						{
							aServFile.add(files[i].getName());
						}
					}
				}
			}
		}
		
		if(aServFile != null && aServFile.size() > 0)
		{
			aTF	=	new	ArrayList();
			if(al != null && al.size() > 0)
			{
				boolean	bChk	=	true;
				for(int i=0; i < aServFile.size(); i++)
				{
					bChk	=	true;
					for(int j=0; j < al.size(); j++)
					{
						if(aServFile.get(i).toString().equals(al.get(j).toString()))
						{
							bChk	=	false;
							break;
						}
					}
					aTF.add(bChk);
				}
			}else
			{
				for(int i=0; i < aServFile.size(); i++)
				{
					aTF.add(true);
				}
			}
		}
		
		if(aServFile != null && aTF != null && (aServFile.size() == aTF.size()))
		{
			for(int i=0; i < aServFile.size(); i++)
			{
				if((Boolean)aTF.get(i))
				{
					File	delFile	=	new	File(path + "/" + aServFile.get(i).toString());
					delFile.delete();
				}
			}
		}
	}  

	public int getRandInt(int start, int count) {
		Random r = new Random();
		return start + r.nextInt(count);
	}
	
	public String getRandString(int len) {
		String random_string = "";
		String pattern = "[a-zA-Z0-9]+$";
		Random r = new Random();
		
		while(random_string.length()<len) {
			int rnd = r.nextInt(1000);
			String r_str = String.valueOf((char)rnd);
			Pattern p = Pattern.compile(pattern);
			Matcher m = p.matcher(r_str);
			if(!m.matches()) continue;
			random_string += String.valueOf((char)rnd);	
		}
		return random_string;
	}

	public int getUnixTime() {
		Date d = new Date();
		return (int)(d.getTime() / 1000);
	}

	public String urlencode(String url) throws Exception {
		return URLEncoder.encode(url, encoding);
	}

	public String urldecode(String url) throws Exception {
		return URLDecoder.decode(url, encoding);
	}

	public Hashtable strToMap(String str) {
		return this.strToMap(str, "");
	}

	public Hashtable strToMap(String str, String prefix) {
		Hashtable h = new Hashtable();
		if(str == null) return h;

		StringTokenizer token = new StringTokenizer(str, ",");
		while(token.hasMoreTokens()) {
			String subtoken = token.nextToken();
			int idx = subtoken.indexOf(":");
			if(idx != -1) {
				h.put(prefix + subtoken.substring(0, idx), replace(replace(subtoken.substring(idx + 1), "%3A", ":"), "%2C", ",")); 
			}
		}
		return h;
	}

	public String mapToString(Hashtable values) {
		if(values == null) return "";
		StringBuffer sb = new StringBuffer();
		Enumeration e = values.keys();
		int i = 0;
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			String value = values.get(key) != null ? replace(replace(values.get(key).toString(), ":", "%3A"), ",", "%2C") : "";
			sb.append("," + key + ":" + value);
			i++;
		}
		if(i > 0) return sb.toString().substring(1);
		else return "";
	}
	
	public boolean serialize(String path, Object obj) {
		return serialize(new File(path), obj);	
	}

	public boolean serialize(File file, Object obj) {
		FileOutputStream f = null;
		ObjectOutput s = null;
		boolean flag = true;
		try {       
			f = new FileOutputStream(file); 
			s = new ObjectOutputStream(f);
			s.writeObject(obj); 
			s.flush(); 
		} catch(Exception e) {  
			System.out.println("[ERROR Util.java]:" + e.toString());
			flag = false;
		} finally {
			if( s != null ) try { s.close(); } catch(Exception e) { System.out.println("[ERROR Util.java]:" + e.toString()); }
			if( f != null ) try { f.close(); } catch(Exception e) { System.out.println("[ERROR Util.java]:" + e.toString()); }
		}
		return flag;
	}

	public Object unserialize(String path) {
		return unserialize(new File(path));
	}

	public Object unserialize(File file) {
		FileInputStream fis = null;
		ObjectInputStream ois = null;
		Object obj = null;
		try {
			fis = new FileInputStream(file); 
			ois = new ObjectInputStream(fis);
			obj = ois.readObject();
		} catch(Exception e) {
			System.out.println("[ERROR Util.java]:" + e.toString());
		} finally {
			if( ois != null ) try { ois.close(); } catch(Exception e) { System.out.println("[ERROR Util.java]:" + e.toString()); }
			if( fis != null ) try { fis.close(); } catch(Exception e) { System.out.println("[ERROR Util.java]:" + e.toString()); }
		}
		return obj;
	}

	public String encrypt(String prefix) {
		String key = "SDI913akfrvb";
		return md5(prefix + md5(key));
	}

	public String nl2br(String str) {
		return replace(replace(str, "\r\n", "<br>"), "\n", "<br>");
	}

	public String htmlToText(String str) {
		return nl2br(replace(replace(str, "<", "&lt;"), ">", "&gt;"));
	}

	public String stripTags(String str) {
		return replace(replace(replace(replace(str.replaceAll("<[^>]+>", ""), "\t", ""), "\r", ""), "\n", ""), "\r\n", "").trim();
	}

	public static String strpad(String input, int size, String pad) {
		int gap = size - input.getBytes().length;
		if(gap <= 0) return input;
		String output = input;
		for(int i=0; i<gap; i++) {
			output += pad;
		}
		return output;
	}
	public static String strrpad(String input, int size, String pad) {
		int gap = size - input.getBytes().length;
		if(gap <= 0) return input;
		String output = "";
		for(int i=0; i<gap; i++) {
			output += pad;
		}
		return output + input;
	}

	public static String getFileSize(long size) {
		if(size >= 1024 * 1024 * 1024) {
			return (size / (1024 * 1024 * 1024)) + "GB";
		} else if(size >= 1024 * 1024) {
			return (size / (1024 * 1024)) + "MB";
		} else if(size >= 1024) {
			return (size / 1024) + "KB";
		} else {
			return size + "B";
		}
	}

	public double round(double size, int i) {
//		size = size * ( 10 ^ i );
//		return java.lang.Math.round(size) / ( 10 ^ i );
		return Math.round(size * Math.pow(10, i)) / Math.pow(10, i);
	}

	public static String numberFormat(int n) {
		DecimalFormat df = new DecimalFormat("#,###");
		return df.format(n);
	}
	
	public static String numberFormat(long n) {
		DecimalFormat df = new DecimalFormat("#,###");
		return df.format(n);
	}

	public static String numberFormat(double n, int i) {
		String format = "#,##0";
		if(i > 0) format += "." + strpad("", i, "0");
		DecimalFormat df = new DecimalFormat(format);
		return df.format(n);
	}

	public static String numberFormat(String sNum) 
	{
		if(sNum.equals("")){
			return "";
		}
		sNum	=	sNum.replaceAll("[.]00","");
		
		String		sVal	=	"";
		String		sRtnVal	=	"";
		int			iScale	=	0;
		
		String[]	saNum	=	null;
		String		sNum1	=	"";
		String		sNum2	=	"";
		
		if(sNum.indexOf(".") != -1)
		{
			saNum	=	sNum.split("[.]");
			sNum1	=	saNum[0];	
			sNum2	=	saNum[1];
		}else
		{
			sNum1	=	sNum;
		}
		
		if(sNum2.length() > 0)
		{
			sVal	=	sNum1	+	"."	+	sNum2;
			iScale	=	sNum2.length();
			
			double	dNum	=	Double.parseDouble(sVal); 
			sRtnVal	=	Util.numberFormat(dNum, iScale);
		}else
		{
			sVal	=	sNum;
			long	lNum	=	Long.parseLong(sVal);
			sRtnVal	=	Util.numberFormat(lNum); 
		}
		return	sRtnVal;	
	}

	public void p(Object obj) throws Exception {
		out.print("<div style='border:3px solid lightgreen;margin-bottom:5px;padding:10px;font-size:12px;'>");
		if(obj != null) {
			if( obj.getClass().toString().indexOf("RecordSet") != -1 || obj.getClass().toString().indexOf("DataSet") != -1 ) {
				out.println("<pre style='text-align:left;font-size:9pt;'>");
				out.println(replace(replace(replace(replace(obj.toString(), "{", "\r\n{\n\t"), ", ", ",\r\n\t["), "}", "\r\n}"), "=", "] => "));
				out.println("</pre>");
			} else if(obj instanceof String[]){
				String[] arr = (String[])obj; 
				for(int i = 0 ; i < arr.length; i ++){
					out.println(arr[i]+"<br>");
				}
			}else  {
				out.println(obj.toString());
			}
		}else {
			out.println("NULL");
		}
		out.print("</div>"); 
	}

	public void p(int i) throws Exception {
		out.print("<div style='border:3px solid lightgreen;margin-bottom:5px;padding:10px;font-size:12px;'>");
		p("" + i);
		out.print("</div>");
	}

	public void p() throws Exception {   
		out.print("<div style='border:3px solid lightgreen;margin-bottom:5px;padding:10px;font-size:12px;'>");
		out.print("<pre style='text-align:left;font-size:9pt;'>");
		Enumeration e = request.getParameterNames();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			for(int i=0; i<request.getParameterValues(key).length; i++) {
				out.println("[" + key + "] => " + request.getParameterValues(key)[i] + "\r");
			}
		}
		out.print("</pre>");
		out.print("</div>");
	}
	
	
	public void sp(Object obj) throws Exception {
		String url = request==null?"request is null":request.getRequestURI();
		System.out.println("----START("+url+")-----------------------------------");
		if(obj != null) {
			if( obj.getClass().toString().indexOf("RecordSet") != -1 || obj.getClass().toString().indexOf("DataSet") != -1 ) {
				System.out.println("DataSet START>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
				System.out.println(replace(replace(replace(replace(obj.toString(), "{", "\r\n{\n\t"), ", ", ",\r\n\t["), "}", "\r\n}"), "=", "] => "));
				System.out.println("DataSet END>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
			} else if(obj instanceof String[]){
				String[] arr = (String[])obj; 
				for(int i = 0 ; i < arr.length; i ++){
					System.out.println(arr[i]+"\n");
				}
			}else  {
				System.out.println(obj.toString());
			}
		}else {
			System.out.println("NULL");
		}
		System.out.println("----END("+url+")-------------------------------------"); 
	}

	public void sp(int i) throws Exception {
		String url = request==null?"request is null":request.getRequestURI();
		System.out.println("----START("+url+")-----------------------------------");
		sp("" + i);
		System.out.println("----END("+url+")-------------------------------------");
	}

	public void sp() throws Exception {
		String url = request==null?"request is null":request.getRequestURI();
		System.out.println("----START("+url+")-----------------------------------");
		Enumeration e = request.getParameterNames();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			for(int i=0; i<request.getParameterValues(key).length; i++) {
				System.out.println("[" + key + "] => " + request.getParameterValues(key)[i] + "\n");
			}
		}
		System.out.println("----END("+url+")-------------------------------------");
	}

	public String getScriptDir() {
		return dirname(replace(request.getRealPath(request.getServletPath()), "\\", "/"));
	}   

	public static String dirname(String path) {
		File f = new File(path);
		return f.getParent();
	}   

	public static String[] split(String p, String str, int length) {
		String[] arr = str.split(p);
		String[] result = new String[length];
		for(int i=0; i<length; i++) {
			if(i < arr.length) {
				result[i] = arr[i];
			} else {
				result[i] = "";
			}
		}
		return result;
	}
	public Hashtable getImageSize(String path, int bx, int by) {
		Hashtable imgsize = new Hashtable();
		int width = 0; int height = 0;
		imgsize.put("width", "" + bx);
		imgsize.put("height", "" + by);
		try {
			File file = new File(path);
			BufferedImage bi = ImageIO.read( file );
			width = bi.getWidth(); height = bi.getHeight();
			if(width > bx){
				imgsize.put("height", "" + ((height * bx) / width));
				imgsize.put("width", "" + bx);
			} else if(width < by) {
				imgsize.put("width", "" + by); 
				imgsize.put("height", ""  + ((height * by) / width));
			}
		} catch(Exception e) { }
		if(imgsize.containsKey("width") && Integer.parseInt((String)imgsize.get("width")) >= bx) imgsize.put("width", "" + bx);
		if(imgsize.containsKey("height") && Integer.parseInt((String)imgsize.get("height")) > by + 40) imgsize.put("height", "" + (by + 20));
		return imgsize;
	}

	public Hashtable getImageSize(String path, int bx) {
		Hashtable imgsize = new Hashtable();
		int width = 0; int height = 0; int by = 0;
		imgsize.put("width", "" + bx);
		imgsize.put("height", "" + by);
		imgsize.put("r_width", "" + bx);
		imgsize.put("r_height", "" + by);
		try {
			File file = new File(path);
			BufferedImage bi = ImageIO.read( file );
			width = bi.getWidth(); height = bi.getHeight();
			imgsize.put("r_width", "" + width);
			imgsize.put("r_height", "" + height);
			imgsize.put("width", "" + (width > bx ? bx : width));
			imgsize.put("height", "" + (height * ((bx * 1.0) / width)));
		} catch(Exception e) { }
		//if(imgsize.containsKey("width") && Integer.parseInt("" + imgsize.get("width")) >= bx) imgsize.put("width", bx);
		//if(imgsize.containsKey("height") && Integer.parseInt("" + imgsize.get("height")) > by + 40) imgsize.put("height", by + 20);
		return imgsize;
	}
	
	public String addSlashes(String str) {
		return replace(replace(str, "\"", "\\\""), "\'", "\\\'");
	}

	public static String replace(String s, String sub, String with) {
		int c = 0;
		int i = s.indexOf(sub,c);
		if (i == -1) return s;

		StringBuffer buf = new StringBuffer(s.length() + with.length());

		synchronized(buf) {
			do {
				buf.append(s.substring(c, i));
				buf.append(with);
				c = i + sub.length();
			} while((i = s.indexOf(sub, c)) != -1);
			if(c < s.length()) {
				buf.append(s.substring(c, s.length()));
			}
			return buf.toString();
		}
	}

	public String getBizNo(String bizno)
	{
		if(bizno.length() != 10)
			return bizno;
		else
			return bizno.substring(0, 3) + "-" + bizno.substring(3, 5) + "-" + bizno.substring(5);	
	}
	public String getBizNoLastHide(String bizno)
	{
		if(bizno.length() != 10)
			return bizno;
		else
			return bizno.substring(0, 3) + "-" + bizno.substring(3, 5) + "-*****";	
	}
	
	public String getPostCode(String post_code)
	{
		if(post_code.length() != 6)
			return post_code;
		else
			return post_code.substring(0, 3) + "-" + post_code.substring(3) ;	
	}
	
	//public static String aeskey = "nicednb nicedocu ";  // AES의 key는 16(128),24(192),32(256)byte중 하나로 이루어져야 한다.
	
	/**
	 * AES 암호화
	 * @param message	암호화 대상값
	 * @return
	 */
	public String aseEnc(String message)
	{
		String sAesEnc	=	"";
		try {
			sAesEnc = Security.AESencrypt(message);
		} catch (Exception e) {
			System.out.println("[ERROR Util.java]:" + e.toString());
		}
		return sAesEnc;
	}
	
	/**
	 * AES 복호화
	 * @param encrypted	암호화된 값
	 * @return
	 */
	public String aseDec(String encrypted)
	{
		String sAesDec	=	"";
		try {
			sAesDec = Security.AESdecrypt(encrypted);
		} catch (Exception e) {
			System.out.println("[ERROR Util.java]:" + e.toString());
		}
		return sAesDec;
	}
	
	/**
	 * 한글 금액으로 변환
	 * @param money	금액 값
	 * @return
	 */
	public static String getHanMoney(long money){
		String MONEY_NUM[] = {"","일","이","삼","사","오","육","칠","팔", "구"};
		String MONEY_DANWI[] = {"", "만","억","조","경"};
		String MONEY_DETAIL[] = {"","십","백","천"};
		
		if(money == 0) return "영";
		char [] source = new Long(money).toString().toCharArray();
		StringBuffer buf = new StringBuffer();
		boolean flag = false;
		for(int i= 0; i < source.length; i++){
			if(i==0 && source[i]== '-')
			{
				buf.append("감 ");
				continue;
			}
			int val = source[i]-48;
			buf.append(MONEY_NUM[val]);
			int detail = (source.length -1 - i) % 4;
			
			if(!MONEY_NUM[val].equals("")){
				buf.append(MONEY_DETAIL[detail]);
				flag = true;
			}
			int danwi = (source.length -1 - i) / 4;
			if(detail == 0 && danwi > 0 && flag){
				buf.append(MONEY_DANWI[danwi]);
				flag=false;
			}
			
		}
		return buf.toString();
	}
	
	/**
	 * 한글 금액으로 변환
	 * sMoney 금액 값
	 */
	public static String getHanMoney(String sMoney){
		String MONEY_NUM[] = {"","일","이","삼","사","오","육","칠","팔", "구"};
		String MONEY_DANWI[] = {"", "만","억","조","경"};
		String MONEY_DETAIL[] = {"","십","백","천"};
		
        long money = 0L;

        if ( (sMoney != null) && !sMoney.equals("") )
        {
        	money = Long.parseLong(sMoney.replaceAll(",", ""));
        }
		
		if(money == 0) return "영";
		char [] source = new Long(money).toString().toCharArray();
		StringBuffer buf = new StringBuffer();
		boolean flag = false;
		for(int i= 0; i < source.length; i++){
			if(i==0 && source[i]== '-')
			{
				buf.append("감 ");
				continue;
			}
			int val = source[i]-48;
			buf.append(MONEY_NUM[val]);
			int detail = (source.length -1 - i) % 4;
			
			if(!MONEY_NUM[val].equals("")){
				buf.append(MONEY_DETAIL[detail]);
				flag = true;
			}
			int danwi = (source.length -1 - i) / 4;
			if(detail == 0 && danwi > 0 && flag){
				buf.append(MONEY_DANWI[danwi]);
				flag=false;
			}
			
		}
		return buf.toString();
	}
	
	public DataSet getBrowserInfo() {
		DataSet info = new DataSet();
		if(request == null) {
			return info;
		}
		info.addRow();
		String userAgent = request.getHeader("User-Agent").toLowerCase();
		
		if(userAgent.indexOf("msie")>-1 ) {
			info.put("name","Internet Explorer");
			if(userAgent.indexOf("msie 6")>-1 ) {
				info.put("version","6");
			}
			if(userAgent.indexOf("msie 7")>-1 ) {
				info.put("version","7");
			}
		}
		if(userAgent.indexOf("trident")>-1) {
			info.put("name","Internet Explorer");
			
			if(userAgent.indexOf("trident/4.0")>-1) {
				info.put("version","8");
			}
			if(userAgent.indexOf("trident/5.0")>-1) {
				info.put("version","9");
			}
			if(userAgent.indexOf("trident/6.0")>-1) {
				info.put("version","10");
			}
			if(userAgent.indexOf("trident/7.0")>-1) {
				info.put("version","11");
			}
		}
		
		if(userAgent.indexOf("edge/12.0")>-1) {
			info.put("name","Edge Browser");
		}
		
		if(userAgent.indexOf("safari")>-1) {
			info.put("name","safari");
		}
		if(userAgent.indexOf("applewebkit/5")>-1) {
			info.put("name","safari3");
		}
		if(userAgent.indexOf("mac")>-1) {
			info.put("name","mac");
		}
		if(userAgent.indexOf("chrome")>-1) {
			info.put("name","chrome");
		}
		if(userAgent.indexOf("firefox")>-1) {
			info.put("name","firefox");
		}
		
		
		return info;
	}
   
}