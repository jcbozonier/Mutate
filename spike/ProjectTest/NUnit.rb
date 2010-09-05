require "src/FileSystem"
require "spike/ProjectTest/SystemCall"

class NUnit
  def initialize test_runner_path, code_to_test, test_results_path, system_call
    @test_runner = test_runner_path
    @test_results_path = test_results_path
    @test_command = code_to_test
    @file_system = FileSystem.new
    @system_call = system_call
  end
  
  def test    
    @system_call.call @test_runner, @test_command, "/xml:#{@test_results_path}" do |results|
      raise "Test results weren't found" if !@file_system.exists? @test_results_path
    
      @file_system.read_all @test_results_path do |text|
        @test_report.unit_tests_completed text
      end
    end
  end
  
  def report_test_results_to test_report
    @test_report = test_report
  end
end