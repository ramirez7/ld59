{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TypeFamilies #-}
module LD59.World where

import Apecs
import Data.Word (Word64)
import Pixi.Types qualified as Pixi
import LD59.Snake
import LD59.Dir

newtype CurrentDir = CurrentDir Dir deriving stock (Show)
instance Component CurrentDir where type Storage CurrentDir = Unique CurrentDir

$(mempty)

makeWorld "World" [''Snake, ''CurrentDir]
