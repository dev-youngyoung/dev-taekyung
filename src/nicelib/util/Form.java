package nicelib.util;

import java.io.*;
import java.net.*;
import java.util.*;
import java.util.regex.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspWriter;
import javax.servlet.http.Cookie;

import procure.common.conf.Startup;

import nicelib.util.MultipartRequest;
import nicelib.util.Util;

public class Form {

	public String name = "form1";
	public Vector elements = new Vector();
	public Hashtable data = new Hashtable();
	public String errMsg = null;
	public String uploadDir = null; //사용자 지정 디렉토리
	public int maxPostSize = 1024 * 1024 * 1024; //1G
	public String encoding = Config.getEncoding();

	private static Hashtable options = new Hashtable();
	//private static String saveDir = "c:/windows/temp";
	private static String saveDir = Startup.conf.getString("file.path.bcontract")+"temp";

	private MultipartRequest mrequest = null;	
	private HttpServletRequest request;
	private JspWriter out = null;
	private boolean debug = false;
	private Hashtable files = new Hashtable();

	static {
		options.put("email", "^[a-z0-9A-Z\\_\\.\\-]+@([a-z0-9A-Z\\.\\-]+)\\.([a-zA-Z]+)$");
		//options.put("userid", "^([a-z0-9\\_\\.\\-]{4,15})$");
		options.put("userid", "^[a-zA-Z]{1}[a-zA-Z0-9_]{5,19}$");//20160808 자리수 이슈 적용
		//options.put("userpw", "^([a-z0-9\"'\\{\\}\\[\\]/?.,;:|\\)\\(*~`!^\\-_+<>@#$&%^\\\\=]{8,20})$");
		options.put("url", "^(http:\\/\\/)(.+)");
		options.put("number", "^-?[0-9]+$");
		options.put("money", "^-?[0-9\\,]+$");
		options.put("domain", "^([a-z0-9]+)([a-z0-9\\.\\-]+)\\.([a-z]{2,4})$");
		options.put("engonly", "^([a-zA-Z]+)$");
		options.put("phone", "^([0-9]{2,4}-[0-9]{3,4}-[0-9]{4})$");
		options.put("jumin", "^([0-9]{6}-?[0-9]{7})$");
		if("/".equals(File.separator)) saveDir = "/tmp";
	}

	public Form(String name) {
		this.name = name;
	}
	
	public Form(String name, HttpServletRequest request) throws Exception {
		this(name);
		setRequest(request);
	}

	public Form(HttpServletRequest request) throws Exception {
		this("form1");
		setRequest(request);
	}

	public void setDebug(JspWriter out) {
		this.out = out;
		this.debug = true;
	}

	public void setError(String msg) {
		this.errMsg = msg;
		if(this.debug == true && out != null) {
			try { out.println("<hr>" + msg + "<hr>"); } catch(Exception e) {}
		}
	}

	public void setRequest(HttpServletRequest req) throws Exception {
		this.request = req;

		String key = null;
		String type = req.getContentType();
		if(type != null && type.toLowerCase().startsWith("multipart/form-data")) {
			mrequest = new MultipartRequest(req, saveDir, maxPostSize, encoding);
			Enumeration e = mrequest.getParameterNames();
			while(e.hasMoreElements()) {
				key = (String)e.nextElement();
				data.put(key, mrequest.getParameter(key));
			}
		} else {
			Enumeration e = req.getParameterNames();
			while(e.hasMoreElements()) {
				key = (String)e.nextElement();
				data.put(key, request.getParameter(key));
			}
		}
	}
	
	public void addElement(String name, String value, String attributes) {
		String[] element = new String[3];
		element[0] = name;
		element[1] = value;
		element[2] = attributes;
		elements.addElement(element);
	}

	public void addElement(String name, int value, String attributes) {
		addElement(name, "" + value, attributes);
	}
	
	public void put(String name, String value) {
		data.put(name, value);
	}

	public void put(String name, int value) {
		data.put(name, "" + value);
	}

	public void put(String name, double value) {
		data.put(name, "" + value);
	}

