/*extension StringExtension on String{
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}*/

class StringFunctions{
  static String capitalize(String string) => "${string[0].toUpperCase()}${string.substring(1)}";
}