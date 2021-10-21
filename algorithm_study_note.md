

LCP Array

* Store sorted suffices in an array
* Each index track length of longest common prefix of two consecutive suffixes 
* First index is 0/undefined by convention  
* Can be constructed in O(nLogn) or O(n)

Syntax

* `range(2,2)` will not execute

LRU Cache

```
from functools import lru_cache
@lru_cache(maxsize = 100)
def method(param):
	...
```

