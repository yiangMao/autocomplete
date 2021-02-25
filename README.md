# Search Autocomplete (UBC CPSC 312 Project 1)

This is a haskell library that can take care of search autocompletion. That is, given a prefix string and a library of english words, we will return a list of possible matches that the user may be in the process of typing.

# Background

Our Trie data structure represents a node as an object with:

1.  a boolean property that indicates whether this node represents the end of a dictionary word
2.  a [Data.Map](https://hackage.haskell.org/package/containers-0.4.0.0/docs/Data-Map.html) property that represents the children of this ```Trie``` node. This is a map of ```Char``` to ```TrieNode```.

For example, a dictionary of the words [cat, car] would be represented in our Trie data structure pictorically as follows:

                                 Root 
                                  |
                                  c
                                  |
                                  a
                                /   \
                               t     r

This is represented by the following recursive Trie node structure:

<pre>
Trie {
 False, 
 [
   ('c', Trie {
           False, 
           [ ('a', Trie {
                     False, 
                     [ ('t', Trie { 
                                True, 
                                []
                       }),
                       ('r', Trie {
                               True,
                               []
                       }),
                     ]
           })]
   })]
}
}
</pre>
 
# Usage Guide

1. Load the library into GHCI:

``` :l autocomplete.hs ```

2. Given this predefined definition for an empty trie in ```autocomplete.hs```:

```
emptyNode :: Trie
emptyNode = Node False Map.empty
```

You can insert a word into the trie like this:

```mytrie = insert "cat" emptyNode```

3. If you choose to do so, you can also initialize the trie with a list of words:

```mytrie = insertList ["cat", "car"]```

4. You can also load a list of words from a file. For example, given a words.txt file containing the following words:

```
cat
car
```
You can load the entire file into a trie like this:

```mytrie = loadDictionary words.txt```

5. Once a dictionary has been populated we can get a list of autocomplete suggestions by running the ```autocomplete``` command with a given prefix and trie node representing the root of our trie:

```autoComplete "c" mytrie```

In our example, this autocomplete call will return the following list: ["cat", "car"].
