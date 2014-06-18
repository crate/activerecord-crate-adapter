require 'active_record/attribute_methods/crate_object'

class Address
  attr_accessor :street, :city, :phones, :zip

  include CrateObject

  def initialize(opts)
    @street = opts[:street]
    @city = opts[:city]
    @phones = opts[:phones]
    @zip = opts[:zip]
  end

end