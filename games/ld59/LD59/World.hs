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
import Data.Monoid (Sum (..))

newtype CurrentDir = CurrentDir Dir deriving stock (Show)
instance Component CurrentDir where type Storage CurrentDir = Unique CurrentDir

data Head = Head
  { headSprite :: Pixi.Sprite
  }

-- Wave type will go in here
data Tail = Tail
  { tailSprite :: Pixi.Sprite
  }

type Snake = SnakeF Head Tail

newtype Frame = Frame Word64
  deriving stock (Show)
  deriving newtype (Enum, Bounded, Num)
  deriving (Semigroup, Monoid) via (Sum Frame)

instance Component Frame where type Storage Frame = Global Frame


makeWorld "World" [''Snake, ''CurrentDir, ''Frame]
