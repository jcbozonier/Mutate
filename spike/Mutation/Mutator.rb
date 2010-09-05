class Mutator
  def initialize file_writer, report
    @file_writer = file_writer
    @current_line = 0
    @report = report
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
      @report.mutated_line @current_line, text_to_write
    else
       text_to_write = line
    end
    
    @file_writer.write @file_path_to_mutate, text_to_write    
  end
  
  def end
    @file_writer.close @file_path_to_mutate 
    @current_line = 0
  end
end