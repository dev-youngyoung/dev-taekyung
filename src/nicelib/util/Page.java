package nicelib.util;

import java.io.File;
import java.util.Date;
import javax.servlet.jsp.JspWriter;
import nicelib.util.Template;


public class Page extends Template {

	private String _root;
	private String _layout;
	private String _body;
	private long startTime;

	public Page(String root) {
		super(root);
		_root = root;
		startTime = System.currentTimeMillis();
	}

	public void setLayout(String layout) {
		_layout = "layout/layout_" + layout.replace('.', '/') + ".html";

		File file = new File(_root + "/" + _layout);
		if(!file.exists()) {
			_layout = "layout/layout_blank.html";
		}
	}

	public void setBody(String body) {
		_body = body.replace('.', '/') + ".html";
	}

	public void display(JspWriter out) throws Exception {

		this.setVar("BODY", _body);
		this.print(out, _layout);

		long endTime = System.currentTimeMillis();
		double exeTime = (double)(endTime - startTime) / 1000;
		out.print("\r\n<!-- LAYOUT : " + _layout + " -->");
		out.print("\r\n<!-- BODY : " + _body + " -->");
		out.print("\r\n<!-- EXECUTION TIME : " + exeTime + " Second -->");
	}

}
