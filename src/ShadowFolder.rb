class ShadowFolder
  def initialize path_to_shadow
    @path_to_shadow = path_to_shadow
    @temp_root = Dir.mktmpdir
  end

  def shadow
    cp_r @path_to_shadow + '\\.', @temp_root
	
    yield @temp_root
    
    rm_r @temp_root
    raise "Folder not destroyed!!" if File.directory? @temp_root
  end
  
  def root_path
    @temp_root
  end
end