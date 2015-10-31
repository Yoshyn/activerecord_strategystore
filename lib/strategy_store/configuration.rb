require 'set'

module StrategyStore

  # Class to register a strategy
  class StrategyDSL

    ATTRIBUTES = [:strategy_methods, :class_implementations]
    attr_reader *(ATTRIBUTES + [:ui_id])

    def initialize(strategy_ui_id)
      @ui_id                 = strategy_ui_id
      @class_implementations = Set.new
      if block_given?
        yield self
      else
        @strategy_methods = StrategyStore.config.default_strategy_methods
      end
    end

    def ui_id; @ui_id; end

    def strategy_methods=(value);  @strategy_methods = Array.wrap(value); end
    def add_implementation(klass); @class_implementations.add(klass);     end
  end

  # StrategyStore global configuration
  class Configuration
    def initialize
      @registered_strategies ||= HashWithIndifferentAccess.new
      default_strategy
    end

    def register_strategy(strategy_ui_id, &block)
      raise StrategyStore::StrategyAlreadyRegister.new(self) if @registered_strategies[strategy_ui_id]
      @registered_strategies[strategy_ui_id] = StrategyStore::StrategyDSL.new(strategy_ui_id, &block)
    end

    def fetch_strategy(strategy_ui_id)
      # TODO : Do not raise error here, just warning a message that the strategy is not registered in initialize
      raise StrategyStore::StrategyMissing.new(strategy_ui_id) unless @registered_strategies[strategy_ui_id]
      @registered_strategies[strategy_ui_id]
    end

    StrategyStore::StrategyDSL::ATTRIBUTES.each do |attribute|
      define_method("default_#{attribute}")  { default_strategy.send(attribute) }
      define_method("default_#{attribute}=") { |value| default_strategy.send("#{attribute}=", value) }
    end

    protected
    def default_strategy
      @_default_strategy ||= register_strategy(:default) do |strategy|
        strategy.strategy_methods = [:perform]
      end
    end
  end

  class << self
    attr_accessor :configuration
    alias_method :config, :configuration

    def fetch_strategy(strategy_ui_id)
      config.fetch_strategy(strategy_ui_id)
    end

    def register_strategy(strategy_ui_id)
      config.register_strategy(strategy_ui_id)
    end
  end

  @configuration ||= Configuration.new

  def self.configure
    yield(@configuration)
  end
end
