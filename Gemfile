# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web API
gem 'json'
gem 'puma', '~>5'
gem 'roda', '~>3'

# Configuration
gem 'figaro', '~>1'
gem 'rake', '~>13'

# Security
gem 'bundler-audit'
gem 'rbnacl', '~>7'

# Database
gem 'hirb', '~>0'
gem 'sequel', '~>5'

<<<<<<< HEAD
group :production do
  gem 'pg'
end

=======
>>>>>>> 1c3ebe9b3f68fab79c2b871fc20654bebff3b7b3
# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
end

<<<<<<< HEAD
# Debugging
gem 'pry' # necessary for rake console

# Development
group :development do
=======
# Development
group :development do
  gem 'pry'
>>>>>>> 1c3ebe9b3f68fab79c2b871fc20654bebff3b7b3
  gem 'rerun'
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'rack-test'
  gem 'sequel-seed'
  gem 'sqlite3'
end