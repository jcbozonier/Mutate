class FileLineReplacer
  def provided_root_path
    @provided_root_path
  end
  
  def provided_line_number
    @provided_line_number
  end

  def provided_line_of_text
    @provided_line_of_text
  end
  
  def provided_target_file_path
    @provided_target_file_path
  end
  
  def replace_with_this_line line_number, line_of_text, target_file_path, root_path
    @provided_root_path = root_path
    @provided_line_number = line_number
    @provided_line_of_text = line_of_text
    @provided_target_file_path = target_file_path
  end
end