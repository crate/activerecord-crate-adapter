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

require_relative '../spec_helper'

describe "Post#array" do

  before(:all) do
    ActiveRecord::Migration.class_eval do
      create_table :posts do |t|
        t.string :title
        t.integer :comment_count
        t.array :tags, array_type: :string
        t.array :votes, array_type: :integer
        t.array :bool_arr, array_type: :boolean
      end
    end
    Post.reset_column_information
  end

  after(:all) do
    ActiveRecord::Migration.class_eval do
      drop_table :posts
    end
  end


  describe "#array column type" do
    let(:array) { %w(hot fresh) }
    let(:votes) { [9, 8, 7] }
    let(:bool_arr) { [true, false, true] }
    let(:post) { Post.create!(title: 'Arrays are awesome', tags: array, votes: votes, bool_arr: bool_arr) }

    context 'create' do
      it 'should store and return an array' do
        p = Post.find(post.id)
        p.tags.should be_a Array
        p.votes.should be_a Array
        p.bool_arr.should be_a Array
        p.tags.should eq array
        p.votes.should eq votes
        p.bool_arr.should eq bool_arr
      end

      it 'should find the post by array value' do
        post = Post.create!(title: 'Arrays are awesome', tags: array, votes: votes)
        refresh_posts
        Post.where("'fresh' = ANY (tags)").should include(post)
      end
    end

    context '#update' do
      it 'should update and existing array value' do
        post = Post.create!(title: 'Arrays are awesome', tags: array, votes: votes)
        refresh_posts
        new_tags = %w(ok)
        post.update_attributes!(tags: new_tags)
        refresh_posts
        post.reload
        post.tags.should eq new_tags
      end
    end

  end

end