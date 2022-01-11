package nicelib.util;

import javax.servlet.jsp.JspWriter;

import net.sf.json.JSONObject;
import net.sf.json.JSONArray;
import org.apache.http.conn.ConnectTimeoutException;

import java.io.*;
import java.util.*;
import java.net.*;

// SSL
import java.security.cert.X509Certificate;
import javax.net.ssl.*;

/**
 * <pre>
 * Http http = new Http("http://aaa.com/data/test.jsp");
 * //http.setDebug(out);
 * http.setParam("var", "aaa");
 * http.send("GET", false);
 * </pre>
 */
public class Http {

	private JspWriter out = null;
	private boolean debug = false;
	private String url = null;
	private Hashtable headers = new Hashtable();
	private Hashtable params = new Hashtable();
	private String encoding = "UTF-8";
	private String method = "GET";
	private String contentType = null;
	private String body = "";
	public int timeOut = 5*1000;

	public String errMsg = "";

	public Http() { }

	public Http(String path) {
		this.url = path;
	}

	public void setDebug(JspWriter out) {
		this.out = out;
		this.debug = true;
	}

	private void setError(String msg) throws Exception {
		this.errMsg = msg;
		if(out != null && debug == true) {
			out.print("<hr>" + msg + "<hr>\n");
		}
	}

	public void setContentType(String type) {
		this.contentType = type;
	}
	
	public void setEncoding(String enc) {
		this.encoding = enc;
	}

	public void setUrl(String path) {
		this.url = path;
	}

	public void setHeader(String name, String value) {
		headers.put(name, value);
	}
	public void setParam(String name, String value) {
		params.put(name, value);
	}

	public void setBody(String body) {
		this.body = body;
	}

	public String send() throws Exception {
		return send(this.method);
	}

	public void send(String method, HttpListener listener) throws Exception {
		this.method = method;
		new HttpAsync(this, listener).start();
	}

	public String sendKapt(String data) throws Exception {
		URL 				url;
		URLConnection 		conn;

		String returnValue 	= "";
		HttpURLConnection hUrlc = null;
		try{
			url  = new URL(this.url);
			conn = url.openConnection();
			
			
			//######################################################################
			// POST 방식으로 구현한 부분
			hUrlc = (HttpURLConnection) conn;
			hUrlc.setRequestProperty("Content-Type", "application/xml; charset=UTF-8");
			hUrlc.setRequestProperty("Content-Length", Integer.toString(data.length()) );
			hUrlc.setRequestMethod("POST");
			hUrlc.setDoOutput(true);
			hUrlc.setDoInput(true);
			hUrlc.setUseCaches(false);
			hUrlc.setDefaultUseCaches(false);
			hUrlc.setConnectTimeout(timeOut);
			hUrlc.setReadTimeout(timeOut);
			//new Thread(new InterruptThread(hUrlc,timeOut)).start();

			OutputStream opstr = hUrlc.getOutputStream();

			opstr.write(data.getBytes("utf-8"));
			opstr.flush();
			opstr.close();

			String buffer = null;
			String sendKapt = "";
			BufferedReader in = new BufferedReader(new InputStreamReader(hUrlc.getInputStream(), this.encoding));

			while( (buffer = in.readLine()) != null ){
				sendKapt += buffer;
			}

			System.out.println("sendKapt => " + sendKapt );
			returnValue = sendKapt.trim();

			in.close();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			hUrlc.disconnect();
		}
		
		return returnValue;
	}		
	
