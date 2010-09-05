class TestResultSpy
  def unit_tests_passed
    @tests_passed = true
  end
  
  def unit_tests_failed
    @tests_passed = false
  end

  def tests_passed
    @tests_passed
  end
  
  def tests_failed
    not @tests_passed
  end
end