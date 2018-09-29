<?php
include_once 'config.php';
include_once 'function.php';
start_session();
unset($_SESSION['uid']);
if(!array_key_exists('uname',$_POST)||!array_key_exists('pass',$_POST)){
	$arr['code'] = 1;
	$arr['msg'] = 'Invalid request. Please consult API documnet.';
	header('Content-type: application/json');
	echo json_encode($arr);
	return;
}
if (!empty($_SERVER['HTTP_CLIENT_IP'])) {
    $ip = $_SERVER['HTTP_CLIENT_IP'];
} elseif (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) {
    $ip = $_SERVER['HTTP_X_FORWARDED_FOR'];
} else {
    $ip = $_SERVER['REMOTE_ADDR'];
}
$uname = $_POST['uname'];
$pass = $_POST['pass'];
try{
	$db = getDBConn();
	$sql = 'SELECT `userId`, `userName`, `password` FROM `user` WHERE `username`=?';
	$log = getLog($db);
	$stmt = $db->prepare($sql);
	if(!$stmt->execute(array($uname))){
		$arr['code'] = 2;
		$arr['msg'] = 'Databse error.';
		header('Content-type: application/json');
		echo json_encode($arr);
		return;
	}
	$row = $stmt->fetch(PDO::FETCH_ASSOC);
	if($row){
		$password = $row['password'];
		if(password_verify($c, $password)){
			#Login OK
			doLog($log,'LOGIN',"User {$uname} logged in from {$ip}");
			if(password_needs_rehash($password, PASSWORD_DEFAULT, ['cost' => PASSWORD_COST])){
				doLog($log, 'SECURITY', "Password for user {$uname} need rehash.");
			}
			
			$_SESSION['uid'] = $row['userId'];
			$arr['code']=0;
			header('Content-type: application/json');
			echo json_encode($arr);
			return;
		}else{
			#Login fail
			doLog($log,'LOGIN',"Failed login from {$ip} for $uname");
			$arr['code'] = 3;
			$arr['msg'] = 'Username/password incorrect.';
			header('Content-type: application/json');
			echo json_encode($arr);
			return;
		}
	}else{
			#Login fail
			doLog($log,'LOGIN',"Failed  from {$ip} for $uname(User does not exists)");
			password_hash($pass,PASSWORD_DEFAULT, ['cost' => PASSWORD_COST]);
			$arr['code'] = 3;
			$arr['msg'] = 'Username/password incorrect.';
			header('Content-type: application/json');
			echo json_encode($arr);
			return;
		}
}catch(PDOException $e){
	$arr['code'] = 2;
	$arr['msg'] = 'Databse error.';
	header('Content-type: application/json');
	echo json_encode($arr);
	return;
}

