module Hel

class Name
  attr_accessor :first, :middle, :last

  def initialize(first, middle, last)
    @first = first
    @middle = middle
    @last = last
  end

  def to_s
    [ @first, @middle, @last ].compact.
      collect { |x| x.downcase.capitalize }.join(" ")
  end

  def to_s_reversed
    [ @last, @middle, @first ].compact.
      collect { |x| x.downcase.capitalize }.join(" ")
  end
end

class Person < HelModel

  has_many :identities, :class_name => "::Hel::Identity"

  belongs_to :home_location, :class_name => "::Hel::Location"
  belongs_to :birth_location, :class_name => "::Hel::Location"

  composed_of :name,
              :class_name => "::Hel::Name",
              :mapping =>
                [
                  %w[ first_name first ],
                  %w[ middle_name middle ],
                  %w[ last_name last ]
                ]

  #Move to monkeypatch???? FIXME TODO
#  has_one :pilot
end

end
