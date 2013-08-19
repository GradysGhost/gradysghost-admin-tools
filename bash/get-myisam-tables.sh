#!/bin/bash

mysql -Be '
	SELECT
		CONCAT(
			`TABLE_SCHEMA`,
			".",
			`TABLE_NAME`
		) AS `TABLE`
	FROM
		`information_schema`.`TABLES`
	WHERE
		`TABLE_SCHEMA` NOT IN (
			"mysql",
			"information_schema",
			"performance_schema"
		) AND
		`ENGINE` = "MyISAM"
	ORDER BY
		`TABLE_SCHEMA`,
		`TABLE_NAME`
'
