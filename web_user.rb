gem 'httpclient'
gem 'crack'
require 'crack/json'
require "httpclient"

class WebUser
  
  def initialize(uri_root, email, password)
    id = rand(2000)
    @uri_root = uri_root
    @email = email
    @password = password
    @client = HTTPClient.new @uri_root
    cookie_store = "#{Process.pid}-cookie-#{id}.dat"
    @client.set_cookie_store cookie_store
    @messageIds = {}
    login
    get_messages
  end
  
  def login
    puts "logging in #{@email} #{password}"
    @client.post "#{@uri_root}/sso/login", {'email' => @email, 'password' => @password}
  end
  
  def ready?
    @ready
  end
  
  def act!
    @ready = false
    case rand(10)
    when 0..2  
      get_messages
    when 3..6
      post_message
    when 7..9
      post_comment
    end
    sleep rand(4)
    @ready = true
  end
  
  def get_messages
    puts "getting messages"
    @client.get_content "#{@uri_root}/api/messages.json" do |content|
      messages = Crack::JSON.parse(content)
      messages.each do |message|
        @messageIds[message['id'].to_i] = message
      end
    end
  end
  
  def post_message
    puts "posting message"
    @client.post "#{@uri_root}/api/messages.json", {'message' => {'body' => ('A' * rand(50))}}
  end
  
  def post_comment
    puts "posting comment"
    id = @messageIds.keys[rand(@messageIds.keys.size)]
    @client.post "#{@uri_root}/api/messages/#{id}/comments", {'comment' => {'comment' => ('B'*rand(30))}}
  end
  
end