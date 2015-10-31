require 'strategy_store/strategy/accessor_hash'
require 'strategy_store/strategy/column'
require 'strategy_store/strategy/dsl'

module StrategyStore
  module Implementation
    extend ActiveSupport::Concern

    included do
      include ActiveModel::Dirty
      include ActiveModel::Serialization

      class_attribute :columns,              instance_accessor: false
      class_attribute :implemented_strategy, instance_accessor: false
    end

    class_methods do

      def register_as_strategy(strategy_ui_id)
        raise StrategyStore::StrategyAlreadyImplemented.new(self) if self.implemented_strategy
        self.implemented_strategy = StrategyStore.fetch_strategy(strategy_ui_id)
        self.implemented_strategy.add_implementation(self)
      end

      def strategy_columns(&block); strategy_columns_for(:default, &block); end

      def strategy_columns_for(implemented_strategy, &block)
        register_as_strategy(implemented_strategy)
        dsl = ::StrategyStore::Strategy::DSL.new(&block)
        register_columns(dsl.columns)
        generate_strategy_accessors
        generate_abstract_strategy_method
      end

      private

      def register_columns(attr_columns)
        self.columns ||= {}
        self.columns.merge!(attr_columns.index_by(&:name))
        # TODO - rpc : Define a AccessorHash with the columns
        # accessor_hash_class = AccessorHash.create(columns)
        # const_set("#{name}_accessor_hash".camelize, accessor_hash_class)
      end

      # Generate the abstract method of the strategy that are defined in the strategy_columns yield
      def generate_strategy_accessors

        attributes = []
        columns.keys.each do |column_name|
          attributes << column_name

          self.send(:define_attribute_methods, column_name)
          self.send(:define_method, column_name) { @strategy_hash[column_name] }
          self.send(:define_method, "#{column_name}=") do |value|
            send("#{column_name}_will_change!") unless value == instance_variable_get("@_#{column_name}")
            @strategy_hash[column_name] = value
          end
        end

        self.send(:define_method, :attributes) do
          Hash[attributes.map { |name, _| [name, send(name)] }]
        end
      end

      # Generate the abstract method of the strategy that are defined in the configuration
      def generate_abstract_strategy_method
        implemented_strategy.strategy_methods.each do |method|
          # TODO : in case of inherited strategy. Do not override the method
          # TODO : Must be tested
          unless self.respond_to?(method)
            self.send(:define_method, method) do |*args|
              raise NotImplementedError.new("Abstract method #{method} not implemented, or unsupported operation")
            end
          end
        end
      end
    end

    # Return the name of the strategy
    def name;    self.class.to_s;    end
    # Return the columns of the strategy
    def columns; self.class.columns; end

    # TODO : must be private
    def initialize(context_model, strategy_parameters)
      columns         = self.class.columns
      @context_model  = context_model

      # TODO - rpc : Use the defined AccessorHash
      #@strategy_hash = const_get("#{name}_accessor_hash".camelize).new(strategy_parameters, columns)
      @strategy_hash = ::StrategyStore::Strategy::AccessorHash.new(strategy_parameters, columns)
    end
  end
end
