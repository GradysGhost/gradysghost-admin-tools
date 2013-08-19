#!/bin/bash

mysql -Be "
	SELECT
		`TABLE_SCHEMA`,
		`TABLE_NAME`
	FROM
		`information_schema`.`TABLES`
	WHERE
		`TABLE_SCHEMA` NOT IN (
			'mysql',
			'information_schema',
			'performance_schema'
		) AND
		`ENGINE` = 'MyISAM'
	ORDER BY
		`TABLE_SCHEMA`,
		`TABLE_NAME`
"
