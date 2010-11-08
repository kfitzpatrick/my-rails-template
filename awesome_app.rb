
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

log run "gem install bundler -v=1.0.2"

file 'Gemfile', <<-END
  source :gemcutter
  gem "rails", "2.3.8"
  gem "sqlite3-ruby", :require => "sqlite3"

  # bundler requires these gems in all environments
  # gem "nokogiri", "1.4.2"
  # gem "geokit"

  group :development do
    # bundler requires these gems in development
    # gem "rails-footnotes"
  end

  group :test do
    # bundler requires these gems while running tests
    # gem "rspec"
    # gem "faker"
  end
END

log run "bundle install"

rake "db:migrate"
rake "default"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

