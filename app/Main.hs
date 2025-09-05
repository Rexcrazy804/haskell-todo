module Main where

import System.Environment (getArgs)
import Todos.Cli
import Todos.TodoList

subcommands :: [(String, [String] -> IO ())]
subcommands =
  [ ("add", addEntry)
  , ("remove", removeEntry)
  , ("show", showEntries)
  , ("done", completeEntry)
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

showEntries :: [String] -> IO ()
showEntries _args = showTodoList Nothing

removeEntry :: [String] -> IO ()
removeEntry [] = putStrLn "Entry Index Required"
removeEntry (idx : _) = do
  todoList <- getTodoList
  writeTodoList $ removeTodoEntry (read idx) todoList
  return ()

completeEntry :: [String] -> IO ()
completeEntry [] = putStrLn "Entry Index requred"
completeEntry (idx : _) = do
  todoList <- getTodoList
  writeTodoList $ completeTodoEntry (read idx) todoList
  return ()
