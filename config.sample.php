<?php
define('DEBUG_MODE',false);

define('DB_PATH','localhost');
define('DB_USER','mm');
define('DB_PASS','password');
define('DB_NAME','moneymanager');
#The random ID can be generated using the output of the following link
#Please remove space from he generated output.
#https://www.random.org/strings/?num=2&len=14&digits=on&loweralpha=on&unique=on&format=plain&rnd=new
#Please remove the follow line after replacing the value of NODE_ID and BNODE_ID
die('Please read though the config.php');
define('NODE_ID','71f7an6z0mnf8x');
define('BNODE_ID','yw113hqngxd7j9');

#The higher the password cost, the long it takes for login, but it will slow
#down the brute force attacks
define('PASSWORD_COST',12);

#The API key for Aplha Vantage
#Please obtain the api key from https://www.alphavantage.co/support/#api-key
#Please remove the follow line after replacing the value of AV_API_KEY
die('Please read though the config.php');
define('AV_API_KEY','demo');
