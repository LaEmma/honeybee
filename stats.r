########################
### Getting ready
########################
library(ggplot2)
setwd("D:\\AeroFS\\Projects\\survey\\2stats")
dd <- read.table("data\\all_v3.tab")
attach(dd)

head(dd)
names(dd)
summary(dd)

table(year)
table(province)
table(HoneyResourceOverall)
table(ThreatenOverall)
table(FoodOverall)
table(SpeicesOverall)
table(NQueenChange)
table(NewHiveOrNot)
table(MtOrNot)
table(MtAllTogetherOrNot)
table(StMonth)
table(CCD)
table(CcdOrNot)
length(na.omit(CCD))

attach(dd)
## A neat way to create an empty data frame (with colomn names)!!! (from yoursearchbuddy.com)
grand_df <- data.frame(t(rep(NA,4)))
names(grand_df) <- c("name","x^2","p","adjusted.p")
grand_df <- grand_df[-1,]

########################
## region
########################
# 山西   140000     # 辽宁   210000     # 吉林   220000
# 黑龙江 230000     # 江苏   320000     # 浙江   330000
# 安徽   340000     # 福建   350000     # 河南   410000
# 湖北   420000     # 广东   440000     # 广西   450000
# 海南   460000     # 重庆   500000     # 四川   510000
# 云南   530000     # 甘肃   620000     # 新疆   650000
south  <- province==350000 | province==440000 | province==450000 | province==460000
north  <- !south
region <- ifelse(south,"South","North")

table(cerana)
table(cerana[south])
table(cerana[north])
table(cerana[province==350000])
table(cerana[province==440000])
table(cerana[province==450000])
table(cerana[province==460000])

########################
### mortality
########################
mortality <- WintLoss/NOct
## mortality - arcsin-sequare root transformation
trans.mortality <- asin(sqrt(mortality/100))
summary(mortality)
summary(mortality[north])
summary(mortality[south])
ggplot(data.frame(mortality, region), aes(x=mortality)) + geom_histogram(binwidth=0.02, fill="white", colour="black") + facet_grid(region ~ .)


########################
### Mite treatment and mortality
########################
table(MtOrNot)
filter.mt <- !is.na(MtOrNot)
plot(factor(MtOrNot[filter.mt]), mortality[filter.mt])
levels(factor(MtOrNot))
plot(factor(MtOrNot[filter.mt]), trans.mortality[filter.mt])
ttt <- data.frame(mortality=(WintLoss/NOct), vt=MtOrNot)
ttt <- na.omit(ttt)
mean(ttt$mortality[vt==1])
mean(ttt$mortality[vt==0])
#plot(factor(MtAllTogetherOrNot[filter.mt]), mortality[filter.mt])
#plot(factor(MtAllTogetherOrNot[filter.mt]), trans.mortality[filter.mt])

# chi-square test
mt <- cbind(NOct,WintLoss,MtOrNot)[filter.mt,]
mt1.total <- sum(mt[,1][mt[,3]==1])
mt0.total <- sum(mt[,1][mt[,3]==0])
mt1.dead  <- sum(mt[,2][mt[,3]==1])
mt0.dead  <- sum(mt[,2][mt[,3]==0])
mt1.live  <- mt1.total - mt1.dead
mt0.live  <- mt0.total - mt0.dead
M <- as.table(rbind(c(mt1.live,mt1.dead),c(mt0.live,mt0.dead)))
t <- chisq.test(M,correct=F)

# write chi-square test result into grand_df
l = length(grand_df[,1])
i = l+1
grand_df[i,1] <- "Varroa mite treatment"
grand_df[i,2] <- t$statistic
grand_df[i,3] <- t$p.value


########################
### New queen and mortality
########################
# No. of queen change
table(NQueenChange)
filter.qc <- NQueenChange<=5 & NQueenChange>0  ## ‘0’ 被排除出去，因为含义不明（没有换蜂王/没有填写本条数据）
plot(factor(NQueenChange[filter.qc]), mortality[filter.qc])
plot(factor(NQueenChange[filter.qc]), trans.mortality[filter.qc])
table(NQueenChange[filter.qc])

