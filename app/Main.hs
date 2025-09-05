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
addEntry tasks = do
  todoList <- getTodoList
  writeTodoList $ foldr (insertTodoEntry . newEntry) todoList tasks
  return ()

showEntries :: [String] -> IO ()
showEntries _args = showTodoList Nothing

removeEntry :: [String] -> IO ()
removeEntry [] = putStrLn "Entry Index Required"
removeEntry idxs = do
  todoList <- getTodoList
  writeTodoList $ foldr (removeTodoEntry . read) todoList idxs
  return ()

completeEntry :: [String] -> IO ()
completeEntry [] = putStrLn "Entry Index requred"
completeEntry idxs = do
  todoList <- getTodoList
  writeTodoList $ foldr (completeTodoEntry . read) todoList idxs
  return ()
