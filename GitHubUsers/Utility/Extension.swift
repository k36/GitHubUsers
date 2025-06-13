//
//  Extension.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import SwiftUI

public extension View {
  func hudOverlay(_ isShowing: Bool) -> some View {
    modifier(
      LoadingIndicatorModifier(isShowing: isShowing)
    )
  }
}
