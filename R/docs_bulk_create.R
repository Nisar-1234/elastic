#' Use the bulk API to create documents
#' 
#' @export
#' @inheritParams docs_bulk
#' @details 
#' 
#' For doing create with a file already prepared for the bulk API, 
#' see [docs_bulk()]
#' 
#' Only data.frame's are supported for now.
#' @family bulk-functions
#' @references 
#' <https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-bulk.html>
#' @examples \dontrun{
#' x <- connect()
#' if (index_exists(x, "foobar")) index_delete(x, "foobar")
#' 
#' df <- data.frame(name = letters[1:3], size = 1:3, id = 100:102)
#' docs_bulk_create(x, df, 'foobar', es_ids = FALSE)
#' Search(x, "foobar", asdf = TRUE)$hits$hits
#' 
#' # more examples
#' docs_bulk_create(x, mtcars, index = "hello")
#' ## field names cannot contain dots
#' names(iris) <- gsub("\\.", "_", names(iris))
#' docs_bulk_create(x, iris, "iris")
#' ## type can be missing, but index can not
#' docs_bulk_create(x, iris, "flowers")
#' ## big data.frame, 53K rows, load ggplot2 package first
#' # res <- docs_bulk_create(x, diamonds, "diam")
#' # Search(x, "diam")$hits$total$value
#' }
docs_bulk_create <- function(conn, x, index = NULL, type = NULL, chunk_size = 1000,
  doc_ids = NULL, es_ids = TRUE, raw = FALSE, quiet = FALSE, query = list(), ...) {
  
  UseMethod("docs_bulk_create", x)
}

#' @export
docs_bulk_create.default <- function(conn, x, index = NULL, type = NULL, 
  chunk_size = 1000, doc_ids = NULL, es_ids = FALSE, raw = FALSE, 
  quiet = FALSE, query = list(), ...) {
  
  stop("no 'docs_bulk_create' method for class ", class(x)[[1L]], 
    call. = FALSE)
}

#' @export
docs_bulk_create.data.frame <- bulk_ci_generator("create", FALSE)
