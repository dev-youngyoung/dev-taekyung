package nicelib.util;

import java.io.*;
import javax.servlet.jsp.JspWriter;
import nicelib.db.*;
import nicelib.util.*;
import java.util.*;
import java.lang.*;

public class Generator {

	private JspWriter out;
	private Page p;
	private String jndi = "jdbc/lms";
	private String user;
	private boolean isWindows = false;

	private String root;
	private String srcDir;
	private String outDir;
	private String daoDir;

	private String table;
	private String tableComment;
	private String objName;
	private String dirName;
	private String daoName;
	private String prefixName;
	private String priName = "";
	private boolean existsStatus = false;

	private String type;
	private String group;
	private String writeType = "exists";
	private boolean isFile = true;
	private String[] exceptions = { "sms", "tb_sms" };

	private StringBuffer message = new StringBuffer();

	public void setIsWindows(boolean flag) {
		this.isWindows = flag;
	}
	public void setClassPath(String classDir) {
		this.daoDir = classDir + "/WEB-INF/classes/dao";
	}

	public Generator(String root, JspWriter out, Page p, String jndi, String user) {
		this.out = out;
		this.p = p;
		this.root = root;
		this.srcDir = root + "/generator/src";
		this.outDir = root + "/result";
		this.daoDir = root + "/result/WEB-INF/classes/dao";
		this.jndi = jndi;
		this.user = user;
	}

	public void setJndi(String jndi) {
		this.jndi = jndi;
	}
	public void setDirectory(String dir) {
		this.outDir = dir;
	//	this.daoDir = dir + "/WEB-INF/classes/dao";
	}
	public void setWriteType(String writeType) {
		this.writeType = writeType;
	}
	public void setWriteFile(boolean type) {
		this.isFile = type;
	}

	private DataSet getMetaColumns() throws Exception {
		DB conn = new DB(jndi);
		String dbType = conn.getDBType();
		this.priName = "";
		DataSet columns = new DataSet();
		DataSet tableInfo = new DataSet();
		if("mysql".equals(dbType)) {
			//table info
			tableInfo = conn.query("SELECT * FROM information_schema.tables WHERE table_name='" + table + "'");
			if(tableInfo.next()) tableComment = tableInfo.getString("table_comment");

			//column info
			columns = conn.query("SELECT * FROM information_schema.columns WHERE table_name='" + table + "'");
			while(columns.next()) {
				columns.put("column_length", columns.getInt("numeric_precision") > 0 ? columns.getInt("numeric_precision") : columns.getInt("character_maximum_length"));
			}
			this.priName = "id"; //mysql 烙矫
		} else if("oracle".equals(dbType)) {
			//table info
			tableInfo = conn.query("SELECT a.*, b.comments table_comment FROM USER_TABLES a LEFT JOIN USER_TAB_COMMENTS b ON a.table_name=b.table_name WHERE a.table_name='" + table + "'");
			if(tableInfo.next()) tableComment = tableInfo.getString("table_comment");

			//column info
			columns = conn.query("SELECT a.*, b.comments column_comment FROM USER_TAB_COLUMNS a LEFT JOIN USER_COL_COMMENTS b ON a.table_name=b.table_name AND a.column_name=b.column_name WHERE a.table_name='" + table + "'");

			//primary info
			DataSet priList = conn.query("SELECT a.* FROM USER_IND_COLUMNS a, USER_CONSTRAINTS b WHERE a.table_name=b.table_name AND a.index_name=b.constraint_name AND a.table_name='" + table + "' ORDER BY a.table_name, a.column_position");
			Hashtable priInfo = new Hashtable();
			while(priList.next()) {
				priInfo.put(priList.getString("column_name"), "true");
				this.priName += (!"".equals(this.priName) ? "," : "") + priList.getString("column_name");
			}


			while(columns.next()) {
				columns.put("column_key", null != priInfo.get(columns.getString("column_name")) ? "pri" : "");
				columns.put("column_length", columns.getInt("data_precision") > 0 ? columns.getInt("data_precision") : columns.getInt("data_length"));
				columns.put("column_name", columns.getString("column_name").toLowerCase());
			}
		} else if("mssql".equals(dbType)) {

			//table info
			tableInfo = conn.query("SELECT tb.name table_name, CAST(p.[value] as varchar) table_comment FROM sys.tables tb LEFT JOIN sys.extended_properties p ON p.major_id=tb.object_id AND p.minor_id=0 WHERE tb.name = '" + table + "'");
			if(tableInfo.next()) tableComment = tableInfo.getString("table_comment");

			columns = conn.query("SELECT c.*, c.name column_name, tb.name, t.name data_type, CAST(p.[value] as varchar) column_comment FROM sys.columns c INNER JOIN sys.types t ON c.user_type_id = t.user_type_id INNER JOIN sys.objects tb ON tb.object_id = c.object_id LEFT JOIN sys.extended_properties p ON p.major_id = c.object_id AND p.minor_id = c.column_id AND p.class = 1 WHERE tb.name = '" + table + "' ORDER BY c.column_id");
	
			while(columns.next()) {
				columns.put("column_key", "true".equals(columns.getString("is_identity")) ? "pri" : "");
				columns.put("column_length", columns.getString("data_type").equals("int") ? columns.getInt("precision") : columns.getInt("max_length"));
				columns.put("column_name", columns.getString("column_name").toLowerCase());
				if("true".equals(columns.getString("is_identity"))) {
					this.priName += (!"".equals(this.priName) ? "," : "") + columns.getString("column_name");
				}
			}
		}
		conn.close();
		
		columns.first();
		return columns;
	}

