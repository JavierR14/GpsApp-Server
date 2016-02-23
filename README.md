# GpsApp-Server

Setup for Postgres locally on Mac OS X
* brew update
	* if homebrew doesn't work, it's prob an issue with el capitan, google it.
* brew doctor
	* fix any issues reported
* brew install postgresql
* initdb /usr/local/var/postgres -E utf8
* gem install lunchy
	* helpful gem that allows you to easily start and stop postgres
* mkdir -p ~/Library/LaunchAgents
* cp /usr/local/Cellar/postgresql/9.2.1/homebrew.mxcl.postgresql.plist ~/Library/LaunchAgents/

Now ready:
* lunchy start postgres
	* to start postgres, you should now be able to run the rake commands to create database
* lunchy stop postgres
	* to stop postgres

Rake command to create database:
* rake db:create db:migrate

Postgres
* psql
	* to start the postgres console
* \list
	* to view psql dbs on local machine
* \connect db_name
	* to connect to a database
* \dt
	* to view tables in database
* \d table_name
	* to view columns and propertie of table
* \q
	* to quit postgres
* bin/rails generate migration MigrationName
	* to generate a migration (change to db) in root of folder
	* more on migrations here: http://guides.rubyonrails.org/active_record_migrations.html
* rake db:migrate
	* to update db after new migration file is created

SQL
* INSERT INTO persons (fname, lname, email) VALUES ('Jitin','Dodd','jitindodd@gmail.com');
	* example of inserting fake data into table
* SELECT * FROM table_name;
	* view data in a table
* ALTER TABLE "locations" ADD CONSTRAINT "bid_fk" FOREIGN KEY ("bid") REFERENCES "persons"(id);
	* Example showing how to add a foreign key to a column