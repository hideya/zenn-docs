---
title: "LangChain.js × Gemini × MCP の Schema Error を回避する方法（@langchain/google版）"
emoji: "🛠️"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["MCP", "Gemini", "MCP", "LangChain", "LLM"]
published: true
---

### TL;DR

**もし Gemini + LangChain.js (`@langchain/google`) + MCP で 「`InvalidInputError: Gemini does not support ...`」や「`RequestError: Invalid JSON payload received`」が出てお困りの場合、このパッケージで差し替えるだけで解決します！**

まず、このライブラリを入れてみてください：
```bash
npm i @h1deya/langchain-google-ex
```
そしてインポートを差し替えて、クラス名を  **`ChatGoogleEx`** で置き換えるだけ：
```diff
- import { ChatGoogle } from "@langchain/google/node"
+ import { ChatGoogleEx } from "@h1deya/langchain-google-ex"

- const model = new ChatGoogle({...});
+ const model = new ChatGoogleEx({...});
```
これで込み入ったスキーマの MCP を Gemini が拒否してエラーを返す問題を回避できます。

> **Note：`@langchain/google-genai`** をお使いの方は、[**こちらの記事**](https://zenn.dev/h1deya/articles/mcp-langchain-gemini-400-error) をご覧ください。

> このライブラリは、`langchain` v1.5.10、`@langchain/google` v0.2.3、および `@langchain/mcp-adapters` v1.1.4 で動作を 確認しています。

## はじめに

LangChain.js を使って MCP サーバーを動かしつつ、LLM に Google Gemini を使うと「**`InvalidInputError: Gemini does not support ...`**」や「**`RequestError: Invalid JSON payload received`**」ようなスキーマエラーが出ることがあります。

困るのは、他の OpenAI や Anthropic のモデルではうまく動くのに、Gemini では動かない場合があることです。そこで、これをなんとかしたいと思い、**Gemini でも MCPツール をエラー無しで使えるようにするための小さなライブラリ** を作ってみました。

以下では、以前 作った `@langchain/google-genai` 用のライブラリを **`@langchain/google`** 用にアップデートしたものについて、実際の使い方をコード例を交えてご紹介します。

同じように「LangChain.js × Gemini × MCP」でハマっている方のお役に立てばうれしいです！

## よくハマるエラー

LangChain.js + Gemini（`@langchain/google`）で MCP を使っていて、こんなエラーに出くわすことがあります：

```
RequestError: Invalid JSON payload received.
Unknown name "exclusiveMaximum" ...
Unknown name "exclusiveMinimum" ...
```
```
InvalidInputError: Gemini does not support union types in function schemas.
Use a single type instead.
```
これは、**MCP サーバーのスキーマが Gemini にとって「複雑すぎる」** ときに起きます。

MCP ツールは LLM の Function Calling を使って実行されるのですが、この **ツール定義のスキーマへの要求が、Gemini はかなり厳しい** んです（[参考資料](https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/rest/v1/Schema)）。なので、要求のゆるい OpenAI や Anthropic の LLM では問題がなくても、Gemini だとうまく動かなくなることがあるんです。

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

そこで 対策を組み込んだ小さなライブラリを自作 して、パッケージとして公開しました： **`@h1deya/langchain-google-ex`**（[リンク](https://www.npmjs.com/package/@h1deya/langchain-google-ex)）

これをインストールして、提供しているクラスで「`ChatGoogle`」を置き換えると、LangChain.js から Gemini を呼び出すときに **MCP のスキーマを自動的に 「Gemini フレンドリー」な形に書き換え** てくれます。単に **インポートとクラス名を置き換えるだけ** で OK です。
```diff
- import { ChatGoogle } from "@langchain/google/node"
+ import { ChatGoogleEx } from "@h1deya/langchain-google-ex"

- const model = new ChatGoogle({...});
+ const model = new ChatGoogleEx({...});
```
これで、MCP ツールのスキーマをそのままにしていても、Gemini が「anyOf があるからイヤ！」みたいに拒否せず、**ちゃんと受け付けてくれる** ようになります。

つまり、**MCP の定義をいじらなくても、そのまま Gemini で使えるようになる「ドロップイン修正」** が可能です。

## 再現＆解決のコード例

以下ではサンプルコードを用いて使い方を具体的に見ていきます（即 clone して実行できるように GitHub にも上げました ➡︎ [リンク](https://github.com/hideya/langchain-google-ex-usage)）。

### 1. 依存パッケージをインストール
```
npm i langchain @langchain/mcp-adapters \
        @langchain/google @h1deya/langchain-google-ex
```
### 2. APIキーを設定
```
export GOOGLE_API_KEY=...
```
### 3. コードの実行 （Before / After）

以下のサンプルをそのまま実行してみると違いがわかります。

**Before（標準の `ChatGoogleGenerativeAI` を使った場合）**
```ts
import { ChatGoogle } from "@langchain/google/node";
// import { ChatGoogleEx } from "@h1deya/langchain-google-ex";
import { createAgent } from "langchain";
import { MultiServerMCPClient } from "@langchain/mcp-adapters";

const client = new MultiServerMCPClient({
  throwOnLoadError: true,
  useStandardContentBlocks: true,
  mcpServers: {
    fetch: {
      transport: "stdio",
      command: "uvx",
      args: ["--with", "mcp<2", "mcp-server-fetch==2025.4.7"],
    },
  },
});

(async () => { // workaround for top-level await
  try {
    const mcpTools = await client.getTools();
    const model = new ChatGoogle({
    // const model = new ChatGoogleEx({
      model: "gemini-3.5-flash",
      apiKey: process.env.GOOGLE_API_KEY,
    });
    const agent = createAgent({ model, tools: mcpTools });

    const result = await agent.invoke({
      messages: [
        {
          role: "user",
          content: "Fetch the raw HTML content from bbc.com and tell me the title",
        },
      ],
    });

    console.log(result.messages.at(-1)?.content);
  } finally {
    await client.close();
  }
})();
```

これを実行すると、**`RequestError: Invalid JSON payload received`** が返ってきます。

```
RequestError: Invalid JSON payload received. Unknown name "exclusiveMaximum" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field.
Invalid JSON payload received. Unknown name "exclusiveMinimum" at 'tools[0].function_declarations[0].parameters.properties[1].value': Cannot find field.
    at Function.fromResponse (/.../node_modules/@langchain/google/src/utils/errors.ts:543:12)
    at process.processTicksAndRejections (node:internal/process/task_queues:105:5)
    at async <anonymous> (/.../node_modules/@langchain/google/src/chat_models/base.ts:606:19)
    at async Object.pRetry (/.../node_modules/@langchain/core/src/utils/p-retry/index.js:246:22)
    at async run (/.../node_modules/p-queue/dist/index.js:163:29) {
  url: 'https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent',
  statusCode: 400,
  statusText: 'Bad Request',
  headers: {
      ...
```

**After（`ChatGoogleGenerativeAIEx` に置き換え後）**
```ts
// import { ChatGoogle } from "@langchain/google/node";
import { ChatGoogleEx } from "@h1deya/langchain-google-ex";
    ︙
    ︙
  // const model = new ChatGoogle({
  const model = new ChatGoogleEx({
    ︙
```

これで エラーが消え、ちゃんと応答が返ってくる ようになります！
```
I have fetched the raw HTML content of bbc.com. The title of the page (found inside the `<title>` tag) is:

**"BBC Home - Breaking News, World News, US News, Sports, Business, Innovation, Climate, Culture, Travel, Video & Audio"**
```

つまり、置き換えるのは たった２行だけ。  
このシンプルさがポイントです。

## スキーマの何が変更されたか確認する

もし、どのようなスキーマ変換が行われているかを確認したい場合、以下の環境変数を設定することで、詳細なログが取得できます。
```bash
export LANGCHAIN_GOOGLE_EX_VERBOSE=true
```
**出力例：** 上のサンプルコードの場合は、以下のようなログが出てきます。
```
🔧 Transforming 1 MCP tool(s) for Gemini compatibility...
  🔄 fetch: 2 exclusive bound(s) converted, 1 unsupported format(s) removed (uri)
📊 Summary: 1/1 tool(s) required schema transformation
```

## 良いところ

実際に試してみるとわかりますが、このアプローチの利点は：

- **とにかく簡単**  
  ➡︎ インポートとクラス名を置き換えるだけ。数分で終わります。
- **機能はそのまま**  
  ➡︎ ストリーミングやシステム・プロンプト等、元のクラスの機能は全部そのまま動きます。
- **破壊的変更なし**  
  ➡︎ 既存のコードを大きく直す必要はなく、今までどおり LangChain.js の他の機能とも問題なく連携します。
- **戻すのも簡単**  
  ➡︎ 将来 Gemini 側のスキーマ処理が改善されたり、MCP サーバー側が直ったりしたら、元の ChatGoogleGenerativeAI に戻すのも簡単です。

**「今すぐ使える応急処置」としてすぐに適用可能で、状況をみつつ柔軟に元に戻せる** のがポイントです。

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

## おわりに

私はこの問題で時間を浪費してきました。。  
そんなこともあり、同じように悩んでいる方が時間をムダにせずに済むように、このライブラリを作ってみました。もし何らかのお役に立てれば幸いです。

もし使ってみて何かフィードバックがあれば、[GitHub](https://github.com/hideya/langchain-google-ex) で Issue や PR をいただければ助かります！🙏

### 参考資料・リンク

- [Gemini の Function Calling におけるスキーマ定義への要件](https://docs.cloud.google.com/gemini-enterprise-agent-platform/reference/rest/v1/Schema)
- [npmjs の @h1deya/langchain-google-ex のページ](https://www.npmjs.com/package/@h1deya/langchain-google-ex)
- [GitHub リポジトリ](https://github.com/hideya/langchain-google-ex)
- [即実行可能な利用サンプルコード（GitHub）](https://github.com/hideya/langchain-google-ex-usage)
- [**`@langchain/google-genai`** 用の同様のパッケージ](https://www.npmjs.com/package/@h1deya/langchain-google-genai-ex)

