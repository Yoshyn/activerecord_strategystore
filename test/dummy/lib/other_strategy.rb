class OtherStrategy
  include StrategyStore::Implementation

  strategy_columns_for(:other_strategy) do |column|
    column.string :other_str, null: false, default: 'other_str_sample'
  end

  def run(*args); return "#{self.name}_#{other_str}_#{args}"; end
end
