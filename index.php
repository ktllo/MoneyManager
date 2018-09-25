<?php
include_once 'config.php';
include_once 'function.php';
if(isLogin()){
	include 'main.php';
}else{
	include 'login.php';
}
