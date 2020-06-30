package procure.common.utils;

public class PageDivide {
	
	/**
	*	��� �Ҵ� ����
	*	0 : ����,������,���� 
	*	1 : ó��,����,������,����,������
	*/
	private int i_navy_mode = 1; 

	/**
	*	��ü ������ ����
	*/
	private int i_total_page = 0;

	/**
	*	�̹��� ��ư ���
	*/
	private String str_btn_Path = "";
	/**
	*	������ư ��� ����
	*/
	private String btn_Prev = str_btn_Path + "/images/board_b_before.gif";
	/**
	*	������ư ��� ����
	*/
	private String btn_Next = str_btn_Path + "/images/board_b_next.gif";
	/**
	*	ó����ư ��� ����
	*/
	private String btn_First = str_btn_Path + "/images/board_b_first.gif";
	/**
	*	��������ư ��� ����
	*/
	private String btn_Last = str_btn_Path + "/images/board_b_last.gif";


	/**
	*��� :		i_navy_mode, btn_Prev, btn_Next, btn_First, btn_Last ���� ���� default�� ����
	*/
	public PageDivide() {}

	/**
	*��� :		i_navy_mode  ���� �� ����
	*			btn_Prev, btn_Next, btn_First, btn_Last ���� ���� default�� ����
	*@param   i_navy_mode		��� ����
	*/
	public PageDivide(int i_navy_mode) throws Exception {
		if(i_navy_mode < 0) throw new Exception();
		this.i_navy_mode = i_navy_mode;
	}

	/**
	*��� :		btn_Prev, btn_Next  ���� �� ����
	*			i_navy_mode, btn_First, btn_Last ���� ���� default�� ����
	*@param   btn_Prev		���������� ��ư �̹���
	*@param   btn_Next		���������� ��ư �̹���
	*/
	public PageDivide(String btn_Prev, String btn_Next) throws Exception {
		if(btn_Prev == null || "".equals(btn_Prev) || btn_Next == null || "".equals(btn_Next)) throw new Exception();
		this.btn_Prev = btn_Prev;
		this.btn_Next = btn_Next;
	}

	/**
	*��� :		i_navy_mode, btn_Prev, btn_Next  ���� �� ����
	*			btn_First, btn_Last ���� ���� default�� ����
	*@param   i_navy_mode		��� ����
	*@param   btn_Prev		���������� ��ư �̹���
	*@param   btn_Next		���������� ��ư �̹���
	*/
	public PageDivide(int i_navy_mode, String btn_Prev, String btn_Next) throws Exception {
		if(i_navy_mode < 0 || btn_Prev == null || "".equals(btn_Prev) || btn_Prev == null || "".equals(btn_Prev)) throw new Exception();
		this.i_navy_mode = i_navy_mode;
		this.btn_Prev = btn_Prev;
		this.btn_Next = btn_Next;
	}

	/**
	*��� :		btn_Prev, btn_Next, btn_First, btn_Last  ���� �� ����
	*			i_navy_mode ���� ���� default�� ����
	*@param   btn_Prev		���������� ��ư �̹���
	*@param   btn_Next		���������� ��ư �̹���
	*@param   btn_First		ó�������� ��ư �̹���
	*@param   btn_Last		������������ ��ư �̹���
	*/
	public PageDivide(String btn_Prev, String btn_Next, String btn_First, String btn_Last) throws Exception {
		if(btn_Prev == null || "".equals(btn_Prev) || btn_Next == null || "".equals(btn_Next) || btn_First == null || "".equals(btn_First) || btn_Last == null || "".equals(btn_Last)) throw new Exception();
		this.i_navy_mode = 1;
		this.btn_Prev    = btn_Prev;
		this.btn_Next    = btn_Next;
		this.btn_First   = btn_First;
		this.btn_Last    = btn_Last;
	}

	/**
	*��� :		i_navy_mode, btn_Prev, btn_Next, btn_First, btn_Last  ���� �� ����
	*@param   i_navy_mode		��� ����
	*@param   btn_Prev		���������� ��ư �̹���
	*@param   btn_Next		���������� ��ư �̹���
	*@param   btn_First		ó�������� ��ư �̹���
	*@param   btn_Last		������������ ��ư �̹���
	*/
	public PageDivide(int i_navy_mode, String btn_Prev, String btn_Next, String btn_First, String btn_Last) throws Exception {
		if(i_navy_mode < 1 || btn_Prev == null || "".equals(btn_Prev) || btn_Next == null || "".equals(btn_Next) || btn_First == null || "".equals(btn_First) || btn_Last == null || "".equals(btn_Last)) throw new Exception();
		this.i_navy_mode = i_navy_mode;
		this.btn_Prev    = btn_Prev;
		this.btn_Next    = btn_Next;
		this.btn_First   = btn_First;
		this.btn_Last    = btn_Last;
	}

