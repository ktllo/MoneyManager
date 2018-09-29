<?php
include_once 'config.php';
include_once 'function.php';
start_session();start_session();start_session();start_session();
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
		if(password_verify($pass, $password)){
			#Login OK
			doLog($log,'LOGIN',"User {$uname} logged in from {$ip}");
			$passinfo = password_get_info($password);
			if($passinfo['algo']<PASSWORD_DEFAULT){
				doLog($log,'LOG',"Poor hash algroithm {$passinfo['algoName']} used for user $uname, rehash is needed.");
			}else if($passinfo['algo']==PASSWORD_DEFAULT){
				if(array_key_exists('cost', $passinfo['options'])){
					if($passinfo['options']['cost']<PASSWORD_COST){
						$roundNeeded = pow(2, PASSWORD_COST - $passinfo['options']['cost']) - 1;
						for($i=0;$i<$roundNeeded;$i++){
							password_hash($pass,PASSWORD_DEFAULT, ['cost' => $passinfo['options']['cost']]);
						}
					}
				}
				doLog($log,'LOGIN',"Poor hash cost used for user $uname, rehash is needed.");
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