str(nqc)
nqc <- cbind(NOct,WintLoss,NQueenChange)[filter.qc,]
nqc <- na.omit(nqc)
nqc.total <- c( sum(nqc[,1][nqc[,3]==1]),
                sum(nqc[,1][nqc[,3]==2]),
                sum(nqc[,1][nqc[,3]==3]),
                sum(nqc[,1][nqc[,3]==4]),
                sum(nqc[,1][nqc[,3]==5]) )
nqc.dead  <- c( sum(nqc[,2][nqc[,3]==1]),
                sum(nqc[,2][nqc[,3]==2]),
                sum(nqc[,2][nqc[,3]==3]),
                sum(nqc[,2][nqc[,3]==4]),
                sum(nqc[,2][nqc[,3]==5]) )
nqc.live  <- nqc.total - nqc.dead
chisq.test(nqc.live,nqc.dead,correct=F)
# Pearson's Chi-squared test
# data:  nqc.dead and nqc.live
# X-squared = 20, df = 16, p-value = 0.2202
chisq.test(nqc.dead[c(1,5)],nqc.live[c(1,5)],correct=F)
nqc.live/nqc.dead
nqc.live[c(1,5)]/nqc.dead[c(1,5)]

# Ratio of new queen
table(NNewQueen)
filter.nq <- NNewQueen!=0 & !is.na(NNewQueen)
nqRatio <- NNewQueen/NOct
summary(nqRatio[filter.nq])
dg1 <- data.frame(nqRatio[filter.nq], mortality[filter.nq])
fit1 <- lm(mortality[filter.nq] ~ nqRatio[filter.nq])
summary(fit1)
coef(fit1)
    # (Intercept) nqRatio[filter.nq]
    # 0.103481585        0.008557722
ggplot(dg1, aes(x=nqRatio.filter.nq.,y=mortality.filter.nq.)) + geom_point() + geom_abline(intercept=0.103481585,slope=0.008557722)
# queen change method
summary(data.frame(factor(qcCol), factor(qcOp), factor(qcBreed)))
plot(factor(qcCol),mortality)
plot(factor(qcOp),mortality)
plot(factor(qcBreed),mortality)

## Chi-square test
filter.qc <- filter.qc & !is.na(NQueenChange)
dnqc <- cbind(NOct,WintLoss,NQueenChange)[filter.qc,]
total <- c(dnqc[,1][dnqc[,3]==1],dnqc[,1][dnqc[,3]==2],dnqc[,1][dnqc[,3]==3],dnqc[,1][dnqc[,3]==4],dnqc[,1][dnqc[,3]==5])
dead  <- c(dnqc[,2][dnqc[,3]==1],dnqc[,2][dnqc[,3]==2],dnqc[,2][dnqc[,3]==3],dnqc[,2][dnqc[,3]==4],dnqc[,2][dnqc[,3]==5])
live  <- total - dead
tnqc <- chisq.test(dead,live)
tnqc

####################
## New hive and mortality
####################
# New hive?
NewHiveOrNot
plot(factor(NewHiveOrNot), mortality)
plot(factor(NewHiveOrNot), trans.mortality)

nh <- cbind(NOct,WintLoss,NewHiveOrNot)
nh <- na.omit(nh)
nh1.total <- sum(nh[,1][nh[,3]==1])
nh2.total <- sum(nh[,1][nh[,3]==2])
nh1.dead  <- sum(nh[,2][nh[,3]==1])
nh2.dead  <- sum(nh[,2][nh[,3]==2])
nh1.live  <- nh1.total - nh1.dead
nh2.live  <- nh2.total - nh2.dead
M <- as.table(rbind(c(nh1.live,nh1.dead),c(nh2.live,nh2.dead)))
t <- chisq.test(M,correct=F)
t
# X-squared = 3437.463, df = 1, p-value < 2.2e-16

