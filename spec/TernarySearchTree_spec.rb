#!/usr/bin/env ruby -w
# encoding: UTF-8
#
# = IntervalList_spec.rb -- The TaskJuggler III Project Management Software
#
# Copyright (c) 2006, 2007, 2008, 2009, 2010, 2011
#               by Chris Schlaeger <chris@linux.com>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of version 2 of the GNU General Public License as
# published by the Free Software Foundation.
#

require 'rubygems'

require 'taskjuggler/TernarySearchTree'

class TaskJuggler

  describe TernarySearchTree do

    before do
      @tst = TernarySearchTree.new
    end

    it 'should not contain anything yet' do
      @tst.length.should be_equal 0
      @tst[''].should be_nil
    end

    it 'should accept single element on creation' do
      @tst = TernarySearchTree.new('foo')
      @tst.length.should == 1
    end

    it 'should accept an Array on creation' do
      @tst = TernarySearchTree.new(%w( foo bar ))
      @tst.length.should == 2
    end

    it 'should store inserted values' do
      v = %w( foo bar foobar barfoo fo ba foo1 bar1 zzz )
      v.each { |val| @tst << val }

      @tst.length.should be_equal v.length
      rv = @tst.collect { |v| v }.sort
      rv.should == v.sort
    end

    it 'should find exact matches' do
      v = %w( foo bar foobar barfoo fo ba foo1 bar1 zzz )
      v.each { |val| @tst << val }

      v.each do |val|
        @tst[val].should == val
      end
    end

    it 'should not find non-existing elements' do
      %w( foo bar foobar barfoo fo ba foo1 bar1 zzz ).each { |v| @tst << v }

      @tst['foos'].should be_nil
      @tst['bax'].should be_nil
      @tst[''].should be_nil
    end

    it 'should find partial matches' do
      %w( foo bar foobar barfoo ba foo1 bar1 zzz ).each { |v| @tst << v }

      @tst['foo', true].sort.should == [ 'foo' ]
      @tst['fo', true].sort.should == %w( foo foobar foo1 ).sort
      @tst['b', true].sort.should == %w( bar barfoo ba bar1 ).sort
      @tst['zzz', true].should == [ 'zzz' ]
    end

    it 'should not find non-existing elements' do
      %w( foo bar foobar barfoo fo ba foo1 bar1 zzz ).each { |v| @tst << v }

      @tst['foos', true].should be_nil
      @tst['', true].should be_nil
    end

    it 'maxDepth should work' do
      v = %w( a b c d e f)
      v.each { |val| @tst << val }
      @tst.maxDepth.should == v.length
    end

    it 'should be able to balance a tree' do
      %w( aa ab ac ba bb bc ca cb cc ).each { |v| @tst << v }
      @tst = @tst.balanced
      # The tree will not be perfectly balanced.
      @tst.maxDepth.should == 5
    end

  end

end