	public void generator(String table, String type) throws Exception {
		this.type = type;
		generator(table);
	}

	private void generator(String table) throws Exception {
		this.table = table;
		this.dirName = getDirName(table.toLowerCase());
		this.prefixName = getPrefixName(table.toLowerCase());
		this.daoName = getDaoName(table.toLowerCase());
		this.objName = (daoName.substring(0, 1).toLowerCase() + daoName.substring(1)).replaceAll("Dao", "");

		DataSet columns = getMetaColumns();

		DataSet elements = new DataSet();
		int i = 0; int sComment = 5;
		int size = columns.size(); 
		while(columns.next()) if("pri".equals(columns.getString("column_key").toLowerCase())) size -= 1;
		columns.first();

		while(columns.next()) {
			//special field set
			if("status".equals(columns.getString("column_name").toLowerCase())) this.existsStatus = true;
			//primary key continue;
			if("pri".equals(columns.getString("column_key").toLowerCase())) continue;
			//data formatting
			columns.put("start_comment", size > sComment && i == sComment ? "<!-- " : "");
			columns.put("end_comment", size > sComment && i == size - 1 ? " -->" : "");
			columns.put("start_pgm_comment", size > sComment && i == sComment ? "/*\r\n" : "");
			columns.put("end_pgm_comment", size > sComment && i == size - 1 ? "\r\n*/" : "");
			elements.addRow(formatter(columns.getRow()));
			i++;
		}

		if("dao".equals(type)) { 
			fetchDao(out, p); 
		} else if("init".equals(type)) { 
			fetchInit(out, p); 
		} else {
			if("program".equals(group)) fetchProgram(out, p, elements);
			if("html".equals(group)) fetchHtml(out, p, elements);
		}
	}

