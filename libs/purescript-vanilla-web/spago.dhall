{ name = "vanilla-web"
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]

, dependencies =
  [ "prelude"
  , "effect"
  , "functions"
  , "maybe"
  , "partial"
  ]
}
