# Google Text-to-Speech Script

## 準備

### アカウント、APIキーの準備

[Google Cloud Text-to-Speech の使い方](https://blog.apar.jp/web/9893/) を、「Cloud Text-to-Speech API へのリクエスト実行」の手前まで進めます。
（`環境変数「GOOGLE_APPLICATION_CREDENTIALS」にもキーファイルのパスを追加しておきます。` は行う必要はありません）

## APIキーファイルの設定

ダウンロードした JSON ファイルを、このスクリプトと同じ場所に置きます。

`config.yaml` を編集し、ダウンロードした JSON ファイルの名前を記載します。

```yaml
---
credential_json: ./robust-doodad-276112-d09da8668193.json
```

## 使い方

### 入力ファイルフォーマット

以下のような、mp3ファイル名、テキストを並べた CSV ファイルです。

```
1.mp3,テキスト１
2.mp3,テキスト２
```

### 実行

CSV ファイルを指定して実行します。

```
$ ruby g-text-to-speech.rb input.csv 
```

実行すると `mp3` ディレクトリ以下にファイルが生成されます。

