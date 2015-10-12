class Software < ActiveRecord::Base
  acts_as_strategy_store(:settings)
end
