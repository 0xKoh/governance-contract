# Governance Contract
## Overview
このコントラクトは提案と投票といった一般的なガバナンス機能を持ち、EIP712に準拠した署名で代理投票を行うことが可能です。
Foudryというツールチェーンを使用し定義しています。FoundryとEthereumの署名に関しての学習の為に作成しました。

## Deploy
`.env`を作成し、以下のように使用するJSON-RPCとデプロイを行うアカウントの秘密鍵を環境変数として設定してください。
```env
GOERLI_RPC_URL=
PRIVATE_KEY=
```
環境変数設定後に以下のコマンドを実行してください。
```bash
forge script script/Governance.s.sol:deployScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
```
デプロイ後は好きなようにコントラクトを叩いて実験してみてね！