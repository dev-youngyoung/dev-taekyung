package nicelib.util;

import java.io.IOException;
import java.io.StringReader;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;
import org.jdom.input.SAXBuilder;

import procure.common.conf.Startup;

public class AptBid {
	private String key = "";
	
	public static void main(String[] args) {
		
		AptBid apt = new AptBid();
		
		LinkedHashMap<String, String> aptInfo = new LinkedHashMap<String, String>();
		LinkedHashMap<String, String> bidInfo = new LinkedHashMap<String, String>();
		
		// 아파트 정보
		aptInfo.put("code_way", "01");  // 
		aptInfo.put("apt_code", "23");  // 단지코드
		aptInfo.put("apt_name", "단지명");  // 단지명
		aptInfo.put("apt_addr", "관리사무소 주소");  // 관리사무소 주소
		aptInfo.put("apt_man", "아파트 담당자");  // 아파트 담당자 
		aptInfo.put("apt_tel", "전화번호");  // 전화번호
		aptInfo.put("apt_fax", "팩스번호");  // 팩스번호
		aptInfo.put("apt_dong", "동수");  // 동수(옵션)
		aptInfo.put("apt_house", "세대 수");  // 세대수(옵션)
			
		bidInfo.put("bid_num", "M43400001");  // 입찰번호
		bidInfo.put("state", "1");  // 입찰진행상황(1:신규, 2:수정, 3:재입찰, 4:유찰, 5:낙찰, 6:취소, 7:수정취소, 8:낙찰:계약진행, 9:계약취소(입찰무효)
		bidInfo.put("area", "시도코드");  // 시도코드
		bidInfo.put("title", "입찰제목");  // 입찰제목
		bidInfo.put("url", "http://www.niceaptbid.com/web/apt/bid/kapt_view.jsp?q=");  // http 주소
		bidInfo.put("deadline", "2016-03-31 10:00:00");  // 입찰마감일(데이타포맷 YYYY-MM-DD HH24:MI:SS)
		bidInfo.put("reg_date", "2016-03-20 10:25:10");  // 공고일시(데이타포맷 YYYY-MM-DD HH24:MI:SS)
		bidInfo.put("code_classify_type_1", "01");  // 입찰 구분 타입 대분류(01:주택관리업자, 02:사업자)
		bidInfo.put("code_classify_type_2", "01");  // 입찰 구분 타입 중분류(01:공동주택위탁관리,	02:공사,03:용역, 04:물품, 05:기타)
		bidInfo.put("code_classify_type_3", "");  // 입찰 구분 타입 소분류
		/*
		01:하자보수 / code_classify_type_2="02"일때
		02:장기수선 / code_classify_type_2="02"일때
		03:일반보수 / code_classify_type_2="02"일때
		04:경비 / code_classify_type_2="03"일때
		05:청소 / code_classify_type_2="03"일때
		06:승강기유지 / code_classify_type_2="03"일때
		07:지능형홈네트워크 / code_classify_type_2="03"일때
		08:전기안전관리 / code_classify_type_2="03"일때
		09:정화조청소, 관리 / code_classify_type_2="03"일때
		10:저수조 청소 / code_classify_type_2="03"일때
		11:건축물 안전진단 / code_classify_type_2="03"일때
		12:기타 용역 / code_classify_type_2="03"일때
		13:구입 / code_classify_type_2="04"일때
		14:매각 / code_classify_type_2="04"일때
		15:잡수입 / code_classify_type_2="05"일때
		16:보험계약 / code_classify_type_2="05"일때
		13:소독 / code_classify_type_2="05"일때
		14:주민운동시설의 위탁 / code_classify_type_2="05"일때
		*/
		bidInfo.put("code_way", "01");  // 입찰방법(00:직접입찰, 01:전자입찰)
		bidInfo.put("code_kind", "01");  // 입찰종류(01:일반경쟁, 02:제한경쟁, 03:지명경쟁)
		bidInfo.put("code_suc_way", "01");  // 낙찰방법(01:최저(고) 낙찰, 02:적격심사)
		bidInfo.put("terms_of_payment", "01");  // 지급 조건(옵션)
		bidInfo.put("guarantee_yn", "Y");  // 입찰보증보험증권 유무(Y:유, N:무)
		bidInfo.put("credit_conf_yn", "Y");  // 신용평가 등급확인서 제출여부(Y : 제출, N:미제출)
		bidInfo.put("mng_cert_yn", "Y");  // 관리(공사용역) 실적증명서 제출 여부(Y : 제출, N:미제출)
		bidInfo.put("cert_open_yn", "Y");  // 입찰서 개봉 여부(Y:개봉, N:미개봉)
		bidInfo.put("emrg_yn", "N");  // 긴급입찰여부(Y:긴급, N:일반)
		bidInfo.put("contract_date", "2016-04-08");  // 계약체결날짜(데이타포맷 YYYY-MM-DD) (옵션)
		bidInfo.put("contract_regdt", "2016-03-22 10:25:10");  // 계약체결등록일(데이타포맷 YYYY-MM-DD HH24:MI:SS) (옵션)
		bidInfo.put("field_des_loc", "아파트 관리사무소");  // 현장설명장소 (옵션)
		bidInfo.put("field_des_date", "2016-03-25 10:25:10");  // 현장설명 일시(데이타포맷 YYYY-MM-DD HH24:MI:SS) (옵션)
		bidInfo.put("field_des_ess", "N");  // 현장설명회참석필수여부(P:필수, Y:임의, N:없음)
		bidInfo.put("req_docs", "구비서류");  // 구비서류명 (옵션)
		bidInfo.put("docs_deadline", "2016-03-26 10:00:10");  // 서류제출마감일(데이타포맷 YYYY-MM-DD HH24:MI:SS) (옵션)
		bidInfo.put("org_num", "2016-03-26 10:00:10");  // 재공고시 ORG 입찰 번호 (수정, 재공고일 때 필수)
		
		// 유찰, 낙찰, 취소, 낙찰무효시
		bidInfo.put("reason", "낙찰,유찰,취소 사유");  // 낙찰,유찰,취소 사유 (필수)
		bidInfo.put("com_name", "업체 명");  // 업체 명 (낙찰, 취소시 필수)
		bidInfo.put("com_owner", "대표자 명");  // 대표자 명 (옵션)
		bidInfo.put("com_addr", "주소");  // 주소 (옵션)
		bidInfo.put("com_tel", "연락처");  // 연락처 (옵션)
		bidInfo.put("con_period_sdate", "2016-04-08");  // 계약 시작일(데이타포맷 YYYY-MM-DD) (옵션)
		bidInfo.put("con_period_edate", "2017-04-07");  // 계약 종료일(데이타포맷 YYYY-MM-DD) (옵션)
		bidInfo.put("con_prog_period_sdate", "2016-04-08");  // 계약 체결기간 시작일(데이타포맷 YYYY-MM-DD) (옵션)
		bidInfo.put("con_prog_period_edate", "2016-04-08");  // 계약 체결기간 종료일(데이타포맷 YYYY-MM-DD) (옵션)
		bidInfo.put("con_amount", "10000000");  // 계약 금액 (낙찰, 취소시 필수)
		bidInfo.put("con_type", "01");  // 선정 방법(01:경쟁입찰, 02:수의계약) (낙찰, 취소시 필수)
		bidInfo.put("etc", "기타 내용");  // 내용 (옵션)
		
		apt.createAptXml(5, aptInfo, bidInfo);
		
	}
	
