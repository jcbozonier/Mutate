require 'src/ShadowFolder'
require 'src/FileSystem'
require 'src/Mutation/Mutator'
require 'src/Mutation/FileWriter'
require 'src/Mutation/MutationController'
require "StringIO"

if __FILE__ == $0
  file_system = FileSystem.new
  folder = ShadowFolder.new
  mutation_controller = MutationController.new file_system, Mutator.new(FileWriter.new), folder
  
  folder.shadow 'C:\Code\MutationTesting\tests\test_project' do |root_path|
    working_folder = File.join root_path, "SampleDotNetProject"
    search_pattern = File.join working_folder, "**", "*.cs"
    
    file_system.glob(search_pattern) do |mutatable_file_paths|
      mutatable_file_paths.each{ |mutatable_file_path|
        relative_mutatable_file_path = mutatable_file_path.sub(working_folder, '')
        
        file_line_number = 0
        
        file_system.read_each_line mutatable_file_path do |mutatable_line|
          file_line_number += 1        
          mutation_controller.mutate working_folder, file_line_number, relative_mutatable_file_path
        end
      }
    end
  end
end