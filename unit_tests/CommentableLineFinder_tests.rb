#Test Framework
require 'test/unit'

class TestFileSystem
  def file_path_lines_were_requested_from
    @file_path_lines_were_requested_from
  end
  
  def start_reading_all_lines file_path
    @file_path_lines_were_requested_from = file_path
  end
end

class CommentableLineFinder
  def next_file root_path, relative_path
    @file_system.start_reading_all_lines File.join root_path, relative_path
  end
  
  def for_file_system_access_use file_system
    @file_system = file_system
  end
end

class CommentableLineFinder_Tests < Test::Unit::TestCase
  def test_when_a_mutatable_file_is_found
    root_path = 'root path'
    relative_file_path = 'relative file path'
    expected_file_path = File.join root_path, relative_file_path
  
    file_system = TestFileSystem.new
    commentable_line_finder = CommentableLineFinder.new
    commentable_line_finder.for_file_system_access_use file_system

    commentable_line_finder.next_file root_path, relative_file_path
    
    assert_equal expected_file_path, file_system.file_path_lines_were_requested_from, 'should ask file system for lines of text'
  end
end