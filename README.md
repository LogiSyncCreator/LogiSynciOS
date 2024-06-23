# Hello! LogiSync.

ルール
現状Xcodeでのチーム開発ができないため、info等の設定情報がバラバラになってしまう可能性があるので、
設定変更あれば以下に書く

ルール変更内容
例：・LogiSync/Target/General/App Category をnone->Book

2024/06/13
対象機種の変更
LogiSync/Target/General destinationをiphoneとipadに制限

2024/6/14
LogiSync/Tartgets/Signing & Capabilities 
Background Modesを追加
Location update
Background feach
Remote notification にチェック
LogiSync/Tartgets/Info/Custom iOS Target Propaties
Privacy - Location When In Use Usage Description を追加
Privacy - Location Always and When In Use Usage Description を追加
現在位置情報を共有、表示使用するために使用します をValueにセット

アセットにカラーを追加して、ステータスに割り当てる


6/16日にApple Devを契約する予定なので、それまでチーム開発は不便かも
Bundle identifierはしばらく各自のものになるかも。

