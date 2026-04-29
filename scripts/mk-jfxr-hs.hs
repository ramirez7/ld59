{-# LANGUAGE GHC2024 #-}
-- no need for this to be jfxr-specific if i use aeson..just do a little inference
import System.Environment
import System.Process
main :: IO ()
main = do
  jfxrFile <- getArgs >>= \case
    f : [] -> do pure f
    _ -> error "no arg"
  let jqCmd = mconcat ["cat ", jfxrFile, " | jq -r 'keys | .[]'"]
  jfxrFields <- lines <$> readCreateProcess (shell jqCmd) ""
  print jfxrFields

