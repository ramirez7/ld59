{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Lib
import Control.Monad (when, replicateM)
import GHC.Wasm.Prim
import Pixi.Types qualified as Pixi
import Apecs
import LD59.World
import Data.Function (on)
import Safe (maximumMay, minimumByMay)
import Data.Foldable (for_)
import LD59.Controls
import LD59.Draw
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
  runWith w $ do
    hardcodedTail <- replicateM 5 $ do
      tailSprite <- liftIO $ newSprite (artTailTexture art)
      liftIO $ addChild app tailSprite
      let snakeTailVal = Tail{..}
      let snakeTailDir = RIGHT
      pure SnakeTailSeg{..}
    let initSnake = Snake
          { snakeHead = SnakeHead
            { snakeHeadVal = Head { headSprite = artHeadSprite art }
            , snakeHeadPos = V2 5 5
            , snakeHeadDir = RIGHT
            }
          , snakeTail = SnakeTail hardcodedTail
          , snakeStomachDir = RIGHT
          }
    newEntity_ (CurrentDir RIGHT, initSnake)
    newEntity_ Dead

  callAddTicker gameTicker =<< jsFuncFromHs_
    (\_ -> runWith w $ do
        gateScreen Playing $ do
          tickFrame
          tickSnake
        syncSnakeArt
        )
                                                 
  handleInput w
  startTicker gameTicker
  pure ()
