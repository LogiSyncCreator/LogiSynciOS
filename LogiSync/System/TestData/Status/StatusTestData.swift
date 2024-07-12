//
//  StatusTestData.swift
//  LogiSync
//
//  Created by 広瀬友哉 on 2024/06/14.
//

import Foundation
import SwiftUI

struct StatusTestData {
    var StatusTagData: [StatusTagModelTest] = [
        StatusTagModelTest(label: "オンライン", symboleColor: Color(.green), symbole: "checkmark.circle.fill"),
        StatusTagModelTest(label: "オフライン", symboleColor: Color(.gray), symbole: "xmark.circle")
    ]
    var driverAccount: StatusAccountModelTest = StatusAccountModelTest(userId: "33675", pass: "password", name: "田中 照敏", companyCode: "CP000001", group: "株式会社架空運輸", selectedRole: "荷主", phone: "09014561234", profile: """
こんにちは！株式会社架空運輸のトラックドライバー、田中昭敏と申します。私は10年以上の運送業務の経験を持ち、常に安全運転と迅速な配送を心掛けています。

私の仕事に対するモットーは、「信頼と責任」です。お客様の大切な荷物を確実にお届けするために、常に最善を尽くしております。運転技術だけでなく、お客様とのコミュニケーションも大切にし、丁寧な対応を心掛けています。

休日には家族と過ごす時間を大切にしており、趣味のキャンプでリフレッシュしています。自然の中で過ごすことで、心も体もリフレッシュでき、また新たな気持ちで仕事に取り組むことができます。

これからも、お客様の信頼に応えられるよう努力してまいりますので、どうぞよろしくお願いいたします。
""")
    var ninushi: StatusAccountModelTest = StatusAccountModelTest(userId: "example@mail.com", pass: "password", name: "山田 秀雄", companyCode: "CP000001", group: "株式会社架空食品", selectedRole: "荷主", phone: "09056783456", profile: """
                                                                 
                                                                 山田 秀雄
                                                                 - 職業: 株式会社架空食品の社員（荷主）
                                                                 - 役職: 荷主（物流部門）
                                                                 - 業務内容: 物流部門における荷主として、製品の出荷や配送などの物流プロセスを管理・調整する。供給チェーン全体の効率化や顧客満足度の向上に注力。
                                                                 - スキル・経験:
                                                                   - 物流管理の専門知識を有し、出荷計画や配送スケジュールの策定、在庫管理などを行う。
                                                                   - チームリーダーシップに優れ、チームメンバーとの円滑なコミュニケーションや作業の効率化に貢献。
                                                                   - データ分析や改善活動にも積極的に取り組み、業務プロセスの最適化を図る。
                                                                 - 教育背景: 物流管理やビジネスに関する専門学校やセミナーで学び、実務経験を積んできた。
                                                                 - 趣味・関心事: ロジスティクス業界の最新トレンドやテクノロジーへの関心が高く、自己研鑽を重ねながら業務に取り組んでいる。
                                                                 - モットー: "効率と品質を両立させることで、より良い物流サービスを提供する。
                                                                 """)
}
