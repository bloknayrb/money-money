import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/providers.dart';
import '../../../data/remote/llm/claude_client.dart';
import '../../../data/remote/llm/gemini_client.dart';
import '../../../data/remote/llm/llm_client.dart';
import '../../../data/remote/llm/ollama_client.dart';
import '../../../data/remote/llm/openai_client.dart';

/// Screen for configuring the LLM provider, API key, and model selection.
class LlmSettingsScreen extends ConsumerStatefulWidget {
  const LlmSettingsScreen({super.key});

  @override
  ConsumerState<LlmSettingsScreen> createState() => _LlmSettingsScreenState();
}

class _LlmSettingsScreenState extends ConsumerState<LlmSettingsScreen> {
  String _selectedProvider = 'gemini';
  String _selectedModel = 'gemini-2.0-flash';
  final _keyController = TextEditingController();
  bool _obscureKey = true;
  bool _isTesting = false;
  String? _testResult;
  bool _testSuccess = false;

  static const _providerModels = {
    'gemini': ['gemini-2.0-flash', 'gemini-2.0-flash-lite', 'gemini-1.5-pro'],
    'claude': [
      'claude-haiku-4-5-20251001',
      'claude-sonnet-4-6',
      'claude-opus-4-6',
    ],
    'openai': ['gpt-4o-mini', 'gpt-4o'],
  };

