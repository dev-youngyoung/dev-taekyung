package nicelib.util;

import java.io.*;
import java.util.*;
import java.net.*;
import javax.xml.parsers.*;
import javax.xml.transform.dom.*;
import org.w3c.dom.*;
import nicelib.db.DataSet;
import javax.servlet.jsp.JspWriter;

public class OpenApi {

	public String[] apiTypes = { 
		"naverbook=>���̹�å",
		"naverimage=>���̹��̹���",
		"navernews=>���̹�����",
		"naverkin=>���̹�����",
		"tomorrow=>���ϰ˻�",
		"archive=>������Ͽ�",
		"youtube=>You Tube" 
	};

/*
	//������Ͽ� ����
	//��Ϲ� ����
	public String[] archivesType1 = { "01=>�Ϲݱ�Ϲ�", "02=>��û����Ϲ�", "03=>����ɱ�Ϲ�", "04=>�ѵ��α�Ϲ�", "05=>���ΰ��๰", "06=>�ؿܱ�Ϲ�", "07=>�����Ϲ�", "08=>�����ڹ�", "09=>�ΰ���Ϲ�", "10=>��ȭ�ʸ�", "11=>������α׷�" };
	//doc_type ���� ��Ϲ� ���� 
	public String[] archivesTpype2 = { "1=>�����ڹ�(���η�)", "2=>�����ڹ�(��¡��买)", "3=>�����ڹ�(�繫�����)", "4=>�����ڹ�(��Ÿ)", "A=>�Ϲݹ�����", "B=>�����", "C=>����,�ʸ���", "D=>����,�������", "E=>ī���", "F=>�����"", ""G=>����ȸ�Ƿ�", "H=>����", "I=>��������ڹ���", "M=>���ΰ��๰", "O=>�Ϲݵ���", "P=>�ѵ��ΰ��๰" }; 
	*/

	URL url = null;
	InputStream is = null;
	Document xmlDocument = null;
	DocumentBuilderFactory factory = null;
	DocumentBuilder builder = null;

	Element root = null;
	NodeList items = null;

	String apiUrl = null;
	String apiName = null;
	String keyword = null;
	Hashtable parameters = new Hashtable();

	String dataField = "item";
	String[] dataElements = null;
	String[] reportElements = null;
	String dateFormat = null;
	String dateConvFormat = null;

	Vector errors = new Vector();

	public OpenApi() {} //apiŸ�Ը�� ����

	public OpenApi(String apiName, String keyword) throws Exception { //�˻���
		this.apiName = apiName.toLowerCase();
		this.keyword = keyword;
		try {
			factory = DocumentBuilderFactory.newInstance();
			builder = factory.newDocumentBuilder();
		} catch (Exception e) {
			errors.add("API�˻� �ʱ�ȭ ����. error - create builder from factory.");
		}
	}

	//�Ķ���� �߰�/�����
	public void addParameter(String key, String value) {
		parameters.put(key, value);
	}

	//�Ķ���� GET��Ʈ�� ���
	private String getParameters() {
		String str = "";
		Enumeration e = parameters.keys();
		while(e.hasMoreElements()) {
			String key = (String)e.nextElement();
			String value = parameters.containsKey(key) ? parameters.get(key).toString() : "";
			str += "&" + key + "=" + value;
		}
		return str.length() > 1 ? str.substring(1) : "";
	}

	//XML �Ľ�
	private void parse() throws Exception {
		url = new URL(apiUrl);
		is = url.openStream();

		try { 
			xmlDocument = builder.parse(is); 
			root = xmlDocument.getDocumentElement();
			items = root.getElementsByTagName(dataField);
		}
		catch(Exception e) { errors.add("API�˻��� �Ҽ� �����ϴ�. error - parseData from inputstream."); }
		finally { if(is != null) is.close(); }

	}

	//����� ����Ÿ������ ��ȯ
	public DataSet getDataSet() throws Exception {
		DataSet result = new DataSet();
		if(initialize()) {
			Locale loc = new Locale("ENGLISH");
			loc.setDefault(loc.US);
			parse();

			if(null != items) {
				for(int i=0; i<items.getLength(); i++) {
					result.addRow();
					NodeList subItems = items.item(i).getChildNodes();
					for(int j=0; j<subItems.getLength(); j++) {
						String[] dataElementKeys = Util.getItemKeys(dataElements);
						String nodeName = subItems.item(j).getNodeName();
						if(Util.inArray(nodeName, dataElementKeys)) {
							String key = Util.getItem(subItems.item(j).getNodeName().trim(), dataElements).toLowerCase();
							String value = null != subItems.item(j).getFirstChild() ? subItems.item(j).getFirstChild().getNodeValue() : "";
							result.put(key, value);

							if("media:thumbnail".equals(nodeName) || "media:player".equals(nodeName)) {
								result.put(key, ((Element)subItems.item(j)).getAttribute("url"));
							}
							if("pubdate".equals(key) && null != dateFormat) {
								result.put(key + "_conv", Util.getTimeString(dateConvFormat, Util.strToDate(dateFormat, value, loc)));
							}
						}
					}
					result.put("__i", i);
					result.put("__asc", i + 1);
				}
			}
		} else {
			errors.add("�������� ���� API. error - unknown api.");
		}
		return result;
	}

