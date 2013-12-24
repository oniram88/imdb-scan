begin
  require 'rspec/expectations';
rescue LoadError;
  require 'spec/expectations';
end
require 'cucumber/formatter/unicode'
$:.unshift(File.dirname(__FILE__) + '/../../lib')
require 'imdb'

Before do
end

After do
end

Given /I have person with id "(.*)"/ do |n|
  @result = IMDB::Person.new(n.to_s)
end

Then /^the name should be "(.*)"$/ do |name|
  @result.name.should == name
end

Then /^the films where he was actor should be "(.*)"$/ do |number|
  res=@result.filmography
  res.length.should == number.to_i
end

Then /^the height of the actor should be "(.*)"$/ do |height|
  @result.height.should == height.to_f
end

Then /^the photo should be a link to an image$/ do
  @result.photo.should be_kind_of String
  @result.photo.should =~ /^http:.*jpg$/
end

When /^the birth date should be "([^"]*)"$/ do |arg|
  @result.birthdate.should == Date.parse(arg)
end

When /^the profile path shuld be "([^"]*)"$/ do |arg|
  @result.profile_path.should == arg
end

When /^the real name shoud be "([^"]*)"$/ do |arg|
  @result.real_name.should == arg
end