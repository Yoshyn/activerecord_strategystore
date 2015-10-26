require 'test_helper'


class StrategyStores::ActiveRecordStoreTest < ActiveSupport::TestCase

  def test_available_strategies
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], ::Software.available_strategies
    sw = ::Software.new
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], sw.available_strategies
  end

  def test_other_available_strategies
    assert_equal [OtherStrategy], ::Software.other_settings_available_strategies
    sw = ::Software.new
    assert_equal [OtherStrategy], sw.other_settings_available_strategies
  end

  def test_can_instantize_and_change_strategy
    sw = ::Software.create(name: 'ciacs', strategy_class: 'FirstSoftwareStrategy')
    assert_equal FirstSoftwareStrategy, sw.strategy_class
    sw.strategy_class = SecondSoftwareStrategy
    assert_equal SecondSoftwareStrategy, sw.strategy_class
  end

  def test_can_save_strategy
    sw = ::Software.create(name: 'css', strategy_class: 'FirstSoftwareStrategy')
    sw.strategy_class = 'SecondSoftwareStrategy'
    sw.save
    sw_reload = ::Software.where(id: sw.id, name: 'css').first
    assert_equal SecondSoftwareStrategy, sw_reload.strategy_class
  end

  def test_strategy_default_attribute
    sw = ::Software.create(name: 'sda', strategy_class: 'FirstSoftwareStrategy')

    assert_equal 'fsp_sample', sw.strategy.fsp_str
    assert_equal 0,            sw.strategy.fsp_num
    assert_equal false,        sw.strategy.fsp_bool
  end

  def test_strategy_change_methods_must_change
    sw = ::Software.create(name: 'scmmc', strategy_class: 'FirstSoftwareStrategy')
    assert_equal 'fsp_sample', sw.strategy.fsp_str
    sw.strategy_class = 'SecondSoftwareStrategy'
    assert_equal 'ssp_sample', sw.strategy.ssp_str
  end

  def test_can_save_strategy_attributes
    sw = ::Software.create(name: 'cssa', strategy_class: 'FirstSoftwareStrategy')
    assert_equal 'fsp_sample', sw.strategy.fsp_str
    sw.strategy.fsp_str = 'new_value_for_fsp'
    sw.save
    sw_reload = ::Software.where(id: sw.id, name: 'cssa').first
    assert_equal 'new_value_for_fsp', sw.strategy.fsp_str
  end

  def test_strategy_value_must_be_casted
    sw = ::Software.create(name: 'svmbc', strategy_class: 'FirstSoftwareStrategy')
    assert_equal 0,     sw.strategy.fsp_num
    assert_equal false, sw.strategy.fsp_bool

    sw.strategy.fsp_num  = 23.98; assert_equal 23, sw.strategy.fsp_num
    sw.strategy.fsp_bool = 1;     assert_equal true, sw.strategy.fsp_bool
    sw.strategy.fsp_bool = false; assert_equal false, sw.strategy.fsp_bool
  end
end
