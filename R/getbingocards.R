library(bingo)
tail(get_topic("BachelorBingo"))
bc <-bingo(n_cards=8, words=get_topic("BachelorBingo"))
plot(bc)
