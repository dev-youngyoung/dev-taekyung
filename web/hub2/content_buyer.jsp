<%@ page contentType="text/html; charset=EUC-KR" %>
<script>
function changContent(gubun){
	$(".sub-block").hide();
	$(".service1 > li").removeClass('active');
	if(gubun == "bid"){
		$(".content_bid").show();
		$(".service1 > li:eq(0)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}else if(gubun == "cont"){
		$(".content_cont").show();
		$(".service1 > li:eq(1)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}else if(gubun == "work"){
		$(".content_work").show();
		$(".service1 > li:eq(2)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}
}
</script>
<div class="sub-title-block">
	<div class="center-inner">
		<h1>
			나이스다큐 일반기업용
		</h1>
		<p>최고의 만족도 최상의 서비스를 경험하세요</p>
	</div>
</div>
<div class="sub-link-block">
	<div class="inner-container">
		<ul class="service1">
			<li class="active">
				<a href="javascript:changContent('bid');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_1_1.gif" alt="아이콘">
						</div>
						<div class="txt-area">
							<p class="tit">전자입찰</p>
							<div class="link">
								<p>
									<span>자세히 보기</span>
									<i class="fas fa-angle-right"></i>
								</p>
							</div>
						</div>
					</div>
					<div class="link-bg"></div>
				</a>
			</li>
			<li>
				<a href="javascript:changContent('cont');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_1_2.gif" alt="아이콘">
						</div>
						<div class="txt-area">
							<p class="tit">전자계약</p>
							<div class="link">
								<p>
									<span>자세히 보기</span>
									<i class="fas fa-angle-right"></i>
								</p>
							</div>
						</div>
					</div>
					<div class="link-bg"></div>
				</a>
			</li>
			<li>
				<a href="javascript:changContent('work');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_1_3.gif" alt="아이콘">
						</div>
						<div class="txt-area">
							<p class="tit">전자근로계약</p>
							<div class="link">
								<p>
									<span>자세히 보기</span>
									<i class="fas fa-angle-right"></i>
								</p>
							</div>
						</div>
					</div>
					<div class="link-bg"></div>
				</a>
			</li>
		</ul>
	</div>
</div>


<div class="sub_gubun" style="hight:1px;width: 100%"></div>

<div class="sub-block content_bid">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">전자입찰 서비스 소개</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart1.png" alt="전자입찰 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart1.png" alt="전자입찰 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_01.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">견적/입찰 프로세스의 <br class="mobile">표준화/자동화 지원</p>
							<p class="txt">
								구매 품목에 대해 가장 적합한 공급사를 <br class="mobile">발굴하여 평가하고, <br class="pc">
								적정한 원가를 분석하고 <br class="mobile">산정해 최적의 가격을 추정하는 등 <br class="pc">
								구매프로세스 <br class="mobile">전반의 업무 정형화, 표준화, 자동화, <br class="mobile">Paperless화를 지원합니다. 
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_02.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">직ㆍ간접구매에 대한 다양한 <br class="mobile">입찰방법/낙찰자선정방법 지원 </p>
							<p class="txt">
								기업별로 고유한 구매 프로세스가 <br class="mobile">존재하는 상황에서 <br class="pc">
								표준 구매 프로세스를 <br class="mobile">정의하여 모든 기업에 적용 가능한 공통 <br class="mobile">기능을 기본으로 제공하며,<br class="pc"> 기업별 고유 기능은 <br class="mobile">별도 추가 개발을 통해 지원을 합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_03.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">국가ㆍ지방계약법 <br class="mobile">구매업무 처리 규정 지원</p>
							<p class="txt">
								‘국가를 당사자로 하는 계약에 관한 법률’, <br class="mobile">‘지방자치단체를 당사자로 하는
								계약에 관한 법률’에  <br>근거하여 진행되는 복수예가, 적격심사 등
								<br class="pc mobile">각종 구매 프로세스를 지원합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_04.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">협력사 리스크 사전예측 지원</p>
							<p class="txt">
								신용평가정보를 연계하여 협력업체 <br class="mobile">리스크 관리를 위한 각종 정보를 제공합니다.<br>
								부정당업자 제재처분정보, 행정처분정보 <br class="mobile">연계를 통해 견적/입찰 참여업체의 <br>
								잠재적 위험을 사전에 파악하여 공급 <br class="mobile">안정성 확보를 지원합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_05.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">신규 업체 소싱을 위한 <br class="mobile">Vendor Pool 제공</p>
							<p class="txt">
								다양한 구매 품목 유형에 따라 실제 거래 가능한 <br>
								검증된 나이스다큐 Vendor Pool을 제공합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_06.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">수작업 업무 처리의 자동화 지원</p>
							<ul class="list">
								<li>
									이메일을 통한 업무 처리에서 시스템을 이용한 업무 처리
									<ul>
										<li>견적요청, 설명회공고, 입찰공고 안내</li>
									</ul>
								</li>
								<li>
									협력사 담당자에게 실시간으로 업무 요청 안내
									<ul>
										<li>업무 단계별 SMS, e-mail, 카카오톡 발송</li>
									</ul>
								</li>
								<li>투찰업체의 입찰서를 기반으로 입찰대비표 자동생성</li>
								<li>구매담당자 및 협력사들은 온라인상에서 트랜잭션 정보들을 언제든지 조회</li>
							</ul>
						</div>
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>


<div class="sub-block content_cont" style="display:none">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">전자계약 서비스 소개</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart2.png" alt="전자계약 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart2.png" alt="전자계약 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_07.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">PC 및 모바일 상에서 계약 체결</p>
							<p class="txt">
								기업과 기업, 기업과 개인 간 계약에 대해 언제 어디서든 PC와 휴대폰을 통해 <br class="pc">
								회원가입 절차 없이 계약서를 확인하고 바로 계약을 체결할 수 있습니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_08.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">표준화된 계약양식</p>
							<p class="txt">
								시스템에 접속하여 계약서를 작성하여 전자계약을 체결합니다.
							</p>
							<p class="tit">비표준화된 계약양식</p>
							<p class="txt">
								담당자 PC에서 작성된 계약파일(PDF)을 시스템에 업로드하여 전자계약을 체결합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_09.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">양식별 결재라인 관리</p>
							<p class="txt">
								계약 양식별 유연한 결재(승인)라인 기능을 적용하여 전자계약 체결이 가능합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_10.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">계약 구비서류 전자화 관리</p>
							<p class="txt">
								계약체결 시 받는 보증보험증권, 구비서류 등 각종 계약서류에 대해 전자화가 가능합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_11.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">사용자별 로그인 ID 부여</p>
							<p class="txt">
								사용통제, 접속 이력 및 작업에 대한 로그 관리가 가능합니다.
							</p>
							<p class="tit">ID별로 서로 다른 권한을 지정</p>
							<p class="txt">
								사용자 ID별 계약서 열람범위 및 업무권한을 지정하여 시스템을 사용합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_12.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">계약결과에 대한 현황 및 통계자료</p>
							<p class="txt">계약결과 정보에 대해 월별, 근로자별 등 다양한 현황 및 통계 자료를 제공합니다.</p>
							<p class="tit">내부 업무시스템과 데이터 연동</p>
							<p class="txt">
								ERP 등 내부 업무시스템과의 데이터 연동을 통하여 사용자의 결과정보 수기입력 최소화가 가능합니다.<br>
								내부 업무시스템에서 자동 로그인(SSO) 지원
							</p>
						</div>
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>


<div class="sub-block content_work" style="display:none">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">전자근로계약 서비스 소개</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart3.png" alt="전자근로계약 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart3.png" alt="전자근로계약 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<p class="sub__tit sub__tit--type2">
					<strong>근로자는 회원가입 없이 휴대폰상에서 <br class="mobile">쉽고 빠르게 <br class="pc">3분만에 계약 체결</strong>을 <br class="mobile">할 수 있습니다.
				</p>
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart4.png" alt="전자근로계약 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart4.png" alt="전자근로계약 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog reverse">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_13.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">손쉽게 모바일, PC에서 근로계약 체결</p>
							<p class="txt">
								근로자는 모바일 및 PC에서 휴대폰본인인증으로 <br class="pc">
								쉽고 빠르게 근로계약을 체결합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_14.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">대량 근로계약 일괄생성 및 발송</p>
							<p class="txt">
								엑셀파일을 업로드하여 계약서 일괄생성과 대량발송이 가능합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_15.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">계약 업무담당자의 로그인 ID 부여</p>
							<p class="txt">
								사용통제, 접속 이력 및 작업에 대한 로그 관리가 가능합니다.
							</p>
							<p class="tit">ID별로 서로 다른 권한을 지정</p>
							<p class="txt">
								사용자 ID별 계약서 열람범위 및 업무권한을 지정하여 시스템을 사용합니다.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_16.png" alt="아이콘">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">해촉증명서 및 근로자명부 관리</p>
							<p class="txt">
								전자근로계약 체결 정보를 기반으로 한 해촉증명서 발급 및 근로자명부관리가 가능합니다.
							</p>
							<p class="tit">인사시스템과 데이터 연동</p>
							<p class="txt">
								ERP 등 내부 업무시스템과의 데이터 연동을 통하여 사용자의 결과정보 수기입력 최소화가 가능합니다.<br class="pc">
								내부 업무시스템에서 자동 로그인(SSO) 지원
							</p>
						</div>
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>