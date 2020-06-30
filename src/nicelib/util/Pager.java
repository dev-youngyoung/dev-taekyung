package nicelib.util;

import java.util.*;
import javax.servlet.http.HttpServletRequest;


public class Pager {

	private int pageNum = 1;
	private int totalNum = 0;
	private int listNum = 20;
	private int naviNum = 10;

	private HttpServletRequest _request;
	private String pageVar = "page";
	private String link;

	public int linkType = 0;
	public String pagebar = "";

	public Pager(HttpServletRequest req) throws Exception {
		_request = req;
		parseQuery();
	}

	public void setPageVar(String str) {
		pageVar = str;
	}

	public void setPageNum(int num) {
		pageNum = num;
	}

	public void setTotalNum(int num) {
		totalNum = num;
	}

	public void setListNum(int num) {
		listNum = num;
	}

	public void setNaviNum(int num) {
		naviNum = num;
	}

	public void setLink(String link) {
		this.link = link;
	}	

	public int getPageNum() {
		return pageNum;
	}

	public int getLeftPage() {
		int firstPage = (int)(( java.lang.Math.ceil( (double)pageNum / (double)naviNum ) - 1 ) * (double)naviNum + 1);
		if(firstPage > 1) return firstPage - 1;
		else return 0;
	}

	public int getRightPage() {
		int totalPage = (int)(java.lang.Math.ceil((double)totalNum / (double)listNum));
		int firstPage = (int)(( java.lang.Math.ceil( (double)pageNum / (double)naviNum ) - 1 ) * (double)naviNum + 1);
		int lastPage = firstPage + naviNum - 1;
		if(lastPage < totalPage) return lastPage + 1;
		else return 0;
	}

	public String getPagerK() throws Exception {
		if(totalNum == 0) return "";
		int totalPage = (int)(java.lang.Math.ceil((double)totalNum / (double)listNum));
		int firstPage = (int)(( java.lang.Math.ceil( (double)pageNum / (double)naviNum ) - 1 ) * (double)naviNum + 1);
		int lastPage = firstPage + naviNum - 1;
		if(totalPage < lastPage) {
			lastPage = totalPage;
		}

/*		String firstImg = "<div class='page_first_btn'><!----></div>";
		String prevImg = "<div class='page_prev_btn'><!----></div>";
		String nextImg = "<div class='page_next_btn'><!----></div>";
		String lastImg = "<div class='page_last_btn'><!----></div>";
		String separator = "<div class='page_seperator'><!----></div>";*/
		//String firstImg = "&nbsp;<img src=\"/images/board_b_first.gif\" border=\"0\" >&nbsp;";
		//String prevImg = "&nbsp;<img src=\"/images/board_b_before.gif\" border=\"0\">&nbsp;&nbsp;";
		//String nextImg = "&nbsp;&nbsp;<img src=\"/images/board_b_next.gif\" border=\"0\">&nbsp;";
		//String lastImg = "&nbsp;&nbsp;<img src=\"/images/board_b_last.gif\" border=\"0\">&nbsp;";
		//String separator = "&nbsp;&nbsp;&nbsp;&nbsp;";
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("<div class=\"common-paging\"><ul>");

		//ù ������
		/*
		sb.append("<li>");
		if(pageNum > 1) {
			sb.append("<a href='"+getPageLink(1)+"' class='on'>" + firstImg + "</a>");
		} else {
			sb.append("");
		}
		sb.append("</li>");
		 */
		
		//���� �� ������
		if(pageNum <= 1) {
			sb.append("<li class=\"paging-prev\"><a href=\"javascript:alert('ù������ �Դϴ�.');\"></a></li>");
		} else {
			sb.append("<li class=\"paging-prev\"><a href='"+getPageLink(pageNum-1)+"'></a></li>");
		}
		
		for(int i = firstPage; i <= lastPage; i++) {
			if(pageNum != i) {
				sb.append("<li><a href='"+getPageLink(i)+"'>"+ i +"</a></li>");
			} else {
				sb.append("<li class='is-active'><a>"+ i + "</a></li>");
			}
			//if(i < lastPage) sb.append("<li>" + separator + "</li>");
		}

		//���� �� ������
		sb.append("");
		if(pageNum < totalPage) {
			sb.append("<li class=\"paging-next\"><a href='"+getPageLink(pageNum+1)+"'>&nbsp;</a></li>");
		} else {
			sb.append("<li class=\"paging-next\"><a href=\"javascript:alert('������������ �Դϴ�.');\">&nbsp;</a></li>");
		}

/*		
		//������ ������
		sb.append("<li>");
		if(pageNum < totalPage) {
			sb.append("<a href='"+getPageLink(totalPage)+"' class='on'>" + lastImg + "</a>");
		} else {
			sb.append("");
		}
		sb.append("</li>");
*/
		sb.append("</ul></div>");

		return sb.toString();
	}
	
