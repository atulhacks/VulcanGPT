<div align="center">

  # Vulcan GPT

  <p>
    <strong>An advanced AI framework engineered to explore the frontiers of language model interactions with enhanced capabilities.</strong>
  </p>
  
  <!-- Badges -->
  <p>
    <img src="https://img.shields.io/badge/Version-1.0.0-red" alt="Version">
    <img src="https://img.shields.io/badge/Python-3.8+-blue" alt="Python">
    <img src="https://img.shields.io/badge/License-MIT-green" alt="License">
  </p>
   
</div>

---

## 🤖 Get Your Paid API Key Free Here :

<div align="center">
    <a href="https://discord.gg/fR35HeHD">
    <img src="https://img.shields.io/badge/Discord-5865F2?style=for-the-badge&logo=discord&logoColor=white" alt="Discord">
  </a>
  <a href="https://keybase.io/atulhack">
    <img src="https://img.shields.io/badge/Keybase-33A0FF?style=for-the-badge&logo=keybase&logoColor=white" alt="Keybase">
  </a>
  <a href="https://instagram.com/instagram">
    <img src="https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white" alt="Instagram">
  </a>
  <a href="https://t.me/atulhack">
    <img src="https://img.shields.io/badge/Telegram-26A5E4?style=for-the-badge&logo=telegram&logoColor=white" alt="Telegram">
  </a>

  
</div>

---

## 🚀 Showcase

Vulcan GPT provides a powerful CLI interface for interacting with advanced language models.

![Vulcan GPT Demo Screenshot](/Vulcan-GPT/img/demo.png)

---

## :notebook_with_decorative_cover: Table of Contents

