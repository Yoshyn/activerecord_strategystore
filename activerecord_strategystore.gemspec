$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'strategy_store/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'activerecord_strategystore'
  spec.version     = StrategyStores::VERSION
  spec.authors     = ['Sylvestre Antoine']
  spec.email       = ['sylvestre.antoine@gmail.com']
  spec.homepage    = 'https://github.com/Yoshyn/activerecord_strategystore'
  spec.summary     = %q{ActiveRecord::Store designed for pattern strategy.}
  spec.description = %q{Typed store for a pattern strategy implementation with active-record.}
  spec.license     = 'MIT'

  spec.files       = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  spec.test_files  = Dir['test/**/*']

  spec.add_dependency 'rails', '~> 4.2.4'

  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry-byebug'
end
