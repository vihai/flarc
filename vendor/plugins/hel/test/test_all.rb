#
#
require File.join(File.dirname(__FILE__), "test_environment")


require 'test/unit'

root = File.expand_path(File.dirname(__FILE__))

Hel.require_recursive('*.rb', File.join(root, "unit") , true)

