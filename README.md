# Google Text-to-Speech Script

Google Text-to-Speech API を使い、MP3ファイルを作成するスクリプトです。

# 準備

Google Cloud の設定を行い、API を利用できるようにします。

## アカウント、APIキーの準備

[Google Cloud Text-to-Speech の使い方](https://blog.apar.jp/web/9893/) を、「Cloud Text-to-Speech API へのリクエスト実行」の手前まで進めます。
（`環境変数「GOOGLE_APPLICATION_CREDENTIALS」にもキーファイルのパスを追加しておきます。` は行う必要はありません）

## APIキーファイルの設定

ダウンロードした JSON ファイルを、このスクリプトと同じ場所に置きます。

`config.yaml` を編集し、ダウンロードした JSON ファイルの名前を記載します。

```yaml
---
credential_json: ./test-123456-123456789abc.json
```

# 使い方

テキストを指定してMP3を作成する方法と、CSVファイルを指定して複数のMP3を一度に作成する方法があります。

## テキストを入力する方法

`-t` の後にテキストを入力して実行します。

```console
$ ruby g-text-to-speech.rb -t "これはサンプルテキストです。"
```

実行すると `mp3` ディレクトリに、`result.mp3` というファイルが作成されます。

## CSV を入力する方法

以下のような、mp3ファイル名、テキストを並べた CSV ファイルを準備します。

```
1.mp3,テキスト１
2.mp3,テキスト２
```

`-f` の後に CSV ファイルを指定して実行します。

```console
$ ruby g-text-to-speech.rb -f input.csv
```

実行すると `mp3` ディレクトリ以下にファイルが生成されます。
