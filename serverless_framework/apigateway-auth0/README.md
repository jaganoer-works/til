## Auth0でのAPI作成とAPI Gatewayへの認可機能追加

### Auth0でAPIを作成する手順
1. **Auth0ダッシュボードにログイン**
2. **APIの作成**
   - 左側のナビゲーションメニューから「APIs」を選択し、「+ Create API」ボタンをクリック。
   - 必要な情報を入力し、APIを作成:
     - **Name**: APIの名前（例: `MyAPI`）。
     - **Identifier**: APIの識別子（例: `https://myapi.com`）。
     - **Signing Algorithm**: `RS256`を選択。
   - 「Create」ボタンをクリックしてAPIを作成。
3. **API Permissionsの設定**
   - 作成したAPIの詳細ページに移動し、「Permissions」タブで必要なパーミッションを追加:
     - **Permission Name**: パーミッションの名前（例: `read:messages`）。
     - **Description**: パーミッションの説明（例: `Read access to messages`）。
     - **Add** ボタンをクリックしてパーミッションを追加。
     - **例**:
       - `read:messages`: メッセージの読み取り権限
       - `write:messages`: メッセージの書き込み権限
       - `delete:messages`: メッセージの削除権限
4. **複数APIの作成**
   - 同様の手順で、必要な数だけAPIを作成（例: `MySecondAPI`、識別子: `https://mysecondapi.com`）。
5. **クライアントの作成**
   - 左メニューの「Applications」から「+ Create Application」をクリック。
   - アプリケーションの設定を行い作成:
     - **Name**: アプリケーションの名前（例: `MyClient`）。
     - **Type**: `Machine to Machine Applications`を選択。
6. **APIへのアクセスを許可**
   - 作成したアプリケーションの詳細ページの「APIs」タブで、先ほど作成した各APIを選択。
   - 必要なスコープを選択し、「Add Permissions」ボタンをクリック。
     - **例**:
       - `read:messages`
       - `write:messages`
7. **クライアントIDとクライアントシークレットの確認**
   - アプリケーションの「Settings」タブでクライアントIDとクライアントシークレットを確認。

### アクセストークンの取得方法
以下のコマンドを使用してアクセストークンを取得。各APIごとにアクセストークンを取得する。

```bash
curl --request POST \
  --url 'https://<YOUR_DOMAIN>/oauth/token' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=<YOUR_CLIENT_ID> \
  --data client_secret=<YOUR_CLIENT_SECRET> \
  --data audience=https://myapi.com
```

```bash
curl --request POST \
  --url 'https://<YOUR_DOMAIN>/oauth/token' \
  --header 'content-type: application/x-www-form-urlencoded' \
  --data grant_type=client_credentials \
  --data client_id=<YOUR_CLIENT_ID> \
  --data client_secret=<YOUR_CLIENT_SECRET> \
  --data audience=https://mysecondapi.com
```

- `<YOUR_DOMAIN>`: Auth0のドメイン（例: `dev-hzy2ijocvhfmctf6.jp.auth0.com`）
- `<YOUR_CLIENT_ID>`: 作成したクライアントのID
- `<YOUR_CLIENT_SECRET>`: 作成したクライアントのシークレット
- `audience`: 作成した各APIの識別子（例: `https://myapi.com`, `https://mysecondapi.com`）

### トークンを使用したAPIリクエスト
取得したアクセストークンを使用してAPIにアクセス。

```bash
curl -X GET -H 'Authorization: Bearer <ACCESS_TOKEN>' 'https://<YOUR_API_ENDPOINT>'
```

- `<ACCESS_TOKEN>`: 取得したアクセストークン
- `<YOUR_API_ENDPOINT>`: APIエンドポイント（例: `https://ltckk51jeg.execute-api.ap-northeast-1.amazonaws.com/hello`）


```json
{
  "message": "Go Serverless v3.0! Your function executed successfully!"
}%
```
              

### トークンなしでAPIリクエストを送った場合
トークンなしでAPIリクエストを送ると、認可エラーが発生する。

```bash
curl -X GET 'https://<YOUR_API_ENDPOINT>'
```

- このリクエストは`401 Unauthorized`エラーを返す。

```json
{
  "message": "Unauthorized"
}
```

### Serverless Frameworkの設定
```yaml
org: jaganoerworks
app: aws-node-http-api-project
service: aws-node-http-api-project
frameworkVersion: "3"

useDotenv: true

provider:
  name: aws
  runtime: nodejs18.x
  region: ap-northeast-1
  httpApi:
    authorizers:
      auth0Authorizer:
        identitySource: $request.header.Authorization
        issuerUrl:  ${env:AUTH0_DOMAIN}
        audience:
          - ${env:AUTH0_AUDIENCE}

functions:
  api:
    handler: index.handler
    events:
      - httpApi:
          path: /hello
          method: get
          authorizer:
            name: auth0Authorizer
```

### .envの設定
```
AUTH0_DOMAIN=https://<TENANT NAME>.jp.auth0.com/
AUTH0_AUDIENCE=<API AUDIENCE>
```