module LD59.Env where

import LD59.Draw
import LD59.Jfxr.JSFFI qualified as Jfxr
import Pixi.Types qualified as Pixi

data Env = Env
  { envArt :: Art
  , envAudio :: Jfxr.AudioContext
  , envApp :: Pixi.Application
  }

type HasEnv = (?env :: Env)

withEnv :: Env -> (HasEnv => r) -> r
withEnv e k = let ?env = e in k
