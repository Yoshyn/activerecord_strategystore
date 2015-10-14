class OtherStrategy < StrategyStores::Strategy

  strategy_columns_for(:other_strategy) do |column|
    column.string  :other_str, null: false, default: 'other_str_sample'
  end

  def perform(*args); return "#{self.name}_#{other_str_sample}_#{args}"; end
end
