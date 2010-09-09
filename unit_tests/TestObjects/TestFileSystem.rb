class TestFileSystem
  def search_path
    @search_path
  end
  
  def glob search_string
    @search_path = search_string
  end
  
  def file_path_lines_were_requested_from
    @file_path_lines_were_requested_from
  end
  
  def start_reading_all_lines file_path
    @file_path_lines_were_requested_from = file_path
  end
end