	public String sendSkbroadband(String reqCode, JSONArray data, boolean isArray) throws Exception {
		URL 				url;
		URLConnection 		conn;

		String returnValue 	= "";
		String param 	= "";
		HttpURLConnection hUrlc = null;
		try{
			url  = new URL(this.url);
			conn = url.openConnection();
			System.out.println(url);
			
			//######################################################################
			// POST 방식으로 구현한 부분
			hUrlc = (HttpURLConnection) conn;
			hUrlc.setRequestProperty("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");						
			//hUrlc.setRequestProperty("Content-Length", Integer.toString(data.toString().length()) );
			hUrlc.setRequestMethod("POST");
			hUrlc.setDoOutput(true);
			hUrlc.setDoInput(true);
			hUrlc.setUseCaches(false);
			hUrlc.setDefaultUseCaches(false);
			hUrlc.setConnectTimeout(timeOut);
			hUrlc.setReadTimeout(timeOut);
			//new Thread(new InterruptThread(hUrlc,timeOut)).start();

			OutputStream opstr = hUrlc.getOutputStream();
			
			JSONObject json = null;
			String bandinfo = "";
			if(isArray)  // Json 배열일경우
			{				
				bandinfo = data.toString();
			}else
			{
			
				json= JSONObject.fromObject(data.getJSONObject(0));
				bandinfo = json.toString();
			}
			
			
			System.out.println("[sendSkbroadband]" +bandinfo);
			bandinfo = new String(Base64Coder.encode(bandinfo.getBytes("UTF-8")));
			
			bandinfo = URLEncoder.encode(bandinfo,"UTF-8");
			
			param = "reqCode=" + reqCode + "&data=" + bandinfo ;
			System.out.println("==================================통신중===========================================");	
			System.out.println("==================================" +param);			
			
						
			opstr.write(param.getBytes("UTF-8"));
			//opstr.write("&".getBytes("UTF-8"));
			//opstr.write(bandinfo.getBytes("UTF-8"));
			opstr.flush();
			opstr.close();

			String buffer = null;
			String sendSkbroadband = "";
			System.out.println("============================1=====");	
								
			//Reader tmp = new InputStreamReader(hUrlc.getInputStream());
			
			System.out.println("============================2======");
			
			//BufferedReader in = new BufferedReader(tmp);
			BufferedReader in = new BufferedReader(new InputStreamReader(hUrlc.getInputStream(), this.encoding));

			//BufferedReader in = new BufferedReader(new InputStreamReader(((HttpURLConnection) (new URL(this.url)).openConnection()).getInputStream(), this.encoding));
			
			System.out.println("============================3======");	
			while( (buffer = in.readLine()) != null ){
				sendSkbroadband += buffer;
			}

			System.out.println("sendSkbroadband => " + sendSkbroadband );
			returnValue = sendSkbroadband.trim();

			in.close();

		}catch(Exception e){
			System.out.println("============================err=====");
			System.out.println(e.toString());
			e.printStackTrace();
		}finally{
			hUrlc.disconnect();
		}
		
		return returnValue;
	}	
	
	public String send(String method) throws Exception {
		StringBuffer buffer = new StringBuffer();
		String line;

		// Construct data
		String data = "";
		Enumeration e = params.keys();
		while(e.hasMoreElements()) {
			String name = (String)e.nextElement();
			data += URLEncoder.encode(name, encoding) + "=" + URLEncoder.encode((String)params.get(name), encoding) + "&";
		}

		setError(data);

		if("GET".equals(method) && !"".equals(data)) {
			if(url.indexOf("?") > 0) {
				this.url += "&" + data;	
			} else {
				this.url += "?" + data;
			}
		}

		setError(this.url);

		URL u = new URL(this.url);

		InputStreamReader is = null;

		if("POST".equals(method)) {
			
			System.out.println(data);
			URLConnection conn = u.openConnection();

			//header param set
			Enumeration h = headers.keys();
			while(h.hasMoreElements()) {
				String name = (String)h.nextElement();
				conn.setRequestProperty(name,(String)headers.get(name));
			}

			conn.setDoOutput(true);
			OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
			wr.write(data);
			wr.flush();
			wr.close();

			is = new InputStreamReader(conn.getInputStream(), encoding);
		}else{
			is = new InputStreamReader(u.openStream(), encoding);
		}

		BufferedReader in = new BufferedReader(is);
		int i = 1;
		while((line = in.readLine()) != null) {
			if(i > 1000) break;
			buffer.append(line + "\r\n");
			i++;
		}
		in.close();

		return buffer.toString();
	}
	
