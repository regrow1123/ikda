import 'dart:convert';
import 'package:dio/dio.dart';

class SdService {
  // SD Forge API URL (dart-define으로 주입, 기본값 로컬)
  static const _baseUrl = String.fromEnvironment(
    'SD_API_URL',
    defaultValue: 'http://192.168.0.30:7860',
  );

  static final _dio = Dio(BaseOptions(
    baseUrl: _baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 120), // 이미지 생성은 오래 걸림
    responseType: ResponseType.plain,
  ));

  /// txt2img로 일러스트 생성, base64 이미지 반환
  static Future<String> generateIllustration({
    required String prompt,
    String? negativePrompt,
    int width = 512,
    int height = 512,
    int steps = 20,
    double cfgScale = 7.0,
  }) async {
    final res = await _dio.post(
      '/sdapi/v1/txt2img',
      data: jsonEncode({
        'prompt': prompt,
        'negative_prompt': negativePrompt ??
            'ugly, blurry, low quality, deformed, text, watermark, signature, worst quality, bad anatomy, bad hands, extra fingers, missing fingers, extra limbs, disfigured, out of frame, duplicate, morbid, mutilated, poorly drawn face, mutation, extra digits, cropped, jpeg artifacts, lowres, normal quality',
        'steps': steps,
        'width': width,
        'height': height,
        'cfg_scale': cfgScale,
        'sampler_name': 'DPM++ 2M Karras',
        'seed': -1,
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    final data = res.data is String ? jsonDecode(res.data as String) : res.data;
    final images = data['images'] as List<dynamic>;
    if (images.isEmpty) throw Exception('이미지 생성 실패');
    return images[0] as String; // base64 encoded PNG
  }

  /// SD 서버 상태 확인
  static Future<bool> isAvailable() async {
    try {
      final res = await _dio.get('/sdapi/v1/sd-models');
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
