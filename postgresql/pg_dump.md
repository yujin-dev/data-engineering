
## Dump only source data
```bash
pg_dump -h $SOURCE_SERVER -p 5432 -U postgres -d my_database --table 'my_schema.my_table' --data-only -F t > my_table.tar
```

```bash
pg_dump -h $SOURCE_SERVER -p 5432 -U postgres -d my_database --table 'my_schema.my_table' --data-only > my_table.sql
```
### Result
```
-rw-r--r--   1 root root 69328896 Sep 18 12:19 my_table.tar
-rw-r--r--   1 root root 69323663 Sep 18 12:26 my_table.sql
```
- less size in sql dump file

## Restore
```bash
psql -h $TARGET_SERVER -p 5432 -U postgres -d my_database -f my_table.sql
```
- you should check restoring data with `my_table.tar` file by `pg_restore`

### Result
```
psql -h $SOURCE_SERVER -p 5432 -U postgres -d my_database -c "select count(*) from my_schema.my_table;"
 count  
--------
 166857
(1 row)

psql -h $TARGET_SERVER -p 5432 -U postgres -d my_database -c "select count(*) from my_schema.my_table;"
Password for user postgres: 
 count  
--------
 166857
(1 row)
```

## Directly copy data
```bash
pg_dump -h $SOURCE_SERVER -p 5432 -U postgres -d my_database --data-only | psql -h $TARGET_SERVER -p 5432 -U postgres -d my_database
```

---

## Reference
- [Genrating Postgres dump and saving to another server](https://stackoverflow.com/questions/66356435/genrating-postgres-dump-and-saving-to-another-server)