	private void fetchDao(JspWriter out, Page p) throws Exception {
		//parse dao source
		p.setRoot(srcDir + "/dao");
		p.setVar("dao", daoName);
		p.setVar("table", table);
		p.setVar("jndi", jndi);
		p.setVar("primary_key", priName);
		String result = p.fetch("_" + type + "_");
		//write file
		String path = daoDir + "/" + daoName + ".java";
		if(isFile) writeFile(result, path);
		else setMessage(path, " 家胶积己");
		//display
		display(out, result);
	}
	private void fetchInit(JspWriter out, Page p) throws Exception {
		//parse init source
		p.setRoot(srcDir);
		String result = p.fetch("_" + type + "_");
		//write file
		String path = outDir + "/" + dirName + "/" + type + ".jsp";
		if(isFile) writeFile(result, path);
		else setMessage(path, " 家胶积己");
		//display
		display(out, result);
	}
	private void fetchProgram(JspWriter out, Page p, DataSet elements) throws Exception {
		//add relation Dao code 
		DataSet DaoCodes = new DataSet();
		elements.first();
		while(elements.next()) {
			String columnName = elements.getString("column_name");
			if(columnName.length() > 3) {
				if("_id".equals(columnName.substring(columnName.length() - 3))) {
					if("login_id".equals(columnName)) continue;
					if("org_id".equals(columnName)) columnName = "organizition_id";
					DaoCodes.addRow();
					String daoName =  getDaoName("tb_" + columnName.substring(0, columnName.length() - 3));
					DaoCodes.put("dao", daoName);
					DaoCodes.put("obj", daoName.substring(0, 1).toLowerCase() + daoName.substring(1).replaceAll("Dao", ""));
					DaoCodes.put("loopName", columnName.replaceAll("_id", ""));
				}
			}
		}

		//parse program source
		p.setRoot(srcDir);
		p.setLoop("DaoCodes", DaoCodes);
		p.setLoop("elements", elements);
		p.setVar("obj", objName);
		p.setVar("dao", daoName);
		p.setVar("table_comment", tableComment);
		p.setVar("table_comment_conv", tableComment.replaceAll("沥焊", ""));
		p.setVar("dir", dirName);
		p.setVar("table", table);
		p.setVar("prefix", prefixName);
		p.setVar("primary_key", priName);
		p.setVar("query", "{{query}}");
		p.setVar("list_query", "{{list_query}}");
		p.setVar("exists_status", existsStatus);
		String result = p.fetch("_" + type + "_");
		//write file
		String path = outDir + "/" + dirName + "/" + prefixName + "_" + type + ".jsp";
		if(isFile) writeFile(result, path);
		else setMessage(path, " 家胶积己");
		//display
		display(out, result);
	}
	private void fetchHtml(JspWriter out, Page p, DataSet elements) throws Exception {
		//parse html source
		p.setRoot(srcDir + "/html");
		p.setLoop("elements", elements);
		p.setVar("table_comment", tableComment);
		p.setVar("table_comment_conv", tableComment.replaceAll("沥焊", ""));
		p.setVar("obj", objName);
		p.setVar("dir", dirName);
		p.setVar("if_start_id", "<!-- IF START 'id' -->");
		p.setVar("if_end_id", "<!-- IF END 'id' -->");
		p.setVar("ifnot_start_id", "<!-- IFNOT START 'id' -->");
		p.setVar("ifnot_end_id", "<!-- IFNOT END 'id' -->");
		p.setVar("loop_start_list", "<!-- LOOP START 'list' -->");
		p.setVar("loop_end_list", "<!-- LOOP END 'list' -->");
		p.setVar("loop_start_status", "<!-- LOOP START 'status_list' -->");
		p.setVar("loop_end_status", "<!-- LOOP END 'status_list' -->");
		p.setVar("ifnot_start_list", "<!-- IFNOT START 'list' -->");
		p.setVar("ifnot_end_list", "<!-- IFNOT END 'list' -->");
		p.setVar("ifnot_start_print_block", "<!-- IFNOT START 'print_block' -->");
		p.setVar("ifnot_end_print_block", "<!-- IFNOT END 'print_block' -->");
		p.setVar("status_list.id", "{{status_list.id}}");
		p.setVar("status_list.name", "{{status_list.name}}");
	//	p.setVar("list.id", "{{list.id}}");
		p.setVar("list.id", "{{list." + priName + "}}");
		p.setVar("list.__ord", "{{list.__ord}}");
		p.setVar("list.ROW_CLASS", "{{list.ROW_CLASS}}");
		p.setVar("tab", "{{tab}}");
		p.setVar("form_script", "{{form_script}}");
		p.setVar("pagebar", "{{pagebar}}");
		p.setVar("ord", "{{ord}}");
		p.setVar("prefix", prefixName);
		p.setVar("query", "{{query}}");
		p.setVar("list_query", "{{list_query}}");
		p.setVar("exists_status", existsStatus);
		p.setVar("[[", "{{");
		p.setVar("]]", "}}");
		String result = p.fetch("_" + type + "_");
		//write file
		String path = outDir + "/html/" + dirName + "/" + prefixName + "_" + type + ".html";
		if(isFile) writeFile(result, path);
		else setMessage(path, " 家胶积己");
		//display
		display(out, result);
	}

