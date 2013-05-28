#!/bin/bash

SCHEMA=$1

mysql -Be "USE $SCHEMA;" &> /dev/null
EXITCODE=$?
if [ $EXITCODE -eq 0 ]; then
        QUERY="USE \`information_schema\`; SELECT \`table_name\` FROM \`TABLES\` WHERE \`table_schema\` = \"$SCHEMA\" AND \`engine\`='MyISAM';"
        mysql information_schema --skip-column-names -Be "$QUERY" > /tmp/myisamdbs
        while read TABLE; do
                echo "Converting table $TABLE..."
                mysql $SCHEMA -Be "ALTER TABLE $TABLE ENGINE=InnoDB;"
                if [ $? -eq 0 ]; then
                        echo "Table $TABLE converted successfully."
                else
                        echo "Could not convert table $TABLE."
                fi
        done < /tmp/myisamdbs
else
        echo "Could not access schema $SCHEMA."
fi
