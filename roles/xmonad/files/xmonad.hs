import XMonad
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Magnifier
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

main :: IO ()

main = do
    xmonad
     . ewmh
     . withEasySB (statusBarProp "xmobar" (pure xmobarpp)) defToggleStrutsKey
     $ cfg


cfg = def
    { terminal = "tilix"
    , modMask = mod4Mask
    , startupHook = startup
    , layoutHook = layout
    , focusedBorderColor = "#db9490"
    }
  `additionalKeysP`
    [ ("M-S-z", spawn "xscreensaver-command -lock")
    , ("M-C-s", unGrab *> spawn "scrot -s"        )
    , ("M-f"  , spawn "firefox"                   )
    , ("M-r"  , spawn "dmenu_run -b"              )
    ]


layout = tiled ||| Mirror tiled ||| Full ||| threeColumn
    where
        tiled       = Tall nmaster delta fraction
        threeColumn = magnifiercz' 1.3 $ ThreeColMid nmaster delta fraction
        nmaster  = 1     -- Default number of windows in the master pane
        fraction = 1/2   -- Default proportion of screen occupied by master pane
        delta    = 3/100 -- Percent of screen to increment by when resizing panes

xmobarpp :: PP
xmobarpp = def
    { ppSep             = magenta " • "
    , ppTitleSanitize   = xmobarStrip
    , ppCurrent         = wrap " " "" . xmobarBorder "Top" "#8be9fd" 2
    , ppHidden          = white . wrap " " ""
    , ppHiddenNoWindows = lowWhite . wrap " " ""
    , ppUrgent          = red . wrap (yellow "!") (yellow "!")
    --, ppOrder           = \[ws, l, _, wins] -> [ws, l, wins]
    , ppOrder           = \(ws:_:t:_) -> [ws]
    , ppExtras          = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "[") (white    "]") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "[") (lowWhite "]") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""


startup :: X ()
startup = do
    spawnOnce "feh --bg-fill --no-fehbg /usr/share/wallpapers/Next/contents/images/3840x2160.png"
    spawnOnOnce "workspace1" "tilix"
    spawnOnOnce "workspace1" "firefox"
    --spawnOnOnce "workspace2" "vscodium"
    --spawnOnOnce "workspace9" "steam-runtime"
