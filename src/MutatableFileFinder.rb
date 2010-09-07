class MutatableFileFinder
  def search directory_path
    @file_system.glob File.join directory_path, '**/*.cs'
  end
  
  def search_complete
    @commentable_line_finder.no_more_files
  end

  def on_file_updates_notify file_system
    @file_system = file_system
  end
  
  def when_commentable_files_are_found_notify commentable_line_finder
    @commentable_line_finder = commentable_line_finder
  end
  
  def next_path_found path
    @commentable_line_finder.next_file_path path
  end
end
