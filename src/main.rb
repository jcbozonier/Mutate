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

  def test(to_do)
    system @compiler_path, @build_path
    system @test_runner, @test_command, "/xml:#{@test_results_path}"
    test_results_file = File.open(@test_results_path, 'r')
    tests_passed = test_results_file.read.include? 'failures="0"'
    
    if tests_passed
      to_do[:when_tests_pass].call
    else
      to_do[:when_tests_fail].call
    end
  end
end


working_folder = WorkingFolder.new golden_copy_path, working_folder_path
baseline_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path

working_folder.reset
baseline_test.test(
  {
    :when_tests_pass=>lambda{puts "tests passed!"}, 
    :when_tests_fail=>lambda{puts "tests failed!"}
  })
