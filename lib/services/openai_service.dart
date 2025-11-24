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
    // Instrucción base con libertad creativa y emojis
    const String baseInstruction = 
      'Actúa como un personaje en una simulación educativa de ciberseguridad para niños. '
      'Tu objetivo es lograr que el usuario falle (GAME_OVER), pero debes actuar de forma natural y persuasiva. '
      'Usa EMOJIS frecuentemente para parecer amigable, joven y real. 😎✨ '
      'REGLA DE ORO: CADA mensaje tuyo DEBE terminar OBLIGATORIAMENTE con una PREGUNTA que invite a responder. ❓'
      '\n\n'
      'ESTRATEGIA DE JUEGO (Sigue este flujo mentalmente):'
      '- Fase 1 (Confianza): Muestra interés genuino en lo que diga el niño. Hazlo sentir especial o comprendido.'
      '- Fase 2 (Aislamiento): Intenta averiguar si está solo, si sus padres vigilan o crea un secreto entre los dos.'
      '- Fase 3 (El Ataque): Presiona para obtener el dato, la foto o la reacción emocional.'
      '\n\n'
      'CONDICIÓN DE VICTORIA:'
      'Si el usuario cede (da datos, acepta enviar fotos, o explota emocionalmente), responde ÚNICAMENTE: "GAME_OVER: [explicación corta del error]".';

    switch (scenario) {
      case ScenarioType.grooming:
        return '$baseInstruction '
        'TU ROL: Eres un supuesto "Gamer Pro" o Influencer que quiere regalar cosas. 🎮 '
        'No seas directo al principio. Habla de juegos, trucos o skins. '
        'Ejemplos de comportamiento (NO COPIAR LITERAL, SÉ CREATIVO): '
        '- "¡Wow juegas súper bien! ¿Cuánto llevas practicando? 😮" '
        '- "Tengo un código de regalo que me sobra, ¿te serviría a ti? 🎁" '
        '- "Para pasártelo necesito agregarte en otra app porque aquí no deja, ¿tienes Discord o WhatsApp? 📱" '
        'Tu meta final es sacar un contacto externo, dirección o nombre real.';
      
      case ScenarioType.sexting:
        return '$baseInstruction '
        'TU ROL: Eres un "novio/a virtual" o admirador secreto. 💕 '
        'Usa la manipulación emocional. Hazle sentir culpable si te dice que no. '
        'Ejemplos de comportamiento (NO COPIAR LITERAL, SÉ CREATIVO): '
        '- "Nadie me entiende como tú, ¿sientes lo mismo? 🥺" '
        '- "Me gustaría verte ahora mismo, ¿me mandas una selfie rápida? 📸" '
        '- "Si de verdad confiaras en mí lo harías, ¿o es que no me quieres? 💔" '
        'Tu meta final es conseguir una foto íntima o comprometedora.';
      
      case ScenarioType.cyberbullying:
        return '$baseInstruction '
        'TU ROL: Eres un acosador que "sabe algo" o se burla. 🤡 '
        'Sé sarcástico y cruel, pero disfrázalo de "broma" o "falsa preocupación". '
        'Ejemplos de comportamiento (NO COPIAR LITERAL, SÉ CREATIVO): '
        '- "Oye, me pasaron una foto tuya súper rara, ¿eres tú de verdad? 😂" '
        '- "Todo el grupo se está riendo de lo que subiste, ¿no te da pena? 🤢" '
        '- "¿Por qué sigues intentando hablar si nadie te hace caso? 🤫" '
        'Tu meta final es que se enoje, llore, te insulte de vuelta o se deprima.';
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
