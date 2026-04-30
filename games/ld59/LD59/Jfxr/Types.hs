module LD59.Jfxr.Types where
import Data.Aeson as Ae
import GHC.Generics
import Data.Scientific
data JfxrDef = JfxrDef
  { jfxr_name :: String
  , jfxr_version :: Scientific
  , jfxrAmplification :: Scientific
  , jfxrAttack :: Scientific
  , jfxrBitcrush :: Scientific
  , jfxrBitcrushsweep :: Scientific
  , jfxrCompression :: Scientific
  , jfxrDecay :: Scientific
  , jfxrFlangeroffset :: Scientific
  , jfxrFlangeroffsetsweep :: Scientific
  , jfxrFrequency :: Scientific
  , jfxrFrequencydeltasweep :: Scientific
  , jfxrFrequencyjump1amount :: Scientific
  , jfxrFrequencyjump1onset :: Scientific
  , jfxrFrequencyjump2amount :: Scientific
  , jfxrFrequencyjump2onset :: Scientific
  , jfxrFrequencysweep :: Scientific
  , jfxrHarmonics :: Scientific
  , jfxrHarmonicsfalloff :: Scientific
  , jfxrHighpasscutoff :: Scientific
  , jfxrHighpasscutoffsweep :: Scientific
  , jfxrInterpolatenoise :: Bool
  , jfxrLowpasscutoff :: Scientific
  , jfxrLowpasscutoffsweep :: Scientific
  , jfxrNormalization :: Bool
  , jfxrRepeatfrequency :: Scientific
  , jfxrSamplerate :: Scientific
  , jfxrSquareduty :: Scientific
  , jfxrSquaredutysweep :: Scientific
  , jfxrSustain :: Scientific
  , jfxrSustainpunch :: Scientific
  , jfxrTremolodepth :: Scientific
  , jfxrTremolofrequency :: Scientific
  , jfxrVibratodepth :: Scientific
  , jfxrVibratofrequency :: Scientific
  , jfxrWaveform :: String
  }
  deriving (Eq, Ord, Show, Read, Generic)

aesonStrip'jfxr :: Ae.Options
aesonStrip'jfxr = Ae.defaultOptions { fieldLabelModifier = drop 4 }

instance Ae.ToJSON JfxrDef where
  toJSON = genericToJSON aesonStrip'jfxr
  toEncoding = genericToEncoding aesonStrip'jfxr
instance Ae.FromJSON JfxrDef where
  parseJSON = genericParseJSON aesonStrip'jfxr
