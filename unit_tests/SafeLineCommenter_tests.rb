#Test Framework
require 'test/unit'

#Subject Under Test
require 'src/SafeLineCommenter'

#Test Objects
require 'unit_tests/TestObjects/ShadowFolder'
require 'unit_tests/TestObjects/FileLineReplacer'

class SafeLineCommenter_tests < Test::Unit::TestCase
  def test_when_a_commentable_line_is_provided
    line_number = 42
    line_of_text = 'line OF texxxtttttt!!!!!'
    root_path_to_shadow = 'root path to shadow'
    target_file_path = 'target file path!'
    shadow_root_path = 'shadow root path'
    shadow_folder = ShadowFolder.new
    file_line_replacer = FileLineReplacer.new
    safe_line_commenter = SafeLineCommenter.new
    
    safe_line_commenter.on_shadow_folder_updates_notify shadow_folder
    safe_line_commenter.on_file_line_replacement_updates_notify file_line_replacer
    
    safe_line_commenter.next_line line_number, line_of_text, target_file_path, root_path_to_shadow
    safe_line_commenter.folder_shadowed shadow_root_path
    
    assert_equal root_path_to_shadow, shadow_folder.root_path_to_copy, 'it should request a shadow folder for the correct path'
    assert_equal shadow_root_path, file_line_replacer.provided_root_path, 'it should pass the shadow root path to the file_line_replacer'
    assert_equal line_number, file_line_replacer.provided_line_number, 'it should request to replace the correct line number'
    assert_equal line_of_text, file_line_replacer.provided_line_of_text, 'it should provide the correct replacement text'
    assert_equal target_file_path, file_line_replacer.provided_target_file_path, 'it should provide the correct target file path'
  end
end