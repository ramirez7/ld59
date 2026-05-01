{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Monad (when)
import GHC.Wasm.Prim
import Pixi.Types qualified as Pixi
import Apecs
import LD59.World
import Data.Function (on)
import Safe (maximumMay, minimumByMay)
import Data.Foldable (for_)
import LD59.Controls
import LD59.Draw
import LD59.Init
import LD59.Tick
import LD59.Snake
import Linear.V2
import LD59.Dir
import LD59.Screen
import LD59.Env
import LD59.Art
import LD59.Jfxr.JSFFI qualified as Jfxr

-- Export the actual initialization function
foreign export javascript "wasmMain" main :: IO ()


main :: IO ()
main = do
  ac <- Jfxr.newAudioContext
  art <- newArt
  -- Initialize PIXI application
  app <- newApp
  pa <- initPlayArea app
  withEnv (Env art ac app pa) $ do
    app <- initAppInTarget app "black" "#canvas-container"
    appendToTarget "#canvas-container" app
    screen <- getProperty "screen" app
    screen_width <- valAsInt <$> getProperty "width" screen
    screen_height <- valAsInt <$> getProperty "height" screen
    
    gameTicker <- newTicker
    setProperty "maxFPS" gameTicker (intAsVal 60)
    setProperty "minFPS" gameTicker (intAsVal 60)
    
    
    
    w <- initWorld
    runWith w initGame
    
    callAddTicker gameTicker =<< jsFuncFromHs_
      (\_ -> runWith w $ do
          gateScreen Playing $ do
            tickFrame
            tickSnake
            tickFoodSpawn
          syncSnakeArt
          )
    
    handleInput w
    startTicker gameTicker
    pure ()
