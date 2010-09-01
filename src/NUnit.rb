class NUnit
  def initialize working_folder_path, test_runner_path, code_to_test
    @test_runner = File.join working_folder_path, test_runner_path 
    @test_results_path = File.join working_folder_path, 'test_results.xml'
    @test_command = File.join working_folder_path, code_to_test
  end
  
  def test    
    system @test_runner, @test_command, "/xml:#{@test_results_path}"
    
	raise "Test results weren't found" if !File.exists? @test_results_path
	
    test_results_file = File.open(@test_results_path, 'r')
    test_results_text = test_results_file.read
    test_results_file.close 
    
    @test_report.unit_tests_completed test_results_text
  end
  
  def report_test_results_to test_report
	@test_report = test_report
  end
end