module Main where

import System.Environment (getArgs)
import Todos.Cli
import Todos.TodoList

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

addEntry :: [String] -> IO ()
addEntry [] = putStrLn "Error: Task Description Required"
addEntry (task : _) = do
  todoList <- getTodoList
  writeTodoList $ insertTodoEntry (newEntry task) todoList
  return ()

removeEntry :: [String] -> IO ()
removeEntry args = do
  putStrLn (concat args)
  return ()

completeEntry :: [String] -> IO ()
completeEntry args = do
  putStrLn (concat args)
  return ()
