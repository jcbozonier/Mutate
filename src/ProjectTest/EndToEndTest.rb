require "StringIO"
include FileUtils
require "src/ProjectTest/VisualStudio"
require "src/ProjectTest/NUnit"
require "src/ShadowFolder"
require "src/ProjectTest/TestReport"

if __FILE__ == $0
  folder = ShadowFolder.new 'C:\Code\MutationTesting\tests\test_project'
  
  folder.shadow do |root_path|
	  solution_path = File.join root_path, 'SampleDotNetProject/SampleCodeLibrary/SampleCodeLibrary.sln'
	  test_project_path = 'SampleDotNetProject/SampleCodeTests/SampleCodeTests.csproj'
	  test_runner_path = 'NUnit_2.5.7_SampleInstall/bin/net-2.0/nunit-console.exe'
	  
	  visual_studio = VisualStudio.new(solution_path)
	  nunit = NUnit.new(root_path, test_runner_path, test_project_path)
	  test_report = TestReport.new
	  
	  test_report.compile_using visual_studio
	  test_report.unit_test_using nunit
	  visual_studio.report_compilation_results_to test_report
	  nunit.report_test_results_to test_report
	  
	  test_report.run_test
  end
end