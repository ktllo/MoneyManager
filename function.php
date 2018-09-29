<?php
include_once 'config.php';

function start_session(){
	if (session_status() == PHP_SESSION_NONE) {
		session_start();
	}
}

function isLogin(){
	start_session();
	return isset($_SESSION['uid']);
}

function getDBConn(){
return new PDO("mysql:host=".DB_PATH.";dbname=".DB_NAME, DB_USER, DB_PASS,array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
}




