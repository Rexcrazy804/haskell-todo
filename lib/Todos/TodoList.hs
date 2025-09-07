module Todos.TodoList (
  TodoList,
  TodoEntry (TodoEntry),
  newTodoList,
  insertTodoEntry,
  removeTodoEntry,
  readTodo,
  newEntry,
  completeTodoEntry,
  sortTodoList,
) where

import Data.List (partition)
import Text.Read (readMaybe)

type TodoList = [(Int, TodoEntry)]
data TodoEntry = TodoEntry
  { isCompleted :: Bool
  , getTask :: String
  }
  deriving (Show, Read)

newTodoList :: TodoList
newTodoList = []

newEntry :: String -> TodoEntry
newEntry = TodoEntry False

insertTodoEntry :: TodoEntry -> TodoList -> TodoList
insertTodoEntry entry xl@((idx, _) : _) = (idx + 1, entry) : xl
insertTodoEntry entry [] = [(1, entry)]

removeTodoEntry :: Int -> TodoList -> TodoList
removeTodoEntry idx list
  | idx <= 0 = list
  | otherwise = aux list
 where
  aux [] = []
  aux (x@(idx', entry) : xs)
    | idx == idx' = aux xs
    | idx' > idx = (idx' - 1, entry) : aux xs
    | otherwise = x : aux xs

readTodo :: String -> Maybe TodoList
readTodo = readMaybe

-- despite the name it actually toggles the completion status
completeTodoEntry :: Int -> TodoList -> TodoList
completeTodoEntry idx list
  | idx <= 0 = list
  | otherwise = aux list
 where
  aux [] = []
  aux (x@(idx', TodoEntry dn tsk) : xs)
    | idx == idx' = (idx', TodoEntry (not dn) tsk) : aux xs
    | otherwise = x : aux xs

sortTodoList :: TodoList -> TodoList
sortTodoList list =
  let (completed, incomplete) = partition (isCompleted . snd) list
   in reverse . reIndex 1 $ incomplete ++ completed
 where
  reIndex :: Int -> TodoList -> TodoList
  reIndex _ [] = []
  reIndex idx ((_, x) : xs) = (idx, x) : reIndex (idx + 1) xs