	public String sendHTTPS() throws Exception {
		URL 				url;
		HttpURLConnection 		conn = null;
		String returnValue 	= "";
		String data = "";
		try{
			System.out.println("sendHTTPS start ---------------");
			TrustManager[] trustAllCerts = new TrustManager[] { new X509TrustManager() {
				public java.security.cert.X509Certificate[] getAcceptedIssuers() {
					return null;
				}

				public void checkClientTrusted(X509Certificate[] certs,
						String authType) {
				}

				public void checkServerTrusted(X509Certificate[] certs,
						String authType) {
				}
			} };
			System.out.println("sendHTTPS end ---------------");
			SSLContext sc = SSLContext.getInstance("SSL");
			sc.init(null, trustAllCerts, new java.security.SecureRandom());
			HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());

			url = new URL(this.url);
			conn = (HttpURLConnection) url.openConnection();
			
			Enumeration e = params.keys();
			while(e.hasMoreElements()) {
				String name = (String)e.nextElement();
				data += URLEncoder.encode(name, encoding) + "=" + URLEncoder.encode((String)params.get(name), encoding) + "&";
			}			
			if(!body.equals("")){
				data = body;
			}
			System.out.println(">>>>>>>>>>>>>>>>"+data);
			
			//######################################################################
			// POST 방식으로 구현한 부분
			//header param set
			Enumeration h = headers.keys();
			while(h.hasMoreElements()) {
				String name = (String)h.nextElement();
				conn.setRequestProperty(name,(String)headers.get(name));
				System.out.println("name =>"+name);
				System.out.println("value =>"+(String)headers.get(name));
			}

			conn.setRequestProperty("Content-Length", Integer.toString(data.length()) );
			conn.setRequestMethod("POST");
			conn.setDoOutput(true);
			conn.setDoInput(true);
			conn.setUseCaches(false);
			conn.setDefaultUseCaches(false);
			conn.setConnectTimeout(timeOut);
			conn.setReadTimeout(timeOut);
			//new Thread(new InterruptThread(hUrlc,timeOut)).start();

			OutputStream opstr = conn.getOutputStream();

			opstr.write(data.getBytes(encoding));
			opstr.flush();
			opstr.close();

			String buffer = null;
			String retVal = "";
			BufferedReader in = new BufferedReader(new InputStreamReader(conn.getInputStream(), this.encoding));

			while( (buffer = in.readLine()) != null ){
				retVal += buffer;
			}

			System.out.println("return => " + retVal );
			returnValue = retVal.trim();

			in.close();

		}catch (ConnectTimeoutException ce) {
			System.out.println(">>>>>connection timeout>>>>>>>>>>>"+data);
			System.out.println(ce.getMessage());
		}catch(Exception e){
			System.out.println(e.getMessage());
		}finally{
			conn.disconnect();
		}
		
		return returnValue;
	}	
	
	public String getAegisData(String paramUrl){
		URL 				url;
		URLConnection 		conn;
		InputStream 		is;
		InputStreamReader 	isr;
		BufferedReader 		br;

		String returnValue 	= "";
		StringBuffer sb = new StringBuffer();
		HttpURLConnection hUrlc = null;
		
		System.out.println("paramUrl => " + paramUrl );
		try{
			url  = new URL(paramUrl);
			
			conn = url.openConnection();
			
			//######################################################################
			// POST 방식으로 구현한 부분
			hUrlc = (HttpURLConnection) conn;
			hUrlc.setRequestProperty("Content-Type", "Application/x-www-form-urlencoded");
			hUrlc.setRequestMethod("POST");
			hUrlc.setDoOutput(true);
			hUrlc.setDoInput(true);
			hUrlc.setUseCaches(false);
			hUrlc.setDefaultUseCaches(false);
			hUrlc.setConnectTimeout(timeOut);
			hUrlc.setReadTimeout(timeOut);
			//new Thread(new InterruptThread(hUrlc,timeOut)).start();
			OutputStream opstr = hUrlc.getOutputStream();

			opstr.write(paramUrl.getBytes());
			opstr.flush();
			opstr.close();

			String buffer = null;
			String ecgResultStr = "";
			BufferedReader in = new BufferedReader(new InputStreamReader(hUrlc.getInputStream()));

			while( (buffer = in.readLine()) != null ){
				ecgResultStr += buffer;
			}

			System.out.println("ecgResultStr => " + ecgResultStr );
			returnValue = ecgResultStr.trim();

			in.close();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			hUrlc.disconnect();
		}
		
		return returnValue;
	}	
}

class HttpAsync extends Thread {

	private Http http = null;
	private HttpListener listener = null;
	private String result = null;

	public HttpAsync(Http h, HttpListener l) {
		http = h;
		listener = l;
	}

	public void run() {
		try {
			result = http.send();
			if(listener != null) listener.execute(result);
		} catch(Exception ex) {
			System.out.print("Http Async Error!!");
		}
	}
}