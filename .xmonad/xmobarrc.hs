Config
  { position         = TopW L 100
  , font             = "liberation mono" --"xft:Serif-9:bold"
  , bgColor          = "#3d3d3d"
  , fgColor          = "#dcdccc"
  , lowerOnStart     = False
  , overrideRedirect = False
  , allDesktops      = True
  , persistent       = True
  -- , borderColor      = "#dddddd"
  -- , borderWidth      = 2
  -- , border           = BottomB
  , commands         =     -- Testing things out for profiler
    -- why so slow
    [ Run Weather     "ZBAA"
                       -- [ ("clear"                  , "\x2600")
                       -- , ("sunny"                  , "\x263C")
                       -- , ("mostly clear"           , "\x1F324")
                       -- , ("mostly sunny"           , "\x1F324")
                       -- , ("partly sunny"           , "\x26C5")
                       -- , ("fair"                   , "\x2609")
                       -- , ("cloudy"                 , "\x2601")
                       -- , ("overcast"               , "\x2601")
                       -- , ("partly cloudy"          , "\x26C5")
                       -- , ("mostly cloudy"          , "\x1F325")
                       -- , ("considerable cloudiness", "\x2601")
                       -- , ("rain"                   , "\x1F327")
                       -- , ("light rain"             , "\x1F327")
                       -- , ("light rain showers"     , "\x1F327")
                       -- , ("thunder"                , "\x1F329")
                       -- , ("snow"                   , "\x1F328")
                       -- ]

                       [ "-t"
                       , "<station>: <skyCondition> <tempC>\x00B0"
                       , "-L", "10"
                       , "-H", "25"
                       , "--normal", "#ffcc66"
                       , "--low", "#99cc99"
                       , "--high", "#f2777a"
                       ] 10

    , Run Memory       [ "--template", "Mem: <usedratio>%"
                       , "--Low"     , "25"
                       , "--High"    , "75"
                       , "--low"     , "#99cc99"
                       , "--normal"  , "#ffcc66"
                       , "--high"    , "#f2777a"
                       ] 10
    , Run DynNetwork   ["-t", "Net: <rx>kb/<tx>kb"] 10
    , Run Date         "%a %_d. %b %R" "date"   10
    , Run StdinReader
    ]
  , sepChar          = "%"
  , alignSep         = "}{"
  , template         = "  %StdinReader% }{ %memory%     %dynnetwork%     %date%     %ZBAA%  "
  }
