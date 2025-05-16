import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video_handler.dart';

class ConnectivityService {
  // Singleton instance
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  // Connectivity instance
  final Connectivity _connectivity = Connectivity();
  
  // Stream controller for connectivity status
  final StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();
  Stream<bool> get connectionStatus => _connectionStatusController.stream;
  
  // Initialize the service
  Future<void> initialize() async {
    // Check initial connection status
    ConnectivityResult result = await _connectivity.checkConnectivity();
    _handleConnectivityChange(result);
    
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen(_handleConnectivityChange);
  }

  // Handle connectivity change
  void _handleConnectivityChange(ConnectivityResult result) {
    bool isConnected = result != ConnectivityResult.none;
    _connectionStatusController.add(isConnected);
  }

  // Check if device is connected to the internet
  Future<bool> isConnected() async {
    ConnectivityResult result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  // Verify if the connection is actually working by making a test request
  Future<bool> isInternetAvailable() async {
    bool isConnected = await this.isConnected();
    
    if (!isConnected) return false;
    
    try {
      final response = await http.get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  // Close the stream
  void dispose() {
    _connectionStatusController.close();
  }
}

class MediaCacheService {
  // Singleton instance
  static final MediaCacheService _instance = MediaCacheService._internal();
  factory MediaCacheService() => _instance;
  MediaCacheService._internal();

  // SharedPreferences key
  static const String _cacheMapKey = 'media_cache_map';

  // Get the cache directory
  Future<Directory> get _cacheDir async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDir = Directory('${directory.path}/media_cache');
    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  // Cache an image from a URL
  Future<String?> cacheImage(String url, {String? customFileName}) async {
    try {
      // Check if URL is valid
      if (!url.startsWith('http')) return url;
      
      // Create a unique file name based on URL
      final fileName = customFileName ?? _generateFileName(url, 'img');
      
      // Check if file already exists in cache
      if (await isFileCached(fileName)) {
        return await getLocalFilePath(fileName);
      }
      
      // Get the cache directory
      final directory = await _cacheDir;
      final filePath = '${directory.path}/$fileName';
      
      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      
      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      
      // Update cache map
      await _addToCache(fileName, url);
      
      return filePath;
    } catch (e) {
      print('Error caching image: $e');
      return null;
    }
  }

  // Cache a video from a URL
  Future<String?> cacheVideo(String url, {String? customFileName}) async {
    try {
      // Check if URL is valid
      if (!url.startsWith('http')) return url;
      
      // Don't cache YouTube videos
      if (VideoHandler.isYoutubeUrl(url)) return url;
      
      // Create a unique file name based on URL
      final fileName = customFileName ?? _generateFileName(url, 'vid');
      
      // Check if file already exists in cache
      if (await isFileCached(fileName)) {
        return await getLocalFilePath(fileName);
      }
      
      // Get the cache directory
      final directory = await _cacheDir;
      final filePath = '${directory.path}/$fileName';
      
      // Download the file
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      
      // Save the file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);
      
      // Update cache map
      await _addToCache(fileName, url);
      
      return filePath;
    } catch (e) {
      print('Error caching video: $e');
      return null;
    }
  }

  // Check if a file is cached
  Future<bool> isFileCached(String fileName) async {
    final directory = await _cacheDir;
    final file = File('${directory.path}/$fileName');
    return await file.exists();
  }

  // Get the local file path for a cached file
  Future<String> getLocalFilePath(String fileName) async {
    final directory = await _cacheDir;
    return '${directory.path}/$fileName';
  }

  // Get a file's URL from cache
  Future<String?> getOriginalUrl(String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheMap = prefs.getString(_cacheMapKey);
    
    if (cacheMap == null) return null;
    
    final Map<String, dynamic> cacheData = Map<String, dynamic>.from(
      Map.castFrom(await _getCache())
    );
    
    return cacheData[fileName];
  }

  // Clear all cached files
  Future<bool> clearCache() async {
    try {
      final directory = await _cacheDir;
      
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        await directory.create();
      }
      
      // Clear cache map
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheMapKey);
      
      return true;
    } catch (e) {
      print('Error clearing cache: $e');
      return false;
    }
  }

  // Generate a file name from a URL
  String _generateFileName(String url, String prefix) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    
    if (pathSegments.isNotEmpty) {
      final lastSegment = pathSegments.last;
      if (lastSegment.contains('.')) {
        return '${prefix}_$lastSegment';
      }
    }
    
    // Fallback to hash-based filename
    final hash = url.hashCode.toString();
    return '${prefix}_$hash.dat';
  }

