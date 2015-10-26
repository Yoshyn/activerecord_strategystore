class Software < ActiveRecord::Base
  acts_as_strategy_store(:settings, use: :software_strategy)

  acts_as_strategy_store(:other_settings, use: :other_strategy, prefix: true)
end
