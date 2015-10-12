module StrategyStores
  class Configuration
    attr_accessor :strategies_folder
    attr_accessor :perform_method_names

    # TODO : Manage suffix of the strategy autoloading

    def initialize
      self.strategies_folder    = nil      # TODO : Must be set per model (How to have multiple strategy?)
      self.perform_method_names = :perform # TODO : Must be set per model (How to have multiple strategy?)
    end
  end

  class << self
    attr_accessor :configuration
  end

  @configuration ||= Configuration.new

  def self.configure
    yield(@configuration)
  end
end
