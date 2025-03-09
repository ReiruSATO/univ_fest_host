# univ_fest_host
大学の学園祭用モバイルオーダーアプリ(店舗用)
## 主要ファイルの簡単な説明
- [ICCD_7.pdf](ICCD_7.pdf)  
    学内発表で使用したプレゼンスライド

- [main.dart](univ_fest_host/lib/main.dart)  
    アプリの基礎設定と構成。画面切り替えはTabControllerで切り替え。
- [add_order.dart](univ_fest_host/lib/screens/add_order.dart)  
    モバイルオーダー未使用の客の注文をキューに追加。
- [order_list.dart](univ_fest_host/lib/screens/order_list.dart)  
    Firebaseにて管理している注文のキューを取得して表示。
- [regist_menu.dart](univ_fest_host/lib/screens/regist_menu.dart)  
    参考商品画像、品名、値段を指定してその店舗のメニュー一覧に登録。
- [scan.dart](univ_fest_host/lib/screens/scan.dart),[scandata.dart](univ_fest_host/lib/screens/scandata.dart),[scan_data.dart](univ_fest_host/lib/screens/widgets/scan_data.dart)  
    客側のアプリで生成したQRコードを読み取り、オーダーIDを取得後、金額を表示。(決済機能は非搭載)
- [shop_info_screen.dart](univ_fest_host/lib/screens/shop_info_screen.dart)  
    店舗の識別情報として大学用Googleアカウントを用い、現在使用中のアカウントを表示。