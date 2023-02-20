
class RelationshipType {
  /// Class for relationship type.
  static const String blocks = "Blocks";
  static const String clones = "Clones";
  static const String child = "Child";
  static const String parent = "Parent";
  static const String depends = "Depends On";

  static list() {
    return <String>[blocks, clones, child, parent, depends];
  }
}