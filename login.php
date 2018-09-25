<?php
include_once 'config.php';
?><!DOCTYPE html>
<html>
<head>
	<title>Login Page</title>
	<script type="text/javascript" src="lib/jquery.js"></script>
	<script type="text/javascript" src="lib/jquery-ui.js"></script>
	<link rel="stylesheet" href="lib/jquery-ui.css">
	<style>
.xx-input-error{
	border-color:red;
	border-style:solid;
	border-width: 3px;
}
	</style>
	<script>
function action_butLogin(){
	$("#msg_err").css("display", "none");
	var uname = $("#username").val().trim();
	var pass = $("#password").val().trim();
	var hasError = false;
	if(uname.length == 0){
		$("#username").addClass("xx-input-error");
		hasError=true;
	}else{
		$("#username").removeClass("xx-input-error");
	}
	if(pass.length == 0){
		$("#password").addClass("xx-input-error");
		hasError=true;;
	}else{
		$("#password").removeClass("xx-input-error");
	}
	if(hasError){
		$("#msg_mand").css("display", "block");
		return;
	}else{
		$("#msg_mand").css("display", "none");
	}
	$.post( "doLogin.php",{uname: uname, pass:pass}, function( data ) {
		if(data.code==0){
			location.reload();
		}else{
			$("#txt_err").text(data.msg);
			$("#msg_err").css("display", "block");
		}
	});
}
	</script>
</head>
<body>
<div style="width: 500px; padding: 20px; position: relative;margin:auto;margin-bottom:5px;display:none;font-size:1.1em" class="ui-widget-content ui-corner-all ui-state-error" id="msg_mand">
<span class="ui-icon ui-icon-alert"></span><span class="ui-state-error-text">Username and password are required.</span>
</div>
<div style="width: 500px; padding: 20px; position: relative;margin:auto;margin-bottom:5px;display:none;font-size:1.1em" class="ui-widget-content ui-corner-all ui-state-error" id="msg_err">
<span class="ui-icon ui-icon-alert"></span><span class="ui-state-error-text" id="txt_err"></span>
</div>
<div style="width: 500px; padding: 20px; position: relative;margin:auto" class="ui-widget-content ui-corner-all">
		<div style="top:20px; font-size: 4vw; text-align: center">Login</div>
		<hr>
		<table style="width:66.67%;margin:auto">
			<tr><td style="width:50%;margin:auto">Username</td><td style="margin:auto"><input id="username" type="text" class="ui-corner-all"></td></tr>
			<tr><td style="width:50%;margin:auto">Password</td><td style="margin:auto"><input id="password" type="password" class="ui-corner-all"></td></tr>
			<tr><td colspan="2" style="text-align:center"><button class="ui-button ui-widget ui-corner-all" style="margin:auto" id="butLogin" onclick="action_butLogin();">Login</button></td></tr>
		</table>
	</div>
</body>
<script>
$("#username").keyup(function(event) {
    if (event.keyCode === 13) {
        $("#password").focus();
    }
});
$("#password").keyup(function(event) {
    if (event.keyCode === 13) {
       action_butLogin();
    }
});
$("#username").focus();
</script>
</html>
