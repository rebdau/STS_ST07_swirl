test_func1 <- function() {
  try({
    func <- get('boring_function', globalenv())
    t1 <- identical(func(9), 9)
    t2 <- identical(func(4), 4)
    t3 <- identical(func(0), 0)
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func2 <- function() {
  try({
    func <- get('my_mean', globalenv())
    t1 <- identical(func(9), mean(9))
    t2 <- identical(func(1:10), mean(1:10))
    t3 <- identical(func(c(-5, -2, 4, 10)), mean(c(-5, -2, 4, 10)))
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func3 <- function() {
  try({
    func <- get('remainder', globalenv())
    t1 <- identical(func(9, 4), 9 %% 4)
    t2 <- identical(func(divisor = 5, num = 2), 2 %% 5)
    t3 <- identical(func(5), 5 %% 2)
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func4 <- function() {
  try({
    func <- get('evaluate', globalenv())
    t1 <- identical(func(sum, c(2, 4, 7)), 13)
    t2 <- identical(func(median, c(9, 200, 100)), 100)
    t3 <- identical(func(floor, 12.1), 12)
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func5 <- function() {
  try({
    func <- get('telegram', globalenv())
    t1 <- identical(func("Good", "morning"), "START Good morning STOP")
    t2 <- identical(func("hello", "there", "sir"), "START hello there sir STOP")
    t3 <- identical(func(), "START STOP")
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func6 <- function() {
  try({
    func <- get('mad_libs', globalenv())
    t1 <- identical(func(place = "Baltimore", adjective = "smelly", noun = "Roger Peng statue"), "News from Baltimore today where smelly students took to the streets in protest of the new Roger Peng statue being installed on campus.")
    t2 <- identical(func(place = "Washington", adjective = "angry", noun = "Shake Shack"), "News from Washington today where angry students took to the streets in protest of the new Shake Shack being installed on campus.")
    ok <- all(t1, t2)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_func7 <- function() {
  try({
    func <- get('%p%', globalenv())
    t1 <- identical(func("Good", "job!"), "Good job!")
    t2 <- identical(func("one", func("two", "three")), "one two three")
    ok <- all(t1, t2)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_eval1 <- function(){
  try({
    e <- get("e", parent.frame())
    expr <- e$expr
    t1 <- identical(expr[[3]], 6)
    expr[[3]] <- 7
    t2 <- identical(eval(expr), 8)
    ok <- all(t1, t2)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_eval2 <- function(){
  try({
    e <- get("e", parent.frame())
    expr <- e$expr
    t1 <- identical(expr[[3]], quote(c(8, 4, 0)))
    t2 <- identical(expr[[1]], quote(evaluate))
    expr[[3]] <- c(5, 6)
    t3 <- identical(eval(expr), 5)
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}

test_eval3 <- function(){
  try({
    e <- get("e", parent.frame())
    expr <- e$expr
    t1 <- identical(expr[[3]], quote(c(8, 4, 0)))
    t2 <- identical(expr[[1]], quote(evaluate))
    expr[[3]] <- c(5, 6)
    t3 <- identical(eval(expr), 6)
    ok <- all(t1, t2, t3)
  }, silent = TRUE)
  exists('ok') && isTRUE(ok)
}



# Get the swirl state
getState <- function(){
  # Whenever swirl is running, its callback is at the top of its call stack.
  # Swirl's state, named e, is stored in the environment of the callback.
  environment(sys.function(1))$e
}

# Retrieve the log from swirl's state
getLog <- function(){
  getState()$log
}

submit_log <- function(){
  
  # Please edit the link below
  # pre_fill_link <- "https://docs.google.com/forms/d/1ngWrz5A5w5RiNSuqzdotxkzgk0DKU-88FmnTHj20nuI/viewform?entry.1733728592"
  pre_fill_link <- "https://docs.google.com/forms/d/e/1FAIpQLSdAOjg2BmNt7qtlj-KZbdoq7Gk_6uvZEy3xh0OBhqvqwBwjhQ/viewform?entry.419798233"
  
  # Do not edit the code below
  if(!grepl("=$", pre_fill_link)){
    pre_fill_link <- paste0(pre_fill_link, "=")
  }
  
  p <- function(x, p, f, l = length(x)){if(l < p){x <- c(x, rep(f, p - l))};x}
  
  temp <- tempfile()
  log_ <- getLog()
  nrow_ <- max(unlist(lapply(log_, length)))
  log_tbl <- data.frame(user = rep(log_$user, nrow_),
                        course_name = rep(log_$course_name, nrow_),
                        lesson_name = rep(log_$lesson_name, nrow_),
                        question_number = p(log_$question_number, nrow_, NA),
                        correct = p(log_$correct, nrow_, NA),
                        attempt = p(log_$attempt, nrow_, NA),
                        skipped = p(log_$skipped, nrow_, NA),
                        datetime = p(log_$datetime, nrow_, NA),
                        stringsAsFactors = FALSE)
  write.csv(log_tbl, file = temp, row.names = FALSE)
  encoded_log <- base64encode(temp)
  browseURL(paste0(pre_fill_link, encoded_log))
}