# Percentage of new hive
nh.perc <- NewHivePercentage
filter.nh <- !is.na(nh.perc) & nh.perc<=100
fit2 <- lm(mortality[filter.nh] ~ nh.perc[filter.nh])
summary(fit2)
coef(fit2)
    # (Intercept) nh.perc[filter.nh]
    # 0.1082502686      -0.0001005173
dg5 <- data.frame(nh.perc[filter.nh], mortality[filter.nh])
ggplot(dg5, aes(x=nh.perc.filter.nh.,y=mortality.filter.nh.)) + geom_point() + geom_abline(intercept=0.1082502686, slope=-0.0001005173)


########################
## Feeding and mortality
########################
food <- factor(FoodOverall)
levels(food)[levels(food)=="1"] <- "Honey"
levels(food)[levels(food)=="2"] <- "Sugar"
levels(food)[levels(food)=="3"] <- "Inverted sugar"
levels(food)[levels(food)=="4"] <- "HFCS"
levels(food)[levels(food)=="5"] <- "Pollen"
levels(food)[levels(food)=="6"] <- "Protein"
levels(food)[levels(food)=="7"] <- "Yeast"
levels(food)[levels(food)=="8"] <- "Egg"
levels(food)[levels(food)=="99"]<- "Multiple food"
table(food)
filter.f <- !is.na(food)

dg2 <- data.frame(mortality[filter.f], food[filter.f], trans.mortality[filter.f])
ggplot(dg2, aes(x=food.filter.f.,y=mortality.filter.f.)) + geom_boxplot() + theme(axis.text.x = element_text(colour="black", size=rel(1.2))) + xlab("Food") + ylab("Mortality")
ggplot(dg2, aes(x=food.filter.f.,y=trans.mortality.filter.f.)) + geom_boxplot() + theme(axis.text.x = element_text(colour="black", size=rel(1.2))) + xlab("Food") + ylab("Mortality (arcsin-square root transformed")

fd <- cbind(NOct,WintLoss,FoodOverall,honey,sugar,invertSugar,HFCS,pollen,protein,yeast)
table(fd[,3])
fd <- fd[fd[,3]]
fd <- na.omit(fd)
fd1.total <- c(sum(fd[,1][fd[, 4]==1]),
               sum(fd[,1][fd[, 5]==1]),
               sum(fd[,1][fd[, 6]==1]),
               sum(fd[,1][fd[, 7]==1]),
               sum(fd[,1][fd[, 8]==1]),
               sum(fd[,1][fd[, 9]==1]),
               sum(fd[,1][fd[,10]==1])
              )
fd1.dead  <- c(sum(fd[,2][fd[, 4]==1]),
               sum(fd[,2][fd[, 5]==1]),
               sum(fd[,2][fd[, 6]==1]),
               sum(fd[,2][fd[, 7]==1]),
               sum(fd[,2][fd[, 8]==1]),
               sum(fd[,2][fd[, 9]==1]),
               sum(fd[,2][fd[,10]==1])
              )
fd0.total <- c(sum(fd[,1][fd[, 4]==0]),
               sum(fd[,1][fd[, 5]==0]),
               sum(fd[,1][fd[, 6]==0]),
               sum(fd[,1][fd[, 7]==0]),
               sum(fd[,1][fd[, 8]==0]),
               sum(fd[,1][fd[, 9]==0]),
               sum(fd[,1][fd[,10]==0])
              )
fd0.dead  <- c(sum(fd[,2][fd[, 4]==0]),
               sum(fd[,2][fd[, 5]==0]),
               sum(fd[,2][fd[, 6]==0]),
               sum(fd[,2][fd[, 7]==0]),
               sum(fd[,2][fd[, 8]==0]),
               sum(fd[,2][fd[, 9]==0]),
               sum(fd[,2][fd[,10]==0])
              )
fd1.live  <- fd1.total - fd1.dead
fd0.live  <- fd0.total - fd0.dead
fd1.live/fd1.dead
fd0.live/fd0.dead
n <- c("honey","sugar","inverted sugar","HFCS","pollen","protein","yeast")
for (i in 1:7) {
    M <- as.table(rbind( c(fd1.live[i],fd1.dead[i]),
                         c(fd0.live[i],fd0.dead[i])
                       ))
    t <- chisq.test(M,correct=F)
    print(n[i])
    print(t$statistic)
    print(t$p.value)
}

