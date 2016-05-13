<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新規登録画面</title>
</head>
<body>
<a href="../control/">戻る</a>
<c:if test="${ not empty errorMessages }">
	<ul>
		<c:forEach items="${ errorMessages }" var="message">
			<li><span><c:out value="${message}" /></span></li>
		</c:forEach>
	</ul>
	<c:remove var="errorMessages" scope="session" />
</c:if>
<form:form modelAttribute="userForm">
ログインID
<form:input path="loginId" /><br/>
パスワード
<form:password path="password"/><br/>
名前
<form:input path="name"/><br/>
所属支店(本社含む)
<form:select path="branchId">
<c:forEach items="${ branches }" var="branch">
	<form:option value="${ branch.id }">${ branch.name }</form:option>
</c:forEach>
</form:select><br/>
部署・役職
<form:select path="positionId">
	<c:forEach items="${ positions }" var="position">
		<form:option value="${ position.id }">${ position.name }</form:option>
	</c:forEach>
</form:select><br/>
<input type="submit" value="登録">
</form:form>
</body>
</html>