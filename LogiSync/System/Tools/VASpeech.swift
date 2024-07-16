//
//  VASpeech.swift
//  SampleChat
//
//  Created by 中島瑠斗 on 2024/07/09.
//

import Foundation
import Speech


/// 音声取得＋音声認識クラス
@MainActor
public class VASpeech :ObservableObject {
    //オーディオクラス
    //音声認識エンジンとは->人間の言葉をコンピュータが理解できるようにする技術
    private let mAudio = AVAudioEngine()
    //音声認識クラス
    private let mRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ja_JP"))!
    //音声認識要求
    private var mRecognitionRequest : SFSpeechAudioBufferRecognitionRequest?
    //音声認識状況管理クラス
    private var mRecognitionTalk : SFSpeechRecognitionTask?
    
    
    //権限リクエスト状態
    @Published public var isRequestAuthorization = false
    //終了フラグ （true = 終了）
    @Published public var isFinal = true
    
    @Published public var finalRecognizedText: String = ""
    @Published var isLoading: Bool = false
    
    @Published var isRecode = true
    
    //音声認識した文字列を格納
    private var recognizedText = [String]()
    
    init(){
        Task{
            //音声認識　： 権限を求めるダイアログを表示する
            SFSpeechRecognizer.requestAuthorization { status in
                DispatchQueue.main.async {
                    switch status {
                    case .notDetermined:
                        print("許可されていない")
                        self.isRequestAuthorization = false
                    case .denied:
                        print("拒否された")
                        self.isRequestAuthorization = false
                    case .restricted:
                        print("端末が音声認識に対応していない")
                        self.isRequestAuthorization = false
                    case .authorized:
                        print("許可された")
                        self.isRequestAuthorization = true
                    @unknown default:
                        print("その他")
                        self.isRequestAuthorization = false
                    }
                }
                
            }
        }
    }
    
    //音声認識準備処理
    public func prepareRecording(){
        //Audio Session取得
        let audiosession = AVAudioSession.sharedInstance()
        
        do {
            
            // .record = オーディオ録音用
            // mode: .measurement = オーディオ入出力の測定での利用
            // options: .duckOthers = オーディオ再生時に、バックグラウンドオーディオの音量を下げるオプション。
            try audiosession.setCategory(.record , mode: .measurement , options: .duckOthers )
            
            // options: .notifyOthersOnDeactivation = アプリのオーディオセッションを無効化したことを、システムが他のアプリに通知
            //オーディオセッション->複数のアプリが同時に音声を再生するときに干渉しないようにするため
            try audiosession.setActive(true, options: .notifyOthersOnDeactivation)
            
            // Audio InputNode 生成
            let inputNode = mAudio.inputNode
            
            
            //音声認識リクエスト生成
            //バッファを送信し、音声認識エンジンから認識結果を取得する
            mRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            guard let mRecognitionRequest = mRecognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
            
            //中間結果取得　有効
            //文章が出来上がる前から文字起こしする
            mRecognitionRequest.shouldReportPartialResults = false
            //ローカル認識　有効
            //デバイス上で音声認識を行うこと
            mRecognitionRequest.requiresOnDeviceRecognition = self.isRecode
            
            //.重複開始を防ぐため初期化処理
            //既に開始している場合、一度キャンセルする。
            self.mRecognitionTalk?.cancel()
            self.mRecognitionTalk = nil
            
            //音声認識イベント処理
            self.mRecognitionTalk = mRecognizer.recognitionTask(with: mRecognitionRequest) { result, error in
                Task {
                    // 音声認識開始の結果を確認する
                    if let result = result {
                        self.recognizedText.append(result.bestTranscription.formattedString)
                        
                        // 認識結果をプリント
                        //print("RecognizedText: \(result.bestTranscription.formattedString)")
                    }
                    
                    // エラー　または　終了フラグが設定されている場合は処理を終了する
                    if error != nil {
                        // オーディオ取得を停止する
                        self.mAudio.stop()
                        // inputNodeを空にする
                        inputNode.removeTap(onBus: 0)
                        // 音声認識を終了する
                        self.mRecognitionRequest = nil
                        self.mRecognitionTalk?.cancel()
                        self.mRecognitionTalk = nil
                        
                        // 音声取得を停止する
                        let _ = try await self.stopRecording()
                    }
                }
            }
            
            //Input Nodeから音声データを取得する。
            //マイクから入力された音声を取得し、音声認識エンジンに送る処理
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                // 音声を取得したら
                self.mRecognitionRequest?.append(buffer) // 認識リクエストに取得した音声を加える
            }
            
        } catch let error {
            print("Start Recording Error!!")
            print(error)
        }
    }
    
    
    /// 録音開始
    public func startRecording(){
        do{
            //終了フラグにfalseを設定する
            self.isFinal = false
            //音声の取得を開始
            self.mAudio.prepare()
            try self.mAudio.start()
        }
        catch let error
        {
            print(error)
        }
    }
    
    
    /// 録音停止
    public func stopRecording() async throws -> String{
        
        self.isRecode = false
        
        //ボタンの切り替えのため
        self.isFinal = true
        
        self.isLoading = true
        
        return await withCheckedContinuation { continuation in
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5){
                
                if !self.recognizedText.isEmpty {
                    
                    self.finalRecognizedText = self.recognizedText.joined()
                    self.recognizedText.removeAll() // 出力後、配列を空にする
                    //print(self.finalRecognizedText)
                    
                    continuation.resume(returning: self.finalRecognizedText)
                    self.isLoading = false
                    
                } else {
                    continuation.resume(returning: "")
                    self.isLoading = false
                }
                //音声の取得を終了
                self.mAudio.stop()
            }
            
        }
        
    }
    
}


