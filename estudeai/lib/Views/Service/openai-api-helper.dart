import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

Future<String> sendChatCompletionRequest(
    String tema, String quantidadeQuestoes) async {
  const url = 'https://api.openai.com/v1/chat/completions';
  final secretKey = await loadSecretKey();

  final headers = {
    'Authorization': 'Bearer $secretKey',
    'Content-Type': 'application/json',
    'User-Agent': 'insomnia/10.2.0',
  };

  final body = {
    "model": "gpt-3.5-turbo",
    "messages": [
      {
        "role": "system",
        "content": "Você é um assistente útil que cria quizzes no seguinte formato JSON, em português: "
            "{\"pergunta-1\": {\"pergunta\": \"Aqui coloque a pergunta 1\", \"alternativa-A\": \"alternativa A\", \"alternativa-B\": \"alternativa B\", \"alternativa-C\": \"alternativa C\", \"alternativa-D\": \"alternativa D\", \"alternativa-correta\": \"Aqui coloque uma letra A, B, C ou D\"}, "
            "\"pergunta-2\": {\"pergunta\": \"Aqui coloque a pergunta 2\", \"alternativa-A\": \"alternativa A\", \"alternativa-B\": \"alternativa B\", \"alternativa-C\": \"alternativa C\", \"alternativa-D\": \"alternativa D\", \"alternativa-correta\": \"Aqui coloque uma letra A, B, C ou D\"}}. "
            "O quiz deve ser baseado no tema e no número de perguntas fornecido pelo usuário. "
            "Cada pergunta deve sempre ter exatamente 4 alternativas identificadas como A, B, C e D, com uma resposta correta especificada como uma dessas letras (A, B, C ou D). "
            "Certifique-se de que todas as perguntas, alternativas e a resposta correta estejam sempre em português."
      },
      {
        "role": "user",
        "content":
            "Crie um quiz sobre '$tema' com $quantidadeQuestoes perguntas."
      }
    ],
    "max_tokens": 450,
    "temperature": 0.7
  };

  print(body);

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode(body),
    );

    final responseBody = utf8.decode(response.bodyBytes);

    print("RESPOSTA REQUISICAO: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(responseBody);
      final content = responseData['choices'][0]['message']['content'];
      return content;
    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Response body: ${responseBody}');
      return '';
    }
  } catch (e) {
    print('Error: $e');
    return '';
  }
}

Future<String> loadSecretKey() async {
  try {
    // Carregar o conteúdo do arquivo dentro da pasta assets
    final secretKey = await rootBundle.loadString('assets/openai-token.txt');
    return secretKey.trim(); // Remove espaços extras ou quebras de linha
  } catch (e) {
    print('Erro ao carregar a secret key: $e');
    rethrow;
  }
}

Future<void> testConnection() async {
  try {
    final response = await http.get(Uri.parse('https://api.openai.com/'));
    if (response.statusCode == 421) {
      print('Conexão bem-sucedida com a API OpenAI');
    } else {
      print('Falha na conexão com a API OpenAI: ${response.statusCode}');
    }
  } catch (e) {
    print('Erro ao testar conexão: $e');
  }
}
