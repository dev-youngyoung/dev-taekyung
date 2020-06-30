package nicednb.ebiz;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.List;
import java.util.Properties;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.input.SAXBuilder;

public class EbizReqData {
	private Properties props;
	private String nicednb_req_url;
	private String nicednb_ret_url;
	private String biz_vend_cd;
	private String biz_conn_id;
	private String biz_rcv_filepath;
	private String biz_rcv_filenm;
	private String[] keyFields;
	private String[] dataFields;
	private String ins_qry;
	private String del_qry;
	private SimpleDateFormat dateTimeSf = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	private SimpleDateFormat dateSf = new SimpleDateFormat("yyyyMMddHHmmss");
	private boolean isSuccess = false;
	private File logf;
	private long log_fsize;
	private PrintWriter log;

	// 초기화
	private void init() throws Exception {
		SimpleDateFormat df1 = new SimpleDateFormat("yyyyMM");
		SimpleDateFormat df2 = new SimpleDateFormat("yyyyMMdd");
		Calendar cal = Calendar.getInstance();

		load_prop("nicednb.ebiz.properites");

		nicednb_req_url = props.getProperty("nicednb.req.url");
		nicednb_ret_url = props.getProperty("nicednb.ret.url");
		biz_rcv_filepath = getKo(props.getProperty("biz.rcv.filepath"));
		biz_rcv_filenm = getKo(props.getProperty("biz.rcv.filenm"));
		biz_rcv_filenm = df2.format(cal.getTime()) + "_" + biz_rcv_filenm;
		biz_vend_cd = props.getProperty("biz.vend.cd");
		biz_conn_id = props.getProperty("biz.conn.id");

		// 전송파일 디렉토리
		if(biz_rcv_filepath.charAt(biz_rcv_filepath.length()-1)!='/') {
			biz_rcv_filepath = biz_rcv_filepath + "/";
		}

		biz_rcv_filepath = biz_rcv_filepath + df1.format(cal.getTime()) + "/";

		File f = new File(biz_rcv_filepath);

        if(!f.isDirectory()) {
        	f.mkdirs();
        }

        // 로그파일디렉토리
		String log_filepath = getKo(props.getProperty("biz.logpath"));

		if(log_filepath.charAt(log_filepath.length()-1)!='/') {
			log_filepath = log_filepath + "/";
		}

		String _log_filepath = log_filepath + df1.format(cal.getTime()) + "/";

		logf = new File(_log_filepath);

		if(!logf.exists()) {
			logf.mkdirs();
		}

		logf = new File(_log_filepath + df2.format(cal.getTime()) + ".log");
		log = new PrintWriter(new FileWriter(logf, true), true);
	}

	// Properties Load
	private Properties load_prop(String prop_file) throws Exception {
		ClassLoader cl = Thread.currentThread().getContextClassLoader();
		
		if(cl==null) {
			cl = ClassLoader.getSystemClassLoader();
		}

		URL url = cl.getResource(prop_file);
		String prop_fname;

		if(url==null) {
			prop_fname = prop_file;
		} else {
			prop_fname = url.getFile();
		}

		props = new Properties();

		FileInputStream fis = new FileInputStream(prop_fname);

		props.load(fis);
		fis.close();

		return props;
	}

	// 메인
	public static void main(String argv[]) {
		EbizReqData ebizReqData = new EbizReqData();

		try {
			try {
				ebizReqData.init();
			} catch(Exception e1) {
				System.out.println("설정파일(nicednb.ebiz.properites)을 확인하시기 바랍니다.");
				e1.printStackTrace();
				return;
			}

			ebizReqData.log("**********************************************************", true);
			ebizReqData.log("* EbizReqData Process 작업시작 ", true);
			ebizReqData.log("**********************************************************", true);

			if(argv.length==0) {
				argv = new String[]{""};
			}

			String p_data = argv[0].toUpperCase();

			if(!p_data.equals("") && p_data.length() != 8) {
				ebizReqData.log("*********** Request Job Parameter is not Valid ***********", true);
				ebizReqData.log("** Parameter : 일자[특정일자|99991231]                     ***", true);
				ebizReqData.log("** [" + p_data + "] 일자를 확인해 주십시요.                          ***", true);
				ebizReqData.log("**********************************************************", true);
			} else {
				try {
					if(p_data.length() == 8) {
						Double.parseDouble(p_data);
					}

					ebizReqData.log("* Request Job Parameter", true);
					ebizReqData.log("* 요청일자 : " + p_data, true);
					ebizReqData.log("**********************************************************", true);

					try {
						// 정보전송요청
						if(ebizReqData.getRequestData(p_data)) {
							// 전송파일 DB write
							ebizReqData.getXMLDataWrite();
						}

						// 결과리턴
						ebizReqData.setReturnMsg();
					} catch(Exception _ebiz) {
						ebizReqData.log("reqData.getContReceive_data Exception is " + _ebiz.toString(), true);
					}
				} catch(Exception _ex) {
					ebizReqData.log("*********** Request Job Parameter is not Valid ***********", true);
					ebizReqData.log("** Parameter : 일자[특정일자|99991231]                     ***", true);
					ebizReqData.log("** [" + p_data + "] 일자를 확인해 주십시요.                          ***", true);
					ebizReqData.log("**********************************************************", true);
				}
			}

			ebizReqData.log("**********************************************************", true);
			ebizReqData.log("* EbizReqData Process 작업종료", true);
			ebizReqData.log("**********************************************************", true);
		} catch(Exception _e) {
			ebizReqData.log("Main Exception is " + _e.toString(), true);
		} finally {
			 if(ebizReqData.log != null) {
				 ebizReqData.log.close(); 
			 }
		}
	}

