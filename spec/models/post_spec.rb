require_relative '../spec_helper'

describe Post do

  before(:all) do
    ActiveRecord::Base.connection.raw_connection
    .create_table("posts", id: [:string, "primary key"],
                  title: :string,
                  views: :integer).should be_true
  end

  after(:all) do
    ActiveRecord::Base.connection.raw_connection.drop_table("posts").should be_true
  end

  let(:params) { {title: "Crate rocks", views: 10000} }

  context 'initialization' do
    it 'should initialize a post object with all columns' do
      post = Post.new(params)
      post.should be_a(Post)
      post.title.should eq "Crate rocks"
      post.views.should eq 10000
    end
  end

  context 'persistance' do

    it 'should persist the record to the database' do
      post = Post.create!(params)
      post.persisted?.should be_true
      refresh_table
      Post.count.should eq 1
    end

  end

  context 'deletion' do

    before do
      @post = Post.create!(params)
    end

    it 'should destroy the record to the database' do
      @post.destroy
      Post.where(id: @post.id).should be_empty
    end
  end

  describe 'existing record manipulation' do
    before do
      @post = Post.create!(params)
    end

    after do
      @post.destroy
    end

    context 'find' do
      it 'should find the crated record' do
        post = Post.where(id: @post.id).first
        post.id.should eq(@post.id)
      end
    end

    context 'update' do
      it 'should update the record' do
        @post.update_attributes(title: 'Crate Dope')
        @post.reload.title.should eq('Crate Dope')
      end

    end
  end

  # Crate is eventually consistent therefore we need
  # to refresh the table when doing queries, except we
  # query for the primary key
  def refresh_table
    Post.connection.raw_connection.refresh_table('posts')
  end

end

