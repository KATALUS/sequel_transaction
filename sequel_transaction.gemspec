# -*- encoding: utf-8 -*-
require File.expand_path('../lib/sequel_transaction/version', __FILE__)

Gem::Specification.new do |gem|
  gem.author        = 'vyrak.bunleang@gmail.com'
  gem.description   = 'Middlewares for Sequel transactions'
  gem.summary       = 'Middlewares for Sequel transactions'

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "sequel_transaction"
  gem.require_paths = ["lib"]
  gem.version       = SequelTransaction::VERSION

  gem.add_dependency 'sequel', '>= 4.0.0'
end
