package nicelib.pdf;

import gui.ava.html.image.generator.HtmlImageGenerator;

import java.io.*;
import java.net.URLEncoder;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;

import nicelib.db.DataObject;
import nicelib.db.DataSet;
import nicelib.util.Auth;
import nicelib.util.Util;
import procure.common.conf.Startup;

public class PDFDown extends HttpServlet {

	private static final long serialVersionUID = 1L;

	public PDFDown() {

		super();
	}

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException  
    {   
    	System.out.println("----------------------PDFDown servlet start-------------------------------");
    	ServletOutputStream outputStream	=	null;
		try {
			response.setHeader("Pragma", "No-cache");
			response.setDateHeader("Expires", 0);
			response.setHeader("Cache-Control", "no-Cache");

			Util u = new Util(request, response, null);
			String system = u.request("system");
			String ci_img = u.request("ci_img");
			String stamp_img = u.request("stamp_img");
			String sign_info_img = u.request("sign_info_img");
			String footer_img = u.request("footer_img");
			String down_file_name = u.request("down_file_name");
			String full_file_path = u.request("full_file_path");
			String attach_mode = u.request("attach_mode").equals("off")?"off":"no";
			if(!ci_img.equals("")) ci_img = u.aseDec(ci_img);
			if(!stamp_img.equals("")) stamp_img = u.aseDec(stamp_img);
			if(!sign_info_img.equals("")) sign_info_img = u.aseDec(sign_info_img);
			if(!footer_img.equals("")) footer_img = u.aseDec(footer_img);
			if(!down_file_name.equals("")) down_file_name = u.aseDec(down_file_name);
			if(!full_file_path.equals("")) full_file_path = u.aseDec(full_file_path);
			u.sp(
					 "ci_img :"+ ci_img
					+"\nstamp_img :"+ stamp_img
					+"\nsign_info_img:"+ sign_info_img 
					+"\nfooter_img :"+ footer_img
					+"\ndown_file_name:"+ down_file_name 
					+"\nfull_file_path :"+ full_file_path
					);
			
			String [] keyNmaes = {"supplier=>AUTHID868","buyer=>AUTHID867", "fc=>AUTHIDFC218"};
			Auth auth = new Auth(request, response);
			auth.keyName = u.getItem(system, keyNmaes);
			if(!auth.isValid()){
				/*response.setContentType("text/html; charset=euc-kr");
				PrintWriter out =  response.getWriter();
				out.println("<script>");
				out.print("alert('로그인 되어 있지 않습니다.');history.go(-1)");
				out.println("</script>");
				return;*/
			}
			String _member_no = auth.getString("_MEMBER_NO");
			
			if(full_file_path.equals("")||down_file_name.equals("")){
				response.setContentType("text/html; charset=UTF-8");
				PrintWriter out =  response.getWriter();
				out.println("<script>");
				out.print("alert('정상적인 경로로 접근하세요.');history.go(-1)");
				out.println("</script>");
				return;
			}
			
			response.setContentType("application/pdf");
			if(!attach_mode.equals("off")) {
				response.setHeader("Content-Disposition", "attachment;filename=\""+new String((down_file_name+".pdf").getBytes("UTF-8"), "ISO-8859-1")+"\";");
			}
			
			outputStream = response.getOutputStream();
			
			PDFWaterMark waterMark = new PDFWaterMark();
			
			waterMark.setImage(full_file_path,ci_img,stamp_img,sign_info_img,footer_img,outputStream);
			
			outputStream.flush();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + "] :" + e.toString());
			throw new IOException("[ERROR "+this.getClass().toString()+"] " + e.toString());
		} finally
		{
			if(outputStream != null)
			{
				try {
					outputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
					System.out.println("[ERROR "+this.getClass().getName() + "] :" + e.toString());
					throw new IOException("[ERROR "+this.getClass().toString()+"] " + e.toString());
				}
			}
		}
    }
}
