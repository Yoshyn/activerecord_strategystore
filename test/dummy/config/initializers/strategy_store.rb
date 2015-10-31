StrategyStore.configure do |config|
  # config.default_strategy_methods = [:process, :run]

  config.register_strategy(:software_strategy) do |strategy|
    strategy.strategy_methods = [:perform_process_1, :perform_process_2]
  end

  config.register_strategy(:other_strategy) do |strategy|
    strategy.strategy_methods = [:process, :run]
  end

  config.register_strategy(:my_amazing_strategy)

  config.register_strategy(:empty_strategy)
end

require 'first_software_strategy'
require 'second_software_strategy'

require 'other_strategy'
require 'default_strategy'