	// 정보전송요청
	private boolean getRequestData(String req_date) {
		URL url = null;
		HttpURLConnection conn = null;
		BufferedReader br = null;
		boolean isRequest = false;

		try {
			log("* 정보수신요청 ................................................", true);

			isSuccess = false;

			String conn_url = nicednb_req_url + "?vend_cd=" + biz_vend_cd + "&biz_conn_id=" + biz_conn_id + "&req_date=" + req_date;
			
			System.out.println("conn_url["+conn_url+"]");
			
			
			String line;

			url = new URL(conn_url);
			conn = (HttpURLConnection) url.openConnection();			

			if(conn.getResponseCode()==HttpURLConnection.HTTP_OK) {  // 200
				
	            StringBuffer buff = new StringBuffer();
	           

				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				
				System.out.println("br.toString()["+br.toString()+"]");

	            while ((line = br.readLine()) != null) {
	            	System.out.println("line["+line+"]");
	            	
	            	buff.append(line + "\r\n");
	            }

	            String writer_file = biz_rcv_filepath + biz_rcv_filenm; 
	            
	            System.out.println("writer_file["+writer_file+"]");

	            FileWriter fw = new FileWriter(writer_file);

	            fw.write(buff.toString());
	            fw.flush();

				br.close();
				conn.disconnect();

				isRequest = true;

				log("* 정보수신완료 ................................................", true);
			} else if(conn.getResponseCode()==HttpURLConnection.HTTP_NOT_FOUND) {  // 404
				log("요청하신 " + nicednb_req_url + "를 찾을수가 없습니다.", true);
			} else {
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));

                while((line = br.readLine()) != null) {
                	log(line, true);
                 }
			}
		} catch(Exception e) {
			System.out.println("ddddddddddddddddddddddddddd 9999" + e.toString());
			
			log("getRequestData Exception", true);
			e.printStackTrace(log);

			System.out.println("getRequestData Exception : " + e.toString());
		} finally {
			if(br != null) {
				try {
					br.close();
				} catch(Exception _br) {}
			}

			if(conn != null) {
				try {
					conn.disconnect();
				} catch(Exception _conn) {}
			}
		}

		return isRequest;
	}

	// 전송파일 DB에 Write
	private void getXMLDataWrite() {
		Connection cpool = null;
		PreparedStatement ps_del_qry = null;
		PreparedStatement ps_ins_qry = null;
		FileInputStream fi = null;

		try {
			log("* DB JOB Start ...........................................", true);

			// DB접속
			cpool = db_connect();

			int del_cnt = 0;
			int ins_cnt = 0;
			String tbl_name = "";
            String read_file = biz_rcv_filepath + biz_rcv_filenm;
			File f = new File(read_file);

			fi = new FileInputStream(f);

			SAXBuilder builder = new SAXBuilder();
			Document doc = builder.build(fi);
			Element xmlRoot = doc.getRootElement();

			List list = xmlRoot.getChildren();

			for(int idx=0;idx<list.size();idx++) {
				// 처리테이블의 목록을 가져온다.
				Element element = (Element)list.get(idx);

				tbl_name = element.getName();

				log("********************** TABLE [ " + tbl_name + "] 작업시작 *********************", true);

				// SQL생성
				if(getSqlFieldsCreate(tbl_name)) {
					isSuccess = false;

					ins_cnt = 0;
					del_cnt = 0;

					if(!del_qry.equals("")) {
						ps_del_qry = cpool.prepareStatement(del_qry);
					}

					ps_ins_qry = cpool.prepareStatement(ins_qry);

					// 필드값을 가져온다.
					List dataList = element.getChildren();

					for(int dl=0;dl<dataList.size();dl++) {
						Element dataElement = (Element)dataList.get(dl);

						try {
							if(!del_qry.equals("")) {
								for(int df_del=0;df_del<keyFields.length;df_del++) {
									ps_del_qry.setObject(df_del+1, dataElement.getChildTextTrim(keyFields[df_del]));
								}

								del_cnt = del_cnt + ps_del_qry.executeUpdate();
							}

							for(int df=0;df<dataFields.length;df++) {
								ps_ins_qry.setObject(df+1, dataElement.getChildTextTrim(dataFields[df]));
							}

							ins_cnt = ins_cnt + ps_ins_qry.executeUpdate();
						} catch(Exception _db) {
							throw _db;
						}
					}

					if(ps_del_qry != null) {
						ps_del_qry.close();
					}

					if(ps_ins_qry != null) {
						ps_ins_qry.close();
					}

					if(del_cnt > 0) {
						ins_cnt = ins_cnt - del_cnt;
					}

					String sql_log = "* " + tbl_name + " TABLE INSERT DATA : [" + ins_cnt + "건] UPDATE DATA : [" + del_cnt + "] 건";

					log(sql_log, true);
					log("********************** TABLE [ " + tbl_name + "] 작업종료 *********************", true);

					isSuccess = true;
				}
			}

			cpool.commit();
			fi.close();

			log("* DB JOB End .............................................", true);
		} catch(Exception _ex) {
			if(cpool != null) {
				try {
					cpool.rollback();
				} catch(Exception _cpool) {}
			}
			
			

			log("getXMLDataWrite Exception", true);
			_ex.printStackTrace(log);
		} finally {
			if(ps_del_qry != null) {
				try {
					ps_del_qry.close();
				} catch(Exception _ps_del_qry) {}
			}

			if(ps_ins_qry != null) {
				try {
					ps_ins_qry.close();
				} catch(Exception _ps_ins_qry) {}
				
			}

			if(cpool != null) {
				try {
					cpool.close();
				} catch(Exception _cpool) {}
			}

			if(fi != null) {
				try {
					fi.close();
				} catch(Exception _fi) {}
			}
		}
	}

	// DB접속
	private Connection db_connect() throws Exception {
		String url = props.getProperty("biz.db.url");
		String userid = props.getProperty("biz.db.user");
		String passwd = props.getProperty("biz.db.password");
		String dbms = props.getProperty("biz.db.type");

		Connection cpool = null;

		Class.forName(props.getProperty("biz.db.driver"));

		if("ms2008".equals(dbms)) {
			cpool = DriverManager.getConnection(url);
			log("* Connection for MS-SQL 2008 .........................", true);
		} else {
			cpool = DriverManager.getConnection(url, userid, passwd);
			log("* Connection for " + dbms + "...........................", true);
		}

		cpool.setAutoCommit(false);

		return cpool;
	}

	// SQL생성
	private boolean getSqlFieldsCreate(String pTableNm) throws Exception {
		log("* " + pTableNm + " TABLE SQL 정보생성 Start ...................................", true);

		String keyField = props.getProperty(pTableNm + ".db.keyFields");
		String dataField = props.getProperty(pTableNm + ".db.dataFields");
		String get_field = "";
		String del_field = "";
		String ins_field = "";
		String ins_value = "";
		boolean is_return = false;

		log(pTableNm + " TABLE SQL 정보생성 FAIL : 필드정보가 없습니다." + dataField, true);

		if(dataField==null) {
			log(pTableNm + " TABLE 정보가 없습니다.", true);
		} else if(dataField.equals("")) {
			log(pTableNm + " TABLE SQL 정보생성 FAIL : 필드정보가 없습니다.", true);
		} else {
			dataFields = dataField.split(",");

			for(int idx=0;idx<dataFields.length;idx++) {
				get_field = dataFields[idx];

				if(get_field != null && !"".equals(get_field)) {
					ins_field = ins_field + dataFields[idx] + ",";
					ins_value = ins_value + "?,";
				}
			}

			if(ins_field.equals("")) {
				log("* " + pTableNm + " TABLE INSERT SQL 정보생성 FAIL : 필드정보가 없습니다.", true);
			} else {
				ins_field = ins_field.substring(0, ins_field.length() - 1);
				ins_field = " (" + ins_field + ") ";

				ins_value = ins_value.substring(0, ins_value.length() - 1);
				ins_value = " (" + ins_value + ") ";

				ins_qry = "insert into " + pTableNm + ins_field + "values" + ins_value;

				keyField = keyField==null?"":keyField;

				// DELETE SQL
				if(keyField.equals("")) {
					log(pTableNm + " TABLE SQL 정보생성 FAIL : KEY 필드정보가 없습니다.", true);
				} else {
					keyFields = keyField.split(",");

					for(int idx=0;idx<keyFields.length;idx++) {
						get_field = keyFields[idx];

						if(get_field != null && !"".equals(get_field)) {
							del_field = del_field + " and " + get_field + " = ?";
						}
					}

					if(del_field.equals("")) {
						log("* " + pTableNm + " TABLE UPDATE/DELETE SQL 정보생성 FAIL : KEY 필드정보가 없습니다.", true);
					} else {
						del_qry = "delete from " + pTableNm + " where 1=1" + del_field;

						is_return = true;

						log("* " + pTableNm + " TABLE INSERT SQL => " + ins_qry, true);
						log("* " + pTableNm + " TABLE DELETE SQL => " + del_qry, true);
					}
				}
			}
		}

		log("* " + pTableNm + " TABLE SQL 정보생성 End .....................................", true);

		return is_return;
	}

	// 결과리턴
	private void setReturnMsg() {
		URL url = null;
		HttpURLConnection conn = null;
		BufferedReader br = null;
		String conn_url = "";
		String line;

		try {
			log("* 작업결과 리턴 Start .........................................", true);
			log("* 작업결과 is " + isSuccess, true);

			// 작업성공시
			if(isSuccess) {
	            String read_file = biz_rcv_filepath + biz_rcv_filenm;
				File f = new File(read_file);
				File f_ren = new File(read_file + "_" + getDatetime(dateSf));

				// 파일명변경
				boolean b_ren = f.renameTo(f_ren);

				if(!b_ren) {
					for(int i = 0; i < 20; i++) {
						if(b_ren) {
					    	continue;
						}

						b_ren = f.renameTo(f_ren);

					    System.gc();

						try {
							Thread.sleep(50);
					    } catch(InterruptedException ie) {
							ie.printStackTrace();
						}
					}
				}
			}

			conn_url = nicednb_ret_url +  "?vend_cd=" + biz_vend_cd + "&biz_conn_id=" + biz_conn_id;

			url = new URL(conn_url);
			conn = (HttpURLConnection) url.openConnection();

			conn.setRequestMethod("POST");
			conn.setAllowUserInteraction(true); 
			conn.setDoOutput(true);

			OutputStream out = conn.getOutputStream();

			try {
				out.write((byte[]) getLogBody());
			} catch(Exception _out) {}

			out.close();

			if(conn.getResponseCode() != HttpURLConnection.HTTP_OK) {  // 200
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));

                while((line = br.readLine()) != null) {
                	log(line, true);
                }

				br.close();
			}

			conn.disconnect();

			log("* 작업결과 리턴 End ...........................................", true);
		} catch(Exception e) {
			log("setReturnMsg Exception", true);
			e.printStackTrace(log);

			System.out.println("setReturnMsg Exception : " + e.toString());
		} finally {
			if(br != null) {
				try {
					br.close();
				} catch(Exception _br) {}
			}

			if(conn != null) {
				try {
					conn.disconnect();
				} catch(Exception _conn) {}
			}
		}
	}

	// 한글코드변환
	public static String getKo(String en) {
		String korean = null;

		try {
			korean = new String(en.getBytes("8859_1"),"KSC5601");
		} catch(Exception e) {
			return korean;
		}

		return korean;
	}

	// trace
	public static String toTrace(Throwable e) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);

		e.printStackTrace(pw);
		pw.flush();

		return getKo(sw.toString());
	}

	// 로그출력
	private void log(String str) {
		log(str, false);
	}

	private void log(String str, boolean sys_out) {
		log.println(getDatetime(dateTimeSf) + " " + str);

		if(sys_out) {
			System.out.println(getDatetime(dateTimeSf) + " " + str);
		}
	}

	// 로그내용
	public byte[] getLogBody() throws Exception {
		long log_lsize = logf.length();

		FileInputStream fin = new FileInputStream(logf);
		ByteArrayOutputStream bos = new ByteArrayOutputStream((int)(log_lsize-log_fsize));

		java.nio.channels.FileChannel fc = fin.getChannel();
		java.nio.channels.WritableByteChannel wbc = java.nio.channels.Channels.newChannel(bos);

		fc.transferTo(log_fsize, Long.MAX_VALUE, wbc);

		wbc.close();
		fc.close();

		return bos.toByteArray();
	}

	// 현재일시
	private String getDatetime(SimpleDateFormat df) {
		return df.format(new java.util.Date());
	}

}
