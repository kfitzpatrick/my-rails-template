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
    gem "remarkable_rails", "3.1.13"
    gem "capybara", "0.4.0"
    gem "cucumber-rails", "0.3.2"
    gem "database_cleaner", "0.5.2"
  end
END

log run "bundle"

generate "cucumber"
generate "rspec"
generate "nifty_layout"
generate "nifty_scaffold Foo name:string"

# Rewrite the controller spec to use remarkable
run "rm spec/controllers/foos_controller_spec.rb"
file 'spec/controllers/foos_controller_spec.rb', <<-EOF
  require File.dirname(__FILE__) + '/../spec_helper'

  describe FoosController do
    mock_models :foo

    describe :get => :index do
      should_render_template :index
    end

    describe :get => :show, :id => "foo" do 
      expects :find, :on => Foo, :with => "foo", :returns => mock_foo 
      should_render_template :show
    end

    describe :get => :new do
      should_render_template :new
    end

    describe :post => :create do
      expects :new, :on => Foo, :returns => mock_foo 
      expects :save, :on => mock_foo, :returns => false  
      should_render_template :new
    end

    describe :post => :create, :foo => "bar" do
      expects :new, :on => Foo, :with => "bar", :returns => mock_foo 
      expects :save, :on => mock_foo, :returns => true  
      should_redirect_to { foo_path(mock_foo) }
      should_assign_to :foo, :with => mock_foo
    end

     describe :get => :edit, :id => "foo"  do
       expects :find, :on => Foo, :returns => mock_foo
       should_render_template :edit
     end

    describe :put => :update, :id => "foo" do
      expects :find, :on => Foo, :returns => mock_foo
      expects :update_attributes, :on => mock_foo, :returns => false  
      should_render_template :edit 
    end

     describe :put => :update, :id => "foo", :foo => "bar" do
       expects :find, :on => Foo, :returns => mock_foo
       expects :update_attributes, :on => mock_foo, :with => "bar", :returns => true
       should_redirect_to { foo_path(mock_foo) } 
     end

     describe :delete => :destroy, :id => "foo" do
       expects :find, :on => Foo, :returns => mock_foo
       expects :destroy, :on => mock_foo
       should_redirect_to { foos_path }
     end
  end
EOF

run "rm spec/fixtures/foos.yml"

rake "db:migrate"
rake "cucumber"
spec_output = run "rake spec"

log spec_output

raise "The specs are not passing correctly." unless spec_output.include?("11 examples, 0 failures")

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

# TODO
# insert the require remarkable bits into spec_helper
# install remarkable and make the controller use it
# one basic cucumber feature
# one javascript cucumber feature
# Install jQuery
# make an application.js with the basic stuff I want
# install jasmine 
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
# Make the resource index the root route