########################
# Threatens and mortality
########################
threatens <- factor(ThreatenOverall)
levels(threatens)[levels(threatens)=="11"] <- "Mouse"
levels(threatens)[levels(threatens)=="10"] <- "Bear"
levels(threatens)[levels(threatens)=="9"]  <- "Ant"
levels(threatens)[levels(threatens)=="8"]  <- "Poison"
levels(threatens)[levels(threatens)=="7"]  <- "Mite"
levels(threatens)[levels(threatens)=="6"]  <- "Bee eater"
levels(threatens)[levels(threatens)=="5"]  <- "Hornet"
levels(threatens)[levels(threatens)=="4"]  <- "Fire"
levels(threatens)[levels(threatens)=="3"]  <- "Storm"
levels(threatens)[levels(threatens)=="2"]  <- "Beatles"
levels(threatens)[levels(threatens)=="1"]  <- "Human"
levels(threatens)[levels(threatens)=="12"] <- "Other"
levels(threatens)[levels(threatens)=="13"] <- "Other disease"
levels(threatens)[levels(threatens)=="99"] <- "Multiple threatens"
table(threatens)
filter.t <- !is.na(threatens)

dg3 <- data.frame(mortality[filter.t], threatens[filter.t], trans.mortality[filter.t])
ggplot(dg3, aes(x=threatens.filter.t.,y=mortality.filter.t.)) + geom_boxplot() + theme(axis.text.x = element_text(angle=-45, vjust=1, hjust=0, colour="black", size=rel(1.2))) + xlab("Threatens") + ylab("Mortality")

trt <- cbind(NOct,WintLoss,ThreatenOverall,mouse,bear,ant,poison,mite,beeEater,hornet,fire,storm,beatles,human,other,otherDisease)
trt <- na.omit(trt)
trt1.total <- c(sum(trt[,1][trt[, 4]==1]),
                sum(trt[,1][trt[, 5]==1]),
                sum(trt[,1][trt[, 6]==1]),
                sum(trt[,1][trt[, 7]==1]),
                sum(trt[,1][trt[, 8]==1]),
                sum(trt[,1][trt[, 9]==1]),
                sum(trt[,1][trt[,10]==1]),
                sum(trt[,1][trt[,11]==1]),
                sum(trt[,1][trt[,12]==1]),
                sum(trt[,1][trt[,13]==1]),
                sum(trt[,1][trt[,14]==1]),
                sum(trt[,1][trt[,15]==1]),
                sum(trt[,1][trt[,16]==1])
              )
trt1.dead  <- c(sum(trt[,2][trt[, 4]==1]),
                sum(trt[,2][trt[, 5]==1]),
                sum(trt[,2][trt[, 6]==1]),
                sum(trt[,2][trt[, 7]==1]),
                sum(trt[,2][trt[, 8]==1]),
                sum(trt[,2][trt[, 9]==1]),
                sum(trt[,2][trt[,10]==1]),
                sum(trt[,2][trt[,11]==1]),
                sum(trt[,2][trt[,12]==1]),
                sum(trt[,2][trt[,13]==1]),
                sum(trt[,2][trt[,14]==1]),
                sum(trt[,2][trt[,15]==1]),
                sum(trt[,2][trt[,16]==1])
              )
trt0.total <- c(sum(trt[,1][trt[, 4]==0]),
                sum(trt[,1][trt[, 5]==0]),
                sum(trt[,1][trt[, 6]==0]),
                sum(trt[,1][trt[, 7]==0]),
                sum(trt[,1][trt[, 8]==0]),
                sum(trt[,1][trt[, 9]==0]),
                sum(trt[,1][trt[,10]==0]),
                sum(trt[,1][trt[,11]==0]),
                sum(trt[,1][trt[,12]==0]),
                sum(trt[,1][trt[,13]==0]),
                sum(trt[,1][trt[,14]==0]),
                sum(trt[,1][trt[,15]==0]),
                sum(trt[,1][trt[,16]==0])
              )
