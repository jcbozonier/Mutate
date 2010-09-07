class TestFileSystem
  def search_path
    @search_path
  end
  
  def glob search_string
    @search_path = search_string
  end
end