	public void put(String name, boolean value) {
		data.put(name, "" + value);
	}

	public String get(String name) {
		if(data.containsKey(name)) {
			return data.get(name).toString();//.replace('\'', '`');
		} else {
			return "";
		}
	}

	public String get(String name, String str) {
		if(data.containsKey(name)) {
			return data.get(name).toString();//.replace('\'', '`');
		} else {
			return str;
		}
	}

	public String glue(String delim, String names) {
		String[] vars = names.split(",");
		if(vars == null) return "";
		for(int i=0; i<vars.length; i++) {
			vars[i] = get(vars[i].trim());
		}
		return Util.join(delim, vars);
	}

	public String[] getArr(String name) {
		if(mrequest != null) return mrequest.getParameterValues(name);
		else return request.getParameterValues(name);
	}

	public Hashtable getMap(String name) {
		Hashtable map = new Hashtable();
		int len = name.length();
		try {
			Enumeration e = data.keys();
			while(e.hasMoreElements()) {
				String key = (String)e.nextElement();
				if(key.matches("^(" + name + ")(.+)$")) {
					map.put(key.substring(len), data.get(key));
				}
			}
		} catch(Exception ex) {}
		return map;
	}

	public int getInt(String name) {
		return getInt(name, 0);
	}

	public int getInt(String name, int i) {
		String str = get(name);
		if(str.matches("^-?[0-9]+$")) return Integer.parseInt(str);
		else return i;
	}
	
	public boolean validate() throws Exception {
		Iterator ie = elements.iterator();         //Vector의 요소의 리스트를 리턴
		while(ie.hasNext()) {
		    String[] element = (String[])ie.next();
		    if(isValid(element) == false) return false;
		}
		return true;
	}
	
	public File saveFileTime(String name) throws Exception {
		if(mrequest == null) return null;

		String orgname = mrequest.getOriginalFileName(name);
		if(orgname == null) return null;

		String filename = null;
		String path = null;
		File f = null;
		int i = 0;
		do {
			filename = (i > 0) ? "[" + i + "]" + orgname : orgname;
			path = null != uploadDir ? uploadDir + "/" + Util.getUploadFileName(filename) : Util.getUploadFileName(filename);
			f = new File(path);
			i++;
		} while (f.exists());
		
		if(!f.getParentFile().isDirectory()) {
			f.getParentFile().mkdirs();
		}
		files.put(name, filename);
		return saveFile(name, path);
	}
	
	public File saveFile(String name) throws Exception {
		if(mrequest == null) return null;

		String orgname = mrequest.getOriginalFileName(name);
		if(orgname == null) return null;

		String filename = null;
		String path = null;
		File f = null;
		int i = 0;
		do {
			filename = (i > 0) ? "[" + i + "]" + orgname : orgname;
			path = null != uploadDir ? uploadDir + "/" + filename : Util.getUploadPath(filename);
			f = new File(path);
			i++;
		} while (f.exists());
		
		if(!f.getParentFile().isDirectory()) {
			f.getParentFile().mkdirs();
		}
		files.put(name, filename);
		return saveFile(name, path);
	}

	public File saveFile(String name, String path) throws Exception {
		if(mrequest == null) return null;

		File f = mrequest.getFile(name);
		if(f != null && f.exists()) {

			File target = new File(path);

			if(!target.getParentFile().isDirectory()) {
				target.getParentFile().mkdirs();
			}
			
			if(!target.exists()) target.createNewFile();

			InputStream fis = null;
			OutputStream fos = null;
			try {
				fis = new FileInputStream(f);
				fos = new FileOutputStream(target);
				byte[] buf = new byte[2048];
				int len;
				while((len = fis.read(buf)) > 0){
					fos.write(buf, 0, len);
				}
			} catch(Exception e) {
				target.delete();
				if(out != null && debug == true) {
					out.print("File Upload Error : " + e.getMessage());
				}
			} finally{
				fis.close();
				fos.close();
			}
			
			f.delete();

			if(target.exists()) return target;
			else return null;

		} else {
			return null;
		}
	}