	/**
	*��� :   list ȭ���� ������ ������ �Լ�
	*@param   i_total_row_cnt	��ü �˻��� ����Ÿ ����
	*@param   i_bbs_row_cnt		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_page_num		���� ��������ȣ
	*@return  String			������ �׺���̼�
	*/
	public String getPageDivide(int i_total_row_cnt, int i_bbs_row_cnt, int i_page_num) throws Exception {
		if(i_total_row_cnt < 0 || i_bbs_row_cnt < 0 || i_page_num < 0) return "&nbsp;";

		int i_page_navi = 10;				// navigation ����

		return makePageDivide(i_total_row_cnt, i_bbs_row_cnt, i_page_num, i_page_navi);
	}
	
	/**
	*��� :   list ȭ���� ������ ������ �Լ�
	*@param   i_total_row_cnt	��ü �˻��� ����Ÿ ����
	*@param   i_bbs_row_cnt		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_page_num		���� ��������ȣ
	*@param   i_page_navi		�������� Ŭ���ϴ°��� ��Ÿ���� ���ڵ��� ����(�׺���̼�(?))
	*@return  String			������ �׺���̼�
	*/
	public String getPageDivide(int i_total_row_cnt, int i_bbs_row_cnt, int i_page_num, int i_page_navi) throws Exception {
		if(i_total_row_cnt < 0 || i_bbs_row_cnt < 0 || i_page_num < 0 || i_page_navi < 0) return "&nbsp;";
		return makePageDivide(i_total_row_cnt, i_bbs_row_cnt, i_page_num, i_page_navi);
	}

	/**
	*��� :   ������ Navigation �� ����� �ִ� �Լ�
	*@param   i_total_row_cnt	��ü �˻��� ����Ÿ ����
	*@param   i_bbs_row_cnt		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_page_num		���� ��������ȣ
	*@param   i_page_navi		�������� Ŭ���ϴ°��� ��Ÿ���� ���ڵ��� ����(�׺���̼�(?))
	*@return  String			������ �׺���̼�
	*/
	private String makePageDivide(int i_total_row_cnt, int i_bbs_row_cnt, int i_page_num, int i_page_navi) {

		StringBuffer sb_PageDivide = new StringBuffer();
		String str_PageDivide = "";
	
		i_total_page = i_total_row_cnt % i_bbs_row_cnt == 0 ? 
			i_total_row_cnt/i_bbs_row_cnt : i_total_row_cnt/i_bbs_row_cnt + 1;

		boolean is_next_flag = true;
		
		int i_pre_next_cnt = 0;

		int i_loop = ( ( i_page_num-1 ) / i_page_navi ) * i_page_navi;
		if( i_loop == 0 ) i_loop = 1;

		int i = 0;
		for( i=i_loop; i<=i_loop+i_page_navi; i++) {
			if ( i_pre_next_cnt <= 1 && i%10==0 ) {
				sb_PageDivide.append("&nbsp; <img src=\"" + btn_Prev + "\" border=\"0\" style=\"cursor:hand\" onclick=\"javascript:on_next(" + i + ", 0);\" align=\"absmiddle\">");
			} else if ( i_pre_next_cnt > 9 && i%10==1 ) {
				sb_PageDivide.append("&nbsp; <img src=\"" + btn_Next + "\" border=\"0\" style=\"cursor:hand\" onclick=\"javascript:on_next(" + i + ", 1);\" align=\"absmiddle\">");
			} else {
				if ( i_page_num == i )
					sb_PageDivide.append("&nbsp; <font color='#FF0000'>" + i + "</font>");
				else
					sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(" + i + ", 0);\">" + i + "</a>");
		        if ( i == i_total_page || i_total_page == 0 ) {
		            is_next_flag = false;
		            break;
		        }
			}
			i_pre_next_cnt++;
    	}
    	if ( i_loop != 1 && is_next_flag) {
    		sb_PageDivide.append("&nbsp; <img src=\"" + btn_Next + "\" border=\"0\" style=\"cursor:hand\" onclick=\"javascript:on_next(" + i + ", 1);\" align=\"absmiddle\">");
    	}

		switch (i_navy_mode) {
			case 1:
				str_PageDivide = attachFirstLast(sb_PageDivide.toString(), i_loop, i_page_navi, i_total_page);
				break;
			default :
				str_PageDivide = sb_PageDivide.toString();
				break;
		}
		str_PageDivide = "<table width='100%' height='50' border='0' cellspacing='0' cellpadding='0'><tr><td align='center' valign='middle'>" + str_PageDivide + "</td></tr></table>";
		
