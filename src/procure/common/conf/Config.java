package procure.common.conf;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.XMLConfiguration;
import org.apache.commons.configuration.reloading.FileChangedReloadingStrategy;


/**
 * xml 설정파일 읽기
 * @author lee jong whan
 *
 */
public class Config {
	private			String					sFileName	=	"";
	private	static	Config					config		=	null;
	private 		CompositeConfiguration 	ccf 		= 	null;
	
	/**
	 * 인스턴스 생성
	 * @param sFileName	설정파일명
	 * @return
	 * @throws ConfigurationException 
	 */
	public static CompositeConfiguration getInstance(String sFileName) throws ConfigurationException
	{
		try {
			if (config == null) {
				config = new Config();
	        }
			config.sFileName	=	sFileName;
			config.setConfig();
		} catch (ConfigurationException e) {
			System.out.println("[ERROR Config.getInstance()] :" + e.toString());
			throw new ConfigurationException("[ERROR Config.getInstance()] :" + e.toString());
		}
		return config.getConf();
	}
	
	/**
	 * 인스턴스 생성
	 * @return
	 * @throws ConfigurationException 
	 */
	public static CompositeConfiguration getInstance() throws ConfigurationException
	{
		try {
			if (config == null) {
	        	config = new Config();
	        }
			config.sFileName	=	"conf.xml";
			config.setConfig();
		} catch (ConfigurationException e) {
			System.out.println("[ERROR Config.getInstance()] :" + e.toString());
			throw new ConfigurationException("[ERROR Config.getInstance()] :" + e.toString());
		}
		return config.getConf();
	}
	
	/**
	 * 설정파일 로딩
	 * @throws ConfigurationException 
	 */
	private void setConfig() throws ConfigurationException {
		try {
			this.ccf = new CompositeConfiguration();
			XMLConfiguration.setDefaultListDelimiter('^');
			
			//System.out.println("------this.sFileName : " + this.sFileName);
			XMLConfiguration conf =	new	XMLConfiguration(this.sFileName);
			//conf.setReloadingStrategy(new FileChangedReloadingStrategy());
			this.ccf.addConfiguration(conf);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass()+".setConfig()] :" + e.toString());
			throw new ConfigurationException("[ERROR "+this.getClass()+".setConfig()] :" + e.toString());
		}
    }
	
	/**
	 * CompositeConfiguration 객체 가져오기
	 * @return
	 */
	public CompositeConfiguration	getConf()
	{
		//System.out.println("------this.ccf : " + this.ccf);
		return this.ccf;
	}
}
