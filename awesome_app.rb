files_to_delete = [
  "README",
  "public/index.html",
  "public/images/rails.png", 
  "public/javascripts/prototype.js",
  "public/javascripts/effects.js",
  "public/javascripts/dragdrop.js",
  "public/javascripts/controls.js",
  "public/javascripts/application.js",
  "test/performance/browsing_test.rb"
]

log run "rm #{files_to_delete.join(' ')}"

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

log run "bundle"

generate "cucumber"
generate "rspec"

rake "db:migrate"
rake "cucumber"
rake "spec"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

# TODO
# Get rid of prototype
# Install jQuery
# make an application.js with the basic stuff I want
# install jasmine 
# one basic cucumber feature
# one javascript cucumber feature
# nifty layout
# one scaffolded resource with tests
# devise stuff
# log in/out links in the layout
# put the Foo resource behind the login screen
# route the resource
# hamlize the layouts
# remove the erb files
# install sass
# sassify the css
