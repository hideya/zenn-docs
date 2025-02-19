

#### メモリ・コンテキスト関連：

- [**Anthropic: Constitutional AI 2.0**（2023年7月）](https://www.anthropic.com/research/constitutional-ai-2)
  - 高度な倫理的制約と意思決定能力
- [**OpenAI: Memory System**（2023年11月）](https://platform.openai.com/docs/assistants-api/memory)
  - 会話の長期記憶と文脈理解


#### コンテキストウィンドウ（LLM が一度に扱えるテキストの最大長）拡大：
- [**GPT-3**（2020年）](https://openai.com/blog/gpt-3-apps): 4,096トークン
- [**GPT-3.5**（2022年）](https://openai.com/blog/chatgpt): 4,096トークン
- [**GPT-4**（2023年初期）](https://openai.com/research/gpt-4): 8,192トークン
- [**Claude 2**（2023年7月）](https://www.anthropic.com/news/claude-2): 100k トークン
- [**GPT-4 Turbo**（2023年11月）](https://openai.com/blog/new-models-and-developer-products-announced-at-devday): 128k トークン（日本語・英語ともに標準的な書籍1冊程度）
- [**Claude 3 Opus**（2024年3月）](https://www.anthropic.com/news/claude-3-family): 200k トークン（英語で技術書1冊・標準的な書籍1.5冊程度、日本語の場合はそれよりやや少なくなる）
- [**Google Gemini 1.5 Pro**（2024年2月）](https://blog.google/technology/ai/google-gemini-next-generation-model-february-2024/): 1m トークン（5月版で 2mトークン）
- **最新情報：[LLM API Providers Leaderboard - Comparison of over 100 LLM endpoints](https://artificialanalysis.ai/leaderboards/providers)**


### LLM の処理速度の向上：
- GPT-3.5/4の初期状態（〜2023年前半）
  - 応答生成に数十秒、トークン生成速度1-2トークン/秒程度
- GPT-3.5 Turbo（2023年7月）
  - 応答時間が半分程度に短縮、コスト効率も改善
- Claude 2.1（2023年11月）
  - トークン生成速度が約5トークン/秒に向上
  - 長文処理の効率化を実現
- GPT-4 Turbo（2023年11月）
  - 応答速度が従来の2倍以上に改善
  - システムプロンプト処理の最適化
- Gemini 1.0 Ultra（2024年2月）
  - マルチモーダル処理の高速化
  - 並列処理による効率化
- Claude 3（2024年3月）
  - トークン生成速度が最大20トークン/秒に到達
  - マルチモーダル処理とテキスト処理の両立
- 主な改善要因：モデルアーキテクチャの最適化、ハードウェア利用効率の向上、そして並列処理の実現です。




#### 視覚・マルチモーダル関連：

- [**DALL-E**（OpenAI 2021年1月）](https://openai.com/blog/dall-e/)
  - テキストから画像を生成する最初の主要なモデル
  - 画像生成の可能性を示した画期的な成果
- [**OpenAI: GPT-4V**（2023年9月）](https://platform.openai.com/docs/guides/vision)
  - 画像理解と詳細な分析が可能
- [**Anthropic: Claude 3 Vision**（2024年3月）](https://www.anthropic.com/news/claude-3-family)
  - 高精度な画像理解と分析機能
- [**Google: Gemini Ultra Vision**（2024年初頭)](https://blog.google/technology/ai/google-gemini-ai/)
  - マルチモーダルな理解と生成能力
- **進化の方向性**
  - テキスト、画像、音声の統合的理解、単一モダリティから複数モダリティの統合へ
  - 単方向処理（生成のみ/理解のみ）から双方向処理へ
  - 静的コンテンツから動的コンテンツ（動画）の理解へ
  - 表面的な理解から深い文脈理解・推論へ

> **より詳細：**
> - DALL-E（OpenAI 2021年1月）
>   - テキストから画像を生成する最初の主要なモデル
>   - 画像生成の可能性を示した画期的な成果
> - Flamingo（DeepMind 2021年）
>   - 画像に関する質問応答が可能なモデル
>   - 少数のサンプルからの学習能力を実証
> - PaLM-E（Google 2022年）
>   - 言語とロボット制御を統合
>   - 実世界のタスクに対する理解を実証
> - GPT-4V（OpenAI 2023年9月）
>   - 高度な画像理解と分析
>   - 画像に基づく詳細な説明や推論が可能
> - Claude 2.1（Anthropic 2023年11月）
>   - 基本的な画像理解機能
>   - テキストと画像の統合分析
> - Gemini 1.0（Google 2023年12月）
>   - ネイティブなマルチモーダル設計
>   - テキスト、画像、音声、コードの統合処理
> - Claude 3（Anthropic 2024年3月）
>   - 高精度な画像分析
>   - 複雑な視覚的推論能力
> - Gemini 1.5（Google 2024年2月）
>   - 長時間の動画理解
>   - より深い視覚的コンテキスト理解

#### ツール利用・操作関連：

- [**OpenAI: Function Calling**（2023年6月）](https://openai.com/blog/function-calling-and-other-api-updates)
  - APIを通じた外部ツール呼び出し機能
- [**Anthropic: Tool Use**（2024年3月）](https://www.anthropic.com/news/claude-3-tool-use)
  - Pythonコード実行、ファイル操作など

> **より詳細：**
> - **2022年：**
>   - 基本的なツール呼び出し
>   - 単一のAPI呼び出し
>   - 事前定義された単純な機能の実行
>   - 限定的なエラーハンドリング
> - **2023年前半：**
>   - Function Calling（OpenAI、2023年6月）
>   - 構造化されたツール呼び出し
>   - JSON ベースのパラメータ渡し
>   - 基本的な入力検証
> - **2023年後半：**
>   - ツールチェーンの実行（複数ツールの連続的な使用）
>   - 中間結果の解釈と次のアクションの決定
>   - より洗練されたエラー処理
> - **2024年：**
>   - 高度なツール統合
>   - 並列ツール実行
>   - コンテキストを考慮したツール選択
>   - 安全性チェックの強化
>   - 実行結果の検証と修正
> - **進化の方向性**：
>   1. 制御の高度化：
>      - アクセス権限の細かな制御
>      - 実行前の安全性チェック
>      - 実行結果の妥当性検証
>   2. 連携の高度化：
>      - 複数ツールの組み合わせ最適化
>      - ツール間のデータ受け渡しの効率化
>      - 実行順序の動的な決定
>   3. エラー処理の高度化：
>      - より賢いエラーリカバリー
>      - 代替手段の自動選択
>      - ユーザーへの適切なフィードバック
>   4. セキュリティの強化：
>      - 実行前の意図確認
>      - アクセス範囲の明確な制限
>      - 監査ログの詳細化


## 処理速度の進

2023年前半まで：

GPT-3.5/GPT-4の初期モデル

応答生成に数十秒程度必要
トークン生成速度：約1-2トークン/秒
バッチ処理に最適化



2023年後半：

GPT-4 Turbo（2023年11月）

応答速度が2倍以上に改善
コスト効率の向上
https://openai.com/blog/turbo-update


Claude 2.1（2023年11月）

高速なトークン生成（約5トークン/秒）
長文処理の効率化
https://www.anthropic.com/news/claude-2-1



2024年：

Gemini 1.0 Ultra（2024年2月）

マルチモーダル処理の高速化
並列処理の最適化


Claude 3（2024年3月）

最大20トークン/秒の生成速度
マルチモーダル処理の効率化
https://www.anthropic.com/news/claude-3-family



主な進化のポイント：

トークン生成速度の向上

より自然な会話のような応答速度へ
リアルタイム処理の実現


処理の効率化

モデルアーキテクチャの最適化
ハードウェア活用の効率化
バッチ処理から逐次処理への移行


マルチタスク処理

複数モダリティの同時処理
並列処理の実現



Microsoft Autogen (2023年9月発表)

マルチエージェントの会話と協調を実現するフレームワーク
エージェント間の対話を通じた問題解決
カスタマイズ可能な会話フロー
https://github.com/microsoft/autogen


Microsoft AutoGen
詳細な情報：

初期公開：2023年9月
最初の発表ブログ：https://www.microsoft.com/en-us/research/blog/autogen-enabling-next-generation-large-language-model-applications/
GitHub リポジトリ：https://github.com/microsoft/autogen

その後の主な展開：

2024年3月：v0.4がリリース（アーキテクチャの大幅な改善）
AutoGen Studioの導入（ローコードインターフェース）
継続的な機能拡張とコミュニティの成長


#### AI アシスタント（単体 AI エージェント）構築フレームワーク

- [**Googl: Project Astra**（2024年5月）](https://ai-market.jp/services/what-project-astra/)
  - Gemini モデルベースの汎用 AI アシスタントを目指すプロジェクト
  - 視覚的入力（スマートグラスやモバイルカメラ）を通じて世界を理解し対話可能
  - Google 検索、マップ、レンズなどのサービスと統合して日常生活をサポート

- [**Amazon Q**（2023年11月）](https://aws.amazon.com/q/)
  - エンタープライズ向けの AI アシスタントで、AWS 内のサービスやリソースと直接連携可能
  - 企業の内部データやツールに接続し、セキュリティを保ちながら業務特化型の支援を提供
  - マルチモーダル対応で、コード生成からインフラ管理まで幅広いタスクに対応可能

- [**OpenAI: Assistants API**（2023年11月）](https://platform.openai.com/docs/assistants/overview)
  - アプリ内への AIアシスタントの組込み・カスタマイズを可能にする API
  - コード実行、ファイル操作、外部ツール連携などの機能をモジュール化して提供
  - 会話履歴の管理やスレッド機能により、複雑な対話セッションの維持が可能


