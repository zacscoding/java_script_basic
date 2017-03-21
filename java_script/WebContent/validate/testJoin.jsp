<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
</head>
<body>
	<div align="center">
	<form action="#" method="post" name="frm">
		<table>
			<tr>
				<td>아이디:</td>
				<td><input type="text" name="id"></td>			
			</tr>
			
			<tr>
				<td>PW:</td>
				<td><input type="text" name="password"></td>			
			</tr>
			
			<tr>
				<td>PW2:</td>
				<td><input type="text" name="confirm_password"></td>			
			</tr>
			
			<tr>
				<td>PHONE:</td>
				<td><input type="text" name="phone" id="phone"></td>			
			</tr>
			
			<tr>
				<td>EMAIL:</td>
				<td><input type="text" name="email" id="email"></td>			
			</tr>	
		</table>
		<input type="submit" value="확인" onclick="checkJoin(); return false;">
		<input type="reset" value="취소">
	</form>
	</div>

<script>
	function checkJoin() {		
		//공백 여부
		/* if(document.frm.id.value.length==0) {
			alert('check id');
			frm.id.focus();
			return false;
		} */
		
		//폰 유효성 1)
		//var phone = document.frm.phone.value;
		
		/* phone = phone.replace(/[^0-9]/g, '');
		if(phone.length != 10) { 
		   alert(phone + "\nnot 10 digits");
		} else {
		  alert(phone + "\nyep, its 10 digits");
		} */
		
		//폰 유효성2)		
		
/* 		var phoneRegex = /^01([0|1|6|7|8|9]?)-\d{3,4}-\d{4}$/;
		var phone  = $('#phone').val();		
		if(!regExp.test(phone)) {
			alert('폰 정규식 일치 안함');
			frm.phone.focus();
			return false;
		} else {
			alert('폰 정규식 일치');
			return false;
		}	 */
		
		var emailRegex = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		var email = $('#email').val();
		if(!emailRegex.test(email)) {
			alert('이메일 정규식 일치 안함');
			frm.email.focus();
			return false;
		} else {
			alert('이메일 정규식 일치');
			return false;
		}	
		
		
		
		
		
		return false;
	}




</script>	


</body>
</html>