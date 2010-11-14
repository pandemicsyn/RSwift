#source("/Users/fhines/Documents/RSwift.R")
library("RCurl")

authurl <- c("http://cftest.blackopscode.com:11000/v1.0")
xstorageuser <- c("test:tester")
xstoragepass <- c("testing")

PerformAuth <- function() {
  rhdr <- basicTextGatherer()
  result <- getURL(authurl, httpheader = c('x-storage-user' = xstorageuser, 'x-storage-pass' = xstoragepass), header = TRUE, headerfunction = rhdr$update)
  result.headers <- read.dcf(textConnection(paste(rhdr$value(NULL)[-1], collapse="")))
  storage.url <<- result.headers[1,"X-Storage-Url"]
  storage.token <<- result.headers[1,"X-Storage-Token"]
  storage.auth <<- result.headers[1,"X-Auth-Token"]
  
  #need to find trycatch/exception handling
  if(exists("storage.url")) {
  	return(TRUE)
  } else {
  	return(FALSE)	
  }
}

GetAccountInfo <- function() {
  rhdr <- basicTextGatherer()
  result <- getURL(storage.url, httpheader = c(storage.auth), header = TRUE, headerfunction = rhdr$update, customrequest = "HEAD")
  result.headers <- read.dcf(textConnection(paste(rhdr$value(NULL)[-1], collapse="")))
  account.object.count <<- result.headers[1,"X-Account-Object-Count"]
  account.bytes.used <<- result.headers[1,"X-Account-Bytes-Used"]
  account.container.count <<- result.headers[1,"X-Account-Container-Count"]
  
  #need to find trycatch/exception handling
  if(exists("account.bytes.used")) {
  	return(TRUE)
  } else {
  	return(FALSE)
  }
}

GetContainerInfo <-function(container, debug=FALSE) {
  rhdr <- basicTextGatherer()
  h <- getCurlHandle()
  url <- paste(storage.url, container, sep="")
  result <- getURL(url, httpheader=c(storage.auth), header=TRUE, headerfunction=rhdr$update, customrequest="HEAD", curl=h, nobody=TRUE, verbose=debug)
  result.headers <- read.dcf(textConnection(paste(rhdr$value(NULL)[-1], collapse="")))
  if (getCurlInfo(h)$response.code == 204) { 
	print(result.headers)
	return(TRUE)
  } else if (getCurlInfo(h)$response.code == 404) {
  	print("404 Container Not Found")
  	return(FALSE)
  } else {
  	print(paste("Request failed, encountered:", getCurlInfo(h)$response.code))
  	return(FALSE)	
  }
}

GetObjectInfo <-function(container, object, debug=FALSE) {
  rhdr <- basicTextGatherer()
  h <- getCurlHandle()
  url <- paste(storage.url, container, object,  sep="")
  result <- getURL(url, httpheader=c(storage.auth), header=TRUE, headerfunction=rhdr$update, customrequest="HEAD", curl=h, nobody=TRUE, verbose=debug)
  result
  result.headers <- read.dcf(textConnection(paste(rhdr$value(NULL)[-1], collapse="")))
  if (getCurlInfo(h)$response.code == 200) { 
	return(result.headers)
  } else if (getCurlInfo(h)$response.code == 404) {
  	if(debug == TRUE) {
  	  print("404 File Not Found")
  	}
  	return(result.headers)
  } else {
  	if(debug == TRUE) {
  	  print(paste("Requested failed, encountered", getCurlInfo(h)$response.code))
  	}
  	return(FALSE)	
  }
}

#need to use getURLContent
GetObject <-function(container, object, debug=FALSE) {
  rhdr <- basicTextGatherer()
  h <- getCurlHandle()
  url <- paste(storage.url, container, object,  sep="")
  result <- getURLContent(url, httpheader=c(storage.auth), curl=h, verbose=debug, binary=NA)
  if (getCurlInfo(h)$response.code == 200) { 
	return(result)
  } else if (getCurlInfo(h)$response.code == 404) {
  	if(debug == TRUE) {
  	  print("404 File Not Found")
  	}
  	return(result)
  } else {
  	if(debug == TRUE) {
  	  print(paste("Requested failed, encountered", getCurlInfo(h)$response.code))
  	}
  	return(FALSE)	
  }
}