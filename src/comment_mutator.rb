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
    puts @working_folder_path
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

class ReadableTextFile
  def initialize output
    @output = output
  end

  def read file_path
    lines_from_file = File.open(file_path, 'r').readlines
    
    for line_from_file in lines_from_file
      @output.next line_from_file
    end
  end
end

class LineCommentingMutationController
  def initialize writer, tester, working_folder
    @writer = writer
    @tester = tester
    @working_folder = working_folder
  end
  
  def next_file relative_file_path
    @line_counter = 0
    @file = relative_file_path
  end
  
  def next text
    @line_counter += 1
    if text.strip != ""
      @working_folder.reset
      @writer.write(@file, @line_counter, "//" + text)
      @tester.next "#{@file}, #{@line_counter}, #{text}"
    end
  end
  
  def done
    @tester.done
  end 
end

class RecursivelyFindCodeFilesInFolder
  def initialize(path, mutation_controller, file_reader)
    @path = path
    @mutation_controller = mutation_controller
    @file_reader = file_reader
  end
  
  def start
    file_paths = nil
    Dir.chdir(@path) do
      file_paths = Dir.glob(File.join("**", "*.cs"))
    end
    
    for relative_file_path in file_paths
      @mutation_controller.next_file relative_file_path
      @file_reader.read File.join(@path, relative_file_path)
    end
   
    @mutation_controller.done
  end
end

class LineWriteableTextFile
  def initialize writeable_root_path
    @root_path = writeable_root_path
  end

  def write file_name, line_number, text  
    writeable_path = File.join(@root_path, file_name)
    readable_file = File.open(writeable_path, 'r')
    lines_of_text = readable_file.readlines
    readable_file.close
    
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
    writeable_file.close
    
  end
end

class TestRunner
  def initialize test, report_path
    @test = test
    @report_path = report_path
    @report = File.new(@report_path + "\\mutation_report.txt", 'w')
  end
  
  def next data
    puts data
    
    @test.test do |baseline_test_result|
      case baseline_test_result
        when :tests_passed then 
          @report.puts "#{data} Passed! BAD BAD BAD >:("
        when :tests_failed then 
          @report.puts "#{data} Failed! Good. :)"
      end
    end
  end
  
  def done
    @report.close
  end
end

if __FILE__ == $0
  working_folder = WorkingFolder.new golden_copy_path, working_folder_path
  baseline_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path
  
  tester = TestRunner.new baseline_test, "C:\\Code\\MutationTesting\\"
  writer = LineWriteableTextFile.new File.join(working_folder_path, code_to_mutate)
  mutation_controller = LineCommentingMutationController.new writer, tester, working_folder
  code_file_reader = ReadableTextFile.new mutation_controller
  file_finder = RecursivelyFindCodeFilesInFolder.new File.join(golden_copy_path, code_to_mutate), mutation_controller, code_file_reader
  
  working_folder.reset
  baseline_test.test do |test_result|
    if test_result == :tests_failed
      puts "Baseline tests passed! FAILURE!"
    else
      file_finder.start
    end
  end
end
