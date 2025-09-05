module Todos.Cli (
  getTodoFile,
) where

import Data.Maybe (fromMaybe)
import System.Directory (createDirectoryIfMissing)
import System.Environment (getEnvironment)
import System.Environment.XDG.BaseDir (getUserConfigDir)
import System.FilePath ((</>))

getTodoFile = do
  defaultTodoDir <- getUserConfigDir "todo"
  let defaultConfig = defaultTodoDir </> "todolist.dat"
  configFile <- fromMaybe defaultConfig . lookup "KURU_TODO" <$> getEnvironment
  createDirectoryIfMissing True configFile
  return configFile
