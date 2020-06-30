package nicednb.license;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * classpath에 설정된 properties 파일을 읽어온다 
 * @author yisu_park@hotmail.com
 */
public class NiceDnBPropertiesReader {
	
	private Properties props = null;
	
	public Properties getProperties(String filePath) throws IOException {
		// ClassLoader로 InputStream 생성
		// InputStream is = ClassLoader.getSystemResourceAsStream(filePath);
		InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream(filePath);
		Properties props = new Properties();
		props.load(is);
		return props;
	}
	
	public String getProperty(String key){
		if(props == null) return null;
		return String.valueOf(props.get(key));
	}
}
