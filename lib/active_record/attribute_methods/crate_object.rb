# -*- coding: utf-8; -*-
#
# Licensed to CRATE Technology GmbH ("Crate") under one or more contributor
# license agreements.  See the NOTICE file distributed with this work for
# additional information regarding copyright ownership.  Crate licenses
# this file to you under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.  You may
# obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations
# under the License.
#
# However, if you have executed another commercial license agreement
# with Crate these terms will supersede the license and you may use the
# software solely pursuant to the terms of the relevant commercial agreement.

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


