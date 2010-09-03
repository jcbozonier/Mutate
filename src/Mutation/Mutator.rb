class Mutator
  def initialize file_writer
    @file_writer = file_writer
    @current_line = 0
  end

  def begin file_path_to_mutate, target_line_number
    @file_path_to_mutate = file_path_to_mutate
    @target_line_number = target_line_number
    @file_writer.open @file_path_to_mutate
  end
  
  def next_line line
    @current_line += 1
    if @current_line == @target_line_number
      text_to_write = "// " + line
    else
       text_to_write = line
    end
    puts text_to_write
    @file_writer.write @file_path_to_mutate, text_to_write    
  end
  
  def end
    @file_writer.close @file_path_to_mutate 
  end
end