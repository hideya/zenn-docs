---
title: "LangChain.js × Gemini × MCPでハマる「400 Bad Request」をサクッと回避する方法"
emoji: "🛠️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["MCP", "Gemini", "MCP", "LangChain", "LLM" ]
published: false
---

LangChain.js を使って MCP サーバーを動かしつつ、LLM に Google Gemini を選んで試してみたところ……  
**「400 Bad Request: Invalid JSON payload received」**  
というエラーが…。これには何度も泣かされました。

特に、MCP サーバーのスキーマにちょっと複雑な要素（`anyOf` など）が含まれていると、Gemini がそれを受け付けず、一緒に使おうとしてる MCP 全部まとめて失敗してしまうんです。

LangChain.js ユーザーで、MCP 活用中、かつ Gemini のコスパの良さに目覚めた私にとっては、とても悩ましい問題です…。

そこで、「これはさすがに困る！」と思い、**Gemini でも MCPツール をエラー無しで使えるようにするための小さなライブラリ** を作ってみました。  
本記事では、

- どういう状況でエラーが出るのか
- どんな仕組みで回避できるのか
- 実際の導入方法とコード例

をご紹介します。  
同じように「LangChain.js × Gemini × MCP」でハマっている方のお役に立てば嬉しいです 🚀

## TL;DR

**もし Gemini + LangChain.js + MCP で 400 エラーが出てお困りの場合、このパッケージで差し替えるだけで解決します！**

まず、このライブラリを入れてみてください 👇
```bash
npm i @h1deya/langchain-google-genai-ex
```
そしてインポートを差し替えて：
```diff
- import { ChatGoogleGenerativeAI } from "@langchain/google-genai"
+ import { ChatGoogleGenerativeAIEx } from "@h1deya/langchain-google-genai-ex"
```
クラス名を **`ChatGoogleGenerativeAIEx`** に変えるだけ。

これで込み入ったスキーマの MCP を Gemini が拒否してエラーを返す問題を回避できます 🚀

## よくハマるエラー

LangChain.js で MCP を使っていて、LLM に Gemini を選んだときに…こんなエラーを見たことはありませんか？

```
[GoogleGenerativeAI Error]: Error fetching from https://generativelanguage.googleapis.com/v1beta
[400 Bad Request] Invalid JSON payload received.
Unknown name "anyOf" at 'tools[0].function_decla...
```
これは、**MCP サーバーのスキーマが Gemini にとって「複雑すぎる」** ときに起きます。

