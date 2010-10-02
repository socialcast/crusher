class LoadGenerator
  
  def initialize(options)
    @options = options
    @log_file = File.open(options[:log_file], 'a') if options[:log_file]
    
    # Reseed the pseudorandom number generator with the process's PID file,
    # as we assume this code will be run in a forked process.
    Kernel.srand(Process.pid)
  end
  
  
  
  def start!
    log('Booting')
    prepare
    while Time.now < @options[:end_time]
      act!
    end
    log('Terminating')
  end
  
  def act!; end
  
  def prepare; end
  
  def log(message)
    log_message = [Time.now.strftime('%Y-%m-%d %H:%M:%S'), @options[:process_name], message].compact.join(' ') + "\n"
    if @log_file
      @log_file.syswrite(log_message)
    else
      puts log_message
    end
  end
  
end