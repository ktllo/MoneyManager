CREATE TABLE currency(
currencyCode CHAR(3) COLLATE latin1_general_ci NOT NULL PRIMARY KEY,
currencyName VARCHAR(500) NOT NULL,
subUnitSize DECIMAL(8)
);

CREATE TABLE currencyRate(
currencyCode CHAR(3) COLLATE latin1_general_ci NOT NULL,
updatedDate DATETIME NOT NULL,
rate DECIMAL(12,4) NOT NULL,
CONSTRAINT PRIMARY KEY (currencyCode, updatedDate),
CONSTRAINT FOREIGN KEY (currencyCode) REFERENCES currency(currencyCode) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE OR REPLACE VIEW vw_current_currency_rate AS
SELECT c.currencyCode, c.currencyName, c.subUnitSize, cr.rate, cr.updatedDate
FROM currency c LEFT OUTER JOIN currencyRate cr ON c.currencyCode = cr.currencyCode
WHERE (c.currencyCode,cr.updatedDate) IN (
	SELECT currencyCode, MAX(updatedDate) FROM currencyRate GROUP BY currencyCode
) OR cr.currencyCode IS NULL;

CREATE TABLE user(
userId INT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
userName VARCHAR(64) COLLATE latin1_general_ci NOT NULL,
`password` VARCHAR(255) NOT NULL,
lastPasswordUpdate DATETIME NOT NULL,
resetFlag CHAR(1) NOT NULL,
CONSTRAINT UNIQUE KEY (userName)
);

CREATE TABLE role(
roleName VARCHAR(20) COLLATE latin1_general_ci NOT NULL PRIMARY KEY,
roleDescription TEXT NOT NULL
);

CREATE TABLE userRole(
userId INT UNSIGNED NOT NULL,
roleName VARCHAR(20) COLLATE latin1_general_ci NOT NULL,
CONSTRAINT PRIMARY KEY (userId, roleName),
CONSTRAINT FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FOREIGN KEY (roleName) REFERENCES role(roleName) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE apiKeys(
apiKey CHAR(86) COLLATE latin1_bin NOT NULL PRIMARY KEY,
userId INT UNSIGNED NOT NULL,
keyName TEXT NOT NULL,
CONSTRAINT FOREIGN KEY (userId) REFERENCES user(userId) ON DELETE CASCADE ON UPDATE CASCADE
);
