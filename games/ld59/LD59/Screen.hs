module LD59.Screen where

import Control.Monad (when)
import LD59.World
import Apecs

gateScreen :: Screen -> System World () -> System World ()
gateScreen screen sys = cmapM_ $ \theScreen ->
  when (theScreen == screen) sys
  
