import qualified Data.Map as Map
import Trie
import Helpers

-- | A definition for an empty Trie node
emptyNode :: Trie
emptyNode = Node False Map.empty

-- | The 'insert' function takes a: (1) string, and (2) a trie node and inserts the string into the trie
insert :: String -> Trie -> Trie
insert "" trie = trie
insert (h:t) (Node end children)
  -- case 1: We have not yet finished processing the string and there's no existing node matching the next char in the string. 
  | noSuchChild (Node end children) h && (length t > 0 ) = Node end (Map.alter insertNewNode h children)
  -- case 2: We have finished processing the insertion string and there is no existing node matching the next char in the string. 
  | noSuchChild (Node end children) h && (length t == 0 ) = Node end (Map.alter insertEndNode h children)
  -- case 3: We have not yet finished processing the string and there is already an existing node matching the next char in the string. 
  | (length t > 0) = Node end (Map.alter traverseToNextNode h children)  
  -- case 4: We have finished processing the insertion string and there is an existing node matching the next char in the string.
  | otherwise = Node end (Map.alter markEndNode h children)
 where
  insertNewNode _ = Just ( insert t ( Map.findWithDefault Empty h ( Map.insert h emptyNode children ) ) )
  insertEndNode _ = Just ( insert t ( Map.findWithDefault Empty h ( Map.insert h (Node True Map.empty) children ) ) )
  traverseToNextNode _ = Just (insert t (Map.findWithDefault Empty h children))
  markEndNode a = markEnd a

-- | The 'insertList' function inserts a list of strings into a trie
insertList :: [String]-> Trie -> Trie
insertList [] trie = trie
insertList (h:t) trie = insertList t (insert h trie)

-- | The 'getWords' function utilizes a list comprehension helper to return a list of all the words contained within a trie node.
getWords :: Trie -> [String]
getWords (Node end children) 
    | end = "" : getWordsHelper
    | otherwise = getWordsHelper
    where getWordsHelper = [ c : words | (c, trie) <- Map.toList children, words <- getWords trie ]

-- | The 'autoComplete' function retrieves a list of strings in the trie matching the given prefix 
autoComplete :: String -> Trie -> [String]
autoComplete prefix trieNode = map (\x -> prefix ++ x) (autoCompleteHelper prefix trieNode)

-- | The 'autoCompleteHelper' traverses the trie node up to the end of the prefix and then 
--   calls getWords from whatever node we are at to get the words that can be generated from the given prefix
autoCompleteHelper :: String -> Trie -> [String]
autoCompleteHelper [] node = getWords node
autoCompleteHelper (x:xs) node = let keys = (getChildren node) in
                           case (Map.lookup x keys) of
                           Nothing -> []
                           Just result -> autoCompleteHelper xs result

-- IO Functions to read and load a file containing a list of dictionary words to input into a Trie 
-- getWordsFromFile :: IO [[Char]]
getWordsFromFile =
   do
      putStr "Which file do you want to read?\n"
      filename <- getLine
      file <- readFile (filename)
      let words = splitsep (== '\n') file
      return words

loadDictionary :: FilePath -> IO Trie
loadDictionary file trie =
   do 
     file <- readFile file
     let words = splitsep (== '\n') file
     return (insertList words trie)
