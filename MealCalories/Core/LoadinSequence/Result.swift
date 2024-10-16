//
//  Result.swift
//  MealCalories
//
//  Created by Kuandik Chingiz on 09.10.24.
//

public enum Result<Element> {

  case success(Element)
  case error(Error)

  public var element: Element? {
    if case let .success(element) = self {
      return element
    }
    return nil
  }

  public var error: Error? {
    if case let .error(error) = self {
      return error
    }
    return nil
  }
}
