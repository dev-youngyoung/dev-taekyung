package nicelib.sap;

import java.util.Properties;

import com.sap.mw.jco.IRepository;
import com.sap.mw.jco.JCO;

public class JcoCaller {
	
	private static final String POOL_NAME = "ECSR3";
	private static final String PROPERTIES_PATH = "/jco.properties";

	private IRepository repository;
	
	public JcoCaller() {
		try {
        	JCO.Pool pool = JCO.getClientPoolManager().getPool(POOL_NAME);
        	if (pool == null) {
        		// Add a connection pool to the specified system
        		Properties p = new Properties();
        		p.load(JcoCaller.class.getResourceAsStream(PROPERTIES_PATH));
        		JCO.addClientPool(POOL_NAME, 30, p);
        		/*
    			JCO.addClientPool(POOL_NAME,   		// Alias for this pool
    							  10,          		// Max. number of connections
    							  "520", 			// SAP client
    					          "nmmjks",          // userid
    					          "654321",       	// password
    					          "KO",             // language
    					          "172.25.1.125",   // application server host name
    					          "00");            // system number
				*/
    			/*
        		JCO.addClientPool(POOL_NAME,   		// Alias for this pool
						  10,          		// Max. number of connections
						  "350", 			// SAP client
				          "nmmjks",          // userid
				          "654321",       	// password
				          "KO",             // language
				          "172.30.10.102",   // application server host name
				          "00");            // system number
				 */
        	}
			// Create a new repository
        	repository = JCO.createRepository("MYRepository", POOL_NAME);
		} catch (Exception ex) {
			System.out.println("Caught an exception: \n" + ex);
		}
	}
	
    //SAP ERP에 연결하고 연결객체를 반환합니다.
	public JCO.Client getClient() {
		return JCO.getClient(POOL_NAME);
	}
	
    public IRepository getRepository() {
    	return repository;
    }
}