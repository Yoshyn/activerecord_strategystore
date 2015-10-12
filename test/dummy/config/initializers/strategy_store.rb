StrategyStores.configure do |config|
  config.strategies_folder    = File.join(Rails.root, 'lib')
  config.perform_method_names = [:perform_process_1, :perform_process_2]
end
