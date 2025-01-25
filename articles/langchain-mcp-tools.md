---
title: "【LangChain】の能力を 450+ の【MCP】ツール群で 一気に拡張する方法 ー ReAct Agent で使ってみる！"
emoji: "🤖"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["LangChain", "MCP", "AIエージェント", "ReAct", "LLM" ]
published: true
---

## Quick Start!

これから **「多量に存在する MCPサーバ群の機能を LangChain から簡単利用するためのユーティリティ」** と、それを使った LLM からの外部リソースの呼び出し方法をご紹介していきます！が、関連技術を既にご存知で「手早く実際のコードの雰囲気を見てみたい！」という方に向けて、

**まず最初に、LangChain の ReAct Agent を介して MCP の機能呼び出しを実現する方法の概略を、コードの実例と共に駆け足でご紹介** しようと思います。

以下ではコードがバーっと出てきますが、難しそうだなんて思わないでください！
以降の節で、その内容を詳細に説明していきます。

**「内容からじっくり理解したい」という方は、[次の節まで読み飛ばしてOKです！](#%E2%80%8B)**

では、使い方を手短に…

#### シムテム要件：

- Python 3.11+ もしくは Node.js 16+
- [uv のインストール](https://docs.astral.sh/uv/getting-started/installation/)（Pythonベースの MCPサーバの実行に使用）
- npm 7+（Node.js ベースの MCPサーバの実行に使用）

#### インストレーション：

- **"MCP To LangChain Tools Conversion Utility"** :
  - **[Python版 (PyPI)](https://pypi.org/project/langchain-mcp-tools/)**
  - **[TypeScript版 (npmjs)](https://www.npmjs.com/package/@h1deya/langchain-mcp-tools)**

```bash:Python
pip install langchain-mcp-tools
# uvユーザは：uv add langchain-mcp-tools
```
```bash:TypeScript
npm i @h1deya/langchain-mcp-tools
```

#### MCPサーバの設定：

```python:Python
mcp_configs = {
    'fetch': {
        'command': 'uvx',
        'args': ['mcp-server-fetch']
    }
}
```
```ts:TypeScript
const mcpServers: McpServersConfig = {
  fetch: {
    command: 'uvx',
    args: ['mcp-server-fetch']
  }
};
```

#### ユーティリティを用いた MCP から LangChain への橋渡し：

```python:Python
from langchain_mcp_tools import convert_mcp_to_langchain_tools
    ︙
try:
    tools, cleanup = await convert_mcp_to_langchain_tools(mcp_configs)
        ︙ tools の利用

finally:
    if cleanup:
        await cleanup()
```
```ts:TypeScript
import {
  convertMcpToLangchainTools,
  McpServersConfig,
  McpServerCleanupFn
} from '@h1deya/langchain-mcp-tools';
    ︙

let mcpCleanup: McpServerCleanupFn | undefined;
try {
  const { tools, cleanup } = await convertMcpToLangchainTools(mcpServers);
  mcpCleanup = cleanup
    ︙ tools の利用

} finally {
  await mcpCleanup?.();
}
```

#### LangChain / ReAct Agent のセットアップ例：

```python:Python
from langchain.chat_models import init_chat_model
from langgraph.prebuilt import create_react_agent
    ︙
llm = init_chat_model(
    model='claude-3-5-haiku-latest',
    model_provider='anthropic'
)

agent = create_react_agent(
    llm,
    tools
)
```
```ts:TypeScript
import { ChatAnthropic } from '@langchain/anthropic';
import { createReactAgent } from '@langchain/langgraph/prebuilt';
    ︙
const llm = new ChatAnthropic({ model: 'claude-3-5-haiku-latest' });

const agent = createReactAgent({
  llm,
  tools
});
```

以上で、たとえば **「bbc.com のニュースヘッドラインを読んで、日本語で要約して」** といったクエリが実行できるようになりました！

#### <!-- &ZeroWidthSpace; >>> -->​<!-- <-- <<< &ZeroWidthSpace; -->
![mcp-server-listing-sites](/images/langchain-mcp-tools/robot-langchain-tools.png)


## MCP のインパクト

Anthropic が [2024年11月に発表](https://www.anthropic.com/news/model-context-protocol)した「[Model Context Protocol（MCP）](https://modelcontextprotocol.io/introduction)」ですが、AI エージェント界隈でかなり盛り上ってます。MCP は何かというと、雑に言うと **LLM が外部ツールやリソースを扱えるようにして、生成 AI の適用範囲を劇的に拡大する オープンソース技術**。すでにこれを使って、Google Drive、Slack、Notion、Spotify、Docker、PostgreSQL なんかが LLM からアクセスできるようなってます。

ただ残念なのは、**MCP の作法に沿って使わないといけない**こと…
う〜ん、**LangChain から楽に使いたい！** そう思い立って！ 作りました！

**「MCPサーバの機能を LangChain から簡単利用するためのユーティリティ」**

LangGraph で提供されている **話題の [ReAct Agent](https://sun-asterisk.com/service/development/viblo/reactagent/) で実際に利用** してみたので、そのサンプルコードを用いて利用方法を以下で具体的に説明します。

ちなみに **現時点で利用可能な機能群（MCPサーバ）の数は 450以上**。 ウェブ検索やブラウザ・オートメーション、DB アクセス、クラウド・サービス利用、SNS 連携 を含め、驚くほど多くの種類の外部機能が、誰でも LLM 連携できるように公開されています。ご参考までに以下に MCPサーバのまとめサイトをご紹介します：

- [Glama’s list of Open-Source MCP servers](https://glama.ai/mcp/servers)
- [awesome-mcp-servers](https://github.com/hideya/awesome-mcp-servers#Server-Implementations)
- [Smithery: MCP Server Registry](https://smithery.ai/)
- [MCP公式サイトの MCPサーバの例](https://modelcontextprotocol.io/examples)

これら **450+の機能群（MCP サーバ）を LangChain からガッツリ使えるようにしちゃおう！** というのが、本ユーティリティの目論見です。

![mcp-server-listing-sites](/images/mcp-introduction/mcp-server-listing-sites.png =650x)


## LangChain ✕ MCP どうやって？

では、実際どうやるのでしょうか？
とっても簡単です！ **このユーティリティで、MCPサーバの機能群（ツール）を LangChain が直接扱える Tool に変換** して、それを単に使えば OK！

ユーティリティは Python 用 と TypeScript 用、両方用意してあります：

- **"MCP To LangChain Tools Conversion Utility"** :
  - **[Python版 (PyPI)](https://pypi.org/project/langchain-mcp-tools/)**
  - **[TypeScript版 (npmjs)](https://www.npmjs.com/package/@h1deya/langchain-mcp-tools)**

この使い方自体は極簡単なのですが、活用するには MCPの概略について理解しておく必要があります。そこで、次の節では、MCP について少々説明しようと思います。

もし MCP について既にご存知の方は、[その次の節までスキップ](#%E3%80%8Cmcp-to-langchain-tools-conversion-utility%E3%80%8D%E3%81%AE%E6%A6%82%E8%A6%81) して大丈夫です！

もし「MCPって初めて聞いた」という方は、ユーティリティの使い方を具体的に説明する前に、最低限必要な MCP の知識を少々お伝えさせてください。

> MCP の詳細について知りたい方は、もしよろしければ、こちらのドキュメントもご覧ください：
>『[AI エージェント界隈で話題の MCP の凄さ実感！ー その特徴・技術概要・今後の展開 ー「メタ AI エージェント」実現なるか？](https://zenn.dev/h1deya/articles/mcp-introduction)』


## MCP はどうやって外部ツールと連携しているのか？

LLM と MCP 機能群（MCPサーバ）がどのように連携してるか、以下の図で説明します（なおこれは、2025年 1月時点での典型的な実装例です）。ちょっと長いですが、少し辛抱してお付き合いください…

![mcp-diagram-stdio](/images/mcp-introduction/mcp-diagram-stdio.png =550x)

マシン（Your Computer）上で、LLM 利用アプリ（図の左側の LLM-powered App / LangChain で書かれたアプリも含む）が動いていたとすると、外部リソースへアクセスを仲介する「MCPサーバ」は、別プロセスとして動きます。たとえば、ウェブ検索 と SQLiteアクセスをするための MCPサーバを組み込んだ場合、それらは別プロセスとして動いて、LLM 利用アプリ側とは、標準入出力（`stdio`）を介してやりとりします（そのやりとりのプロトコルが狭義の MCP です）。

> なぜそんな面倒なことしてるのか… 詳しく知りたい方は（ちゃんと理由があります）、**[こちらのドキュメント](https://zenn.dev/h1deya/articles/mcp-introduction)** をぜひご参照ください。ちょっと長いですが MCP 関する情報が包括的にまとめてあります。

「MCPサーバ」は、典型的には Python や Node.js で記述された小規模なソフトウェアです。例えば上の図において、ウェブ検索 MCPサーバは、`stdio`を介して受け取ったリクエストを、ウェブ検索サービスの API 呼び出しに変換して、結果を得ます（一種のラッパーですね）。SQLite MCPサーバも同様で、リクエストを SQLite ライブラリが提供する API を使って実行します。

アプリ側で、MCPサーバとのやり取りを司るモジュールは「MCPクライアント」と呼ばれます（いわゆるクライアント・サーバ・アーキテクチャです）。MCPクライアントは、MCP対応 LLMアプリに組み込まれた小さなモジュールで、MCPサーバのプロキシ的な存在。MCPサーバと LLM とのやりとりを仲介します。

なお上の図では、MCPサーバそれぞれに MCPクライアントが１対１で対応していますが（なのでサーバ毎に別実装のクライアントが必要なようにも読めますが）、MCPクライアントの実装は共通です（サーバ毎に別インスタンスを生成します）。

MCPクライアントは、MCPサーバとの仲介に加え、MCPサーバ利用開始時のサーバの初期化、つまり MCPサーバ毎のサブプロセスの生成と、その中でのサーバコードの実行開始の面倒もみます（なので MCPサーバが別プロセスで動いていることはそんなに意識することはありません）。サーバコード取得の定石は、[`uvx`](https://docs.astral.sh/uv/guides/tools/)や[`npx`](https://docs.npmjs.com/cli/v8/commands/npx)を利用することで、これにより、いちいち手作業でサーバをインストールすることなしに使えるようになります。

ちっと長かったですが、これで MCPの挙動の基本的な知識はカバーできました。お疲れ様でした！


## 「MCP To LangChain Tools Conversion Utility」の概要

まず、このユーティリティが何をするのか、その概要を図を使って簡単に説明します。
以下の図をご覧ください。左側のアプリのハコの中の「LangChain」と「LangChain Tools」に注目してください。

このユーティリティは、MCPサーバの設定情報を受け取り、内部で MCPクライアントを生成し、サーバを生成・初期化して、「LangChain で直接利用可能な Tool」にラッピングして返します。

![langchain-mcp-tools](/images/langchain-mcp-tools/langchain-mcp-tools.png =550x)

つまり、MCPクライアントとその MCPサーバへのアクセスをひっくるめて隠蔽し、LangChainが扱える Tool（Pythonの場合は`List[BaseTool]`、TypeScriptの場合は`StructuredTool[]`）に変換します（通常１つの MCPサーバは複数の機能を提供しているので、それぞれを個別のツールとしてラップして、全サーバの分をまとめて配列（`List`/`Array`）で返します）。

上述のように、MCPサーバ・プロセスの起動や初期化は MCPクライアントが面倒を見ますので、それらも含めて、MCPサーバを利用するためのもろもろの詳細を、まるごと隠蔽しているといえます。

この変換は、ユーティリティ関数の呼び出し一発！で行えます（両方とも`async`です）：

- Pythonの場合は **`convert_mcp_to_langchain_tools()`**
- TypeScriptの場合は **`convertMcpToLangchainTools()`**

引数には、使いたい MCPサーバを初期化するための情報を与えます（複数サーバ対応）。
以下では具体的な例を用いて、その利用方法や実行結果を、やや細かめに説明します。


## 具体的な使用方法

シムテム要件は以下のとおりです：

- Python 3.11+ もしくは Node.js 16+
- [uv のインストール](https://docs.astral.sh/uv/getting-started/installation/)（Python ベースの MCPサーバの実行に `uvx` を使用）
- npm 7+（Node.js ベースの MCPサーバの実行に `npx` を使用）


利用に先立って、まずユーティリティをインストールします：

```bash:Python
pip install langchain-mcp-tools
# uvユーザは：uv add langchain-mcp-tools
```

```bash:TypeScript
npm i @h1deya/langchain-mcp-tools
```

全体感を掴んでいただくために、ユーティリティの呼び出しの手順をすべてまとめて書くと、Python版、TypeScirpt版それぞれで以下のようになります。コードの内容の詳細は順次追って説明します。


```python:Python
from langchain_mcp_tools import convert_mcp_to_langchain_tools
    ︙

mcp_configs = {
    'fetch': {
        'command': 'uvx',
        'args': ['mcp-server-fetch']
    },
    'filesystem': {
        'command': 'npx',
        'args': ['-y', '@modelcontextprotocol/server-filesystem', '.']
    }
}

try:
    tools, cleanup = await convert_mcp_to_langchain_tools(mcp_configs)
      ︙ Tool呼び出し

finally:
    if cleanup is not None:
        await cleanup()

```

```ts:TypeScript
import {
  convertMcpToLangchainTools,
  McpServersConfig,
  McpServerCleanupFn
} from '@h1deya/langchain-mcp-tools';
    ︙

const mcpServers: McpServersConfig = {
  fetch: {
    command: 'uvx',
    args: ['mcp-server-fetch']
  },
  filesystem: {
    command: 'npx',
    args: ['-y', '@modelcontextprotocol/server-filesystem', '.']
  }
};

let mcpCleanup: McpServerCleanupFn | undefined;
try {
  const { tools, cleanup } = await convertMcpToLangchainTools(mcpServers);
  mcpCleanup = cleanup;
   ︙ Tool呼び出し

} finally {
  await mcpCleanup?.();
}
```


### MCPサーバの設定

この例では、MCPサーバとして、以下の２つを設定しています：
- **`fetch`**：ネットから特定のページを読み出す機能
- **`filesystem`**：ローカルファイルの読み書き等の操作機能

それぞれの MCPサーバの実装は、[**PyPI**（Python Package Index）](https://pypi.org/) と [**npmjs**（Node Package Manager 用パッケージリポジトリ）](https://www.npmjs.com/) で提供されており、ここではそれを活用します。

各サーバの設定を詳しく見ていきましょう。
まず **`fetch`** の場合を見てみます：
```ts
  fetch: {
    command: 'uvx',
    args: ['mcp-server-fetch']
  },
```
**`command`** が **`uvx`** 、**`args`** が **`mcp-server-fetch`** となっています。
これはどういう意味かというと、**Fetch MCPサーバ** の初期化の際、生成（spawn）したサププロセスのシェルで、「 **`uvx mcp-server-fetch`** 」を実行する、つまり PyPI から [**Fetch MCPサーバの実装 `mcp-server-fetch`**](https://pypi.org/project/mcp-server-fetch/) を読み込んで、実行することを意味します。
**[`uvx`](https://docs.astral.sh/uv/guides/tools/)** を使っているので、**実行には [`uv`](https://docs.astral.sh/uv/) のインストールが必要** です。

> **[`uvx`](https://docs.astral.sh/uv/guides/tools/)** は比較的新しいツールで、2024年2月に発表された **[`uv`](https://docs.astral.sh/uv/)** にバンドルされています。
> `uv` は `pip` に相当するツールなのですが、「pip より 10〜100倍早い」そうです。いやマジ早いです！ 僕は最近は`pip`ではなく、極力`uv`を使うようにしています。
>  **`uvx`** は、PyPI でホストされた Pythonパッケージを取得してそのまま実行するためのコマンドです。つまり`pip`で手動でインストールしてからコマンドを実行するのではなく、パッケージを取得した後、そのまま実行します。MCPサーバのような小規模なパッケージの実行にはもってこいです。


次に **`filesystem`** の部分を見てみましょう：
```ts
  filesystem: {
    command: 'npx',
    args: ['-y', '@modelcontextprotocol/server-filesystem', '.']
  },
```
こちらは **Filesystem MCPサーバ** の起動時に「 **`npx -y @modelcontextprotocol/server-filesystem .`** 」を実行するよう指定しています。
つまり、spawn した MCPサーバのシェルから、**[`npx`](https://docs.npmjs.com/cli/v8/commands/npx)**（`uvx`に相当）を用い、**npmjs** から [**Filesystem MCPサーバの実装 `@modelcontextprotocol/server-filesyste`**](https://www.npmjs.com/package/@modelcontextprotocol/server-filesystem) を取得して、直接実行するよう設定しています。

なお最初の引数`-y`は、`npx`がユーザとのインタラクション無しに実行することを指示するオプションで、最後の「`.`」は、Filesystem MCPサーバが操作できるディレクトリのトップディレクトリを、アプリを動かした時のカレントディレクトリにすることを指定しています（**ファイルの削除もできちゃうので、指定には注意してください**）。

### MCP To LangChain Tools Conversion Utility の呼び出し

MCPサーバの設定が済んでしまえば、ユーティリティ関数の利用自体は簡単です！

```python:Python
try:
    tools, cleanup = await convert_mcp_to_langchain_tools(mcp_configs)
    
      ︙ MCPツールの利用

finally:
    if cleanup is not None:
        await cleanup()
```
```ts:TypeScript
let mcpCleanup: McpServerCleanupFn | undefined;
try {
  const { tools, cleanup } = await convertMcpToLangchainTools(mcpServers);
  mcpCleanup = cleanup;

   ︙ MCPツールの利用

} finally {
  await mcpCleanup?.();
}
```

ここれ返された **`tools`** は、Pythonの場合は **`List[BaseTool]`** 、TypeScriptの場合は **`StructuredTool[]`** で、そのまま LangChain で使うことができます。

**`cleanup`** は、MCPサーバの利用が終わった後で、サーバとのコネクションや使用リソースの開放をするために呼び出す`async`なコールバック関数です。典型的には`finally`ブロックで呼び出します。


### LangChian / ReAct Agent での利用例

それでは実際のコード例で、この **`tool`** を LangChain で利用する手順を見ていきましょう。

以下の例では、使用する LLM として、Anthropic の `claude-3-5-haiku-latest` を、LangChain のユーティリティ関数を用いて初期化しています。

実行には一時期話題をさらった[「ReAct エージェント」](https://sun-asterisk.com/service/development/viblo/reactagent/) を使っています。

ありがたいことに LangGraph（`langgraph.prebuilt`）で ReAct エージェント の初期化用関数が用意されています（Python：[`create_react_agent()`](https://api.python.langchain.com/en/latest/langchain/agents/langchain.agents.react.agent.create_react_agent.html)、TypeScript：[`createReactAgent()`](https://v03.api.js.langchain.com/functions/langchain.agents.createReactAgent.html)）。

これに、`llm` と共に、生成した `tools` を与えます：


```python:Python
# from langchain.chat_models import init_chat_model
llm = init_chat_model(
    model='claude-3-5-haiku-latest',
    model_provider='anthropic'
)

# from langgraph.prebuilt import create_react_agent
agent = create_react_agent(
    llm,
    tools
)
```

```ts:TypeScript
// import { ChatAnthropic } from '@langchain/anthropic';
const llm = new ChatAnthropic({ model: 'claude-3-5-haiku-latest' });

// import { createReactAgent } from '@langchain/langgraph/prebuilt';
const agent = createReactAgent({
  llm,
  tools
});
```

なお、ReAct Agent は以下の処理の面倒を見ます：
- 適切なツール選択ロジックの適用
- ツール実行のための推論のチェーン（連鎖）の実行
- ツール応答の処理

以上で MCP を LangChain から呼び出す準備ができました。


### クエリーの実行

この`agent`へのクエリーの投げ方は、要点だけをかい摘むと以下のような感じになります：

```python:Python
query = 'bbc.com のニュースヘッドラインを読んで、日本語で要約して、bbc-news.txtという名前でカレントディレクトリに保存して'
messages = [HumanMessage(content=query)]
result = await agent.ainvoke({'messages': messages})
# the last message should be an AIMessage
response = result['messages'][-1].content
```

```ts:TypeScript
const query = 'bbc.com のニュースヘッドラインを読んで、日本語で要約して、bbc-news.txtという名前でカレントディレクトリに保存して';
const messages =  { messages: [new HumanMessage(query)] }
const result = await agent.invoke(messages);
// the last message should be an AIMessage
const response = result.messages[result.messages.length - 1].content;
```

実際このクエリーを実行すると（ファイル書き込みがあるので注意！）、指示どおり **「bbc.com のニュースヘッドラインを読んで、日本語で要約して、bbc-news.txt という名前のファイルとして、カレントディレクトリ（このデモを起動したディレクトリ）に保存」** します。

つまり、**上の２つの MCPサーバを組み込むだけで、LLM アプリ外からの（ネットからの）情報の取得と、LLM アプリ外への情報の出力（ファイルの書き込み）ができるようになっちゃう** わけです。

Google Drive、Slack、Notion、Spotify、Docker、PostgreSQL… などにアクセスするための MCPサーバが、450+以上利用できるとなると…
組み合わせると何が実現できるのか…
妄想が膨らみます…！


### 実際の使用例

なお、実際に動く最小限のコードの実装例は、以下で見ることができます：
- [Python](https://github.com/hideya/langchain-mcp-tools-py-usage/blob/main/src/example.py)（"Simple MCP Client Using LangChain / Python"）
- [TypeScript](https://github.com/hideya/langchain-mcp-tools-ts-usage/blob/main/src/index.ts)（"Simple MCP Client Using LangChain / TypeScript"）

MCPサーバ連携を色々簡単に試してみたいという方は、このユーティリティを使って作成した、以下の簡単な LangChain アプリを試してみてください：
- ["MCP Client Using LangChain / Python"](https://github.com/hideya/mcp-client-langchain-py)
- ["MCP Client Using LangChain / TypeScript"](https://github.com/hideya/mcp-client-langchain-ts)


## 実行ログでの実際の挙動の確認

最後に、実際の挙動にご興味がある方向けに、以下では実行ログをご紹介しつつ、ポイントをまとめてみようと思います。

長いので、ご興味のない方はスキップしてください！（というか、これが最後の節です！）

変換ユーティリティはデフォルトで、以下のようなログメッセージを出しながら処理を進めます（ログレベルはオプションで変更できます）。挙動がわかりやすいように、１回のクエリーを処理するサンプルコード（上述のコード例）の起動から終了までのログを添付します。ちょっと長いですがご容赦ください… （以下の出力は TypeScript 版のものですが、Python 版でもほぼ同様です）

```
% npm start
> langchain-mcp-tools-ts-usage@0.1.9 start
> tsx src/index.ts

[info] MCP server "filesystem": initializing with: {"command":"npx","args":["-y","@modelcontextprotocol/server-filesystem","."]}
[info] MCP server "fetch": initializing with: {"command":"uvx","args":["mcp-server-fetch"]}
[info] MCP server "fetch": connected
[info] MCP server "fetch": 1 tool(s) available:
[info] - fetch
Secure MCP Filesystem Server running on stdio
Allowed directories: [ '/Users/hideya/.../langchain-mcp-tools-ts-usage' ]
[info] MCP server "filesystem": connected
[info] MCP server "filesystem": 11 tool(s) available:
[info] - read_file
[info] - read_multiple_files
[info] - write_file
[info] - edit_file
[info] - create_directory
[info] - list_directory
[info] - directory_tree
[info] - move_file
[info] - search_files
[info] - get_file_info
[info] - list_allowed_directories
[info] MCP servers initialized: 12 tool(s) available in total

bbc.com のニュースヘッドラインを読んで、日本語で要約して、bbc-news.txtという名前でカレントディレクトリに保存してください

[info] MCP tool "fetch"/"fetch" received input: {
  "url": "https://www.bbc.com/",
  "max_length": 5000,
  "start_index": 0,
  "raw": false
}
[info] MCP tool "fetch"/"fetch" received result (length: 5305)
[info] MCP tool "filesystem"/"write_file" received input: {
  "path": "bbc-news.txt",
  "content": "BBCニュースヘッドライン（日本語要約）:\n\n1. ...（略）..."
}
[info] MCP tool "filesystem"/"write_file" received result (length: 61)
[info] MCP tool "filesystem"/"read_file" received input: {
  "path": "bbc-news.txt"
}
[info] MCP tool "filesystem"/"read_file" received result (length: 585)

ファイルが正常に作成され、要約が保存されました。何か他にお手伝いできることはありますか？

[info] MCP server "filesystem": session closed
[info] MCP server "fetch": session closed
```

実行を開始するとまず、指定した内容に沿って、MCPサーバの初期化を開始している様子が伺えます。

１つの MCPサーバは、複数の機能（MCP でいうところの tool）を実装します。

Fetch MCPサーバの場合は `fetch` １つだけ。
Filesystem MCPサーバの場合は `read_file`、`write_file` など、計 11 のファイル関連の操作を実装しています。

これら計 12 の機能が、それぞれ個別の LangChain Tool に変換されます。

初期化が終わったら、ReAct エージェントにプロンプトを食わせます。

すると、プロンプトの内容から、 `www.bbc.com` ページの取得が必要と判断して `fetch`MCPサーバの`fetch`ツールを呼び出し、結果を得ます：

```
[info] MCP tool "fetch"/"fetch" received input: {
  "url": "https://www.bbc.com/",
  "max_length": 5000,
  "start_index": 0,
  "raw": false
}
[info] MCP tool "fetch"/"fetch" received result (length: 5305)
```

次にエージェント、は取得した内容を日本語で要約した結果をファイルに保存する必要を認識して、`filesystem`MCPサーバの`write_file`ツールを呼び出します。


```
[info] MCP tool "filesystem"/"write_file" received input: {
  "path": "bbc-news.txt",
  "content": "BBCニュースヘッドライン（日本語要約）:\n\n1. ...（略）..."
}
[info] MCP tool "filesystem"/"write_file" received result (length: 61)
```
ちなみにこの `received result`の内容は「書き込み成功」の類です。

> ひとつ興味深い点として、ログをよく見ると、書き込みの後に、検証読み込みを行っています。これは ReAct Agent が自律的にエラーチェックをしていると考えられ、 その能力の高さを示しているようにも思われます。しかしながら、同じ内容のクエリーを英語で試したら（内容を単に「要約して保存」と変更して）この検証読み込みは行われませんでした。。ReAct Agent は、やや気分屋さんなのかもしれません（本当？）
> > もしかしたら日本語でクエリーすると、詳細にうるさめな日本人向けに気を利かせて（！）挙動を変更しているのかもしれません…（妄想過ぎ？？）

保存が確認できたら、LLM はユーザにその旨返答します。

このサンプルアプリでは、これで処理を終了し、`cleanup`を呼び出して、MCPサーバとのセッションを終了しています。


## おわりに

以上、MCPサーバが提供する膨大な量の外部機能を LangChain から簡単に使えるようにするユーティリティの利用方法を説明いたしました。

長かったですが😅、みんさんの 想像力 + 創造力 を少しでも掻き立てられたなら、とってもうれしいです！

今回も、アップアップで書きました… もし何か書き違えを見つけたり、ご要望などございましたら、お気軽にコメントください 🙇‍♂️

このユーティリティを活用して、数々のツールを想定外な方法で組み合わせて、あっ！と驚くようなことを実現するアプリができたりしないかな… そんな利用例が出てくることを心待ちにしてます！🚀

> もちろん自分でも作ります！もし何か面白いのができたらご報告いたします！

> 今回こそは、サクッと簡潔に書き上げるつもりだったんだけどな…
> 書きはじめるといつも想定の３倍くらいの長さになっちゃう… 😓