	public File getFile(String name) {
		if(mrequest == null) return null;
		return mrequest.getFile(name);
	}

	public String getFileName(String name) {
		if(mrequest == null) return "";
		if(files.containsKey(name)) return (String)files.get(name);
		else return mrequest.getOriginalFileName(name);
	}

	public String getFileType(String name) {
		if(mrequest == null) return "";
		return mrequest.getContentType(name);
	}
	
	private Hashtable getAttributes(String str) {
		Hashtable map = new Hashtable();
		if(str != null && !"".equals(str)) {
			String[] arr = str.split("\\,");
			for(int i=0; i<arr.length; i++) {
				String[] arr2 = null;
				arr2 = arr[i].split("[=:]");
				if(arr2.length == 2) {
					map.put(arr2[0].trim().toUpperCase(), arr2[1].replace('\'', '\0').trim());
				}
			}
		}
		return map;
	}
	
	private boolean isValid(String[] element) throws Exception {
		String name = element[0];
		String value = get(name);
		Hashtable attributes = getAttributes(element[2]);
		String nicname = (String)attributes.get("HNAME");
		if(nicname == null) nicname = name;
	//	nicname = new String(nicname.getBytes("KSC5601"),"8859_1");
		
		if(attributes.containsKey("REQUIRED")) {
			if(mrequest !=  null && mrequest.getFile(name) != null) value = getFileName(name);
			if("".equals(value.trim())) {
				this.errMsg = "["+ nicname +"]항목은 필수항목입니다.";
				return false;
			}
		}
		
		if(attributes.containsKey("MAXBYTE")) {
			int size = Integer.parseInt((String)attributes.get("MAXBYTE"));
			if(value.getBytes().length > size) {
				this.errMsg = "["+ nicname +"]항목의 최대길이는 "+ size +"자 입니다.";
				return false;
			}
		}

		if(attributes.containsKey("MINBYTE")&&attributes.containsKey("REQUIRED")) {
			int size = Integer.parseInt((String)attributes.get("MINBYTE"));
			if(value.getBytes().length < size) {
				this.errMsg = "["+ nicname +"]항목의 최소길이는 "+ size +"자 입니다.";
				return false;
			}
		}
		if(attributes.containsKey("FIXBYTE")&&attributes.containsKey("REQUIRED")) {
			int size = Integer.parseInt((String)attributes.get("FIXBYTE"));
			if(value.getBytes().length != size) {
				this.errMsg = "["+ nicname +"]항목은 정확히 "+ size +"자이어야 합니다.";
				return false;
			}
		}
		
		if(attributes.containsKey("MINSIZE")) {
			int size = Integer.parseInt((String)attributes.get("MINSIZE"));
			int v = Integer.parseInt(value);
			if(v < size) {
				this.errMsg = "["+ nicname +"]항목의 값은 "+ size +"이하이어야 합니다.";
				return false;
			}
		}

		if(attributes.containsKey("MAXSIZE")) {
			int size = Integer.parseInt((String)attributes.get("MAXSIZE"));
			int v = Integer.parseInt(value);
			if(v > size) {
				this.errMsg = "["+ nicname +"]항목의 값은 "+ size +"이상이어야 합니다.";
				return false;
			}
		}
		

		if(attributes.containsKey("GLUE")) {
			String glue = (String)attributes.get("GLUE");
			String delim = attributes.containsKey("DELIM") ? (String)attributes.get("DELIM") : "";
			String[] arr = glue.split("\\|");
			for(int i=0; i<arr.length; i++) {
				if(!"".equals(get(arr[i].trim()))) value += delim + get(arr[i].trim());
			}
		}

		if(attributes.containsKey("OPTION") && !"".equals(value)) {
			String option = (String)attributes.get("OPTION");
			String re = (String)options.get(option);
			if(re == null) return true;
			Pattern pattern = Pattern.compile(re);
			Matcher match = pattern.matcher(value);
			if(match.find() == false) {
				this.errMsg = "["+ nicname +"]항목은 형식에 어긋납니다.";
				return false;
			}
		}

		if(attributes.containsKey("ALLOW")) {
			String filename = getFileName(name);
			String re = (String)attributes.get("ALLOW");
			if(filename != null && !"".equals(filename) && !"".equals(re)) {
				Pattern pattern = Pattern.compile("(" + re.replace('\'', '|') + ")$");
				Matcher match = pattern.matcher(getFileName(name).toLowerCase());
				if(match.find() == false) {
					this.errMsg = "["+ nicname +"]항목은 업로드가 제한된 파일입니다.";
					return false;
				}
			}
		}

		if(attributes.containsKey("DENY")) {
			String filename = getFileName(name);
			String re = (String)attributes.get("DENY");
			if(filename != null && !"".equals(filename) && !"".equals(re)) {
				Pattern pattern = Pattern.compile("(" + re.replace('\'', '|') + ")$");
				Matcher match = pattern.matcher(getFileName(name).toLowerCase());
				if(match.find() == true) {
					this.errMsg = "["+ nicname +"]항목은 업로드가 제한된 파일입니다.";
					return false;
				}
			}
		}

		return true;
	}
	
