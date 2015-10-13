StrategyStores.configure do |config|
  config.default_definition_path  = File.join(Rails.root, 'lib')
  config.default_method_names     = [:perform_process_1, :perform_process_2]
end
