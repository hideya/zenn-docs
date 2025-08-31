---
title: "「各種 MCP」を「色々な LLM」で試す！ 話題の「gpt-oss」も無料で試せるツールをご紹介"
emoji: "🤖"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["MCP", "LangChain", "LLM", "gpt-oss", "生成AI" ]
published: true
---

<!-- ![robot-langchain-tools](/images/mcp-clients-for-testing/title.png) -->

### 「使いたい MCP サーバー」を「各種 LLM」で簡単に試せる コマンドライン・ツール のご紹介です

最近、魅力的な LLM が続々と発表されています！  
**LLM の高性能化や低価格化のスピードときたら、追いつくのが大変です。**  
「gpt-oss」なんていう ChatGPT のオープンソース版も出てきちゃいました。  
加えて、**MCP サーバーもかなり使えるものが出揃ってきています。**
MCP サーバーを単に呼び出して定型処理をするだけなら、廉価版 LLM でも結構いけます。
そこで…

- この MCP サーバーを使った所望の作業は[『gpt-5-mini - $0.25 / $2.00』](https://platform.openai.com/docs/pricing)でいけるのか？ せこく[『gpt-5-nano - $0.05 / $0.40』](https://platform.openai.com/docs/pricing)でもなんとかなるのか？
- コスパが話題の[『Gemini 2.5 Flash-Lite - $0.10 / $0.40 無料枠あり』](https://ai.google.dev/gemini-api/docs/pricing)ではどうか？
- 爆速[『Cerebras + gpt-oss-120B - $0.25 / $0.69 無料枠あり - 脅威の 3,000 tps』](https://inference-docs.cerebras.ai/models/openai-oss)は？

こういった確認を手軽にしたい！ そこで…
**「使いたい MCP サーバー」と「各種 LLM」の組み合わせを、簡単に色々試すための コマンドライン・ツール を作りました！**  
以下はそのご紹介です。  
今話題の **「gpt-oss」+ MCP も無料で試せます！**

## 例えば…

以下のような設定ファイルを書くと、指定した LLM で、Notion や GitHub の MCP サーバーがどう反応するか、同じ一連のクエリーを適用して、簡単に確認・比較することができます。

```json
{
  "llm": {
    "provider": "openai",       "model": "gpt-5-mini"
    // "provider": "anthropic",    "model": "claude-3-5-haiku-latest"
    // "provider": "google_genai", "model": "gemini-2.5-flash"
    // "provider": "xai",          "model": "grok-3-mini"
    // "provider": "cerebras",     "model": "gpt-oss-120b"
    // "provider": "groq",         "model": "openai/gpt-oss-20b"
  },

  "mcp_servers": {
    "notion": {  // リモートMCPサーバーに”mcp-remote”を使ってアクセス
      "command": "npx",
      "args": ["-y", "mcp-remote", "https://mcp.notion.com/mcp"],
    },

    "github": {
      "type": "http",  // OAuthが不要であれば、直接アクセスも可能
      "url": "https://api.githubcopilot.com/mcp",
      "headers": { "Authorization": "Bearer ${GITHUB_PERSONAL_ACCESS_TOKEN}" }
    },
  },

  "example_queries": [
    "私の Notion アカウントについて教えて",
    "私の GitHub プロファイルについて教えて",
  ]
}
```

MCP サーバー設定の記述方法は、Claude Desktop や Cursor、VSCode なんかと揃えるようにしています。  
ちなみにファイルの形式は JSON を拡張した JSON5 形式なので、コメントもOK、最後の要素の後にカンマ「`,`」が残っていても大丈夫です（なので各要素を簡単にコメントアウトできます）。  
また、**`${GITHUB_PERSONAL_ACCESS_TOKEN}`** といった形式で書くと、指定の環境変数の値がそこに入ります（セキュリティ的にそういった情報は設定ファイルに書き込みたくなかったのでこうしました）。

現時点でサポートしている LLM API プロバイダーは、**Anthropic、OpenAI、Google Gemini**（Vertex AI ではないです）、**xAI、Cerebras、Groq** です（Cerebras と Groq は主に「gpt-oss」と速度が目当てです）。

なお、**扱える MCP の出力形式は「テキストのみ」** です（それ以外は無視します）。

## 使い方

### インストール

[**npm でインストールする版**](https://www.npmjs.com/package/@h1deya/mcp-client-cli) と [**pip でのインストール版**](https://pypi.org/project/mcp-chat/) の ２バージョンがあります。お好みで使い分けてください（細かい差異は最後に説明します）。

👇 npm 版（TypeScript 実装版）は「Node.js 18 以上」が必要です
```bash
npm install -g @h1deya/mcp-client-cli
```

👇 pip 版（Python 実装版）は「Python 3.11 以上」が必要です
```bash
pip install mcp-chat
```

npm 版の実行コマンドは **「`mcp-client-cli`」**  
pip 版の実行コマンドは **「`mcp-chat`」** です。

### 設定ファイルの準備

ここでは動作確認のための設定ファイルをご紹介します。  
以下の内容をファイル名 **「`llm_mcp_config.json5`」**、文字コードは UTF-8 で保存してください。利用したい LLM のコメントを外して、それ以外はコメントアウトしてください。
```json
{
    "llm": {
        "provider": "openai",       "model": "gpt-5-mini"
        // "provider": "anthropic",    "model": "claude-3-5-haiku-latest"
        // "provider": "google_genai", "model": "gemini-2.5-flash"
        // "provider": "xai",          "model": "grok-3-mini"
        // "provider": "cerebras",     "model": "gpt-oss-120b"
        // "provider": "groq",         "model": "openai/gpt-oss-20b"
    },

    "example_queries": [
        "LLM の動作原理を簡単に説明して",
        "llm_mcp_config.json5 はどのようなファイルか簡単に説明して",
        "bbc.com のヘッドラインの冒頭の内容を日本語で要約して",
    ],

    "mcp_servers": {
        // ローカル・ファイル操作用 MCP
        // https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem
        "filesystem": {
            "command": "npx",
            "args": [
                "-y",
                "@modelcontextprotocol/server-filesystem",
                "."  // ここで指定のディレクトリー（カレントディレクトリ）以下のファイルを操作できる
            ]
        },

        // ウェブページをフェッチするための MCP
        // https://pypi.org/project/mcp-server-fetch/
        "fetch": {
            "command": "uvx",
            "args": [
                "mcp-server-fetch"
            ]
        },
    }
}
```

この例では、２つのローカル MCP サーバーを設定しています。その起動には、それぞれ **「`npx`」** と **「`uvx`」** を使用しています。必要に応じてインストールするか、使用しない場合は該当 MCP サーバーをコメントアウトしてください。

次に APIキー 等を環境変数で指定します。**「`.env`」ファイル** で以下のような感じで指定すると、ツール実行時にそこから読み込みます（以下のうち使うものだけ設定してください）。

```bash
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-proj-...
GOOGLE_API_KEY=AI...
XAI_API_KEY=xai-...
CEREBRAS_API_KEY=csk-...
GROQ_API_KEY=gsk_...
```

### 実行

これらのファイル「`llm_mcp_config.json5`」と「`.env`」を置いたディレクトリーで、「`mcp-client-cli`」もしくは「`mcp-chat`」を実行すると、以下のような感じで LLM と MCP サーバーを初期化して、ユーザーのクエリー入力待ちになります（以下の出力は「`mcp-client-cli`」のものですが、「`mcp-chat`」でもほぼ同じです）。なお、設定ファイル名はオプションで変更できます。詳しくは「`--help`」オプションでご確認ください。
```
% mcp-client-cli
Initializing model... { provider: 'cerebras', model: 'gpt-oss-120b' } 

Initializing 2 MCP server(s)...

Writing MCP server log file: mcp-server-filesystem.log
Writing MCP server log file: mcp-server-fetch.log
[info] MCP server "filesystem": initializing with: {"command":"npx","args":["-y","@modelcontextprotocol/server-filesystem","."],"stderr":14}
[info] MCP server "fetch": initializing with: {"command":"uvx","args":["mcp-server-fetch"],"stderr":16}
[info] MCP server "fetch": connected
[info] MCP server "fetch": 1 tool(s) available:
[info] - fetch
[MCP Server Log: "filesystem"] Secure MCP Filesystem Server running on stdio
[info] MCP server "filesystem": connected
[MCP Server Log: "filesystem"] Client does not support MCP Roots, using allowed directories set from server args: [ '/Users/hideya/.../mcp-chat-test' ]
[info] MCP server "filesystem": 14 tool(s) available:
[info] - read_file
  ︙
  ︙
[info] - list_allowed_directories
[info] MCP servers initialized: 15 tool(s) available in total

Conversation started. Type 'quit' or 'q to end the conversation.

Exaample Queries (just type Enter to supply them one by one):
- あなたのLLMモデル名を教えて
- llm_mcp_config.json5 はどのようなファイルか簡単に説明して
- bbc.com のヘッドラインの冒頭の内容を日本語で要約して

Query: █
```

ここで、クエリーを書き込むこともできますし、単にリターンを押せば  
「Exaample Queries」の最初のものが自動的に入力されます。

リターンを押すごとに次々とサンプルクエリーを実行していくので、同じ一連のクエリーで、LLM と MCP の色々な組み合わせでの挙動の違いを、手軽に確認・比較することができます。終了するには「`q`」と入力します。

サンプルでは、最初に MCP が絡まないクエリーで基本的な動作を確認し、その後に「filesystem MCP サーバー」によるローカルファイルの読み込みと、「fetch MCP サーバー」によるウェブページの取得を試みています（filesystem MCP サーバーは書き込み等もできちゃうので注意してください）。

ローカル MCP サーバーを動かすと、カレントディレクトリーにそれぞれの MCP サーバーのログファイルを出力します（fetch サーバはログを書き込まないので中身は空です）。ログファイルの書き出し先はオプションで変更できます。詳しくは「`--help`」オプションでご確認ください。

## 今話題の「gpt-oss」を無料で試す！

試せます！ LLM API プロバイダーの **「Cerebras」と「Groq」が無料枠を提供** しています！

- [**Cerebras の gpt-oss の無料枠の説明**](https://inference-docs.cerebras.ai/models/openai-oss)（下の方の「Tier / Free」の部分。頻度や総トークン量の上限の詳細）
- [**Groq の無料枠の説明ページ**](https://console.groq.com/docs/rate-limits)（同様の上限の説明）

「Cerebras」と「Groq」は Llama といったオープンソース / パラメータ LLM の利用 API を提供している企業なのですが、その特色は何とっても、**LLM 専用ハードウェアを用いた「爆走さ！」** にあります（GPU ではないんです。それぞれ [とても興味深い専用システム](https://zenn.dev/jnst/articles/cerebras-is-my-fave) を実装しています）。

LLM のランキングサイト、Artificial Analysis の [**「LLM API Providers Leadersboard」**](https://artificialanalysis.ai/leaderboards/providers) によると（このサイト超便利です！）、例えば、GPT-5 のトークン出力スピードは「200 tps（トークン / 秒）」ほどなのですが、  
**Cerebras＋gpt-oss-120B だと「3,000 tps」** を超えます。  
衝撃です。桁が違う。  
**groq＋gpt-oss-120B** だと「500 tps」程度。  
**groq＋gpt-oss-20B** は「1,000 tps」以上です。  
（値は 2025年 8月 現在。なお Cerebras は現時点では gpt-oss-20B をサポートしていません）

両方ともアカウントと API Key の作成はとても簡単（クレジットカード不要）ですので、ぜひ使ってみてください！

> ちなみに、上のサンプル・クエリーを使って **「gpt-oss-120B」** に対して「あなたのLLMモデル名を教えて」と聞くと **「私はOpenAIが提供するChatGPTで、GPT‑4（GPT‑4‑turbo）アーキテクチャをベースにした大規模言語モデルです」** と答えます。**「gpt-oss-20B」** の場合は **「私はOpenAIが開発したGPT‑4アーキテクチャをベースにしたChatGPTです」** と答えます（答え方は毎回やや異なります）。  
> お前ら、やはり GPT‑4 一味か。。

## 実装について

実装について少しだけ。ここから先はちょっと話が込み入ってくるので、まずはサクッと試したい方は読み飛ばしても大丈夫です！

このアプリは LangChain.js を用いて開発した MCP クライアントです。内部では MCP サーバーのツールを LangChain のツールに変換して実行しています。  
その変換には LangChain 公式の [MCP Adapters](https://www.npmjs.com/package/@langchain/mcp-adapters) は使っておらず、代わりに、**テキスト出力だけを扱う簡易 MCP アダプターを使っています**（[TypeScript 版](https://www.npmjs.com/package/@h1deya/langchain-mcp-tools)、[Python 版](https://pypi.org/project/langchain-mcp-tools/) ともに）。  
また、ツールの実行には [**LangGraph の ReAct エージェント**](https://langchain-ai.github.io/langgraphjs/reference/functions/langgraph_prebuilt.createReactAgent.html) を使っています（[LangChain 版の ReAct エージェント](https://v03.api.js.langchain.com/functions/langchain.agents.createReactAgent.html)ではないです）。

**このツールで挙動をチェックしても、下回りが異なると 挙動が異なる可能性があります** ので、一筆しました。

## Google Gemini が通常の LangChain.js＋MCP だとうまく動かない問題について

これは **TypeScript 版 特有の問題** なのですが、Google Gemini（`ChatGoogleGenerativeAI`）と LangChain.js 公式の MCP Adapters との組み合わせで 、スキーマ定義が複雑な MCP サーバーを呼び出そうとすると、以下のようなエラーメッセージをして **「400 Bad Request」** で失敗する場合があります（ちなみに Google Vertex AI なら回避できます）。なお、Python SDK では、この問題は発生しません。

> Google の新しい Gemini SDK（`@google/genai`）で直接 MCP を使えば問題を回避できるのですが、LangChain.js ではその回避方法が使えず、また LangChain.js の `ChatGoogleGenerativeAI` ではまだ古い SDK（`@google/generative-ai`）を使っており、問題が残っています。

```
GoogleGenerativeAIFetchError: [GoogleGenerativeAI Error]: Error fetching from https://generativelanguage.googleapis.com/v1beta/models/google-2.5-flash:generateContent: [400 Bad Request] Invalid JSON payload received. Unknown name "type" at 'tools[0].function_declarations[22].parameters.properties[2].value.items.all_of[1].any_of[1].properties[1].value.any_of[0].properties[1].value.any_of[1].all_of[0].properties[1].value': Proto field is not repeating, cannot start list.
Invalid JSON payload received. Unknown name "type" at 'tools[0].function_declarations[22].parameters.properties[2].value.items.all_of[1].any_of[1].properties[1].value.any_of[0].properties[1].value.any_of[1].all_of[0].properties[3].value': Proto field is not repeating, cannot start list.
Invalid JSON payload received. Unknown name "type" at 'tools[0].function_declarations[22].parameters.properties[2].value.items.all_of[1].any_of[1].properties[1].value.any_of[0].properties[1].value.any_of[1].all_of[1].any_of[1].properties[1].value.properties[1].value': Proto field is not repeating, cannot start list.
Invalid JSON payload received. Unknown name "type" at 'tools[0].function_declarations[22].parameters.properties[3].value.items.all_of[1].any_of[1].properties[1].value.any_of[0].pro
...長々と続く...
```

このエラーメッセージの主要な部分は **「GoogleGenerativeAIFetchError: … [400 Bad Request] Invalid JSON payload received」** です。

**スキーマ定義が複雑な MCP サーバー、例えば「Notion MCP サーバー」が１つでも MultiServerMCPClient に渡す設定に入っていると、単体では成功する他の MCP サーバーについてでも、ツール呼び出し時にこんな調子で失敗** してしまい、困りまくりです（2025年 8月 現在）。

そこで、**このアプリが使っている MCP アダプターではその対策をしました。** なので「mcp-client-cli」で「gemini-2.5-flash」とかを使っても、上記の MCP サーバーは問題なく動かせます。

> このエラーの原因は、[Gemini のツール呼出し（Function Calling）のスキーマへの要求が、えらく厳しい](https://ai.google.dev/api/caching#Schema) ことです。詳しくは割愛しますが、対策としてやってることは、MCP ツールの定義スキーマを変換して、Gemini が嫌がらない形式にすることです。この機能は LangChain.js でもサポートしても良いのではないかと思っていて、今、LangChain レベルでの良い対処方法を検討・仮実装しています。うまくいったら公開します！

ちなみに、このエラー回避機能は、設定ファイル「`llm_mcp_config.json5`」に以下のフラグをセットすることで止めることができます。そうすると上記の MCP サーバーを Gemini と共に使うとエラーが出るようになります。対策をしない場合の挙動を確認したい場合は、このようにしてみてください。
```json
{
    "schema_transformations": false,

    "llm": {
       ...
```

## mcp-client-cli と mcp-chat の違い

基本的には、ご自分の開発環境に合わせて使っていただければと思います。  
両者はほぼほぼ同じ機能なのですが、`mcp-chat`（Python 版）は、Python 特有のわかりづらいエラーメッセージが出る場合があります（まだ潰しきれていません）。あと、`mcp-client-cli` の方は、ローカル MCP サーバーのログの内容をファイルと同時にコンソールにも出力しますが、`mcp-chat` はファイル出力のみです。  
そんなこともあって、僕は `mcp-client-cli` を使うことの方が多いのですが、各種 SDK は、Python 版の方が「寛容（スキーマの扱いを含め）」な印象で、言語自体の使い勝手もあって Python で開発されている方も多いのではないかと思います。Python 版のデバグはやや手薄なので、もし問題があったらぜひ [GitHub](https://github.com/hideya/mcp-client-langchain-py) で Issue を投げてください 🙇‍♂️

---

以上、長くなってしまいましたが、**「各種 MCP を 色々な LLM で簡単に試せるツール」** のご紹介でした。  
お手軽に色々遊べますので、ぜひ活用してみてください。  
何かのお役に立てれば幸いです！🙏✨

