module StrategyStore
  # Base class for all StrategyStore errors.
  class Error < StandardError
  end

  class StrategyAlreadyRegister < Error
    def initialize(context)
      super("A strategy was already defined for #{context.class}")
    end
  end

  class StrategyAlreadyImplemented < Error
    def initialize(context)
      super("A strategy is already implemented for #{context.class}")
    end
  end

  class StrategyMissing < Error
    def initialize(strategy_ui_id)
      super("The Strategy #{strategy_ui_id} does not exist. You have to register it in your model or in an initializer!")
    end
  end
end
