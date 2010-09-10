class SafeLineCommenter
  def next_line line_number, line_of_text, target_file_path, root_path
    @line_number = line_number
    @line_of_text = line_of_text
    @target_file_path = target_file_path
    
    @shadow_folder.shadow root_path
  end
  
  def folder_shadowed shadow_folder_path
    @file_replacer.replace_with_this_line @line_number, @line_of_text, @target_file_path, shadow_folder_path
  end
  
  def on_shadow_folder_updates_notify shadow_folder
    @shadow_folder = shadow_folder
  end
  
  def on_file_line_replacement_updates_notify file_replacer
    @file_replacer = file_replacer
  end
end