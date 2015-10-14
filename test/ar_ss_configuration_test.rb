require 'test_helper'
require 'pry-byebug'

class StrategyStores::ConfigurationTest < ActiveSupport::TestCase

  def test_configuration_must_have_strategies
    assert_equal false, ::StrategyStores.config.strategy(:other_strategy).nil?
    assert_equal false, ::StrategyStores.config.strategy(:default).nil?
    assert_equal false, ::StrategyStores.config.strategy(:my_amazing_strategy).nil?
  end

  def test_configuration_strategies_must_inform_methods
    assert_equal [:perform], ::StrategyStores.config.strategy(:other_strategy).method_names
    assert_equal [:perform], ::StrategyStores.config.strategy(:default).method_names
    assert_equal(
      [:perform_process_1, :perform_process_2],
      ::StrategyStores.config.strategy(:my_amazing_strategy).method_names
    )
  end

  def test_registered_strategies_loading
    assert_equal(
      [FirstSoftwareStrategy, SecondSoftwareStrategy, OtherStrategy, DefaultStrategy].map(&:to_s).sort,
      StrategyStores::Strategy.strategies.map(&:to_s).sort
    )
  end

  def test_registered_strategies_with_name
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], FirstSoftwareStrategy.strategies
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], SecondSoftwareStrategy.strategies
    assert_equal [OtherStrategy], OtherStrategy.strategies
  end

  def test_registered_strategies_with_name
    assert_equal [OtherStrategy], StrategyStores::Strategy.available_strategies(:other_strategy)
  end

  def test_not_registered_with_bad_suffix
    assert_equal false, !!defined?(ThirdSoftwareNotAutoRequire)
  end

  def test_method_my_amazing_strategy
    fss = FirstSoftwareStrategy.send(:new, nil, {})
    assert_equal false, fss.respond_to?(:perfom)
    assert_equal true, fss.respond_to?(:perform_process_1)
    assert_equal true, fss.respond_to?(:perform_process_2)
  end

  def test_method_default_strategy
    fss = DefaultStrategy.send(:new, nil, {})
    assert_equal false, fss.respond_to?(:perform_process_1)
    assert_equal true, fss.respond_to?(:perform)
  end

  def test_method_other_strategy
    fss = OtherStrategy.send(:new, nil, {})
    assert_equal false, fss.respond_to?(:perform_process_1)
    assert_equal true, fss.respond_to?(:perform)
  end
end