MCP ツールは LLM の Function Calling を使って実行されるのですが、この **ツール定義のスキーマへの要求が、Gemini はかなり厳しい** んです（[参考資料](https://ai.google.dev/api/caching#Schema)）。なので、要求のゆるい OpenAI や Anthropic の LLM では問題がなくても、Gemini だとうまく動かなくなることがあるんです。

特に問題なのが **`MultiServerMCPClient`** で複数の MCP サーバーをまとめて設定したときで、その中に 1 つでも「Gemini が理解できないスキーマ」を返す MCP サーバーがあると、**以降ぜんぶ失敗する** んです。

実際に私がハマったのはこんな MCP サーバーたち：
- `@notionhq/notion-mcp-server@1.9.0` (`npx` で実行)
- `airtable-mcp-server@1.6.1` (`npx` で実行)
- `mcp-server-fetch==2025.4.7` (`uvx` で実行)

公式の @langchain/google-genai ではこの問題は自動で直りません。  
新しい **Gemini SDK（`@google/genai`）ではこの問題に対応している** のですが、LangChain.js からは対処方法の相性が悪くて使えないんです。  
また **Vertex API を使えば、スキーマ要求がゆるい API が選べる** のですが、これは GCP のセットアップが必要で、気軽には使えません。

LangChain.js ユーザーで、かつ MCP と Gemini を活用したい私にとっては、悩ましい限りです…。

## 解決方法

そんなわけで、「このままじゃ Gemini と MCP が一緒に使えない！」と困り果てた末、その **対策を組み込んだ小さなライブラリを自作** して、パッケージとして公開しました：**`@h1deya/langchain-google-genai-ex`**（[リンク](https://www.npmjs.com/package/@h1deya/langchain-google-genai-ex)）

これをインストールして、提供しているクラスで「`ChatGoogleGenerativeAI`」を置き換えると、LangChain.js から Gemini を呼び出すときに **MCP のスキーマを自動的に 「Gemini フレンドリー」な形に書き換え** てくれます。単に **インポートとクラス名を置き換えるだけ** で OK です。
```diff
- import { ChatGoogleGenerativeAI } from "@langchain/google-genai"
+ import { ChatGoogleGenerativeAIEx } from "@h1deya/langchain-google-genai-ex"

- const model = new ChatGoogleGenerativeAI({...});
+ const model = new ChatGoogleGenerativeAIEx({...});
```
これで、MCP ツールのスキーマをそのままにしていても、Gemini が「anyOf があるからイヤ！」みたいに拒否せず、**ちゃんと受け付けてくれる** ようになります。

👉 つまり、**MCP の定義をいじらなくても、そのまま Gemini で使えるようになる「ドロップイン修正」** が可能です。

## 再現＆解決のコード例

サンプルコードを用いて使い方を具体的に見ていきましょう。  
以下ではその実行方法を説明します（即 clone して実行できるように GitHub にも上げました 👉 [リンク](https://github.com/hideya/langchain-google-genai-ex-usage)）。

### 1. 依存パッケージをインストール
```
npm i @langchain/core @langchain/mcp-adapters \
      @langchain/langgraph @langchain/google-genai \
      @h1deya/langchain-google-genai-ex
```
### 2. APIキーを設定
```
export GOOGLE_API_KEY=...
```
### 3. コードの実行 （Before / After）

以下のサンプルをそのまま実行してみると違いがわかります。

**Before（標準の ChatGoogleGenerativeAI を使った場合）**
```ts
import { ChatGoogleGenerativeAI } from "@langchain/google-genai";
// import { ChatGoogleGenerativeAIEx } from "@h1deya/langchain-google-genai-ex";
import { MultiServerMCPClient } from "@langchain/mcp-adapters";
import { createReactAgent } from "@langchain/langgraph/prebuilt";
import { HumanMessage } from "@langchain/core/messages";

const client = new MultiServerMCPClient({
  mcpServers: {
    fetch: { // This MCP server causes "400 Bad Request"
      command: "uvx",
      args: ["mcp-server-fetch==2025.4.7"]
    }
  }
});

(async () => { // workaround for top-level await
  const mcpTools = await client.getTools();
  
  const llm = new ChatGoogleGenerativeAI({ model: "gemini-2.5-flash" });
  // const llm = new ChatGoogleGenerativeAIEx({ model: "gemini-2.5-flash"} );
  
  const agent = createReactAgent({ llm, tools: mcpTools });
  const result = await agent.invoke({
    messages: [new HumanMessage("Read https://en.wikipedia.org/wiki/LangChain and summarize")]
  });
  
  console.log(result.messages[result.messages.length - 1].content);
  await client.close();
})();
```

これを実行すると、例の 400 Bad Request が返ってきます。

```
GoogleGenerativeAIFetchError: [GoogleGenerativeAI Error]: Error fetching from https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent: 
[400 Bad Request] Invalid JSON payload received. Unknown name "exclusiveMaximum" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field.
Invalid JSON payload received. Unknown name "exclusiveMinimum" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field. [{"@type":"type.googleapis.com/google.rpc.BadRequest","fieldViolations":[{"field":"tools[0].function_declarations[0].parameters.properties[1].value","description":"Invalid JSON payload received. Unknown name \"exclusiveMaximum\" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field."},{"field":"tools[0].function_declarations[0].parameters.properties[1].value","description":"Invalid JSON payload received. Unknown name \"exclusiveMinimum\" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field."}]}]
    at handleResponseNotOk (file:///.../node_modules/@google/generative-ai/dist/index.mjs:432:11)
    at process.processTicksAndRejections (node:internal/process/task_queues:95:5)
    at async makeRequest (file:///.../node_modules/@google/generative-ai/dist/index.mjs:401:9)
    at async generateContent (file:///.../node_modules/@google/generative-ai/dist/index.mjs:865:22)
    at async file:///.../node_modules/@langchain/google-genai/dist/chat_models.js:737:24
    at async RetryOperation._fn (/.../node_modules/p-retry/index.js:50:12) {
  status: 400,
  statusText: 'Bad Request',
  errorDetails: [
      ...
```

**After（`ChatGoogleGenerativeAIEx` に置き換え）**
```ts
// import { ChatGoogleGenerativeAI } from "@langchain/google-genai";
import { ChatGoogleGenerativeAIEx } from "@h1deya/langchain-google-genai-ex";
    ︙
    ︙
  // const llm = new ChatGoogleGenerativeAI({ model: "gemini-2.5-flash" });
  const llm = new ChatGoogleGenerativeAIEx({ model: "gemini-2.5-flash"} );
    ︙
```

これで エラーが消え、ちゃんと応答が返ってくる ようになります 🚀
```
LangChain is an open-source software framework launched in October 2022 
by Harrison Chase. It facilitates the integration of large language models 
(LLMs) into applications, with use cases including document analysis, 
summarization, chatbots, and code analysis.
...
```

👉 つまり、置き換えるのは **たった２行だけ。**  
このシンプルさがポイントです。

## スキーマの何が変更されたか確認する

もし、どのようなスキーマ変換が行われているかを確認したい場合、以下の環境変数を設定することで、詳細なログが取得できます。
```bash
LANGCHAIN_GOOGLE_GENAI_EX_VERBOSE=true
```
**出力例：**
```
🔧 Transforming 3 MCP tool(s) for Gemini compatibility...
  ✅ get-alerts: No transformation needed (simple schema)
  ✅ get-forecast: No transformation needed (simple schema)
  🔄 fetch: 2 exclusive bound(s) converted, 1 unsupported format(s) removed (uri)
📊 Summary: 1/3 tool(s) required schema transformation
```

## 良いところ

実際に試してみるとわかりますが、このアプローチの利点は：

- **とにかく簡単**  
  ➡︎ インポートとクラス名を置き換えるだけ。数分で終わります。
- **機能はそのまま**  
  ➡︎ ストリーミングやシステム・プロンプト等、元のクラスの機能は全部そのまま動きます。
- **破壊的変更なし**  
  ➡︎ 既存のコードを大きく直す必要はなく、今までどおり LangChain.js の他の機能とも問題なく連携します。
- **モデル互換性にも気を遣ってます**  
  ➡︎ Gemini 1.5 と 2.5 でテスト済み。
- **戻すのも簡単**  
  ➡︎ 将来 Gemini 側のスキーマ処理が改善されたり、MCP サーバー側が直ったりしたら、元の ChatGoogleGenerativeAI に戻すのも簡単です。

👉 **「今すぐ使える応急処置」としてすぐに適用可能で、状況をみつつ柔軟に元に戻せる** のがポイントです。

## 注意点

もちろん「完全に万能！」というわけではなく、いくつか「微妙な割り切り」をしてるところがあります。細かいですが、もし何か問題が起きたら、ここあたりに原因がある可能性があります：

- **未解決の参照**
  ➡︎ $ref で外部を参照しているスキーマは、単純化されて「とりあえずのオブジェクト型」に置き換わります。
- **タプル形式の配列**
  ➡︎ ["string", "number"] みたいに位置ごとに型を変える配列は、最初の要素だけが使われます。
- **列挙型やフォーマット**
  ➡︎ string の enum と一部のフォーマットだけ残ります。それ以外は落ちます。
- **複雑な組み合わせ**
  ➡︎ oneOf や allOf などはシンプル化されるので、バリデーションルールがちょっと緩くなったり、意味が少し変わることがあります。

つまり「Gemini が受け入れるようにスキーマを書き換える」代わりに、一部の厳密さを犠牲にしているところがあります。  
**実際にはほとんどの MCP ツールがそのまま動きます** が、もし何か問題を発見したら GitHub の Issue で報告していただけると助かります。

## 対応バージョン

このライブラリは、以下の環境で確認済みです（2025年9月時点）：

- `@langchain/core` @0.3.72
- `@langchain/google-genai` @0.2.16

Gemini の 1.5 / 2.5 モデルでも問題なく動作しました。  
（もちろん今後アップデートが入る可能性はありますが、そのときはまた対応していきます 💪）

## おわりに

私はこの問題に何度もハマり、そのたびに時間を浪費してきました。  
「またあの 400 エラーか…」と戦意喪失したことは一度や二度ではありません。

そんなこともあり、同じように悩んでいる方が時間をムダにせずにサクッと前に進めるように、このライブラリを作ってみました。もし何らかのお役に立てれば幸いです。

もし使ってみて何かフィードバックがあれば、[GitHub](https://github.com/hideya/langchain-google-genai-ex) で Issue や PR をいただければ助かります！🙏

### 参考資料・リンク

- [Gemini の Function Calling におけるスキーマ定義への要件](https://ai.google.dev/api/caching#Schema)
- [npmjs の @h1deya/langchain-google-genai-ex のページ](https://www.npmjs.com/package/@h1deya/langchain-google-genai-ex)
- [GitHub リポジトリ](https://github.com/hideya/langchain-google-genai-ex)
- [即実行可能な利用サンプルコード（GitHub）](https://github.com/hideya/langchain-google-genai-ex-usage)

