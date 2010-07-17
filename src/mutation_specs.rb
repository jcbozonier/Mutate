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

    token_file.next "/", "/"
  end
  
  it "should NOT pass a token onward" do
    @output_channel.data.should == nil 
  end 
end

describe "When receiving characters that define a complete comment" do
  before(:each) do
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next "/", "/"
    token_file.done
  end

  it "should pass a comment token onward" do
    @output_channel.data.should == (Comment.new "//")
  end
end

describe "When receiving characters that define a complete comment with text" do
  before(:each) do
    @comment_text = "Hello world!"
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next Literals.comment_literal, @comment_text
    token_file.done
  end

  it "should pass the correct comment token onward" do
    expected_result = Literals.comment_literal + @comment_text
    @output_channel.data.should == (Comment.new expected_result)
  end
end

describe "When receiving characters that define a complete comment with text ended by new line" do
  before(:each) do
    @comment_text = "Hello world!"
    @output_channel = OutputChannel.new
    token_file = TokenFile.new @output_channel

    token_file.next Literals.comment_literal, @comment_text, Literals.newline
  end

  it "should pass the correct comment token onward" do
    expected_result = Literals.comment_literal + @comment_text
    @output_channel.data.should == (Comment.new expected_result)
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
