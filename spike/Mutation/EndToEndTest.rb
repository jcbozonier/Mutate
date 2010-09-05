require 'spike/ShadowFolder'
require 'spike/FileSystem'
require 'spike/Mutation/Mutator'
require 'spike/Mutation/FileWriter'
require 'spike/Mutation/MutationController'
require "StringIO"

class Report
  def mutated_line line_number, text
    puts "Mutated line: #{text}"
  end
  
  def mutating_file file_path
    puts "Mutating file: #{file_path}"
  end
  
  def mutating_line_number line_number
    puts "Mutating line ##{line_number}"
  end
end

if __FILE__ == $0
  file_system = FileSystem.new
  folder = ShadowFolder.new
  report = Report.new
  mutation_controller = MutationController.new file_system, Mutator.new(FileWriter.new, report), folder
  
  folder.shadow 'C:\Code\MutationTesting\tests\test_project' do |root_path|
    working_folder = File.join root_path, "SampleDotNetProject"
    search_pattern = File.join working_folder, "**", "*.cs"
    
    file_system.glob(search_pattern) do |mutatable_file_paths|
      mutatable_file_paths.each{ |mutatable_file_path|
        relative_mutatable_file_path = mutatable_file_path.sub(working_folder, '')
        report.mutating_file relative_mutatable_file_path
        
        file_line_number = 0
        
        file_system.read_each_line mutatable_file_path do |mutatable_line|
          file_line_number += 1        
          report.mutating_line_number file_line_number
          mutation_controller.mutate working_folder, file_line_number, relative_mutatable_file_path
        end
      }
    end
  end
end