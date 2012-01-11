# Edit this Gemfile to bundle your application's dependencies.
source 'http://gemcutter.org'

gem 'rails', '~> 3.2.0.rc2'

gem 'pg'

gem 'pry', :git => 'https://github.com/pry/pry'
gem 'pry-rails'

gem 'ym4r'
gem 'scruffy'
gem 'uuidtools'
gem 'httpclient'

gem 'geokit'
gem 'geokit-rails3'

gem 'exception_notification', :git => 'git://github.com/rails/exception_notification', :require => 'exception_notifier'

gem 'thinking-sphinx', '>= 2.0.0', :require => 'thinking_sphinx'

gem 'vihai-password', '>= 1.2.0', :git => 'https://github.com/vihai/vihai-password.git'
gem 'active_rest', '>= 3.0.1', :git => 'https://github.com/yggdra/active_rest'

#gem 'facebooker', :git => 'git://github.com/joren/facebooker.git', :branch => 'rails3'

gem 'yggdra_plugins', :path => '../yggdra/plugins/yggdra_plugins'

gem 'hel', :path => '../yggdra/plugins/hel'

gem 'core_models', :path => '../yggdra/plugins/core_models'
gem 'core_hel', :path => '../yggdra/plugins/core_hel'

gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.0.rc1'
#  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier', '>= 1.0.3'
  gem 'therubyracer'
end

# Required for testing
group :test, :development do
  gem 'rspec', '>= 2.0.0'
  gem 'rspec-rails', '>= 2.0.0'
  gem 'factory_girl_rails', '>= 1.1.beta1'
  gem 'vihai-assert2', :git => 'https://github.com/vihai/assert2.git'
end

