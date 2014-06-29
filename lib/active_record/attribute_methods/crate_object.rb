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
      object ? object.to_hash : nil
    end
  end


  def to_hash
    h = {}
    instance_variables.each do |var|
      h.merge!({"#{var.to_s.gsub(/@/, '')}" => instance_variable_get(var)})
    end
    h
  end
end


