#Test Framework
require 'test/unit'

#Subject Under Test
require 'src/MutatableFileFinder'

#Test Objects
require 'unit_tests/TestObjects/FileSystem'
require 'unit_tests/TestObjects/CommentableLineFinder'

class MutatableFileFinder_Tests < Test::Unit::TestCase
  def test_when_searching_a_path
    @file_path = ''
    
    file_system = TestFileSystem.new
    file_finder = MutatableFileFinder.new
    file_finder.on_file_updates_notify file_system
    
    file_finder.search @file_path
    
    assert_equal file_system.search_path, '/**/*.cs', 'The wrong search string was requested of the file system.'
  end
  
  def test_when_mutatable_paths_are_found
    test_commentable_line_finder = TestCommentableLineFinder.new
    file_finder = MutatableFileFinder.new
    file_finder.when_commentable_files_are_found_notify test_commentable_line_finder
    expected_found_path = 'path_found'
    
    file_finder.next_path_found expected_found_path
    
    assert_equal expected_found_path, test_commentable_line_finder.found_path, 'The path found is not the same path that was provided.'
  end
  
  def test_when_search_is_complete
    test_commentable_line_finder = TestCommentableLineFinder.new
    file_finder = MutatableFileFinder.new
    file_finder.when_commentable_files_are_found_notify test_commentable_line_finder
    
    file_finder.search_complete
    
    assert test_commentable_line_finder.completed_searching, 'The commentable line finder should be done searching now.'
  end
end