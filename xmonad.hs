--
--  ~/.xmonad/xmonad.hs
--  written by Steve Wang
--
-- Modules {{{
------------------------------------------------------------------------

import System.Exit
import Data.Monoid
import XMonad

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

import XMonad.Actions.CycleWS                   -- shift workspaces 
import XMonad.Actions.DynamicProjects 

import XMonad.Hooks.DynamicLog                  -- log display
import XMonad.Hooks.ManageDocks                 -- space for dock
import XMonad.Hooks.ManageHelpers               -- windows management 
import XMonad.Hooks.SetWMName

import XMonad.Layout.Circle 
import XMonad.Layout.Column                     
import XMonad.Layout.Gaps                       -- gaps 
import XMonad.Layout.Grid
import XMonad.Layout.Master                     -- add master window 
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances 
import XMonad.Layout.NoBorders                  -- no borders 
import XMonad.Layout.PerWorkspace               -- layouts manager  
import XMonad.Layout.Renamed                    -- rename a layouts
import XMonad.Layout.ShowWName                  -- show workspace name 
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing                    -- spacing 
import XMonad.Layout.Tabbed                     -- tab windows
import XMonad.Layout.ThreeColumns               -- 3 cloums  
import XMonad.Layout.ToggleLayouts              -- toggle layout

import XMonad.Prompt
import XMonad.Prompt.ConfirmPrompt              -- Confirm when command 
import XMonad.Prompt.Man                        -- manal page 
import XMonad.Prompt.Shell                      -- run shell command 
import XMonad.Prompt.Window

import XMonad.Util.Run                          -- spawnPipe

import Graphics.X11.ExtraTypes.XF86             -- Extra keys 

-------------------------------------------------------------------- }}}
-- Main {{{
------------------------------------------------------------------------

main = do

    xmproc <- spawnPipe "xmobar"

    xmonad $ docks def

        -- Basic Setting 
        { terminal              = myTerminal
        , focusFollowsMouse     = myFocusFollowsMouse
        , clickJustFocuses      = myClickJustFocuses
        , modMask               = myModMask
        , workspaces            = myWorkspaces
        , borderWidth           = myBorderWidth
        , normalBorderColor     = myNormalBorderColor
        , focusedBorderColor    = myFocusedBorderColor
        
        -- Key Bindings
        , keys                  = myKeys
        , mouseBindings         = myMouseBindings
        
        -- Hooks, Layout
        , layoutHook            = myLayout
        , manageHook            = myManageHook
        , handleEventHook       = myEventHook
        , logHook               = myLogHook xmproc
        , startupHook           = myStartupHook
        }

-------------------------------------------------------------------- }}}
-- Basic {{{
------------------------------------------------------------------------

-- Modkey
myModMask = mod4Mask

-- Workspace
myWorkspaces = ["1", "2", "3", "4", "5"] 

-- Whether focus follows the mouse pointer.
myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False

-- Whether clicking on a window to focus also passes the click to the window
myClickJustFocuses :: Bool
myClickJustFocuses = False

-- Applications 
myTerminal          = "urxvt"
myTerminaladd       = "urxvt -e "
myBrowser           = "firefox"
myFileManager       = myTerminaladd ++ "ranger"
myTextEditer        = myTerminaladd ++ "vim"

-------------------------------------------------------------------- }}}
-- Theme {{{
------------------------------------------------------------------------

-- font 
myFont      = "xft:DejaVuSansCondensed:size=8:antialias=true:hinting=true"
myLargeFont = "xft:DejaVuSansCondensed:size=55:antialias=true:hinting=true"

-- Background image 
--myBackgroundImage = "feh --bg-fill /home/steve/Pictures/josh-adamski-116628.jpg &"
myBackgroundImage = "feh --bg-fill /home/steve/Pictures/jan-erik-waider-144384.jpg &"

-- Colors
myColorBlack   = "#000000"
myColorGrey    = "#555555"
myColorWhite   = "#bbbbbb"

-- Border Color 
myNormalBorderColor     = myColorGrey
myFocusedBorderColor    = myColorWhite

-- Border Width
myBorderWidth   = 3

-- Spacing Width
mySpacingWidth  = 10

-- Gap Width 
myGapWidthTop       = mySpacingWidth
myGapWidthBottom    = mySpacingWidth
myGapWidthLeft      = mySpacingWidth
myGapWidthRight     = mySpacingWidth

myTabHeight     = 30  
myDecoHeight    = 30  
myPromptHeight  = 30  

-- Prompt Height 

-- Tab 
myTabTheme = def
    { fontName              = myFont
    , activeColor           = myColorWhite 
    , inactiveColor         = myColorGrey
    , activeBorderColor     = myColorWhite
    , inactiveBorderColor   = myColorGrey
    , activeTextColor       = myColorBlack
    , inactiveTextColor     = myColorBlack
    , decoHeight            = myTabHeight
    }

-- Pormpt 
myPromptTheme = def
    { font              = myFont
    , fgColor           = myColorBlack
    , bgColor           = myColorWhite
    , fgHLight          = myColorWhite
    , bgHLight          = myColorBlack
    , borderColor       = myColorWhite
    , promptBorderWidth = 0
    , position          = Top
    , height            = myPromptHeight
    }

-- Show workspace name 
myShowWNameTheme = def 
    { swn_font      = myLargeFont
    , swn_fade      = 0.25
    , swn_bgcolor   = myColorBlack
    , swn_color     = myColorWhite
    }

-------------------------------------------------------------------- }}}
-- Bindings: Key {{{
------------------------------------------------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $

    -- System {{{
------------------------------------------------------------------------
    -- Quit / Restart XMonad
    [ ((modm                , xK_q          ), spawn "xmonad --recompile; xmonad --restart")
    , ((modm .|. shiftMask  , xK_q          ), confirmPrompt myPromptTheme "exit" (io exitSuccess))


    -- Kill the focused window 
    , ((modm                , xK_BackSpace  ), kill) 

    -- Launch applications 
    , ((modm                , xK_Return     ), spawn $ XMonad.terminal conf)
    , ((modm                , xK_space      ), shellPrompt myPromptTheme   )
    , ((modm .|. shiftMask  , xK_Return     ), spawn myFileManager         )
    , ((modm .|. shiftMask  , xK_space      ), spawn myBrowser             )
    
    -- Launch man page 
    , ((modm, xK_F1), manPrompt myPromptTheme)

    ---------------------------------------------------------------- }}} 
    -- Windows & Workspaces {{{
------------------------------------------------------------------------
    
    , ((modm                , xK_g     ), windowPrompt myPromptTheme Goto wsWindows)
    , ((modm                , xK_b     ), windowPrompt myPromptTheme Bring allWindows)

    -- Change / Shift the focused window
    , ((modm                , xK_j     ), windows W.focusDown  )
    , ((modm                , xK_k     ), windows W.focusUp    )
    , ((modm                , xK_m     ), windows W.focusMaster)
    , ((modm .|. shiftMask  , xK_j     ), windows W.swapDown   )
    , ((modm .|. shiftMask  , xK_k     ), windows W.swapUp     )
    , ((modm .|. shiftMask  , xK_m     ), windows W.swapMaster )
    
    -- Shrink / Expand the mastered window
    , ((modm .|. controlMask, xK_h     ), sendMessage Shrink)
    , ((modm .|. controlMask, xK_l     ), sendMessage Expand)

    -- + / - master pane 
    , ((modm .|. shiftMask  , xK_comma ), sendMessage (IncMasterN 1)   )
    , ((modm .|. shiftMask  , xK_period), sendMessage (IncMasterN (-1)))

    -- reload layout 
    , ((modm .|. controlMask, xK_Tab   ), setLayout $ XMonad.layoutHook conf)

    -- Toggle Full Layout 
    , ((modm                , xK_f     ), sendMessage ToggleLayout)

    -- Toggle mirror (rotate 90) 
    , ((modm                , xK_r     ), sendMessage $ XMonad.Layout.MultiToggle.Toggle MIRROR)

    -- Next Layout 
    , ((modm                , xK_Tab   ), sendMessage NextLayout)
    , ((modm  .|. shiftMask , xK_Tab   ), sendMessage FirstLayout)
    
    -- Push the focused window back nito tiling 
    , ((modm                , xK_t     ), withFocused $ windows . W.sink)
    
    -- Change the focused workspace 
    , ((modm                , xK_h     ), prevWS)
    , ((modm                , xK_l     ), nextWS)

    -- Shift the focus window to next / previous workspace
    , ((modm .|. shiftMask  , xK_h     ), shiftToPrev)
    , ((modm .|. shiftMask  , xK_l     ), shiftToNext)

    ---------------------------------------------------------------- }}}
    -- Extra functions {{{ 
    --------------------------------------------------------------------

    -- Audio control 
    -- , ((noModMask   , xF86XK_AudioMute       ), spawn "amixer toggle"       )
    , ((noModMask   , xF86XK_AudioLowerVolume), spawn "amixer set Master 5-")
    , ((noModMask   , xF86XK_AudioRaiseVolume), spawn "amixer set Master 5+")
    , ((controlMask , xF86XK_AudioLowerVolume), spawn "amixer set Master 1-")
    , ((controlMask , xF86XK_AudioRaiseVolume), spawn "amixer set Master 1+")

    -- 198 XF86AudioMicMute

    -- Monitor Brightness 
    , ((noModMask   , xF86XK_MonBrightnessDown), spawn "xbacklight -dec 5")
    , ((noModMask   , xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 5")
    , ((controlMask , xF86XK_MonBrightnessDown), spawn "xbacklight -dec 1")
    , ((controlMask , xF86XK_MonBrightnessUp  ), spawn "xbacklight -inc 1")
    
    -- External Monitor Toggle 
    , ((noModMask   , xF86XK_Display         ), spawn "~/.config/myScripts/externalMonitorToggle.sh")  

    -- Screenshot 
    , ((modm        , xK_s                   ), spawn "import -window root ~/Desktop/$(date +%F_%H%M%S_%N).jpg")  

    -- 246 XF86WLAN

    -- System Setting
    , ((noModMask   , xF86XK_Tools           ), spawn "urxvt -e vim ~/.xmonad/xmonad.hs")
    
    -- Bluetooth menu
    , ((noModMask   , xF86XK_Bluetooth       ), spawn "blueberry")

    -- keyboard 
    -- star 

    ]
    ---------------------------------------------------------------- }}} 

    ++

    -- Workspace 
    -- mod-[1..9], Switch to workspace N
    -- mod-shift-[1..9], Move client to workspace N
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

-------------------------------------------------------------------- }}}
-- Bindings: Mouse {{{
------------------------------------------------------------------------

myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    ]

-------------------------------------------------------------------- }}}
-- Layouts {{{
------------------------------------------------------------------------

myLayout = showWName' myShowWNameTheme
    $ toggleLayouts ((avoidStruts full) ||| full) 
    $ renamed [CutWordsLeft 3]
    $ avoidStruts
    $ gaps [(U, myGapWidthTop), (D, myGapWidthBottom), (L, myGapWidthLeft), (R, myGapWidthRight)] 
    $ addTabs shrinkText myTabTheme
    $ spacing mySpacingWidth
    $ mkToggle (single MIRROR)
    $ tall ||| twoPanes ||| grid 
    where

    named n = renamed [(XMonad.Layout.Renamed.Replace n)]

    -- one window

    full = named "Full"
        $ noBorders
        $ Full

    tab = named "Tabbed"
        $ addTabsAlways shrinkText myTabTheme
        $ noBorders
        $ Simplest 

    -- two or more windows 

    twoPanes = named "2 Panes"
        $ mastered (3/100) (1/2) 
        $ Simplest         

    tall = named "Tall"
        $ Tall 1 (3/100) (1/2) 

    grid = named "Grid"
        $ GridRatio (3/2) 

-------------------------------------------------------------------- }}}
-- Windows {{{
------------------------------------------------------------------------

myManageHook = composeOne
    [ 
    ]

-------------------------------------------------------------------- }}}
-- X Events {{{
------------------------------------------------------------------------

myEventHook = mempty

-------------------------------------------------------------------- }}}
-- Log {{{
------------------------------------------------------------------------

myLogHook h = dynamicLogWithPP $ xmobarPP
    { ppCurrent         = xmobarColor myColorBlack "" . \s -> "●"
    , ppHidden          = xmobarColor myColorGrey  "" . \s -> "●"
    , ppHiddenNoWindows = xmobarColor myColorGrey  "" . \s -> "○"
    , ppLayout          = xmobarColor myColorBlack "" 
    , ppWsSep           = "  "
    , ppSep             = xmobarColor myColorGrey  ""  "  |  " 
    , ppOrder           = \(ws:l:_:_) -> [ws, l]
    , ppOutput          = hPutStrLn h
    }

-------------------------------------------------------------------- }}}
-- Startup {{{ 
------------------------------------------------------------------------

myStartupHook = do 
    spawn myBackgroundImage
    setWMName "LG3D" 

------------------------------------------------------------------- }}}
--
-- vim: foldmethod=marker
