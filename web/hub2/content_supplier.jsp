<%@ page contentType="text/html; charset=EUC-KR" %>
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
			���̽���ť �Ǽ������
		</h1>
		<p>��������ϴ� ��������, ���� ���� ����, ���ſ��� ������ �����մϴ�</p>
	</div>
</div>
<div class="sub-link-block">
	<div class="inner-container">
		<ul class="service2">
			<li class="active">
				<a href="javascript:changContent('bid');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_2_1.gif" alt="������">
						</div>
						<div class="txt-area">
							<p class="tit">��������</p>
							<div class="link">
								<p>
									<span>�ڼ��� ����</span>
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
							<img src="/web/hub2/images/sub/icon_service_link_2_2.gif" alt="������">
						</div>
						<div class="txt-area">
							<p class="tit">���ڰ��</p>
							<div class="link">
								<p>
									<span>�ڼ��� ����</span>
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
							<img src="/web/hub2/images/sub/icon_service_link_2_3.gif" alt="������">
						</div>
						<div class="txt-area">
							<p class="tit">���ڽ�������/���ڹ���</p>
							<div class="link">
								<p>
									<span>�ڼ��� ����</span>
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
							<img src="/web/hub2/images/sub/icon_service_link_2_4.gif" alt="������">
						</div>
						<div class="txt-area">
							<p class="tit">���ڱٷΰ��</p>
							<div class="link">
								<p>
									<span>�ڼ��� ����</span>
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
			<h1 class="sub__tit">�������� ���� �Ұ�</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service2_chart1.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service2_m_chart1.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<div class="service-list bg1">
					<p class="tit">�������� �ֿ� ���</p>
					<ul>
						<li>���庰 �� ������ ���� ���������� �Ѿ������� ��������</li>
						<li>����, ����� �����Ͽ� ����/�빫��/���, �ܰ��� ������ ����</li>
						<li>�پ��� �����ڼ������ ����(������, �ְ�,��)</li>
						<li>��������, �������� ����� ��� ��ü�� ���� ���� ���� �ǽð� Ȯ��/ ��˸� ���</li>
						<li>��������ǿ� ���� ��������, �������, ��Ұ��� ���</li>
						<li>��������ǿ� ���� ����, ����, ������ ���</li>
						<li>��ü�� ����Ǵ� �������� ���� ��ȣȭ �� ���ڼ��� ó��</li>
						<li>���� ������ü�� �������� ���� �������ǥ �ڵ� ����</li>
						<li>������ ����� �������� �޴������� �����ϰ� ���� ��û ���</li>
						<li>���� ������� ��ü ���� ȭ�鿡�� ���»翡 ���� ����ũ ���� ���� ����</li>
						<li>������ü ���� ȭ�鿡�� ���������翡 ���� ����ũ ���� ���� ����</li>
					</ul>
				</div>
				<div class="chart-flow">
					<div class="pc">
						<img src="/web/hub2/images/sub/service2_chart2.png" alt="���ڱٷΰ�� ���� �÷ο�">
					</div>
					<a href="/web/hub2/images/sub/service2_chart2_pop.jpg" target="_blank" class="mobile">
						<img src="/web/hub2/images/sub/service2_chart2.png" alt="���ڱٷΰ�� ���� �÷ο�">
					</a>
				</div>
			</div>
		</div>
	</div>
</div>


