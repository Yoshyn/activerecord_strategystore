require 'strategy_stores/strategies/accessor_hash'
require 'strategy_stores/strategies/column'
require 'strategy_stores/strategies/dsl'

module StrategyStores
  class Strategy
    include ActiveModel::Dirty
    include ActiveModel::Serialization

    REGISTERED_STRATEGIES = []

    class_attribute :strategy_columns,        instance_accessor: false
    # class_attribute :strategy_implementation, instance_accessor: false
    # String

    # def self.implement_strategy(strategy_identifier)
    #   StrategyStores.configuration.strategies[strategy_identifier].each do |options|
    #     # if method = options[:perform_method] && method.is_a?(Proc)
    #     # elsif method_names = options[:perform_method_names]
    #     # else
    #     #    define StrategyStores.configuration.default_perform_method
    #     # end
    #   end
    # end

    Array.wrap(::StrategyStores.config.default_method_names).each do |method_name|
      define_method(method_name) do |*args|
        raise NotImplementedError.new("Abstract method #{method_name} not implemented, or unsupported operation")
      end
    end

    def name;    self.class.to_s;             end
    def columns; self.class.strategy_columns; end
    # Work but realy ugly method. Must be refactored
    def self.strategies
      @_strategies || self.register_strategies
    end

    protected
    # Can be call only by Ancestor. You should not override this.
    def initialize(context_model, strategy_parameters)
      columns         = self.class.strategy_columns
      @context_model  = context_model

      # TODO - rpc : Use the defined AccessorHash
      #@strategy_hash = const_get("#{name}_accessor_hash".camelize).new(strategy_parameters, columns)
      @strategy_hash = ::StrategyStore::Strategies::AccessorHash.new(strategy_parameters, columns)
    end

    def self.columns(&block)
      dsl = ::StrategyStore::Strategies::DSL.new(&block)
      register_strategy_columns(dsl.columns)
      generate_strategy_accessors
    end

    private
    def self.register_strategies
      if definition_path = ::StrategyStores.config.default_definition_path
        suffix         = ::StrategyStores.config.default_file_suffix
        strategy_files = File.join(definition_path, "*_#{suffix}.rb")
        Dir[File.expand_path(strategy_files, __FILE__)].each do |path|
          require_relative path
        end
      end
      @_strategies = REGISTERED_STRATEGIES
    end

    def self.inherited(child);
      puts "StrategyStore::Strategies : Register strategy #{child.name}"
      REGISTERED_STRATEGIES << child.name;
    end

    def self.register_strategy_columns(columns)
      self.strategy_columns ||= {}
      strategy_columns.merge!(columns.index_by(&:name))
      # TODO - rpc : Define a AccessorHash with the columns
      # accessor_hash_class = AccessorHash.create(columns)
      # const_set("#{name}_accessor_hash".camelize, accessor_hash_class)
    end

    def self.generate_strategy_accessors

      attributes = []
      strategy_columns.each do |column_name, _|
        attributes << column_name

        self.send(:define_attribute_methods, column_name)
        self.send(:define_method, column_name) do
          @strategy_hash[column_name]
        end
        self.send(:define_method, "#{column_name}=") do |value|
          send("#{column_name}_will_change!") unless value == instance_variable_get("@_#{column_name}")
          @strategy_hash[column_name] = value
        end
      end

      self.send(:define_method, :attributes) do
        Hash[attributes.map { |name, _| [name, send(name)] }]
      end
    end
  end
end
