require File.dirname(__FILE__) + '/spec_helper'
root = File.expand_path(File.dirname(__FILE__))

Hel.require_recursive('*.rb', File.join(root, "models") , true)