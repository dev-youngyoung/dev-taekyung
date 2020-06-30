<%
/*************************************************************************
	* 파 일 명 : Calendar.jsp
	* 작 업 자 : 이종환
	* 작 업 일 : 2008.02.04
	* 기    능 : 달력 페이지
	* ---------------------------- 변 경 이 력 --------------------------------
	* 번호 작 업 자   작      업     일   변경내용                       비고
	* -----------------------------------------------------------------------
	*   1  이종환			신규작성
 **************************************************************************/
%>
<%@ page contentType="text/html; charset=EUC-KR" %>
<%@ include file = "../../../inc/funUtil.inc"%>
<%
	String	sYYYYMMDD		=	_chkNull(request.getParameter("yyyymmdd"));
	String	sFormName	=	_chkNull(request.getParameter("formname"));
	String	sFieldName	=	_chkNull(request.getParameter("fieldname"));
	String	sSize				=	_chkNull(request.getParameter("length"),"0");

	int			iSize				=	Integer.parseInt(sSize);
	if(iSize == 10)
	{
		sYYYYMMDD	=	sYYYYMMDD.replaceAll("-","");
	}
%>
<html>
	<head>
		<TITLE>달력</TITLE>
		<link href="./basic.css" rel="stylesheet" type="text/css">

		<script language="javascript">
			var now					= new Date();
			var WinDate			= new Date();
			var firstyear		=	now.getFullYear()-105;
			var lastyear		=	now.getFullYear()+5;
			var colour			=	"#cccccc";
			var coltoday		=	"#FF0000";
			var currWinDate	="<%=sYYYYMMDD%>";

			var day			= now.getDate();
			var month		= now.getMonth();
			var year		= now.getFullYear();
			var daycell	=	new Array();
			var cellday	=	new Array();
			var n;
			var	n2			=	0;

			function calendar()
			{
				if ( (currWinDate.substring(0,2) == '19' || currWinDate.substring(0,2) == '20') &&
						 (currWinDate.substring(4,6) <= '12' && currWinDate.substring(4,6) > '00') &&
						 (currWinDate.substring(6,8) <= '31' && currWinDate.substring(6,8)  > '00'))
				{
					WinDate.setFullYear(currWinDate.substring(0,4));
					WinDate.setMonth(currWinDate.substring(4,6)-1);
					WinDate.setDate(currWinDate.substring(6,8));
					day   = WinDate.getDate();
					month = WinDate.getMonth();
					year  = WinDate.getFullYear();
				}

				var calobj = "";
				calobj+="<table border='0' cellpadding='1' cellspacing='1' bgcolor='#B59D88'>";
				calobj+="<tr>";
				calobj+="<td bgcolor='#FFFFFF'>";
				calobj+="<table border='0' cellpadding='0' cellspacing='0'>";
				calobj+="	<tr height='22'>";
				calobj+="		<td colspan='2'>";
				calobj+="			<TABLE border='0' cellpadding='0' cellspcing='0'>";
				calobj+="				<TR>";
				calobj+="					<TD class='cal_graybold' id='td_year'></TD>";
				calobj+="					<TD class='cal_graybold'>.</TD>";
				calobj+="					<TD id='td_month'></TD>";
				calobj+="				</TR>";
				calobj+="			</TABLE>";
				calobj+="		</td>";
				calobj+="		<td colspan='5' align='center'><img src='../../../images/cross.gif' onClick='closeCal()' class='hand' align='absmiddle'>";
				calobj+="										<img src='../../../images/resultset_previous_02.gif' onClick='gobackyear();updatecalendar();' class='hand' align='absmiddle'>";
				calobj+="										<img src='../../../images/resultset_previous.gif' onClick='gobackmonth()' class='hand' align='absmiddle'>";
				calobj+="										<img src='../../../images/resultset_next.gif' onClick='goonmonth()' class='hand' align='absmiddle'>";
				calobj+="										<img src='../../../images/resultset_next_02.gif' onClick='goonyear();updatecalendar();' class='hand' align='absmiddle'></td>";
				calobj+="	</tr>";
				calobj+="	<tr><td class='dot' colspan='7'></td></tr>";
				calobj+="	<tr align='center'>";
				calobj+="		<td width='25' height='20' class='cal_redbold'>일</td>";
				calobj+="		<td width='25' class='cal_graybold'>월</td>";
				calobj+="		<td width='25' class='cal_graybold'>화</td>";
				calobj+="		<td width='25' class='cal_graybold'>수</td>";
				calobj+="		<td width='25' class='cal_graybold'>목</td>";
				calobj+="		<td width='25' class='cal_graybold'>금</td>";
				calobj+="		<td width='25' class='cal_graybold'>토</td>";
				calobj+="	</tr>";
				calobj+=" <tr><td class='dot' colspan='7'></td></tr>";
				calobj+="	<tr><td id='td_calendar' colspan='7'></td></tr>";
				calobj+="</td>";
				calobj+="</tr>";
				calobj+="</table>";

				document.write(calobj);

				caltoday();
				updatecalendar();
			}

			function caltoday()
			{
				day   = now.getDate();
				document.getElementById("td_year").innerHTML	=	now.getFullYear();
				document.getElementById("td_month").innerHTML	=	now.getMonth()+1;

				if ( (currWinDate.substring(0,2) == '19' || currWinDate.substring(0,2) == '20') &&
				     (currWinDate.substring(4,6) <= '12' && currWinDate.substring(4,6) > '00') &&
				     (currWinDate.substring(6,8) <= '31' && currWinDate.substring(6,8)  > '00'))
				{
					WinDate.setFullYear(currWinDate.substring(0,4));
					WinDate.setMonth(currWinDate.substring(4,6)-1);
					WinDate.setDate(currWinDate.substring(6,8));
					day                    = WinDate.getDate();

					document.getElementById("td_year").innerHTML	=	WinDate.getFullYear();
					document.getElementById("td_month").innerHTML	=	WinDate.getMonth()+1;
				}
				updatecalendar();
			}

			function caltoday1()
			{
				day   = now.getDate();
				updatecalendar();
			}

			function updatecalendar()
			{
				month	=	parseInt(document.getElementById("td_month").innerHTML)-1;
				year	=	document.getElementById("td_year").innerHTML;

				var firstOfMonth	= new Date (year, month, 1);
				var startingPos		= firstOfMonth.getDay();
				var curday				=	1
				var days					=	monthdays(month,year)
				var prevdays			=	monthdays(month-1,year)
				var str

				var	iSumDay				=	startingPos+parseInt(days);
				var	iSumDay2			=	0;

				var	n1						=	0;
				var	n2						=	0;

				n1	=	Math.floor(iSumDay/7);

				if(iSumDay > n1 * 7)
				{
					n2	=	n1	+	1;
				}else
				{
					n2	=	n1;
				}

				iSumDay2	=	n2	*	7;

				var	sText	=	"";

				for (n=0; n < iSumDay2; n++)
				{
					if (startingPos==n)
				  {
						if (month==now.getMonth()&year==now.getFullYear()&curday==now.getDate())
						{
							str=curday;

							/*sText	=		"";
							sText	+=	"<TABLE border='0' cellpadding='0' cellspacing='0'>";
							sText	+=	"	<TR>";
							sText	+=	"		<TD class='cal_today'>"+str.toString()+"</TD>";
							sText	+=	"	</TR>";
							sText	+=	"</TABLE>";
							daycell[n]	=	sText;*/
							//daycell[n]	=	str.toString();
							//daycell[n]	=	"<TABLE border='0' cellpadding='0' cellspacing='0'><TR><TD class='cal_today'>"+str.toString()+"</TD></TR></TABLE>";
							daycell[n]	=	str.toString();
						}else
						{
							if (month==WinDate.getMonth()&year==WinDate.getFullYear()&curday==WinDate.getDate())
						  {
								str=curday;

								/*sText	=		"";
								sText	+=	"<TABLE border='0' cellpadding='0' cellspacing='0'>";
								sText	+=	"	<TR>";
								sText	+=	"		<TD class='cal_selectday'>"+str.toString()+"</TD>";
								sText	+=	"	</TR>";
								sText	+=	"</TABLE>";
								daycell[n]	=	sText;*/
								daycell[n]	=	str.toString();
							}else
							{
								daycell[n]	=	curday;
							}
						}
						setday(n,month,year,curday);
		    		startingPos++
		    		curday++
		  		}else
		 	 		{
						if (startingPos==66)
		  			{
					  	setday(n,month+1,year,curday);
					  	str=curday;

							//alert("pre["+str.toString()+"]");
				 	  	curday++
		  			}else
		  			{
						  setday(n,month-1,year,prevdays-startingPos+n+1);
				      str=prevdays-startingPos+n+1
							//alert("next["+str.toString()+"]");
					  }
						daycell[n]	=	str.toString();
				  }

	  			if (curday > days)
	  			{
					  curday=1
					  startingPos=66
				  }
				}


				/*for(var i=0; i < daycell.length; i++)
				{
					alert(daycell[i]);
				}*/

				var calcell			= "";
				var calrow			= "";
				var	sClassName	=	"";

				var	sCalendar		=	"";

				var	sRtnCal			=	"";

				var	iYear				=	0;
				var	iMonth			=	0;
				var	iDay				=	0;

				var	sYear				=	"";
				var	sMonth			=	"";
				var	sDay				=	"";
				//alert("year["+year+"], month["+month+"]");

				sCalendar	+=	"<TABLE border='0' cellpadding='0' cellspcing='0'>";
				for (calcell=0; calcell	<	n2; calcell++)
				{
					sCalendar	+="	<tr height='20' align='center'>";
					for(var i=0; i < 7; i++)
					{
						iYear		=	year;
						iMonth	=	month + 1;
						iDay		=	parseInt(daycell[(calcell*7+i)]);

						if(calcell == 0 && iDay > 7)
						{
							sClassName	=	"cal_gray";

							iMonth	=	iMonth - 1;

							if(iMonth == 0)
							{
								iYear		=	iYear - 1;
								iMonth	=	12;
							}
						}else if(calcell ==	n2-1 && iDay < 7)
						{
							sClassName	=	"cal_gray";

							iMonth	=	iMonth + 1;

							if(iMonth == 13)
							{
								iYear		=	parseInt(iYear) + 1;
								iMonth	=	1;
							}
						}else
						{
							if(month == now.getMonth() && year == now.getFullYear() && iDay == now.getDate())
							{
								sClassName	=	"cal_today";
							}else if (month==WinDate.getMonth()	&&	year==WinDate.getFullYear()	&& iDay == WinDate.getDate())
							{
								sClassName	=	"cal_selectday";
							}else
							{
								if(i == 0)
								{
									sClassName	=	"cal_redbold";
								}else
								{
									sClassName	=	"cal_nomal";
								}
							}
						}

						sYear	=	""	+	iYear;

						if(iMonth < 10)	sMonth	=	"0"	+	iMonth;
						else						sMonth	=	""	+	iMonth;

						if(iDay < 10)	sDay	=	"0"	+	iDay;
						else					sDay	=	""	+	iDay;

						sRtnCal	=	sYear	+	sMonth	+	sDay;

						sCalendar	+="	<td width='25'	onclick='message("+sRtnCal+");' style='cursor:hand' class='"+sClassName+"'>"+iDay+"</td>";
					}
					sCalendar	+="	</tr>";
				}
				sCalendar	+=	"</table>";

				document.getElementById("td_calendar").innerHTML	=	sCalendar;

				parent.document.getElementById("ifCalendar").style.height	= 63 + (20 * n2);
			}

			function setday(cell,month,year,day)
			{
				/*month++
				if (month==13){month=1;year++}
				if (month==0){month=12;year--}

				var strmon;
				var stryear;
				var strday;

				strmon=month.toString();
				if (strmon.length==1){strmon="0"+strmon}
					strday=day.toString();
				if (strday.length==1){strday="0"+strday}
					stryear=year.toString();
				cellday[cell]=stryear+strmon+strday*/
			}

			function monthdays(month,year)
			{
				var days;
				if (month==0 || month==2 || month==4 || month==6 || month==7 || month==9 || month==11 || month==-1 || month==12)  days=31;
				else if (month==3 || month==5 || month==8 || month==10) days=30;
				else if (month==1)
				{
					if (leapyear(year)) { days=29; }
					else { days=28; }
				}
				return (days);
			}

			function leapyear (Year)
			{
				if (((Year % 4)==0) && ((Year % 100)!=0) || ((Year % 400)==0))
				{
					return (true);
				} else { return (false);
				}
			}

			function goonmonth()
			{
				month	=	parseInt(document.getElementById("td_month").innerHTML);

				month	=	month	+	1;

				if(month == 13)
				{
					month	=	1;
					goonyear();
				}

				document.getElementById("td_month").innerHTML	=	month;
				updatecalendar();
			}

			function goonyear()
			{
			  year	=	parseInt(document.getElementById("td_year").innerHTML);
				document.getElementById("td_year").innerHTML	=	year	+	1;
			}

			function gobackmonth()
			{
				month	=	parseInt(document.getElementById("td_month").innerHTML);

				month	=	month	-	1;

				if(month	==	0)
				{
					month	=	12;
					gobackyear();
				}

				document.getElementById("td_month").innerHTML	=	month;
				updatecalendar();
			}

			function gobackyear()
			{
			  year	=	parseInt(document.getElementById("td_year").innerHTML);
				document.getElementById("td_year").innerHTML	=	year	-	1;
			}

			function closeCal()
			{
				var	oNode	=	parent.document.getElementById("ifCalendar");
				if(oNode != null)
				{
					parent.document.body.removeChild(oNode);
				}
			}

			/*****************************
				달력에 선택한 내용  EMEDIT로 전송
			*****************************/
			function message(cell)
			{
				var	_sCell	=	cell+"";
				var	sCell		=	"";

				if(<%=iSize%> == 10)
				{
					sCell	=	_sCell.substring(0,4)	+	"-"	+	_sCell.substring(4,6) +	"-"	+	_sCell.substring(6);
				}else
				{
					sCell	=	_sCell;
				}
		<%
			if(sFormName.equals(""))
			{
		%>
				if(typeof(parent.document.getElementById("<%=sFieldName%>").Text) != "undefined")
				{
					parent.document.getElementById("<%=sFieldName%>").Text	=	sCell;
				}

				if(typeof(parent.document.getElementById("<%=sFieldName%>").value) != "undefined")
				{
					parent.document.getElementById("<%=sFieldName%>").value	=	sCell;
					if(typeof(parent.document.getElementById("<%=sFieldName%>").callback) != "undefined"){
						var callback=parent.document.getElementById("<%=sFieldName%>").callback;
						eval("parent."+callback+"()");
					}
				}

		<%
			} else {
		%>
				parent.document.<%=sFormName%>.<%=sFieldName%>.value = sCell;
		<%
			}
		%>

				var	oNode	=	parent.document.getElementById("ifCalendar");
				if(oNode != null)
				{
					parent.document.body.removeChild(oNode);
				}
			}
		</script>
	</head>
<body topmargin="0" leftmargin="0">
	<script language="javascript">calendar();</script>
</body>
</html>