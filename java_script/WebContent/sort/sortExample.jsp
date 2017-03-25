<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Sort test</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
</head>
<body>

<form action="/test" method="GET" name="category-filter-form" id="category-filter-form">

	<input type="text" name="query" placeholder="검색어">	
	<ul>
	<li class="category-sort-link">
		<a href="/articles?sort=id&order=desc" data-sort="id" data-order="desc" class="category-sort-link">최신순</a>
	</li>
	<li class="category-sort-link">
		<a href="/articles?sort=voteCount&order=desc" data-sort="voteCount" data-order="desc" class="category-sort-link">추천순</a>
	</li>
	<li class="category-sort-link">
		<a href="/articles?sort=noteCount&order=desc" data-sort="noteCount" data-order="desc" class="category-sort-link">댓글순</a>
	</li>
	<li class="category-sort-link">
		<a href="/articles?sort=viewCount&order=desc" data-sort="viewCount" data-order="desc" class="category-sort-link">조회순</a>
	</li>
	</ul>
		
	<input type="hidden" name="sort" id="category-sort-input">
	<input type="hidden" name="order" id="category-order-input">	
	<button type="submit">검색</button>
</form>
<script>
	$(function() {
		$('.category-sort-link').click(function(e) {
			var sort = $(this).data('sort');
			var order = $(this).data('order');
			alert('sort : '+sort + '\n'+order+" : "+order);
			$('#category-sort-input').val($(this).data('sort'));
			$('#category-order-input').val($(this).data('order'));
			e.preventDefault();
			$('#category-filter-form')[0].submit();
		});
	});
</script>


</body>
</html>