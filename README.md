# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
* ...
* ...


* convert html tags with classes

    + use regex query
    
            <\s*(.*) class="\s*(.*)">                 

    + replace with 
 
            %$1.$2



* replace erb interpolation 

    + use regex query +
            
            <%=?\s*(.*) %>

    + replace with
    
            =- $1