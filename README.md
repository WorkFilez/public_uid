# PublicUid

[![Build Status](https://travis-ci.org/equivalent/public_uid.svg?branch=master)](https://travis-ci.org/equivalent/public_uid)
[![Code Climate](https://codeclimate.com/github/equivalent/public_uid.png)](https://codeclimate.com/github/equivalent/public_uid)


Generates random string (or random number) to represent public unique
record identifier.

### `public_uid` vs `record.id`

Let say you're building social network or business dashboard.

If you publicly display your *record ids* as an unique identificator for
accessing your records (as a part of HTML url or in JSON) it's easy to
 estimate how many records (users, clients, messages, orders,...) you have
in the database. Marketing of rival companies may use this information
against you.

This is bad: 

    http://www.eq8.eu/orders/12/edit
    http://www.eq8.eu/orders/12-order-for-mouse-and-keyboard/edit

However if you generate random unique identifier and use that as a public
identifier, you won't have to worry about that.

This is how it should be: 

    http://www.eq8.eu/orders/8395820/edit
    http://www.eq8.eu/orders/8395820-order-for-mouse-and-keyboard/edit
    http://www.eq8.eu/orders/abaoeule/edit
    http://www.eq8.eu/orders/aZc3/edit

So keep `record.id` for your internal relationships and show `public_id`
to the world :smile:

## Installation

Add this line to your application's Gemfile:

    gem 'public_uid'

And then execute:

    $ bundle


## Usage

Create database column for public unique ID.

```ruby
class AddPublicUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_uid, :string
  end
end
```

Tell your model to generate the public identifier

```ruby
class User < ActiveRecord::Base
  generate_public_uid
end
```

This will automatically generate unique 8 char downcase string for 
column `public_uid`. 


```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> "aeuhsthi"
```

Then you can do more clever things like having urls based on `public_uid` and `title` (http://blog.teamtreehouse.com/creating-vanity-urls-in-rails)

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  generate_public_uid

  def self.find_param(param)
    find_by! public_uid: param.split('-').first
  end
  
  def to_param
    "#{public_uid}-#{tile.gsub(/\s/,'-'}"
  end
end
 
# app/controllers/users_controller.rb
class UsersController < ActionController::Base
  # ...
  def show
    @user = User.find_param(param[:id])
    # ...
  end
  # ...
end
```


If you want to use different column just specify column option:

```ruby
class User < ActiveRecord::Base
  generate_public_uid column: :guid
end
```

```irb
u = User.new
u.guid  #=> nil
u.save! #=> true
u.guid  #=> "troxuroh"
```

If you want to generate random Integer you can use built-in number 
generator:

```ruby
class User < ActiveRecord::Base
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 4567123
```

**Note** Warning **PostgreSQL** have built in type safety meaning that this
generator wont work if your public uniq ID column is a String (as the
gem would try to set Integer on a String). If you really want a number
like string you can specify number range for Range String Generator

### Customizing generated string

```ruby
class User < ActiveRecord::Base
  UID_RANGE = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
  generate_public_uid generator: PublicUid::Generators::RangeString.new(4, UID_RANGE)
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> "aZ3e"
```

To generate number format String you can specify number range 

```
class User < ActiveRecord::Base
  UID_RANGE = ('1'..'9').to_a
  generate_public_uid generator: PublicUid::Generators::RangeString.new(4, UID_RANGE)
end

# User.create.public_uid  == "1234"
```

### Customizing randomized number 

```ruby
class User < ActiveRecord::Base
  UID_RANGE = 1_000..4_000
  generate_public_uid generator: PublicUid::Generators::NumberRandom.new(UID_RANGE)
end
```

```irb
u = User.new
u.public_uid  #=> nil
u.save!       #=> true
u.public_uid  #=> 2398
```

### Rails rake task

By using this gem you will automatically gain rake task `rake public_uid:generate`
in your Rails application which will generate `public_uid` on the tables
using `public_uid` on records where `public_uid == nil`.

This is helpfull to generate `public_uid` on pre-existing recrods.

```
rake public_uid:generate

Model EntityApplication: generating public_uids for missing records
  * generating 0 public_uid(s)

Model ValidationFormField: generating public_uids for missing records
  * generating 133 public_uid(s)

Model ValidationType: generating public_uids for missing records
  * generating 0 public_uid(s)
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
