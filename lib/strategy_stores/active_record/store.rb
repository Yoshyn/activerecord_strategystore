module StrategyStores
  module ActiveRecord
    module Store
      extend ActiveSupport::Concern
      included do
        # TODO : Add an option strategy_reference|name
        # DO the same in Strategy class with class_attribute
        def self.acts_as_strategy_store(store_attribute, options={})
          options[:accessors] = [:strategy_class, :strategy]
          store store_attribute, options

          define_method(:initialize_or_retrive_strategy_hash) do
            send(store_attribute)[:strategy] ||= HashWithIndifferentAccess.new
          end

          define_method(:strategy) do
          # def strategy  # Does not work with ActiveSupport.on_load(:after_initialize)
            @_strategy = (!strategy_changed? && @_strategy) || begin
              strategy_class && strategy_class.new(self, initialize_or_retrive_strategy_hash)
            end
          end

          # TODO : Make possible to accept hash of parameter
          #Define strategy=

          define_method(:strategy_changed?) do
          # def strategy_changed? # Does not work with ActiveSupport.on_load(:after_initialize)
            strategy_class.to_s != @_strategy.class.to_s
          end

          define_method(:strategy_class) do
          # def strategy_class # Does not work with ActiveSupport.on_load(:after_initialize)
            super().to_s.safe_constantize
          end

          Array.wrap(::StrategyStores.configuration.perform_method_names).each do |perform_method_name|
            define_method(perform_method_name) do |*args|
              strategy.send(perform_method_name, *args)
            end
          end
        end
      end
    end
  end
end
