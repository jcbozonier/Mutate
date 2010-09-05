require "tmpdir"
include FileUtils

class ShadowFolder
  def shadow path
    temp_root = Dir.mktmpdir
    cp_r path + '\\.', temp_root
	
    yield temp_root
    
    rm_r temp_root
    raise "Folder not destroyed!!" if File.directory? temp_root
  end
end