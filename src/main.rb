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
    test_results_file = File.open(@test_results_path, 'r')
    tests_passed = test_results_file.read.include? 'failures="0"'
    test_results_file.close 

    yield :tests_passed if tests_passed
    yield :tests_failed if !tests_passed
  end
end

class MutationProcess
  def initialize working_folder, after_mutation_test, test_report
    @working_folder = working_folder
    @after_mutation_test = after_mutation_test
    @test_report = test_report
  end

  def start
    tests_pass = false
    testing_done = false
    begin
      @working_folder.reset

      # MUTATE CODE HERE

      @after_mutation_test.test do |mutation_test_result|
        case mutation_test_result
          when :tests_passed 
            @test_report.code_mutated_but_tests_pass
            tests_pass = true
          when :tests_failed
            @test_report.code_mutated_and_tests_failed
            testing_done = true
        end
      end
    end until tests_pass or testing_done
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

test_report = TestReport.new
working_folder = WorkingFolder.new golden_copy_path, working_folder_path
baseline_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path
after_mutation_test = CodeUnderTest.new working_folder_path, solution_to_build, code_to_test, test_runner_path
mutation_process = MutationProcess.new working_folder, after_mutation_test, test_report 

working_folder.reset
baseline_test.test do |baseline_test_result|
  case baseline_test_result
    when :tests_passed then 
      mutation_process.start
    when :tests_failed then 
      test_report.baseline_test_failed
  end
end


