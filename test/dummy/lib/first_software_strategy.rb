class FirstSoftwareStrategy < StrategyStores::Strategy

  strategy_columns_for(:my_amazing_strategy) do |column|
    column.string  :fsp_str,  null: false, default: 'fsp_sample'
    column.integer :fsp_num,  null: false, default: 0
    column.boolean :fsp_bool, null: false, default: false
  end

  def perform_process_1(*args); return "#{self.name}_#{fsp_str}_#{args}"; end
  # def perform_process_2(*args); nil; end # Not implemented
end
