
run "rm README"
run "rm public/index.html"
run "rm -rf test"

run "cp config/database.yml config/database.yml.example"

file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

unless (run "gem list bundler").include?("1.0.2")
  run "gem install bundler -v=1.0.2"
end

file 'Gemfile', <<-END
  source :gemcutter
  gem "rails", "2.3.8"
  gem "sqlite3-ruby", :require => "sqlite3"

  group :development do
  end

  group :test do
    gem "rspec", "> 1.3", "< 2.0"
    gem "rspec-rails", "> 1.3", "< 2.0"
    gem "capybara", "0.4.0"
    gem "cucumber-rails", "0.3.2"
    gem "database_cleaner", "0.5.2"
  end
END

log run "bundle install"

rake "db:migrate"
rake "default"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

