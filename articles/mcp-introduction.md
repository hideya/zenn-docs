---
title: "AI エージェント界隈で話題の MCP の凄さ実感！ー その特徴・技術概要・今後の展開 ー「メタ AI エージェント」実現なるか？"
emoji: "🤖"
type: "tech" # tech: 技術記事 / idea: アイデア
topics: ["MCP", "AIエージェント", "LLM", "生成AI", "Anthropic" ]
published: true
---

## MCP が盛り上がってるらしい…

Anthropic が [2024年11月に発表](https://www.anthropic.com/news/model-context-protocol)した「[Model Context Protocol（MCP）](https://modelcontextprotocol.io/introduction)」ですが、AI エージェント界隈で結構な盛り上がりを見せています。そこで、その特徴や技術概要、将来の展望について、実際にコーディングした経験も踏まえてまとめてみようと思います。今後の開発の方向性を見るにつけ、MCP が切り開こうとしている世界とその可能性に、とてもワクワクしています。希望的憶測だと、たぶん **「メタ AI エージェント」「自律進化型AIエージェント」** にまでつながります！（後述）

では手始めに、MCP について少々…

**MCPとは、雑に言うと、LLM が外部ツールやリソースを扱えるようにして、生成 AI の適用範囲を劇的に拡大するための オープンソース技術です。**

この技術は「AI エージェント」と非常に相性が良いです。たとえば「マーケティング AI エージェント」を構築したい場合、 LLM は MCP を介して、マーケティングに必須なツールやサービス群、たとえば、ウェブ検索や、売上・在庫 DB、CRM（Customer Relationship Management）システム、BI（Business Interigence）システム などにアクセスして、情報を取得したり操作したりできるようになります。こういったこともあり、特に AI エージェント界隈で MCP は大変話題になっています。

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-plain.png =550x)

以下ではまず、MCP のインパクトとその可能性をより具体的にイメージしていただくために、デモをひとつご紹介します。上の図を含めた MCP の技術的な話は、その後でしようと思います。

さらにその後、MCP の今後の展開についてまとめ、将来の MCP がもたらしうる、希望的観測満載😳の可能性の例として **「メタ AI エージェント」** と **「自律進化型AIエージェント」** について、ごく簡単に触れてみたいと思います。


## 最初に具体的な利用例を…（僕には衝撃でした…）

たとえば「GitHub にアクセスする MCPサーバ」が LLM アプリから利用できるようになると、何がうれしいのでしょうか？ そこで具体例をひとつ。例えば以下のようなプロンプトを LLM に投げることができるようになります：

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
つまり、簡単な HTML ページを自動で作り、"new-society-test"というリポジトリを作ってそこに push。簡単な CSS も追加で push。加えて「コンテンツをもう少し HTML ページに追加する」という Issue を作り、"feature"というブランチを作成し、なおかつこの Issue の修正案も自動で作ってそこに push。最後にこの修正の pull request を作成、という、
いたって簡単な例ではありますが、**ふだんは人手でやってるような一連の開発作業とそれに伴う GitHub の操作を、プロンプト一発で全自動でできちゃうんです！**

その実際の様子は、以下の Youtube で見ることができます👇
「未来が来た〜！」と Youtuberさんも興奮気味です！早口すぎッ😅

