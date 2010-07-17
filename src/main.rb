require 'fileutils'
include FileUtils

# User defined settings
working_folder_path = 'c:\\code\\MutationTesting\\TestWorkingFolder'
golden_copy_path = 'c:\\Code\\MutationTesting\\SampleDotNetProject'
solution_to_build = 'SampleCodeLibrary\\SampleCodeLibrary.sln'
code_to_test = 'SampleCodeTests\\bin\\Debug\\SampleCodeTests.dll'
test_runner_path = 'C:\\Code\\MutationTesting\\lib\\NUnit\\nunit-console.exe'

class WorkingFolder
  def initialize(golden_copy_path, working_folder_path)
    @golden_copy_path = golden_copy_path
    @working_folder_path = working_folder_path 
  end
  
  def reset
    rm_rf @working_folder_path if File.directory? @working_folder_path
    mkdir @working_folder_path
    cp_r @golden_copy_path + '\\.', @working_folder_path
  end
end

class CodeUnderTest
  def initialize(working_folder_path, solution_to_build, code_to_test, test_runner_path)
    @test_runner = test_runner_path 
    @test_command = "#{working_folder_path}\\#{code_to_test}"
    @test_results_path = "#{working_folder_path}\\test_results.xml"
    @build_path = working_folder_path + '\\' + solution_to_build
    @compiler_path = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe'
  end

  def test
    system @compiler_path, @build_path
    system @test_runner, @test_command, "/xml:#{@test_results_path}"

    tests_passed = false

    if File.exists?(@test_results_path)
      test_results_file = File.open(@test_results_path, 'r')
      tests_passed = test_results_file.read.include?('failures="0"')
      test_results_file.close 
    end

    yield :tests_passed if tests_passed
    yield :tests_failed if !tests_passed
  end
end

class TestReport
  def baseline_test_failed
    puts 'Baseline tests on golden code failed. Mutation testing can not begin.' 
  end

  def code_mutated_but_tests_pass
    puts 'Mutation but no failing test!'
  end

  def code_mutated_and_tests_failed
    puts 'Test failed after mutation.'
  end
end

class TextFile
  def initialize output
    @output = output
  end

  def read file_path
    File.open(file_path, 'r') do |line_from_file|
      while (current_line = line_from_file.gets)
        @output.next current_line
      end
    end
  end
end

class TokenFile
  def initialize output_channel
    @output_channel = output_channel
    @character_list = ''
    @current_token = :none
  end

  def next *args
    for data in args
      self.done if data == Literals.newline

      @character_list += data
      @current_token = :comment if @character_list == Literals.comment_literal
    end
  end

  def done
    if @current_token == :comment
      @output_channel.next Comment.new @character_list
    end
  end
end

class Literals
  def self.comment_literal
    "//"
  end
  def self.newline
    '\n'
  end
end

class Comment
  def initialize comment_text
    @comment_text = comment_text
  end

  def comment_text
    @comment_text
  end

  def ==(another_comment)
    @comment_text == another_comment.comment_text
  end
end

if __FILE__ == $0
  test_report = TestReport.new
  working_folder = WorkingFolder.new golden_copy_path, working_folder_path
  baseline_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path
  after_mutation_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path

  working_folder.reset
  baseline_test.test do |baseline_test_result|
    case baseline_test_result
    when :tests_passed then 
      puts "Tests passed!"
    when :tests_failed then 
      test_report.baseline_test_failed
    end
  end

end
