require File.dirname(__FILE__) + '/spec_helper'

describe Sitemod::Matcher do
  it "should be true" do
    Sitemod::Matcher.new.is_true?.should be_true
  end
end