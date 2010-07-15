require 'main.rb'

describe "When receiving a comment" do
  before(:each) do
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next "// testing"
  end
  
  it "should pass the appropriate token onward" do
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