	//�����
	public void error(JspWriter out) throws Exception {
		out.print(!errors.isEmpty() ? Util.join("<hr><br>", errors.toArray()) : "");
		errors.clear();
	}



	/*
	 * api ���� ����(��밡���� �͸�)
	 */
	private boolean initialize() throws Exception {
		//���̹�����
		if("navernews".equals(apiName)) {
			parameters.put("key", "02f21a3b0cbb431be65ecc1557a059d7"); //���������DB ���̹� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("target", "news");
			parameters.put("start", "1");
			parameters.put("display", "100");
			apiUrl = "http://openapi.naver.com/search?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "originallink", "link", "description", "pubDate" };
			reportElements = new String[] { "rss", "channel", "lastBuildDate", "total", "start", "display" }; //�˻�����Ʈ���� �̱���(�ʿ����..)

			dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z";
			dateConvFormat = "yyyy.MM.dd HH:mm";

			return true;
		} 
		//���̹�å
		if("naverbook".equals(apiName)) {
			parameters.put("key", "02f21a3b0cbb431be65ecc1557a059d7"); //���������DB ���̹� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("target", "book");
			parameters.put("start", "1");
			parameters.put("display", "100");
			apiUrl = "http://openapi.naver.com/search?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "originallink", "link", "image", "author", "price", "discount", "publisher", "pubdate", "isbn", "description" };
			reportElements = new String[] { "rss", "channel", "lastBuildDate", "total", "start", "display" };

			dateFormat = "yyyyMMdd";
			dateConvFormat = "yyyy.MM.dd";

			return true;
		} 
		//���̹�����
		if("naverkin".equals(apiName)) {
			parameters.put("key", "02f21a3b0cbb431be65ecc1557a059d7"); //���������DB ���̹� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("target", "kin");
			parameters.put("start", "1");
			parameters.put("display", "100");
			apiUrl = "http://openapi.naver.com/search?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "link", "description" };
			reportElements = new String[] { "rss", "channel", "lastBuildDate", "total", "start", "display" };

			return true;
		} 
		//���̹��̹���
		if("naverimage".equals(apiName)) {
			parameters.put("key", "02f21a3b0cbb431be65ecc1557a059d7"); //���������DB ���̹� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("target", "image");
			parameters.put("start", "1");
			parameters.put("display", "100");
			apiUrl = "http://openapi.naver.com/search?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "link", "thumbnail", "sizeheight", "sizewidth" };
			reportElements = new String[] { "rss", "channel", "lastBuildDate", "total", "start", "display" };

			return true;
		} 
		//���ϰ˻�
		if("tomorrow".equals(apiName)) {
			parameters.put("apikey", "58A29064D80F4E055D88E39C719AB9445D0F160C"); //���������DB ���ϰ˻� ����Ű
			parameters.put("q", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("sort", "1");
			parameters.put("count", "100");
			apiUrl = "http://naeil.incruit.com/rss/search/?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "link", "description" };
			reportElements = new String[] { "" };
			
			return true;
		}
		//������Ͽ�����˻�
		if("archive".equals(apiName)) {
			parameters.put("key", "J0J9H2X6C4U7H2M9H2X1Z3X5W3X0Z5T0"); //���������DB ������Ͽ� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("sort", "1");
			parameters.put("online_reading", "Y");
			parameters.put("display", "100");
			apiUrl = "http://search.archives.go.kr/openapi/search.arc?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "link", "prod_name=>description" };
			reportElements = new String[] { "" };
			
			return true;
		}
		//YOU TUBE
		if("youtube".equals(apiName)) {
		//	parameters.put("key", "AI39si5vjDviDPuyyCknkXj7CdmRfWLrMqf-yyN0JsidFzKYlLI3vlTQLP24BFOnpFql91idKc7EKUIVKq0ajA4yRVX_lA3RDg"); //���������DB youtube ����Ű
			parameters.put("q", URLEncoder.encode(keyword, "utf-8"));
			apiUrl = "http://gdata.youtube.com/feeds/api/videos?" + getParameters();
			errors.add(apiUrl);
			dataField = "media:group";
			dataElements = new String[] { "media:title=>title", "media:player=>link", "media:description=>description", "media:thumbnail=>image" };
			reportElements = new String[] { "" };

			return true;
		}
		/*
		//���̹�������ǥ(��ǥ�� ������)
		if("naverkin".equals(apiName)) {
			parameters.put("key", "9c79f18d0d8c2ce6d35318aa47a8b553"); //���������DB ���̹� ���� ����Ű
			parameters.put("query", URLEncoder.encode(keyword, "utf-8"));
			parameters.put("target", "kin");
			parameters.put("start", "1");
			parameters.put("display", "100");
			apiUrl = "http://openapi.naver.com/search?" + getParameters();
			errors.add(apiUrl);
			dataField = "item";
			dataElements = new String[] { "title", "link", "description" };
			reportElements = new String[] { "rss", "channel", "lastBuildDate", "total", "start", "display" };

			return true;
		} 
		*/

		return false;
	}


}
