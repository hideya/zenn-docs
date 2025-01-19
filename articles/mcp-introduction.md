---
title: "AI エージェント界隈で話題の MCP は結構すごい！"
emoji: "🤖"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["MCP", "生成AI", "LLM", "Agent", "Anthropic" ]
published: true
---

## MCP が盛り上がってるらしい…

Anthropic が [2024年11月26日に発表](https://www.anthropic.com/news/model-context-protocol)した「[Model Context Protocol（MCP）](https://modelcontextprotocol.io/introduction)」ですが、AI エージェント界隈で結構な盛り上がりを見せています。そこで、その特徴や技術概要について、実際にコーディングした経験も踏まえてまとめてみようと思います。今後の開発方針（後述）を見るにつけ、MCP が切り開こうとしているこれからの展開とその可能性に、とてもワクワクしています！

**MCPとは、雑に言うと、LLM が外部リソースを扱えるようにして、生成 AI の適用範囲を劇的に拡大するための オープンソース技術です。**

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-plain.png)

以下ではまず、MCP のインパクトとその可能性をより具体的にイメージするために、活用例をひとつ見てみましょう。上の図を含めた MCP の技術的な説明は、その後でしようと思います。

## 最初に具体的な利用例を…（僕には衝撃でした…）

たとえば、github へのアクセスを可能にする MCPサーバへのアクセスを LLM アプリに組み込むと、以下のような指示（プロンプト）を LLM アプリに出すことができるようになります：

```
Please do the following:
- Make a simple html page
- Create a repository called "new-society-test"
- Push the html page to the "new-society-test" repo
- Add a little css to the html page and then push it up
- Make an issue suggesting we add some more content on the html page
- Now make a branch called feature and make that fix and push the change
- Make a pull request against main with these changes
```
つまり、簡単な HTML ページを自動で作り、"new-society-test"というリポジトリを作ってそこに push。簡単な CSS も追加で push。加えて「コンテンツをもう少し HTML ページに追加する」という Issue を作り、"feature"というブランチを作成し、なおかつこの Issue の修正案も自動で作ってそこに push。最後にこの修正の pull request を作成、という、簡単な例ではありますが、
**ふだんは人手でやってるような一連の開発作業とそれに伴う github の操作を、プロンプトで全自動でできちゃうんです！**

その実行の様子は、以下の Youtube で見ることができます（Youtuberさんも やや興奮気味です！）

https://www.youtube.com/watch?v=5CmAKm1wWW0&t=723s

