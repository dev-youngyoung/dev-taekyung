function setProperty(GridObj)
{
	//GridObj.strHDFontName = "�������";
	//GridObj.strCellFontName = "�������";
	// Cell Font Setting
	GridObj.nCellFontSize = 9;

	// Header Font Setting
	GridObj.nHDFontSize = 9;
	GridObj.bHDFontBold = false;

	// Header ���߿� ���� ����
	GridObj.bMultiRowMenuVisible = true;

	// Header Color
	GridObj.strHDBgColor="244|244|244";	//	�׸��� ����� ������ 
	GridObj.strHDFgColor="0|113|167";		//	�׸�������� ���ڻ��� 


	// Cell Color
	GridObj.strGridBgColor="255|255|255";	//�׸����� ������
	GridObj.strCellBgColor="255|255|255";	//�׸��弿�� ������

	GridObj.strCellFgColor="0|0|0";			//�׸��弿�� ���ڻ����� ������ �� �ִ�.

	// Row Color
	//GridObj.strAlternateRowsBgColor="228|246|250";

	// Border Style
	GridObj.strGridBorderColor = "189|209|223";
	GridObj.strGridBorderStyle = "solidline";
	GridObj.strHDBorderStyle = "solidline";
	GridObj.strCellBorderStyle = "solidline";

	// ETC Color
	GridObj.strActiveRowBgColor="214|228|236";
	GridObj.strSelectedCellBgColor = "241|231|221";
	GridObj.strSelectedCellFgColor = "51|51|51";
	GridObj.strStatusbarBgColor = "243|243|243";
	GridObj.strStatusbarFgColor = "101|101|101";
	GridObj.strProgressbarColor = "0|126|174"; 

	// ETC
	// Grid RowSelector ��뿩��
	GridObj.bRowSelectorVisible = true;
	
	// Header ��ġ�̵� ��ų �� �ִ� �޺���ư Ȱ��ȭ ����
	GridObj.bHDSwapping = false;
	
	// Grid ���� ����
	GridObj.nAlphaLevel = 0;
	
	// Grid Row ���� ����
	GridObj.nRowHeight = 25;

	GridObj.nHDLines=1;

	// �������� ���ε�� �⺻ ��
	GridObj.strDefaultImportFileFilter ='xls';

	GridObj.SetHelpInfo();
	
	//��� �� ��ҹ�ư ��뿩��
	GridObj.bAbortQueryVisible = true;
	
	GridObj.strScrollBarSkin = "/img/docs/scrollbar-ocean.bmp";
	
	GridObj.bQueryErrorMsgVisible = false;
}

function btn(a,b){
	document.write ("<table cellpadding=0 cellspacing=0 border=0 height=23 onClick="+a+" style='cursor:hand'><tr ><td width=15 class=btn_left >");
	document.write ("<img src=/img/docs/blank.gif width=15 height=1></td>");
	document.write ("<td class=btn_txt valign=middle >"+b+"</td><td width=4 class=btn_right ><img src=/img/docs/blank.gif width=4></td></tr></table>");
}

var Mcolor = "222|227|242"; //Mandatory
var Ocolor = "223|241|230"; //Optionally
var Rcolor = "255|255|255"; //ReadOnly
var Scolor = "249|247|183"; //Summary Background Color
var Lcolor = "0|0|255";		//Link Color

var nfCaseAmt = "#,##0";
var nfCaseAmtFor = "#,##0.00";
var nfCaseQty = "#,##0.000";
var nfCasePrice = "#,##0.00000";