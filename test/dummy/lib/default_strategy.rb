class DefaultStrategy < StrategyStores::Strategy

  strategy_columns do |column|
    column.string  :default_str, null: false, default: 'default_str_sample'
  end

end
