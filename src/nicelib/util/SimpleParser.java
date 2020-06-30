package nicelib.util;

import org.xml.sax.InputSource;
import org.apache.commons.io.IOUtils;
import org.w3c.dom.*;

import javax.xml.xpath.*;
import javax.servlet.jsp.JspWriter;

import java.io.*;
import java.net.URL;

import nicelib.db.*;
import nicelib.util.Util;

/**
 * <pre>
 * SimpleParser sp = new SimpleParase("/data/test.xml");
 * //SimpleParser sp = new SimpleParase("http://aaa.com/data/test.xml");
 * //sp.setDebug(out);
 * DataSet ds = sp.getDataSet("//rss/item");
 * m.p(ds);
 * </pre>
 */
public class SimpleParser {

	private JspWriter out = null;
	private boolean debug = false;
	private String path = null;

	public String errMsg = "";

	public SimpleParser() { }

	public SimpleParser(String filepath) {
		this.path = filepath;
	}

	public void setDebug(JspWriter out) {
		this.out = out;
		this.debug = true;
	}

	private void setError(String msg) throws Exception {
		this.errMsg = msg;
		if(out != null && debug == true) {
			out.print("<hr>" + msg + "<hr>\n");
		}
	}

	public void setPath(String filepath) {
		this.path = filepath;
	}

	public DataSet getDataSet(String node) throws Exception {

		DataSet result = new DataSet();
		if(this.path == null) return result;

		InputStream is = null;
		if(this.path.indexOf("http") == 0) {
			URL url = new URL(this.path);
			is = url.openStream();
		} else {
			File f = new File(this.path);
			if(!f.exists()) {
				setError("File not found : " + this.path);
				return result;
			}
			is = new FileInputStream(f);
		}
		
		XPathFactory factory = XPathFactory.newInstance();
		XPath xpath = factory.newXPath();
		try {
			/*
			StringWriter writer = new StringWriter();
			IOUtils.copy(is, writer, "euc-kr");
			String theString = writer.toString();
			System.out.println(theString);
			*/
			InputSource inputXml = new InputSource(is);
			NodeList nodes = (NodeList) xpath.evaluate(node, inputXml, XPathConstants.NODESET);
			for (int i = 0, n = nodes.getLength(); i < n; i++) {
				result.addRow();
				NodeList xx = nodes.item(i).getChildNodes();
				if(null != xx && xx.getLength() > 1) {
					for(int j=0, k = xx.getLength(); j<k; j++) {
						if(xx.item(j).getNodeType() == Node.ELEMENT_NODE) {   
							result.put(xx.item(j).getNodeName(), (xx.item(j)).getFirstChild().getNodeValue());
						} else {   
							result.put(xx.item(j).getNodeName(), xx.item(j).getNodeValue());					
						}
					}
				} else {
					if(nodes.item(i).getNodeType() == Node.ELEMENT_NODE) {   
						result.put(nodes.item(i).getNodeName(), (nodes.item(i)).getFirstChild().getNodeValue());
					} else {   
						result.put(nodes.item(i).getNodeName(), nodes.item(i).getNodeValue());					
					}
				}
			}
		} catch (XPathExpressionException ex) {
			setError("XPath Error : " + ex.getMessage());
		} finally {
			if(is != null) is.close();
		}
		
		result.first();
		return result;
	}
}