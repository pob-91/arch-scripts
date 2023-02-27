-- Base imports
import XMonad
import System.IO (hPutStrLn)
import qualified XMonad.StackSet as W

import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen)
 
import XMonad.Util.Run (spawnPipe)
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig (additionalKeys)

import XMonad.Hooks.SetWMName
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers

import XMonad.Layout.Spacing
import XMonad.Layout.IndependentScreens

import XMonad.Actions.GridSelect

import Data.Monoid

import Graphics.X11.ExtraTypes.XF86

import Colors.DoomOne

myTerminal :: String
myTerminal = "alacritty"

myModMask :: KeyMask
myModMask = mod4Mask

myBorderWidth :: Dimension
myBorderWidth = 2

myFocusColor :: String
myFocusColor = color15

myStartupHook = do
  spawn "killall trayer"

  spawnOnce "lxsession &"
  spawnOnce "nitrogen --restore &"
  spawnOnce "picom --experimental-backend &"
  spawnOnce "nm-applet --no-agent &"
  spawnOnce "dunst &"
  spawnOnce "xbanish &"
  spawnOnce "volumeicon &"
  spawnOnce "blueman-applet &"
  spawnOnce "xscreensaver -no-splash &"
  
  spawn "sleep 2 && trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --transparent true --alpha 51 --height 21 --tint 0x292d3e --monitor 1"

  setWMName "LG3D"

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio   = 1/2
    -- Percent of screen to increment by when resizing panes
    delta   = 3/100

-- spacing raw module adds a configurable amount of space around windows
mySpacing = spacingRaw False (Border 8 8 8 8) True (Border 8 8 8 8) True

-- this next bit is the same but no borders if fewer than two windows
-- mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
-- mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- key bindings
myKeys :: [((KeyMask, KeySym), X ())]
myKeys =
  -- Screen / window management
  [ ((myModMask, xK_comma), nextScreen) -- switch focus to the next screen
  , ((myModMask, xK_period), prevScreen) -- switch focus to the previous screen
  
  -- Multimedia
  , ((0, xF86XK_AudioNext), spawn "playerctl next")
  , ((0, xF86XK_AudioPrev), spawn "playerctl previous")
  , ((0, xF86XK_AudioPlay), spawn "playerctl play-pause")
  , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
  , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
  , ((0, xF86XK_AudioMute), spawn "pactl set-sint-mute @DEFAULT_SINK@ toggle")

  -- Backlight
  , ((0, xF86XK_MonBrightnessUp), spawn "lux -a 5%")
  , ((0, xF86XK_MonBrightnessDown), spawn "lux -s 5%")
  , ((myModMask .|. shiftMask, xK_l), spawn "xscreensaver-command -lock")

  -- Focus control
  , ((myModMask, xK_Right), windows W.focusDown) -- move focus to next window
  , ((myModMask, xK_Left), windows W.focusUp) -- move focus to prev window
  , ((myModMask .|. shiftMask, xK_Right), windows W.swapDown) -- swap current window with next window
  , ((myModMask .|. shiftMask, xK_Left), windows W.swapUp) -- swap current window with prev window
  ]

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  -- this is to float certain windows and apps
  [ className =? "Pavucontrol" --> doCenterFloat 
  ] 
  
myWorkspaces = ["1:admin", "2:web", "3:dev", "4:msg", "5:media", "6:arch", "7:util", "8:misc" , "9:misc"] 

-- main

main :: IO()
main = do
  n <- countScreens
  xmprocs <- mapM (\i -> spawnPipe $ "xmobar $HOME/.config/xmobar/xmobarrc -x" ++ show i) [0..n-1]
  xmonad $ docks def
    { modMask = myModMask
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , focusedBorderColor = myFocusColor
    , startupHook = myStartupHook
    , layoutHook = mySpacing $ myLayout
    , manageHook = myManageHook <+> manageDocks
    , workspaces = myWorkspaces
    , logHook = mapM_ (\handle -> dynamicLogWithPP $ xmobarPP
      -- Xmobar settings
      { ppOutput = hPutStrLn handle 
      , ppCurrent = xmobarColor "#98be65" "" . wrap "[" "]"
      , ppVisible = xmobarColor "#98be65" ""
      , ppHidden = xmobarColor "#82aaff" "" . wrap "*" ""
      , ppHiddenNoWindows = xmobarColor "#c792ea" ""
      , ppSep = " <fc=#ffffff>|</fc> "
      , ppTitle = xmobarColor "#b3afc2" "" . shorten 60
      , ppOrder = \(ws:l:t:ex) -> [ws]++ex++[t]
      }) xmprocs
  } `additionalKeys` myKeys
