<?php
if(!defined('SESS_CHK')){
	header('Location: .');
	return;
}
include_once 'config.php';
include_once 'function.php';
?><!DOCTYPE html>
<html>
	<head>
		<title>Money Manager</title>
		<script type="text/javascript" src="lib/jquery.js"></script>
		<script type="text/javascript" src="lib/jquery-ui.js"></script>
		<link rel="stylesheet" href="lib/jquery-ui.css">
		<link rel="stylesheet" href="main.css">	
	</head>
	<body>
	<div class="func"><?php include 'menu.php';?></div>
		<div class="main"> </div>
	</body>
</html>