[![david-youtube](/images/mcp-introduction/david-youtube.png =500x)](https://www.youtube.com/watch?v=5CmAKm1wWW0&t=723s)

なお、同じことを自分で再現するには、「[Claude for Desktop](https://claude.ai/download)」（Claude PC / Mac アプリ）を有料プラン（Professional Plan）で使い、かつ、[GitHub MCPサーバ](https://github.com/modelcontextprotocol/servers/tree/main/src/github#setup) を [利用するための設定](https://modelcontextprotocol.io/quickstart/user) が必要になります。ムービーの前の方に説明があります。一度わかればとても簡単。僕も実際に試して同様の挙動を確認しました（もし需要があれば日本語での説明と実行状況をポストするかも…）


## 450 以上の MCP サーバが利用可能！

GitHub だけじゃないんです！
発表されてからまだそんなに経っていない MCP ですが、既に多数の MCPサーバが、開発・公開されています。たとえば、Google Drive、Slack、Notion、Spotify、Docker、PostgreSQL などなど… ウェブ検索やブラウザ・オートメーション、DB アクセス、クラウド・サービス利用、SNS 連携 を含め、驚くほど多くの種類があります。以下に MCPサーバのまとめサイトをご紹介します：

- [Glama’s list of Open-Source MCP servers](https://glama.ai/mcp/servers)
- [awesome-mcp-servers](https://github.com/hideya/awesome-mcp-servers#Server-Implementations)
- [Smithery: MCP Server Registry](https://smithery.ai/)
- [MCP公式サイトの MCPサーバの例](https://modelcontextprotocol.io/examples)

![mcp-diagram-plain](/images/mcp-introduction/mcp-server-listing-sites.png =650x)

ご覧のように、すでに 450 以上もの MCPサーバが利用できるんです！
これらを組み合わせるとどんなことが実現できるか… 想像するだけでもワクワクしてきませんか…？


## MCP の技術的な説明：具体的にどう動いてる？

MCP の大きな可能性が垣間見れたところでシフトチェンジ。中身のお話を。
そこそこ技術的な内容です。ご興味のない方は [読み飛ばしてOK！](#mcp-%E3%81%AE%E7%89%B9%E5%BE%B4%E3%81%AE%E3%81%BE%E3%81%A8%E3%82%81%EF%BC%9A%E5%BE%93%E6%9D%A5%E3%81%AE-function-%2F-tool-calling-%E3%81%A8%E3%81%AF%E3%81%A9%E3%81%86%E9%81%95%E3%81%86%EF%BC%9F)

上で紹介した MCPサーバは、実際どのように LLM とやり取りするのでしょうか？
MCP のアーキテクチャ的な特徴は何でしょうか？

以下は、2025年 1月時点での公式サイトの説明に沿った MCP 利用システムの構成例です：

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-stdio.png =550x)

MCPフレームワークでは、外部機能は（2025年 1月時点での参考例では）別プロセスで実行される「MCPサーバー」としてカプセル化されます。そしてその利用側とは、オープンな標準プロトコル「[MCP Protocol](https://spec.modelcontextprotocol.io/)」に沿って、標準入出力（`stdio`）を介してやり取りします。

「MCPサーバー」は、典型的には Python や Node.js で記述された小規模なソフトウェアです。例えば上の図において、ウェブ検索 MCPサーバは、`stdio`を介して受け取ったリクエストを、ウェブ検索サービスの API 呼び出しに変換して、結果を得ます（一種のラッパーですね）。SQLite MCPサーバも同様で、リクエストを SQLite ライブラリが提供する API を使って実行します。

アプリ側で、MCPサーバとのやり取りを司るモジュールは「MCPクライアント」と呼ばれます（いわゆるクライアント・サーバ・アーキテクチャです）。MCPクライアントは、MCP対応 LLMアプリに組み込まれた小さなモジュールで、MCPサーバのプロキシ的な存在。MCPサーバと LLM とのやりとりを仲介します。なお上の図では、MCPサーバそれぞれに MCPクライアントが１対１で対応していますが（なのでサーバ毎に別実装のクライアントが必要なようにも読めますが）、MCPクライアントの実装は共通です（サーバ毎に別インスタンスを生成します）。


この MCPクライアントの実装は SDK で提供されています（[Python client](https://github.com/modelcontextprotocol/python-sdk/tree/main/src/mcp/client)・[TypeScript client](https://github.com/modelcontextprotocol/typescript-sdk/tree/main/src/client)）。実装では、MCPクライアントは、MCPサーバとの仲介に加え、MCPサーバの初期化、つまり MCPサーバ毎のサブプロセスの生成と、その中でのサーバコードの実行開始の面倒もみます。サーバコード取得の定石は、[`uvx`](https://docs.astral.sh/uv/guides/tools/)や[`npx`](https://docs.npmjs.com/cli/v8/commands/npx)を利用することで、これにより、いちいち手作業でサーバをインストールすることなしに使えるようになります。

ここで「標準入出力（`stdio`）を介してやり取り」というところでピンときた方も多いかと思いますが、この実装は 最初期バージョンで、当然のごとく、HTTP を介したネットワーク越しのやり取りの実現が計画されています（後述）。

> 実際、[Python Client SDK](https://github.com/modelcontextprotocol/python-sdk/tree/main/src/mcp/client) と [TypeScript Client SDK](https://github.com/modelcontextprotocol/typescript-sdk/tree/main/src/client) の実装をのぞいてみると、HTTPプロトコル用の実装（`sse.py` と `sse.ts`）がすでに存在します。この「sse」は「Server-Sent Events」のことで、コメントによると「メッセージの受信には Server-Sent Events を使用、送信には個別の POST リクエストを使用」とのことです。認証まわりの標準化が未完成なので（後述）、まだ公には利用を勧めていないのだと思われます。

ちなみに、MCPクライアントをサポートするアプリの一覧は [こちらです](https://github.com/modelcontextprotocol/docs/blob/main/clients.mdx)。数的にもまだまだですが、今後増えていくことを願っています。なお、現時点でちゃんと有意義に使えるのことを自分自身で確認したのは「[Claude for Desktop](https://claude.ai/download)」だけです。

> 脇道：「MCP」の「P」は「Protocol」の「P」。では「MCP Protocol」とは、こはいかに？！ …でも、[本家の資料](https://modelcontextprotocol.io/introduction) もそうなってるんで、エキスパート的にも英語的にも問題はないのでしょう… 
おっとそういえば！「HTTP Protocol」って自分も平気で言ってる〜 😅


## MCP の特徴のまとめ：従来の Function / Tool Calling とはどう違う？

今までの説明を聞いて、「それって [OpenAI の Function Calling](https://zenn.dev/kazuwombat/articles/1f39f003298028) や、[Claude の Tool Calling](https://zenn.dev/ttks/articles/b7115073a5712c)と本質的に何が違うの？」という疑問を持った方もいらっしゃるのではないでしょうか。ただ面倒な新しい仕組みを作っただけじゃないかと…

そこで、特にこれらと比較しての MCP アーキテクチャの特徴をまとめてみました：
- **オープンソース** 🎉：機能を提供する方（MCPサーバ）も、利用する方（MCPクライアント）も、プロトコルや SDK が公開されていて、無料で利用可能（[Python SDK](https://github.com/modelcontextprotocol/python-sdk) / [TypeScript SDK](https://github.com/modelcontextprotocol/typescript-sdk)）
- **実装の明確な分離と再利用性** 🧩：明確に定義された通信プロトコルを介して機能（MCPサーバ）の実装が完全に分離されており、その独立性と再利用性が非常に高い。
- **利用側の拡張性** 🚀：MCPクライアントは、すべての MCPサーバで共通で、どのような MCPサーバーにも対応できる。つまり、どんな LLM アプリであっても、MCPクライアントさえ最初に組み込んでおけば、さまざまな機能を持った MCPサーバに対応でき、アプリ側の設定次第で、後から新規機能（新しい MCPサーバ）を追加利用することもできる。
- **アプリ間の相互運用性** 🤝：また上記のことは、MCPクライアントを組み込んだ すべてのアプリの間で、すべての MCPサーバが共通に利用できることも意味する。
- **リモート・リソース・アクセス 🌐（将来）**：将来的には、ネットワーク越しのリソース（MCPサーバ）への直接アクセスができるようになるらしい。目下絶賛作業中らしい（後述）

以上のような特徴のおかげで、上述のように、オープンソース・コミュニティで広く受け入れられ、非常に活発に開発が進められています！


## MCP の今後の展開：新たに切り開かれる可能性「メタ AI エージェント」「自律進化型AIエージェント」

「リモート・リソース・アクセス、目下絶賛作業中」と言いましたが、根拠は [このロードマップ](https://modelcontextprotocol.io/development/roadmap) です。「Remote MCP Support」とガッツリ書いてあります。2025年前半のトッププライオリティだそうです。このロードマップで個人的に興味を引いた事項を以下に抜粋しました：

1. **リモートMCP接続（最優先事項 🎯）**
    - 標準化された認証機能の追加、特に OAuth 2.0 のサポートに重点
    - **リモート MCPサーバーのディスカバリー（発見）と 接続方法 の定義**

2. **MCPサーバー共有方法の改善（Distribution と Discovery）** 📦
    - MCPサーバーのパッケージング・フォーマットの標準化
    - MCPクライアントでのサーバーのインストールを簡素化するインストールツール
    - 「Server Registry」を提供することによる サーバの登録・発見の支援

3. **エージェントの連携サポート** 👯
    - 名前空間とトポロジーに配慮した、エージェントのツリー階層のサポート強化
    - エージェント階層をまたいだユーザーの権限と情報のリクエストへの対応の改善

この中で、特に **「リモート MCPサーバー・ディスカバリー」** と **「MCPサーバー共有方法の改善」** が気になりました。

リモート MCP 接続を利用したシステム構成は、こんな感じになると思われます。

![mcp-diagram-plain](/images/mcp-introduction/mcp-diagram-remote.png =550x)

現状では、例えば GitHub 機能を MCP 経由で利用するには、同じマシン上にサブプロセスを生成して、それが MCPクライアントからのリクエストを GitHub の API 呼び出しに変換していたわけですが、もし MCPクライアントが HTTP 経由のリモート・リクエストをサポートして、もし GitHub サーバが直接 MCPサーバとしても振る舞えれば（もしくは MCPサーバを並立できれば）、上の図のように構成が一段とシンプルになるわけです。

このように構成がかなりスッキリするのですが、リモート MPC 接続の重要な狙いはそこではないと思っています。では何か？ **「リモート MCPサーバー・ディスカバリー」** と組み合わせてできるようになることを妄想すると…

**現在、多くのウェブ・サービスが API を公開して、それをアプリが利用しているのと同じように、多くのウェブ・サービスが MCPサーバを公開して、さまざまな LLMアプリ が必要に応じてそれらを「ディスカバー（発見）」して利用できるようになったら…** 🤔

**そしてそれをベースにして、LLM が与えられた業務を与えられた環境でこなすための最適な手段を自動的に見出して、特定用途向けに高度に最適化された（たとえば「A社B部門のサービスC のマーケティング 超専用」の、もしくは「自分超専用（！）」の）、新しい AI エージェントを個別に作り出せたら…** 😮

**そんなエージェントを自動生成する「メタな AI エージェント」（専用エージェント生成専用エージェント）が実現できたら…** 😲

**さらにはエージェント自身が、環境や状況の変化に対応するために新たな機能が必要になった場合、そのことを自ら認識し、その機能を探し出して自身を拡張するような「自律進化型AIエージェント」が実現できたら…** 🤯

やや妄想過ぎかもですが😅、長く夢見られていたそんな未来を実現するための基盤技術の開発が、リモート MPC 接続を手始めに、今盛んに進められているのです。もしこういった世界が実現できれば、とても多くの可能性が開けていくのではないでしょうか！

![mcp-diagram-plain](/images/mcp-introduction/robot-building-robot.png)

ウェブ API についても一覧等は存在しますが、それらから必要な機能を探し出して動的に追加利用する… とまでは至ってないです。でも今の時代には LLM があります。自然言語による自由気ままなプロンプトの内容から、必要なツール呼び出しを見出して実行できるのと同じように、与えられた作業に対して必要なサービスを見出して、それをネットから探し出して利用することが自律的にできるようになったら… そんな未来を想像しています。
> そもそも、LLM がそんなに頭がいいんなら、既存のウェブ API 呼び出しを直接 LLM にさせればいいんじゃね？ HTTP クライアントの機能だけ入れといて、あとは LLM に良きに計らってもらえば？ とかも考えたりもしますが、LLM で利用するためには、提供している機能と呼び出し方の適切な情報（信頼できるメタデータ）が必要で、認証やセキュリティーまわりも考慮すると、そんなに簡単ではない、、、たぶんそういう判断なのでしょう。
>> いやいやそんなの LLM にググらせればわかるでしょ？ 大体、人間だってそうやって API 呼び出しの利用方法の説明やコード例を探してきて実装してるんだから、その真似事くらいできるでしょ、とか議論できるかもですが、実現できたとしてもちょっと手数が多くなりすぎるのかなぁ… でも、成功した事例をネットで共有して（たとえば LLM が StackOverflow とかを利用して）それらを参照するとこで二度手間を省けば良くね、とか… う〜ん、一瞬それでもいいようにも思えましたが… でもセキュリティ面でだめかな？ ネット上に偽情報を撒いてそれを実行させて、パスワードや API キーをゲットとか、はたまた悪意のあるクレジット・カード利用をカモフラージして実行させるとか… たぶん、こういった懸念もあって、認証まわりも含めた正式なプロトコルを策定することにしたのでしょうね。

ちなみに、上記のロードマップの検討項目のいくつかは、[MCP 仕様用の GitHub リポジトリ](https://github.com/modelcontextprotocol/specification/) の [Issues](https://github.com/modelcontextprotocol/specification/issues) で、議論が一般公開されています（例えば：「[Authentication #64](https://github.com/modelcontextprotocol/specification/discussions/64)」）
参加しているのはその道のエキスパートでしょうから、ご興味のある方はこれらの議論を追ってみると、色々と学びが多いかもしれません。


## 勢いあまって… LangChain から MCPサーバを簡単に使うためのライブラリを作って公開しました

で、MCP の魅力と可能性に影響されまくって！勢い余って！ LangChain から MCPサーバを簡単に使うためのライブラリを作っちゃいました…😳

だって、450+もの機能がそろった MCPサーバを活用したアプリを、できるだけ楽に作りたいじゃないですか。で、LLM アプリの作成といえば [LangChain](https://www.langchain.com/)。LangChain のツール呼び出しで MCPサーバが簡単に呼び出せれば、これはうれしいはずだ！ ということで、早速作って以下で公開しました：
- **"MCP To LangChain Tools Conversion Utility"** :
  - [Python (PyPI)](https://pypi.org/project/langchain-mcp-tools/)
  - [TypeScript (npmjs)](https://www.npmjs.com/package/@h1deya/langchain-mcp-tools)

くわえて、このライブラリを使って、簡単な MCPサーバ対応 AIチャットアプリ（コマンドライン・ベース）も作りました。このMCPクライアントを使えば、Claude for Desktop を使わなくても色々な MCPサーバで遊ぶことができます：
- **"MCP Client Using LangChain"** :
  - [Python (github)](https://github.com/hideya/mcp-client-langchain-py)
  - [TypeScript (github)](https://github.com/hideya/mcp-client-langchain-ts)


これらの利用方法の紹介や、実装でハマった点なんかについても、色々書き留めることができればと思っているのですが、今はこの文章書くのだけで、ちょっと燃え尽き気味で、、、😵‍💫
その辺はまたの機会に！

> **ツールの利用方法の記事、書きました！** もしよろしければ、ぜひ 👇
> [「【LangChain】の能力を 450+ の【MCP】ツールで 一気に爆充する！ ／ ReAct Agent で使ってみた（Py＆Ts）」](https://zenn.dev/h1deya/articles/langchain-mcp-tools)


## ちょっと冷静に：他社を含めた今後の展開は？

MCP の凄さや可能性についてバンバン盛り上げて書き下してきたわけですが、ちょっと冷静に、他社を含めた今後の展開について少し。。

MCP はいくらオープンソースとはいえ Anthoropic 主導の技術なので、果たして、他の LLM プロバイダー、特に大物 OpenAI がどう出るか…？ 独自の対抗馬を出してくるのか…？ 現時点ではまだ情報は見当たりません。要注目です。

あと、上で GitHub の例を出しましたが、今出ている GitHub MCPサーバは、GitHubが出したオフィシャル版、というわけではありません。「すで多量の MCPサーバが！」と盛り上げましたが、API が公開された既存のサービスに対する MCPサーバを書くのはそんなに難しくないので（要はラッパーなので）、MCP がオープンソースということもあり、「こいつとの連携が欲しい！」と思った人が、勝手にバンバン作った結果、ともいえます（それでもその勢いや、それらがもたらす利便性はすごいですが！）。

では、GitHub がオフィシャル版を出してくるか？ より重要な質問は、「果たして GitHub は リモートMCPサーバ をホストするのか？」ですが、GitHub は Microsoft 傘下で、Microsoft は OpenAI に出資しているので、OpenAI の意向に沿った感じになるのではないか… と思われます。

> ちなみに OpenAI は、2024年10月に「**Swarm**」と呼ばれる マルチエージェント・オーケストレーション・フレームワーク（雑にいって LangChain / LangGraph みたいなもの）をオープンソースとして公開していますが（[github](https://github.com/openai/swarm)）、2025年2月時点でも「experimental, educational」の但し書きは消えず、githubの活動も、2024年10月のコミットを最後に動きがないです。なおこれには、ネット越しのリソースアクセスの直接的なサポートはないようです。これは捨てて、より戦略的な何かを用意してくるのでしょうか…？

「リモートMCPサーバ」が広まると本当に素晴らしいのですが、それはオフィシャルでしかサポートできないので（コミュニティが勝手に、とはいかないので）、上述のような、大いに政治的な話が関わってくると思います（みんなの技術で社会を豊かに企業政治なんてクソ喰らえな僕にとっては悲しい現実なのですが、それが現実です。。）

そのような状況に対するバックアップ・プランとして機能するのが、ロードマップにあった「MCPサーバー共有方法の改善」の項目です。つまり、オフィシャルなサポートがうまく広まらなかった場合、ローカルで動く（誰でも開発できる）MCPサーバの「標準パッケージング・フォーマット」を決めて、「利用可能な MCPサーバーを発見（ディスカバー）するための共通ディレクトリ（一覧）」を用意することで、「リモート MCPサーバー・ディスカバリー」と同等のことが実現できます（セキュリティ担保の課題はありますが）。でもそれでも、正式サポートは広まってほしいです！

また、AIシステム構築面に目を向けると、Microsoft や Google、Amazon、IBM 等が、AI エージェント構築プラットフォーム（マルチ・エージェント・システム）を製品化しています（特に Microsoft の「Copilot Studio」は 導入実績がかなりありそうです）。これらの大物の中で、果たして MCP をサポートしてくるところがあるのか…

いずれせよ、コミュニティでの盛り上がりが素晴らしいので、各社がどう出てくるのか。そして「リモートMCP接続」が正式に発表された時、果たして Anthropic はどこかとのパートナーシップの類を発表するのか？（たぶんどこかのメジャーなサービスプロバイダと PoC してるだろうと憶測）、目が離せません！


## おわりに

以上、僕が感じた MCP の魅力と可能性について、現時点での理解をベースにまとめてみました。
とっ散らかった文章に、最後までお付き合いいただき、どうもありがとうございました 🙇‍♂️
何か勘違いや分かりにくい部分があったら、ぜひコメントくださいませ 🙇‍♂️
もし何らかのご参考になることがあったのであれば、とってもうれしいです 😀