<div class="sub-block content_cont" style="display:none">
	<div class="sub__section">
		<div class="inner-container">
			<h1 class="sub__tit">���ڰ�� ���� �Ұ�</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service2_chart3.png" alt="���ڰ�� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service2_m_chart3.png" alt="���ڰ�� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<div class="service-list bg2">
					<p class="tit">���ڰ�� �ֿ� ���</p>
					<ul>
						<li>���������� �����ϴ� ǥ���ϵ��ް�༭ �� 40������ �̻��� ����� ����</li>
						<li>��༭ �ۼ��� ���� ���õ� ��༭��(��఩��, �Ϲ�����) �ڵ� ����</li>
						<li>�������� ���� ������� ���濡 ���� �̷� ����</li>
						<li>���� ���õ� ���� ��������, ��� ���񼭷� ���������� ����</li>
						<li>�¶��λ󿡼� �ڵ����� ������ ���� �� ����Ȯ�μ� ���� </li>
						<li>��࿡ ���� ���ޱ� ���� ����</li>
						<li>�ϵ��޴�����޺����� ����</li>
						<li>���庰/���Ǻ� ������������ ����</li>
						<li>���������� ����</li>
					</ul>
				</div>
				<div class="chart-flow">
					<div class="pc">
						<img src="/web/hub2/images/sub/service2_chart4.png" alt="���ڱٷΰ�� ���� �÷ο�">
					</div>
					<a href="/web/hub2/images/sub/service2_chart4_pop.jpg" target="_blank" class="mobile">
						<img src="/web/hub2/images/sub/service2_chart4.png" alt="���ڱٷΰ�� ���� �÷ο�">
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
					<p class="tit">���ڽ�������߱� �ֿ� ���</p>
					<ul>
						<li>���� ���ǿ� ���� ��ȸ�� �������� �¶��� �߱� ��û �� �߱� ����</li>
						<li>�߱� ��ȸ : ���������Ǽ���ȸ,  ���Ѽ���Ǽ���ȸ, �ѱ�������Ű�����ȸ,  �ѱ����������ȸ,  �ѱ��ҹ������ȸ</li>
					</ul>
					<p class="tit">���ڹ��� �ֿ� ���</p>
					<ul>
						<li>��༭ �ܿ� �������/���޻���ڰ� �߻��ϴ� ���� ���̼����� ���� ���ڹ���ȭ</li>
						<li>
							���ڹ��� ����
							<ul>
								<li>��������ۼ� : �ϵ��޴�� ���� ���� Ȯ�μ�,  �ϵ��޴�� ����/���� �뺸��, ���������ҵ��Ǽ�</li>
								<li>���޻���� �ۼ� : ��������Ϸ�Ȯ��(��), ���ޱ����Ⱒ��, û����</li>
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
			<h1 class="sub__tit">���ڱٷΰ��</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart3.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart3.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section gray">
		<div class="inner-container">
			<div class="service-top">
				<p class="sub__tit sub__tit--type2">
					<strong>�ٷ��ڴ� ȸ������ ���� �޴����󿡼� <br class="mobile">���� ������ <br class="pc">3�и��� ��� ü��</strong>�� <br class="mobile">�� �� �ֽ��ϴ�.
				</p>
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart4.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart4.png" alt="���ڱٷΰ�� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog reverse">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_13.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">�ս��� �����, PC���� �ٷΰ�� ü��</p>
							<p class="txt">
								�ٷ��ڴ� ����� �� PC���� �޴��������������� <br class="pc">
								���� ������ �ٷΰ���� ü�� �� �� �ֽ��ϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_14.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">�뷮 �ٷΰ�� �ϰ����� �� �߼�</p>
							<p class="txt">
								���������� ���ε��Ͽ� ��༭ �ϰ������� �뷮�߼��� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_15.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">��� ����������� �α��� ID �ο�</p>
							<p class="txt">
								�������, ���� �̷� �� �۾��� ���� �α� ������ �����մϴ�.
							</p>
							<p class="tit">ID���� ���� �ٸ� ������ ����</p>
							<p class="txt">
								����� ID�� ��༭ �������� �� ���������� �����Ͽ� �ý����� ����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_16.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">�������� �� �ٷ��ڸ�� ����</p>
							<p class="txt">
								���ڱٷΰ�� ü�� ������ ������� �� �������� �߱� �� �ٷ��ڸ�ΰ����� �����մϴ�.
							</p>
							<p class="tit">�λ�ý��۰� ������ ����</p>
							<p class="txt">
								ERP �� ���� �����ý��۰��� ������ ������ ���Ͽ� ������� ������� �����Է� �ּ�ȭ�� �����մϴ�.<br class="pc">
								���� �����ý��ۿ��� �ڵ� �α���(SSO) ����
							</p>
						</div>
					</div>
				</div>
			</li>
		</ul>
	</div>
</div>