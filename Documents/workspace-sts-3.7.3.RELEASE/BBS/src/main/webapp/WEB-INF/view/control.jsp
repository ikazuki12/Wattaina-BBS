<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ユーザー管理</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1/jquery-ui.min.js"></script>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jqueryui/1/i18n/jquery.ui.datepicker-ja.min.js"></script>
<link type="text/css" href="http://ajax.googleapis.com/ajax/libs/jqueryui/1/themes/ui-lightness/jquery-ui.css" rel="stylesheet" />
<script type="text/javascript">
$(function(){
	var requestObj = {
    		id : null,
    };
	$("[id=edit_btn]").click(function(){
		var parentTable = $(this).parents("tr");
		requestObj.id = parentTable.find("#user_id").val();
		var requestJson = JSON.stringify(requestObj);
        $.ajax({
            type        : "GET",
            url         : "/BBS/settings",
            data: {requestJs : requestJson},
            success     : function(data) {
                            success(data, parentTable);
                        },
            error       : function(XMLHttpRequest, textStatus, errorThrown) {
           				 	
                            error(XMLHttpRequest, textStatus, errorThrown);
                        }
        });
    });
	function success(data, parentTable) {
		var addContent = 
			'<div id="hogehoge" title="編集">' +
				'<form:form modelAttribute="userForm" action="/BBS/settings">' +
					'<form:hidden path="id" id="id"/>' +
					'<table class="setting">' +
						"<tr><th>ログインID</th><td>" +
							'<form:input path="loginId" id="loginId"/>' +
						'</td></tr>' +
						'<tr><th>パスワード</th><td>' +
							'<form:password path="password" />' +
						'</td></tr>' +
						'<tr><th>名前</th><td>' +
							'<form:input path="name" id="name" />' +
						'</td></tr>' +
						'<tr><th>所属支店</th><td>' +
							'<form:select path="branchId">' +
								'<c:forEach items="${ branches }" var="branch">' +
									'<form:option value="${ branch.id }">${ branch.name }</form:option>' +			
								'</c:forEach>' +
							'</form:select>' +
						'</td></tr>' +
						'<tr><th>部署・役職</th><td>' +
							'<form:select path="positionId">' +
								'<c:forEach items="${ positions }" var="position">' +
									'<form:option value="${ position.id }">${ position.name }</form:option>' +
								'</c:forEach>' +
							'</form:select>' +
							'<form:select path="positionId">' +
							'<c:forEach items="${ positions }" var="position">' +	
								'<form:option value="${ position.id }">${ position.name }</form:option>' +
							'</c:forEach>' +
						'</form:select>' +
						'</td></tr>' +
					'</table>' +
				'<input type="submit" value="編集">' +
			'</form:form>' +
		'</div>';
		var $addContent = $(addContent);
		$addContent.find("#id").val(data[0]);
		$addContent.find("#loginId").val(data[1]);
		$addContent.find("#name").val(data[2]);
		$("#hoge").append($addContent);
		$("#hogehoge").dialog();
	}
	 
	function error(XMLHttpRequest, textStatus, errorThrown) {
	  console.log(XMLHttpRequest);
	  console.log(textStatus);
	  console.log(errorThrown);
	}
});

</script>
</head>
<body>
<div class="menu">
	<a href="../signup/">新規登録</a> /
	<a href="../">戻る</a>
</div>
<div class="user_name">
	<c:out value="${ loginUser.name }" />
</div>
<c:if test="${ not empty errorMessages }">
	<ul>
		<c:forEach items="${ errorMessages }" var="message">
			<li><span><c:out value="${message}" /></span></li>
		</c:forEach>
	</ul>
	<c:remove var="errorMessages" scope="session" />
</c:if>
<div id='hoge'></div>
<table class="control">
	<tr>
		<th>名前</th>
		<th>ログインID</th>
		<th>所属支店</th>
		<th>役職</th>
		<th>ユーザー</th>
		<th>編集</th>
	</tr>
	<c:forEach items="${ users }" var="user">
		<tbody id="target">
			<tr>	
				<td>
					<c:out value="${ user.name }" />
				</td>
				<td><c:out value="${ user.loginId }" /></td>
				<td>
					<c:forEach items="${ branches }" var="branch">
						<c:if test="${ branch.id == user.branchId }">
							<c:out value="${ branch.name }" />
						</c:if>
					</c:forEach>
				</td>
				<td>
					<c:forEach items="${ positions }" var="position">
						<c:if test="${ position.id == user.positionId }">
							<c:out value="${ position.name }" />
						</c:if>
					</c:forEach>
				</td>
				<c:if test="${ user.stopped }">
					<td>
						<form:form modelAttribute="userForm">
							<form:hidden path="id" value="${user.id}"/>
							<form:hidden path="stopped" value="${user.stopped}"/>
							<input type="submit" value="ON">
						</form:form>
					</td>
				</c:if>
				<c:if test="${ not user.stopped }">
					<td>
						<form:form modelAttribute="userForm">
							<form:hidden path="id" value="${user.id}"/>
							<form:hidden path="stopped" value="${user.stopped}"/>
							<input type="submit" value="OFF">
						</form:form>
					</td>
				</c:if>
				<td>
					<input type="hidden" id="user_id" value="${ user.id }" />
					<button id="edit_btn">編集</button>
				</td>
			</tr>
		</tbody>
	</c:forEach>
</table>
</body>
</html>