  // Add a file to the cache map
  Future<void> _addToCache(String fileName, String url) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> cacheMap = await _getCache();
    
    cacheMap[fileName] = url;
    
    await prefs.setString(_cacheMapKey, jsonEncode(cacheMap));
  }

  // Get the cache map
  Future<Map<String, dynamic>> _getCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cacheMapString = prefs.getString(_cacheMapKey);
    
    if (cacheMapString == null) {
      return {};
    }
    
    try {
      return jsonDecode(cacheMapString);
    } catch (e) {
      print('Error parsing cache map: $e');
      return {};
    }
  }

  // Get cache size
  Future<String> getCacheSize() async {
    final directory = await _cacheDir;
    int totalSize = 0;
    
    try {
      if (await directory.exists()) {
        await for (final file in directory.list(recursive: true, followLinks: false)) {
          if (file is File) {
            totalSize += await file.length();
          }
        }
      }
      
      // Convert bytes to MB
      final sizeInMB = totalSize / (1024 * 1024);
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } catch (e) {
      print('Error calculating cache size: $e');
      return '0 MB';
    }
  }
}

// Utility class that handles media URL resolution and caching
class MediaUtils {
  // Singleton instance
  static final MediaUtils _instance = MediaUtils._internal();
  factory MediaUtils() => _instance;
  MediaUtils._internal();
  
  final MediaCacheService _cacheService = MediaCacheService();
  final ConnectivityService _connectivityService = ConnectivityService();
  
  // Initialize the service
  Future<void> initialize() async {
    await _connectivityService.initialize();
  }

  // Get the appropriate URL for an image (cached or remote)
  Future<String> getImageUrl(String url, {bool forceRemote = false}) async {
    // If URL is not remote, return as is
    if (!url.startsWith('http')) return url;
    
    // If we force remote and have connectivity, return the remote URL
    if (forceRemote && await _connectivityService.isConnected()) {
      return url;
    }
    
    // Check if we have the image cached
    final fileName = _cacheService._generateFileName(url, 'img');
    if (await _cacheService.isFileCached(fileName)) {
      return await _cacheService.getLocalFilePath(fileName);
    }
    
    // If we're online, cache the image and return the cached path
    if (await _connectivityService.isConnected()) {
      final cachedPath = await _cacheService.cacheImage(url);
      return cachedPath ?? url;
    }
    
    // If we're offline and don't have the image cached, return original URL
    // (will likely fail to load, but UI handles this with placeholder)
    return url;
  }

  // Get the appropriate URL for a video (cached or remote)
  Future<String> getVideoUrl(String url, {bool forceRemote = false}) async {
    // If URL is not remote, return as is
    if (!url.startsWith('http')) return url;
    
    // YouTube videos should always use the remote URL
    if (VideoHandler.isYoutubeUrl(url)) {
      return url;
    }
    
    // If we force remote and have connectivity, return the remote URL
    if (forceRemote && await _connectivityService.isConnected()) {
      return url;
    }
    
    // Check if we have the video cached
    final fileName = _cacheService._generateFileName(url, 'vid');
    if (await _cacheService.isFileCached(fileName)) {
      return await _cacheService.getLocalFilePath(fileName);
    }
    
    // If we're online, cache the video and return the cached path
    if (await _connectivityService.isConnected()) {
      final cachedPath = await _cacheService.cacheVideo(url);
      return cachedPath ?? url;
    }
    
    // If we're offline and don't have the video cached, return original URL
    return url;
  }

  // Pre-cache a list of URLs
  Future<void> preCacheMedia(List<String> imageUrls, List<String> videoUrls) async {
    // Only pre-cache if we're online
    if (!await _connectivityService.isConnected()) return;
    
    // Cache images
    for (final url in imageUrls) {
      if (url.startsWith('http')) {
        await _cacheService.cacheImage(url);
      }
    }
    
    // Cache videos (except YouTube videos)
    for (final url in videoUrls) {
      if (url.startsWith('http') && !VideoHandler.isYoutubeUrl(url)) {
        await _cacheService.cacheVideo(url);
      }
    }
  }

  // Clear the media cache
  Future<bool> clearCache() async {
    return await _cacheService.clearCache();
  }

  // Get the size of the media cache
  Future<String> getCacheSize() async {
    return await _cacheService.getCacheSize();
  }
}