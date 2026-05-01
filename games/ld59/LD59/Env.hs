{-# LANGUAGE ImplicitParams #-}
{-# LANGUAGE RecordWildCards #-}
module LD59.Env where

import LD59.Art
import LD59.Jfxr.JSFFI qualified as Jfxr
import Pixi.Types qualified as Pixi
import Control.Monad.IO.Class
import Lib

data Env = Env
  { envArt :: Art
  , envAudio :: Jfxr.AudioContext
  , envApp :: Pixi.Application
  , envPlayArea :: Pixi.Container
  }

type HasEnv = (?env :: Env)

withEnv :: Env -> (HasEnv => r) -> r
withEnv e k = let ?env = e in k

openEnv :: HasEnv => (Env -> r) -> r
openEnv k = k ?env

addPlayAreaChild :: MonadIO m => IsJSVal a => HasEnv => a -> m ()
addPlayAreaChild x = openEnv $ \Env{..} -> liftIO $ addContainerChild envPlayArea x
