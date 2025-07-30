// Main test suite that imports all unit tests
// Run with: flutter test

import 'game_handler_test.dart' as game_handler_tests;
import 'questions_manager_test.dart' as questions_manager_tests;  
import 'player_utils_test.dart' as player_utils_tests;

void main() {
  // Run all unit tests
  game_handler_tests.main();
  questions_manager_tests.main();
  player_utils_tests.main();
}
