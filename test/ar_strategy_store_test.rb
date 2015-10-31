require 'test_helper'


class StrategyStores::ActiveRecordStoreTest < ActiveSupport::TestCase

  def test_strategies
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], ::Software.strategies
    sw = ::Software.new
    assert_equal [FirstSoftwareStrategy, SecondSoftwareStrategy], sw.strategies
  end

  def test_prefixed_strategies
    assert_equal [OtherStrategy], ::Software.other_settings_strategies
    sw = ::Software.new
    assert_equal [OtherStrategy], sw.other_settings_strategies
  end

  def test_prefixed_strategies_with_string
    assert_equal [], ::Software.empty_strategies
    sw = ::Software.new
    assert_equal [], sw.empty_strategies
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

  def test_strategy_assign_attributes
    sw = ::Software.create(name: 'saa', strategy_class: 'FirstSoftwareStrategy')
    sw.update_attributes(
      strategy_attributes: {
        fsp_str:  'Assign_Attributes',
        fsp_num:  '12',
        fsp_bool: 'true',
        nawak:    'nawak'
      }
    )
    sw_reload = ::Software.where(id: sw.id, name: 'saa').first
    assert_equal 'Assign_Attributes', sw_reload.strategy.fsp_str
    assert_equal 12,                  sw_reload.strategy.fsp_num
    assert_equal true,                sw_reload.strategy.fsp_bool
    assert_equal nil,                 sw_reload.settings[:nawak]
  end
end
