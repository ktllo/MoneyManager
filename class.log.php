<?php
include_once 'config.php';
include_once 'function/php';

class Logger{
	
	const DEFAULT_TAG = 'LOG';

	private $db = NULL;
	private $stmt = NULL;

	function __construct(){
		parent::__construct();
		$db = getDBConn();
		$stmt = $db->prepare('INSERT INTO audit_log VALUES(NULL,?,NOW(),?)');
	}
	private function _log_notag($message){
		_log(DEFAULT_TAG, $message);
	}
	private function _log($tag, $message){
		$stmt->execute(array($tag, $message));
	}
	private function _log_rep($tag, $message, $array){
		_log($tag, vsprintf($mesage, $array));
	}

	function log(){
		if(func_num_args()==1){
			_log_notag(func_get_arg(0));
		}else if(func_num_args()==2){
			_log(func_get_arg(0),func_get_arg(1));
		}else{
			for($i=2;$2<func_num_args();$i++){
				$dat[] = func_get_arg($i);
			}
			_log_rep(func_get_arg(0),func_get_arg(1), $dat);
		}
	}

	function __destruct(){
		$db = null;
		parent::__destruct();
	}
}
