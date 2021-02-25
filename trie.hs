module Trie where
    
import qualified Data.Map as Map

--  A Trie Node is either Empty or contains:
--    1. a boolean variable indicating whether this node represents the end of a word
--    2. a character to Trie map containing the children Trie nodes accessible from this node
data Trie = Empty
           | Node Bool (Map.Map Char Trie)
        deriving (Show)