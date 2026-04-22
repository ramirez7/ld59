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

-- Export the actual initialization function
foreign export javascript "wasmMain" main :: IO ()


main :: IO ()
main = do
  -- Initialize PIXI application
  app <- newApp
  app <- initAppInTarget app "black" "#canvas-container"
  appendToTarget "#canvas-container" app
  screen <- getProperty "screen" app
  screen_width <- valAsInt <$> getProperty "width" screen
  screen_height <- valAsInt <$> getProperty "height" screen

  gameTicker <- newTicker
  setProperty "maxFPS" gameTicker (intAsVal 60)
  setProperty "minFPS" gameTicker (intAsVal 60)

  art <- newArt
  addChild app (artHeadSprite art)

  w <- initWorld
  runWith w (initGame app art)

  callAddTicker gameTicker =<< jsFuncFromHs_
    (\_ -> runWith w $ do
        gateScreen Playing $ do
          tickFrame
          tickSnake
          tickFoodSpawn app art
        syncSnakeArt
        )
                                                 
  handleInput app art w
  startTicker gameTicker
  pure ()
