class TestTestRunner
  def test test_project_path
    @was_ran = true
    @test_project_path = test_project_path
  end
  
  def was_ran
    @was_ran
  end
  
  def was_NOT_ran
    not @was_ran
  end
  
  def test_project_path
    @test_project_path
  end
end