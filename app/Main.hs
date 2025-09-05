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
  , ("clear", clearEntries)
  ]

main :: IO ()
main = do
  (subcommand, args) <- getSubCommand <$> getArgs
  case lookup subcommand subcommands of
    Just func -> func args
    Nothing -> putStrLn "Error: Invalid Subcommand"

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

clearEntries :: [String] -> IO ()
clearEntries _ = writeTodoList newTodoList

removeEntry :: [String] -> IO ()
removeEntry [] = putStrLn "Error: Entry Index Required"
removeEntry idxs = do
  todoList <- getTodoList
  writeTodoList $ foldr (removeTodoEntry . read) todoList idxs
  return ()

completeEntry :: [String] -> IO ()
completeEntry [] = putStrLn "Error: Entry Index requred"
completeEntry idxs = do
  todoList <- getTodoList
  writeTodoList $ foldr (completeTodoEntry . read) todoList idxs
  return ()
