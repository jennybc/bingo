library(bingo)
tail(get_topic("boring-meeting"))
bc <-bingo(n_cards=8, words=get_topic("boring-meeting"))
plot(bc)
