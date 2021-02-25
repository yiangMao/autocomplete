module Helpers 
 (noSuchChild,
 getChildren,
 markEnd,
 splitsep
 ) where

import qualified Data.Map as Map
import Trie

-- Returns true if the character is not a valid key in the children map of a given trie. Otherwise, it returns false
noSuchChild :: Trie -> Char -> Bool
noSuchChild Empty _ = True
noSuchChild (Node end children) letter = Map.notMember letter children

-- Returns the children of a given Trie
getChildren :: Trie -> Map.Map Char Trie
getChildren Empty = Map.empty
getChildren (Node end children) = children

-- This function takes a trie node and marks this node as an end of a word
markEnd :: Maybe Trie -> Maybe Trie
markEnd (Just (Node end children)) = Just (Node True children)

-- This function reads lines from a input file and returns an array of the content of each line in the file
splitsep :: (a -> Bool) -> [a] -> [[a]]
splitsep _ [] = [[]]
splitsep f list = p list []
 where p [] parts = [parts]
       p (h:t) parts = if f h then parts: p t [] else p t (parts++[h])
