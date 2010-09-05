class FileSystem
  def read_all path
    file = File.open(path, 'r')
    yield file.read
    file.close
  end
  
  def read_each_line file_path
    target_file = File.open file_path
    target_file.each_line{ |line|
      yield line
    }
    target_file.close
  end
  
  def write_all file_path, text_to_write
    target_file = File.open(file_path, 'w')
    target_file.write(text_to_write)
    target_file.close
  end
  
  def exists? path
    File.exists? path
  end
  
  def glob search_pattern
    yield Dir.glob(search_pattern)
  end
end