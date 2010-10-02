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
      
      def initialize(&block)
        instance_eval &block
      end      
      
      def uri(new_uri = nil)
        return @uri unless new_uri
        @uri = new_uri
      end
      
    end
    
    class Scenario
      
      attr_reader :launch_jobs
      
      def initialize(&block)
        @launch_jobs = []
        @duration = nil
        instance_eval &block
      end
      
      def launch(count, type, &block)
        @launch_jobs.push :type => type, :count => count, :proc => block
      end
      
      def duration(new_duration = nil)
        return @duration unless new_duration
        @duration = new_duration
      end
      
    end
    
  end
  
end