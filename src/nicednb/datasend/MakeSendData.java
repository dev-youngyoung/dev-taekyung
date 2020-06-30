package nicednb.datasend;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import procure.common.conf.Startup;
import procure.common.value.ResultSetValue;

public class MakeSendData {
	private	Element root	=	null;
	private	Element list	=	null;
	private	Element data	=	null;
	private	Element element	=	null;
	
	public MakeSendData()
	{
		this.setRoot(new Element("nice_docu"));
	}
	
	/**
	 * 
	 * @param 	sTableNm
	 * @param 	saDnbField
	 * @param 	saBizField
	 * @param 	rsv
	 * @throws 	Exception 
	 */
	public void	MakeXml(String sTableNm, String[] saDnbField, String[] saBizField, ResultSetValue rsv) throws Exception
	{		
		try {
			if(rsv	!=	null && rsv.size() > 0)
			{
				this.setList(new Element(sTableNm));
				this.getRoot().addContent(this.getList());
				String	sDnbField	=	"";
				String	sBizField	=	"";
				
				for(int i=1; rsv.next(); i++)
				{
					if(i == 1)
					{
						System.out.println(rsv.getHashMap());
					}
					
					for(int j=0; j < saDnbField.length; j++)
					{
						sDnbField	=	saDnbField[j];
						sBizField	=	saBizField[j];
						
						// 레코드의 시작점을 만들어준다. 이름은 원하는 이름 주면됨
						if(j == 0)
						{
							this.setData(new Element("row_"+i));
						}
						
						this.setElement(new Element(sBizField));				// 서비스업체 SQL필드
						this.getElement().setText(rsv.getString(sDnbField));	// NICEDNB SQL필드
						this.getData().addContent(this.element);
					}
					this.getList().addContent(this.getData());
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".MakeXml()] :" + e.toString());
			throw new Exception(e.toString());
		}
	}
	
	/**
	 * xml 파일 생성
	 * @param sVendCd	사업자번호
	 * @return
	 * @throws IOException
	 */
	public String getXMLString(String sVendCd) throws IOException
	{
		String	xmlDoc	=	"";
		try {
			// XML 파일 생성
			SimpleDateFormat 	df1 = new SimpleDateFormat("yyyyMM");
			SimpleDateFormat 	df2 = new SimpleDateFormat("yyyyMMdd");
			Calendar 			cal = Calendar.getInstance();

			String file_url = Startup.conf.getString("file.path.send_log") + sVendCd + "/" + df1.format(cal.getTime()) + "/";

			File f = new File(file_url);

		    if(!f.isDirectory()) {
		    	f.mkdirs();
		    }

			String file_nm = file_url + df2.format(cal.getTime()) + "_biz_send_data.xml";
			Document doc = new Document(this.getRoot());
			XMLOutputter xmlout = new XMLOutputter();
			Format fm = xmlout.getFormat();

			fm.setEncoding("euc-kr");
			fm.setIndent(" ");
			fm.setLineSeparator("\r\n");

			xmlout.setFormat(fm);

			xmlout.output(doc, new FileWriter(file_nm));
			xmlDoc = xmlout.outputString(doc);
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("[ERROR "+this.getClass().getName() + ".getXMLString()] :" + e.toString());
			throw new IOException(e.toString());
		}
		return	xmlDoc;
	}
	
	public	void	setRoot(Element root)
	{
		this.root	=	root;
	}
	
	public Element	getRoot()
	{
		return	this.root;
	}
	
	public void	setList(Element list)
	{
		this.list	=	list;
	}
	
	public Element	getList()
	{
		return this.list;
	}
	
	public void	setData(Element data)
	{
		this.data	=	data;
	}
	
	public Element	getData()
	{
		return this.data;
	}
	
	public void	setElement(Element element)
	{
		this.element	=	element;
	}
	
	public Element	getElement()
	{
		return this.element;
	}
}
