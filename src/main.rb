require 'fileutils'
include FileUtils

# User defined settings
working_folder_path = 'c:\\code\\MutationTesting\\TestWorkingFolder'
golden_copy_path = 'c:\\Code\\MutationTesting\\SampleDotNetProject'
solution_to_build = 'SampleCodeLibrary\\SampleCodeLibrary.sln'
code_to_test = 'SampleCodeTests\\bin\\Debug\\SampleCodeTests.dll'
code_to_mutate = "SampleCodeLibrary"
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
    system @compiler_path, @build_path, "/verbosity:q"
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

class ReadableTextFile
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

class LineCommentedOutMutator
  def initialize golden_root_path, writable_root_path, output_channel, writeable_file
    @golden_root_path = golden_root_path
    @writable_root_path = writable_root_path
    @output_channel = output_channel
    @writeable_file = writeable_file
  end

  def comment_out relative_file_path, line_number, line_text
    current_line_number = 0
    File.open("#{@golden_root_path}\\#{relative_file_path}", 'r') do |line_from_file|
      writable_file = File.open("#{@writable_root_path}\\#{relative_file_path}", "w")
      current_line_number += 1
      if current_line_number == line_number
        puts "// #{line_text}"
        @writeable_file.write File.join(@writable_root_path, relative_file_path), line_number, "// #{line_text}"
      else
        writable_file.puts line_text
      end
      writable_file.close
    end
    
    @output_channel.next relative_file_path
  end
end

class LineCommentingMutationController
  def initialize writer, tester
    @line_counter = 0
    @writer = writer
    @tester = tester
  end
  
  def next_file relative_file_path
    @file = relative_file_path
  end
  
  def next text
    @line_counter += 1
    if text.strip != ""
      @writer.write(@file, @line_counter, "//" + text)
      @tester.next "#{@file}, #{@line_counter}, #{text}"
    end
  end
end

class RecursivelyFindCodeFilesInFolder
  def initialize(path, mutation_controller, file_reader)
    @path = path
    @mutation_controller = mutation_controller
    @file_reader = file_reader
  end
  
  def start
    Dir.chdir(@path) do
      file_paths = File.join("**", "*.cs")
      
      for relative_file_path in Dir.glob(file_paths) 
        @mutation_controller.next_file relative_file_path
        @file_reader.read File.join(@path, relative_file_path)
      end
    end
  end
end

class LineWriteableTextFile
  def initialize writeable_root_path
    @root_path = writeable_root_path
  end

  def write file_name, line_number, text
    puts "Writing to #{@root_path} & #{file_name} at line number #{line_number}: #{text}"
  
    writeable_path = File.join(@root_path, file_name)
    lines_of_text = File.open(writeable_path, 'r').readlines
    writeable_file = File.new(writeable_path, 'w')
    current_line_number = 0
    for line in lines_of_text
      current_line_number += 1
      if current_line_number == line_number
        writeable_file.puts text
      else
        writeable_file.puts line
      end
    end
  end
end

class WriteableTextFile
  def initialize file_name
    @file_name = file_name
    @file = nil
  end
  
  def write line
    if @file == nil
      @file = File.new @file_name, 'w'
    end
    
    @file.puts line
  end
  
  def close
    @file.close if @file != nil
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

class OutputChannel
  def next_file input
    puts input
  end
end

class TestRunner
  def initialize test, working_folder
    @test = test
    @working_folder = working_folder
  end
  
  def next data
    puts data
  
    #@working_folder.reset
    @test.test do |baseline_test_result|
      case baseline_test_result
        when :tests_passed then 
          puts "#{data} Passed! BAD BAD BAD >:("
        when :tests_failed then 
          puts "#{data} Failed! Good. :)"
      end
    end
  end
end

if __FILE__ == $0
  working_folder = WorkingFolder.new golden_copy_path, working_folder_path
  baseline_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path
  
  tester = TestRunner.new baseline_test, working_folder
  writer = LineWriteableTextFile.new File.join(golden_copy_path, code_to_mutate)
  mutation_controller = LineCommentingMutationController.new writer, tester
  code_file_reader = ReadableTextFile.new mutation_controller
  file_finder = RecursivelyFindCodeFilesInFolder.new File.join(golden_copy_path, code_to_mutate), mutation_controller, code_file_reader
  
  working_folder.reset
  baseline_test.test do |test_result|
    if test_result == :tests_failed
      puts "Tests passed! FAILURE!"
    else
      file_finder.start
    end
  end
end


=begin
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
=end
