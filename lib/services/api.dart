import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<http.Response?> generateImage(String category, String gender, String personImagePath, String clothImagePath) async {
  final url = Uri.parse('http://your_flask_server_ip/api/generate_tryon');
  final personImageBytes = await _readImageBytes(personImagePath);
  final clothImageBytes = await _readImageBytes(clothImagePath);

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'category': category,
      'gender': gender,
      'person_image': base64Encode(personImageBytes),
      'cloth_image': base64Encode(clothImageBytes),
    }),
  );

  if (response.statusCode == 200) {
    print('Image generated successfully.');
    // Decode the response body if it's an image and display it
    // For example, you can use Image.memory to display it in Flutter
    // Image.memory(base64Decode(response.bodyBytes));
    return response;
  } else {
    print('Failed to generate image.');
    return null;
  }
}



Future<List<int>> _readImageBytes(String imagePath) async {
  final file = File(imagePath);
  return await file.readAsBytes();
}