	private void writeFile(String result, String path) throws Exception {
		File f = new File(path);
		if(!f.getParentFile().isDirectory()) {
			f.getParentFile().mkdirs();
		}

		if("over".equals(writeType)) {
			if(f.exists()) {
				Util.copyFile(path, path + ".bak");
				setMessage(path + ".bak", " 积己");
			}
		} else if("new".equals(writeType)) {
			path = getNewFilePath(path);
		} else if("exists".equals(writeType)) {
			if(f.exists()) path = getNewFilePath(path);
		}

		//FileWriter fw = new FileWriter(path);
		//BufferedWriter bw = new BufferedWriter(new WriterToUTF8(fw));
	
		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(path),"UTF8"));
	
	
	//	bw.write(new String(result.trim().getBytes("KSC5601"), "8859_1"));
		bw.write(result.trim());
		bw.close(); 
		//fw.close();

	//	String user = jndi.substring(jndi.indexOf("/") + 1);
		if(!isWindows) Runtime.getRuntime().exec("chown -R " + user + ":" + user + " " + ("dao".equals(this.type) ? daoDir : outDir));

		setMessage(path, " 积己");
	}

	private String getNewFilePath(String path) {
		String[] suffixes = { ".java", ".jsp", ".html"};
		for(int i=0; i<suffixes.length; i++) {
			if(path.indexOf(suffixes[i]) != -1) path = path.replaceAll(suffixes[i], ".gen" + suffixes[i]);
		}
		return path;
	}
	public void setSingularExceptions (String[] exceptions) {
		this.exceptions = exceptions;
	}

	public String getSingularName(String str) {
		String singular = str;
		if(!Util.inArray(str, exceptions)) {
			try {
				if("ches".equals(str.substring(str.length() - 4))) {
					singular = str.substring(0, str.length() - 2);
				} else if("ies".equals(str.substring(str.length() - 3))) {
					singular = str.substring(0, str.length() - 3) + "y";
				} else if("s".equals(str.substring(str.length() - 1))) {
					singular = str.substring(0, str.length() - 1);
				}
			} catch(Exception e) { }
		}
		return singular;
	}

	public String getPrefixName(String table) {
		String[] names = getSingularName(table).split("_");
		String name = "";
		for(int i=0; i<names.length; i++) {
			if(i ==0 ) continue;
			name += names[i] + (i + 1 != names.length ? "_" : "");
		}
		return name;
	}
	public String getDaoName(String table) {
		String name = "";
		table = getSingularName(table);
		try {
			String[] names = table.split("_");
			if(names.length >= 2) {
				for(int i=0; i<names.length; i++) {
				//	if(i == 0) continue;
					if(names[0].equals("tb") && i == 0) continue;
					name += names[i].substring(0, 1).toUpperCase() + names[i].substring(1).toLowerCase();
				}
			}
		} catch(Exception e) {
			name = table;
		}
		return name + "Dao";
	}

	public String getDirName(String table) {
		String[] names = table.split("_");
		return names.length > 1 ? getSingularName(names[1]) : table;
	}

	private void display(JspWriter out, String result) throws Exception {
		result = "<!------------------- " + dirName + "/" + prefixName + " - " + type + " ------------------->\r\n" + result;
		out.print("<pre style='font-family:tahoma;font-size:9pt'>");
		out.print(toText(result));
		out.print("</pre>");
	}

	public void setMessage(String str) {
		this.message.append(str);
	}
	private void setMessage(String str, String suffix) {
		this.message.append("[ " + objName + " - " + type + " ] " + str + suffix + "<br>");
	}
	public String getMessage() {
		String msg = this.message.toString();
		initMessage();
		return msg;
	}
	public void initMessage() {
		this.message.setLength(0);
	}

	private String toText(String str) {
		return str.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}

	public void repairResultInit() throws Exception {
		try {
			String srcDir = root + "/generator/result_src";
			Util.copyFile(srcDir, outDir);
			setMessage("[ 扁夯券版汗备肯丰 ]" + "<br>");
		} catch(Exception e) {
			out.print(e);
		}
	}
	public void deleteFiles(String[] files) throws Exception {
		for(int i=0; i<files.length; i++) {
			File file = new File(files[i].replaceAll("/", File.separator));
			if(file.exists()) {
				Util.delFile(files[i]);
				setMessage("[ DeleteFile ] " + files[i] + "<br>");
			}
		}
	}

	public void copyFiles(String[] files) throws Exception {

		for(int i=0; i<files.length; i++) {
			String tgt = outDir + "/" + files[i].replaceAll(root + "/result/", "");

			Util.copyFile(files[i], tgt);
			if(!isWindows) Runtime.getRuntime().exec("chown -R " + user + ":" + user + " " + tgt);
			setMessage("[ CopyFile ] " + files[i] + " " + tgt + "<br>");
		}
	}


	private Hashtable formatter(Hashtable row) throws Exception {
		String column = row.get("column_name").toString();
		String name = column.toLowerCase();
		String type = row.get("data_type").toString().toLowerCase();

		String[] numerics = { "int", "tinyint", "dicemal", "number", "integer" };

		//for form check & add
		row.put("name", column);
		row.put("hname", !"".equals(row.get("column_comment").toString().trim()) ? row.get("column_comment").toString() : name);
		row.put("value", "{{" + column + "}}");
		row.put("list", "{{list." + column + "}}");
		row.put("number", Util.inArray(type, numerics) ? ", option:'number'" : "");
		row.put("jumin", "jumin".equals(name) ? ", option:'jumin'" : "");
		row.put("email", "email".equals(name) ? ", option:'email'" : "");
		row.put("phone", "phone".equals(name) || "mobile".equals(name) ? ", option:'phone'" : "");
		row.put("etc", "");
		row.put("field_status", "status".equals(name) ? "true" : "false");

		row.put("is_boolean", "false");
		row.put("inputBox", "true");
		row.put("selectBox", "false");
		row.put("textareaBox", "false");

		row.put("reg_date", "reg_date".equals(column) ? "true" : "false");
		
		//formatting & list addSearch
		String maxLength = row.get("column_length").toString().trim();
		int length = "".equals(maxLength) ? 5 : Integer.parseInt(maxLength);
		if(length > 80) length = 120;
		if((Util.inArray(type, numerics)) && !("id".equals(name) || name.indexOf("_id") != -1)) {
			row.put("gettype", "getInt");
			row.put("sformatter", "m.numberFormat(");
			row.put("eformatter", ")");
			row.put("fsformatter", "");
			row.put("feformatter", "");
			row.put("isformatter", "");
			row.put("ieformatter", "");
			row.put("oper", "");
			row.put("size", "5");
			row.put("date_select_box", "");
			if("status".equals(name)) {
				row.put("sformatter", "m.getItem(");
				row.put("eformatter", ", " + objName + ".statusList)");

				row.put("inputBox", "false");
				row.put("selectBox", "true");
			}
		} else if(name.indexOf("_date") != -1) {
			row.put("gettype", "getString");
			row.put("sformatter", "m.getTimeString(\"yyyy.MM.dd\", ");
			row.put("eformatter", ")");
			row.put("fsformatter", "m.getTimeString(\"yyyy-MM-dd\", ");
			row.put("feformatter", ")");
			row.put("isformatter", "m.getTimeString(\"" + (length == 14 ? "yyyyMMddHHmmss" : "yyyyMMdd") +"\", ");
			row.put("ieformatter", ")");
			row.put("oper", "");
			row.put("size", "10");
			row.put("date_select_box", " onfocus=\"new CalendarFrame.Calendar(this)\" readonly");
		} else if(name.indexOf("_yn") != -1) {
			row.put("gettype", "getString");
			row.put("sformatter", "");
			row.put("eformatter", "");
			row.put("fsformatter", "");
			row.put("feformatter", "");
			row.put("isformatter", "");
			row.put("ieformatter", "");
			row.put("oper", "");
			row.put("size", "5");
			row.put("date_select_box", "");
			row.put("inputBox", "false");
			row.put("selectBox", "true");
			row.put("is_boolean", "true");
		} else {
			row.put("gettype", "getString");
			row.put("sformatter", "");
			row.put("eformatter", "");
			row.put("fsformatter", "");
			row.put("feformatter", "");
			row.put("isformatter", "");
			row.put("ieformatter", "");
			row.put("oper", ", \"LIKE\"");
			row.put("size", "" + Math.abs(length - 40));
			row.put("date_select_box", "");

			if(Util.parseInt(maxLength) >= 1000 || type.equals("text") || type.equals("ntext")) {
				row.put("inputBox", "false");
				row.put("textareaBox", "true");
			}
		}

		return row;
	}



	public void i(String table) throws Exception { 
		this.type = "insert";
		this.group = "program";
		generator(table);
		this.group = "html";
		generator(table);
	}
	public void i(String table, String group) throws Exception { 
		this.type = "insert";
		this.group = group;
		generator(table);
	}

	public void m(String table) throws Exception { 
		this.type = "modify";
		this.group = "program";
		generator(table);
		this.group = "html";
		generator(table);
	}
	public void m(String table, String group) throws Exception { 
		this.type = "modify";
		this.group = group;
		generator(table);
	}

	public void v(String table) throws Exception { 
		this.type = "view";
		this.group = "program";
		generator(table);
		this.group = "html";
		generator(table);
	}
	public void v(String table, String group) throws Exception { 
		this.type = "view";
		this.group = group;
		generator(table);
	}

	public void d(String table) throws Exception { 
		this.type = "delete";
		this.group = "program";
		generator(table);
		this.group = "html";
		generator(table);
	}
	public void d(String table, String group) throws Exception { 
		this.type = "delete";
		this.group = group;
		generator(table);
	}

	public void l(String table) throws Exception { 
		this.type = "list";
		this.group = "program";
		generator(table);
		this.group = "html";
		generator(table);
	}
	public void l(String table, String group) throws Exception { 
		this.type = "list";
		this.group = group;
		generator(table);
	}

	public void t(String table) throws Exception { 
		this.type = "init";
		this.group = "";
		generator(table);
	}
	public void o(String table) throws Exception { 
		this.type = "dao";
		this.group = "";
		generator(table);
	}

	public void all(String table) throws Exception { 
		i(table);
		m(table);
		v(table);
		d(table);
		l(table);
		t(table);
		o(table);
	}
}

