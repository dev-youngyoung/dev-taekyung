package procure.common.utils;

import java.util.*;
import java.text.*;
import java.sql.*;
import java.io.*;
import java.lang.reflect.*;
import javax.servlet.http.*;

/******************************
 * 유용하게 사용되는 함수들.
 * 실제로 jsp로 구현된것은 아니고 class로 되어있음.<br>
 * 사용법은 Utils.func() 임
*******************************/
public class Utils {
	public static class mException extends Exception {
		Object data;
		public mException(Exception e) { super(e); }
		public mException(Exception e, Object data) { super(e); this.data = data; }
		public Object get() { return data; }
		public void set(Object data) { this.data=data; }
	}
	public static class Entry { public Object k, v; public Object getKey() { return k; } public Object getValue() { return v; } public Entry(Object k, Object v) { this.k = k; this.v = v; } }

	public static class stime {
		private long s_time;
		public void s() { s_time = System.currentTimeMillis(); }
		public void f() { System.out.println(df[3].format((System.currentTimeMillis()-s_time)/1000.)); s_time = System.currentTimeMillis(); }
		public void f(String prompt) { System.out.print(prompt); System.out.println(df[3].format((System.currentTimeMillis()-s_time)/1000)); s_time = System.currentTimeMillis(); }
		public String fs() { String ret = df[3].format((System.currentTimeMillis()-s_time)/1000.); s_time = System.currentTimeMillis(); return ret; }
		public stime() { s_time = System.currentTimeMillis(); }
	}
	public static stime tm = new stime();

	private static DecimalFormat df[] = new DecimalFormat[7];

	static {
		df[0] = new DecimalFormat("#,##0");
		df[1] = new DecimalFormat("#,##0.0");
		df[2] = new DecimalFormat("#,##0.00");
		df[3] = new DecimalFormat("#,##0.000");
		df[4] = new DecimalFormat("#,##0.0000");
		df[5] = new DecimalFormat("#,##0.00000");
		df[6] = new DecimalFormat("0");
	}
/******************************
 * 스트링의 일부문자를 다른 문자로 치환.
 * String b가 "" 일경우 문자삭제의 효과가 있음.
*******************************/
	public static String replaceMark(String str, char a, String b) {
		if(str==null) return "";
		StringBuffer buffer = new StringBuffer();
		char[] arr_char = str.toCharArray();
		for(int i=0; i<arr_char.length; i++)
			if( arr_char[i] == a )
				buffer.append(b);
			else
				buffer.append(arr_char[i]);
		return buffer.toString();
	}

/******************************
 * 스트링은 구분문자로 잘라서 List로 출력함.
*******************************/
	public static List splitlst(String str, char a) {
		List ret = new Vector();
		if(ret==null) return ret;
		char[] arr_char = str.toCharArray();
		int idx=0;
		for(int i=0;i<arr_char.length;i++) {
			if(arr_char[i]==a) { ret.add(new String(arr_char, idx, i-idx)); idx = i+1; }
		}
		if(idx!=arr_char.length) ret.add(new String(arr_char, idx, arr_char.length-idx));
		return ret;
	}
	public static List splitlst(String str, char a, int max) {
		List ret = new Vector();
		if(ret==null) return ret;
		char[] arr_char = str.toCharArray();
		int idx=0;
		for(int i=0;i<arr_char.length&&i<max;i++) {
			if(arr_char[i]==a) { ret.add(new String(arr_char, idx, i-idx)); idx = i+1; }
		}
		if(idx!=arr_char.length) ret.add(new String(arr_char, idx, arr_char.length-idx));
		return ret;
	}
/******************************
 * 스트링을 구분문자로 잘라서 String[]로 출력
*******************************/
	public static String[] split(String str, char a) { List ret = splitlst(str, a); String[] b=new String[0]; return (String[])ret.toArray(b); }
	public static String[] split(String str, char a, int max) { List ret = splitlst(str, a, max); String[] b=new String[0]; return (String[])ret.toArray(b); }

/******************************
*******************************/
	public static String trim(String str) {
		if(str==null) return ""; else return str.trim();
	}

/******************************
 * 스트링의 오른쪽 공백을 자름. 탭문자는 그대로 둠.
*******************************/
	public static String rtrim(String str) {
		if(str==null || str.length()==0) return "";
		char[] arr_char = str.toCharArray();
		int i=arr_char.length-1;
		for(;i>=0&&(arr_char[i]<=' '||arr_char[i]=='　'); i--) ;
		if(i<0) return "";
		else return str.substring(0, i+1);
	}

	public static String trim(String in, int len) throws Exception {
		byte[] inb = in.getBytes();
		if(inb.length>len) {
			if(Utils.hancheck(inb, len))
				return (new String(inb, 0, len-1));
			else
				return new String(inb, 0, len);
		}
		return in;
	}

