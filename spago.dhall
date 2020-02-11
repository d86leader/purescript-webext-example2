{ name = "borderify"
, packages = ./packages.dhall
, sources = ["src/**/*.purs"]

, dependencies =
  [ "console"
  , "effect"
  , "psci-support"
  , "promises"
  ]
}
