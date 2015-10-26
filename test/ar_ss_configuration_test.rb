require 'test_helper'

class StrategyStore::ConfigurationTest < ActiveSupport::TestCase

  def test_register_existing_strategy_must_raise_error
    assert_raise StrategyStore::StrategyAlreadyRegister do
      StrategyStore.register_strategy(:software_strategy)
    end
  end

  def test_default_strategy_parameters
    config = StrategyStore.config
    assert_equal [:perform],  config.default_strategy_methods
    assert_equal [DefaultStrategy], config.default_class_implementations.to_a
  end

  def test_software_strategy_parameters
    strategy = StrategyStore.fetch_strategy(:software_strategy)
    assert_equal [:perform_process_1, :perform_process_2], strategy.strategy_methods
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], strategy.class_implementations.to_a
  end

  def test_other_strategy_parameters
    strategy = StrategyStore.fetch_strategy(:other_strategy)
    assert_equal [:process, :run], strategy.strategy_methods
    assert_equal [OtherStrategy],  strategy.class_implementations.to_a
  end

  def test_my_amazing_strategy_strategy_parameters
    strategy = StrategyStore.fetch_strategy(:my_amazing_strategy)
    assert_equal [:perform], strategy.strategy_methods
    assert_equal [],         strategy.class_implementations.to_a
  end
end
