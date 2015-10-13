# StrategyStores.configuration.register_strategy_implementation do |rsi|
#   rsi.definition_path = 'XXX'
#   rsi.method_names = 'XXX'
#   # Maybe one day...
#   #rsi.methods = {
#   #   perform_method_1: Proc.new { |arg1, arg2| },
#   #   perform_method_2: Proc.new { |arg1, arg2| }
#   # }
# end

module StrategyStores
  class Configuration

    class DSL

      ATTRIBUTES = [:definition_path, :file_suffix, :method_names]
      attr_accessor *ATTRIBUTES

      def initialize
        yield self
      end
    end

    def initialize
      @registered_strategies ||= HashWithIndifferentAccess.new
      default_strategy
    end

    def register_strategy(strategy_name, &block)
      @registered_strategies[strategy_name] = DSL.new(&block)
    end

    def strategy(strategy_name)
      @registered_strategies[strategy_name] || default_strategy
    end

    DSL::ATTRIBUTES.each do |attribute|
      define_method("default_#{attribute}") do
        default_strategy.send(attribute)
      end
      define_method("default_#{attribute}=") do |value|
        default_strategy.send("#{attribute}=", value)
      end
    end

    protected
    def default_strategy
      @_default_strategy ||= begin
        register_strategy('default') do |strategy|
          strategy.definition_path   = nil # TODO Accept a proc here to make possible to use Rails.root
          strategy.method_names      = :perform
          strategy.file_suffix       = 'strategy'
        end
      end
    end
  end

  class << self
    attr_accessor :configuration
    alias_method :config, :configuration
  end

  @configuration ||= Configuration.new

  def self.configure
    yield(@configuration)
  end
end
