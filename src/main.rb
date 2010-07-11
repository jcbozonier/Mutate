require 'fileutils'
include FileUtils

# User defined settings
working_folder_path = 'c:\\code\\MutationTesting\\TestWorkingFolder'
golden_copy_path = 'c:\\Code\\MutationTesting\\SampleDotNetProject'

class WorkingFolder
  def initialize(golden_copy_path, working_folder_path)
    @golden_copy_path = golden_copy_path
    @working_folder_path = working_folder_path 
  end
  
  def reset
    if File.directory? @working_folder_path
      rm_rf @working_folder_path
    end
    mkdir @working_folder_path
    cp_r @golden_copy_path + '\\.', @working_folder_path
  end
end

folder = WorkingFolder.new golden_copy_path, working_folder_path
folder.reset

