package nicelib.util;

import java.io.File;
import jxl.*;
import jxl.biff.DisplayFormat;
import jxl.format.Alignment;
import jxl.write.*;
import jxl.write.Number;
import javax.servlet.http.HttpServletResponse;
import nicelib.db.DataSet;

/**
 * <pre>
 * // Excel File Save
 * ExcelWriter ex = new ExcelWriter("/data/test.xls");
 * ex.put(1, 1, "aaa");
 * ex.put(1, 2, "bbb");
 * ex.write();
 * 
 * // Excel Export
 * String[] cols = { "col1=>Name", "col2=>Email" };
 * ExcelWriter ex = new ExcelWriter(response, "test.xls");
 * ex.setData(rs, cols);
 * ex.write();
 * </pre>
 */
public class ExcelWriter {

	private WritableWorkbook workbook = null;
	private WritableSheet sheet = null; 

	public ExcelWriter(String path) throws Exception {
		File f = new File(path);
		if(!f.getParentFile().isDirectory()) {
			f.getParentFile().mkdirs();
		}
		
		if(!f.exists()) f.createNewFile();
		workbook = Workbook.createWorkbook(f);
		sheet = workbook.createSheet("Sheet1", 0);
	}

	public ExcelWriter(HttpServletResponse response, String filename) throws Exception {
		//jsp에서 꼭 out.clear(); 해줘야 함.
		response.setContentType("application/octet-stream");
	    response.setHeader("Content-Disposition", "attachment; filename=\"" + new String(filename.getBytes("KSC5601"),"8859_1") + "\"");
		workbook = Workbook.createWorkbook(response.getOutputStream());
		sheet = workbook.createSheet("Sheet1", 0);
	}
	
	public void setWidth(String[] widths) throws Exception {
		//String[] widths = new String[] {"vendcd=>20", "fieldname=>20","cont_name=>20","cont_name=>20","cust_name=>20","cust_vendcd=>20"};
		for(int i=0; i<widths.length; i++) {
			String[] arr = widths[i].split("=>");
			sheet.setColumnView(i, Integer.parseInt(arr[1]) );
		}
	}

	public void setData(DataSet rs, String[] cols) throws Exception {

		//String[] w_cols = new String[] {"vendcd=>원사업자", "fieldname=>공사명","cont_name=>계약명","cont_name=>계약일","cust_name=>업체명","cust_vendcd=>수급사업자"};
		for(int i=0; i<cols.length; i++) {
			String[] arr = cols[i].split("=>");
			this.put(i, 0, arr[1], setCellFormat("center", null, "gray"));
			cols[i] = arr[0];
		}

		int y = 1;
		rs.first();
		while(rs.next()) {
			for(int x=0; x<cols.length; x++) {
				this.put(x, y, rs.getString(cols[x]));
			}
			y++;
		}
	}
	 
	
	public WritableCellFormat setCellFormat(String align, String valign, String backgroundColor) throws Exception{
		WritableCellFormat cellFormat= new WritableCellFormat();
		if(align != null){
			if(align.toLowerCase().equals("center") ){
				cellFormat.setAlignment(Alignment.CENTRE);
			}
			if(align.toLowerCase().equals("left")){
				cellFormat.setAlignment(Alignment.LEFT);
			}
			if(align.toLowerCase().equals("right")){
				cellFormat.setAlignment(Alignment.RIGHT);
			}
		}
		if(valign!= null){
			if(valign.toLowerCase().equals("top")){
				cellFormat.setVerticalAlignment(VerticalAlignment.TOP);
			}
			if(valign.toLowerCase().equals("center")||valign.toLowerCase().equals("middle")){
				cellFormat.setVerticalAlignment(VerticalAlignment.CENTRE);
			}
			if(valign.toLowerCase().equals("bottom")){
				cellFormat.setVerticalAlignment(VerticalAlignment.BOTTOM);
			}
		}
		if(backgroundColor != null){
			cellFormat.setBackground(Colour.GRAY_25);//색상 변경 API없음.
		}
		return cellFormat;
	}
	
	
	public void put(int x, int y, String str) throws Exception {
		if(sheet != null) {
			Label label = new Label(x, y, str); 
			sheet.addCell(label); 
		}
	}
	
	public void put(int x, int y, String str, WritableCellFormat cellFormat) throws Exception {
		if(sheet != null) {
			Label label = new Label(x, y, str, cellFormat); 
			sheet.addCell(label); 
		}
	}

	public void put(int x, int y, int num) throws Exception {
		if(sheet != null) {
			Number number = new Number(x, y, num); 
			sheet.addCell(number);
		}
	}

	public void put(int x, int y, double num) throws Exception {
		if(sheet != null) {
			Number number = new Number(x, y, num); 
			sheet.addCell(number);
		}
	}

	public void merge(int x, int y, int c, int r) throws Exception {
		if(sheet != null) {
			sheet.mergeCells(x, y, c, r);
		}
	}
	

	public void write() throws Exception {
		if(workbook != null) {
			workbook.write();
			workbook.close();
		}
	}
}
