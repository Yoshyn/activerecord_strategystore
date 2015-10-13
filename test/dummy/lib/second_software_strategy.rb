class SecondSoftwareStrategy < StrategyStores::Strategy
  columns do |column|
    column.string  :ssp_str, null: false, default: 'ssp_sample'
    column.integer :ssp_num, null: false, default: 0
  end

  def perform_process_1(*args); return "#{self.name}_#{fsp_str}_#{args}"; end
  def perform_process_2(*args); nil; end
end
