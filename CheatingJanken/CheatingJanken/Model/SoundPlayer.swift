//
//  SoundPlayer.swift
//  CheatingJanken
//
//  Created by トム・クルーズ on 2023/04/22.
//

import UIKit
import AVFoundation

class SoundPlayer: NSObject {
    // 音源データの読み込み
    let winSoundData = NSDataAsset(name: "winSound")!.data
    // 勝利音用プレーヤーの変数
    var winSoundPlayer: AVAudioPlayer!
    // 音源データの読み込み
    let loseSoundData = NSDataAsset(name: "loseSound")!.data
    // 勝利音用プレーヤーの変数
    var loseSoundPlayer: AVAudioPlayer!
    // 音源データの読み込み
    let buttonSoundData = NSDataAsset(name: "buttonSound")!.data
    // ボタンタップ音用プレーヤーの変数
    var buttonSoundPlayer: AVAudioPlayer!
    // 音源データの読み込み
    let jankenSoundData = NSDataAsset(name: "jankenSound")!.data
    // ジャンケン音用プレーヤーの変数
    var jankenSoundPlayer: AVAudioPlayer!

    func winSoundPlay() {
        do {
            // 勝利用のプレーヤーに音源データを指定
            winSoundPlayer = try AVAudioPlayer(data: winSoundData)
            // 勝利用の音源を再生
            if winSoundPlayer.isPlaying == false {
                winSoundPlayer.currentTime = 0.0
                winSoundPlayer.play()
            }
        } catch {
            print("勝利の音源がエラーです。")
        }
    }

    func loseSoundPlay() {
        do {
            // 敗北用のプレーヤーに音源データを指定
            loseSoundPlayer = try AVAudioPlayer(data: loseSoundData)
            // 敗北用の音源を再生
            if loseSoundPlayer.isPlaying == false {
                loseSoundPlayer.currentTime = 0.0
                loseSoundPlayer.play()
            }
        } catch {
            print("敗北の音源がエラーです。")
        }
    }

    func buttonSoundPlay() {
        do {
            // 敗北用のプレーヤーに音源データを指定
            buttonSoundPlayer = try AVAudioPlayer(data: buttonSoundData)
            // 敗北用の音源を再生
            if buttonSoundPlayer.isPlaying == false {
                buttonSoundPlayer.currentTime = 0.0
                buttonSoundPlayer.play()
            }
        } catch {
            print("ボタンタップの音源がエラーです。")
        }
    }

    func jankenSoundPlay() {
        do {
            // 敗北用のプレーヤーに音源データを指定
            jankenSoundPlayer = try AVAudioPlayer(data: jankenSoundData)
            // 敗北用の音源を再生
            if jankenSoundPlayer.isPlaying == false {
                jankenSoundPlayer.currentTime = 0.0
                jankenSoundPlayer.play()
            }
        } catch {
            print("ジャンケンの音源がエラーです。")
        }
    }
}
