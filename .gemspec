spec = Gem::Specification.new do |s|
  s.name = 'crusher'
  s.version = '0.0.1'
  s.summary = 'A scriptable load generator'
  s.homepage = 'http://github.com/phene/crusher'
  
  s.files = Dir['rails/init.rb', 'lib/**/*', 'bin/*', 'test/**/*',
      'extra/**/*', 'Rakefile', 'init.rb', '.yardopts']
  
  s.executables = ['crush']
  
  s.has_rdoc = false
end