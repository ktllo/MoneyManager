<?php
include_once 'config.php';
include_once 'function.php';
if(isLogin()){
	define('SESS_CHK', true);
	include 'main.php';
}else{
	include 'login.php';
}
