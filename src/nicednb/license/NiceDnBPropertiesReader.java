package nicednb.license;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

/**
 * classpath�� ������ properties ������ �о�´� 
 * @author yisu_park@hotmail.com
 */
public class NiceDnBPropertiesReader {
	
	private Properties props = null;
	
	public Properties getProperties(String filePath) throws IOException {
		// ClassLoader�� InputStream ����
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
