# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'solidus_active_sale'
  s.version     = '1.0.0'
  s.summary     = 'Solidus Active Sale to handle flash sales / daily deal behavior for Solidus'
  s.description = 'Solidus Active Sale makes it easy to handle flash sale.  By this, you can have a variant, product, or group number of products in a taxon, attach that variant, product, or taxon to a sale event with a start and end date for scheduling.  Your sale event will only be available between the dates given and when the sale is gone, it will not be accessible at any point until you create a new one or re-schedule the same'
  s.required_ruby_version = '>= 2.1.0'

  s.author    = 'Jeffrey Leung'
  s.email     = 'jeffreyleung@alumni.calpoly.edu'
  # s.homepage  = 'http://www.spreecommerce.com'
  s.license = 'BSD-3'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'solidus', '~> 1.3'

  s.add_development_dependency 'capybara', '~> 2.6'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 3.4'
  s.add_development_dependency 'sass-rails', '~> 5.0.0'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
