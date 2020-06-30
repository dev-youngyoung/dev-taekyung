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
			���̽���ť �Ϲݱ����
		</h1>
		<p>�ְ��� ������ �ֻ��� ���񽺸� �����ϼ���</p>
	</div>
</div>
<div class="sub-link-block">
	<div class="inner-container">
		<ul class="service1">
			<li class="active">
				<a href="javascript:changContent('bid');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_1_1.gif" alt="������">
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
							<img src="/web/hub2/images/sub/icon_service_link_1_2.gif" alt="������">
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
				<a href="javascript:changContent('work');">
					<div class="link-inner">
						<div class="icon">
							<img src="/web/hub2/images/sub/icon_service_link_1_3.gif" alt="������">
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
					<img src="/web/hub2/images/sub/service1_chart1.png" alt="�������� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart1.png" alt="�������� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_01.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">����/���� ���μ����� <br class="mobile">ǥ��ȭ/�ڵ�ȭ ����</p>
							<p class="txt">
								���� ǰ�� ���� ���� ������ ���޻縦 <br class="mobile">�߱��Ͽ� ���ϰ�, <br class="pc">
								������ ������ �м��ϰ� <br class="mobile">������ ������ ������ �����ϴ� �� <br class="pc">
								�������μ��� <br class="mobile">������ ���� ����ȭ, ǥ��ȭ, �ڵ�ȭ, <br class="mobile">Paperlessȭ�� �����մϴ�. 
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_02.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">�����������ſ� ���� �پ��� <br class="mobile">�������/�����ڼ������ ���� </p>
							<p class="txt">
								������� ������ ���� ���μ����� <br class="mobile">�����ϴ� ��Ȳ���� <br class="pc">
								ǥ�� ���� ���μ����� <br class="mobile">�����Ͽ� ��� ����� ���� ������ ���� <br class="mobile">����� �⺻���� �����ϸ�,<br class="pc"> ����� ���� ����� <br class="mobile">���� �߰� ������ ���� ������ �մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_03.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">������������� <br class="mobile">���ž��� ó�� ���� ����</p>
							<p class="txt">
								�������� ����ڷ� �ϴ� ��࿡ ���� ������, <br class="mobile">��������ġ��ü�� ����ڷ� �ϴ�
								��࿡ ���� ��������  <br>�ٰ��Ͽ� ����Ǵ� ��������, ���ݽɻ� ��
								<br class="pc mobile">���� ���� ���μ����� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_04.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">���»� ����ũ �������� ����</p>
							<p class="txt">
								�ſ��������� �����Ͽ� ���¾�ü <br class="mobile">����ũ ������ ���� ���� ������ �����մϴ�.<br>
								��������� ����ó������, ����ó������ <br class="mobile">���踦 ���� ����/���� ������ü�� <br>
								������ ������ ������ �ľ��Ͽ� ���� <br class="mobile">������ Ȯ���� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_05.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">�ű� ��ü �ҽ��� ���� <br class="mobile">Vendor Pool ����</p>
							<p class="txt">
								�پ��� ���� ǰ�� ������ ���� ���� �ŷ� ������ <br>
								������ ���̽���ť Vendor Pool�� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_06.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">���۾� ���� ó���� �ڵ�ȭ ����</p>
							<ul class="list">
								<li>
									�̸����� ���� ���� ó������ �ý����� �̿��� ���� ó��
									<ul>
										<li>������û, ����ȸ����, �������� �ȳ�</li>
									</ul>
								</li>
								<li>
									���»� ����ڿ��� �ǽð����� ���� ��û �ȳ�
									<ul>
										<li>���� �ܰ躰 SMS, e-mail, īī���� �߼�</li>
									</ul>
								</li>
								<li>������ü�� �������� ������� �������ǥ �ڵ�����</li>
								<li>���Ŵ���� �� ���»���� �¶��λ󿡼� Ʈ����� �������� �������� ��ȸ</li>
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
			<h1 class="sub__tit">���ڰ�� ���� �Ұ�</h1>
			<div class="service-top">
				<div class="chart pc">
					<img src="/web/hub2/images/sub/service1_chart2.png" alt="���ڰ�� ���� �÷ο�">
				</div>
				<div class="chart mobile">
					<img src="/web/hub2/images/sub/service1_m_chart2.png" alt="���ڰ�� ���� �÷ο�">
				</div>
			</div>
		</div>
	</div>
	<div class="sub__section">
		<ul class="service-catalog">
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_07.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">PC �� ����� �󿡼� ��� ü��</p>
							<p class="txt">
								����� ���, ����� ���� �� ��࿡ ���� ���� ��𼭵� PC�� �޴����� ���� <br class="pc">
								ȸ������ ���� ���� ��༭�� Ȯ���ϰ� �ٷ� ����� ü���� �� �ֽ��ϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_08.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">ǥ��ȭ�� �����</p>
							<p class="txt">
								�ý��ۿ� �����Ͽ� ��༭�� �ۼ��Ͽ� ���ڰ���� ü���մϴ�.
							</p>
							<p class="tit">��ǥ��ȭ�� �����</p>
							<p class="txt">
								����� PC���� �ۼ��� �������(PDF)�� �ý��ۿ� ���ε��Ͽ� ���ڰ���� ü���մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_09.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">��ĺ� ������� ����</p>
							<p class="txt">
								��� ��ĺ� ������ ����(����)���� ����� �����Ͽ� ���ڰ�� ü���� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_10.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">��� ���񼭷� ����ȭ ����</p>
							<p class="txt">
								���ü�� �� �޴� ������������, ���񼭷� �� ���� ��༭���� ���� ����ȭ�� �����մϴ�.
							</p>
						</div>
					</div>
				</div>
			</li>
			<li>
				<div class="catalog-area">
					<div class="icon">
						<img src="/web/hub2/images/sub/service_icon/icon_s1_11.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">����ں� �α��� ID �ο�</p>
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
						<img src="/web/hub2/images/sub/service_icon/icon_s1_12.png" alt="������">
					</div>
					<div class="txt-area">
						<div class="center-inner">
							<p class="tit">������� ���� ��Ȳ �� ����ڷ�</p>
							<p class="txt">����� ������ ���� ����, �ٷ��ں� �� �پ��� ��Ȳ �� ��� �ڷḦ �����մϴ�.</p>
							<p class="tit">���� �����ý��۰� ������ ����</p>
							<p class="txt">
								ERP �� ���� �����ý��۰��� ������ ������ ���Ͽ� ������� ������� �����Է� �ּ�ȭ�� �����մϴ�.<br>
								���� �����ý��ۿ��� �ڵ� �α���(SSO) ����
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
			<h1 class="sub__tit">���ڱٷΰ�� ���� �Ұ�</h1>
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
								���� ������ �ٷΰ���� ü���մϴ�.
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