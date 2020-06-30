package nicednb.license;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.Properties;

/**
 * config.license (라이센스 설정 파일) 파일 값을 읽는다.
 * @author yisu_park@hotmail.com
 *
 */
public class NiceDnBLicenseConfig {
	
	private static Properties configProps = null;
	
	static {
		try {
			//라이센스 설정 파일을 읽는다
			NiceDnBPropertiesReader propsReader = new NiceDnBPropertiesReader();
			configProps = propsReader.getProperties("config.license");
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static String getConfig(String key){
		if(configProps == null) return null;
		return String.valueOf(configProps.get(key));
	}
	
	/**
	 * 라이센스 파일을 생성할 기본 디렉토리
	 * @return
	 */
	public static String getBaseDir(){
		return getConfig("base_dir");
	}
	
	/**
	 * 라이센스 정책 (Term)
	 * @return
	 */
	public static String getTerm(){
		String term = null;
		try {
			term = new String(getConfig("license_term").getBytes("ISO-8859-1"), "euc-kr");
			return term.replaceAll("\\n", System.getProperty("line.separator"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return null;
		}
	}
}
