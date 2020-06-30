package procure.common.conf;


import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.XMLConfiguration;
import org.apache.commons.configuration.reloading.FileChangedReloadingStrategy;

public class Startup extends HttpServlet {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	public	static XMLConfiguration conf	=	null; 
	
	/**
	 * Initialization of the servlet. <br>
	 *
	 * @throws ServletException if an error occurs
	 */
	public void init(ServletConfig config) throws ServletException {
	
		try {
			XMLConfiguration.setDefaultListDelimiter('^');
			conf =	new	XMLConfiguration("conf.xml");
			conf.setReloadingStrategy(new FileChangedReloadingStrategy());

		} catch (ConfigurationException e) {
			e.printStackTrace();
		}
	}

	/**
	 * Destruction of the servlet. <br>
	 */
	public void destroy() {
		super.destroy(); // Just puts "destroy" string in log
		// Put your code here
	}

}
