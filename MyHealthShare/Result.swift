//
//  Result.swift
//  BwFramework
//
//  Created by Katsuhiko Terada on 2017/08/03.
//  Copyright (c) 2017 Katsuhiko Terada. All rights reserved.
//

import Foundation

// ------------------------------------------------------------------
// MARK: - 結果構造
// ------------------------------------------------------------------
/// 結果通知用定義
///
/// - success       成功の場合　オブジェクトを返す
/// - failure       失敗の場合  Error型を返す
public enum Result<T, E:Error>
{
    case success(T)     // .successの場合はT型
    case failure(E)     // .failureの場合はError型
}

// ------------------------------------------------------------------
// MARK: - 標準結果
// ------------------------------------------------------------------

public enum StdResult: Int
{
    case ok
    case cancel
}

// ------------------------------------------------------------------
// MARK: - エラー
// ------------------------------------------------------------------

// エラーを返さない場合はこれを使用できる
public enum StdError: Error
{
    case unknown
}

// localizedDescriptionの定義（変更）
extension StdError: LocalizedError
{
    public var errorDescription: String?
    {
        switch self
        {
        case .unknown:
            return "原因不明のエラーです"
        }
    }
}

// descriptionの定義（追加）
extension StdError: CustomStringConvertible
{
    public var description: String
    {
        return localizedDescription
    }
}
