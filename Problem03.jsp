<%-- 컴퓨터학과 박소현 20190963 --%>
<%-- 크롬에 적합합니다. --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import="java.util.Enumeration" %>
  <%@ page import="java.util.*" %>
 <% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>시간표 작성</title>
<style>
		table {
			border-collapse:collapse;
		}
		table, td, th {
			border: solid 1.5px;
			width: 550px;
			height: 60px;
		}
		td.left_column {
			font-size: 20px;
			font-weight:bold;
			text-align: center;
		}
		
		td {
			font-size: 13px;
			text-align: center;
		}
		
		td.mandatory {
			background-color: #ffe08c;  
		}
		td.selective {
			background-color: #b2ccff;   
		}
		td.liberal {
			background-color: #bdbdbd;   
		}
</style>
<%!
	public int check(Object obj){
		if(obj == null)
			return 1;
		return 0;
	}

	int[][] lectureType = {
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0},
			{0, 0, 0, 0, 0}
	};
	
	int[][] consecutive = {
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1},
			{1, 1, 1, 1, 1}
	};
	
	int[][] lectureTitle = {
			{-1, -1, -1, -1, -1},
			{-1, -1, -1, -1, -1},
			{-1, -1, -1, -1, -1},
			{-1, -1, -1, -1, -1},
			{-1, -1, -1, -1, -1},
			{-1, -1, -1, -1, -1}
	};

	String[] typeNames = { "전공필수", "전공선택", "교양", "자유선택" };
	String[] titleNames = { "웹프로그래밍", "운영체제", "소프트웨어프로그래밍", "데이터베이스개론",
			"자료구조", "네트워크", "창의와감성", "사회봉사" };
	String[] days = { "월", "화", "수", "목", "금" };
%>
</head>
<body>
<div align="center">
<form method="post" action="Problem03.jsp">
<%	
	int i;
	out.println("과목타입: <select name=\"lectureType\"><br>");
	for(i = 0; i < typeNames.length; i++){
		out.println("<option value=\""+ (i+1) +"\">" + typeNames[i] + "</option>");
	}
	out.println("</select>");
	
	out.println("과목명: <select name=\"lectureTitle\"><br>");
	for(i = 0; i < titleNames.length; i++){
		out.println("<option value=\""+ i +"\">" + titleNames[i] + "</option>");
	}
	out.println("</select>");
	
	out.println("요일: <select name=\"day\"><br>");
	for(i = 0; i < days.length; i++){
		out.println("<option value=\""+ i +"\">" + days[i] + "</option>");
	}
	out.println("</select>");
	
	out.println("시간: <select name=\"time\"><br>");
	for(i = 1; i <= 6; i++){
		out.println("<option value=\""+ i +"\">" + i + "</option>");
	}
	out.println("</select>");
	
	out.println("연강여부: <select name=\"consecutive\"><br>");
	for(i = 1; i <= 4; i++){
		out.println("<option value=\""+ i +"\">" + i + "</option>");
	}
	out.println("</select>");
	
	out.println("&nbsp;&nbsp;&nbsp;");
	
	out.println("<input type=\"submit\" value=\"등록\">");
	
	out.println("<hr>");	
