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
  
  def login
    log "Logging in to #{@uri_root} as #{@email}:#{@password}"
    @client.post "#{@uri_root}/sessions", {'email' => @email, 'password' => @password}
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
  
  def get_messages
    log "Listing messages to #{@uri_root}"
    result = @client.get "#{@uri_root}/api/messages.json"
    messages = Crack::JSON.parse(result.content)['messages']
    messages.each do |message|
      @messageIds[message['id'].to_i] = message
    end
  end
  
  def post_message
    log "Posting message to #{@uri_root}"
    @client.post "#{@uri_root}/api/messages.json", {'message[body]' => Util.lipsum([5, rand(50)].max)}
  end
  
  def post_comment
    log "Posting comment to #{@uri_root}"
    id = @messageIds.keys[rand(@messageIds.keys.size)]
    @client.post "#{@uri_root}/api/messages/#{id}/comments", {'comment[comment]' => Util.lipsum([5, rand(25)].max)}
  end
  
end