source "https://rubygems.org"
gem "rails", "~> 8.0.0"
gem "sqlite3", "~> 2.2"
gem "puma", "~> 6.4"
gem "bootsnap", require: false

group :development, :test do
  gem 'rubocop', require: false
  gem 'brakeman', require: false
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
  gem "byebug", platforms: [ :mri, :mingw, :x64_mingw ]
end

group :test do
  gem "shoulda-matchers", "~> 6.4"
end

group :development do
  gem "rails_db", "~> 2.4"
  gem "listen"
  gem "spring"
end