%>
</form>
</div>
<%
	String schedule = null;
	int ans, selectType = 0, selectTitle = 0,
			selectDay = 0, selectTime = 0, selectConsecutive = 0;
	boolean flag = false;//int flag는 c스타일 java는 boolean으로 바꾸기
	String an;
	
	an = request.getParameter("lectureType");
	if(check(an) == 1)
		flag = true;
	else{
		ans = Integer.parseInt(an) - 1;
		schedule = typeNames[ans] + "/";
		selectType = ans + 1;
	} 
	
	if(flag == false){
		ans = Integer.parseInt(request.getParameter("lectureTitle"));
		if(check(ans) == 1)
			flag = true;
		schedule += titleNames[ans] + "/";
		selectTitle = ans;
	}
	
	an = request.getParameter("day");
	if(check(an) == 1)
		flag = true;
	else{
		ans = Integer.parseInt(an);
		schedule += days[ans] + "/";
		selectDay = ans;
	} 
	
	an = request.getParameter("time");
	if(check(an) == 1)
		flag = true;
	else{
		schedule += an + "/";
		selectTime = Integer.parseInt(an) - 1;
	}
	
	an = request.getParameter("consecutive");
	if(check(an) == 1)
		flag = true;
	else{
		schedule += an;
		selectConsecutive = Integer.parseInt(an);
	}
	
	ArrayList<String> list = (ArrayList<String>)session.getAttribute("timetable");
	int[][] lectureTypeE = (int[][])session.getAttribute("typetable");
	int[][] lectureTitleE = (int[][])session.getAttribute("titletable");
	int[][] consecutiveE = (int[][])session.getAttribute("constable");
	if(list == null){
		ArrayList<String> newList = new ArrayList<String>();
		list = newList;
	}
	if(lectureTypeE == null){
		lectureTypeE = lectureType;
	}
	if(lectureTitleE == null){
		lectureTitleE = lectureTitle;
	}
	if(consecutiveE == null){
		consecutiveE = consecutive;
	}
	
	boolean overlap = true;
	if(lectureType[selectTime][selectDay] != 0)
	if(consecutiveE[selectTime][selectDay] == 0)
		overlap = false;
	if(lectureTitle[selectTime][selectDay] != -1)
		overlap = false;
	int check = selectTime + 1;
	for(i = 1; i < selectConsecutive; i++){
		if(consecutiveE[check][selectDay] == 0)
			overlap = false;
	}

	if((overlap == true) && (flag == false) && schedule != null 
			&& (list.contains(schedule) == false))
	{
		list.add(schedule);
		
		lectureTypeE[selectTime][selectDay] = selectType;
		lectureTitleE[selectTime][selectDay] = selectTitle;
		consecutiveE[selectTime++][selectDay] = selectConsecutive;
		for(i = 1; i < selectConsecutive; i++){
			consecutiveE[selectTime++][selectDay] = 0;
		}
		
		
	}
	session.setAttribute("timetable", list);
	session.setAttribute("typetable", lectureTypeE);
	session.setAttribute("titletable", lectureTitleE);
	session.setAttribute("constable", consecutiveE);
	
%>
<div align="center">
	<h3>강의 시간표</h3>
		<table>
		<%
			out.println("<tr>");
			out.println("<td class=\"left_column\">2학년</td>");
			for(i=0; i<5; i++){
				out.println("<td>");
				out.println((days[i]));
				out.println("</td>");
			}
			out.println("</tr>");
				for(i = 0; i < 6; i++){
					out.println("<tr>");
					out.println("<td class=\"left_column\">" + (i+1) + "</td>");
					
					for(int j = 0; j < 5; j++){
						if((consecutiveE[i][j] == 1)&&(lectureTypeE[i][j] == 0))
							out.println("<td>&nbsp;</td>");
						else if(consecutiveE[i][j] == 0){
							continue;
						}
						else{
							int cons = consecutiveE[i][j];
							int title = lectureTitleE[i][j];
							
							if(lectureTypeE[i][j] == 1){
								out.println("<td class=\"mandatory\" rowspan=\"" +
							cons +"\">" + titleNames[title] + "</td>");
							}
							
							else if(lectureTypeE[i][j] == 2){
								out.println("<td class=\"selective\" rowspan=\"" +
										cons +"\">" + titleNames[title] + "</td>");
							}
							else if(lectureTypeE[i][j] == 3){
								out.println("<td class=\"liberal\" rowspan=\"" +
										cons +"\">" + titleNames[title] + "</td>");
							}
							else{
								out.println("<td rowspan=\"" + cons + "\">"+
							titleNames[title] + "</td>");
							}
						}
					}
		
					out.println("</tr>");
				}
			%>
		</table>
</div>

<hr>
<div align="center">
<%
	for(i = 0; i < list.size(); i++){
		String address = list.get(i);
		
		out.println(address + "<br>");
	}
%>

</div>
</body>
</html>