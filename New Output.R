t_final <- rbind(if(exists("t2")) t2, if(exists("t3")) t3)

 
t_ex <- nrow(t1[t1$Role == 'E',])
t_DX <- nrow(t1[t1$Role == 'D',])
t_NX <- nrow(t1[t1$Role == 'N',])

x <- paste("No of exclusions: E =",t_ex)
x1 <- paste("NO of exclusions: I =", (t_ex * 2))
y <- paste("No of denominator: D =",t_DX)
y1 <- paste("NO of denominator: I =", (t_DX * 2))
z <- paste("No of Numerator: N =",t_NX)
z1 <- paste("No of Numerator: I =",(t_NX * 2))

tmp <- file("output1.txt")
writeLines(c("---------EXCLUSION OUTPUT----------",x,x1,"---------NUMERATOR OUTPUT----------",y,y1,"---------DENOMINATOR OUTPUT----------",z,z1),con = tmp)
close(tmp)
