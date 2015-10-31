# ActiveRecord::StrategyStore

[![Code Climate](https://codeclimate.com/github/byroot/activerecord-typedstore.png)](https://codeclimate.com/github/Yoshyn/activerecord_strategystore)

[ActiveRecord::StrategyStore](http://api.rubyonrails.org/classes/ActiveRecord/Store.html) ActiveRecord::Store with various casted fields in order to perform a strategy.


## Installation

Add this line to your application's Gemfile:

    gem 'activerecord-strategystore', git: 'git://github.com//Yoshyn/activerecord_strategystore.git'
    -> TODO : make this possible
    gem 'activerecord-strategystore'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install activerecord-strategystore

## Usage

It works like [ActiveRecord::Store documentation](http://api.rubyonrails.org/classes/ActiveRecord/Store.html) and then you declare your attributes into your strategy.

```ruby
# == Schema Information
# Table name: software
#  id          :integer not null, primary key
#  name        :string
#  settings    :text
class Sofware
  acts_as_strategy_store(:settings)
end

class FirstSoftwareStrategy
  include ::StrategyStore::Strategy::Implementation

  strategy_columns do |s|
    s.string  :code, null: false, default: 'first_code'
    s.integer :num,  null: false, default: 0
    s.boolean :bool, null: false, default: false
  end

  def perform(*args)
    return "#{self.name} #{code} #{num} #{bool} #{args}"
  end
end

class SecondSoftwareStrategy
  include ::StrategyStore::Strategy::Implementation

  strategy_columns do |s|
    s.string  :code, null: false, default: 'second_code'
  end
end

soft = Sofware.create(name: 'Sofware1')
soft.strategy                         # nil
soft.strategies             # [FirstSoftwareStrategy, SecondSoftwareStrategy]

soft.strategy = FirstSoftwareStrategy # Can also be setted with string

soft.strategy.perform(1) # => "FirstSoftwareStrategy first_code 0 false [1]"

soft.strategy.code = 'new_code'
soft.strategy.bool = '1'
soft.strategy.bool # True

soft.save
soft.reload!
soft.perform(2,3)     # => "FirstSoftwareStrategy new_code 0 true [2,3]"

soft.strategy = SecondSoftwareStrategy
soft.strategy.perform # => raise NotImplementedError
```

## Use anothers method(s) than perform :

To define other methods that must be performed by your strategy, you need to set the default_strategy_methods configuration variable in an initializer.

```ruby
StrategyStore.configure do |config|
  config.default_strategy_methods = [:process, :run]
end
```

Then you need to defined theses methods in your strategy :

```ruby
class FirstSoftwareStrategy
  include ::StrategyStore::Strategy::Implementation
  strategy_columns do /* ... */ end

  def perform(*args); /*...*/ end
  def run(*args); /*...*/ end
end
``

## Run several different strategy :

If you need to use several time these gems in your project (several strategy in one model or several strategy for several model), You probably want to avoid have the full list of strategies that include StrategyStore::Implementation.

In order to avoid this, you will have to register manualy your strategy in an initializer like this :

```ruby
StrategyStore.config.register_strategy(:software) do |s|
  s.strategy_methods      = [:process] # By default use perform
end

class OtherModelRelatedStrategy
  include ::StrategyStore::Strategy::Implementation
  strategy_columns_for(:software) do |s|
  end
  def perform(*args); end
end

class Sofware
  acts_as_strategy_store(:settings, use: :software)
end

soft.strategies  # [FirstSoftwareStrategy, SecondSoftwareStrategy]

StrategyStore.config.fetch_strategy(:software) # Return StrategyDefinition

```

## TODO :
-> Make a dynamic strategy form (with possibility to simple_form) ?
-> Make a controller with Ajax call ?
-> Let the possibility to load the view & controller in the configuration

