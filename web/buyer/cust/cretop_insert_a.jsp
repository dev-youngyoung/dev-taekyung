<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp"%>
<%
// �⺻����
String w_member_no = auth.getString("_MEMBER_NO");  // �ۼ��� ȸ����ȣ
String w_user_id = auth.getString("_USER_ID"); // �ۼ��ھ��̵�

// ��Ͼ�ü ���� ��ȸ
DataObject daoMember = new DataObject("tcb_member");
DataSet dsWMember = daoMember.find("member_no = '"+w_member_no+"'");
if(!dsWMember.next())
{
	System.out.println("��� ��ü ������ �����ϴ�. ��Ͼ�ü ȸ����ȣ : " + w_member_no);
	return;
}

String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}
DataSet loop = u.grid2dataset(grid);

// �������� �Է¹޴� ��
String vendcd = ""; // ����ڹ�ȣ
String setup_date = ""; // ��������
String worker_num = ""; // �η¼�
String major_cust = ""; // �ֿ�����(������)
String sales_amt = ""; // ����
String biz_profit = ""; // ��������
String net_profit = ""; // ��������
String asset = ""; // �ڻ��Ѱ�
String capital = ""; // �ں��Ѱ�
String debt = ""; // ��ä�Ѱ�
String liquid_asset = ""; // �����ڻ�
String liquid_debt = ""; // ������ä
String credit_rating = ""; // �ſ���
String tax_delay_yn = ""; // ����ü������

// �������� ���Ǵ� ��
String member_no = "";
double biz_profit_rate=0; // �������ͷ�
double debt_rate=0; // ��ä����
double liquid_rate=0; // ��������

DB db = new DB();
while(loop.next()){
	// �ʱ�ȭ
	member_no = "";  //  �ŷ�ó ȸ����ȣ
	vendcd = loop.getString("vendcd").replaceAll("-","");
	setup_date = loop.getString("setup_date").replaceAll("-","");
	worker_num = loop.getString("worker_num");
	major_cust = loop.getString("major_cust");
	sales_amt = loop.getString("sales_amt");
	biz_profit = loop.getString("biz_profit");
	net_profit = loop.getString("net_profit");
	asset = loop.getString("asset");
	capital = loop.getString("capital");
	debt = loop.getString("debt");
	liquid_asset = loop.getString("liquid_asset");
	liquid_debt = loop.getString("liquid_debt");
	credit_rating = loop.getString("credit_rating");
	tax_delay_yn = loop.getString("tax_delay_yn");

	double dsales_amt = 0;
	double dbiz_profit = 0;
	double ddebt = 0;
	double dcapital = 0;
	double dliquid_asset = 0;
	double dliquid_debt = 0;
	if(!sales_amt.equals("")) dsales_amt = Double.parseDouble(sales_amt); // ����
	if(!biz_profit.equals("")) dbiz_profit = Double.parseDouble(biz_profit); // ��������
	if(!debt.equals("")) ddebt = Double.parseDouble(debt);  // ��ä
	if(!capital.equals("")) dcapital = Double.parseDouble(capital); // �ں�
	if(!liquid_asset.equals("")) dliquid_asset = Double.parseDouble(liquid_asset); // �����ڻ�
	if(!liquid_debt.equals("")) dliquid_debt = Double.parseDouble(liquid_debt); // ������ä

	if(dbiz_profit>0 && dsales_amt>0) biz_profit_rate = dbiz_profit / dsales_amt * 100;  // �������ͷ�(%) = ��������/����*100
	if(ddebt>0 && dcapital>0) debt_rate = ddebt / dcapital * 100; // ��ä���� = ��ä/�ں�*100
	if(dliquid_asset>0 && dliquid_debt>0) liquid_rate = dliquid_asset / dliquid_debt * 100;  // �������� = �����ڻ�/������ä��100

	// 1. ȸ������ üũ
	DataSet dsRMember = daoMember.find("vendcd = '"+vendcd+"'");
	if(dsRMember.next()) // ȸ��
	{
		member_no = dsRMember.getString("member_no");
	}
	else
	{
		// �̰���ȸ�� �α� ���
		Util.log(loop.getString("vendcd") + "\tȸ�� ������ �������� �ʽ��ϴ�");
		continue;
	}

	// ȸ���ΰ�����
	DataObject memberAddDao = new DataObject("tcb_member_add");
	memberAddDao.item("setup_date", setup_date);
	memberAddDao.item("worker_num", worker_num);
	//memberAddDao.item("major_cust", major_cust);
	memberAddDao.item("sales_amt", sales_amt);
	memberAddDao.item("biz_profit", biz_profit);
	memberAddDao.item("net_profit", net_profit);
	memberAddDao.item("asset", asset);
	memberAddDao.item("capital", capital);
	memberAddDao.item("debt", debt);
	memberAddDao.item("liquid_asset", liquid_asset);
	memberAddDao.item("liquid_debt", liquid_debt);
	memberAddDao.item("credit_rating", credit_rating);
	memberAddDao.item("tax_delay_yn", tax_delay_yn);
	memberAddDao.item("biz_profit_rate", biz_profit_rate);
	memberAddDao.item("debt_rate", debt_rate);
	memberAddDao.item("liquid_rate", liquid_rate);
	db.setCommand(memberAddDao.getUpdateQuery("member_no='"+member_no+"'"), memberAddDao.record);
}

if(!db.executeArray()){
	u.jsError("���� ó���� ���� �Ͽ����ϴ�.");
	return;
}

u.jsAlertReplace("ó�� �Ͽ����ϴ�.", "cretop_insert.jsp");
%>

