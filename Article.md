# SQL-ARTICLES
You can read MS SQL Articles

Hello dears.
I am going to talk about MS SQL MERGE STATEMENT.The main purpose of the MERGE is matching the SOURCE and TARGET table.
For example: Lets imagine that you have a TEMP non-transactional table and every day you insert the DATAs to that TEMP table with
a stored procedure.So you need that to prevent the re-INSERTING of existing DATAs from transactional SOURCE table TO
non-transactional DESTINATION TEMP table.
In this situation the MERGE STATEMENT helps us.


1)
Lets create the SOURCE AND TARGET table together.

     ##
     if OBJECT_ID('tempdb.dbo.##Source_Table', 'U') is not null
     drop table ##Source_Table;
     create table ##Source_Table (account_no varchar(12),amount numeric (18,4),date_transaction datetime);

     ##
    insert into ##Source_Table values
    ('AA111','17.85','2020-08-22'),
    ('BB222','90.00','2020-08-25'),
    ('CC333','300.55','2020-07-01'),
    ('DD444','1000.00','2020-09-20')

  --select * INTO ##Target_Table from ##Source_Table    We can create Table and insert ##Source_Table data's to ##Target_Table with SELECT INTO


    ## 
    Now our #Source_Table and ##Target_Table dates are equal.
    select * from ##Source_Table
    select * from ##Target_Table

 2)

 Lets imagine that the ##Source_Table ia a transactional table and new event occured the new rows inserted.(For example by front application)
 But we are going to insert new datas to ##Source_Table manually.
 
     ##
    insert into ##Source_Table values
    ('AA111','38.22','2020-08-25'),
    ('BB222','55.50','2020-09-30');

  Now the ##Source_Table rows is not equal to ##Target_Table
  We need INSERT only the new inserted rows to ##Target_Table from ##Source_Table

	If we use the code below then all the data will insert to ##Target_Table from ##Source_Table even there are already same datas in
	 ##Target_Table table
    insert   into ##Target_Table
    select * from ##Source_Table

  But we do not want to insert dublicate values from ##Source_Table..We need insert only new inserted new rows of ##Source_Table to ##Target_Table.
  In this case the MERGE helps us.
  Lets create the MERGE statement and insert new datas to ##Target_Table from ##Source_Table
   
     ##
     Merge  ##Target_Table tt
     using ##Source_Table st
     on st.[account_no]=tt.[account_no] and st.[amount] = tt.[amount] and st.[date_transaction] = tt.[date_transaction]
     when NOT MATCHED BY TARGET
     then
     insert ( [account_no],[amount] ,[date_transaction])
     values (st.[account_no], st.[amount] , st.[date_transaction]);


  The code above help us to insert only new inserted datas of ##Source_Table to ##Target_Table







