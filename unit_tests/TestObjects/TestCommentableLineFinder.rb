class TestCommentableLineFinder
  def found_path
    @found_path
  end
  
  def next_file_path path
    @found_path = path
  end
  
  def no_more_files
    @completed_searching = true
  end
  
  def completed_searching
    @completed_searching
  end
end