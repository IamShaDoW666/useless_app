import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:http/http.dart' as http;

class ImageLoader {
  static Future<Uint8List?> loadImageFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes; // This is your image as bytes
      } else {
        print('Failed to load image');
        return null;
      }
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }

  static Future<File?> saveImageToFile(
      Uint8List imageBytes, String filePath) async {
    if (imageBytes != null) {
      try {
        await File(filePath).writeAsBytes(imageBytes);
        return File(filePath);
      } catch (e) {
        print('Error saving image to file: $e');
      }
    }
    return null;
  }
}

class DominantColor {
  final Uint8List bytes;
  int k = 2; // Number of clusters (colors)

  DominantColor(this.bytes, this.k);

  List<Color> extractDominantColors() {
    // Extract pixel colors from half the image (optimization)
    List<Color> colors = _getPixelsColorsFromHalfImage();

    // Initialize centroids for K-means++
    List<Color> centroids = initializeCentroids(colors);

    // Cluster pixel colors
    List<List<Color>> clusters = _clusterColors(colors, centroids);

    // Determine the dominant color (largest cluster)
    Color dominantColor = _getDominantColor(clusters);

    return [dominantColor];
  }

  List<Color> _getPixelsColorsFromHalfImage() {
    List<Color> colors = [];
    for (int i = 0; i < bytes.length; i += 4) {
      // Assuming RGBA
      int r = bytes[i];
      int g = bytes[i + 1];
      int b = bytes[i + 2];
      colors.add(Color.fromRGBO(r, g, b, 1));
    }
    return colors;
  }

  List<Color> initializeCentroids(List<Color> colors) {
    // Simple initialization: select k random colors
    return colors.sublist(0, k);
  }

  List<List<Color>> _clusterColors(List<Color> colors, List<Color> centroids) {
    List<List<Color>> clusters = List.generate(k, (index) => []);
    for (var color in colors) {
      int closestIndex = _findClosestCentroid(color, centroids);
      clusters[closestIndex].add(color);
    }
    return clusters;
  }

  Color _getDominantColor(List<List<Color>> clusters) {
    int maxClusterSize = 0;
    late Color dominantColor;
    for (var cluster in clusters) {
      if (cluster.length > maxClusterSize) {
        maxClusterSize = cluster.length;
        dominantColor = _getAverageColor(cluster);
      }
    }
    return dominantColor;
  }

  Color _getAverageColor(List<Color> colors) {
    int r = 0, g = 0, b = 0;
    for (var color in colors) {
      r += color.red;
      g += color.green;
      b += color.blue;
    }
    return Color.fromRGBO(
        r ~/ colors.length, g ~/ colors.length, b ~/ colors.length, 1);
  }

  int _findClosestCentroid(Color color, List<Color> centroids) {
    int closestIndex = 0;
    double minDistance = double.infinity;
    for (int i = 0; i < centroids.length; i++) {
      double distance = _colorDistance(color, centroids[i]);
      if (distance < minDistance) {
        minDistance = distance;
        closestIndex = i;
      }
    }
    return closestIndex;
  }

  double _colorDistance(Color c1, Color c2) {
    int rMean = (c1.red + c2.red) ~/ 2;
    int r = c1.red - c2.red;
    int g = c1.green - c2.green;
    int b = c1.blue - c2.blue;
    return sqrt((2 + rMean / 256) * r * r +
        4 * g * g +
        (2 + (255 - rMean) / 256) * b * b);
  }
}
