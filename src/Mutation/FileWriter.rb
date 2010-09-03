class FileWriter
  def initialize
    @files_being_written = {}
  end
  
  def open filepath
    raise "File \"#{filepath}\" already open for writing!" if @files_being_written.has_key? filepath
    
    @files_being_written[filepath] = File.open(filepath, 'w')
  end
  
  def write filepath, text
    file = @files_being_written[filepath]
    file.puts text
  end
  
  def close filepath
    file = @files_being_written[filepath]
    file.close
    
    @files_being_written.delete filepath
  end
end