		return str_PageDivide;
	}

	/**
	*��� :   ������ Navigation �� ����� �ִ� �Լ�
	*@param   i_total_row_cnt	��ü �˻��� ����Ÿ ����
	*@param   i_bbs_row_cnt		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_page_num		���� ��������ȣ
	*@param   i_page_navi		�������� Ŭ���ϴ°��� ��Ÿ���� ���ڵ��� ����(�׺���̼�(?))
	*@return  String			������ �׺���̼�
	*/
	public String makeEngPageDivide(int i_total_row_cnt, int i_bbs_row_cnt, int i_page_num, int i_page_navi) {
		StringBuffer sb_PageDivide = new StringBuffer();
		String str_PageDivide = "";
		
		btn_Prev = "[prev]";
		btn_Next = "[next]";

		i_total_page = i_total_row_cnt % i_bbs_row_cnt == 0 ? 
			i_total_row_cnt/i_bbs_row_cnt : i_total_row_cnt/i_bbs_row_cnt + 1;

		boolean is_next_flag = true;
		
		int i_pre_next_cnt = 0;

		int i_loop = ( ( i_page_num-1 ) / i_page_navi ) * i_page_navi;
		if( i_loop == 0 ) i_loop = 1;

		int i = 0;
		for( i=i_loop; i<=i_loop+i_page_navi; i++) {
			if ( i_pre_next_cnt <= 1 && i%10==0 ) {
				sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(" + i + ", 0);\">"+btn_Prev+"</a>");
			} else if ( i_pre_next_cnt > 9 && i%10==1 ) {
				sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(" + i + ", 1);\">"+btn_Next+"</a>");
			} else {
				if ( i_page_num == i )
					sb_PageDivide.append("&nbsp; <font color='#1BA4AC'><b>" + i + "</b></font>");
				else
					sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(" + i + ", 0);\">" + i + "</a>");
		        if ( i == i_total_page || i_total_page == 0 ) {
		            is_next_flag = false;
		            break;
		        }
			}
			i_pre_next_cnt++;
    	}
    	if ( i_loop != 1 && is_next_flag) {
    		sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(" + i + ", 1);\">"+btn_Next+"</a>");
    	}

		switch (i_navy_mode) {
			case 1:
				str_PageDivide = attachEngFirstLast(sb_PageDivide.toString(), i_loop, i_page_navi, i_total_page);
				break;
			default :
				str_PageDivide = sb_PageDivide.toString();
				break;
		}
		str_PageDivide = "<table width='100%' height='50' border='0' cellspacing='0' cellpadding='0'><tr><td align='center' valign='middle' class=\"board_font\">" + str_PageDivide + "</td></tr></table>";
		
		return str_PageDivide;
	}

	/**
	*��� :   Navigation�� ó��, ������ ����� �ٿ� �ִ� �Լ�
	*@param   str_PageDivide	������ �׺���̼�
	*@param   i_loop			�� ȭ�鿡�� ���۵Ǵ� ������ ��ȣ
	*@param   i_page_navi		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_total_page		�� ������
	*@return  String			������ �׺���̼�
	*/
	private String attachFirstLast(String str_PageDivide, int i_loop, int i_page_navi, int i_total_page) {
		StringBuffer sb_PageDivide = new StringBuffer();
	
		if((i_loop+1 > i_page_navi) && i_loop > 1) {
			sb_PageDivide.append("&nbsp; <img src=\"" + btn_First + "\" border=\"0\" style=\"cursor:hand\" onclick=\"javascript:on_next(1, -1);\" align=\"absmiddle\">");
		}
		sb_PageDivide.append(str_PageDivide);
    	if ( i_loop + i_page_navi < i_total_page) {
    		sb_PageDivide.append("&nbsp; <img src=\"" + btn_Last + "\" border=\"0\" style=\"cursor:hand\" onclick=\"javascript:on_next(" + i_total_page + ", 1);\" align=\"absmiddle\">");
    	}
		return sb_PageDivide.toString();
	}

	/**
	*��� :   Navigation�� ó��, ������ ����� �ٿ� �ִ� �Լ�
	*@param   str_PageDivide	������ �׺���̼�
	*@param   i_loop			�� ȭ�鿡�� ���۵Ǵ� ������ ��ȣ
	*@param   i_page_navi		�� ȭ�鿡 ��Ÿ���� �ڷ��� ����
	*@param   i_total_page		�� ������
	*@return  String			������ �׺���̼�
	*/
	private String attachEngFirstLast(String str_PageDivide, int i_loop, int i_page_navi, int i_total_page) {
		StringBuffer sb_PageDivide = new StringBuffer();
		
		btn_First = "[start]";
		btn_Last  = "[end]";

		if((i_loop+1 > i_page_navi) && i_loop > 1) {
			sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next(1,0);\">"+btn_First+"</a>");
		}
		sb_PageDivide.append(str_PageDivide);
    	if ( i_loop + i_page_navi < i_total_page) {
    		sb_PageDivide.append("&nbsp; <a href=\"javascript:on_next("+i_total_page+",0);\">"+btn_Last+"</a>");
    	}
		return sb_PageDivide.toString();
	}
}
