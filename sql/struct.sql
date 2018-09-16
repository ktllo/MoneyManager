CREATE TABLE currency(
currencyCode CHAR(3) COLLATE latin1_general_ci NOT NULL PRIMARY KEY,
currencyName VARCHAR(500) NOT NULL,
currencySymbol VARCHAR(20) NOT NULL,
subUnitName VARCHAR(500),
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
SELECT c.currencyCode, c.currencyName, c.currencySymbol, c.subUnitName, c.subUnitSize, cr.rate, cr.updatedDate
FROM currency c JOIN currencyRate cr ON c.currencyCode = cr.currencyCode
WHERE (c.currencyCode,cr.updatedDate) IN (
	SELECT currencyCode, MAX(updatedDate) FROM currencyRate GROUP BY currencyCode
);

CREATE TABLE user(
userId INT UNSIGNED NOT NULL PRIMARY KEY auto_increment,
userName VARCHAR(64) COLLATE latin1_general_ci NOT NULL,
`password` VARCHAR(255) NOT NULL,
lastPasswordUpdate DATETIME NOT NULL,
resetFlag CHAR(1) NOT NULL,
CONSTRAINT UNIQUE KEY (userName)
);
