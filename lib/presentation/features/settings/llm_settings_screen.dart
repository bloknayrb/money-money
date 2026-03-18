import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import '../../../core/di/providers.dart';
import '../../../core/error/app_error.dart';
import '../../../data/remote/llm/claude_client.dart';
import '../../../data/remote/llm/gemini_client.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/remote/llm/ollama_client.dart';
import '../../../data/remote/llm/openai_client.dart';
import '../../../data/remote/llm/openrouter_client.dart';

/// Maps provider IDs to user-visible labels.
const _providerLabels = {
  'gemini': 'Gemini (Google)',
  'claude': 'Claude (Anthropic)',
  'openai': 'OpenAI',
  'openrouter': 'OpenRouter',
  'ollama': 'Ollama (local)',
};

/// Default model for each provider.
const _defaultModels = {
  'gemini': 'gemini-2.5-flash',
  'claude': 'claude-haiku-4-5-20251001',
  'openai': 'gpt-5-mini',
  'openrouter': 'openrouter/auto',
  'ollama': 'llama3.2',
};

/// Available cloud models per provider.
const _cloudModels = {
  'gemini': [
    'gemini-2.5-flash',
    'gemini-2.5-flash-lite',
    'gemini-2.5-pro',
    'gemini-3-flash-preview',
    'gemini-3.1-flash-lite-preview',
    'gemini-3.1-pro-preview',
  ],
  'claude': [
    'claude-haiku-4-5-20251001',
    'claude-sonnet-4-6',
    'claude-opus-4-6',
  ],
  'openai': [
    'gpt-5-nano',
    'gpt-5-mini',
    'gpt-4.1',
    'gpt-5.4',
    'gpt-5.4-pro',
    'o4-mini',
    'o3',
    'o3-pro',
  ],
  'openrouter': [
    'openrouter/auto',
    'google/gemini-2.5-flash',
    'google/gemini-2.5-pro',
    'anthropic/claude-sonnet-4',
    'anthropic/claude-haiku-4',
    'openai/gpt-5-mini',
    'openai/gpt-4.1-mini',
    'meta-llama/llama-4-maverick',
    'deepseek/deepseek-r1',
  ],
};

/// Screen for configuring the active LLM provider, API key, and model.
class LlmSettingsScreen extends ConsumerStatefulWidget {
  const LlmSettingsScreen({super.key});

  @override
  ConsumerState<LlmSettingsScreen> createState() => _LlmSettingsScreenState();
}

class _LlmSettingsScreenState extends ConsumerState<LlmSettingsScreen> {
  String _selectedProvider = 'gemini';
  String _selectedModel = 'gemini-2.5-flash';
  final _apiKeyController = TextEditingController();
  bool _isTesting = false;
  bool _isLoading = true;
  List<String> _ollamaModels = [];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final storage = ref.read(secureStorageProvider);
    final provider = await storage.getActiveLlmProvider();
    final model = await storage.getActiveLlmModel();
    final apiKey =
        provider != null ? await storage.getLlmApiKey(provider) : null;

    if (!mounted) return;
    setState(() {
      _selectedProvider = provider ?? 'gemini';
      _selectedModel =
          model ?? _defaultModels[provider ?? 'gemini'] ?? 'gemini-2.5-flash';
      _apiKeyController.text = apiKey ?? '';
      _isLoading = false;

      // If saved model is no longer in the available list, reset to default
      if (_selectedProvider != 'ollama') {
        final available = _cloudModels[_selectedProvider] ?? [];
        if (available.isNotEmpty && !available.contains(_selectedModel)) {
          _selectedModel = _defaultModels[_selectedProvider] ?? available.first;
        }
      }
    });

