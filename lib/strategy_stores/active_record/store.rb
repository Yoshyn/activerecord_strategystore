module StrategyStores
  module ActiveRecord
    module Store
      extend ActiveSupport::Concern
      included do
        def self.acts_as_strategy_store(store_attribute, options={})

          options[:accessors]     = [:strategy_class, :strategy]
          strategy_implementation = options[:strategy_implementation] || :default

          store store_attribute, options

          define_method(:initialize_or_retrive_strategy_hash) do
            send(store_attribute)[:strategy] ||= HashWithIndifferentAccess.new
          end

          define_method(:strategy) do
          # def strategy  # Does not work with ActiveSupport.on_load(:after_initialize)
            @_strategy = (!strategy_changed? && @_strategy) || begin
              strategy_class && strategy_class.new(
                self, initialize_or_retrive_strategy_hash
              )
            end
          end

          def available_strategies
            # strategy_implementation # Somethings here
          end

          # TODO : Make possible to accept hash of parameter (accept_neested)
          #Define strategy=

          define_method(:strategy_changed?) do
          # def strategy_changed? # Does not work with ActiveSupport.on_load(:after_initialize)
            strategy_class.to_s != @_strategy.class.to_s
          end

          define_method(:strategy_class) do
          # def strategy_class # Does not work with ActiveSupport.on_load(:after_initialize)
            super().to_s.safe_constantize
          end

          # TODO : Use the strategy_implementation or the default_perform_method_names
          Array.wrap(::StrategyStores.config.default_method_names).each do |method_name|
            define_method(method_name) do |*args|
              strategy.send(method_name, *args)
            end
          end
        end
      end
    end
  end
end
