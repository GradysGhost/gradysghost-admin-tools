#!/bin/bash
mysql -Be "SELECT count(*) tables, concat(round(sum(table_rows)/1000000,2),'M') rows, concat(round(sum(data_length)/(1024*1024),2),'M') data, concat(round(sum(index_length)/(1024*1024),2),'M') idx, concat(round(sum(data_length+index_length)/(1024*1024),2),'M') total_size, round(sum(index_length)/sum(data_length),2) idxfrac FROM information_schema.TABLES\G"
