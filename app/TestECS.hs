{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE DerivingStrategies #-}
{-# LANGUAGE DerivingVia #-}
{-# LANGUAGE TypeFamilies #-}
module TestECS where

import Apecs
import Data.Word (Word64)
import Data.Monoid (Sum (..))

newtype FrameCounter = FrameCounter Word64
  deriving stock (Show)
  deriving newtype (Enum, Bounded, Num)
  deriving (Semigroup, Monoid) via (Sum FrameCounter)

instance Component FrameCounter where type Storage FrameCounter = Global FrameCounter

makeWorld "World" [''FrameCounter]
