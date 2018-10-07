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
		<style>
div.func{
	background-color: red;
	position: absolute;
	left:0;
	width: 20%;
	top: 0;
	height: 100%;
	overflow: auto;
}
div.main{
	background-color: blue;
	position: absolute;
	right: 0;
	width: 80%;
	top: 0;
	height: 100%;
	overflow: auto;
}
		</style>
	</head>
	<body>
		<div class="func"> </div>
		<div class="main"> </div>
	</body>
</html>
