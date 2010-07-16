require 'main.rb'

describe "When receiving an indeterminate character" do
  before(:each) do
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next "/"

  end
  
  it "should NOT pass a token onward" do
    @output_channel.data.should == nil 
  end 
end

describe "When receiving characters that define a comment but not done" do
  before(:each) do
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next "/"
    token_file.next "/"
  end
  
  it "should NOT pass a token onward" do
    @output_channel.data.should == nil 
  end 
end

describe "When receiving characters that define a complete comment" do
  before(:each) do
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next "/"
    token_file.next "/"
    token_file.done
  end

  it "should pass a comment token onward" do
    @output_channel.data.should == :comment
  end
end

class OutputChannel
  def initialize
  end
        
  def next data
    @data = data
  end

  def data
    @data
  end

  def data=(val)
    @data = val
  end
end