  List<String> _ollamaModels = [];
  bool _fetchingOllamaModels = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentSettings();
  }

  Future<void> _loadCurrentSettings() async {
    final storage = ref.read(secureStorageProvider);
    final provider = await storage.getActiveLlmProvider();
    final model = await storage.getActiveLlmModel();
    final key = provider != null ? await storage.getLlmApiKey(provider) : null;
    if (!mounted) return;
    setState(() {
      if (provider != null) _selectedProvider = provider;
      if (model != null) _selectedModel = model;
      if (key != null) _keyController.text = key;
    });
    if (_selectedProvider == 'ollama') _fetchOllamaModels();
  }

  @override
  void dispose() {
    _keyController.dispose();
    super.dispose();
  }

  void _onProviderChanged(String value) {
    setState(() {
      _selectedProvider = value;
      _testResult = null;
      _keyController.clear();
      switch (value) {
        case 'gemini':
          _selectedModel = 'gemini-2.0-flash';
        case 'claude':
          _selectedModel = 'claude-haiku-4-5-20251001';
        case 'openai':
          _selectedModel = 'gpt-4o-mini';
        case 'ollama':
          _selectedModel = 'llama3.2';
          _fetchOllamaModels();
      }
    });
  }

  Future<void> _fetchOllamaModels() async {
    setState(() => _fetchingOllamaModels = true);
    try {
      final url = _keyController.text.trim().isEmpty
          ? 'http://localhost:11434'
          : _keyController.text.trim();
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
    } catch (_) {
      // Unreachable — user types model name
    } finally {
      if (mounted) setState(() => _fetchingOllamaModels = false);
    }
  }

  Future<void> _testConnection() async {
    setState(() {
      _isTesting = true;
      _testResult = null;
    });
    try {
      final client = _buildClient();
      if (client == null) {
        setState(() {
          _testResult = 'Please enter an API key.';
          _testSuccess = false;
        });
        return;
      }
      await client.complete('You are a test assistant.', const [
        ChatMessage(role: 'user', content: 'Reply with: OK'),
      ]);
      if (!mounted) return;
      setState(() {
        _testResult = 'Connection successful!';
        _testSuccess = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _testResult = _friendlyError(e.toString());
        _testSuccess = false;
      });
    } finally {
      if (mounted) setState(() => _isTesting = false);
    }
  }

  LlmClient? _buildClient() {
    final key = _keyController.text.trim();
    final dio = ref.read(llmDioClientProvider);
    switch (_selectedProvider) {
      case 'gemini':
        if (key.isEmpty) return null;
        return GeminiClient(apiKey: key, model: _selectedModel);
      case 'claude':
        if (key.isEmpty) return null;
        return ClaudeClient(apiKey: key, dio: dio, model: _selectedModel);
      case 'openai':
        if (key.isEmpty) return null;
        return OpenAiClient(apiKey: key, dio: dio, model: _selectedModel);
      case 'ollama':
        final url = key.isEmpty ? 'http://localhost:11434' : key;
        return OllamaClient(baseUrl: url, dio: dio, model: _selectedModel);
      default:
        return null;
    }
  }

  Future<void> _saveSettings() async {
    if (!_testSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Test the connection before saving.')),
      );
      return;
    }
    final storage = ref.read(secureStorageProvider);

    if (_selectedProvider != 'ollama') {
      final consentGiven = await storage.getLlmCloudConsentGiven();
      if (!consentGiven && mounted) {
        final confirmed = await _showConsentDialog();
        if (!confirmed) return;
        await storage.setLlmCloudConsentGiven();
      }
    }

    final key = _keyController.text.trim();
    await storage.setLlmApiKey(_selectedProvider, key);
    await storage.setActiveLlmProvider(_selectedProvider);
    await storage.setActiveLlmModel(_selectedModel);

    ref.invalidate(activeLlmClientProvider);
    ref.invalidate(activeLlmProviderNameProvider);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('AI provider saved.')),
      );
      Navigator.of(context).pop();
    }
  }

  Future<bool> _showConsentDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Data Privacy Notice'),
            content: Text(
              'Your financial summaries (account balances, spending categories, '
              'budget amounts) will be sent to ${_providerDisplayName(_selectedProvider)} '
              'to generate responses. No account numbers or credentials are included.',
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

  String _providerDisplayName(String p) => switch (p) {
        'gemini' => 'Google Gemini',
        'claude' => 'Anthropic Claude',
        'openai' => 'OpenAI',
        'ollama' => 'Ollama (local)',
        _ => p,
      };

  String _friendlyError(String raw) {
    if (raw.contains('401') || raw.contains('403') || raw.contains('invalid')) {
      return 'Invalid API key. Please check and try again.';
    }
    if (raw.contains('timeout') || raw.contains('connection')) {
      return 'Connection timed out. Check your network.';
    }
    if (raw.contains('429')) {
      return 'Rate limited. Try again in a moment.';
    }
    return 'Connection failed. Check your settings.';
  }

  Widget _buildProviderRadio(String value, String label, String subtitle) {
    final selected = _selectedProvider == value;
    final theme = Theme.of(context);
    return InkWell(
      onTap: () => _onProviderChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outline,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOllama = _selectedProvider == 'ollama';
    final availableModels = _providerModels[_selectedProvider] ?? [];
    final modelValue = availableModels.contains(_selectedModel)
        ? _selectedModel
        : availableModels.isNotEmpty
            ? availableModels.first
            : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Provider'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Provider', style: theme.textTheme.titleSmall),
          const SizedBox(height: 4),
          _buildProviderRadio('gemini', 'Google Gemini',
              'Flash 2.5 · Free tier · Recommended'),
          _buildProviderRadio('claude', 'Anthropic Claude',
              'Haiku 4.5 · Best financial reasoning'),
          _buildProviderRadio('openai', 'OpenAI', 'GPT-4o-mini · Widely supported'),
          _buildProviderRadio('ollama', 'Ollama (local)', 'Free · Requires local server'),

          const SizedBox(height: 16),

          TextField(
            controller: _keyController,
            obscureText: !isOllama && _obscureKey,
            onChanged: (_) => setState(() => _testResult = null),
            decoration: InputDecoration(
              labelText: isOllama ? 'Ollama URL' : 'API Key',
              hintText: isOllama
                  ? 'http://localhost:11434'
                  : 'Paste your API key here',
              border: const OutlineInputBorder(),
              suffixIcon: isOllama
                  ? IconButton(
                      icon: const Icon(Icons.refresh),
                      tooltip: 'Fetch available models',
                      onPressed: _fetchOllamaModels,
                    )
                  : IconButton(
                      icon: Icon(_obscureKey
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () =>
                          setState(() => _obscureKey = !_obscureKey),
                    ),
            ),
          ),

          const SizedBox(height: 16),

          Text('Model', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),

          if (isOllama)
            _fetchingOllamaModels
                ? const LinearProgressIndicator()
                : _ollamaModels.isEmpty
                    ? TextField(
                        decoration: const InputDecoration(
                          labelText: 'Model name',
                          hintText: 'e.g. llama3.2',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) => setState(() => _selectedModel = v),
                      )
                    : DropdownButtonFormField<String>(
                        initialValue: _ollamaModels.contains(_selectedModel)
                            ? _selectedModel
                            : _ollamaModels.first,
                        decoration:
                            const InputDecoration(border: OutlineInputBorder()),
                        items: _ollamaModels
                            .map((m) => DropdownMenuItem(
                                value: m, child: Text(m)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedModel = v ?? _selectedModel),
                      )
          else
            DropdownButtonFormField<String>(
              initialValue: modelValue,
              decoration:
                  const InputDecoration(border: OutlineInputBorder()),
              items: availableModels
                  .map((m) =>
                      DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => _selectedModel = v ?? _selectedModel),
            ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: _isTesting ? null : _testConnection,
            icon: _isTesting
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.wifi_find),
            label: Text(_isTesting ? 'Testing…' : 'Test Connection'),
          ),

          if (_testResult != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  _testSuccess ? Icons.check_circle : Icons.error,
                  color: _testSuccess
                      ? theme.colorScheme.primary
                      : theme.colorScheme.error,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _testResult!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: _testSuccess
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                    ),
                  ),
                ),
              ],
            ),
          ],

          if (_testSuccess) ...[
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _saveSettings,
              child: const Text('Save Provider'),
            ),
          ],
        ],
      ),
    );
  }
}
