module Todos.TodoList (
  TodoList,
  TodoEntry,
  newTodoList,
  insertTodoEntry,
  removeTodoEntry,
  readTodo,
) where

type TodoList = [(Int, TodoEntry)]
data TodoEntry = TodoEntry
  {done :: Bool, task :: String}
  deriving (Show, Read)

newTodoList :: TodoList
newTodoList = []

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
readTodo str = read str :: Maybe TodoList
