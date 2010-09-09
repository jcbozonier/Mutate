class TestCommentableLineFinderObserver
  def current_line_number
    @current_line_number
  end
  
  def current_relative_path
    @current_relative_path
  end
  
  def current_root_path
    @current_root_path
  end
  
  def current_line_of_text
    @current_line_of_text
  end
  
  def next_line line_number, current_root_path, current_relative_path, current_line_of_text
    @current_line_number = line_number
    @current_root_path = current_root_path
    @current_relative_path = current_relative_path
    @current_line_of_text = current_line_of_text
  end
end