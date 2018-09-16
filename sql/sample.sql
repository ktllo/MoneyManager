-- Create default user root with password P@ssw0rd

INSERT INTO user VALUES (1,'root','$2y$12$m3SGOkI16vVQja09Pwsiue/zKiJg6.sLyqDRAgs8mbOWn9zBhxE92','1970-01-01 00:00:00','Y');
INSERT INTO role VALUES( 'ADMIN' , 'System administrator');
INSERT INTO userRole VALUES (1,'ADMIN');
