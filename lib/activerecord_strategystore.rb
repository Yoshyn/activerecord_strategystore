require 'active_support'

require 'pry-byebug' # TODO : remove me

require 'strategy_store/error'
require 'strategy_store/configuration'
require 'strategy_store/implementation'
require 'strategy_store/active_record/store'

module ActiverecordStrategystore; end

ActiveSupport.on_load(:after_initialize) do
  ::ActiveRecord::Base.send :include, StrategyStores::ActiveRecord::Store
end
