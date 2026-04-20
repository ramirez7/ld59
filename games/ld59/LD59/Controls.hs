{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE MultilineStrings #-}
{-# LANGUAGE OverloadedStrings #-}

module LD59.Controls where

import LD59.World
import GHC.Wasm.Prim
import LD59.Dir
import Apecs
import Control.Monad (unless, when)
import Lib
import Control.Monad.IO.Class
import LD59.Jfxr.JSFFI qualified as Jfxr
import Data.Coerce

jfxrStr :: JSString
jfxrStr = toJSString """
{"_version":1,"_name":"Default 1","_locked":[],"sampleRate":44100,"attack":0,"sustain":0.2,"sustainPunch":0,"decay":0,"tremoloDepth":0,"tremoloFrequency":10,"frequency":500,"frequencySweep":0,"frequencyDeltaSweep":0,"repeatFrequency":0,"frequencyJump1Onset":33,"frequencyJump1Amount":0,"frequencyJump2Onset":66,"frequencyJump2Amount":0,"harmonics":0,"harmonicsFalloff":0.5,"waveform":"sine","interpolateNoise":true,"vibratoDepth":0,"vibratoFrequency":10,"squareDuty":50,"squareDutySweep":0,"flangerOffset":0,"flangerOffsetSweep":0,"bitCrush":16,"bitCrushSweep":0,"lowPassCutoff":22050,"lowPassCutoffSweep":0,"highPassCutoff":0,"highPassCutoffSweep":0,"compression":1,"normalization":true,"amplification":100}
"""

handleInput :: World -> IO ()
handleInput w = do
  --ctx <- Jfxr.newAudioContext
  --clip <- Jfxr.newClip jfxrStr
  bindKeyDir w "KeyS" DOWN
  bindKeyDir w "KeyW" UP
  bindKeyDir w "KeyA" LEFT
  bindKeyDir w "KeyD" RIGHT
{-  addWindowEventListener "keydown" =<< jsFuncFromHs_ (\_ -> do
                                                         consoleLogShow "PLAY"
                                                         consoleLogVal (coerce clip)
                                                         Jfxr.playClip ctx clip)-}
bindKeyDir :: World -> String -> Dir -> IO ()
bindKeyDir w keycode dir =
  addWindowEventListener "keydown" =<< jsFuncFromHs_ (runWith w . gateKeypress keycode (setCurrentDir dir))

gateKeypress :: MonadIO m => String -> m () -> JSVal -> m ()
gateKeypress expectedCode k e = do
  krepeat <- valAsBool <$> liftIO (getProperty "repeat" e)
  unless krepeat $ do
    kcode <- fromJSString . valAsString <$> liftIO (getProperty "code" e)
    when (kcode == expectedCode) $ do
      liftIO $ consoleLogShow $ "YOOO " ++ expectedCode
      k
  
setCurrentDir :: Dir -> System World ()
setCurrentDir dir = cmap $ \(CurrentDir _) -> CurrentDir dir
