class VisualStudio
  def initialize(solution_to_build) 
    @compiler_path = 'C:\\Windows\\Microsoft.NET\\Framework\\v4.0.30319\\msbuild.exe'
	@build_path = solution_to_build
  end
  
  def compile
    @test_report.compilation_completed `#{@compiler_path} #{@build_path}`
  end
  
  def report_compilation_results_to test_report
	@test_report = test_report
  end
end