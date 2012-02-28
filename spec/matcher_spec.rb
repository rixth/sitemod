require File.dirname(__FILE__) + '/spec_helper'

describe Sitemod::Matcher, "#directory_matches_uri?" do
  before(:each) do
    @matcher = Sitemod::Matcher.instance
  end

  it 'matches domains correctly' do
    @matcher.directory_matches_uri?("example.com", URI("http://example.com")).should be_true
    @matcher.directory_matches_uri?("example.com", URI("http://www.example.com/with/path")).should be_true
    @matcher.directory_matches_uri?("example.com", URI("http://different.com")).should be_false
  end

  it 'matches subdomains correctly' do
    @matcher.directory_matches_uri?("subdomain.example.com", URI("http://example.com")).should be_false
    @matcher.directory_matches_uri?("subdomain.example.com", URI("http://subdomain.example.com")).should be_true
    @matcher.directory_matches_uri?("example.com", URI("http://subdomain.example.com")).should be_false
  end

  it 'matches paths correctly' do
    @matcher.directory_matches_uri?("example.com/with_path", URI("http://example.com")).should be_false
    @matcher.directory_matches_uri?("example.com/with_path", URI("http://example.com/with_path")).should be_true
    @matcher.directory_matches_uri?("example.com/with_path", URI("http://example.com/with_path/")).should be_true
    @matcher.directory_matches_uri?("example.com", URI("http://www.example.com/with/path")).should be_true
  end

  it 'matches nested paths correctly' do
    @matcher.directory_matches_uri?("example.com/with/nested/path", URI("http://example.com")).should be_false
    @matcher.directory_matches_uri?("example.com/with/nested/path", URI("http://example.com/with/nested/path")).should be_true
  end

  it 'matches wildcard paths correctly' do
    @matcher.directory_matches_uri?("example.com/*/nested/path", URI("http://example.com")).should be_false
    @matcher.directory_matches_uri?("example.com/*/nested/path", URI("http://example.com/hello/nested")).should be_false
    @matcher.directory_matches_uri?("example.com/*/nested/path", URI("http://example.com/hello/nested/path")).should be_true
    @matcher.directory_matches_uri?("example.com/*/nested/path", URI("http://example.com/hello/crazy/path")).should be_false
    @matcher.directory_matches_uri?("example.com/with/*", URI("http://example.com")).should be_false
    @matcher.directory_matches_uri?("example.com/*/nested/path", URI("http://example.com/with/nested/path")).should be_true
    @matcher.directory_matches_uri?("example.com/*/*/path", URI("http://example.com/with/nested/path")).should be_true
  end
end


describe Sitemod::Matcher, "#get_directories_for_url" do
  directories = [
    "www.example.com",
    "example.com",
    "subdomain.example.com",
    "example.com/with_path",
    "subdomain.example.com/with_path",
    "example.com/with/nested/path",
    "example.com/with/wild/*/path",
    "example.com/with/wild/something/path",
    "subdomain.example.com/with/nested/path",
    "subdomain.example.com/a_*/path",
    "example.net/path/*",
    "example.net/path/concrete",
  ]

  before(:each) do
    @matcher = Sitemod::Matcher.instance
    @matcher.directories = directories
  end

  context "with domain" do
    it "correctly matches domains" do
      @matcher.get_directories_for_url("http://www.example.com").should =~ ["example.com", "www.example.com"]
    end

    it "correctly matches paths" do
      @matcher.get_directories_for_url("http://www.example.com/with_path").should =~ [
        "example.com/with_path",
        "example.com",
        "www.example.com"
      ]
    end

    it "correctly matches nested paths" do
      @matcher.get_directories_for_url("http://www.example.com/with/nested/path").should =~ [
        "example.com/with/nested/path",
        "example.com",
        "www.example.com"
      ]
    end

    it "correctly matches wildcard paths" do
      @matcher.get_directories_for_url("http://www.example.com/with/wild/#{rand.to_s}/path").should =~ [
        "example.com/with/wild/*/path",
        "example.com",
        "www.example.com"
      ]

      # Make sure it matches properly when there is a concrete AND wild match
      @matcher.get_directories_for_url("http://www.example.com/with/wild/something/path").should =~ [
        "example.com/with/wild/*/path",
        "example.com/with/wild/something/path",
        "example.com",
        "www.example.com"
      ]

      # And that it works with trailing wildcards
      @matcher.get_directories_for_url("http://www.example.net/path/with/randomness/#{rand.to_s}").should =~ [
        "example.net/path/*"
      ]
    end
  end
end