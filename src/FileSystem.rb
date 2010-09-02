class FileSystem
  def read_all path
    file = File.open(path, 'r')
    yield file.read
    file.close
  end
  
  def exists? path
    File.exists? path
  end
  
  def glob search_pattern
    yield Dir.glob(search_pattern)
  end
end