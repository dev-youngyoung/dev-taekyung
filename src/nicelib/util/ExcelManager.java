package nicelib.util;
import java.io.*;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Iterator;

import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.hssf.util.*;
import org.apache.poi.sl.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.usermodel.VerticalAlignment;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.*;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import nicelib.db.*;

public class ExcelManager {
	
	private String[] strColIndex= {
		 "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
		,"AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"
		,"BA","BB","BC","BD","BE","BF","BG","BH","BI","BJ","BK","BL","BM","BN","BO","BP","BQ","BR","BS","BT","BU","BV","BW","BX","BY","BZ"
		,"CA","CB","CC","CD","CE","CF","CG","CH","CI","CJ","CK","CL","CM","CN","CO","CP","CQ","CR","CS","CT","CU","CV","CW","CX","CY","CZ"
		,"DA","DB","DC","DD","DE","DF","DG","DH","DI","DJ","DK","DL","DM","DN","DO","DP","DQ","DR","DS","DT","DU","DV","DW","DX","DY","DZ"
		,"EA","EB","EC","ED","EE","EF","EG","EH","EI","EJ","EK","EL","EM","EN","EO","EP","EQ","ER","ES","ET","EU","EV","EW","EX","EY","EZ"
		,"FA","FB","FC","FD","FE","FF","FG","FH","FI","FJ","FK","FL","FM","FN","FO","FP","FQ","FR","FS","FT","FU","FV","FW","FX","FY","FZ"
		,"GA","GB","GC","GD","GE","GF","GG","GH","GI","GJ","GK","GL","GM","GN","GO","GP","GQ","GR","GS","GT","GU","GV","GW","GX","GY","GZ"
		,"HA","HB","HC","HD","HE","HF","HG","HH","HI","HJ","HK","HL","HM","HN","HO","HP","HQ","HR","HS","HT","HU","HV","HW","HX","HY","HZ"
		,"IA","IB","IC","ID","IE","IF","IG","IH","II","IJ","IK","IL","IM","IN","IO","IP","IQ","IR","IS","IT","IU","IV","IW","IX","IY","IZ"
	};
	
	
	public DataSet fileRead(String filePath){
		return fileRead(filePath, 1);
	}
	
	public DataSet fileRead(String filePath, int readStartRow){
		DataSet ds = null;
		if(filePath.toLowerCase().endsWith("xls")){
			ds = xls2dataset(filePath,readStartRow);
		}
		if(filePath.toLowerCase().endsWith("xlsx")){
			ds = xlsx2dataset(filePath,readStartRow);
		}
		return ds;
	}
	
