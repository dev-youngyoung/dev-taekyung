package nicelib.util;

import procure.common.utils.Security;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.Hashtable;

public class Auth {

	private HttpServletRequest request;
	private HttpServletResponse response;
	private static String encoding = Config.getEncoding();
	private static String secretId = Config.getSecretId();
	private Hashtable data;

	public String keyName = "AUTHID";
	public String loginURL = "../member/login.jsp";
	public int validTime = 3600 * 24 * 1000; // �и� ������

	public Auth(HttpServletRequest request, HttpServletResponse response) {
		this.request = request;
		this.response = response;
		this.data = new Hashtable();
	}

	public void loginForm() throws Exception {
		this.loginForm(this.loginURL);
	}

	public void loginForm(String url) throws Exception {
		String uri = request.getRequestURI();
		String query = request.getQueryString();
		
		if(query != null) uri = uri + "?" +query;
		response.sendRedirect(url + "?returl=" + URLEncoder.encode(uri, encoding));
	}

	public boolean isValid() throws Exception {
		Cookie[] cookies = request.getCookies();
		String cookie = null;
		if(cookies !=null) {
			for(int i=0; i<cookies.length; i++) {
				if(cookies[i].getName().equals(keyName)) {
					cookie = cookies[i].getValue();
				}
			}
		}
		if(cookie == null) return false;
		String[] arr = cookie.split("\\|");
		if(arr.length != 2) return false;
		if(!arr[0].equals(Util.sha256(arr[1] + secretId))) return false;
		if(!getAuthInfo(arr[1])) return false;
		//if(!this.getString("_CLIENT_IP").equals(request.getRemoteAddr())) return false; // �α����� client IP�� �ٸ��� ��ŷ ������ �����Ƿ� ���� ���ϵ��� ��.
		return true;
	}

	public int getInt(String name) {
		int ret = 0;
		try {
			ret = Integer.parseInt((String)data.get(name));
		} catch(Exception e) {}
		return ret;
	}

	public String getString(String name) {
		return (String)data.get(name);
	}

	public void put(String name, String value) {
		data.put(name, value);
	}

	public void put(String name, int i) {
		put(name, "" + i);
	}

	public void setAuthInfo()throws Exception {
		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");

		Enumeration e = data.keys();
		String key = null;
		String value = null;
		StringBuffer sb = new StringBuffer();

		while(e.hasMoreElements()) {
			key = (String)e.nextElement();
			value = (String)data.get(key);
			sb.append(key + "=>" + value + "|");
		}
		//System.out.println("ip:"+request.getRemoteAddr());
		//sb.append("_CLIENT_IP=>"+request.getRemoteAddr()+"|");  // �α����� Ŭ���̾�ƮIP ����
		//System.out.println("sb:"+sb.toString());

		String info = Security.AESencrypt((sb.toString() + fmt.format(new Date())));
		//String md5 = Util.md5(info + secretId);
		String	sha256	=	Util.sha256(info + secretId);
		//Cookie cookie = new Cookie(keyName, md5 + "|" + info);
		Cookie cookie = new Cookie(keyName, sha256 + "|" + info);
		cookie.setPath("/");
		response.addCookie(cookie);

		if(data.get("_ADMIN_NAME") == null) { // �������� �α����� ���� �������� �������� �ʰ� ��Ű�θ� �����Ѵ�.  ������ ���ÿ� 2�� ��� �Ұ���
			HttpSession session = this.request.getSession(false);
			if (session != null) {
				session.invalidate();
			}
			session = this.request.getSession(true);
			session.setAttribute("user_id", data.get("_USER_ID"));
		}
	}
	
	public void setAuthInfo2() {

		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMddHHmmss");

		Enumeration e = data.keys();
		String key = null;
		String value = null;
		StringBuffer sb = new StringBuffer();

		while(e.hasMoreElements()) {
			key = (String)e.nextElement();
			value = (String)data.get(key);
			sb.append(key + "=>" + value + "|");
		}
		//sb.append("_clientip=>"+request.getRemoteAddr()+"|");  // �α����� Ŭ���̾�ƮIP ����
		String info = Base64Coder.encodeString(sb.toString() + fmt.format(new Date()));
		//String md5 = Util.md5(info + secretId);
		String	sha256	=	Util.sha256(info + secretId);

		//Cookie cookie = new Cookie(keyName, md5 + "|" + info);
		Cookie cookie = new Cookie(keyName, sha256 + "|" + info);
		cookie.setPath("/");
		cookie.setMaxAge(60*60*24*365); // ��ȿ�Ⱓ �Ѵ�
		response.addCookie(cookie);    // ��Ű�� ���信 �߰�����

		HttpSession session = this.request.getSession(false);
		if(session != null){
			System.out.println("���� ���� ��� ���� ������.");
			session.invalidate();
		}
		session = this.request.getSession(true);
		session.setAttribute("user_id", data.get("_USER_ID"));
	}

	public boolean getAuthInfo(String info)throws Exception {
		String[] arr = Security.AESdecrypt(info).split("\\|");
		for(int i=0; i<arr.length; i++) {
			String[] arr2 = arr[i].split("=>");
			if(arr2.length == 2) data.put(arr2[0], arr2[1]);
		}

		//if(((new Date()).getTime() - validTime) > Util.strToDate(arr[arr.length - 1]).getTime()) return false;

		if(data.get("_ADMIN_NAME") == null) { // �������� �α����� ���� �������� �������� �ʰ� ��Ű�θ� �����Ѵ�.  ������ ���ÿ� 2�� ��� �Ұ���
			HttpSession session = request.getSession(false);
			if (session == null) {
				System.out.println("���� ���� [" + data.get("_USER_ID") + "]");
				delAuthInfo();
				return false;
			}

			String user_id = (String) session.getAttribute("user_id");
			if (user_id == null) {
				System.out.println("���� �Ӽ� ���� [" + data.get("_USER_ID") + "]");
				session.invalidate();
				delAuthInfo();
				return false;
			}
			if (!user_id.equals(data.get("_USER_ID"))) {
				System.out.println("���ǰ� ��Ű �ٸ� : ���� id[" + user_id + "], ��Ű id[" + data.get("_USER_ID") + "");
				session.invalidate();
				delAuthInfo();
				return false;
			}
		}
		return true;
	}

	public void delAuthInfo() {
		Cookie cookie = new Cookie(keyName, "");
		cookie.setPath("/");
		response.addCookie(cookie);
	}
	
	public HttpServletRequest getRequest()
	{
		return this.request;
	}
}
