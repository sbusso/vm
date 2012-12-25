ssh_options[:port] = 7222
server "127.0.0.1", :app, :web, :db, :db_server,primary: true
set :whenever_roles, "127.0.0.1"
set :rails_env, 'developement'
