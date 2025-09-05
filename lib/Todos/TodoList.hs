module Todos.TodoList (
  TodoList,
  TodoEntry,
  newTodoList,
  insertTodoEntry,
  removeTodoEntry,
  readTodo,
  newEntry,
) where

import Text.Read (readMaybe)

type TodoList = [(Int, TodoEntry)]
data TodoEntry = TodoEntry
  {done :: Bool, task :: String}
  deriving (Show, Read)

newTodoList :: TodoList
newTodoList = []

newEntry :: String -> TodoEntry
newEntry = TodoEntry False

insertTodoEntry :: TodoEntry -> TodoList -> TodoList
insertTodoEntry entry xl@((idx, _) : _) = (idx + 1, entry) : xl
insertTodoEntry entry [] = [(1, entry)]

removeTodoEntry :: Int -> TodoList -> TodoList
removeTodoEntry idx = aux
 where
  aux [] = []
  aux (x@(idx', _) : xs)
    | idx == idx' = aux xs
    | otherwise = x : aux xs

readTodo :: String -> Maybe TodoList
readTodo = readMaybe