trt0.dead  <- c(sum(trt[,2][trt[, 4]==0]),
                sum(trt[,2][trt[, 5]==0]),
                sum(trt[,2][trt[, 6]==0]),
                sum(trt[,2][trt[, 7]==0]),
                sum(trt[,2][trt[, 8]==0]),
                sum(trt[,2][trt[, 9]==0]),
                sum(trt[,2][trt[,10]==0]),
                sum(trt[,2][trt[,11]==0]),
                sum(trt[,2][trt[,12]==0]),
                sum(trt[,2][trt[,13]==0]),
                sum(trt[,2][trt[,14]==0]),
                sum(trt[,2][trt[,15]==0]),
                sum(trt[,2][trt[,16]==0])
              )
trt1.live  <- trt1.total-trt1.dead
trt0.live  <- trt0.total-trt0.dead
length(trt1.dead)
n <- c("mouse","bear","ant","poison","mite","beeEater","hornet","fire","storm","beatles","human","other","otherDisease")
threaten_df <- data.frame(t(rep(NA,4)))
names(threaten_df) <- c("name","x^2","p","adjusted.p")
threaten_df <- threaten_df[-1,]
for (i in 1:13) {
    M <- as.table(rbind(c(trt1.live[i],trt0.live[i]), c(trt1.dead[i],trt0.dead[i]) ))
    t <- chisq.test(M, correct=F)
    threaten_df[i,1] <- n[i]
    threaten_df[i,2] <- t$statistic
    threaten_df[i,3] <- t$p.value
}
threaten_df$adjusted.p <- p.adjust(threaten_df$p, method="bonferroni")
threaten_df$adjusted.p <- threaten_df$p.value
threaten_df

chisq.test(trt1.live,trt1.dead,correct=F)
# Pearson's Chi-squared test
# data:  trt.live and trt.dead
# X-squared = 156, df = 144, p-value = 0.2335

##################
## Species and mortality
##################
species <- factor(SpeciesOverall)
levels(species)[levels(species)=="1"] <- "cerana"
levels(species)[levels(species)=="2"] <- "mellifera"
levels(species)[levels(species)=="3"] <- "carnica"
levels(species)[levels(species)=="4"] <- "ligustica"
levels(species)[levels(species)=="5"] <- "caucasica"
#levels(species)[levels(species)=="6"] <- "anatoliaca"
levels(species)[levels(species)=="7"] <- "hybrid"
levels(species)[levels(species)=="8"] <- "do_not_know"
levels(species)[levels(species)=="9"] <- "xin_jiang_hei_feng"
levels(species)[levels(species)=="10"]<- "dong_bei_hei_fen"
levels(species)[levels(species)=="99"]<- "Multiple species"
table(species)
filter.sp <- !is.na(species)

dg4 <- data.frame(mortality[filter.sp], trans.mortality[filter.sp], species[filter.sp])
ggplot(dg4, aes(x=species.filter.sp.,y=mortality.filter.sp.)) + geom_boxplot() + theme(axis.text.x = element_text(angle=-45, vjust=1, hjust=0, colour="black", size=rel(1.2))) + xlab("Species") + ylab("Mortality")
ggplot(dg4, aes(x=species.filter.sp.,y=trans.mortality.filter.sp.)) + geom_boxplot() + theme(axis.text.x = element_text(angle=-45, vjust=1, hjust=0, colour="black", size=rel(1.2))) + xlab("Species") + ylab("Mortality (arcsin-square root transformed)")


##########################
## honey production
##########################
hp <- HoneyProduction
decider <- year=="09-10" | year=="10-11" & HoneyProduction<=60
    # Note:
    # 产蜜数据仅留09-10,10-11,其它年的要么没有，要么不靠谱
    # 09-10年产蜜数据为“平均每群产蜜量”
    # 人工检查推测，10-11年“产蜜量”低于60的填写的其实是“平均每群产蜜量”，而不是“总产蜜量”
