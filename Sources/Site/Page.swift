import Foundation

import Slipstream

struct Page<Content: View>: View {
  init(
    path: String,
    title: String? = nil,
    description: String? = nil,
    @ViewBuilder content: @escaping () -> Content
  ) {
    self.path = path
    self.title = title
    self.description = description
    self.content = content
  }

  private let path: String
  private let title: String?
  private let description: String?
  @ViewBuilder private let content: () -> Content

  var body: some View {
    HTML {
      Head {
        Charset(.utf8)
        if let title {
          Title("\(title) — featherless software design")
        } else {
          Title("featherless software design")
        }
        Viewport.mobileFriendly
        if let description {
          Meta(.description, content: description)
        }
        Meta(.generator, content: "Slipstream")
        Meta(.author, content: "Jeff Verkoeyen")
        Preload(URL(string: "/gfx/feather.svg"), as: .image)
        Preload(URL(string: "/gfx/feather-dark.svg"), as: .image)
        Stylesheet(URL(string: "/css/main.css"))

        Script("""
!function(t,e){var o,n,p,r;e.__SV||(window.posthog=e,e._i=[],e.init=function(i,s,a){function g(t,e){var o=e.split(".");2==o.length&&(t=t[o[0]],e=o[1]),t[e]=function(){t.push([e].concat(Array.prototype.slice.call(arguments,0)))}}(p=t.createElement("script")).type="text/javascript",p.async=!0,p.src=s.api_host.replace(".i.posthog.com","-assets.i.posthog.com")+"/static/array.js",(r=t.getElementsByTagName("script")[0]).parentNode.insertBefore(p,r);var u=e;for(void 0!==a?u=e[a]=[]:a="posthog",u.people=u.people||[],u.toString=function(t){var e="posthog";return"posthog"!==a&&(e+="."+a),t||(e+=" (stub)"),e},u.people.toString=function(){return u.toString(1)+".people (stub)"},o="capture identify alias people.set people.set_once set_config register register_once unregister opt_out_capturing has_opted_out_capturing opt_in_capturing reset isFeatureEnabled onFeatureFlags getFeatureFlag getFeatureFlagPayload reloadFeatureFlags group updateEarlyAccessFeatureEnrollment getEarlyAccessFeatures getActiveMatchingSurveys getSurveys getNextSurveyStep onSessionId setPersonProperties".split(" "),n=0;n<o.length;n++)g(u,o[n]);e._i.push([i,s,a])},e.__SV=1)}(document,window.posthog||[]);
posthog.init('phc_6wAoRtZ091R06eOZSPGv1yW2CSKR3MPnD1PBOXu0U66',{api_host:'https://eu.i.posthog.com', person_profiles: 'identified_only'
    })
""")
      }
      Body {
        Div {
          if path != "/" {
            NavigationBar()
          }
          content()
        }
        .frame(minHeight: .screen)

        if path != "/" {
          Footer {
            Container {
              VStack(alignment: .center, spacing: 16) {
                Link(URL(string: "https://github.com/jverkoey/slipstream")) {
                  Image(URL(string: "/gfx/built-with-slipstream.svg"))
                    .accessibilityLabel("Built with Slipstream")
                }
                .modifier(ClassModifier(add: "cursor-pointer"))
                VStack(alignment: .end) {
                  Text("Copyright © 2002-\(Calendar.current.component(.year, from: Date())) Jeff Verkoeyen")
                    .textColor(.text, darkness: 600)
                    .textColor(.text, darkness: 300, condition: .dark)
                }
              }
              .justifyContent(.between)
            }
            .padding(.vertical, 32)
          }
          .border(.palette(.border, darkness: 300), width: 1, edges: .top)
          .border(.palette(.border, darkness: 700), width: 1, edges: .top, condition: .dark)
          .background(.zinc, darkness: 200)
          .background(.zinc, darkness: 800, condition: .dark)
        }
      }
      .background(.gray, darkness: 100)
      .background(.zinc, darkness: 950, condition: .dark)
      .antialiased()
    }
    .language("en")
    .environment(\.path, path)
  }
}

private struct PathEnvironmentKey: EnvironmentKey {
  static let defaultValue: String = "/"
}

extension EnvironmentValues {
  var path: String {
    get { self[PathEnvironmentKey.self] }
    set { self[PathEnvironmentKey.self] = newValue }
  }
}
