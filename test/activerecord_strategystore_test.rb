require 'test_helper'

require 'pry-byebug'

class ActiverecordStrategystoreTest < ActiveSupport::TestCase

  # def test_can_instantize_and_change_strategy
  #   sw = ::Software.create(
  #     name: 'test_can_save_strategy',
  #     strategy_class: 'FirstSoftwareStrategy')
  #   assert_equal FirstSoftwareStrategy, sw.strategy_class
  #   sw.strategy_class = 'SecondSoftwareStrategy'
  #   assert_equal SecondSoftwareStrategy, sw.strategy_class
  # end

  # def test_can_save_strategy
  #   sw = ::Software.create(
  #     name: 'test_can_save_strategy',
  #     strategy_class: 'FirstSoftwareStrategy')
  #   sw.strategy_class = 'SecondSoftwareStrategy'
  #   sw.save
  #   sw_reload = ::Software.where(id: sw.id, name: 'test_can_save_strategy').first
  #   assert_equal SecondSoftwareStrategy, sw_reload.strategy_class
  # end

  # def test_has_strategy_attribute_default
  #   sw = ::Software.create(
  #     name:             'test_has_strategy_attribute_default',
  #     strategy_class:  'FirstSoftwareStrategy')
  #   assert_equal 'fsp_sample', sw.strategy.fsp_str
  # end

  # def test_change_the_strategy_change_methods
  #   sw = ::Software.create(
  #     name:             'test_change_the_strategy_change_methods',
  #     strategy_class:  'FirstSoftwareStrategy')
  #   assert_equal 'fsp_sample', sw.strategy.fsp_str
  #   sw.strategy_class = 'SecondSoftwareStrategy'
  #   assert_equal 'ssp_sample', sw.strategy.ssp_str
  # end

  # def test_can_save_strategy_attributes
  #   sw = ::Software.create(
  #     name: 'test_can_save_strategy_attributes',
  #     strategy_class: 'FirstSoftwareStrategy')
  #   assert_equal 'fsp_sample', sw.strategy.fsp_str
  #   sw.strategy.fsp_str = 'new_value_for_fsp'
  #   sw.save
  #   sw_reload = ::Software.where(id: sw.id, name: 'test_can_save_strategy_attributes').first
  #   assert_equal 'new_value_for_fsp', sw.strategy.fsp_str
  # end

  # def test_strategy_value_must_be_casted
  #   sw = ::Software.create(
  #     name: 'test_strategy_value_must_be_casted',
  #     strategy_class: 'FirstSoftwareStrategy')

  #   assert_equal 0,     sw.strategy.fsp_num
  #   assert_equal false, sw.strategy.fsp_bool

  #   sw.strategy.fsp_num  = 23.98
  #   assert_equal 23, sw.strategy.fsp_num

  #   sw.strategy.fsp_bool = 1
  #   assert_equal true, sw.strategy.fsp_bool

  #   sw.strategy.fsp_bool = false
  #   assert_equal false, sw.strategy.fsp_bool
  # end

  # def test_can_perform_stategy
  #   sw = ::Software.create(
  #     name: 'test_strategy_value_must_be_casted',
  #     strategy_class: 'FirstSoftwareStrategy')
  #   assert_equal "FirstSoftwareStrategy_fsp_sample_[1]", sw.perform_process_1(1)
  # end
end
