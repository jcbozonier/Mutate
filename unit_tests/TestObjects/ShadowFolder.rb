class ShadowFolder
  def root_path_to_copy
    @root_path
  end
  
  def shadow path
    @root_path = path
  end
end