	public DataSet xls2dataset(String filePath,int readStartRow){
		DataSet ds = new DataSet();
		try{
			//파일을 읽기위해 엑셀파일을 가져온다
			FileInputStream fis=new FileInputStream(filePath);
			HSSFWorkbook workbook=new HSSFWorkbook(fis);
			//시트 수 (첫번째에만 존재하므로 0을 준다)
			//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
			HSSFSheet sheet=workbook.getSheetAt(0);
			//행의 수
			int row_cnt = sheet.getPhysicalNumberOfRows();
			for(int rowindex=readStartRow ; rowindex<row_cnt ; rowindex++){
				//행을 읽는다
			    HSSFRow row=sheet.getRow(rowindex);
		
			    if(row == null)continue;
			    
			    ds.addRow();
			    ds.put("rowindex",rowindex);
			    int cell_cnt = row.getPhysicalNumberOfCells();
			    for(int cellindex = 0; cellindex < cell_cnt; cellindex++){
			    	HSSFCell cell=row.getCell(cellindex);
			    	String value = "";
			    	if(cell == null) continue;
			    	
			    	
			    	switch(cell.getCellType()){
			    	case HSSFCell.CELL_TYPE_FORMULA:
	                    value=cell.getCellFormula();
	                    break;
	                case HSSFCell.CELL_TYPE_NUMERIC:
	                	value = cell.getNumericCellValue()+"";
	                    break; 
	                case HSSFCell.CELL_TYPE_STRING:
	                    value=cell.getStringCellValue()+"";
	                    break;
	                case HSSFCell.CELL_TYPE_BLANK:
	                    value=cell.getBooleanCellValue()+"";
	                    break;
	                case HSSFCell.CELL_TYPE_ERROR:
	                    value=cell.getErrorCellValue()+"";
	                    break;
			    	}
			    	ds.put(strColIndex[cellindex], value);
			    }
			}
			ds.first();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return ds;
	}
	
	public DataSet xlsx2dataset(String filePath, int readStartRow){		
		DataSet ds = new DataSet();
		try{
			//파일을 읽기위해 엑셀파일을 가져온다
			FileInputStream fis=new FileInputStream(filePath);
			XSSFWorkbook workbook=new XSSFWorkbook(fis);
			//시트 수 (첫번째에만 존재하므로 0을 준다)
			//만약 각 시트를 읽기위해서는 FOR문을 한번더 돌려준다
			XSSFSheet sheet=workbook.getSheetAt(0);
			//행의 수
			int row_cnt = sheet.getPhysicalNumberOfRows();
			for(int rowindex=readStartRow ; rowindex<row_cnt ; rowindex++){
				//행을 읽는다
				XSSFRow row=sheet.getRow(rowindex);
		
			    if(row == null)continue;
			    
			    ds.addRow();
			    ds.put("rowindex",rowindex);
			    int cell_cnt = row.getPhysicalNumberOfCells();
			    for(int cellindex = 0; cellindex < cell_cnt; cellindex++){
			    	XSSFCell cell=row.getCell(cellindex);
			    	String value = "";
			    	if(cell == null) continue;
			    	
			    	switch(cell.getCellType()){
			    	case HSSFCell.CELL_TYPE_FORMULA:
	                    value=cell.getCellFormula();
	                    break;
	                case HSSFCell.CELL_TYPE_NUMERIC:
	                    value=cell.getNumericCellValue()+"";
	                    break;
	                case HSSFCell.CELL_TYPE_STRING:
	                    value=cell.getStringCellValue()+"";
	                    break;
	                case HSSFCell.CELL_TYPE_BLANK:
	                    value=cell.getBooleanCellValue()+"";
	                    break;
	                case HSSFCell.CELL_TYPE_ERROR:
	                    value=cell.getErrorCellValue()+"";
	                    break;
			    	}
			    	ds.put(strColIndex[cellindex], value);
			    }
			}
			ds.first();
		}catch (Exception e) {
			e.printStackTrace();
		}
		return ds;
	}
	
	public void xlsWrite(String conf,DataSet data, String file_path)throws Exception{
		FileOutputStream fileOutputStream = new FileOutputStream(file_path);
		xlsWrite(conf, data, fileOutputStream);
		fileOutputStream.close();
	}
	
	public void xlsWrite(String conf,DataSet data, OutputStream outputStream)throws Exception{
			DataSet confDS = json2DataSet(conf);
			if(!confDS.next()){
				return;
			}
			
			//column 정보
			String[] columns = confDS.getString("column").split(",");
			//header 정보
			DataSet header = confDS.getDataSet("header");
			//셀병합 정보
			DataSet merge = confDS.getDataSet("merge");
			//col style
			DataSet col_style = confDS.getDataSet("col_style");
		
			//workbook을 생성 
			HSSFWorkbook workbook=new HSSFWorkbook();
			//sheet생성 
			HSSFSheet sheet=workbook.createSheet("sheet1");
			
			//엑셀의 행 
			HSSFRow row=null;
			//엑셀의 셀 
			HSSFCell cell=null;
			//엑셀의 header style
			HSSFCellStyle headerStyle = getHeaderStyle(workbook);
			//흰색
			HSSFCellStyle colStyle_left = getColStyle(workbook,"left","","");
			HSSFCellStyle colStyle_center = getColStyle(workbook,"center","","");
			HSSFCellStyle colStyle_right = getColStyle(workbook,"right","","");

			//흰색 숫자
			HSSFCellStyle colStyle_left_number = getColStyle(workbook,"left","","#,##0.00");
			HSSFCellStyle colStyle_center_number = getColStyle(workbook,"center","","#,##0");
			HSSFCellStyle colStyle_right_number = getColStyle(workbook,"right","","#,##0");
			
			//흰색  소수점 숫자
			HSSFCellStyle colStyle_left_decimal = getColStyle(workbook,"left","","#,##0.000");
			HSSFCellStyle colStyle_center_decimal = getColStyle(workbook,"center","","#,##0.000");
			HSSFCellStyle colStyle_right_decimal = getColStyle(workbook,"right","","#,##0.000");

			//노란색 숫자
			HSSFCellStyle colStyle_left_yellow_number = getColStyle(workbook,"left","yellow","#,##0");
			HSSFCellStyle colStyle_center_yellow_number = getColStyle(workbook,"center","yellow","#,##0");
			HSSFCellStyle colStyle_right_yellow_number = getColStyle(workbook,"right","yellow","#,##0");
			
			//노란색  소수점 숫자
			HSSFCellStyle colStyle_left_yellow_decimal = getColStyle(workbook,"left","yellow","#,##0.000");
			HSSFCellStyle colStyle_center_yellow_decimal = getColStyle(workbook,"center","yellow","#,##0.000");
			HSSFCellStyle colStyle_right_yellow_decimal = getColStyle(workbook,"right","yellow","#,##0.000");
			
			if(header != null){
				row=sheet.createRow((short)confDS.getInt("header_row"));
				for(int i = 0 ; i < columns.length; i++){
					cell=row.createCell((short)i);
					header.first();
					while(header.next()){
						if(columns[i].equals(header.getString("column"))){
							cell.setCellStyle(headerStyle);
							
							if(!header.getString("group").equals("")||!header.getString("group1").equals("")){

								if(!header.getString("group1").equals("")){
									cell.setCellValue(header.getString("group1"));
									int next_row = cell.getRow().getRowNum()+1;
									
									HSSFRow sub_row = sheet.getRow(next_row);
									if(sub_row == null){
										sub_row = sheet.createRow(next_row);
									}
									cell = sub_row.getCell(i);
									if(cell == null){
										cell = sub_row.createCell(i);
										cell.setCellStyle(headerStyle);
									}
								}
								if(!header.getString("group").equals("")){
									
									cell.setCellValue(header.getString("group"));
									int next_row = cell.getRow().getRowNum()+1;
									
									HSSFRow sub_row = sheet.getRow(next_row);
									if(sub_row == null){
										sub_row = sheet.createRow(next_row);
									}
									cell = sub_row.getCell(i);
									if(cell == null){
										cell = sub_row.createCell(i);
										cell.setCellStyle(headerStyle);
									}
								}
								
								cell.setCellValue(header.getString("value"));
								
							}else{
								cell.setCellValue(header.getString("value"));
							}
							
							break;
						}
						
					}
				}
			}
			int row_pos = confDS.getInt("data_start_row");
			if(data!=null){
				data.first();
				while(data.next()){
					row=sheet.createRow((short)row_pos);
					for(int i = 0 ; i < columns.length; i++){
						cell=row.createCell((short)i);
						
						if(col_style!=null){
							col_style.first();
							while(col_style.next()){
								if(col_style.getString("column").equals(columns[i])){
									//일반
									
									if(col_style.getString("style").equals("left")){
										cell.setCellStyle(colStyle_left);
									}else
									if(col_style.getString("style").equals("center")){
										cell.setCellStyle(colStyle_center);
									}else
									if(col_style.getString("style").equals("right")){
										cell.setCellStyle(colStyle_right);
									}else
									//일반 숫자
									if(col_style.getString("style").equals("left_number")){
										cell.setCellStyle(colStyle_left_number);
									}else
									if(col_style.getString("style").equals("center_number")){
										cell.setCellStyle(colStyle_center_number);
									}else
									if(col_style.getString("style").equals("right_number")){
										cell.setCellStyle(colStyle_right_number);
									}else
									//일반 소수점
									if(col_style.getString("style").equals("left_decimal")){
										cell.setCellStyle(colStyle_left_decimal);
									}else
									if(col_style.getString("style").equals("center_decimal")){
											cell.setCellStyle(colStyle_center_decimal);
									}else
									if(col_style.getString("style").equals("right_decimal")){
											cell.setCellStyle(colStyle_right_decimal);
									}else
									//노랑 숫자
									if(col_style.getString("style").equals("left_yellow_number")){
										cell.setCellStyle(colStyle_left_yellow_number);
									}else
									if(col_style.getString("style").equals("center_yellow_number")){
										cell.setCellStyle(colStyle_center_yellow_number);
									}else
									if(col_style.getString("style").equals("right_yellow_number")){
										cell.setCellStyle(colStyle_right_yellow_number);
									}else
									//노랑 소수점
									if(col_style.getString("style").equals("left_yellow_decimal")){
										cell.setCellStyle(colStyle_left_yellow_decimal);
									}else
									if(col_style.getString("style").equals("center_yellow_decimal")){
										cell.setCellStyle(colStyle_center_yellow_decimal);
									}else
									if(col_style.getString("style").equals("right_yellow_decimal")){
										cell.setCellStyle(colStyle_right_yellow_decimal);
									}else{
										cell.setCellStyle(colStyle_left);
									}
									
									if(!col_style.getString("formula").equals("")){
										cell.setCellFormula(col_style.getString("formula").replaceAll("\\$", (row_pos+1)+""));
									}
									break;
								}
							}
						}
						
						if(col_style.getString("style").indexOf("number")>0||col_style.getString("style").indexOf("decimal")>0){
							cell.setCellValue(data.getDouble(columns[i]));
						}else{
							cell.setCellValue(data.getString(columns[i]));
						}
						
					}
					row_pos++;
				}
			}
			
			//auto_width
			if(confDS.getString("auto_size").equals("true")){
				for(int i=0; i<columns.length; i++){
				 sheet.autoSizeColumn((short)i);
				 sheet.setColumnWidth(i, (sheet.getColumnWidth(i))+512 );
				}
			}
			
			//width
			if(header!=null){
				for(int i=0; i<columns.length; i++){
					header.first();
					while(header.next()){
						if(columns[i].equals(header.getString("column"))){
							sheet.setColumnWidth((short)i,header.getInt("width") );//300일 엑셀열넓이 1 정도
							break;
						}
					}
				}
			}
			
			if(merge != null){
				while(merge.next()){
					cell =  sheet.getRow(merge.getInt("firstRow")).getCell(merge.getInt("firstCol")); 
					HSSFCellStyle cellStyle = cell.getCellStyle();
					//col
					for(int i = merge.getInt("firstCol"); i<=merge.getInt("lastCol");i++){
						for(int j = merge.getInt("firstRow"); j<=merge.getInt("lastRow");j++){
							if(j==merge.getInt("firstRow")&&i==merge.getInt("firstCol")){
								continue;
							}
							row = sheet.getRow(j); 
							if(row == null){
								row= sheet.createRow(j);
							}
							cell = row.getCell(i);
							if(cell == null){
								cell = row.createCell(i);
							}
							cell.setCellStyle(cellStyle);
						}
					}
					CellRangeAddress region = new CellRangeAddress(merge.getInt("firstRow"),merge.getInt("lastRow"),merge.getInt("firstCol"), merge.getInt("lastCol"));
					sheet.addMergedRegion(region);
				}
			}
			workbook.write(outputStream);
			workbook.close();
	}
	
	
	private HSSFCellStyle getHeaderStyle(HSSFWorkbook workbook){
		HSSFCellStyle cellStyle = null;
		
		//style은 excel당4000개 가지 밖에 생성 불가
		//header style
		cellStyle = workbook.createCellStyle();
		//bgcolor
		cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
		cellStyle.setFillForegroundColor(HSSFColor.GREY_25_PERCENT.index);
		//bold
		HSSFFont font = workbook.createFont(); 
		font.setBold(true);
		cellStyle.setFont(font);
		//align
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		cellStyle.setAlignment(HorizontalAlignment.CENTER);
		//border
		cellStyle.setBorderTop(BorderStyle.THIN);
		cellStyle.setBorderRight(BorderStyle.THIN);
		cellStyle.setBorderBottom(BorderStyle.THIN);
		cellStyle.setBorderLeft(BorderStyle.THIN);
		return cellStyle;
	}
	

	private HSSFCellStyle getColStyle(HSSFWorkbook workbook, String align, String bgcolor, String numberFormat){
		HSSFCellStyle cellStyle = null;
		
		cellStyle = workbook.createCellStyle();
		//bgcolor
		if(bgcolor.equals("yellow")){
			cellStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
			cellStyle.setFillForegroundColor(HSSFColor.LIGHT_YELLOW.index);
		}
		//align
		cellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
		if(align.equals("center")){
			cellStyle.setAlignment(HorizontalAlignment.CENTER);
		}
		if(align.equals("left")){
			cellStyle.setAlignment(HorizontalAlignment.LEFT);
		}
		if(align.equals("right")){
			cellStyle.setAlignment(HorizontalAlignment.RIGHT);
		}
		//border
		cellStyle.setBorderTop(BorderStyle.THIN);
		cellStyle.setBorderRight(BorderStyle.THIN);
		cellStyle.setBorderBottom(BorderStyle.THIN);
		cellStyle.setBorderLeft(BorderStyle.THIN);
		
		if(!numberFormat.equals("")){
			cellStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat(numberFormat));
		}
		return cellStyle;
	}
	
	
	private DataSet json2DataSet(String jsonstr){
		DataSet ds = new DataSet();
		JSONObject json = JSONObject.fromObject(jsonstr);
		ds.addRow();

		Iterator keys = json.keys();
		while(keys.hasNext()){
			String id = (String)keys.next();
			Object obj = json.get(id);
			if(obj.getClass().toString().indexOf("JSONArray")>0){
				ds.put(id, jsonArr2dataset(json.getString(id)));
			}else{
				ds.put(id, json.getString(id));
			}
		}
		
		ds.first();
		return ds;
	}
	
	private DataSet jsonArr2dataset(String jsonstr){
		DataSet ds = new DataSet();
		if(jsonstr.equals(""))return ds;
		
		JSONArray jarr = JSONArray.fromObject(jsonstr);
		for(int i =0 ;i < jarr.size(); i ++){
			ds.addRow();
			JSONObject json =  jarr.getJSONObject(i);
			Iterator keys = json.keys();
			while(keys.hasNext()){
				String id = (String)keys.next(); 
				ds.put(id, json.getString(id));
			}
		}
		ds.first();
		return ds;
	}
}