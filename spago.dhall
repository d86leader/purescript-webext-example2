{ name = "borderify"
, packages = ./packages.dhall
, sources = ["src/**/*.purs"]

, dependencies =
  [ "console"
  , "arrays"
  , "effect"
  , "partial"
  , "psci-support"
  , "promises"
  , "vanilla-web"
  , "web-extensions"
  ]
}
