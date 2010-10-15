module Crusher
  module Configurator
        
    class Configuration
      
      attr_reader :targets, :scenarios
      
      def initialize(config_path)
        @targets = {}
        @scenarios = {}
        eval File.open(config_path).read
      end
            
      def target target_name, &block
        @targets[target_name] = Crusher::Configurator::Target.new(&block)
      end
      
      def scenario scenario_name, &block
        @scenarios[scenario_name] = Crusher::Configurator::Scenario.new(&block)
      end
      
    end
    
    class Target
      
      def initialize(*args, &block)
        block.call self, *args
      end      
      
      def uri(new_uri = nil)
        return @uri unless new_uri
        @uri = new_uri
      end
      
    end
    
    class Scenario
      
      attr_reader :launch_jobs, :phases
      
      def initialize(*args, &block)
        @launch_jobs = []
        @phases = []
        @duration = nil
        block.call self, *args
      end
      
      def launch(count, type, &block)
        @launch_jobs.push :type => type, :count => count, :proc => block
      end
      
      def phase(name, options = {}, &block)
        @phases << options.merge( :name => name.to_s, :proc => block )
      end

      def duration(new_duration = nil)
        return @duration unless new_duration
        @duration = new_duration
      end
      
    end
    
  end
  
end