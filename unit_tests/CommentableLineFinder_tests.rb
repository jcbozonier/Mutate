#Test Framework
require 'test/unit'

#Subject Under Test
require 'src/CommentableLineFinder'

#Test Objects
require 'unit_tests/TestObjects/TestFileSystem'
require 'unit_tests/TestObjects/TestCommentableLineFinderObserver'

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
  
  def test_when_a_line_of_text_is_provided_to_the_finder
    expected_root_path = 'root_path'
    expected_relative_path = 'relative path'
    expected_line_of_text = 'yada yada!'
    
    commentable_line_finder_observer = TestCommentableLineFinderObserver.new
    commentable_line_finder = CommentableLineFinder.new
    commentable_line_finder.on_next_line_found_notify commentable_line_finder_observer
    
    commentable_line_finder.next_file expected_root_path, expected_relative_path
    commentable_line_finder.next_line expected_line_of_text
    
    assert_equal 1, commentable_line_finder_observer.current_line_number, 'should pass the correct line number to the observer'
    assert_equal expected_root_path, commentable_line_finder_observer.current_root_path, 'should pass the correct root path to the observer'
    assert_equal expected_relative_path, commentable_line_finder_observer.current_relative_path, 'should pass the correct relative path to the observer'
    assert_equal expected_line_of_text, commentable_line_finder_observer.current_line_of_text, 'should pass the correct line of text to the observer'
  end
  
  def test_when_multiple_lines_of_text_are_provided_to_the_finder
    commentable_line_finder_observer = TestCommentableLineFinderObserver.new
    commentable_line_finder = CommentableLineFinder.new
    commentable_line_finder.on_next_line_found_notify commentable_line_finder_observer
    
    commentable_line_finder.next_line 'yada yada!'
    commentable_line_finder.next_line 'gfdgfdgfdg dgfd '
    commentable_line_finder.next_line 'ftryytiu53'
    
    assert_equal 3, commentable_line_finder_observer.current_line_number, 'should be passed to the observer with correct line number'
  end
end