per.col.hp <- ifelse(decider, hp, hp/NOct)

filter.h <- year=="09-10" | year=="10-11" & hp!=per.col.hp
filter.h <- filter.h & !is.na(hp)
filter.h <- filter.h & hp!=0
filter.h <- filter.h & per.col.hp<200
filter.h <- filter.h & NOct>0
summary(per.col.hp[filter.h])

ggplot(NULL,aes(x=per.col.hp[filter.h])) + geom_histogram(binwidth=5, fill="white", colour="black") + xlab("Per colony honey production")
dg6 <- data.frame(region[filter.h], per.col.hp[filter.h])
ggplot(dg6,aes(x=per.col.hp.filter.h.)) + geom_histogram(binwidth=5, fill="white", colour="black") + xlab("Per colony honey production") + facet_grid(region.filter.h. ~ .)


##############################
## Honey production & honey resources
##############################
hr <- HoneyResourceOverall
plot(hr[filter.h & hr!=99], per.col.hp[filter.h & hr!=99], main="honey resource - per colony honey production")
plot(hr[filter.h], per.col.honeyP[filter.h], main="honey resource - per colony honey production")
plot(hr[filter.h & south], per.col.honeyP[filter.h & south], ylim=c(0,200))
plot(hr[filter.h & north], per.col.honeyP[filter.h & north], ylim=c(0,200))

hr <- factor(hr)
levels(hr)[levels(hr)=="14"] <- "rape"  # may carry pesicides
levels(hr)[levels(hr)=="13"] <- "maize"
levels(hr)[levels(hr)=="12"] <- "sunflower"
#levels(hr)[levels(hr)=="11"] <- "willow"
#levels(hr)[levels(hr)=="10"] <- "lime"
levels(hr)[levels(hr)=="9"]  <- "wild flower"
#levels(hr)[levels(hr)=="8"]  <- "clover"
levels(hr)[levels(hr)=="7"]  <- "litchi"
levels(hr)[levels(hr)=="6"]  <- "longan"
#levels(hr)[levels(hr)=="5"]  <- "loquat"
#levels(hr)[levels(hr)=="4"]  <- "locust"
levels(hr)[levels(hr)=="3"]  <- "jujube"
levels(hr)[levels(hr)=="2"]  <- "vitex"
levels(hr)[levels(hr)=="1"]  <- "linden"
#levels(hr)[levels(hr)=="15"] <- "rice"
#levels(hr)[levels(hr)=="16"] <- "wheat"
levels(hr)[levels(hr)=="17"] <- "apple"
#levels(hr)[levels(hr)=="18"] <- "water melon"
levels(hr)[levels(hr)=="19"] <- "strawberry"
#levels(hr)[levels(hr)=="20"] <- "pear"
levels(hr)[levels(hr)=="99"] <- "Multiple"
table(hr)
filter.hr <- filter.h & !is.na(hr)

dg7 <- data.frame(hr[filter.hr], per.col.hp[filter.hr])
ggplot(dg7, aes(x=hr.filter.hr.,y=per.col.hp.filter.hr.)) + geom_boxplot() + theme(axis.text.x = element_text(colour="black",size=rel(1.2))) + xlab("Honey resources") + ylab("Honey production")

hr <- cbind(NOct,WintLoss,HoneyResourceOverall,rape,maize,sunflower,wildFlower,litchi,longan,jujube,vitex,linden,apple,strawberry)
hr <- na.omit(hr)
hr.total <- c( sum(hr[,1][hr[, 4]==1]),
               sum(hr[,1][hr[, 5]==1]),
               sum(hr[,1][hr[, 6]==1]),
               sum(hr[,1][hr[, 7]==1]),
               sum(hr[,1][hr[, 8]==1]),
               sum(hr[,1][hr[, 9]==1]),
               sum(hr[,1][hr[,10]==1]),
               sum(hr[,1][hr[,11]==1]),
               sum(hr[,1][hr[,12]==1]) )
