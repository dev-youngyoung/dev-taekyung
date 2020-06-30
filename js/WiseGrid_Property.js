function setProperty(GridObj)
{
	//GridObj.strHDFontName = "맑은고딕";
	//GridObj.strCellFontName = "맑은고딕";
	// Cell Font Setting
	GridObj.nCellFontSize = 9;

	// Header Font Setting
	GridObj.nHDFontSize = 9;
	GridObj.bHDFontBold = false;

	// Header 다중열 설정 여부
	GridObj.bMultiRowMenuVisible = true;

	// Header Color
	GridObj.strHDBgColor="244|244|244";	//	그리드 헤더의 배경색상 
	GridObj.strHDFgColor="0|113|167";		//	그리드헤더의 글자색상 


	// Cell Color
	GridObj.strGridBgColor="255|255|255";	//그리드의 배경색상
	GridObj.strCellBgColor="255|255|255";	//그리드셀의 배경색상

	GridObj.strCellFgColor="0|0|0";			//그리드셀의 글자색상을 조정할 수 있다.

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
	// Grid RowSelector 사용여부
	GridObj.bRowSelectorVisible = true;
	
	// Header 위치이동 시킬 수 있는 콤보버튼 활성화 여부
	GridObj.bHDSwapping = false;
	
	// Grid 투명도 설정
	GridObj.nAlphaLevel = 0;
	
	// Grid Row 높이 설정
	GridObj.nRowHeight = 25;

	GridObj.nHDLines=1;

	// 엑셀파일 업로드시 기본 값
	GridObj.strDefaultImportFileFilter ='xls';

	GridObj.SetHelpInfo();
	
	//통신 중 취소버튼 사용여부
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