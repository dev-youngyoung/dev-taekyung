package procure.common.file;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.GregorianCalendar;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import nicelib.db.DataSet;

import org.apache.commons.configuration.CompositeConfiguration;
import org.apache.commons.configuration.ConfigurationException;

import procure.common.conf.Config;
import procure.common.utils.StrUtil;
import net.sf.jazzlib.Deflater;
import net.sf.jazzlib.ZipEntry;
import net.sf.jazzlib.ZipOutputStream;

public class MakeZip { 
	ArrayList files = new ArrayList();
	
	public MakeZip(){
		
	}
	
	public MakeZip(ArrayList files)
	{
		this.files = files;
	}
	
	public MakeZip(String[] file)
	{
		setFiles(file);
	}
	
	public MakeZip(String file)
	{
		String[] saFile	=	new	String[1];
		saFile[0]	=	file;
		setFiles(saFile);
	}
	
	public void setFiles(String[] file){
		if(file == null || file.length==0) return ;
		
		files.clear();
		
		for(int i=0; i < file.length; i++)
		{
			files.add(file[i]);
		}
	}
	
	/**
	 * �������� �����
	 * @param sProKey	������Ƽ ��θ�
	 * @param sSubInUrl	��ü ��θ�(������Ƽ ��θ��� �������� ���� ���� ���� ��ü ���)
	 * @param subOutDir	������ ���� ��� ���丮��
	 * @return
	 */
	public boolean make(String sProKey, String sSubInUrl, String subOutDir)
	{
		String	sInFile		= 	"";	//	������ ���ϸ�
		String	sSubInDir	=	"";	//	������ ���� ���丮(���� ������)
		sSubInUrl	=	StrUtil.replace(sSubInUrl,"\\",File.separator);
		sSubInUrl	=	StrUtil.replace(sSubInUrl,"/",File.separator);	
		
		sInFile		=	sSubInUrl.substring(sSubInUrl.lastIndexOf(File.separator.toString())+1);
		sSubInDir	=	sSubInUrl.substring(0,sSubInUrl.lastIndexOf(File.separator.toString())+1);
		
		String[]	saFile	=	new	String[1];
		saFile[0]	=	sInFile;
		
		this.setFiles(saFile);
		
		return this.make(sProKey, sSubInDir, subOutDir, false);
	}
	
	/**
	 * �������� �����
	 * @param sProKey	������Ƽ�� ���ǵ� ���� ���
	 * @param subInDir	������ ���
	 * @param subOutDir	������  ���
	 * @param isAll
	 * @return
	 */
	public boolean make(String sProKey, String subInDir, String subOutDir, boolean isAll)
	{
		boolean	bMake	=	true;
		
		try {
			CompositeConfiguration conf = Config.getInstance();
			String	sProURL			=	conf.getString(sProKey);	//	������Ƽ�� ���ǵ� ���� ���	
			String	sInFullURL		=	sProURL	+	subInDir;	//	������ ���(���� ���� ��ü)
			String	sMakeFullURL	=	sProURL	+	subOutDir;	//	������  ���(���� ���� ��ü)
				
			bMake =	this.make(sInFullURL, sMakeFullURL, isAll);
		} catch (ConfigurationException e) {
			System.out.println("[ERROR "+this.getClass().getName() + ".make()] :" + e.toString());
		}
		return bMake;
	}
	
	/**
	 * �������� �����
	 * @param dir				������ ���丮
	 * @param targetFullPath	�������� ���� ���丮(�������ϸ� ����)
	 * @param isAll				��ü�� ������ ������ ����
	 * @return
	 */
	public boolean make(String dir, String targetFullPath, boolean isAll)
	{
		dir				=	StrUtil.replace(dir,"\\",File.separator);
		dir				=	StrUtil.replace(dir,"/",File.separator);
		
		targetFullPath	=	StrUtil.replace(targetFullPath,"\\",File.separator);
		targetFullPath	=	StrUtil.replace(targetFullPath,"/",File.separator);
		
	   File d = new File(dir);
	   if (!d.isDirectory()){
		   System.out.println("���丮�� �ƴմϴ�");
		   return false;
	   }
	   
	   if(targetFullPath==null || targetFullPath.equals("")){
		   System.out.println("���� ���� �̸��� �� �� �Ǿ����ϴ�");
		   return false;		   
	   }
	   
	   int pos = targetFullPath.lastIndexOf(File.separator);
	   String targetDir = targetFullPath.substring(0, pos+1);
	   
	   try{
		   this.checkDirectory(targetDir);
	   }catch(Exception e){
		   System.out.println("[ERROR "+this.getClass().getName() + ".make()] :" + e.toString());
		   return false;
	   }

	   String[] entries = null;
	   if(isAll) entries = d.list();
	   else{
		   Object[] o = files.toArray();
		   int length = o.length;
		   entries = new String[length];
		   for(int i=0; i < files.size(); i++){
			   entries[i] = (String)o[i]; 
		   }		   
	   }
	   
	   byte[] buffer = new byte[4096]; // Create a buffer for copying
	   int bytesRead;	   
	   
	   try{
		   ZipOutputStream out = new ZipOutputStream(new FileOutputStream(targetFullPath));
	   
		   out.setLevel(Deflater.DEFAULT_COMPRESSION);

		   for (int i = 0; i < entries.length; i++) {
			   File f = new File(d, entries[i]);
			   if (f.isDirectory())	   continue;//���丮 ����
			   
			   FileInputStream in = new FileInputStream(f); // Stream to read file
			   ZipEntry entry = new ZipEntry(f.getName()); // Make a ZipEntry
			   out.putNextEntry(entry); // Store entry
			   while ((bytesRead = in.read(buffer)) != -1)
				   out.write(buffer, 0, bytesRead);
			   out.closeEntry();
			   in.close();
			   
		   }
		   out.close();
	   }catch(IOException e){
		   System.out.println("[ERROR "+this.getClass().getName() + ".make()] :" + e.toString());
		   return false;
	   }
	   
	   return true;
	}
	
