package nicelib.util;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import nicelib.db.DataSet;

public class JsoupUtil {
	String _html = null;
	Document _document = null;
	
	public JsoupUtil(String html) {
		_html = html;
		_document = Jsoup.parse(_html);
	}
	
	public String getInnerHtml(String name){
		return getInnerHtml(name, "");
	}

	public DataSet getInnerHtml( String[] names){
		DataSet data = new DataSet();
		for(int i = 0 ; i < names.length; i++) {
			data.addRow();
			data.put(names[i], getInnerHtml(names[i]));
		}
		return data;
	}

	public String getInnerHtml(String name, String spliter){
		String value = "";
		String _spliter = ",";
		if(!spliter.equals("")) {
			_spliter = spliter;
		}

		Elements elements = _document.select(name);
		for(int i = 0 ; i < elements.size(); i++){
			Element element = elements.get(i);
			if(element.tagName().equalsIgnoreCase("span")) {
				if(i != 0 ) value += _spliter;
				value += element.html();
			}
		}
		return value;
	}

	public String getValue(String name){
		return getValue(name, "");
	}
	
	public DataSet getValue( String[] names){
		DataSet data = new DataSet();
		for(int i = 0 ; i < names.length; i++) {
			data.addRow();
			data.put(names[i], getValue(names[i]));
		}
		return data;
	}

	public String getValue(String name, String spliter){
		String value = "";
		String _spliter = ",";
		if(!spliter.equals("")) {
			_spliter = spliter;
		}
		
		Elements elements = _document.getElementsByAttributeValue("name", name);
		for(int i = 0 ; i < elements.size(); i++){
			Element element = elements.get(i);
			if(!element.attr("name").equals(name))continue;//Jsoup 버그일까? AttributeValue검색시 대소문자 구분을 못하고 있음.
			if(element.tagName().equalsIgnoreCase("input")) {
				if(element.attr("type").equalsIgnoreCase("radio")) {//무조건 하나의 값
					if(element.hasAttr("checked")) {
						value = element.attr("value");
					}else {
						continue;
					}
					
				}else if(element.attr("type").equalsIgnoreCase("checkbox")) {//여러게 선택 가능
					if(element.hasAttr("checked")) {
						if(value!="") value += _spliter;
						value += element.attr("value");
					}else {
						continue;
					}
				}else{
					if(i != 0 ) value += _spliter;
					value += element.attr("value");
				}
			}else if(element.tagName().equals("select")){
				if(i != 0 ) value += _spliter;
				value += element.getElementsByAttribute("selected").get(0).attr("value");
			}else if(element.tagName() .equals("textarea")){
				if(i != 0 ) value += _spliter;
				value += element.text();
			}
		}
		return value;
	}
 
	public String getValueHtml(String name ){
		String value ="";
		Elements elements = _document.select("input[name= " + name + "]") ;
		for(int i = 0 ; i < elements.size(); i++){
			value += elements.get(i); 
		} 
		return value;
	}


	public void setValue(String name, String value){
		Elements elements = _document.select(name) ;
		elements.val(value);
	}



	public void addTableRow(String name, String[] values){
		addTableRow(name, values, null);
	}

	public void addTableRow(String name, String[] values, String[] options){
		Elements tables = _document.select(name);
		String html = "";
		for(Element table :  tables){
			html = "<tr>\n";
			for(int i = 0 ; i < values.length; i++){
				String option = "";
				if(options != null) {
					option = options[i];
				}
				html+="<td "+option+">"+values[i]+"</td>\n";
			}
			html += "</tr>\n";
		}
		tables.append(html);
	}
	 
	public void replaceInput(String name, String value){
		for( Element element : _document.select("."+name+"") ){
			String tag_name = element.tagName().toLowerCase(); 
			if(tag_name.equals("span")){
				element.text(value);
			}else if(tag_name.equals("input")){
				String type = element.attr("type").toLowerCase();
				if(type.equals("checkbox")){
					if(element.attr("value").equals(value)){
						element.attr("checked","checked");
					}
				}else if(type.equals("radio")) {
					if(element.attr("value").equals(value)){
						element.attr("checked","checked");
					}else {
						element.removeAttr("checked");
					}
				}else if(type.equals("text")||type.equals("hidden")||type.equals("")){//jsoup 버전 버그 type="text"가 전부 사라진다.
					if(type.equals("")){
						element.attr("type","text");
					}
					element.attr("value",value);
				}
				
			}else if(tag_name.equals("select")){
				for(Element option : element.children()){
					if(option.tagName().toLowerCase().equals("option")){
						if(option.hasAttr("selected")){
							option.removeAttr("selected");
						}
						if(option.attr("value").equals(value)){
							option.attr("selected", "");
						}
					}
				}
			}else if(tag_name.equals("textarea")){
				element.text(value);
			}
		}
	}


	public String getHtml(){
		for( Element elem : _document.select("input[type=text]") ){ elem.attr("type","text"); }  // jsoup 버그 처리
		String __html  = _document.getElementsByTag("body").html().toString();
		String style = _document.getElementsByTag("style").html();
		String script = _document.getElementsByTag("script").html();
		if(!style.equals(""))__html = "<style>"+style+"</style>\n"+__html;
		if(!script.equals(""))__html = "<script>"+script+"</script>\n"+__html;
		return __html;
	}

	public String removeHtml()
	{
		// DB용
		// PDF용
		for( Element elem : _document.select("input[type=text]") ){ elem.parent().text(elem.val()); }  // input box 값 모두 제거
		for( Element elem : _document.select("input[type=checkbox]") ){ elem.parent().text(elem.hasAttr("checked")?"▣":"□"); }
		for( Element elem : _document.select("input[type=radio]") ){ elem.parent().text(elem.hasAttr("checked")?"▣":"□"); }
		for( Element elem : _document.select("textarea") ){ elem.parent().html(elem.val().replaceAll("\\r\\n","<br>").replaceAll("\\n","<br>")); }
		for( Element elem : _document.select("select") ){ elem.parent().text(elem.select("option[selected]").val()); }
		_document.select(".no_pdf").attr("style", "display:none"); // pdf 버전에 보여야 안되는것
		
		String cont_html_rm = _document.getElementsByTag("body").html().toString();
		String style = _document.getElementsByTag("style").html();
		String script = _document.getElementsByTag("script").html();
		if(!style.equals(""))cont_html_rm = "<style>"+style+"</style>\n"+cont_html_rm;
		if(!script.equals(""))cont_html_rm = "<script>"+script+"</script>\n"+cont_html_rm;
		
		return cont_html_rm;
	}
}