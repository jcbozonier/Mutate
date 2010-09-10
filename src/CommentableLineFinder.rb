class CommentableLineFinder
  def next_file root_path, relative_path
    @current_root_path = root_path
    @current_relative_path = relative_path
    
    if @file_system
      @file_system.start_reading_all_lines File.join root_path, relative_path
    end
  end
  
  def next_line text    
    if not /^\s*\/\//.match(text) and text.strip != ''
      @current_line_number = 0 if @current_line_number.equal? nil
      @current_line_number += 1
      @next_line_observer.next_line @current_line_number, @current_root_path, @current_relative_path, text
    end
  end
  
  def for_file_system_access_use file_system
    @file_system = file_system
  end
  
  def on_next_line_found_notify observer
    @next_line_observer = observer
  end
end