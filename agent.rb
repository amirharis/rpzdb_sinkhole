#Author: Amir Haris Ahmad <amir@localhost.my>

require 'sinatra'
require 'useragent'
require 'httparty'
require 'pp'
require 'daemons'
require 'logger'

###Set your variables here###
id = "hack"
api_key = "YymQ5ZzxwZ7FfHxG5-Tz"
bind = "0.0.0.0"
port = 80
wg_domain = "api.rpzdb.com"
################################

set :bind, bind
set :port, port

pwd = Dir.pwd

$logger = Logger.new("#{pwd}/agent.log", 10, 1024000)

$logger.formatter = proc do |severity, datetime, progname, msg|
                "#{datetime} #{severity}: #{msg}\n"
end

class Partay
  include HTTParty
  base_uri 'http://api.rpzdb.com'
end


get '*' do
  user_agent =  UserAgent.parse(request.env["HTTP_USER_AGENT"])
  options = {
  :body => {
      :domain_name => request.env["SERVER_NAME"],
      :browser_os => user_agent.platform, 
      :browser_type => user_agent.browser,
      :browser_version => user_agent.version.to_s,
      :client => request.env["REMOTE_ADDR"],
      :http_agent => request.env["HTTP_USER_AGENT"],
      :url => request.host,
      :path => request.env["REQUEST_PATH"],
      :uri => request.env["REQUEST_URI"],
      :proxy_hash => "494a77ac7154baacd74adf0895e3e2dd5bae0740",
      :auth_token => api_key
      }
    #}
  }
  p options
  data = Partay.post('/save_data.json', options)
  $logger.info("#{options}")
  redirect "http://www.google.com"
end

#Daemons.daemonize
