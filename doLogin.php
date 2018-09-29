<?php
include_once 'config.php';
include_once 'function.php';
include_once 'class.log.php';
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
	$log = new Logger();
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
		if(password_verify($pass, $password)){
			#Login OK
			$log->log('LOGIN',"User %s logged in from %s",$uname,$ip);
			$passinfo = password_get_info($password);
			if($passinfo['algo']<PASSWORD_DEFAULT){
				$log->log('LOG',"Poor hash algroithm %s used for user %s, rehash is needed.",$passinfo['algoName'],$uname);
			}else if($passinfo['algo']==PASSWORD_DEFAULT){
				if(array_key_exists('cost', $passinfo['options'])){
					if($passinfo['options']['cost']<PASSWORD_COST){
						$roundNeeded = pow(2, PASSWORD_COST - $passinfo['options']['cost']) - 1;
						for($i=0;$i<$roundNeeded;$i++){
							password_hash($pass,PASSWORD_DEFAULT, ['cost' => $passinfo['options']['cost']]);
						}
					}
				}
				$log->log('LOGIN',"Poor hash cost used for user %s, rehash is needed.",$uname);
			}
			
			$_SESSION['uid'] = $row['userId'];
			$arr['code']=0;
			header('Content-type: application/json');
			echo json_encode($arr);
			return;
		}else{
			#Login fail
			$log->log('LOGIN',"Failed login from %s for %s",$ip,$uname);
			$arr['code'] = 3;
			$arr['msg'] = 'Username/password incorrect.';
			header('Content-type: application/json');
			echo json_encode($arr);
			return;
		}
	}else{
			#Login fail
			$log->log('LOGIN',"Failed  from %s for %s(User does not exists)",$ip,$uname);
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