	public String getPager() throws Exception {
		if(totalNum == 0) return "";
		int totalPage = (int)(java.lang.Math.ceil((double)totalNum / (double)listNum));
		int firstPage = (int)(( java.lang.Math.ceil( (double)pageNum / (double)naviNum ) - 1 ) * (double)naviNum + 1);
		int lastPage = firstPage + naviNum - 1;
		if(totalPage < lastPage) {
			lastPage = totalPage;
		}

/*		String firstImg = "<div class='page_first_btn'><!----></div>";
		String prevImg = "<div class='page_prev_btn'><!----></div>";
		String nextImg = "<div class='page_next_btn'><!----></div>";
		String lastImg = "<div class='page_last_btn'><!----></div>";
		String separator = "<div class='page_seperator'><!----></div>";*/
		String firstImg = "&nbsp;<img src=\"/images/board_b_first.gif\" border=\"0\" >&nbsp;";
		String prevImg = "&nbsp;<img src=\"/images/board_b_before.gif\" border=\"0\">&nbsp;&nbsp;";
		String nextImg = "&nbsp;&nbsp;<img src=\"/images/board_b_next.gif\" border=\"0\">&nbsp;";
		String lastImg = "&nbsp;&nbsp;<img src=\"/images/board_b_last.gif\" border=\"0\">&nbsp;";
		String separator = "&nbsp;&nbsp;&nbsp;&nbsp;";
		
		StringBuffer sb = new StringBuffer();
		
		sb.append("<table align='center' border='0' cellspacing='0' cellpadding='0' class='page_box' style='border-collapse:collapse;'><tr>");

		//ù ������
		sb.append("<td>");
		if(pageNum > 1) {
			sb.append("<a href='"+getPageLink(1)+"' class='on'>" + firstImg + "</a>");
		} else {
//			sb.append(firstImg);
			sb.append("");
		}
		sb.append("</td>");

		//���� �� ������
		sb.append("<td>");
		if(firstPage > 1) {
			sb.append("<a href='"+getPageLink(firstPage-1)+"' class='on'>" + prevImg + "</a>");
		} else {
//			sb.append(prevImg);
			sb.append("");
		}
		sb.append("</td>");

		for(int i = firstPage; i <= lastPage; i++) {
			sb.append("<td>");
			if(pageNum != i) {
				sb.append("<a href='"+getPageLink(i)+"'><div class='page_number_btn'>"+ i +"</div></a>");
			} else {
				sb.append("<div class='page_number_btn_on'>"+ i + "</div>");
			}
			sb.append("</td>");
			if(i < lastPage) sb.append("<td>" + separator + "</td>");
		}

		//���� �� ������
		sb.append("<td>");
		if(lastPage < totalPage) {
			sb.append("<a href='"+getPageLink(lastPage+1)+"' class='on'>" + nextImg + "</a>");
		} else {
//			sb.append(nextImg);
			sb.append("");
		}
		sb.append("</td>");

		//������ ������
		sb.append("<td>");
		if(pageNum < totalPage) {
			sb.append("<a href='"+getPageLink(totalPage)+"' class='on'>" + lastImg + "</a>");
		} else {
//			sb.append(lastImg);
			sb.append("");
		}
		sb.append("</td>");

		sb.append("</tr></table>");

		return sb.toString();
	}

	private void parseQuery() throws Exception {
		link = _request.getRequestURI() + "?";
		String query = _request.getQueryString();
		if(query != null) {
			StringTokenizer token = new StringTokenizer(query, "&");
			String subtoken = null;
			String key = null;
			String value = null;
			StringBuffer sb = new StringBuffer();
			while(token.hasMoreTokens()) {
				int itmp;
				subtoken = token.nextToken();
				if((itmp = subtoken.indexOf("=")) != -1) {
					key = subtoken.substring(0,itmp);
					value = subtoken.substring(itmp+1);
					if(!key.equals(pageVar)) {
						sb.append(key + "=" + value + "&");
					}
				}
			}
			query = sb.toString();
		}
		if(!"".equals(query) && query != null) link = link + query;
	}

	private String getPageLink(int num) {
		if(this.linkType == 1) return "javascript:NaviPage("+ num +")";
		else return link + pageVar + "=" + num;
	}
}
