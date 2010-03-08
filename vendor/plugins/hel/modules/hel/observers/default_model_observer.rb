
require 'activemessaging/processor'

class Hel::Observers::DefaultModelObserver < ActiveRecord::Observer  
  include ActiveMessaging::MessageSender
  observe HelModel
  
  publishes_to :default_hel_queue
  
  def after_create(object)
    send_event :create, object   
  end
  
  def after_destroy(object)
    send_event :destroy, object   
  end 
  
  def after_update(object)
    send_event :update, object   
  end   
  
  private
  def send_event(event, object)
    
    payload = Hel::Events::Message.new(event, object).serialize
    #publish :default_hel_queue, payload  
  end
  
end
