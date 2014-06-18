require_relative '../spec_helper'

describe "User#object" do

  before(:all) do
    ActiveRecord::Migration.class_eval do
      create_table :users do |t|
        t.string :name
        t.object :address
      end
    end
    User.reset_column_information
  end

  after(:all) do
    ActiveRecord::Migration.class_eval do
      drop_table :users
    end
  end


  describe "#array column type" do
    let(:address) {Address.new(street: '1010 W 2nd Ave', city: 'Vancouver', phones: ["123", "987"], zip: 6888)}
    let(:user) {@user = User.create!(name: 'Mad Max', address: address)}

    it 'should store and return an object' do
      p = User.find(user.id)
      p.address.should be_a Address
      p.address.street.should eq address.street
      p.address.city.should eq address.city
      p.address.zip.should eq address.zip.to_s # without a object schema numbers are converted to strings
    end

  end

end