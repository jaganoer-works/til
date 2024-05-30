## Serverless Frameworkでのcorsの設定方法
### デフォルトのCORS設定
以下のように指定するだけでデフォルトの設定が有効になる。

```yaml
provider:
  httpApi:
    cors: true
```

### カスタムCORS設定

カスタマイズしたい場合は以下のようにオプションを指定できる。

```yaml
provider:
  httpApi:
    cors:
      allowedOrigins:
        - https://example.com
      allowedHeaders:
        - Content-Type
      allowedMethods:
        - GET
        - POST
      allowCredentials: true
```

- `allowedOrigins`: 許可するオリジンのリスト
- `allowedHeaders`: 許可するHTTPヘッダーのリスト 
- `allowedMethods`: 許可するHTTPメソッドのリスト
- `allowCredentials`: 認証情報を許可するかどうか

### Lambda関数側の設定

API Gateway側でCORSを設定しただけでは不十分で、Lambda関数側でもレスポンスヘッダーに`Access-Control-Allow-Origin`を設定する必要がある。

Lambda関数のレスポンスにこのヘッダーを追加することで、ブラウザ側でCORSを有効にすることができる。

### 注意点

- REST APIの場合とHTTP APIの場合で設定方法が異なるため注意が必要。
- CORSの設定を行わないと、クロスオリジンリクエストが失敗する。
- バイナリデータを返す場合は、さらに設定が必要になる可能性がある。

Serverless Frameworkを使えば、簡単にAPI GatewayのCORSを設定できますが、Lambda関数側の設定も合わせて行う必要があり。

## 参考
https://mo-gu-mo-gu.com/serverless-framework-apigateway-cors-basic/
https://qiita.com/tokino/items/c768687d0268479f69dc
https://www.mof-mof.co.jp/tech-blog/serverless-framework-08
https://blog.daisukekonishi.com/post/serverless-cors
https://blog.serverworks.co.jp/tech/2019/05/14/post-70323/