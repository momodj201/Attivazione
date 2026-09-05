import SwiftUI

struct DBMLogoView: View {
    var size: LogoSize = .medium
    var showTagline: Bool = true
    
    enum LogoSize {
        case small, medium, large, extraLarge
        
        var fontSize: CGFloat {
            switch self {
            case .small: return 18
            case .medium: return 28
            case .large: return 42
            case .extraLarge: return 56
            }
        }
        
        var iconSize: CGFloat {
            switch self {
            case .small: return 24
            case .medium: return 40
            case .large: return 60
            case .extraLarge: return 80
            }
        }
        
        var spacing: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 8
            case .large: return 12
            case .extraLarge: return 16
            }
        }
    }
    
    var body: some View {
        VStack(spacing: size.spacing) {
            HStack(spacing: size.spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: size.iconSize / 5)
                        .fill(
                            LinearGradient(
                                colors: [Color.blue, Color.blue.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: size.iconSize, height: size.iconSize)
                        .shadow(color: .blue.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: "desktopcomputer")
                        .font(.system(size: size.iconSize * 0.5, weight: .medium))
                        .foregroundColor(.white)
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("DBM")
                        .font(.system(size: size.fontSize, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                    
                    Text("informatica")
                        .font(.system(size: size.fontSize * 0.5, weight: .medium, design: .rounded))
                        .foregroundColor(.blue)
                }
            }
            
            if showTagline && size != .small {
                Text("Soluzioni digitali per il tuo business")
                    .font(.system(size: size.fontSize * 0.35, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct DBMLogoCompact: View {
    var body: some View {
        HStack(spacing: 6) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.blue.opacity(0.7)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 28, height: 28)
                
                Image(systemName: "desktopcomputer")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
            }
            
            Text("DBM")
                .font(.system(size: 16, weight: .bold, design: .rounded))
            + Text(" informatica")
                .font(.system(size: 16, weight: .medium, design: .rounded))
                .foregroundColor(.blue)
        }
    }
}

struct DBMLogoBadge: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.seal.fill")
                .font(.caption2)
                .foregroundColor(.blue)
            
            Text("by DBM informatica")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.1))
        .cornerRadius(12)
    }
}

struct DBMLogoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 40) {
            DBMLogoView(size: .extraLarge)
            DBMLogoView(size: .large)
            DBMLogoView(size: .medium)
            DBMLogoView(size: .small, showTagline: false)
            
            Divider()
            
            DBMLogoCompact()
            DBMLogoBadge()
        }
        .padding()
    }
}
