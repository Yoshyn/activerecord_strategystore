require 'strategy_stores/strategies/accessor_hash'
require 'strategy_stores/strategies/column'
require 'strategy_stores/strategies/dsl'

require 'pry-byebug'

module StrategyStores
  class Strategy
    include ActiveModel::Dirty
    include ActiveModel::Serialization

    REGISTERED_STRATEGIES = []

    class_attribute :columns,       instance_accessor: false
    class_attribute :strategy_name, instance_accessor: false
    # TODO : Find a better name that strategy_name

    def name;    self.class.to_s;    end
    def columns; self.class.columns; end

    def self.strategies
      strategies      ||= self.register_strategies
      strategy_filter = self.strategy_name
      strategies.select! { |strategy| strategy.strategy_name == strategy_filter } if strategy_filter
      strategies
    end

    def self.available_strategies(filter_name)
      strategies.select { |strategy| strategy.strategy_name == filter_name }
    end

    protected
    # Can be call only by Ancestor. You should not override this.
    def initialize(context_model, strategy_parameters)
      columns         = self.class.columns
      @context_model  = context_model

      # TODO - rpc : Use the defined AccessorHash
      #@strategy_hash = const_get("#{name}_accessor_hash".camelize).new(strategy_parameters, columns)
      @strategy_hash = ::StrategyStore::Strategies::AccessorHash.new(strategy_parameters, columns)
    end

    def self.strategy_columns(&block); strategy_columns_for(:default, &block); end

    def self.strategy_columns_for(strategy_name, &block)
      raise "ERROR : an strategy was already defined for...#{strategy_name}" if self.strategy_name # TODO : Manage Error with an error namespace
      self.strategy_name = strategy_name
      dsl = ::StrategyStore::Strategies::DSL.new(&block)
      register_columns(dsl.columns)
      generate_strategy_accessors
      generate_abstract_strategy_method
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
      REGISTERED_STRATEGIES << child;
    end

    def self.register_columns(attr_columns)
      self.columns ||= {}
      self.columns.merge!(attr_columns.index_by(&:name))
      # TODO - rpc : Define a AccessorHash with the columns
      # accessor_hash_class = AccessorHash.create(columns)
      # const_set("#{name}_accessor_hash".camelize, accessor_hash_class)
    end

    def self.generate_strategy_accessors

      attributes = []
      columns.each do |column_name, _|
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

    def self.generate_abstract_strategy_method
      strategy_str = self.strategy_name || :default

      abstract_strategy_methods = StrategyStores.config.strategy(strategy_str).method_names
      Array.wrap(abstract_strategy_methods).each do |method_name|
        self.send(:define_method, method_name) do |*args|
          raise NotImplementedError.new("Abstract method #{method_name} not implemented, or unsupported operation")
        end
      end
    end
  end
end
