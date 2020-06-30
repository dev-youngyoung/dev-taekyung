package nicednb.license;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

/**
 * ���̼��� ���� ����
 * @author yisu_park@hotmail.com
 *
 */
public class NiceDnBLicenseWriter {
	
	public static void main(String[] args) throws IOException{
		
		/*
		args = new String[2];
		args[0] = "�׽�Ʈ2";
		args[1] = "172.28.5.97";
		*/
		
		if(args == null || args.length < 2){
			System.out.println("Usage : java nicednb.license.NiceDnBLicenseWriter ��ü�� ip1 [ip2 ip3 ...]");
		}
		writeLicense(args);
	}
	
	/**
	 * ���̼��� ���� ����
	 * @param args
	 * @throws IOException
	 */
	private static void writeLicense(String[] args) throws IOException {
		
		System.out.println("Start to make license file");
		String baseDir = NiceDnBLicenseConfig.getBaseDir();			//directory to write license
		String term = NiceDnBLicenseConfig.getTerm();				//license term
		int companyNameHashValue = args[0].hashCode();				//license ���� Ű ��
		
		System.out.println("term:"+ term);
		
		File licenseFolder = new File(baseDir+"/"+args[0]);
		File licenseFile = new File(licenseFolder.getPath()+"/license.nicednb");
		
		System.out.println("licenseFile.exists():"+licenseFolder.exists());
		if( licenseFolder.exists() == false) licenseFolder.mkdirs();
		
		FileOutputStream fos = null;
		
		try {
			fos = new FileOutputStream(licenseFile);
			fos.write(args[0].getBytes());
			fos.write(System.getProperty("line.separator").getBytes());	//���̼�����(ȸ���)
			
			fos.write(term.getBytes());
			fos.write(System.getProperty("line.separator").getBytes());	//���̼�����å
			
			//fos.write(("License Key: "+companyNameHashValue).getBytes());
			//fos.write(System.getProperty("line.separator").getBytes());	//���̼��� Ű (���̼����� hashCode)
			
			//�� ���ڿ��� ������ �������� shift���� ����
			fos.write((companyNameHashValue+"").getBytes());
			fos.write(System.getProperty("line.separator").getBytes());
			
			fos.write(shiftToLeft(term.getBytes()));
			fos.write(System.getProperty("line.separator").getBytes());	//dummy data
			
			//���� ������ ������ �˸��� ���� ���ڿ� (���̼������� hashCode)
			fos.write((companyNameHashValue+"").getBytes());
			fos.write(System.getProperty("line.separator").getBytes());
			
			//���� license�� ���� �� ����� ����
			for(int i=1;i<args.length;i++){
				fos.write(shiftToLeft(args[i].getBytes()));
				
				if(i < args.length-1){
					fos.write(System.getProperty("line.separator").getBytes());
				}
			}
			
			fos.flush();
			System.out.println("Succeeded to make license file");
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("Failed to make license file");
		}finally{
			if(fos != null){
				try {
					fos.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	private static byte[] shiftToLeft(byte[] data){
		byte[] returnData = new byte[data.length];
		
		for(int i=0;i<data.length;i++){
			returnData[i] = (byte) (data[i]<<1);
		}
		
		System.out.println(new String(data)+"="+new String(returnData));
		
		return returnData;
		
	}
}