なお、同じことを再現するには、「[Claude for Desktop](https://claude.ai/download)」（Claude PC/Mac アプリ）を有料プラン（Professional Plan）で使い、かつ、[github MCPサーバ](hhttps://github.com/modelcontextprotocol/servers/tree/main/src/github#setup)を[利用するための設定](https://modelcontextprotocol.io/quickstart/user)が必要になります。ムービーの前の方に説明があります。慣れればとても簡単。僕も実際に試して同様の挙動を確認しました（もし需要があれば日本語での説明と実行状況をポストするかも…）

## 450 以上の MCP サーバが利用可能！

github だけじゃないんです！
発表されてからまだそんなに経っていない MCP ですが、既に多数の MCPサーバが、開発・公開されています。ウェブ検索やブラウザ操作、DB アクセス、クラウド利用、SNS 連携 などなど、驚くほど多くの種類があります。以下にそれらのまとめサイトを３つご紹介します：

- [Glama’s list of Open-Source MCP servers](https://glama.ai/mcp/servers)
- [awesome-mcp-servers](https://github.com/hideya/awesome-mcp-servers#Server-Implementations)
- [Smithery: MCP Server Registry](https://smithery.ai/)

ご覧のように、すでに 450 以上の MCPサーバが利用できるんです！
これらを組み合わせるとどんなことが実現できるか… 想像するだけでもワクワクしてきませんか…？

## MCP の技術的な説明：具体的にどう動いてる？

MCP の大きな可能性が垣間見れたところでシフトチェンジ。中身のお話を。

上で紹介した github MCPサーバとかは、実際どのように LLM とつながっているのでしょうか？
MCP のアーキテクチャ的な特徴は何でしょうか？

以下は、2025年 1月時点での、MCPアーキテクチャの概要です：

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-stdio.png)

MCPフレームワークでは、外部機能は（2025年 1月時点では）別プロセスで実行される「MCPサーバー」としてカプセル化されます。そして利用側とは、オープンな標準プロトコル「[MCP Protocol](https://spec.modelcontextprotocol.io/)」に従って、標準入出力（`stdio`）を介してやり取りします。

「MCPサーバー」は、典型的には Python や node.js で記述された小規模なソフトウェアです。例えば上の絵の例において、ウェブ検索 MCPサーバは、`stdio`を介して受け取ったリクエストを、ウェブ検索サービスの API 呼び出しに変換して、結果を得ます（一種のラッパーですね）。SQLite MCPサーバも同様で、リクエストを SQlite ライブラリが提供する API を使って実行します。

アプリ側で、MCPサーバとのやり取りを司るモジュールは「MCPクライアント」と呼ばれます（いわゆるクライアント・サーバ・アーキテクチャです）。MCPクライアントは、MCP対応 LLMアプリに組み込まれた小さなモジュールで、MCPサーバのプロキシ的な存在です。MCPクライアントの実装は SDK で提供されています。SDK の実装では、MCPクライアントは、MCPサーバとのやりとりの仲介に加え、MCPサーバの初期化、つまり MCPサーバ毎のサブプロセスの生成と、その中でのサーバコードの実行開始の面倒もみます。サーバコードの取得は、王道は、[`uvx`](https://docs.astral.sh/uv/guides/tools/)や[`npx`](https://docs.npmjs.com/cli/v8/commands/npx)を利用することで、これにより、手作業個別のサーバをインストールすることなしに使えるようになります。

ここで「標準入出力（`stdio`）を介してやり取り」というところでピンときた方も多いかと思いますが、現時点の実装は初期バージョンで、当然のごとく、HTTP を介したネットワーク越しの通信の実装が計画されています（後述）。

ちなみに、MCPクライアントをサポートするアプリのリストは [こちらです](https://github.com/modelcontextprotocol/docs/blob/main/clients.mdx)。サーバに比べて数的にはまだまだですが、今後増えていくことを願っています。なお、現時点で現実的に使えるのは「[Claude for Desktop](https://claude.ai/download)」だけかなと思います。

> 脇道：「MCP」の「P」は「Protocol」の「P」。では「MCP Protocol」とは、こはいかに！？ …でも、[本家の資料](https://modelcontextprotocol.io/introduction)もそうなってるんで、ネイティブ的にも問題はないのでしょう…

## MCP の特徴のまとめ：従来の Function / Tool Calling とはどう違う？

今までの説明を聞いて、「それって [OpenAI の Function Calling](https://zenn.dev/kazuwombat/articles/1f39f003298028) や、[Claude の Tool Calling](https://zenn.dev/ttks/articles/b7115073a5712c)と本質的に何が違うの？」という疑問を持った方もいらっしゃるのではないでしょうか。ただ面倒な新しい仕組みを作っただけじゃないかと…

そこで、特にこれらと対比しての MCP アーキテクチャの特徴をまとめてみました：
- **オープンソース**：機能を提供する方（MCPサーバ）も、利用する方（MCPクライアント）も、プロトコルや SDK が公開されていて、無料で利用可能（[Python SDK](https://github.com/modelcontextprotocol/python-sdk) / [TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)）
- **実装の明確な分離と再利用性**：明確に定義された通信プロトコルを介して機能（MCPサーバ）の実装が完全に分離されており、その再利用性が非常に高い。
- **利用側の拡張性**：MCPクライアントは、すべての MCPサーバで共通で、どのような MCPサーバーにも対応できる。つまり、どんな LLM アプリであっても、MCPクライアントさえ最初に組み込んでおけば、どのような機能を持った MCPサーバでも利用でき、アプリ側の設定次第で、後から新規機能（MCPサーバ）を追加利用することもできる。
- **リモート・リソース・アクセス（将来）**：将来的には、ネットワーク越しのリソース（MCPサーバ）への直接アクセスできるようになるらしい。目下絶賛作業中らしい（後述）

以上のような特徴のおかげで、上述のように、オープンソース・コミュニティで広く受け入れられ、開発が非常に活発になっていると思われます！

## MCP の今後の展開：新たに切り開かれる可能性！

「リモート・リソース・アクセス、目下絶賛作業中」と言いましたが、根拠は [このロードマップ](https://modelcontextprotocol.io/development/roadmap) です。「Remote MCP Support」とガッツリ書いてあります。2025年前半のトッププライオリティだそうです！ 以下、ロードマップより抜粋：


1. **リモートMCP接続（最優先事項）**
    - OAuth 2.0を中心とした 認証・認可機能 の追加
    - リモート MCPサーバーの 発見（ディスカバリー）方法 と 接続方法 の定義
    - サーバーレス環境に対応するための ステートレス操作 の検討

2. **リファレンス実装**
     - すべてのプロトコル機能を含んだ 包括的なクライアント実装例 の提供
     - 新しいプロトコル機能の提案と組み込みのための 合理化されたプロセス の確立

3. **配布とディスカバリー**
    - MCPサーバーの 標準パッケージングフォーマット の策定
    - クライアント間での サーバーインストールの簡素化
    - サーバー分離によるセキュリティの向上
    - 利用可能な MCPサーバーを見つけるための 共通ディレクトリ の整備

4. **エージェントサポート**
    - 名前空間とトポロジー認識を通じた エージェントツリー のサポート強化
    - エージェント階層間のユーザー権限と 情報リクエストの改善
    - 長時間実行される操作からの リアルタイム更新機能

5. **エコシステムの拡大**
    - コミュニティ主導による標準（仕様）の開発の促進と 多様な AI プロバイダーの参加
    - テキスト以外のオーディオ、ビデオなどのフォーマットサポート
    - 標準化団体を通じた標準化の検討

> 上のまとめは Claude様にご助力いただきました 🙇‍♂️ バレバレですが…

個人的には、リモートMCP接続 にくわえ、リモート MCPサーバー・ディスカバリー と エージェントサポート が特に気になりました。

リモート MCP 接続とは、つまりはこんな感じですね。絵にするまでのこともないですが…

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-remote.png)

現状では、例えば github 機能を MCP 経由で利用するには、同じマシン上にサブプロセスを生成して、それが仲介する形で、MCPクライアントからのリクエストを、github の API 呼び出しに変換して、github サーバにアクセスしていたわけですが、もし github サーバが直接 MCPサーバとして振る舞えれば（そして MCPクライアントが HTTP 経由のリモート・リクエストをサポートすれば）、構成が一段シンプルになるわけです。

ただ主要な利点はそこではなくって、もっと大きな利点は、**現在、多くのウェブ・サービスが API を公開して、それをアプリが利用しているのと同じように、多くのウェブ・サービスが MCPサーバを公開して、さまざまな LLMアプリ がそれらを必要に応じて「発見（ディスカバー）」して利用できるようになったら…** とても多くの可能性が開けるのではないかと思います。ワクワクですね！

ちなみに、上記のロードマップの検討項目のいくつかは、[MCP 仕様用の github リポジトリ](https://github.com/modelcontextprotocol/specification/) の Issues で、公開的に議論されています（例えば：「[Authentication #64](https://github.com/modelcontextprotocol/specification/discussions/64)」）
参加しているのはその道のエキスパートでしょうから、ご興味のある方はこれらの議論を追ってみると、色々と学びが多いかもしれません。

## おわりに

以上、僕が感じた MCP の魅力と可能性について、現時点での理解をベースにまとめてみました。
とっ散らかった文章に、最後までお付き合いいただき、どうもありがとうございました 🙇‍♂️
もし何らかのご参考になることがあったのであればうれしいです 😀
