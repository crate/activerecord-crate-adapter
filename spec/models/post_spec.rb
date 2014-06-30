require_relative '../spec_helper'

describe Post do

  before(:all) do
    ActiveRecord::Migration.class_eval do
      create_table :posts do |t|
        t.string :title
        t.integer :views
      end
    end
    Post.reset_column_information
  end

  after(:all) do
    ActiveRecord::Migration.class_eval do
      drop_table :posts
    end
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

    before do
      @post = Post.create!(params)
    end

    after do
      @post.destroy
    end

    it 'should persist the record to the database' do
      @post.persisted?.should be_true
      refresh_posts
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

      it 'should find the crated record by title' do
        refresh_posts
        Post.where(title: @post.title).count.should eq 1
        post = Post.where(title: @post.title).first
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

  describe 'sql input sanitization' do

    before do
      @post = Post.create!(params)
    end

    after do
      @post.destroy
    end

    it 'should not return all records but sanitize string' do
      sql = Post.where(id: "#{@post.id} or 1=1").to_sql
      sql.should match(/'#{@post.id} or 1=1'/)
    end

    it 'should not drop the table but sanitize string' do
      Post.where(id: "#{@post.title}; DROP TABLE POST")
      refresh_posts
      Post.last.id.should eq @post.id
    end

  end

end

