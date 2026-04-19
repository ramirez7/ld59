{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TypeFamilies #-}
module LD59.World where

import Apecs
import Data.Word (Word64)
import Pixi.Types qualified as Pixi

data Logo = Logo { logoSeq :: Word64, logoSprite :: Pixi.Sprite }

instance Component Logo where type Storage Logo = Map Logo

makeWorld "World" [''Logo]