    if (_selectedProvider == 'ollama') {
      _fetchOllamaModels();
    }
  }

  void _onProviderChanged(String provider) {
    setState(() {
      _selectedProvider = provider;
      _selectedModel = _defaultModels[provider] ?? '';
      _apiKeyController.clear();
      _ollamaModels = [];
    });
    if (provider == 'ollama') _fetchOllamaModels();
  }

  Future<void> _fetchOllamaModels() async {
    final url =
        _apiKeyController.text.trim().isEmpty ? 'http://localhost:11434' : _apiKeyController.text.trim();
    final dio = ref.read(llmDioClientProvider);
    final client = OllamaClient(baseUrl: url, dio: dio);
    final models = await client.listModels();
    if (mounted) {
      setState(() {
        _ollamaModels = models;
        if (models.isNotEmpty && !models.contains(_selectedModel)) {
          _selectedModel = models.first;
        }
      });
    }
  }

  Future<void> _testAndSave() async {
    final apiKey = _apiKeyController.text.trim();
    if (apiKey.isEmpty && _selectedProvider != 'ollama') {
      _showSnackbar('Enter an API key first.');
      return;
    }

    // For cloud providers, show consent dialog on first save
    if (_selectedProvider != 'ollama') {
      final storage = ref.read(secureStorageProvider);
      final consentGiven = await storage.getLlmCloudConsentGiven();
      if (!consentGiven && mounted) {
        final confirmed = await _showConsentDialog();
        if (!confirmed) return;
        await storage.setLlmCloudConsentGiven();
      }
    }

    setState(() => _isTesting = true);

    try {
      final client = _buildClient(apiKey);
      if (client == null) {
        _showSnackbar('Unsupported provider.');
        return;
      }

      await client.complete(
        'Reply with exactly: OK',
        [const ChatMessage(role: 'user', content: 'Say OK')],
      );

      // Success — persist settings
      final storage = ref.read(secureStorageProvider);
      await storage.setActiveLlmProvider(_selectedProvider);
      await storage.setLlmApiKey(_selectedProvider, apiKey);
      await storage.setActiveLlmModel(_selectedModel);
      ref.invalidate(activeLlmClientProvider);
      ref.invalidate(activeLlmProviderNameProvider);

      if (mounted) {
        _showSnackbar('Connected successfully. Settings saved.');
      }
    } on LLMError catch (e) {
      _showSnackbar(e.message);
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 401 || code == 403) {
        _showSnackbar('Invalid API key. Check your ${_providerLabels[_selectedProvider]} credentials.');
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        _showSnackbar('Connection timed out. Check URL and try again.');
      } else {
        _showSnackbar('Connection failed: ${e.message}');
      }
    } on InvalidApiKey catch (_) {
      _showSnackbar('Invalid API key. Check your credentials.');
    } catch (e) {
      _showSnackbar('Test failed: $e');
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  LlmClient? _buildClient(String apiKey) {
    final dio = ref.read(llmDioClientProvider);
    switch (_selectedProvider) {
      case 'gemini':
        return GeminiClient(apiKey: apiKey, model: _selectedModel);
      case 'claude':
        return ClaudeClient(apiKey: apiKey, dio: dio, model: _selectedModel);
      case 'openai':
        return OpenAiClient(apiKey: apiKey, dio: dio, model: _selectedModel);
      case 'openrouter':
        return OpenRouterClient(apiKey: apiKey, dio: dio, model: _selectedModel);
      case 'ollama':
        final url = apiKey.isEmpty ? 'http://localhost:11434' : apiKey;
        return OllamaClient(baseUrl: url, dio: dio, model: _selectedModel);
      default:
        return null;
    }
  }

  Future<bool> _showConsentDialog() async {
    final provider = _providerLabels[_selectedProvider] ?? _selectedProvider;
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Data Privacy Notice'),
            content: Text(
              'Your financial summaries (account balances, spending categories, '
              'budget amounts) will be sent to $provider to generate responses. '
              'No account numbers, credentials, or personally identifiable '
              'information are included.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('I Understand'),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _showSnackbar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final models = _selectedProvider == 'ollama'
        ? _ollamaModels
        : (_cloudModels[_selectedProvider] ?? []);

    return Scaffold(
      appBar: AppBar(title: const Text('AI Provider')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Provider selection
          Text('Provider', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          RadioGroup<String>(
            groupValue: _selectedProvider,
            onChanged: (v) {
              if (v != null) _onProviderChanged(v);
            },
            child: Column(
              children: _providerLabels.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text(entry.value),
                  value: entry.key,
                  contentPadding: EdgeInsets.zero,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // API key / Ollama URL field
          TextField(
            controller: _apiKeyController,
            obscureText: _selectedProvider != 'ollama',
            decoration: InputDecoration(
              labelText: _selectedProvider == 'ollama'
                  ? 'Ollama Server URL'
                  : 'API Key',
              hintText: _selectedProvider == 'ollama'
                  ? 'http://localhost:11434'
                  : 'Enter your ${_providerLabels[_selectedProvider]} API key',
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _testAndSave(),
          ),

          const SizedBox(height: 16),

          // Model selection
          if (models.isNotEmpty) ...[
            DropdownButtonFormField<String>(
              initialValue: models.contains(_selectedModel) ? _selectedModel : models.first,
              decoration: const InputDecoration(
                labelText: 'Model',
                border: OutlineInputBorder(),
              ),
              items: models
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedModel = v!),
            ),
            const SizedBox(height: 16),
          ] else if (_selectedProvider == 'ollama') ...[
            TextField(
              decoration: const InputDecoration(
                labelText: 'Model name',
                hintText: 'llama3.2',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _selectedModel = v),
            ),
            const SizedBox(height: 16),
          ],

          // Test & Save button
          FilledButton.icon(
            onPressed: _isTesting ? null : _testAndSave,
            icon: _isTesting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(_isTesting ? 'Testing…' : 'Test & Save'),
          ),

          const SizedBox(height: 24),

          // Cost guidance
          _CostGuidance(provider: _selectedProvider),
        ],
      ),
    );
  }
}

class _CostGuidance extends StatelessWidget {
  final String provider;

  const _CostGuidance({required this.provider});

  @override
  Widget build(BuildContext context) {
    const guidance = {
      'gemini':
          'Gemini 2.5 Flash has a generous free tier. Estimated cost: ~\$0.16/month for 10 queries/day.',
      'claude':
          'Claude Haiku is the most cost-effective Anthropic model. Estimated cost: ~\$1.20/month for 10 queries/day.',
      'openai':
          'GPT-5-nano is OpenAI\'s budget option. Estimated cost varies by model.',
      'openrouter':
          'OpenRouter aggregates many providers. Use "auto" for automatic model selection, or pick a specific model. Costs vary by model — check openrouter.ai/models for pricing.',
      'ollama':
          'Ollama runs models locally — completely free. Requires Ollama to be running on your device or local network.',
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  'Cost Estimate',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              guidance[provider] ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
