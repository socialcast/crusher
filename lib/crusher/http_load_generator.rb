module Crusher
  
  class HttpLoadGenerator < LoadGenerator
    
    
    def initialize(options)
      super(options)
      @cookies = ::WebAgent::CookieManager.new 
    end
    
    def request(method, path, content = {}, &block)

      uri = URI.parse(path)

      post_args = content.keys.map do |key| 
        content[key] ? "#{URI.escape(key)}=#{URI.escape(content[key])}" : nil
      end

      post_args = post_args.compact.join("&")

      options = {
        :verb => method,
        :host => uri.host,
        :port => uri.port,
        :request => uri.path,
        :query_string => uri.query,
        :content => post_args,
        :contenttype => 'application/x-www-form-urlencoded',
        :cookie => @cookies.find(uri)
      }

      puts options.inspect

      start_time = Time.now
      EM::Protocols::HttpClient.request(options).callback do |response|
        duration = Time.now - start_time
        
        response[:headers].each do |header|
          
          matcher = /Set-Cookie:\s*(.*)/i.match(header)
          
          if matcher
            puts "Found cookie-like header: #{header}"
            @cookies.parse(matcher[1], uri)
          end
        end
        
        block.call(response, duration) if block
      end

    end
    
    
  end
  
end