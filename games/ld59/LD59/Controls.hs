{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE OverloadedStrings #-}

module LD59.Controls where

import LD59.World
import GHC.Wasm.Prim
import LD59.Dir
import Apecs
import Control.Monad (unless, when)
import Lib
import Control.Monad.IO.Class

handleInput :: World -> IO ()
handleInput w = do
  bindKeyDir w "KeyS" DOWN
  bindKeyDir w "KeyW" UP
  bindKeyDir w "KeyA" LEFT
  bindKeyDir w "KeyD" RIGHT

bindKeyDir :: World -> String -> Dir -> IO ()
bindKeyDir w keycode dir =
  addWindowEventListener "keydown" =<< jsFuncFromHs_ (runWith w . gateKeypress keycode (setCurrentDir dir))

gateKeypress :: MonadIO m => String -> m () -> JSVal -> m ()
gateKeypress expectedCode k e = do
  krepeat <- valAsBool <$> liftIO (getProperty "repeat" e)
  unless krepeat $ do
    kcode <- fromJSString . valAsString <$> liftIO (getProperty "code" e)
    when (kcode == expectedCode) k
  
setCurrentDir :: Dir -> System World ()
setCurrentDir dir = cmap $ \(_ :: CurrentDir) -> CurrentDir dir
