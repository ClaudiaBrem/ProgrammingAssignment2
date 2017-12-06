## First, install and load the package matlib
#install.packages("matlib")
library(matlib)

## This function creates a list of four functions that 
## 1) set the value of the matrix
## 2) get the value of the matrix
## 3) set the value of the inverse
## 4) get the value of the inverse
## The output of this function will be the input for the function cacheSolve. 

makeCacheMatrix <- function(x = matrix()) {
      inv <- NULL
      set <- function(y) {
            x <<- y
            inv <<- NULL
      }
      get <- function() x
      setinv <- function(inverse) inv <<- inverse
      getinv <- function() inv
      list(set = set, get = get,
           setinv = setinv,
           getinv = getinv)
}


## This function takes the output of the function makeCacheMatrix as input.
## If the inverse of the matrix has already been calculted, it takes the result from the cache. 
## Otherwise it calculates the inverse. 

cacheSolve <- function(x, ...) { 
      inv <- x$getinv()
      if(!is.null(inv)) {
            message("getting cached data")
            return(inv)
      }
      data <- x$get()
      inv <- inv(data, ...)
      x$setinv(inv)
      inv
}
