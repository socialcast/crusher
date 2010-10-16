module Crusher
  
  class LoadGenerator
  
    def initialize(crush_session, options)
      @crush_session = crush_session
      @options = options
      begin
        @log_file = File.open(options[:log_file], 'a') if options[:log_file] 
      rescue Errno::ENOENT
        log("Log file #{options[:log_file]} couldn't be opened; logging to STDOUT")
      end    
    end
    
    def act!; end
  
    def prepare; end
        
    def log(message)
      @crush_session.log(message)
    end
  
  end
  
end