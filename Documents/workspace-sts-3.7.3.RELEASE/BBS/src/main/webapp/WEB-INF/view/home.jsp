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
<script type="text/javascript" src="./resources/js/jquery.simplePagination.js"></script>
<link type="text/css" rel="stylesheet" href="./resources/css/simplePagination.css"/>
<link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/ui-lightness/jquery-ui.css" rel="stylesheet" />
<script type="text/javascript" src="./resources/js/hoge.js"></script>
<script type="text/javascript">
$(function(){
	$('#start_date').datepicker({
		todayHighlight : false,
		autoclose : true,
		keyboardNavigation : false
	});
	$('#end_date').datepicker({
		todayHighlight : false,
		autoclose : true,
		keyboardNavigation : false
	});
	
    var requestObj = {
    		id : null,
    		message : null,
    };
    $("[id=comment_btn]").click(function() {
    	$("#errorMessage").text("");
    	var parentTable = $(this).parents("table");
    	var targetBlock = parentTable.find("#target");
    	requestObj.id = parentTable.find("#message_id").val();
    	requestObj.message = parentTable.find("#message_text").val();
    	//JavaScriptのオブジェクトをJSONに変換する
		var requestJson = JSON.stringify(requestObj);
        $.ajax({
            type        : "POST",
            url         : "comment",
            data: {requestJs : requestJson},
            success     : function(data) {
                            success(data, parentTable, targetBlock);
                        },
            error       : function(XMLHttpRequest, textStatus, errorThrown) {
           				 	
                            error(XMLHttpRequest, textStatus, errorThrown);
                        }
        });
    });
    var messageSize = $("#messageSize").val();
    $(".pagination").pagination({
        items: messageSize % 5,
        displayedPages: 4,
        cssStyle: 'light-theme',
        onPageClick: function(currentPageNumber){
            showPage(currentPageNumber);
        }
    })
});

function success(data, parentTable, targetBlock) {

	if(parentTable.find("#message_text").val() != "") {
		var addContent = 
			'<tr><td>' + data[0] + ' ' + data[1] + '</td>'
			+'<td class="delete">'
			+'<form:form modelAttribute="commentForm" action="./comment/delete/">'
			+'<form:hidden path="messageId" id="messageId" name="messageId" />'
			+'<form:hidden path="id" id="id" />'
			+'<form:hidden path="userId" id="userId" />'
			+'<input type="submit" value="×">'
			+'</form:form>'
			+"</td></tr>"
			+ "<tr><td colspan='3'><hr/></td></tr>"
			+ "<tr><td>" + data[5] + "</td></tr>";
		var $addContent = $(addContent);
		$addContent.find("#messageId").val(data[2]);
		$addContent.find("#id").val(data[3]);
		$addContent.find("#userId").val(data[4]);
		targetBlock.append($addContent);
		parentTable.find("#message_text").val("");
	} else {
		 $("#errorMessage").append(data[0]);
	}
	
}
 
function error(XMLHttpRequest, textStatus, errorThrown) {
  console.log(XMLHttpRequest);
  console.log(textStatus);
  console.log(errorThrown);
}
function showPage(currentPageNumber){
    var page="#page-" + currentPageNumber;
    $('.selection').hide();
    $(page).show();
} 
</script>
<style>
.selection {
    display: none;
}
#page-1 {
    display: block;
}
</style>
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
<div>
	<span id="errorMessage"></span>
</div>
<br/>
<br/>
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
			<td>投稿日</td>
			<td><input type="text" id="start_date" name = "start_date" placeholder="クリックして下さい">
				 ～
				<input type="text" id="end_date" name = "end_date" placeholder="クリックして下さい">
			</td>
		</tr>
		<tr>
			<td class="submit"><input type="submit" id="refinement_btn" value="絞り込み"></td>
		</tr>
	</table>
</form>
<input type="hidden" id="messageSize" value="${ messageSize }">
<div class="pagination-holder clearfix">
    <div id="light-pagination" class="pagination"></div>
</div>
<%! int psginationNumber = 1; %>
<c:forEach items="${messages}" var="message" varStatus="status">

	<c:if test="${ status.index % 5 == 0 }">
		<div class="selection" id="page-${ psginationNumber + 1 }">
	</c:if>
		<table>
			<thead>
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
			</thead>
			<tbody id="target">
				<c:forEach items="${ comments }" var="comment">
					<c:if test="${ comment.messageId == message.id }">
						<tr>
							<td colspan="3">
								<c:out value="${ user.name }" />
								<fmt:formatDate value="${ comment.insertDate }" pattern="yyyy年MM月dd日 HH:mm" />
							</td>
							<td class="delete">
								<form:form modelAttribute="commentForm" action="./comment/delete/">
									<form:hidden path="messageId" value="${comment.messageId}"/>
									<form:hidden path="id" value="${comment.id}"/>
									<form:hidden path="userId" value="${comment.userId}"/>
									<input type="submit" value="×">
								</form:form>
							</td>
						</tr>
						<tr>
							<td colspan="3"><hr /></td>
						</tr>
						<tr>
							<td colspan="3" class="comment_text">
								<pre><c:out value="${ comment.text }" /></pre>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
			<tfoot>
				<tr>
					<td>
						<input type="hidden" id="message_id" value="${message.id}" />
						<textarea rows="10" cols="20"  id="message_text"></textarea><br/>
						<input type="button" id="comment_btn" value="コメントする" />
					</td>
				</tr>
			</tfoot>
		</table>
	<c:if test="${ status.index % 6 == 0 }">
		</div>
	</c:if>
</c:forEach>
</body>
</html>