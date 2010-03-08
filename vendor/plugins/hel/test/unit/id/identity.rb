require File.join(File.dirname(__FILE__), '..', '..', "test_environment")

class IdentityTest < ActiveSupport::TestCase
  
  def testCreate
  id = Hel::Id::Identity.new

  assert_instance_of(Hel::Id::Identity, id)
  assert_respond_to(id, :uuid)
  assert_respond_to(id.uuid, :valid?)
  
  assert_throws(:'ActiveRecord::RecordInvalid') {
    id.save!
  }
  
  id.qualified = 'lele@windmill.it'
  
  assert_nothing_raised {
    id.save!
  }  
  end

  def testCreateConst
    id = Hel::Id::Identity.new("lele@windmill.it")
    assert_instance_of(Hel::Id::Identity, id)
    assert_equal(id.qualified, 'lele@windmill.it')
  end
  
  
  # Replace this with your real tests.
  def test_truth
    assert true
  end
end