package procure.common.file;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
//import java.io.PrintWriter;



import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;

import nicelib.util.Util;
import procure.common.conf.Startup;
import procure.common.utils.StrUtil;

public class FileDownLoad extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public FileDownLoad() {

		super();
	}

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  
    {          
    	//PrintWriter pw	=	null;
    	//StringBuffer sb	=	null;
    	
    	Util u = new Util(request, response, null); 
    	
		try {
	    	//pw	=	response.getWriter();
	    	//sb	=	new	StringBuffer();

	    	//CompositeConfiguration  conf = Config.getInstance();  
			
			request.setCharacterEncoding("utf-8");

			String sFilePathKey = StrUtil.chkNull(request.getParameter("FILE_KEY"),true);
			String sFileSubPath = StrUtil.chkNull(request.getParameter("FILE_SUB_PATH"),true);
	        String sFileName 	= StrUtil.chkNull(request.getParameter("FILE_NAME"),true);
			String sFileTarFile = StrUtil.chkNull(request.getParameter("FILE_TAR_FILE"),true);			
			String sFilePath	= Startup.conf.getString(sFilePathKey);
			String sEncYn = StrUtil.chkNull(request.getParameter("ENC_YN"));
			
			// Mobile project를 위한 추가
			String sMobileYN = StrUtil.chkNull(request.getParameter("_mobile_"));
			//System.out.println("sEncYn : " + sEncYn);
			if(sEncYn.equals("Y")){
				if(!sFileSubPath.equals("")) sFileSubPath = u.aseDec(sFileSubPath);
				if(!sFileName.equals("")) sFileName = u.aseDec(sFileName);
			}
			
			String sFile	=	sFilePath	+	 sFileSubPath	+	sFileName;
			sFile	=	StrUtil.replace(sFilePath + sFileSubPath + sFileName, "\\", File.separator);
			sFile	=	StrUtil.replace(sFilePath + sFileSubPath + sFileName, "/", File.separator);

			// 2011.06.21 add by shryu  보안 취약점 보완 CRLF injection/HTTP response splitting
	        sFile = StrUtil.replace(sFile, "\r", "");
	        sFile = StrUtil.replace(sFile, "\n", "");
	        sFileTarFile = StrUtil.replace(sFileTarFile, "\r", "");
	        sFileTarFile = StrUtil.replace(sFileTarFile, "\n", "");

			// 2011.06.21 add by shryu  보안 취약점 보완 Directory Traversal
	        sFile = StrUtil.replace(sFile, "../", "");
	        sFile = StrUtil.replace(sFile, "./", "");
	        sFile = StrUtil.replace(sFile, "..\\", "");
	        sFile = StrUtil.replace(sFile, ".\\", "");

	        sFileTarFile = StrUtil.replace(sFileTarFile, "../", "");
	        sFileTarFile = StrUtil.replace(sFileTarFile, "./", "");
	        sFileTarFile = StrUtil.replace(sFileTarFile, "..\\", "");
	        sFileTarFile = StrUtil.replace(sFileTarFile, ".\\", "");
	        
	        sFile = StrUtil.replace(sFile, "/", File.separator);
	        if(sFileTarFile.length() <= 0) sFileTarFile = sFile.substring(sFile.lastIndexOf(File.separator)+1);
	        System.out.println("sFile["+sFile+"]");
	        
	        response.setContentType("text/html;charset=UTF-8");
	        //response.setCharacterEncoding("euc-kr");
			ServletOutputStream out = response.getOutputStream();
			
			
            
            File file = new File(sFile);
 
            if( file.exists() ) 
            {
                int fileSize = (int)file.length();
                String mimeType = "application/octet-stream";  
                response.setContentType(mimeType);
                response.setHeader("Access-Control-Allow-Origin", "http://m.nicedocu.com"); 
                response.setHeader("Access-Control-Allow-Credentials", "true");
                //response.setHeader("Content-Disposition", "attachment;filename="+StrUtil.ConfCharset(sFileTarFile)+"\"");
                response.setHeader("Content-Disposition", "attachment;filename=\""+new String(sFileTarFile.getBytes("UTF-8"), "ISO-8859-1")+"\";");
                response.setContentLength(fileSize);

                byte[] buffer = new byte[4096];              
                BufferedInputStream  bis = new BufferedInputStream(new FileInputStream(file));
                BufferedOutputStream bos = new BufferedOutputStream(response.getOutputStream());

                int offset = 0;
				
                try {             

                    while( (offset = bis.read(buffer)) != -1 ) {
                        bos.write(buffer, 0, offset);
                    }             
                    bos.flush();
                }catch (Exception e) { 
                	if(sMobileYN.equals("Y")){
                		out.print("{\"success\": \"false\",\"msg\": \"파일이 존재하지 않습니다.<br>관리자에게 문의하세요.\",\"status\": 500}");
                	}else{
	                    out.println("<SCRIPT>");
	                    out.println("alert('파일이 다운로드 중 에러가 발생 하였습니다.\n\n관리자에게 문의 하십시오.');");
	                    out.println("</SCRIPT>");
                	}
                }finally {
                    if( bos != null ) try { bos.close(); } catch(Exception e){}
                    if( bis != null ) try { bis.close(); } catch(Exception e){}
                }
            }else {
				//pw.println(sb.toString());
            	if(sMobileYN.equals("Y")){
            		out.print("{\"success\": \"false\",\"msg\": \"파일이 존재하지 않습니다.<br>관리자에게 문의하세요.\",\"status\": 404}");
            	}else{
                	out.println("<script language=\"javascript\">\n");
                	out.println("	alert(\"파일이 존재하지 않습니다.\\n\\n관리자에게 문의하세요\");\n");
                	out.println("</script>");
            	}
				
				
				throw new IOException("File Not Found : " + sFile);
            }
		}catch(IOException ie) {
        	System.out.println(ie.getMessage());        
        }catch(Exception ex) {
        	System.out.println(ex.getMessage());        
        }
    }    
}
