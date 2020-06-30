package nicednb.license;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.net.InetAddress;
import java.net.URL;
import java.util.HashMap;

/**
 * ���̼��� ������ �д´� (��ȣȭ)
 * @author jake
 *
 */
public class NiceDnBLicenseReader {
	
	private String licenseFilePath = null;
	private static boolean isValidLicense = false;
	private static NiceDnBLicenseReader instance = null;
	
	public static void main(String[] args) throws Exception{
		if(args.length > 0) System.setProperty("license.nicednb.file", args[0]);
		NiceDnBLicenseReader reader = NiceDnBLicenseReader.getInstance();
		System.out.println(reader.isValidLicense());
	}
	
	public static NiceDnBLicenseReader getInstance(){
		if(instance == null) instance = new NiceDnBLicenseReader();
		instance.init();
		return instance;
	}
	
	public void init(){
		/**
		 * system������ license.nicednb.file�� ������ ��� �ش� ��θ� Ž��
		 * �������� ���� ��� /license/license.nicednb�� �⺻ ��η� Ž���Ѵ�.
		 */
		licenseFilePath = System.getProperty("license.nicednb.file", "/license/license.nicednb");
		System.out.println("license file path:"+licenseFilePath);
		try {
			readLincese();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	public boolean isValidLicense() {
		return isValidLicense;
	}
	
	/**
	 * �ʱ�ȭ - ���̼��� ������ �а� �м��Ѵ�.
	 * @throws Exception
	 */
	private void readLincese() throws Exception{
		URL licenseUrl = Thread.currentThread().getContextClassLoader().getResource(licenseFilePath);
		
		System.out.println(licenseUrl.toURI());
		//licenseUrl.toURI();
		File file = new File(licenseUrl.toURI());
		if(file.exists() == false) throw new Exception("doesn't exist "+file.getAbsolutePath());

		HashMap<String, String> dataMap = new HashMap<String, String>();
		BufferedReader br = null;
		
		try{
			String line = null;
			String licenseText = null;
			
			String keyNameHashCode = null;
			int dummyCnt = 0;
			int lineIdx = 0;

			br = new BufferedReader(new FileReader(file));
			
			while( (line = br.readLine()) != null ){
				lineIdx++;
				
				if(lineIdx == 1){
					//��ü��
					keyNameHashCode = String.valueOf(line.hashCode());
					System.out.println("Licensed Company Name:"+line);
					continue;
				}
				
				if(line.equals(keyNameHashCode)){
					//��ü���� �� ���� �����ڷ� �����
					dummyCnt++;
					continue;
				}
				
				if(dummyCnt == 2){
					//��ü���� �ؽð��� �� �� ���� �� ���� ������ ����
					licenseText = new String(shiftToRight(line.getBytes()));
					dataMap.put(licenseText, null);
					System.out.println("Licensed IP:"+licenseText);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			if(br != null) br.close();
		}
		
		// get local ip
		String addr = InetAddress.getLocalHost().getHostAddress();
		
		isValidLicense = dataMap.containsKey(addr);
	}
	
	/**
	 * ���̼��� ���� ����
	 * @param data
	 * @return
	 */
	private byte[] shiftToRight(byte[] data){
		byte[] returnData = new byte[data.length];
		
		for(int i=0;i<data.length;i++){
			returnData[i] = (byte) (data[i]>>1);
		}
		
		return returnData;
		
	}
}
