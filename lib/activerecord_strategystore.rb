require 'active_support'

require 'strategy_stores/configuration'
require 'strategy_stores/strategy'
require 'strategy_stores/active_record/store'

module ActiverecordStrategystore; end

ActiveSupport.on_load(:after_initialize) do
  ::StrategyStores::Strategy.send(:register_strategies)
  ::ActiveRecord::Base.send :include, StrategyStores::ActiveRecord::Store
end
