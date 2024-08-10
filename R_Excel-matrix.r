> library(tidyr)
> data = read.table("OF.csv", header=T, sep=",")
> temp=spread(data,gb,OF)
> write.table(temp,"OF",row.names=F,sep="\t")
