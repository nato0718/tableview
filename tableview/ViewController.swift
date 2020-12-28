import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inpHashTag: UITextField! // 入力フィールド
    @IBOutlet weak var tableView: UITableView! // テーブルビュー
    @IBOutlet weak var editSwitchButton: UIButton! // 編集状態
    
    // データ入力
    @IBAction func addHashTag(_ sender: Any) {
        arrayHashTag.append("\(inpHashTag.text!)")
        tableView.reloadData()
        //arrayHashTagKeyとして配列を書き込む
        userDefaults.set(arrayHashTag, forKey: "arrayHashTagKey")
        print("追加")
        print(arrayHashTag)
    }
    // 編集ボタン
    @IBAction func tspEdit(_ sender: Any) {
        if editSwitch == true {
            tableView.isEditing = true // 編集可能
            tableView.allowsSelectionDuringEditing = true //セルのタップ選択
            tableView.reloadData() // テーブルリロード
            editSwitch = false
            editSwitchButton.setTitle("編集終了", for: .normal)
            
        } else {
            tableView.isEditing = false // 編集終了
            tableView.allowsSelectionDuringEditing = false //セルのタップ選択
            tableView.reloadData() // テーブルリロード
            editSwitch = true
            editSwitchButton.setTitle("編集", for: .normal)
        }
    }
    // 変数・定数
    var userDefaults = UserDefaults.standard // userDefaultsの定義
    //var arrayHashTag = Array(repeating: "#サンプルタグ", count: 1) // 配列データ変数
    var arrayHashTag:[String?] = ["サンプルタグ1","サンプルタグ2","サンプルタグ3"]
    var editSwitch = true // 編集状態（true：編集可 false：編集終了）
    // セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayHashTag.count
    }
    // セル本体の設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) // セルを取得
        cell.textLabel!.text = arrayHashTag[indexPath.row] // セルに表示する値を設定
        return cell
    }
    // 編集中のみ削除できる様にする
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
    // 削除
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,  forRowAt indexPath: IndexPath) {
        arrayHashTag.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        //arrayHashTagKeyとして配列を書き込む
        print("削除")
        print(arrayHashTag)
        userDefaults.set(arrayHashTag, forKey: "arrayHashTagKey")
     }
    
    // 並び替え
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
            return true
    }
    // 並び替え後の制御
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let targetTitle:String = arrayHashTag[sourceIndexPath.row] {
            //元の位置のデータを配列から削除
            arrayHashTag.remove(at:sourceIndexPath.row)
            //移動先の位置にデータを配列に挿入
            arrayHashTag.insert(targetTitle, at: destinationIndexPath.row)
        }
        print("並び替え")
        print(arrayHashTag)
        //テーブルビューをリロードする。
        tableView.reloadData()
        //arrayHashTagKeyとして配列を書き込む
        userDefaults.set(arrayHashTag, forKey: "arrayHashTagKey")
    }
    // 完全に全ての読み込みが完了時に実行
    override func viewDidAppear(_ animated: Bool) {
    }
    // 画面から非表示になる直前の処理
    override func viewWillDisappear(_ animated: Bool) {
        //arrayHashTagKeyとして配列を書き込む
        userDefaults.set(arrayHashTag, forKey: "arrayHashTagKey")
        print(arrayHashTag)
    }
    // 起動時の処理
    override func viewDidLoad() {
        super.viewDidLoad()
        // userDefaultsに初期値を設定
        userDefaults.register(defaults: ["arrayHashTagKey" : arrayHashTag])
        //print(arrayHashTag)
        // userDefaultsに保存された値の取得
        let arrayData1:Array = userDefaults.array(forKey: "arrayHashTagKey")!
        // 配列の個数から1引いた数値（0スタート用）
        let count1 = arrayData1.count - 1
        //userDefaultsに保存された配列の数と配列変数の数を合わす(indexエラー回避)
        arrayHashTag = Array(repeating: "dummy", count: arrayData1.count)
        // userDefaultsに保存された配列の個数だけ配列変数にセット
        for i in  0...count1 {
            arrayHashTag[i] = arrayData1[i] as? String
        }
        
    }
}
