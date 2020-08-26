import Data.Word
import qualified Data.Map as M
import XMonad
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Layout.LayoutModifier
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Util.Run
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
-- import System.IO



-- Set Terminal to Alacritty
myTerminal :: String
myTerminal = "alacritty"

-- Set default browser
myBrowser :: String
myBrowser = "firefox "

-- Set editor
myEditor :: String
myEditor = "emacsclient -c -a ''"

-- Set super key to win
myModMask :: KeyMask
myModMask = mod4Mask

-- Style Border
myBorderWidth :: Word32
myBorderWidth = 2

myFocusedColor :: String
myFocusedColor = "#dcdcdc"

myNormalColor :: String
myNormalColor = "#7f7f7f"

-- Roman Numerals for workspaces
myWorkspaces :: [String]
myWorkspaces   = ["I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX"]

-- Setup Keybindings
myKeys :: [(String, X ())]
myKeys =
  [ ("M-w", spawn myBrowser)
  , ("M-e", spawn myEditor )
  ]

-- Bordering around windows
myBorder :: Border
myBorder = Border 5 5 5 5

-- Spacing function
mySpacing :: l a -> ModifiedLayout Spacing l a
mySpacing =  spacingRaw False myBorder True myBorder True

-- Setup layout
-- avoidStruts: remove overlapping with xmobar
-- spacingWithEdge: spacing with same width between windows as distance from edge
-- myLayout :: ModifiedLayout AvoidStruts (ModifiedLayout Spacing Tall) Window
myLayout = avoidStruts (   Tall 1 (3/100) (1/2)
                       ||| spiral (6/7))

myXmobarrc :: String
myXmobarrc = "~/.xmonad/xmobarrc.hs"

myConfig = def
  { modMask            = myModMask
  , terminal           = myTerminal
  , borderWidth        = myBorderWidth
  , focusedBorderColor = myFocusedColor
  , normalBorderColor  = myNormalColor
  , layoutHook         = mySpacing myLayout
  , workspaces         = myWorkspaces
  }

xmobarTitleColor :: String
xmobarTitleColor = "#91ad91"

xmobarCurrentWorkspaceColor :: String
xmobarCurrentWorkspaceColor = "#91ad91"

myStartupHook :: X ()
myStartupHook
  =  spawnOnce "sh ~/.fehbg &"
  >> spawnOnce "emacs --daemon &"
  >> spawnOnce "picom ~/.config/picom.conf &"

main :: IO ()
main = do
  xmproc <- spawnPipe ("xmobar " ++ myXmobarrc)
  xmonad $ myConfig
    { logHook     = dynamicLogWithPP $ xmobarPP
      { ppOutput  = hPutStrLn xmproc
      , ppTitle   = xmobarColor xmobarTitleColor "" . shorten 100
      , ppCurrent = xmobarColor xmobarCurrentWorkspaceColor ""
      , ppSep     = "   "
      }
      , manageHook = manageDocks
      , startupHook = myStartupHook
      , handleEventHook = docksEventHook
    } `additionalKeysP` myKeys
