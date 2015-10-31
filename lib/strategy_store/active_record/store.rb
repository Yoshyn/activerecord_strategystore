module StrategyStores
  module ActiveRecord
    module Store
      extend ActiveSupport::Concern
      included do

        # Define a new strategy store and all corresponding methods.
        #
        # +strategy_store+ is the field to store the strategy.
        # +options+        Same options as store method (expect 'accessors') and :
        #   +use+    A strategy_ui_id. By default set to 'default'
        #   +prefix+ Prefix the strategy method by the store field name or by a given string
        def self.acts_as_strategy_store(store_attribute, options={})
          use_strategy = options.delete(:use) || :default
          # TODO : Refactor this into a fonction
          prefix = (op = options.delete(:prefix)) && ((op.is_a?(String) || op.is_a?(Symbol)) ? op : store_attribute)

          # Proc to return a symbol prefixed by the store_attribute if needed
          prefixed = Proc.new do |symbol|
            prefix.blank? ? symbol : "#{prefix}_#{symbol}".to_sym
          end

          store store_attribute, options.merge!(accessors: prefixed[:strategy_class])

          # Return the strategy with loaded typed attributes
          define_method(prefixed[:strategy]) do
            # Create a dynamic instance var with store_attribute
            str_inst_var = "@_#{prefixed[:strategy]}".freeze
            # Proc to to call a method prefixed by the store_attribute if needed
            send_prefixed = Proc.new { |symbol, *args| __send__(prefixed[symbol], *args) }

            # Set the instance var this existing one or create it with the begin block
            instance_variable_set(str_inst_var,
              (!send_prefixed[:strategy_changed?] && instance_variable_get(str_inst_var)) || begin
                send_prefixed[:strategy_class] && send_prefixed[:strategy_class].new(
                  self,
                  send_prefixed[:initialize_or_retrive_strategy_hash]
                )
              end
            )
          end

          # Return true if the strategy has changed?
          define_method(prefixed[:strategy_changed?]) do
            __send__(prefixed[:strategy_class]) != instance_variable_get("@_#{prefixed[:strategy]}".freeze).class
          end

          # Return the strategy constantized
          define_method(prefixed[:strategy_class]) do
            super().to_s.safe_constantize
          end

          # Return the list of available strategies for this model field
          # TODO : rename strategies
          define_singleton_method(prefixed[:strategies]) do
            str_inst_var = "@_#{prefixed[:strategies]}".freeze
            instance_variable_set(str_inst_var,
                instance_variable_get(str_inst_var) || begin
                StrategyStore.fetch_strategy(use_strategy).class_implementations.to_a
              end
            )
          end
          delegate prefixed[:strategies], to: :class

          # Make possible to accept hash of parameter like accept_neested_attributes
          define_method(prefixed[:strategy_attributes=]) do |attributes|
            _strategy = __send__(prefixed[:strategy])
            assignable_attributes = attributes.slice(*_strategy.columns.keys)
            assignable_attributes.each do |attr_name, value|
              _strategy.send("#{attr_name}=", value)
            end
          end

          # PRIVATE METHODS
          # Get the strategy hash from store or initialize it if not exist.
          define_method(prefixed[:initialize_or_retrive_strategy_hash]) do
            __send__(store_attribute)[prefixed[:strategy]] ||= HashWithIndifferentAccess.new
          end
          __send__(:private, prefixed[:initialize_or_retrive_strategy_hash])
        end
      end
    end
  end
end
