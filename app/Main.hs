module Main where

import Data.Maybe (fromMaybe)
import System.Environment (getArgs)
import System.IO
import Todos.Cli (getTodoFile)
import Todos.TodoList (newTodoList)
import qualified Todos.TodoList as TD

subcommands :: [(String, [String] -> IO ())]
subcommands =
  [ ("add", addEntry)
  , ("remove", removeEntry)
  ]

main :: IO ()
main = do
  (subcommand, args) <- getSubCommand <$> getArgs
  case lookup subcommand subcommands of
    Just func -> func args
    Nothing -> putStrLn "Invalid Subcommand"

getSubCommand :: [String] -> (String, [String])
getSubCommand [] = ("help", [])
getSubCommand (subcommand : args) = (subcommand, args)

getTodoList :: IO TD.TodoList
getTodoList = do
  todoFile <- getTodoFile
  todoData <- withFile todoFile ReadMode hGetContents'
  return (fromMaybe newTodoList $ TD.readTodo todoData)

addEntry :: [String] -> IO ()
addEntry args = do
  putStrLn (concat args)
  return ()

removeEntry :: [String] -> IO ()
removeEntry args = do
  putStrLn (concat args)
  return ()

completeEntry :: [String] -> IO ()
completeEntry args = do
  putStrLn (concat args)
  return ()
