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
