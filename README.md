The very early beginning's of R API Binding's for the Openstack Swift object storage.
Includes some functionallity specific to Rackspace CloudFiles (CDN Operations).
 TODO: everything, should start by renaming functions. 
PRESENT: Authentication, Getting Acccount/Container/Object Info, Retrieving a file
RACKSPACE CLOUDFILES SPECIFIC: Getting CDN Container listing.
CDN Enabling a container, Enabling CDN log retention.
 
# Sample usage: #

    source("/Users/fhines/Documents/RSwift/RSwift.R")

#### Set your user and apikey:
    xstorageuser <- c("testuser")
    xstoragepass <- c("sUp3rSekritApiKeyGoesHere")

#### Make an auth call
    > PerformAuth()
    [1] TRUE
    > storage.url
    X-Storage-Url  "https://storage101.dfw1.clouddrive.com/v1/MossoCloudFS_9e7f94e2-ff60-47a6-89ae-42cf2d68ecc0" 
    > storage.auth
      X-Auth-Token "8d3bdafa-48da-448e-b39c-1586ced6025b" 
    > cdn.mgmturl
      X-CDN-Management-Url "https://cdn1.clouddrive.com/v1/MossoCloudFS_9e7f94e2-ff60-47a6-89ae-42cf2d68ecc0" 

#### Get an object
    > file <- GetObject("/rapitest", "/cdn-test.txt")

    # Get a list of CDN Containers
    > GetCDNContainers()
    [1] TRUE
    > typeof(cdn.containers)
    [1] "list"

    # Get your account info
    > GetAccountInfo()
    [1] TRUE
    > account.bytes.used
    X-Account-Bytes-Used 
         "498195347"

...and so forth.
