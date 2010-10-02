gem 'httpclient'
gem 'crack'
require 'crack/json'
require "httpclient"


class WebUser < LoadGenerator
  
  def initialize(uri_root, email, password, options)
    super(options)
    @uri_root = uri_root
    @email = email
    @password = password
    @client = HTTPClient.new
    @messageIds = {}
  end
  
  
  def prepare
    login
    get_messages
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
  
  def login
    request :post, "#{@uri_root}/sessions", {'email' => @email, 'password' => @password} do |result, duration|
      log "POST loging in as #{@email}:#{@password} #{result} in #{duration}s"
    end
  end  
  
  def get_messages

    result = request :get, "#{@uri_root}/api/messages.json" do |result, duration|
      log "GET message list #{result} in #{duration}s"
    end
    
    if result
      messages = Crack::JSON.parse(result.content)['messages']
      @messageIds = {}
      messages.each do |message|
        @messageIds[message['id'].to_i] = message
      end
    end
    
  end
  
  def post_message
    request :post, "#{@uri_root}/api/messages.json", {'message[body]' => Util.lipsum([5, rand(50)].max)} do |result, duration|
      log "POST message #{result} in #{duration}s"
    end
  end
  
  def post_comment
    id = @messageIds.keys[rand(@messageIds.keys.size)]
    request :post, "#{@uri_root}/api/messages/#{id}/comments", {'comment[comment]' => Util.lipsum([5, rand(25)].max)} do |result, duration|
      log "POST comment #{result} in #{duration}s"
    end
  end
  
  def request(*args)
    response = nil
    start_time = Time.now
    result = nil
    begin
      response = @client.send(*args) 
      result = 'succeeded'
    rescue HTTPClient::ReceiveTimeoutError => e
      result = 'timed out'
    end
    duration = Time.now - start_time
    yield(result, duration)
    return response
  end
    
end