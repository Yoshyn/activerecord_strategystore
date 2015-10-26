module StrategyStores
  module ActiveRecord
    module Store
      extend ActiveSupport::Concern
      included do

        def self.acts_as_strategy_store(store_attribute, options={})
          use_strategy = options.delete(:use) || :default
          prefix = options.delete(:prefix) && store_attribute

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
            send_prefixed = Proc.new { |symbol| __send__(prefixed[symbol]) }

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
          define_singleton_method(prefixed[:available_strategies]) do
            str_inst_var = "@_#{prefixed[:available_strategies]}".freeze
            instance_variable_set(str_inst_var,
                instance_variable_get(str_inst_var) || begin
                StrategyStore.fetch_strategy(use_strategy).class_implementations.to_a
              end
            )
          end
          delegate prefixed[:available_strategies], to: :class

          # PRIVATE METHODS

          # Get the strategy hash from store or initialize it if not exist.
          define_method(prefixed[:initialize_or_retrive_strategy_hash]) do
            send(store_attribute)[prefixed[:strategy]] ||= HashWithIndifferentAccess.new
          end
          send(:private, prefixed[:initialize_or_retrive_strategy_hash])

          # TODO : Make possible to accept hash of parameter (accept_neested)
          #Define strategy=
        end
      end
    end
  end
end
