class TestReport
  def initialize
    @tests_passed = true
  end

  def unit_tests_completed test_results
    @unit_tests_completed = true
	@tests_passed = false if !test_results.include?('failures="0"')
	
	test_complete if @unit_tests_completed and @compilation_completed
  end

  def compilation_completed test_results
	@compilation_completed = true
	puts test_results
    @tests_passed = false if test_results.include? "FAILED"
	
	test_complete if @unit_tests_completed and @compilation_completed
  end

  def compile_using compiler
	@compiler = compiler
  end

  def unit_test_using testing_framework
	@testing_framework = testing_framework
  end

  def run_test
    compilation_report = @compiler.compile	
    unit_test_report = @testing_framework.test
  end

  def test_complete
    if @tests_passed
      puts "Tests passed!"
    else
      puts "Tests failed!"
    end
  end
end