#Test Framework
require 'test/unit'

#Subject Under Test
require 'src/MutationTest'

#Test Objects
require 'unit_tests/TestObjects/TestCompiler'
require 'unit_tests/TestObjects/TestTestRunner'
require 'unit_tests/TestObjects/TestResultSpy'

class Test_tests < Test::Unit::TestCase
  def setup
    @working_folder_path = 'working_folder_path'
    @project_path = 'project_path'
    @test_project_path = 'test project path'
    @expected_compiled_project_path = File.join @working_folder_path, @project_path
    @expected_test_project_path = File.join @working_folder_path, @test_project_path
  end

  def test_when_running_a_test
    compiler = TestCompiler.new
    test = MutationTest.new
    test.on_compile_notify compiler
    
    test.run @working_folder_path, @project_path, @test_project_path
    
    assert compiler.was_ran, 'Compiler was not ran and it should have been.'
    assert_equal @expected_compiled_project_path, compiler.compiled_project_path, 'The correct project path should be compiled.'
  end
  
  def test_when_compiled_successfully
    test_runner = TestTestRunner.new
    test = MutationTest.new
    test.on_unit_test_notify test_runner
    
    # smell: compilation does need to happen but I know
    # which test project to run even if I don't compile.
    # this means then that there's an implicit dependency
    # on compilation before running the test runner.
    # there should be a better way to get the test project
    # path to the test runner without requiring an implicit
    # dependency on compilation.
    # I could just capture that information on an initialization
    # method or during object construction.
    
    test.on_compile_notify TestCompiler.new
    
    test.run @working_folder_path, 'none', @test_project_path
    test.compiled_successfully
    
    assert test_runner.was_ran, 'should run test runner'
    assert_equal @expected_test_project_path, test_runner.test_project_path, 'should run the correct_test_project'
  end
  
  def test_when_compiled_unsuccessfully
    test_runner = TestTestRunner.new
    test = MutationTest.new
    test.on_unit_test_notify test_runner
    
    test.compiled_unsuccessfully
    
    assert test_runner.was_NOT_ran, "should not run test runner if the project could not compile"
  end
  
  def test_when_unit_tests_pass
    test_result_spy = TestResultSpy.new
    test = MutationTest.new
    test.on_test_results_notify test_result_spy
    
    test.unit_tests_passed
    
    assert test_result_spy.tests_passed, "should notify that the tests passed."
  end
  
  def test_when_unit_tests_fail
    test_result_spy = TestResultSpy.new
    test = MutationTest.new
    test.on_test_results_notify test_result_spy
    
    test.unit_tests_failed
    
    assert test_result_spy.tests_failed, "should notify that the tests failed"
  end
  
  # def teardown
  # end
end