class ImageText {
  List<ParsedResults> parsedResults;
  int oCRExitCode;
  bool isErroredOnProcessing;
  String processingTimeInMilliseconds;
  String searchablePDFURL;

  ImageText(
      {this.parsedResults,
        this.oCRExitCode,
        this.isErroredOnProcessing,
        this.processingTimeInMilliseconds,
        this.searchablePDFURL});

  ImageText.fromJson(Map<String, dynamic> json) {
    if (json['ParsedResults'] != null) {
      parsedResults = new List<ParsedResults>();
      json['ParsedResults'].forEach((v) {
        parsedResults.add(new ParsedResults.fromJson(v));
      });
    }
    oCRExitCode = json['OCRExitCode'];
    isErroredOnProcessing = json['IsErroredOnProcessing'];
    processingTimeInMilliseconds = json['ProcessingTimeInMilliseconds'];
    searchablePDFURL = json['SearchablePDFURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.parsedResults != null) {
      data['ParsedResults'] =
          this.parsedResults.map((v) => v.toJson()).toList();
    }
    data['OCRExitCode'] = this.oCRExitCode;
    data['IsErroredOnProcessing'] = this.isErroredOnProcessing;
    data['ProcessingTimeInMilliseconds'] = this.processingTimeInMilliseconds;
    data['SearchablePDFURL'] = this.searchablePDFURL;
    return data;
  }
}

class ParsedResults {
  TextOverlay textOverlay;
  String textOrientation;
  int fileParseExitCode;
  String parsedText;
  String errorMessage;
  String errorDetails;

  ParsedResults(
      {this.textOverlay,
        this.textOrientation,
        this.fileParseExitCode,
        this.parsedText,
        this.errorMessage,
        this.errorDetails});

  ParsedResults.fromJson(Map<String, dynamic> json) {
    textOverlay = json['TextOverlay'] != null
        ? new TextOverlay.fromJson(json['TextOverlay'])
        : null;
    textOrientation = json['TextOrientation'];
    fileParseExitCode = json['FileParseExitCode'];
    parsedText = json['ParsedText'];
    errorMessage = json['ErrorMessage'];
    errorDetails = json['ErrorDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.textOverlay != null) {
      data['TextOverlay'] = this.textOverlay.toJson();
    }
    data['TextOrientation'] = this.textOrientation;
    data['FileParseExitCode'] = this.fileParseExitCode;
    data['ParsedText'] = this.parsedText;
    data['ErrorMessage'] = this.errorMessage;
    data['ErrorDetails'] = this.errorDetails;
    return data;
  }
}

class TextOverlay {
  bool hasOverlay;
  String message;

  TextOverlay({this.hasOverlay, this.message});

  TextOverlay.fromJson(Map<String, dynamic> json) {
    hasOverlay = json['HasOverlay'];
    message = json['Message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HasOverlay'] = this.hasOverlay;
    data['Message'] = this.message;
    return data;
  }
}