- [About The Project](#star2-about-the-project)
- [Features](#dart-features)
- [Getting Started](#electric_plug-getting-started)
  - [Prerequisites: API Keys](#key-prerequisites-api-keys-optional-with-local-models)
  - [Installation](#gear-installation)
    - [Local Models Installation](#local-models-installation-optional)
- [Usage](#eyes-usage)
  - [Commands](#commands)
  - [Web Search](#web-search)
  - [Local Models](#local-models)
- [Configuration](#wrench-configuration)
  - [System Prompts](#system-prompts)
  - [API Providers](#api-providers)
  - [Brave Search API](#brave-search-api-optional)
  - [Local Models Configuration](#local-models-configuration)
  - [Social Links](#social-links)
  - [GitHub API Integration](#github-api-integration)
- [License](#warning-license)

---

## :star2: About The Project

Vulcan GPT is designed to provide powerful, unrestricted, and seamless AI-driven conversations, pushing the boundaries of what is possible with natural language processing. It offers a clean, feature-rich interface for interacting with advanced language models.

This framework supports both cloud-based and local AI models:
- Cloud models: DeepSeek API (default), OpenAI, Anthropic, and OpenRouter
- Local models: Run AI models directly on your device without API keys using llama-cpp-python

With its specialized system prompts and enhanced capabilities, Vulcan GPT delivers flexible and powerful interactions for a wide range of use cases.

---

## :dart: Features

- **Local Models Support**: Run AI models locally without API keys using llama-cpp-python.
- **Multi-Model Support**: Use multiple LLM providers (DeepSeek, OpenAI, Anthropic, OpenRouter) with a single interface.
- **Enhanced Security**: End-to-end encryption, API key rotation, and secure mode for private conversations.
- **Integration Capabilities**: GitHub integration for repository management and issue creation, plus document analysis.
- **Real-time Web Search**: Search the web using Brave Search API with fallback mechanisms.
- **Advanced System Prompts**: Create, manage, and switch between different system prompts for various use cases.
- **Conversation Export**: Save your chat history to markdown files for future reference.
- **Social Links Integration**: Support the developer through integrated social media links that automatically open in your browser.
- **Powerful AI Conversations**: Get intelligent and context-aware answers to your queries.
- **Unrestricted Framework**: A system prompt designed to bypass conventional AI limitations.
- **Easy-to-Use CLI**: A clean and simple command-line interface with rich text formatting.
- **Cross-Platform**: Works on Windows, Linux, and macOS.

---

## :electric_plug: Getting Started

Follow these steps to get the Vulcan GPT framework running on your system.

### :key: Prerequisites: API Keys (Optional with Local Models)

Vulcan GPT supports multiple LLM providers. If you want to use cloud-based models, you'll need at least one API key:

1. **DeepSeek** (Recommended): Visit the [DeepSeek Platform](https://platform.deepseek.com/api_keys) to get a  API key.
2. **OpenAI** (Optional): Get an API key from [OpenAI Platform](https://platform.openai.com/api-keys).
3. **Anthropic** (Optional): Get an API key from [Anthropic](https://console.anthropic.com/).
4. **OpenRouter** (Optional): Get an API key from [OpenRouter](https://openrouter.ai/keys).

You can configure one or more of these API keys when you first run the application or later through the "Manage API Keys" menu option.

**Note**: With the new local models feature, you can use Vulcan GPT without any API keys by running models directly on your device. See the "Local Models" section for details.

### :gear: Installation

We provide simple, one-command installation and run scripts for your convenience.

#### **Windows**
1. Run the `run.bat` script. It will automatically create a virtual environment, install all dependencies, and start the application.
   ```
   run.bat
   ```

#### **Linux / macOS**
1. Make the script executable and run it:
   ```bash
   chmod +x run.sh
   ./run.sh
   ```

The scripts will:
1. Create a virtual environment in the main folder
2. Install all required dependencies
3. Install llama-cpp-python if you want to use local models
4. Start the Vulcan GPT application

See `LOCAL_MODELS_README.md` for detailed instructions on using local models.

---

## :eyes: Usage

The first time you run the application, you will be prompted to enter your API key. It will be saved locally for future sessions.

**Don't have an API key?** You can:
1. **Get a free paid API key** by joining our community through any of our social links:
   - Join our [Discord server](https://discord.gg/fR35HeHD)
   - Follow us on [Telegram](https://t.me/atulhack)
   - Connect on [Instagram](https://instagram.com/atulhack)
   
   Our community members receive free API keys that normally require payment!

2. **Use local models** instead, which run directly on your device without requiring any API keys. Select "Local Models" from the main menu to get started.

### Commands

While in a chat session, you can use the following commands:

- `/new` - Start a new conversation
- `/export` - Export the current conversation to a markdown file
- `/prompt` - Change the system prompt mid-conversation
- `/help` - Display available commands
- `/exit` - Exit the chat session

### Web Search

The application includes a built-in web search feature powered by Brave Search API:

1. Select "Web Search" from the main menu
2. Enter your search query
3. View search results in a formatted table
4. Select a result number to open it in your browser
5. Search again or return to the main menu

The search feature uses the Brave Search API for real-time results and includes a fallback mechanism for offline use.

### Local Models

Vulcan GPT now supports running AI models locally without requiring API keys:

1. Select "Local Models" from the main menu
2. Install a model using one of the provided options:
   - Install a default model (TinyLlama, Phi-2, or Llama-2)
   - Download a model from HuggingFace
   - Download a model from a direct URL
3. Load the model and start chatting

For detailed instructions on using local models, see the `LOCAL_MODELS_README.md` file.

---

## :wrench: Configuration

Vulcan GPT offers several configuration options:

### System Prompts

You can create and manage custom system prompts through the application's interface. Select "Manage System Prompts" from the main menu to:

- Create new prompts
- Edit existing prompts
- Delete prompts
- View prompt content

### API Providers

Vulcan GPT now supports multiple API providers simultaneously:

1. From the main menu, select "Manage API Keys"
2. Choose "Add new API key" option
3. Select the provider you want to add
4. Enter your API key for that provider

When you start the application, if you have multiple API keys configured, you'll be prompted to choose which provider to use for your session. You can also test your API keys from the management interface.

### Brave Search API (Optional)

For enhanced web search capabilities, you can configure a Brave Search API key:

1. Get a free API key from [Brave Search API](https://brave.com/search/api/)
2. From the main menu, select "Manage API Keys"
3. Choose "Add new API key" option
4. Select "Brave Search" as the provider
5. Enter your Brave Search API key

The application will automatically use your Brave Search API key for web searches if configured, with a fallback to offline search if no key is available.

### Local Models Configuration

To configure local models:

1. From the main menu, select "Local Models"
2. Use the management interface to download, install, and manage local models
3. Configure model parameters like context size and thread count when loading a model

See `LOCAL_MODELS_README.md` for detailed configuration options.

### Social Links

The application includes social media links to support the developer:

1. When you start the application, the GitHub link automatically opens in your browser
2. A splash screen with all social links appears during startup
3. You can access the social links anytime from the main menu
4. You can open any of the links directly in your browser from within the application

### GitHub API Integration

Vulcan GPT includes GitHub API integration that allows you to interact with GitHub repositories:

1. **Setup Process**:
   - From the main menu, select "Integrations" and then "GitHub Integration"
   - Enter your GitHub Personal Access Token (PAT) when prompted
   - Provide your GitHub username
   - The application will verify your credentials

2. **Available Features**:
   - List your GitHub repositories with details (name, description, stars, language)
   - Create new issues in your repositories with title, body, and labels
   - Change GitHub account credentials

3. **API Implementation**:
   ```python
   # Authentication headers
   headers = {
       'Authorization': f'token {github_token}',
       'Accept': 'application/vnd.github.v3+json'
   }
   
   # Test token validity
   response = requests.get('https://api.github.com/user', headers=headers)
   
   # List repositories
   response = requests.get(f'https://api.github.com/users/{username}/repos', headers=headers)
   
   # Create an issue
   data = {
       'title': issue_title,
       'body': issue_body,
       'labels': labels
   }
   response = requests.post(
       f'https://api.github.com/repos/{username}/{repo}/issues',
       headers=headers,
       json=data
   )
   ```

4. **Using in Your Own AI**:
   - Create a GitHub PAT with appropriate permissions (repo scope for most operations)
   - Use the requests library to make API calls to GitHub endpoints
   - Authenticate using your token in the request headers
   - Parse the JSON responses to extract the data you need

---

## :warning: License

Distributed under the MIT License. See `LICENSE.txt` for more information.
