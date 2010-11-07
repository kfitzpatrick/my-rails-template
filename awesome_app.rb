
run "rm public/index.html"

run "cp config/database.yml config/database.yml.example"

file '.gitignore', <<-END
.DS_Store
log/*.log
tmp/**/*
config/database.yml
db/*.sqlite3
END

rake "db:migrate"
rake "default"

git :init
git :add => "."
git :commit => "-a -m 'Initial commit'"

