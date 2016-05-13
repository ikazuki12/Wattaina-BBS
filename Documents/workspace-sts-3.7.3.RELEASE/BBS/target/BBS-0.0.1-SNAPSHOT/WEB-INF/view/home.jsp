<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt"  uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1/i18n/jquery.ui.datepicker-ja.min.js"></script>
<link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/ui-lightness/jquery-ui.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
	$('#datepicker').datepicker({
		todayHighlight : false,
		autoclose : true,
		keyboardNavigation : false
	});
	$('#datepicker2').datepicker({
		todayHighlight : false,
		autoclose : true,
		keyboardNavigation : false
	});
	
	$("#ajax_btn").click(function() {
        // outputDataを空に初期化
        $("#output_data").text("");
        $.ajax({
            type        : "GET",
            url         : "getTestData",
            dataType    : "json",
            success     : function(data) {
                            success(data);
                        },
            error       : function(XMLHttpRequest, textStatus, errorThrown) {
                            error(XMLHttpRequest, textStatus, errorThrown);
                        }
        });
    });
	
});
//Ajax通信成功時処理
function success(data) {
    alert("success:" + data);
 
    $("#output_data").text("");
    for (var cnt = 0; cnt < data.length; cnt++) {
        $("#output_data").append("data[" + cnt + "]：" + data[cnt] + "；");
    }
}
 
// Ajax通信失敗時処理
function error(XMLHttpRequest, textStatus, errorThrown) {
  
}
</script>
<title>ホーム</title>
</head>
<body>
<c:if test="${ not empty user }">
	<a href = "./logout/">ログアウト</a>
</c:if>
<c:if test="${ empty user }">
	<a href = "./login/">ログイン</a>
</c:if>
<c:if test="${ user.positionId == 1}">
	<a href = "./control/">ユーザー管理</a>
</c:if>
<a href = "./message/">新規投稿</a>
<c:out value="${user.name }" />
<c:if test="${ not empty errorMessages }">
	<ul>
		<c:forEach items="${ errorMessages }" var="message">
			<li><span><c:out value="${message}" /></span></li>
		</c:forEach>
	</ul>
	<c:remove var="errorMessages" scope="session" />
</c:if>
<br/>
<input type="button" id="ajax_btn" value="Ajax通信テスト" />
<br/>
outputData：<span id="output_data"></span>
<form method="get">
	<table class="message_select">
		<tr>
			<td>カテゴリー</td><td><select name="category" id="category">
			<option value="all">全て</option>
				<c:forEach items="${ messages }" var="message">
					<c:choose>
						<c:when test="${ editCategory == message.category }">
							<option value="${ message.category }" selected>${ message.category }</option>
						</c:when>
						<c:otherwise>
							<option value="${ message.category }">${ message.category }</option>
						</c:otherwise>
					</c:choose>
				</c:forEach>
		</select></td>
		</tr>
		<tr>
			<td>投稿日</td><td><input type="text" id="datepicker" name = "start_date" placeholder="クリックして下さい"> ～
				<input type="text" id="datepicker2" name = "end_date" placeholder="クリックして下さい"></td>
		</tr>
		<tr>
			<td class="submit"><input type="submit" value="絞り込み"></td>
		</tr>
	</table>
</form>
<c:forEach items="${messages}" var="message">
	<table>
		<tr>
			<td>
				<pre>カテゴリー[<c:out value="${message.category}" />]</pre>
			</td>
			<td>
				<form:form modelAttribute="messageForm" action="./message/delete/">
					<form:hidden path="id" value="${message.id}"/>
					<form:hidden path="userId" value="${message.userId}"/>
					<input type="submit" value="×">
				</form:form>
			</td>
		</tr>
		<tr>
			<td>
				<c:forEach items="${users}" var="user">
					<c:if test="${ user.id == message.userId }">
						<c:out value="${user.name}"/>
					</c:if>
				</c:forEach>
			</td>
		</tr>
		<tr>
			<td>
				<fmt:formatDate value="${message.insertDate}" pattern="yyyy年MM月dd日 HH時mm分" />
			</td>
		</tr>
		<tr>
			<td>
				件名<pre><c:out value="${message.subject}"/></pre>
			</td>
		</tr>
		<tr>
			<td>
				本文<pre><c:out value="${message.text}" /></pre>
			</td>
		</tr>
		<tr>
			<td>
				<div class="comment">コメント</div>
			</td>

		</tr>
		<c:forEach items="${ comments }" var="comment">
			<c:if test="${ comment.messageId == message.id }">
				<tr>
					<td colspan="3">
						<table class="comments">
							<tr>
								<td>
									[<c:out value="${ comment.id }" />]
								</td>
								<td>&nbsp;</td>
								<td class="delete">
									<form:form modelAttribute="commentForm" action="./comment/delete/">
										<form:hidden path="messageId" value="${message.id}"/>
										<form:hidden path="id" value="${comment.id}"/>
										<form:hidden path="userId" value="${comment.userId}"/>
										<input type="submit" value="×">
									</form:form>
								</td>
							</tr>
							<c:forEach items="${ users }" var="user">
								<c:if test="${ user.id == comment.userId }">
									<tr>
										<td nowrap>
											<c:out value="${ user.name }" />
											<fmt:formatDate value="${ comment.insertDate }" pattern="yyyy年MM月dd日 HH:mm" />
										</td>
									</tr>
								</c:if>
							</c:forEach>
							<tr>
							</tr>
							<tr>
								<td colspan="3"><hr /></td>
							</tr>
							<tr>
								<td colspan="3" class="comment_text">
									<pre><c:out value="${ comment.text }" /></pre>
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</c:if>
		</c:forEach>
		<tr>
			<td>
				<form:form modelAttribute="commentForm" action="./comment/">
					<form:hidden path="messageId" value="${message.id}" />
					<form:textarea path="text" cols="20" rows="10"/> <br/>
					<input type="submit" value="コメントする">
				</form:form>			
			</td>
		</tr>
	</table>
	
</c:forEach>
</body>
</html>