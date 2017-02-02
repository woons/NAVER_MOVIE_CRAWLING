#install.packages(c("httr", "rvest", "dplyr", "stringr"))

library(httr)
library(rvest)
library(dplyr)
library(stringr)

#국제시장
url <- "http://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=102875&target=&page="
res <- GET(url)
h <- read_html(res, encoding = "ms949")

#empty vector
first_page_final <- NULL

#10page loop
for(i in 1:10) {
  url <- paste0("http://movie.naver.com/movie/point/af/list.nhn?st=mcode&sword=102875&target=&page=",i)
  res <- GET(url)
  h <- read_html(res, encoding = "ms949")
  #코멘트
  comment_next <- html_nodes(h, xpath = "//*[@id='old_content']/table/tbody/tr/td[4]/text()")
  comment_next <- html_text(comment_next)
  comment_next <- str_trim(comment_next)
  comment_next <- comment_next[comment_next != ""]
  comment_next <- data.frame(comment_next)
  colnames(comment_next) <- "comment"
  #평점
  rate_next <- html_nodes(h, ".point")
  rate_next <- html_text(rate_next)
  rate_next <- data.frame(rate_next)
  colnames(rate_next) <- "rate"
  #날짜
  date_next <- html_nodes(h, xpath = "//*[@id='old_content']/table/tbody/tr/td[5]/text()")
  date_next <- html_text(date_next)
  date_next <- data.frame(date_next)
  colnames(date_next) <- "date"
  #아이디
  id_next <- html_nodes(h, xpath = "//*[@id='old_content']/table/tbody/tr/td[5]/a/text()")
  id_next <- html_text(id_next)
  id_next <- data.frame(id_next)
  colnames(id_next) <- "id"
  final_page <- cbind(date_next, comment_next, rate_next, id_next)
  #결합
  first_page_final <- rbind(first_page_final, final_page)
}



