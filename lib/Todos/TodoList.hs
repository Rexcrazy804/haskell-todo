module Todos.TodoList (
  TodoList,
  TodoEntry (TodoEntry),
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
removeTodoEntry idx list
  | idx <= 0 = list
  | otherwise = aux list
 where
  aux [] = []
  aux (x@(idx', tsk) : xs)
    | idx == idx' = aux xs
    | idx' > idx = (idx' - 1, tsk) : aux xs
    | otherwise = x : aux xs

readTodo :: String -> Maybe TodoList
readTodo = readMaybe
