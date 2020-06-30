<%@page import="java.net.URLDecoder"%>
<%@ page contentType="text/html; charset=EUC-KR" %><%@ include file="init.jsp"%>
<%
// 기본정보
String w_member_no = auth.getString("_MEMBER_NO");  // 작성자 회원번호
String w_user_id = auth.getString("_USER_ID"); // 작성자아이디

// 등록업체 정보 조회
DataObject daoMember = new DataObject("tcb_member");
DataSet dsWMember = daoMember.find("member_no = '"+w_member_no+"'");
if(!dsWMember.next())
{
	System.out.println("등록 업체 정보가 없습니다. 등록업체 회원번호 : " + w_member_no);
	return;
}

String grid = u.request("grid");
if(!grid.equals("")){
	grid = URLDecoder.decode(grid,"UTF-8");
}
DataSet loop = u.grid2dataset(grid);

// 엑셀에서 입력받는 값
String vendcd = ""; // 사업자번호
String setup_date = ""; // 설립일자
String worker_num = ""; // 인력수
String major_cust = ""; // 주요주주(지분율)
String sales_amt = ""; // 매출
String biz_profit = ""; // 영억이익
String net_profit = ""; // 당기순이익
String asset = ""; // 자산총계
String capital = ""; // 자본총계
String debt = ""; // 부채총계
String liquid_asset = ""; // 유동자산
String liquid_debt = ""; // 유동부채
String credit_rating = ""; // 신용등급
String tax_delay_yn = ""; // 세금체납여부

// 수식으로 계산되는 것
String member_no = "";
double biz_profit_rate=0; // 영업이익률
double debt_rate=0; // 부채비율
double liquid_rate=0; // 유동비율

DB db = new DB();
while(loop.next()){
	// 초기화
	member_no = "";  //  거래처 회원번호
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
	if(!sales_amt.equals("")) dsales_amt = Double.parseDouble(sales_amt); // 매출
	if(!biz_profit.equals("")) dbiz_profit = Double.parseDouble(biz_profit); // 영업이익
	if(!debt.equals("")) ddebt = Double.parseDouble(debt);  // 부채
	if(!capital.equals("")) dcapital = Double.parseDouble(capital); // 자본
	if(!liquid_asset.equals("")) dliquid_asset = Double.parseDouble(liquid_asset); // 유동자산
	if(!liquid_debt.equals("")) dliquid_debt = Double.parseDouble(liquid_debt); // 유동부채

	if(dbiz_profit>0 && dsales_amt>0) biz_profit_rate = dbiz_profit / dsales_amt * 100;  // 영업이익률(%) = 영업이익/매출*100
	if(ddebt>0 && dcapital>0) debt_rate = ddebt / dcapital * 100; // 부채비율 = 부채/자본*100
	if(dliquid_asset>0 && dliquid_debt>0) liquid_rate = dliquid_asset / dliquid_debt * 100;  // 유동비율 = 유동자산/유동부채×100

	// 1. 회원인지 체크
	DataSet dsRMember = daoMember.find("vendcd = '"+vendcd+"'");
	if(dsRMember.next()) // 회원
	{
		member_no = dsRMember.getString("member_no");
	}
	else
	{
		// 미가입회원 로그 출력
		Util.log(loop.getString("vendcd") + "\t회사 정보가 존재하지 않습니다");
		continue;
	}

	// 회원부가정보
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
	u.jsError("저장 처리에 실패 하였습니다.");
	return;
}

u.jsAlertReplace("처리 하였습니다.", "cretop_insert.jsp");
%>

