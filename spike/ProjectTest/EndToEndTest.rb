require "spike/ProjectTest/VisualStudio"
require "spike/ProjectTest/NUnit"
require "spike/ShadowFolder"
require "spike/ProjectTest/TestReport"

if __FILE__ == $0
  folder = ShadowFolder.new
  
  folder.shadow 'C:\Code\MutationTesting\tests\test_project' do |root_path|
	  solution_path = File.join root_path, 'SampleDotNetProject/SampleCodeLibrary/SampleCodeLibrary.sln'
	  test_project_path = File.join root_path, 'SampleDotNetProject/SampleCodeTests/SampleCodeTests.csproj'
	  test_runner_path = File.join root_path, 'NUnit_2.5.7_SampleInstall/bin/net-2.0/nunit-console.exe'
    test_results_path = File.join root_path, 'test_results.xml'
	  
    test_report = TestReport.new
    system_call = SystemCall.new
	  visual_studio = VisualStudio.new solution_path, system_call
	  nunit = NUnit.new test_runner_path, test_project_path, test_results_path, system_call
	  
	  test_report.compile_using visual_studio
	  test_report.unit_test_using nunit
	  visual_studio.report_compilation_results_to test_report
	  nunit.report_test_results_to test_report
	  
	  test_report.run_test
  end
end