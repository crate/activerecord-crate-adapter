require_relative '../../../spec_helper'

describe ActiveRecord::ConnectionAdapters::CrateAdapter::TableDefinition do


  describe '#object_schema_to_string' do

    let(:td) { ActiveRecord::ConnectionAdapters::CrateAdapter::TableDefinition.new(nil, nil, nil, nil) }

    it 'should simply set the key and values' do
      s = {street: :string, city: :string}
      str = td.send(:object_schema_to_string, s)
      str.should eq "street string, city string"
    end

    it 'should simply properly parse an array definition' do
      s = {street: :string, city: :string, phones: {array: :string}}
      str = td.send(:object_schema_to_string, s)
      str.should eq "street string, city string, phones array(string)"
    end

  end


end

