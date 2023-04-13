# Chitter-DMs

## Database instructions
 To start create 2 local databases, one called 'chitter-dms' and the other 'chitter-dms-test'

 ```sh
 createdb chitter-dms
 createdb chitter-dms-test
 ```

 Then, to create and populate the tables run the following:

 ```sh
psql -h 127.0.0.1 chitter-dms < spec/create_tables.sql
psql -h 127.0.0.1 chitter-dms < spec/seeds.sql
psql -h 127.0.0.1 chitter-dms-test < spec/create_tables.sql
psql -h 127.0.0.1 chitter-dms-test < spec/seeds.sql
 ```
  
