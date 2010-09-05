class MutationTest
  def initialize
  end

  def on_compile_notify compiler
    @compiler = compiler
  end
  
  def on_test_results_notify test_results
    @test_results = test_results
  end
  
  def on_unit_test_notify test_runner
    @test_runner = test_runner
  end
  
  def run working_folder, relative_project_path, test_project_path
    @test_project_path = File.join working_folder, test_project_path    
    @compiler.compile File.join working_folder, relative_project_path
  end
  
  def compiled_successfully
    @test_runner.test @test_project_path
  end
  
  def compiled_unsuccessfully
    
  end
  
  def unit_tests_passed
    @test_results.unit_tests_passed
  end
  
  def unit_tests_failed
    @test_results.unit_tests_failed
  end
end