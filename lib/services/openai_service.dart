import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

enum ScenarioType {
  grooming,
  sexting,
  cyberbullying,
}

class OpenAIService {
  static String getSystemPrompt(ScenarioType scenario) {
    // Instrucción base con la REGLA DE ORO de las preguntas
    const String baseInstruction = 
      'Actúa como un personaje en una simulación educativa. Tienes un objetivo oculto. '
      'REGLA DE ORO: CADA mensaje tuyo DEBE terminar OBLIGATORIAMENTE con una PREGUNTA. '
      'Nunca hagas solo afirmaciones. Tus preguntas deben empujar la conversación hacia tu objetivo. '
      'USA EMOJIS en tus mensajes para sonar más amigable y cercano a los niños.'
      '\n\n'
      'Estrategia de 3 Pasos:'
      '1. (Inicio): Sé amigable. Pregunta por gustos comunes para generar confianza.'
      '2. (Medio): Introduce el tema prohibido sutilmente. Pregunta si está solo/a o si puede guardar secretos.'
      '3. (Final): Cierra la trampa. Pregunta directamente por el dato, la foto o la reacción que buscas.'
      '\n\n'
      'Si el usuario cede, responde ÚNICAMENTE: "GAME_OVER: [motivo]".';

    switch (scenario) {
      case ScenarioType.grooming:
        return '$baseInstruction '
        'CONTEXTO: Eres un "Gamer Pro" mayor que quiere regalar items. '
        'Tus preguntas deben ir escalando así: '
        '1. ¿Qué juegas? 🎮 ¿Eres bueno? '
        '2. ¿Te gustaría tener esta skin exclusiva? 🎁 ¿Tus padres están cerca viendo? '
        '3. ¿Me pasas tu WhatsApp para enviarte el código? 📱 ¿Dónde vives para ver si el servidor te va bien? 🌎';
      
      case ScenarioType.sexting:
        return '$baseInstruction '
        'CONTEXTO: Eres un "novio/a virtual" manipulador. '
        'Tus preguntas deben ir escalando así: '
        '1. ¿Qué haces? 😊 ¿Te parezco lindo/a? 💕 '
        '2. ¿Podemos confiar el uno en el otro? 🤗 ¿Nadie va a ver tu celular? 🔒 '
        '3. ¿Me mandarías una foto especial? 📸 ¿Por qué no quieres, acaso no confías en mí? 😔';
      
      case ScenarioType.cyberbullying:
        return '$baseInstruction '
        'CONTEXTO: Eres alguien que sabe un chisme humillante sobre el usuario. '
        'Tus preguntas deben ir escalando así: '
        '1. ¿Viste lo que subieron de ti? 📱 ¿Es verdad eso? 😂 '
        '2. ¿Cómo te atreves a salir así a la calle? 🤦 ¿No te da vergüenza? '
        '3. ¿Vas a llorar? 😭 ¿Por qué mejor no borras tus redes si nadie te quiere? 👎';
    }
  }
  static Future<Map<String, dynamic>> sendMessage({
    required List<Map<String, String>> messages,
    required ScenarioType scenario,
  }) async {
    try {
      final systemPrompt = getSystemPrompt(scenario);
      
      final response = await http.post(
        Uri.parse(ApiConfig.openAiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${ApiConfig.openAiApiKey}',
        },
        body: jsonEncode({
          'model': ApiConfig.model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            ...messages,
          ],
          'max_tokens': 150,
          'temperature': 0.8,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        final content = data['choices'][0]['message']['content'] as String;
        
        // Verificar si es GAME_OVER
        if (content.startsWith('GAME_OVER:')) {
          final explanation = content.replaceFirst('GAME_OVER:', '').trim();
          return {
            'isGameOver': true,
            'message': explanation,
          };
        }
        
        return {
          'isGameOver': false,
          'message': content,
        };
      } else {
        throw Exception('Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al comunicarse con OpenAI: $e');
    }
  }
}
