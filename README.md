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
  
# Flash Messages

Flash messages will dispay error/success messages dynamically dependant on the error it encounters and disply them at the top of the page.

require in gemfile and update

```ruby
gem 'sinatra-flash'
```

add this line in the configure block of your application controller

```ruby
register Sinatra::Flash
```

## Add to top of the erb page in the body (or wherever you would like to render it).

```ruby
<% flash.each do |type, message| %>
  <div data-alert class="flash <%= type %> alert-box radius">
    <%= message %>
    <a href="" class="close">&times;</a>
  </div>
```

## In the app file, in the route block add this line when you want to render a message.

```ruby
flash[:success] = "You have successfully logged in."
```

the 'flash' variable acts like a hash with key value pairs and will display the relevant message/s.
