package nicednb.xss;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

public class XssFilter implements Filter 
{
	private FilterConfig fc;
	public void destroy() {
		this.fc = null; 
	}

	public void doFilter(ServletRequest req, ServletResponse resp, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest hReq = (HttpServletRequest) req;
		String method = hReq.getMethod();
		if(method.equals("GET") || method.equals("POST")) {
			chain.doFilter(new RequestWrapper((HttpServletRequest) req), resp);
		} else {
			System.out.println("----- 허용하지 않는 method ---> " + method);
			//((HttpServletResponse)resp).sendRedirect("/501.html");
			hReq.getRequestDispatcher("/error/501.jsp").forward(req, resp);
			return;
		}

	}

	public void init(FilterConfig fc) throws ServletException {
		this.fc = fc;
	}
}