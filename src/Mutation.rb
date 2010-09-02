require 'src/ShadowFolder'
require "StringIO"

def mutate original_working_path, target_line_number, relative_file_path
  folder = ShadowFolder.new original_working_path
  folder.shadow do |working_path|
    file_path_to_mutate = File.join working_path, relative_file_path
    target_file = File.open file_path_to_mutate
    
    mutated_code_text = StringIO.new
    current_line_number = 0
    target_file.each_line{ |line|
      current_line_number += 1
      
      if current_line_number == target_line_number
        mutated_code_text.puts "// " + line
      else
        mutated_code_text.puts line
      end
    }
    target_file.close
    
    target_file = File.open(file_path_to_mutate, 'w')
    
    puts mutated_code_text.string
    
    target_file.write(mutated_code_text.string)
    target_file.close
  end
end

if __FILE__ == $0
  folder = ShadowFolder.new 'C:\Code\MutationTesting\tests\test_project'
  
  folder.shadow do |root_path|
    working_folder = File.join root_path, "SampleDotNetProject"
    search_pattern = File.join working_folder, "**", "*.cs"
    mutatable_file_paths = Dir.glob(search_pattern)
    
    mutatable_file_paths.each{ |mutatable_file_path|
      opened_mutatable_file = File.open(mutatable_file_path)
      relative_mutatable_file_path = mutatable_file_path.sub(working_folder, '')
      
      file_line_number = 0
      opened_mutatable_file.each_line{ |mutatable_line|
        file_line_number += 1        
        mutate working_folder, file_line_number, relative_mutatable_file_path
      }
      
      opened_mutatable_file.close
    }
  end
end