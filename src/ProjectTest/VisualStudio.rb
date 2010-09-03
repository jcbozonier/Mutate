class VisualStudio
  def initialize solution_to_build, system_call
    @compiler_path = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe'
    @build_path = solution_to_build
    @system_call = system_call
  end
  
  def compile
    @system_call.call @compiler_path, @build_path do |results|
      @test_report.compilation_completed results
    end
  end
  
  def report_compilation_results_to test_report
	@test_report = test_report
  end
end