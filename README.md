# Active Storage Database

This is `ActiveStorage` engine that allows storing files inside the database.

While storing files on the external services such as `S3, GCS, Azure` is usually better approach, but better approach also
depends on the context.

There is a group of applications that do store the files, but not a lot of files or they are installed on-premises without
access to these public services.

This project is aimed more for those type of apps, if you store TBs of files then you should probabbly look into other solutions.


# How it works

Every file is stored inside the `activestorage_database_files` table as a `binary/bytea`.
Since PostgreSQL can't store values that span multiple pages(8kb), binaries will probabbly be stored inside the TOAST table,
which allows for quick table scan and leaves the main table(`activestorage_database_files`) slim.

**NOTE**: Max size of TOST tuple in PG is 1GB


Engine will use your `ActiveRecord` database connection.


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'activestorage_database'
```

Install and run the migrations:
```
bin/rails activestorage_database:install:migrations
bin/rails db:migrate
```

Configure database service:
```yml
# config/storage.yml

database:
  service: Database
```

```ruby
config.active_storage.service = :database
```

```ruby
# config/routes.rb
Rails.application.routes.draw do
  mount ActivestorageDB::Engine => '/activestorage_database'
  ...
end
```


After the setup you can work with ActiveStorge API as if it was any other `ActiveStorage` service.


## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