	public static String numOnly(String str) throws Exception {
		if(str==null) return "";
		char[] dat = str.toCharArray();
		char[] out = new char[dat.length];
		int j=0;
		for(int i=0;i<dat.length;i++) if(dat[i]>='0' && dat[i]<='9') out[j++] = dat[i];
		return new String(out, 0, j);
	}

	private static String blank = "                                                                            ";
	private static String zero  = "0000000000000000000000000000000000000000000000000000000000000000000000000000";
/******************************
 * 숫자를 지정된 길이만큼 문자열로 바꾸고 왼쪽은 공백으로 채움
*******************************/
	public static String pads(int val, int len) throws Exception {
		String ret = Integer.toString(val);
		int len_ = ret.length();
		if(len_<len) return blank.substring(0,len-len_)+ret;
		else return ret;
	}

/******************************
 * 숫자를 지정된 길이만큼 문자열로 바꾸고 왼쪽은 '0'으로 채움
*******************************/
	public static String padz(int val, int len) throws Exception {
		String ret = Integer.toString(val);
		int len_ = ret.length();
		if(len_<len) return zero.substring(0,len-len_)+ret;
		else return ret;
	}

/******************************
 * 문자열을 지정된 길이로 만든다. 입력 스트링이 len보다 크면서 is_trim을 true로 설정할 경우는 길이만큼 자른다.
*******************************/
	public static String padd(String in, int len, boolean is_trim) {
		if(in.length()>len) {
			if(is_trim)
				return in.substring(0, len);
			else
				return in;
		}
		else return in + blank.substring(0, len-in.length());
	}

/******************************
 * 문자열을 지정된 길이로 만든다. 입력 스트링이 len보다 크면서 is_trim을 true로 설정할 경우는 길이만큼 자른다. 스트링의 길이가 작을경우 왼쪽에 공백을 붙인다.
*******************************/
	public static String paddl(String in, int len, boolean is_trim) {
		if(in.length()>len) {
			if(is_trim)
				return in.substring(0, len);
			else
				return in;
		}
		else return blank.substring(0, len-in.length())+in;
	}

/******************************
*******************************/
	public static String paddL(String in, int len) { return paddL(in, len, ' ', false); }
/******************************
*******************************/
	public static String paddL(String in, int len, boolean is_trim) { return paddL(in, len, ' ', is_trim); }
/******************************
*******************************/
	public static String paddL(String in, int len, char ch) { return paddL(in, len, ch, false); }
/******************************
	문자열을 지정된 길이로 만든다. 입력 스트링이 len보다 크면서 is_trim을 true로 설정할 경우는 길이만큼 자른다. 스트링의 길이가 작을경우 왼쪽에 공백을 붙인다.
	이 함수는 한글의 경우에 2byte로 계산해서 출력한다.
*******************************/
	public static String paddL(String in, int len, char ch, boolean is_trim) {
		byte[] inb = in.getBytes();
		if(inb.length>len) {
			if(is_trim) {
				if(hancheck(inb, len))
					return (new String(inb, 0, len-1))+' ';
				else
					return new String(inb, 0, len);
			}
			else
				return in;
		}
		else {
			byte[] outb = new byte[len];
			int alen = len-inb.length;
			for(int i=0;i<alen;i++) outb[i] = (byte)ch;
			System.arraycopy(inb, 0, outb, alen, inb.length);
			return new String(outb);
		}
	}

/******************************
*******************************/
	public static String paddR(String in, int len) { return paddR(in, len, ' ', false); }
/******************************
*******************************/
	public static String paddR(String in, int len, boolean is_trim) { return paddR(in, len, ' ', is_trim); }
/******************************
*******************************/
	public static String paddR(String in, int len, char ch) { return paddR(in, len, ch, false); }
/******************************
*******************************/
	public static String paddR(String in, int len, char ch, boolean is_trim) {
		byte[] inb = in.getBytes();
		if(inb.length>len) {
			if(is_trim) {
				if(hancheck(inb, len))
					return (new String(inb, 0, len-1))+' ';
				else
					return new String(inb, 0, len);
			}
			else
				return in;
		}
		else {
			byte[] outb = new byte[len];
			System.arraycopy(inb, 0, outb, 0, inb.length);
			int alen = len-inb.length;
			for(int i=0,j=inb.length;i<alen;i++,j++) outb[j] = (byte)ch;
			return new String(outb);
		}
	}

/******************************
*******************************/
	public static String ko(String en) {
		String korean = null;
		try {
			korean = new String(en.getBytes("8859_1"),"KSC5601");
		} catch(Exception e) {
			return korean;
		}
		return korean;
	}

/******************************
*******************************/
	public static String en(String ko) {
		String english = null;
		try {
			english = new String(ko.getBytes("KSC5601"),"8859_1");
		} catch(Exception e) {
			return english;
		}
		return english;
	}

/******************************
*******************************/
	public static String cvt_zip(String str) {
		String ret = "";
		try {
			ret = str.substring(0, 3) + "-" + str.substring(3);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_zip_p(String str) {
		String ret = "";
		try {
			ret = "(" + str.substring(0, 3) + "-" + str.substring(3) + ")";
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_bz(String str) {
		String ret = "";
		try {
			ret = str.substring(0, 3) + "-" + str.substring(3, 5) + "-" + str.substring(5);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_corp(String str) {
		String ret = "";
		try {
			ret = str.substring(0, 6) + "-" + str.substring(6);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_duns(String str) {
		String ret = "";
		try {
			ret = str.substring(0, 2) + "-" + str.substring(2, 5) + "-" + str.substring(5);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_tel(String str) {
		String ret = "";
		try {
			String remain = str.substring(8).trim();
			if(remain.length()>4) remain = remain.substring(0, 4) + "~" + remain.substring(4).trim();
			ret = "(" + str.substring(0, 4).trim() +")" + str.substring(4, 8).trim() + "-" + remain;
			if(ret.length()==3) ret = "";
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_jumin(String str) {
		String ret = "";
		try {
			ret = str.substring(0, 6) + "-" + str.substring(6);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

	public final static int CVT_YEAR = 0;
	public final static int CVT_YM = 1;
	public final static int CVT_YMD = 2;

/******************************
*******************************/
	public static int get_ymd(java.util.Date dd, int cvt_type) {
		Calendar cal = Calendar.getInstance();
		cal.setTime(dd);
		int ret = cal.get(Calendar.YEAR);
		if(cvt_type>CVT_YEAR) { ret *= 10000; ret += cal.get(Calendar.MONTH)+1; }
		if(cvt_type>CVT_YM) { ret *= 100; ret += cal.get(Calendar.DAY_OF_MONTH); }
		return 0;
	}

/******************************
*******************************/
	public static String cvt_ymd(Integer dd, int cvt_type) { return cvt_ymd(dd, cvt_type, "/"); }
/******************************
*******************************/
	public static String cvt_ymd(Integer dd, int cvt_type, String sep) {
		String ret = "";
		try {
			String str = dd.toString();
			ret = str.substring(0, 4);
			if(cvt_type>CVT_YEAR) ret += sep + str.substring(4, 6);
			if(cvt_type>CVT_YM) ret += sep + str.substring(6, 8);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_ymd(String str, int cvt_type) { return cvt_ymd(str, cvt_type, "/"); }
/******************************
*******************************/
	public static String cvt_ymd(String str, int cvt_type, String sep) {
		String ret = "";
		try {
			ret = str.substring(0, 4);
			if(cvt_type>CVT_YEAR) ret += sep + str.substring(4, 6);
			if(cvt_type>CVT_YM) ret += sep + str.substring(6, 8);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_ymd(java.util.Date dd, int cvt_type) { return cvt_ymd(dd, cvt_type, "/"); }
/******************************
*******************************/
	public static String cvt_ymd(java.util.Date dd, int cvt_type, String sep) {
		String ret = "";
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(dd);
			cal.add(Calendar.DAY_OF_MONTH, 1);
			dd = cal.getTime();
			SimpleDateFormat sdf;
			if(cvt_type==CVT_YMD) sdf = new SimpleDateFormat("yyyy"+sep+"MM"+sep+"dd");
			else if(cvt_type==CVT_YM) sdf = new SimpleDateFormat("yyyy"+sep+"MM");
			else sdf = new SimpleDateFormat("yyyy");
			ret = sdf.format(dd);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static String cvt_ym(java.util.Date dd, String sep) {
		String ret = "";
		try {
			Calendar cal = Calendar.getInstance();
			cal.setTime(dd);
			cal.add(Calendar.DAY_OF_MONTH, 1);
			dd = cal.getTime();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy" + sep + "MM");
			ret = sdf.format(dd);
		} catch(Exception e) {
			return ret;
		}
		return ret;
	}

/******************************
*******************************/
	public static int rscount(ResultSet rs) throws Exception {
		if(rs.getType()==rs.TYPE_FORWARD_ONLY) return 0;
		rs.last();
		int cnt = rs.getRow();
		rs.beforeFirst();
		return cnt;
/*
		int i=0, is;
		is=1000; i += is; while(rs.absolute(i)) i += is; i -= is;
		is=100;  i += is; while(rs.absolute(i)) i += is; i -= is;
		is=10;   i += is; while(rs.absolute(i)) i += is; i -= is;
		i++; while(rs.absolute(i)) i++; i--;
		rs.beforeFirst();
		return i;
*/
	}



/******************************
*******************************/
	public static String toTrace(Throwable e) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw);
		pw.flush();
		return Utils.ko(sw.toString());
	}

/******************************
*******************************/
	public static List map2lst(String skey[], HashMap map) {
		List ret = new ArrayList();
		for(int i=0;i<skey.length;i++)
			ret.add(map.get(skey[i]));
		return ret;
	}

/******************************
*******************************/
	public static HashMap lst2map(int ikey, List lst) { // 각각의 element가 object[]인 상태에서 object[key]를 가지고 HashMap으로 변환
		HashMap map = new HashMap();
		Iterator it = lst.iterator();
		while(it.hasNext()) {
			Object[] item = (Object[])it.next();
			map.put(item[ikey], item);
		}
		return map;
	}

/******************************
*******************************/
	public static List lst2obj(List lst) { // 각각의 element를 list에서 object[] 로 변환
		List ret = new ArrayList();
		Iterator it = lst.iterator();
		while(it.hasNext())
			ret.add(((List)it.next()).toArray());
		return ret;
	}

/******************************
*******************************/
	public static List obj2lst(List lst) { // 각각의 element를 object[]에서 list 로 변환
		List ret = new ArrayList();
		Iterator it = lst.iterator();
		while(it.hasNext())
			ret.add(Arrays.asList((Object[])it.next()));
		return ret;
	}

/******************************
*******************************/
	public static List map2obj(List lst, String[] sKey) { // 각각의 element를 HashMap에서 Object[] 로 변환
		List ret = new ArrayList();
		Iterator it = lst.iterator();
		while(it.hasNext()) {
			HashMap map = (HashMap)it.next();
			Object[] obj = new Object[sKey.length];
			for(int i=0;i<sKey.length;i++)
				obj[i] = map.get(sKey[i]);
			ret.add(obj);
		}
		return ret;
	}

/******************************
*******************************/
	public static List obj2map(List lst, String[] sKey) { // 각각의 element를 Object[]에서 HashMap 로 변환
		List ret = new ArrayList();
		Iterator it = lst.iterator();
		while(it.hasNext()) {
			Object[] obj = (Object[])it.next();
			HashMap map = new HashMap();
			for(int i=0;i<sKey.length;i++)
				map.put(sKey[i], obj[i]);
			ret.add(map);
		}
		return ret;
	}

/******************************
*******************************/
	public static List obj2str(List lst) { // 각각의 element를 Object[]에서 String[] 로 변환
		List ret = new ArrayList();
		Iterator it = lst.iterator();
		while(it.hasNext()) {
			Object[] obj = (Object[])it.next();
			String[] str = new String[obj.length];
			for(int i=0;i<obj.length;i++)
				str[i] = obj[i].toString();
			ret.add(str);
		}
		return ret;
	}

/******************************
*******************************/
	public static String df(String val) { return df(val, 0, "", true); }
/******************************
*******************************/
	public static String df(String val, int pre) { return df(val, pre, "", true); }
/******************************
*******************************/
	public static String df(String val, String nan) { return df(val, 0, nan, true); }
/******************************
*******************************/
	public static String df(String val, boolean zero) { return df(val, 0, "", zero); }
/******************************
*******************************/
	public static String df(String val, int pre, String nan, boolean zero) {
		try {
			val = replaceMark(val, ',', "");
			double dval = Double.parseDouble(val);
			if(dval==0. && zero) return "";
			if(Math.floor(dval)==9999999999. || Double.isNaN(dval) || Double.isInfinite(dval)) return nan;
			String ret = df[pre].format(dval);
			return ret;
		} catch(Exception e) {return nan;}
	}

/******************************
*******************************/
	public static String df(Double val) { return df(val, 0, "", true); }
/******************************
*******************************/
	public static String df(Double val, int pre) { return df(val, pre, "", true); }
/******************************
*******************************/
	public static String df(Double val, String nan) { return df(val, 0, nan, true); }
/******************************
*******************************/
	public static String df(Double val, boolean zero) { return df(val, 0, "", zero); }
/******************************
*******************************/
	public static String df(Double val, int pre, String nan, boolean zero) {
		try {
			double dval = val.doubleValue();
			if(dval==0. && zero) return "";
			if(Math.floor(dval)==9999999999. || Double.isNaN(dval) || Double.isInfinite(dval)) return nan;
			String ret = df[pre].format(dval);
			return ret;
		} catch(Exception e) {return nan;}
	}

/******************************
*******************************/
	public static String df(Integer val) { return df(val, 0, "", true); }
/******************************
*******************************/
	public static String df(Integer val, int pre) { return df(val, pre, "", true); }
/******************************
*******************************/
	public static String df(Integer val, String nan) { return df(val, 0, nan, true); }
/******************************
*******************************/
	public static String df(Integer val, boolean zero) { return df(val, 0, "", zero); }
/******************************
*******************************/
	public static String df(Integer val, int pre, String nan, boolean zero) {
		try {
			double dval = val.intValue();
			if(dval==0. && zero) return "";
			if(Math.floor(dval)==9999999999. || Double.isNaN(dval) || Double.isInfinite(dval)) return nan;
			String ret = df[pre].format(dval);
			return ret;
		} catch(Exception e) {return nan;}
	}

/******************************
*******************************/
	public static String df(double val) { return df(val, 0, "", true); }
/******************************
*******************************/
	public static String df(double val, int pre) { return df(val, pre, "", true); }
/******************************
*******************************/
	public static String df(double val, String nan) { return df(val, 0, nan, true); }
/******************************
*******************************/
	public static String df(double val, boolean zero) { return df(val, 0, "", zero); }
/******************************
*******************************/
	public static String df(double val, int pre, String nan, boolean zero) {
		try {
			if(val==0. && zero) return "";
			if(Math.floor(val)==9999999999. || Double.isNaN(val) || Double.isInfinite(val)) return nan;
			String ret = df[pre].format(val);
			return ret;
		} catch(Exception e) {return nan;}
	}

/******************************
*******************************/
	public static String df(int val) { return df(val, 0, "", true); }
/******************************
*******************************/
	public static String df(int val, int pre) { return df(val, pre, "", true); }
/******************************
*******************************/
	public static String df(int val, String nan) { return df(val, 0, nan, true); }
/******************************
*******************************/
	public static String df(int val, boolean zero) { return df(val, 0, "", zero); }
/******************************
*******************************/
	public static String df(int val, int pre, String nan, boolean zero) {
		try {
			if(val==0. && zero) return "";
			if(Math.floor(val)==9999999999.) return nan;
			String ret = df[pre].format(val);
			return ret;
		} catch(Exception e) {return nan;}
	}

/******************************
*******************************/
	public static String out_s(List arg) { return out_s(arg, "<br>");	}
/******************************
*******************************/
	public static String out_s(List arg, String app) {
		StringBuffer buffer = new StringBuffer();
		Iterator lit = arg.iterator();
		while(lit.hasNext()) {
			String[] dat = (String[])lit.next();
			buffer.append('[');
			for(int i=0;i<dat.length-1;i++) { buffer.append(dat[i]); buffer.append(',');}
			buffer.append(dat[dat.length-1]);
			buffer.append("]");
			buffer.append(app);
		}
		return buffer.toString();
	}

/******************************
 * List의 데이타 값을 스트링으로 변환해서 출력한다. 디폴트 구분문자는 &lt;br&gt;.
*******************************/
	public static String out_o(List arg) { return out_o(arg, "<br>");	}
/******************************
 * List의 데이타 값을 스트링으로 변환해서 출력한다.
*******************************/
	public static String out_o(List arg, String app) {
		StringBuffer buffer = new StringBuffer();
		Iterator lit = arg.iterator();
		while(lit.hasNext()) {
			Object obj = lit.next();
			if(obj instanceof Object[])
				buffer.append(out_o((Object[])obj));
			else
				buffer.append(obj);
			buffer.append(app);
		}
		return buffer.toString();
	}

/******************************
*******************************/
	public static String out_o(TreeMap arg) { return out_o(arg, "<br>");	}
/******************************
*******************************/
	public static String out_o(TreeMap arg, String app) {
		StringBuffer buffer = new StringBuffer();
		Iterator lit = arg.entrySet().iterator();
		while(lit.hasNext()) {
			Map.Entry map = (Map.Entry)lit.next();
			buffer.append(map.getKey()); buffer.append("=");
			Object obj = map.getValue();
			if(obj instanceof Object[]) {
				Object[] dat = (Object[])obj;
				buffer.append('[');
				for(int i=0;i<dat.length-1;i++) { buffer.append(dat[i].toString()); buffer.append(',');}
				buffer.append(dat[dat.length-1]);
				buffer.append("]");
				buffer.append(app);
			}
			else {
				buffer.append(obj);
			}
		}
		return buffer.toString();
	}

/******************************
*******************************/
	public static String out_o(Object[] obj) {
		StringBuffer buffer = new StringBuffer();
		buffer.append('[');
		for(int i=0;i<obj.length-1;i++) { buffer.append(obj[i]); buffer.append(',');}
		buffer.append(obj[obj.length-1]);
		buffer.append("]");
		return buffer.toString();
	}

//	if(Utils.hancheck((byte[])obj, 2036)) sp_idx = 2035; else sp_idx = 2036;
/******************************
*******************************/
	public static boolean hancheck(String sText, int nPos) { return hancheck(sText.getBytes(), nPos, true); }
/******************************
*******************************/
	public static boolean hancheck(String sText) { return hancheck(sText.getBytes(), 0, true); }
/******************************
*******************************/
	public static boolean hancheck(byte[] sText, int nPos) { return hancheck(sText, nPos, true); }
/******************************
*******************************/
	public static boolean hancheck(byte[] sText) { return hancheck(sText, 0, true); }
/******************************
*******************************/
	public static boolean hancheck(byte[] sText, int nPos, boolean nDir) {
		boolean ret = false;
		int len = sText.length;
		if(sText==null || len==0 || nPos>=len) return ret;
		if(nDir) {
			while(nPos<len && sText[nPos]<0) {
				nPos++;
				ret = !ret;
			}
		}
		else {
			while(nPos>0 && sText[nPos]<0) {
				nPos--;
				ret = !ret;
			}
		}
		return ret;
	}

/******************************
 * 스트링이 한글코드페이지에 맞는지 확인. DB에 저장할때 에러를 방지하기 위함임.
*******************************/
	public static boolean checkStr(String str) {
		return str.equals(new String(str.getBytes()));
	}

/******************************
 * 스트링이 한글코드페이지에 맞는지 확인. DB에 저장할때 에러를 방지하기 위함임.
*******************************/
	public static boolean checkStr(String str, String[] ret) {
		String cret;
		if(ret!=null) {
			ret[0] = new String(str.getBytes());
			cret = ret[0];
		}
		else
			cret = new String(str.getBytes());
		return str.equals(cret);
	}

	private static Class ci, cb, csl, csrl, caal, cal, chm, cl, cm;
	static {
		try {
			ci = Class.forName("java.lang.Integer");
			cb = Class.forName("java.lang.Boolean");
			caal = Class.forName("java.util.Arrays$ArrayList");
			cal = Class.forName("java.util.ArrayList");
			csl = Class.forName("java.util.SubList");
			csrl = Class.forName("java.util.RandomAccessSubList");
			chm = Class.forName("java.util.HashMap");
			cl = Class.forName("java.util.List");
			cm = Class.forName("java.util.Map");
		} catch (Exception e) {}
	}

/******************************
*******************************/
	public static Method Method(Class _class, String name, Object[] arg) throws Exception {
		Method _meth = null;
		try {
			Class[] _arg = new Class[arg.length];
			for(int i=0;i<arg.length;i++) _arg[i] = arg[i].getClass();
			try {
				_meth = _class.getMethod(name, _arg);
			}
			catch (NoSuchMethodException e) {
				for(int i=0;i<arg.length;i++) {
					if(_arg[i]==ci) _arg[i] = Integer.TYPE;
					else if(_arg[i]==cb) _arg[i] = Boolean.TYPE;
					else if(_arg[i]==csl) _arg[i] = cl;
					else if(_arg[i]==csrl) _arg[i] = cl;
					else if(_arg[i]==caal) _arg[i] = cl;
					else if(_arg[i]==cal) _arg[i] = cl;
					else if(_arg[i]==chm) _arg[i] = cm;
				}
				try {
					_meth = _class.getMethod(name, _arg);
				} catch(Exception ee) { throw ee; }
			}
		} catch(Exception e) { throw e; }
		return _meth;
	}

/******************************
 * Object Array에서 idx의 위치에 값을 끼워넣는다. 마지막 데이타는 삭제됨
*******************************/
	public static void insert(Object[] obj, int idx, Object ins) {
		int i = i=obj.length-1;
		for(;i>idx;i--) obj[i] = obj[i-1];
		obj[i] = ins;
	}

/******************************
 * Object Array에서 idx 위치 값을 삭제한다. 마지막 데이타는 null로 채움
*******************************/
	public static void delete(Object[] obj, int idx) {
		for(int i=idx;i<obj.length-1;i++) obj[i] = obj[i+1];
		obj[obj.length-1] = null;
	}

/******************************
*******************************/
	public static void log(String log, String user, HttpServletRequest request) {
		Enumeration lst = request.getParameterNames();
		StringBuffer sb = new StringBuffer();
		sb.append(request.getRemoteAddr()); sb.append(' ');
		sb.append(request.getRequestURI());
		sb.append('|'); sb.append(user!=null?user:""); sb.append('|');
		if(lst.hasMoreElements())
			while(true) {
				String param_nm = (String)lst.nextElement();
				String[] param_v = request.getParameterValues(param_nm);
				param_nm = ko(param_nm);
				for(int i=0;i<param_v.length;i++) {
					sb.append(param_nm);
					sb.append("=");
					byte[] pp = param_v[i].getBytes();
					if(pp.length>40)
						sb.append("(memo)");
					else
						sb.append(ko(param_v[i]));
					if(i<param_v.length-1) sb.append('&');
				}
				if(!lst.hasMoreElements()) break;
				sb.append('&');
			}
		sb.append('|');
		//NiceLog.getInstance().logout(log, sb.toString());
	}

/******************************
*******************************/
	public static void logs(String log, String user, HttpServletRequest request) {
		Enumeration lst = request.getParameterNames();
		StringBuffer sb = new StringBuffer();
		sb.append(request.getServerName()); sb.append(' ');
		sb.append(request.getRemoteAddr()); sb.append(' ');
		sb.append(request.getRequestURI());
		sb.append('|'); sb.append(user!=null?user:""); sb.append('|');
		if(lst.hasMoreElements())
			while(true) {
				String param_nm = (String)lst.nextElement();
				String[] param_v = request.getParameterValues(param_nm);
				param_nm = ko(param_nm);
				for(int i=0;i<param_v.length;i++) {
					sb.append(param_nm);
					sb.append("=");
					byte[] pp = param_v[i].getBytes();
					if(pp.length>40)
						sb.append("(memo)");
					else
						sb.append(ko(param_v[i]));
					if(i<param_v.length-1) sb.append('&');
				}
				if(!lst.hasMoreElements()) break;
				sb.append('&');
			}
		sb.append('|');
		//NiceLog.getInstance().logout(log, sb.toString());
	}

/******************************
 * 문자열의 데이타를 분석하여 날짜형태(yyyyMMDD)의 스트링을 출력한다. 문자열 중간의 숫자가 아닌 문자는 무시되며 세기(20, 19)가 표시되지 않으면 추가한다.
*******************************/
	public static String ymd(String str) throws Exception {
		if(str==null) return "";
		int idx_y=0;
		byte[] dat = str.getBytes();
		byte[] out = new byte[4];
		int j=0;
		String ret = "";
		for(int i=0;i<dat.length;i++)
			if(dat[i]>='0' && dat[i]<='9') {
				if((idx_y==0 && j<4) || (j<2)) out[j++] = dat[i];
			}
			else {
				if(j>0) {
					if(idx_y==0) {
						if(j==2) {
							if(out[0]=='0') ret = "20"+new String(out, 0, 2);
							else ret = "19"+new String(out, 0, 2);
						}
						else
							ret = new String(out, 0, j);
					}
					else {
						if(j==1) ret += "0"+(out[0]-'0');
						else ret += new String(out, 0, 2);
					}
					j = 0;
					idx_y++;
					if(idx_y>2) break;
				}
			}
		if(idx_y<3 && j>0) {
			if(idx_y==0) {
				if(j==2) {
					if(out[0]=='0') ret = "20"+new String(out, 0, 2);
					else ret = "19"+new String(out, 0, 2);
				}
				else
					ret = new String(out, 0, j);
			}
			else {
				if(j==1) ret += "0"+(out[0]-'0');
				else ret += new String(out, 0, 2);
			}
		}
		return ret;
	}

/******************************
 * 문자열의 데이타를 분석하여 날짜형태(yyyyMMDD)의 스트링을 출력한다. 문자열 중간의 숫자가 아닌 문자는 무시되며 세기(20, 19)가 표시되지 않으면 추가한다.
*******************************/
	public static String date(String str) throws Exception {
		if(str==null) return "";
		StringBuffer[] s = new StringBuffer[3];
		for(int i=0;i<3;i++) s[i] = new StringBuffer();
		char[] dat = str.toCharArray();
		int idx=0;
		for(int i=0;i<dat.length;i++)
			if(dat[i]>='0' && dat[i]<='9') s[idx].append(dat[i]);
			else if(s[idx].length()>0) { idx++; if(idx==3) break; }
		StringBuffer ret = new StringBuffer();
		if(s[0].length()==2) ret.append("19"); ret.append(s[0]);
		if(s[1].length()==1) ret.append("0"); ret.append(s[1]);
		if(s[2].length()==1) ret.append("0"); ret.append(s[2]);
		return ret.toString();
	}

/******************************
 * 문자열중 숫자가 아닌 문자들은 삭제하고 출력한다. 숫자값의 ','를 제거하는데 유용하다.
*******************************/
	public static String num(String str) throws Exception {
		if(str==null) return "";
		char[] dat = str.toCharArray();
		char[] out = new char[dat.length];
		int j=0;
		boolean first = true;
		for(int i=0;i<dat.length;i++) if(first && (dat[i]=='-'||dat[i]=='.')) {out[j++] = dat[i]; first=false;} else if(dat[i]>='0' && dat[i]<='9' || dat[i]=='.') { out[j++] = dat[i]; first=false; }
		String ret = new String(out, 0, j);
		if(".".equals(ret) || "-".equals(ret)) return ""; else return ret;
	}

/******************************
 * URL중에 특수문자는 %XX 로 표시되는 이것을 일반 문자로 바꿔준다.
*******************************/
	public static String cvt_url(String str) throws Exception {
		byte[] dat = str.getBytes();
		byte[] out = new byte[dat.length];
		int j=0;
		for(int i=0;i<dat.length;i++) {
			if(dat[i]=='%') {
				i++;
				byte[] tmp = new byte[2]; tmp[0] = dat[i++]; tmp[1] = dat[i];
				out[j++] = (byte)Integer.parseInt(new String(tmp), 16);
			}
			else if(dat[i]=='+')
				out[j++] = ' ';
			else
				out[j++] = dat[i];
		}
		return new String(out, 0, j);
	}

/******************************
 * 이중키값을 같는 리스트에서 맨 앞의 키를 출력한다. 보통의 Collecions.binarySearch를 하게 되면 중간의 값을 출력할수도 있다.
*******************************/
	public static int binarySearch(List l, Object okey, Comparator c) {
		int idx = Collections.binarySearch(l, okey, c);
		while(idx>0) {
			idx--;
	   	int cmp = c.compare(l.get(idx), okey);
	   	if(cmp!=0) return idx+1;
		}
		return idx;
	}

	public static blank be = new blank();
	public static blank bv = new blank("&nbsp;");
	public static class blank {
		private String blank;
		private blank() { blank = ""; fill_str(); }
		private blank(String blank) { this.blank = blank; fill_str(); }
		private void fill_str() {
			for(int i=0;i<blank_str.length;i++) {
				blank_str[i] = new String[i];
				for(int j=0;j<blank_str[i].length;j++) blank_str[i][j] = blank;
			}
		}
		public String b(Object str) { // hide
			if(str==null || "".equals(str) || "null".equals(str)) return blank; else if(str instanceof String) return ((String)str).trim(); else return str.toString();
		}
		public String b(Object str, String def) { // hide
			if(str==null || "".equals(str) || "null".equals(str)) return def; else if(str instanceof String) return ((String)str).trim(); else return str.toString();
		}
		public String[] b(String[] str) { for(int i=0;i<str.length;i++) str[i] = b(str[i]); return str;}
		public String[][] blank_str = new String[10][];

//		private List blank_lst = new Vector();
		public String[] b(Iterator lit, int len) throws Exception {
			String[] ret = lit.hasNext()?(String[])lit.next():blank_str[len];
			String[] tmp = new String[len];
			int last = ret.length; if(last>len) last = len;
			for(int i=0;i<last;i++) tmp[i] = b(ret[i]);
			for(int i=ret.length;i<len;i++) tmp[i] = blank;
			return tmp;
		}
		public List _blst(HashMap cmp, String name) throws Exception {
			Object obj = cmp.get(name);
			if(obj==null)
				return new Vector();
			else if(obj instanceof String) {
				String[] sp = Utils.split((String)obj, '\n');
				List ldat = new Vector();
				for(int i=0;i<sp.length;i++)
					ldat.add(Utils.split(sp[i], '\t'));
				return ldat;
			}
			else
				return (List)obj;
		}
		public Iterator blst(HashMap cmp, String name) throws Exception { return _blst(cmp, name).iterator(); }
		public String[] bstr(HashMap cmp, String name) throws Exception {
			String[] dat = (String[])cmp.get(name);
			if(dat==null) return blank_str[0];
			String[] tmp = new String[dat.length];
			for(int i=0;i<dat.length;i++) tmp[i] = b(dat[i]);
			return tmp;
		}
		public String[] bstr(HashMap cmp, String name, int len) throws Exception {
			String[] dat = (String[])cmp.get(name);
			if(dat==null) { dat = new String[len]; Arrays.fill(dat, blank); return dat; }
			String[] tmp = new String[len];
			int last = dat.length; if(last>len) last = len;
			for(int i=0;i<last;i++) tmp[i] = b(dat[i]);
			for(int i=dat.length;i<len;i++) tmp[i] = blank;
			return tmp;
		}
		public String[] bstr(HashMap cmp, String name, int len, char ch) throws Exception {
			String[] dat;
			Object obj = cmp.get(name);
			if(obj==null) { dat = new String[len]; Arrays.fill(dat, blank); return dat; }
			if(obj instanceof String) dat = Utils.split((String)obj, ch); else dat = (String[])obj;
			String[] tmp = new String[len];
			int last = dat.length; if(last>len) last = len;
			for(int i=0;i<last;i++) tmp[i] = b(dat[i]);
			for(int i=dat.length;i<len;i++) tmp[i] = blank;
			return tmp;
		}
	}	
}

