require "tmpdir"
require "StringIO"
include FileUtils

class ShadowFolder
  def initialize path_to_shadow
    @path_to_shadow = path_to_shadow
    @temp_root = Dir.mktmpdir
  end

  def shadow
    cp_r @path_to_shadow + '\\.', @temp_root
  end
  
  def destroy
    rm_r @temp_root
    raise "Folder not destroyed!!" if File.directory? @temp_root
  end
  
  def root_path
    @temp_root
  end
end

class VisualStudio
  def initialize 
    @compiler_path = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe'
  end
  
  def compile project_file_path
    return `#{@compiler_path} #{project_file_path}`
  end
end

class NUnit
  def initialize working_folder_path, test_runner_path, code_to_test
    @working_folder_path = working_folder_path
    @test_runner = File.join working_folder_path, test_runner_path 
    @test_results_path = File.join working_folder_path, 'test_results.xml'
    @test_command = File.join working_folder_path, code_to_test
  end
  
  def test    
    system @test_runner, @test_command, "/xml:#{@test_results_path}"
    
    test_results_file = File.open(@test_results_path, 'r')
    test_results_text = test_results_file.read
    test_results_file.close 
    
    return test_results_text
  end
end

class CodeUnderTest
  def initialize(working_folder_path, solution_to_build, code_to_test, test_runner_path)
    @compiler = VisualStudio.new
    @nunit = NUnit.new working_folder_path, test_runner_path, code_to_test
  end
  
  def on_test_results_received test_report
    @test_report = test_report
  end

  def test
    compilation_report = @compiler.compile @build_path
    unit_test_report = @nunit.test
    
    @test_report.compilation_completed compilation_report
    @test_report.unit_tests_completed unit_test_report
    
    @test_report.test_complete
  end
end

class TestReport
  def initialize
    @tests_passed = true
  end

  def unit_tests_completed test_results
    @tests_passed = false if !test_results.include?('failures="0"')
  end
  
  def compilation_completed test_results    
    @tests_passed = false if test_results.include? "FAILED"
  end
  
  def test_complete
    if @tests_passed
      puts "Tests passed!"
    else
      puts "Tests failed!"
    end
  end
end

if __FILE__ == $0
  folder = ShadowFolder.new 'C:\projects\IronClad\tests\test_project'
  folder.shadow

  solution_path = 'SampleDotNetProject/SampleCodeLibrary/SampleCodeLibrary.sln'
  test_project_path = 'SampleDotNetProject/SampleCodeTests/SampleCodeTests.csproj'
  test_runner_path = 'NUnit_2.5.7_SampleInstall/bin/net-2.0/nunit-console.exe'
  
  test_report = TestReport.new
  code_under_test = CodeUnderTest.new folder.root_path, solution_path, test_project_path, test_runner_path
  code_under_test.on_test_results_received test_report
  
  code_under_test.test    
  
  folder.destroy
end