	/**
	 * ���Ͼ����ϱ�
	 * @param dir	�����丮
	 * @param targetFullPath	������ ���� ���(�������ϸ� ����)
	 * @return
	 */
	public boolean make(String dir, String targetFullPath)
	{
		return this.make(dir, targetFullPath, true);
	}
	
	/**
	 * ���丮 üũ�� �ϰ� ������ �����Ѵ�.
	 * @param dir üũ�� ���丮
	 * @throws IOException
	 */
	public void checkDirectory( String dir ) throws IOException
	{
		String curDir;
		
		dir	=	StrUtil.replace(dir,"\\",File.separator);
		dir	=	StrUtil.replace(dir,"/",File.separator);
		
		curDir	=	dir.substring(0,dir.lastIndexOf(File.separator)+1);
		
		File file = new File(curDir);
		if(!file.exists())
		{
			if(!file.mkdirs())
			{
				throw new IOException("[error:FileUtil] directory creation failure["+dir+"]");
			}
		}
	}
	
	
	
	/**
	 * �������� �����
	 * @param dir				������ ���丮
	 * @param targetFullPath	�������� ���� ���丮(�������ϸ� ����)
	 * @return
	 */
	public boolean make(DataSet files, String targetFullPath)
	{
		targetFullPath	=	StrUtil.replace(targetFullPath,"\\",File.separator);
		targetFullPath	=	StrUtil.replace(targetFullPath,"/",File.separator);
		
	   if(targetFullPath==null || targetFullPath.equals("")){
		   System.out.println("���� ���� �̸��� �� �� �Ǿ����ϴ�");
		   return false;		   
	   }
	   
	   int pos = targetFullPath.lastIndexOf(File.separator);
	   String targetDir = targetFullPath.substring(0, pos+1);
	   
	   try{
		   this.checkDirectory(targetDir);
	   }catch(Exception e){
		   System.out.println("[ERROR "+this.getClass().getName() + ".make()] :" + e.toString());
		   return false;
	   }
	   
	   byte[] buffer = new byte[4096]; // Create a buffer for copying
	   int bytesRead;	   
	   
	   try{
		   ZipOutputStream out = new ZipOutputStream(new FileOutputStream(targetFullPath));
		   out.setLevel(Deflater.DEFAULT_COMPRESSION);

		   files.first();
		   while(files.next()) {
			   System.out.println(files.getString("file_path"));
			   File f = new File(files.getString("file_path"));
			   if (f.isDirectory())	   continue;//���丮 ����
			   
			   FileInputStream in = new FileInputStream(f); // Stream to read file
			   ZipEntry entry = new ZipEntry(f.getName()); // Make a ZipEntry
			   out.putNextEntry(entry); // Store entry
			   while ((bytesRead = in.read(buffer)) != -1)
				   out.write(buffer, 0, bytesRead);
			   out.closeEntry();
			   in.close();
		   }
		   out.close();
	   }catch(IOException e){
		   System.out.println("[ERROR "+this.getClass().getName() + ".make()] :" + e.toString());
		   return false;
	   }
	   
	   return true;
	}	

	/**
	 * @param files �ٿ� ���� ���ϵ� ����
	 * @param response
	 * @return
	 * @throws IOException 
	 */
	public void make(DataSet files, HttpServletResponse response)
	{
	   byte[] buffer = new byte[4096]; // Create a buffer for copying
	   int bytesRead;	   
	   
	   try{
		   // ������ �����ϴ��� ���� üũ
		   files.first();
		   while(files.next()) {
			   File f = new File(files.getString("file_path"));
			   if(!f.exists())
			   {
				   throw new IOException("File Not Found");
			   }
		   }

		   // ���� �ٿ�ε� ����
		   SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
		   String zipfileName = sdf.format((new GregorianCalendar()).getTime()) + ".zip";
		   
		   response.reset();
		   response.setContentType("application/zip");
		   response.setHeader("Content-Disposition", "attachment;filename=\""+new String(zipfileName.getBytes("EUC-KR"), "ISO-8859-1")+";\"");

		   ZipOutputStream zout = new ZipOutputStream(response.getOutputStream());
		   zout.setLevel(Deflater.DEFAULT_COMPRESSION);

		   files.first();
		   while(files.next()) {
			   File f = new File(files.getString("file_path"));
			   if (f.isDirectory())	   continue;//���丮 ����
			   
			   FileInputStream in = new FileInputStream(f); // Stream to read file
			   ZipEntry entry = new ZipEntry(files.getString("doc_name")); // Make a ZipEntry
			   zout.putNextEntry(entry); // Store entry
			   while ((bytesRead = in.read(buffer)) != -1)
				   zout.write(buffer, 0, bytesRead);
			   zout.closeEntry();
			   in.close();
		   }
		   zout.close();
		   
	   }
	   catch(IOException e)
	   {
			response.reset();
			response.setContentType("text/html;charset=euc-kr");
			ServletOutputStream out;
			try {
				out = response.getOutputStream();
				out.println("<SCRIPT>");
				out.println("alert('��༭ ���� �ٿ�ε忡 ���� �Ͽ����ϴ�. \\n���������Ϳ� �����ϼ���.');");
				out.println("</SCRIPT>");
				System.out.println("��༭ ���� �ٿ� ���� : " + files.getString("file_path"));
			} catch (IOException e1) {
				System.out.println(e1.getMessage());
			}
	   }
	   
	}		
}
