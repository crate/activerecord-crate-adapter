module CrateObject
  extend ActiveSupport::Concern

  module ClassMethods
    def load(object)
      case object
        when String
          object.gsub!('=', ':')
          object = JSON.parse("{#{object}}")
      end
      new(object.symbolize_keys)
    end

    def dump(object)
      object ? object.to_literals : nil
    end
  end


  def to_literals
    arr = []
    instance_variables.each do |var|
      v = instance_variable_get(var)
      value = v.is_a?(Array) ? v : %Q{"#{v}"}
      arr << %Q{"#{var.to_s.gsub(/@/, '')}"=#{value}}
    end
    arr.join(', ')
  end
end


