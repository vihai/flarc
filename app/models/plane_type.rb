class PlaneType < ActiveRecord::Base
  has_many :planes
  has_many :configurations, :class_name => "PlaneTypeConfiguration"

  validates_presence_of :manufacturer
  validates_presence_of :name
  validates_presence_of :seats
  validates_numericality_of :seats

  validates_presence_of :motor
  validates_numericality_of :motor

  validates_numericality_of :handicap

  accepts_nested_attributes_for :configurations
end
