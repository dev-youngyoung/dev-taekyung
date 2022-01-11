<%@ page contentType="text/html; charset=UTF-8" %>
<script>
function changContent(gubun){
	$(".sub-block").hide();
	$(".service2 > li").removeClass('active');
	if(gubun == "bid"){
		$(".content_bid").show();
		$(".service2 > li:eq(0)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}else if(gubun == "cont"){
		$(".content_cont").show();
		$(".service2 > li:eq(1)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}else if(gubun == "proof"){
		$(".content_proof").show();
		$(".service2 > li:eq(2)").addClass('active');
		var scroll_pos = $(document).scrollTop();
		var offset_top = $(".sub_gubun:eq(0)").offset().top;
		var move_pos =   offset_top - scroll_pos;
		$('html, body').animate({scrollTop : move_pos}, 400);
	}else if(gubun == "work"){
		$(".content_work").show();
		$(".service2 > li:eq(3)").addClass('active');
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
			나이스다큐 건설기업용
		</h1>
		<p>상생협력하는 전략구매, 구매 투명성 제고, 구매원가 절감을 실현합니다</p>
	</div>
</div>
<div class="sub-link-block">
	<div class="inner-container">
		<ul class="service2">
			<li class="active">
				<a href="javascript:changContent('bid');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_2_1.gif" alt="아이콘">
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
							<img src="/web/hub2/images/sub/icon_service_link_2_2.gif" alt="아이콘">
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
				<a href="javascript:changContent('proof');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_2_3.gif" alt="아이콘">
						</div>
						<div class="txt-area">
							<p class="tit">전자실적증명/전자문서</p>
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
							<img src="/web/hub2/images/sub/icon_service_link_2_4.gif" alt="아이콘">
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
					<img src="/web/hub2/images/sub/service2_chart1.png" alt="전자근로계약 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service2_m_chart1.png" alt="전자근로계약 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<div class="service-list bg1">
					<p class="tit">전자입찰 주요 기능</p>
					<ul>
						<li>현장별 각 공종에 대해 내역입찰과 총액입찰로 입찰진행</li>
						<li>외주, 자재로 구분하여 재료비/노무비/경비, 단가로 입찰서 제출</li>
						<li>다양한 낙찰자선정방법 제공(최저가, 최고가,…)</li>
						<li>현설공고, 입찰공고 진행시 대상 업체의 공고문 열람 여부 실시간 확인/ 재알림 기능</li>
						<li>입찰공고건에 대해 정정공고, 연기공고, 취소공고 기능</li>
						<li>입찰공고건에 대해 낙찰, 유찰, 재입찰 기능</li>
						<li>업체가 제출되는 입찰서에 대해 암호화 및 전자서명 처리</li>
						<li>입찰 참여업체의 입찰서에 대한 입찰대비표 자동 생성</li>
						<li>개찰자 부재시 개찰자의 휴대폰으로 간편하게 개찰 요청 기능</li>
						<li>입찰 참여대상 업체 지정 화면에서 협력사에 대한 리스크 사전 예측 지원</li>
						<li>낙찰업체 선정 화면에서 입찰참여사에 대한 리스크 사전 예측 지원</li>
					</ul>
				</div>
				<div class="chart-flow">
					<div class="pc">
						<img src="/web/hub2/images/sub/service2_chart2.png" alt="전자근로계약 업무 플로우">
					</div>
					<a href="/web/hub2/images/sub/service2_chart2_pop.jpg" target="_blank" class="mobile">
						<img src="/web/hub2/images/sub/service2_chart2.png" alt="전자근로계약 업무 플로우">
					</a>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="sub-block content_cont" style="display:none">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">전자계약 서비스 소개</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service2_chart3.png" alt="전자계약 업무 플로우">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service2_m_chart3.png" alt="전자계약 업무 플로우">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<div class="service-list bg2">
					<p class="tit">전자계약 주요 기능</p>
					<ul>
						<li>공정위에서 제공하는 표준하도급계약서 외 40여가지 이상의 계약양식 지원</li>
						<li>계약서 작성시 계약과 관련된 계약서류(계약갑지, 일반조건) 자동 생성</li>
						<li>변경계약을 통해 계약정보 변경에 대한 이력 관리</li>
						<li>계약과 관련된 각종 보증보험, 계약 구비서류 전자적으로 관리</li>
						<li>온라인상에서 자동으로 인지세 납부 및 납부확인서 관리 </li>
						<li>계약에 대한 선급금 정보 관리</li>
						<li>하도급대금지급보증서 관리</li>
						<li>현장별/계약건별 보증보험증권 관리</li>
						<li>계약관리대장 관리</li>
					</ul>
				</div>
				<div class="chart-flow">
					<div class="pc">
						<img src="/web/hub2/images/sub/service2_chart4.png" alt="전자근로계약 업무 플로우">
					</div>
					<a href="/web/hub2/images/sub/service2_chart4_pop.jpg" target="_blank" class="mobile">
						<img src="/web/hub2/images/sub/service2_chart4.png" alt="전자근로계약 업무 플로우">
					</a>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="sub-block content_proof" style="display:none">
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<div class="service-list bg3">
					<p class="tit">전자실적증명발급 주요 기능</p>
					<ul>
						<li>공사 계약건에 대해 협회별 실적증명서 온라인 발급 신청 및 발급 관리</li>
						<li>발급 협회 : 대한전문건설협회,  대한설비건설협회, 한국정보통신공사협회,  한국전기공사협회,  한국소방공사협회</li>
					</ul>
					<p class="tit">전자문서 주요 기능</p>
					<ul>
						<li>계약서 외에 원사업자/수급사업자간 발생하는 각종 종이서류에 대해 전자문서화</li>
						<li>
							전자문서 종류
							<ul>
								<li>원사업자작성 : 하도급대금 직접 지급 확인서,  하도급대금 증액/감액 통보서, 공사대금직불동의서</li>
								<li>수급사업자 작성 : 보증이행완료확인(원), 선급금포기각서, 청구서</li>
							</ul>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="sub-block content_work" style="display:none">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">전자근로계약</h1>
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
								쉽고 빠르게 근로계약을 체결 할 수 있습니다.
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