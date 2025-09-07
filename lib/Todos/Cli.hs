module Todos.Cli (
  getTodoFile,
  getTodoList,
  writeTodoList,
  showTodoList,
) where

import Data.Maybe (fromMaybe)
import System.Directory (createDirectoryIfMissing)
import System.Environment (getEnvironment)
import System.Environment.XDG.BaseDir (getUserConfigDir)
import System.FilePath (takeDirectory, (</>))
import System.IO
import Todos.TodoList

getTodoFile :: IO FilePath
getTodoFile = do
  defaultTodoDir <- getUserConfigDir "todo"
  let defaultConfig = defaultTodoDir </> "todolist.dat"
  configFile <- fromMaybe defaultConfig . lookup "KURU_TODO" <$> getEnvironment
  createDirectoryIfMissing True (takeDirectory configFile)
  return configFile

getTodoList :: IO TodoList
getTodoList = do
  todoFile <- getTodoFile
  withFile todoFile AppendMode (\_ -> return ())
  todoData <- withFile todoFile ReadMode hGetContents'
  return (fromMaybe newTodoList $ intoTodoList todoData)

showTodoList :: Maybe TodoList -> IO ()
showTodoList list' = do
  todoList <- maybe getTodoList return list'
  mapM_ displayEntry $ reverse todoList
 where
  displayEntry (idx, TodoEntry dn task) =
    putStrLn $ concat [show idx, "|[", if dn then "X" else " ", "]: ", task]

writeTodoList :: (Show a) => a -> IO ()
writeTodoList list = do
  todoFile <- getTodoFile
  withFile todoFile WriteMode (`hPutStr` show list)