hr.dead  <- c( sum(hr[,2][hr[, 4]==1]),
               sum(hr[,2][hr[, 5]==1]),
               sum(hr[,2][hr[, 6]==1]),
               sum(hr[,2][hr[, 7]==1]),
               sum(hr[,2][hr[, 8]==1]),
               sum(hr[,2][hr[, 9]==1]),
               sum(hr[,2][hr[,10]==1]),
               sum(hr[,2][hr[,11]==1]),
               sum(hr[,2][hr[,12]==1]) )
hr.live  <- hr.total - hr.dead
hr.live
hr.dead
hr.live/hr.dead
chisq.test(hr.live,hr.dead,correct=F)
# Pearson's Chi-squared test
# data:  hr.live and hr.dead
# X-squared = 72, df = 64, p-value = 0.2303

######################
## Species and honey production
######################
species <- factor(SpeciesOverall)
levels(species)[levels(species)=="1"] <- "cerana"
levels(species)[levels(species)=="2"] <- "mellifera"
levels(species)[levels(species)=="3"] <- "carnica"
levels(species)[levels(species)=="4"] <- "ligustica"
levels(species)[levels(species)=="5"] <- "caucasica"
#levels(species)[levels(species)=="6"] <- "anatoliaca"
levels(species)[levels(species)=="7"] <- "hybrid"
levels(species)[levels(species)=="8"] <- "do_not_know"
levels(species)[levels(species)=="9"] <- "xin_jiang_hei_feng"
levels(species)[levels(species)=="10"]<- "dong_bei_hei_fen"
levels(species)[levels(species)=="99"]<- "Multiple species"

filter.sp <- !is.na(species)
filter.sphp <- filter.sp & filter.h
table(species[filter.sphp])

dg8 <- data.frame(per.col.hp[filter.sphp],species[filter.sphp])
ggplot(dg8, aes(x=species.filter.sphp.,y=per.col.hp.filter.sphp.)) + geom_boxplot() + xlab("Species") + ylab("Per colony honey production") + theme(axis.text.x = element_text(colour="black",size=rel(1.2)))


############################
### mortality and honey production
############################
plot(per.col.hp[filter.h],mortality[filter.h])
plot(per.col.hp[filter.h],trans.mortality[filter.h])
fit3 <- lm(mortality[filter.h] ~ per.col.hp[filter.h])
summary(fit3)  # slope *** 1.34e-08
coef(fit3)
    # (Intercept) per.col.hp[filter.h]
    # 0.0483942013         0.0005891718
dg9 <- data.frame(per.col.hp[filter.h],mortality[filter.h])
ggplot(dg9, aes(x=per.col.hp.filter.h.,y=mortality.filter.h.)) + geom_point() + geom_abline(intercept=0.0483942013,slope=0.0005891718)


################
# Mortality and operaton size
###############
fit4 <- lm(mortality ~ NOct)
summary(fit4)
plot(NOct,mortality, xlim=c(0,1000))
plot(NOct,mortality)

plot(NOct,mortality, xlim=c(0,500))
plot(NOct,mortality, xlim=c(0,200))
plot(NOct,mortality, xlim=c(0,100))

# chi-square test of proportions
loss_count <- c( sum(WintLoss[NOct<=50]),sum(WintLoss[NOct>50 & NOct<=200]),sum(WintLoss[NOct>200]) )
total_count <- c( sum(NOct[NOct<=50]),sum(NOct[NOct>50 & NOct<=200]),sum(NOct[NOct>200]) )
left_count <- total_count - loss_count
t <- chisq.test(loss_count,left_count)
t

# Proportions test
loss_count <- c( sum(WintLoss[NOct<=50]),sum(WintLoss[NOct>50 & NOct<=200]),sum(WintLoss[NOct>200]) )
total_count <- c( sum(NOct[NOct<=50]),sum(NOct[NOct>50 & NOct<=200]),sum(NOct[NOct>200]) )
prop.test(loss_count,total_count,correct=F)


detach()