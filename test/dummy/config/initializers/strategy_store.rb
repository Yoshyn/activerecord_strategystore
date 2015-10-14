StrategyStores.configure do |config|
  config.default_definition_path  = File.join(Rails.root, 'lib')

  config.register_strategy(:other_strategy)

  config.register_strategy(:my_amazing_strategy) do |rs|
    rs.method_names = [:perform_process_1, :perform_process_2]
  end
end
