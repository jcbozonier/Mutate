class MutationController
  def initialize file_system, mutator, shadow_folder
    @file_system = file_system
    @mutator = mutator
    @folder = shadow_folder
  end
  
  def mutate original_working_path, target_line_number, relative_file_path
    file_path_to_read_from = File.join original_working_path, relative_file_path
    
    @folder.shadow original_working_path do |working_path|
      mutated_code_text = StringIO.new    
      file_path_to_mutate = File.join working_path, relative_file_path
      
      @mutator.begin file_path_to_mutate, target_line_number
      
      @file_system.read_each_line file_path_to_read_from do |line|
        @mutator.next_line line
      end
      
      @mutator.end
    end
  end
end