module Main where

import           GitIssues.OptParser

-- For now just show the internal parsed data model for options.
main :: IO ()
main = do
  print =<< getCommand