	public AptBid() {
		key = Startup.conf.getString("k-apt.key");
	}
	
	public String retAtpXml(String retXml) throws JDOMException, IOException {
		
		SAXBuilder builder = new SAXBuilder();  
		Document doc = builder.build(new StringReader(retXml));
		
		Element root = doc.getRootElement();
		String code = root.getAttributeValue("code");
		String msg = root.getAttributeValue("msg");
		
		System.out.println("kapt code[" + code + "], msg["+msg+"]");
		
		return code;
	}
	
	public String createAptXml(int state, LinkedHashMap<String, String> aptInfo, LinkedHashMap<String, String> bidInfo) {
		
		// 1. Document 생성
		Document doc = new Document();
		Element apt_info = new Element("apt_info");
		Element bid_info = new Element("bidding_info");
		
		Iterator<String> it = aptInfo.keySet().iterator();
		Iterator<String> it2 = bidInfo.keySet().iterator();
		
		// 2. Root Element 생성
		Element root = new Element("g2b");
		doc.setContent(root);
		 
		// 3. Child Element 생성
		switch(state) {
		case 1: // 신규
		case 2: // 수정
		case 3: // 재공고
			root.setAttribute("cmd", "insert");
			root.setAttribute("key", key);
			
			while(it.hasNext()) {
				String key = (String)it.next();
				apt_info.setAttribute(key, aptInfo.get(key));
			}
			
			while(it2.hasNext()) {
				String key = (String)it2.next();
				bid_info.setAttribute(key, bidInfo.get(key));
			}
			
			root.addContent(apt_info);
			root.addContent(bid_info);
			break;
		
			
		case 4: // 유찰
		case 5: // 낙찰
		case 6: // 취소
		case 9: // 낙찰무효
			root.setAttribute("cmd", "result");
			root.setAttribute("key", key);
			
			while(it2.hasNext()) {
				String key = (String)it2.next();
				bid_info.setAttribute(key, bidInfo.get(key));
			}

			root.addContent(bid_info);
			break;			
			
		case 7: // 수정취소
			
			break;
			
		case 8: // 낙찰:계약진행(사용안함)
			
			break;
			
			
		} 

		String retXml = new XMLOutputter(Format.getPrettyFormat().setEncoding("UTF-8")).outputString(doc);
		System.out.println(retXml);
		         
		return retXml;
		
	}
	
	 
}
