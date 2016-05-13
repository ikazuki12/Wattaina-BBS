<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>ユーザー管理</title>
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
<table class="control">
	<tr>
		<th>名前</th>
		<th>ログインID</th>
		<th>所属支店</th>
		<th>役職</th>
		<th>ユーザー</th>
	</tr>
	<c:forEach items="${ users }" var="user">
		<tr>	
			<td>
				<a href="../settings?user_id=${ user.id }"><c:out value="${ user.name }" /></a>
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
		</tr>
	</c:forEach>
</table>
</body>
</html>