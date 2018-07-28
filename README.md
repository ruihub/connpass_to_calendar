# ConnpassToCalendar

ConnpassToCalendarは[connpass API](https://connpass.com/about/api/) で取得したイベントを[Googleカレンダー](https://calendar.google.com/)に登録することができるCLIアプリケーションです。

## インストール 

gemでインストール：

    $ gem install connpass_to_calendar

## 初期設定

### GoogleCalendarAPIの登録

このアプリを使うにはGoogleCalendarのAPI登録が必要です。
Gmailアカウント(Googleアカウント)は取得済みの前提とします。
1.[GoogleAPIsのコンソール](https://console.developers.google.com/apis/dashboard)からプロジェクトを作成します。

2.左のライブラリタブでGoogle Calendar APIを検索し、有効にします。

3.認証情報タブのOAuth同意画面でOAuth認証情報の登録をします。

4.認証情報タブの認証情報で「認証情報の作成」、「OAuthクライアントIDの作成」、「その他」と進みクライアントIDを作成します。

5.作成したクライアントIDのjsonファイルをダウンロードします。

### 設定

`config`コマンドを使用して以下を設定します。

	$ connpass_to_calendar config application_name <作成したプロジェクト名>

	$ connpass_to_calendar config credentials_path <ダウンロードしたjsonファイルのフルパス> # Example => /Users/user/.connpass_to_calendar/oauth/client_secrets.json

	$ connpass_to_calendar config token_path <tokenファイルのフルパス> # Example => /Users/user/.connpass_to_calendar/oauth/tokens.yaml

	$ connpass_to_calendar config user_id <APIを登録したGmailアカウント>

設定した内容は`config --list`で確認できます。

## 使い方

`put`コマンドを使用してカレンダーにイベントを登録します。

	$ connpass_to_calendar put

[connpass API](https://connpass.com/about/api/)のパラメータを使用する場合は以下のようにオプションをつけます。
オプションはリファレンスに乗っている`format`以外使用可能です。

	$ connpass_to_calendar put --keyword "ruby"

初回のみ以下のメッセージがでます。
メッセージに従いURLへアクセスしカレンダーへのアクセスを許可し、表示されたコードを貼り付けてください。

	Open https://accounts.google.com/o/oauth2/auth?<params> in your browser and enter the resulting code:

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tech_rui/connpass_to_calendar.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
