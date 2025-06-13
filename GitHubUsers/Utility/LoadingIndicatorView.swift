//
//  LoadingIndicatorView.swift
//  GitHubUsers
//
//  Created by Bhalodiya, Keyur | ECMPD on 2025/06/13.
//

import SwiftUI

struct LoadingIndicatorView: View {
  public var body: some View {
    VStack(spacing: 14) {
      ProgressView()
        .controlSize(.large)
    }
    .padding(24)
    .background {
      VisualEffectView(effect: UIBlurEffect(style: .regular))
        .cornerRadius(18)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
  }
}

struct VisualEffectView: UIViewRepresentable {
  typealias UIViewType = UIVisualEffectView
  
  let effect: UIVisualEffect
  
  func makeUIView(context: Context) -> UIVisualEffectView {
    UIVisualEffectView(effect: effect)
  }
  
  func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
    uiView.effect = effect
  }
}

struct LoadingIndicatorModifier: ViewModifier {
  
  let isShowing: Bool
  
  func body(content: Content) -> some View {
    content.overlay {
      LoadingIndicatorView()
        .opacity(isShowing ? 1 : 0)
        .animation(.smooth, value: isShowing)
    }
  }
}

#Preview {
    LoadingIndicatorView()
}