	public String getScript() throws Exception {
		StringBuffer sb = new StringBuffer();
		sb.append("<script language='javascript'>\r\n");
		sb.append("function __setElement(el, v, a) { if(v) v = v.replace(/__&LT__/g, '<').replace(/__&GT__/g, '>'); if(typeof(el) != 'object') return; if(v != null) switch(el.type) { case 'text': case 'hidden': case 'password': case 'file': el.value = v; break; case 'textarea': el.value = v; break; case 'checkbox': case 'radio': if(el.value == v) el.checked = true; else el.checked = false; break; case 'select-one': for(var i=0; i<el.options.length; i++) if(el.options[i].value == v) el.options[i].selected = true; break; default: var val = v.split(\",\"); if(val.length > 1) { for(var i=0; i<el.length; i++) { for(var j=0; j<val.length; j++) { if(el[i].value == val[j]) el[i].checked = true; } } break; } else { for(var i=0; i<el.length; i++) if(el[i].value == v) el[i].checked = true; el = el[0]; break; } } if(typeof(a) == 'object') { if(el.type != 'select-one' && el.length > 1) el = el[0]; for(i in a) el.setAttribute(i, a[i]); } }\r\n");
		sb.append("if(_f = document.forms['" + this.name + "']) {\r\n");
		/*
		 function setOninvalid(){
			var elements = $("input[required],select[required],textarea[required]");
			for(var i= 0 ; i < elements.length ; i++){
				elements[i].oninvalid = 
				function(e){
					e.target.setCustomValidity("");
					if(!e.target.validity.valid)
					e.target.setCustomValidity("["+e.target.getAttribute("hname")+"] 항목은 필수 입력 사항 입니다.");	
				}
				elements[i].oninput = function(e) {
			            e.target.setCustomValidity("");
			    };
			}
		}
		setOninvalid() 
		 */
		Iterator ie = elements.iterator();
		while(ie.hasNext()) {
		    String[] element = null;
		    String value = null;
		    element = (String[])ie.next();
		    value = this.get(element[0], null);
		    if(value == null && element[1] != null) {
				value = element[1];
			}
		    sb.append("\t__setElement(_f['" + element[0] + "'], ");
		    sb.append(value != null ? "'" + Util.replace(Util.replace(Util.replace(Util.replace(Util.replace(value, "\\", "\\\\"), "\'", "\\\'"), "\r\n", "\\r\\n"), "<", "__&LT__"), ">", "__&GT__") + "'" : "null");
		    sb.append(", {" + (element[2] != null ? element[2] : "") + "});\r\n");
		}
		
		sb.append("\tif(!_f.onsubmit) _f.onsubmit = function() { return validate(this); };\r\n");
		sb.append("}\r\n</script>");
	
	//	if(errMsg != null) sb.append("<script>alert('"+ new String(errMsg.getBytes("8859_1"),"KSC5601") +"')</script>");
		if(errMsg != null) sb.append("<script>alert('"+ errMsg +"')</script>");

		return sb.toString();
	}
}