class TestCompiler
  def was_ran
    @was_ran
  end
  
  def compile project_path
    @was_ran = true
    @compiled_project_path = project_path
  end
  
  def compiled_project_path
    @compiled_project_path
  end
end