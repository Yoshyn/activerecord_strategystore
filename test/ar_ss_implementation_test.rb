require 'test_helper'

class StrategyStore::ImplementationTest < ActiveSupport::TestCase

  def test_default_strategy_methods
    implementation = DefaultStrategy.new(nil, {})
    assert_equal true,  implementation.respond_to?(:perform)
  end

  def test_software_strategy_methods
    implementation = FirstSoftwareStrategy.new(nil, {})
    assert_equal true, implementation.respond_to?(:perform_process_1)
    assert_equal true, implementation.respond_to?(:perform_process_2)
    assert_equal false,  implementation.respond_to?(:process)
    assert_equal false,  implementation.respond_to?(:run)
    assert_equal false, implementation.respond_to?(:perform)
    implementation2 = SecondSoftwareStrategy.new(nil, {})
    assert_equal true, implementation2.respond_to?(:perform_process_1)
    assert_equal true, implementation2.respond_to?(:perform_process_2)
    assert_equal false,  implementation.respond_to?(:process)
    assert_equal false,  implementation.respond_to?(:run)
    assert_equal false, implementation.respond_to?(:perform)
  end

  def test_other_strategy_methods
    implementation = OtherStrategy.new(nil, {})
    assert_equal true,  implementation.respond_to?(:process)
    assert_equal true,  implementation.respond_to?(:run)
    assert_equal false, implementation.respond_to?(:perform)
  end

  def test_strategy_unimplemented_method_call
    implementation = DefaultStrategy.new(nil, {})
    assert_raise NotImplementedError do
      implementation.perform(1,2,3)
    end
  end

  def test_strategy_implemented_method_call
    implementation = OtherStrategy.new(nil, {})
    assert_equal "OtherStrategy_other_str_sample_[1, 2, 3]", implementation.run(1,2,3)
  end
end
