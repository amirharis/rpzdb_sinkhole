
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
  #redirect "http://#{request.host}.#{id}.#{wg_domain}" 
  #p request
  #puts "#{request.host} #{id}"
  puts "REMOTE_ADDR:  #{request.env["REMOTE_ADDR"]}"
  puts "REMOTE_HOST: #{request.env["REMOTE_HOST"]}"
  puts "REQUEST_URI: #{request.env["REQUEST_URI"]}"
  user_agent =  UserAgent.parse(request.env["HTTP_USER_AGENT"])
  puts "REQUEST_PATH: #{request.env["REQUEST_PATH"]}"
  puts "SERVER_NAME: #{request.env["SERVER_NAME"]}"
  puts "SERVER_PORT: #{request.env["SERVER_PORT"]}"
  puts "rack.request.query_hash: #{request.env['rack.request.query_hash']}"
  puts "user_agent.browser #{user_agent.browser}"
  puts "user_agent.version #{user_agent.version}"
  puts "user_agent.platform #{user_agent.platform}"  

  options = {
  :body => {
    #:user => { # your resource
      #:domain_name => params[:domain],
      :domain_name => request.env["SERVER_NAME"],
      #:reputation => params[:reputation],
      :browser_os => user_agent.platform, 
      :browser_type => user_agent.browser,
      :browser_version => user_agent.version.to_s,
      #:client => params[:remote_address],
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
  #puts data["url"]
  $logger.info("#{options}")
  #redirect "http://#{wg_domain}/vaults"
  redirect "http://www.google.com"
end

#Daemons.daemonize
