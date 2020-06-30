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
		
		// ����Ʈ ����
		aptInfo.put("code_way", "01");  // 
		aptInfo.put("apt_code", "23");  // �����ڵ�
		aptInfo.put("apt_name", "������");  // ������
		aptInfo.put("apt_addr", "�����繫�� �ּ�");  // �����繫�� �ּ�
		aptInfo.put("apt_man", "����Ʈ �����");  // ����Ʈ ����� 
		aptInfo.put("apt_tel", "��ȭ��ȣ");  // ��ȭ��ȣ
		aptInfo.put("apt_fax", "�ѽ���ȣ");  // �ѽ���ȣ
		aptInfo.put("apt_dong", "����");  // ����(�ɼ�)
		aptInfo.put("apt_house", "���� ��");  // �����(�ɼ�)
			
		bidInfo.put("bid_num", "M43400001");  // ������ȣ
		bidInfo.put("state", "1");  // ���������Ȳ(1:�ű�, 2:����, 3:������, 4:����, 5:����, 6:���, 7:�������, 8:����:�������, 9:������(������ȿ)
		bidInfo.put("area", "�õ��ڵ�");  // �õ��ڵ�
		bidInfo.put("title", "��������");  // ��������
		bidInfo.put("url", "http://www.niceaptbid.com/web/apt/bid/kapt_view.jsp?q=");  // http �ּ�
		bidInfo.put("deadline", "2016-03-31 10:00:00");  // ����������(����Ÿ���� YYYY-MM-DD HH24:MI:SS)
		bidInfo.put("reg_date", "2016-03-20 10:25:10");  // �����Ͻ�(����Ÿ���� YYYY-MM-DD HH24:MI:SS)
		bidInfo.put("code_classify_type_1", "01");  // ���� ���� Ÿ�� ��з�(01:���ð�������, 02:�����)
		bidInfo.put("code_classify_type_2", "01");  // ���� ���� Ÿ�� �ߺз�(01:����������Ź����,	02:����,03:�뿪, 04:��ǰ, 05:��Ÿ)
		bidInfo.put("code_classify_type_3", "");  // ���� ���� Ÿ�� �Һз�
		/*
		01:���ں��� / code_classify_type_2="02"�϶�
		02:������ / code_classify_type_2="02"�϶�
		03:�Ϲݺ��� / code_classify_type_2="02"�϶�
		04:��� / code_classify_type_2="03"�϶�
		05:û�� / code_classify_type_2="03"�϶�
		06:�°������� / code_classify_type_2="03"�϶�
		07:������Ȩ��Ʈ��ũ / code_classify_type_2="03"�϶�
		08:����������� / code_classify_type_2="03"�϶�
		09:��ȭ��û��, ���� / code_classify_type_2="03"�϶�
		10:������ û�� / code_classify_type_2="03"�϶�
		11:���๰ �������� / code_classify_type_2="03"�϶�
		12:��Ÿ �뿪 / code_classify_type_2="03"�϶�
		13:���� / code_classify_type_2="04"�϶�
		14:�Ű� / code_classify_type_2="04"�϶�
		15:����� / code_classify_type_2="05"�϶�
		16:������ / code_classify_type_2="05"�϶�
		13:�ҵ� / code_classify_type_2="05"�϶�
		14:�ֹο�ü��� ��Ź / code_classify_type_2="05"�϶�
		*/
		bidInfo.put("code_way", "01");  // �������(00:��������, 01:��������)
		bidInfo.put("code_kind", "01");  // ��������(01:�Ϲݰ���, 02:���Ѱ���, 03:�������)
		bidInfo.put("code_suc_way", "01");  // �������(01:����(��) ����, 02:���ݽɻ�)
		bidInfo.put("terms_of_payment", "01");  // ���� ����(�ɼ�)
		bidInfo.put("guarantee_yn", "Y");  // ���������������� ����(Y:��, N:��)
		bidInfo.put("credit_conf_yn", "Y");  // �ſ��� ���Ȯ�μ� ���⿩��(Y : ����, N:������)
		bidInfo.put("mng_cert_yn", "Y");  // ����(����뿪) �������� ���� ����(Y : ����, N:������)
		bidInfo.put("cert_open_yn", "Y");  // ������ ���� ����(Y:����, N:�̰���)
		bidInfo.put("emrg_yn", "N");  // �����������(Y:���, N:�Ϲ�)
		bidInfo.put("contract_date", "2016-04-08");  // ���ü�ᳯ¥(����Ÿ���� YYYY-MM-DD) (�ɼ�)
		bidInfo.put("contract_regdt", "2016-03-22 10:25:10");  // ���ü������(����Ÿ���� YYYY-MM-DD HH24:MI:SS) (�ɼ�)
		bidInfo.put("field_des_loc", "����Ʈ �����繫��");  // ���弳����� (�ɼ�)
		bidInfo.put("field_des_date", "2016-03-25 10:25:10");  // ���弳�� �Ͻ�(����Ÿ���� YYYY-MM-DD HH24:MI:SS) (�ɼ�)
		bidInfo.put("field_des_ess", "N");  // ���弳��ȸ�����ʼ�����(P:�ʼ�, Y:����, N:����)
		bidInfo.put("req_docs", "���񼭷�");  // ���񼭷��� (�ɼ�)
		bidInfo.put("docs_deadline", "2016-03-26 10:00:10");  // �������⸶����(����Ÿ���� YYYY-MM-DD HH24:MI:SS) (�ɼ�)
		bidInfo.put("org_num", "2016-03-26 10:00:10");  // ������ ORG ���� ��ȣ (����, ������� �� �ʼ�)
		
		// ����, ����, ���, ������ȿ��
		bidInfo.put("reason", "����,����,��� ����");  // ����,����,��� ���� (�ʼ�)
		bidInfo.put("com_name", "��ü ��");  // ��ü �� (����, ��ҽ� �ʼ�)
		bidInfo.put("com_owner", "��ǥ�� ��");  // ��ǥ�� �� (�ɼ�)
		bidInfo.put("com_addr", "�ּ�");  // �ּ� (�ɼ�)
		bidInfo.put("com_tel", "����ó");  // ����ó (�ɼ�)
		bidInfo.put("con_period_sdate", "2016-04-08");  // ��� ������(����Ÿ���� YYYY-MM-DD) (�ɼ�)
		bidInfo.put("con_period_edate", "2017-04-07");  // ��� ������(����Ÿ���� YYYY-MM-DD) (�ɼ�)
		bidInfo.put("con_prog_period_sdate", "2016-04-08");  // ��� ü��Ⱓ ������(����Ÿ���� YYYY-MM-DD) (�ɼ�)
		bidInfo.put("con_prog_period_edate", "2016-04-08");  // ��� ü��Ⱓ ������(����Ÿ���� YYYY-MM-DD) (�ɼ�)
		bidInfo.put("con_amount", "10000000");  // ��� �ݾ� (����, ��ҽ� �ʼ�)
		bidInfo.put("con_type", "01");  // ���� ���(01:��������, 02:���ǰ��) (����, ��ҽ� �ʼ�)
		bidInfo.put("etc", "��Ÿ ����");  // ���� (�ɼ�)
		
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
		
		// 1. Document ����
		Document doc = new Document();
		Element apt_info = new Element("apt_info");
		Element bid_info = new Element("bidding_info");
		
		Iterator<String> it = aptInfo.keySet().iterator();
		Iterator<String> it2 = bidInfo.keySet().iterator();
		
		// 2. Root Element ����
		Element root = new Element("g2b");
		doc.setContent(root);
		 
		// 3. Child Element ����
		switch(state) {
		case 1: // �ű�
		case 2: // ����
		case 3: // �����
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
		
			
		case 4: // ����
		case 5: // ����
		case 6: // ���
		case 9: // ������ȿ
			root.setAttribute("cmd", "result");
			root.setAttribute("key", key);
			
			while(it2.hasNext()) {
				String key = (String)it2.next();
				bid_info.setAttribute(key, bidInfo.get(key));
			}

			root.addContent(bid_info);
			break;			
			
		case 7: // �������
			
			break;
			
		case 8: // ����:�������(������)
			
			break;
			
			
		} 

		String retXml = new XMLOutputter(Format.getPrettyFormat().setEncoding("UTF-8")).outputString(doc);
		System.out.println(retXml);
		         
		return retXml;
		
	}
	
	 
}
