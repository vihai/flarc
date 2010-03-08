
if(RUBY_VERSION >= '1.9.0')
  $:.unshift File.join(File.dirname(__FILE__), '..', 'compat')
end

# are we in the rails environment?
#begin
    require File.expand_path(File.join(File.dirname(__FILE__), '..', '..', '..', '..', 'test', 'test_helper'))

    Test::Unit::TestCase.fixture_path = File.expand_path(File.dirname(__FILE__)  + "/fixtures/")

#rescue LoadError => e
#    print 'Running in standalone mode...'
#    require File.expand_path(File.join(File.dirname(__FILE__), 'test_helper'))
#end
