----------------------------------
--changes in vendor table
----------------------------------
ALTER TABLE vendor
ADD is_favourite BOOLEAN DEFAULT false;

SELECT * FROM vendor