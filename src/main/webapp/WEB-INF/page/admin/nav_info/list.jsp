<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!doctype html>
<html>
<head>
<meta charset="utf-8">
<title>导航设置</title>
<c:import url="../common/common.jsp"></c:import>
</head>

<body>
	<!-- 面包屑导航和主体内容 -->
	<div class="content">
		<!--面包屑导航-->
		<div class="content-header">
			<div class="breadcrumb">
				<span>界面</span>
				<span class="divider">/</span>
				<span class="active">导航设置</span>
			</div>
		</div>
		
		<!--全部主体内容-->
		<div class="list-content">
			<!--块元素-->
			<div class="block">
				<!--页面有多个表格时，可以用于标识表格-->
				<h2>导航列表</h2>
				<!--正文内容-->
				<div class="main">
					<!--表格上方的操作元素，添加、删除、搜索等-->
					<div class="operation-wrap">
						<div class="buttons-wrap">
							<button id="add" class="button blue"><span class="icon-plus"></span> 添加</button>
							<button id="delete" class="button red"><span class="icon-minus"></span> 删除</button>
							<button id="save" class="button green"><span class="icon-check2"></span> 保存</button>
						</div>
					</div>
					<!--class加上color可以实现隔行变色-->
					<!--color1表示奇数行着色、color2表示偶数行着色-->
					<table id="table" class="table">
						<thead>
							<tr>
								<th class="checkbox"><input type="checkbox" class="fill listen-1" /> </th>
								<th style="width:20%;">显示顺序</th>
								<th>名称</th>
								<th>链接</th>
								<th>类型</th>
								<th>首页</th>
								<th>可用</th>
								<th>显示下载计数器</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach items="${list}" var="navInfo">
								<tr>
									<c:choose>
										<c:when test="${navInfo.type=='system'}">
											<td class="checkbox"><input type="checkbox" class="fill listen-1-2" name="id" value="${navInfo.id}" disabled="disabled" /> </td>
											<td><input type="text" class="text" name="sort" value="${navInfo.sort}" data-type="非负整数" error-msg="请填写非负整数" error-pos="36" /></td>
											<td><input type="text" class="text" name="name" value="${navInfo.name}" data-type="必填" error-pos="36" /></td>
											<td>${navInfo.link}<input type="hidden" class="text" name="link" value="${navInfo.link}" /></td>
											<td><font color="blue">内置</font></td>
										</c:when>
										<c:otherwise>
											<td class="checkbox"><input type="checkbox" class="fill listen-1-2" value="${navInfo.id}" name="id" /> </td>
											<td><input type="text" class="text" name="sort" value="${navInfo.sort}" data-type="非负整数" error-msg="请填写非负整数" error-pos="36" /></td>
											<td><input type="text" class="text" name="name" value="${navInfo.name}" data-type="必填" error-pos="36" /></td>
											<td><input type="text" class="text" name="link" value="${navInfo.link}" data-type="必填" error-pos="36" /></td>
											<td><font color="red">自定义</font></td>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${navInfo.isIndex=='1'}">
											<td><input type="radio" class="fill" value="1" name="isIndex" checked /> </td>
										</c:when>
										<c:otherwise>
											<td><input type="radio" class="fill" value="0" name="isIndex" /> </td>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${navInfo.isUse=='1'}">
											<td><input type="checkbox" class="fill" value="1" name="isUse" checked /> </td>
										</c:when>
										<c:otherwise>
											<td><input type="checkbox" class="fill" value="0" name="isUse" /> </td>
										</c:otherwise>
									</c:choose>
									<c:choose>
										<c:when test="${navInfo.isDownloadCount=='1'}">
											<td><input type="checkbox" class="fill" value="1" name="isDownloadCount" checked /> </td>
										</c:when>
										<c:otherwise>
											<td><input type="checkbox" class="fill" value="0" name="isDownloadCount" /> </td>
										</c:otherwise>
									</c:choose>
								</tr>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script>
	javaex.loading();
	
	var idArr = new Array();
	var sortArr = new Array();
	var nameArr = new Array();
	var linkArr = new Array();
	var isIndexArr = new Array();
	var isUseArr = new Array();
	var isDownloadCountArr = new Array();
	
	// 点击添加按钮，table向下追加一行
	$("#add").click(function() {
		var trHtml = '';
		trHtml += '<tr>';
		trHtml += '<td class="checkbox"><input type="checkbox" class="fill listen-1-2" name="id" value="" /> </td>';
		trHtml += '<td><input type="text" class="text" name="sort" value="" data-type="非负整数" error-msg="请填写非负整数" error-pos="36" /></td>';
		trHtml += '<td><input type="text" class="text" name="name" value="" data-type="必填" error-pos="36" /></td>';
		trHtml += '<td><input type="text" class="text" name="link" value="" data-type="必填" error-pos="36" /></td>';
		trHtml += '<td></td>';
		trHtml += '<td></td>';
		trHtml += '<td></td>';
		trHtml += '<td></td>';
		trHtml += '</tr>';
		$("#table tbody").append(trHtml);
		
		// 动态加载html代码之后，需要重新渲染
		javaex.render();
	});
	
	// 点击删除按钮事件
	$("#delete").click(function() {
		idArr = [];
		$(':checkbox[name="id"]').each(function() {
			if ($(this).is(":checked")) {
				var id = $(this).val();
				if (id!="") {
					idArr.push(id);
				}
			}
		});
		
		// 判断是否选择了有效值
		if (idArr.length==0) {
			// 仅仅删除多添加的tr行，不需要后台处理
			$(':checkbox[name="id"]:checked').each(function() {
				$(this).parent().parent().parent().remove();
			});
		} else {
			javaex.optTip({
				content : "数据提交中，请稍候...",
				type : "submit"
			});
			
			$.ajax({
				url : "delete.json",
				type : "POST",
				dataType : "json",
				traditional : "true",
				data : {
					"idArr" : idArr
				},
				success : function(rtn) {
					if (rtn.code=="000000") {
						javaex.optTip({
							content : rtn.message,
							type : "success"
						});
						// 建议延迟加载
						setTimeout(function() {
							window.location.reload();
						}, 2000);
					} else {
						javaex.optTip({
							content : rtn.message,
							type : "error"
						});
					}
				}
			});
		}
	});
	
	// 点击保存按钮事件
	$("#save").click(function() {
		// 表单验证函数
		if (javaexVerify()) {
			idArr = [];
			sortArr = [];
			nameArr = [];
			linkArr = [];
			isIndexArr = [];
			isUseArr = [];
			isDownloadCountArr = [];
			
			// id
			$(':checkbox[name="id"]').each(function() {
				idArr.push($(this).val());
			});
			
			// 显示顺序
			$('input[name="sort"]').each(function() {
				sortArr.push($(this).val());
			});
			
			// 导航名称
			$('input[name="name"]').each(function() {
				nameArr.push($(this).val());
			});
			
			// 导航链接
			$('input[name="link"]').each(function() {
				linkArr.push($(this).val());
			});
			
			// 导航首页
			$(':radio[name="isIndex"]').each(function() {
				if ($(this).attr("checked")) {
					isIndexArr.push("1");
				} else {
					isIndexArr.push("0");
				}
			});
			
			// 导航是否可用
			$(':checkbox[name="isUse"]').each(function() {
				if ($(this).attr("checked")) {
					isUseArr.push("1");
				} else {
					isUseArr.push("0");
				}
			});
			
			// 是否显示下载计数器
			$(':checkbox[name="isDownloadCount"]').each(function() {
				if ($(this).attr("checked")) {
					isDownloadCountArr.push("1");
				} else {
					isDownloadCountArr.push("0");
				}
			});
			
			javaex.optTip({
				content : "数据提交中，请稍候...",
				type : "submit"
			});
			
			// 向后台提交
			$.ajax({
				url : "save.json",
				dataType : "json",
				traditional : "true",	// 允许传递数组
				data : {
					"idArr" : idArr,
					"sortArr" : sortArr,
					"nameArr" : nameArr,
					"linkArr" : linkArr,
					"isIndexArr" : isIndexArr,
					"isUseArr" : isUseArr,
					"isDownloadCountArr" : isDownloadCountArr
				},
				success : function(rtn) {
					if (rtn.code=="000000") {
						javaex.optTip({
							content : rtn.message,
							type : "success"
						});
						// 建议延迟加载
						setTimeout(function() {
							window.location.reload();
						}, 2000);
					} else {
						javaex.optTip({
							content : rtn.message,
							type : "error"
						});
					}
				}
			});
		}
	});
</script>
</html>
