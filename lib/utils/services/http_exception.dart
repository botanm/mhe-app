class HttpException implements Exception {
  final String message;

  HttpException(this.message);
  // watch this video to throw 'text' without us the current utils HttpException
  // https://www.youtube.com/watch?v=IXBLP1bMeBE

  @override
  String toString() {
    return message;
    // return super.toString(); // Instance of HttpException
  }
}
