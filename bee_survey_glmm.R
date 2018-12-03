library(lme4)
library(ggplot2)
setwd("D:\\AeroFS\\Projects\\survey\\2stats")

#-----------------------------
## Getting data ready
#-----------------------------
dd <- read.table("data\\all_v3.tab")
attach(dd)
length(dd$NOct)  # 5803
# Loss
total <- NOct
loss <- WintLoss
left <- total - loss
# Number of Queen Change
nqc <- NQueenChange
nqc <- ifelse(nqc<=5 & nqc>0,nqc,NA)  ## ‘0’ 被排除出去，因为含义不明（没有换蜂王/没有填写本条数据）
length(na.omit(nqc))  # 3974
# ID for entry, i.e. for each bee keeper
entryID <- 1:5803
# If the species is A.cerana
#levels(species)[levels(species)=="1"] <- "cerana"
#levels(species)[levels(species)=="2"] <- "mellifera"
#levels(species)[levels(species)=="3"] <- "carnica"
#levels(species)[levels(species)=="4"] <- "ligustica"
#levels(species)[levels(species)=="5"] <- "caucasica"
#levels(species)[levels(species)=="6"] <- "anatoliaca"
#levels(species)[levels(species)=="7"] <- "hybrid"
#levels(species)[levels(species)=="8"] <- "do_not_know"
#levels(species)[levels(species)=="9"] <- "xin_jiang_hei_feng"
#levels(species)[levels(species)=="10"]<- "dong_bei_hei_fen"
#levels(species)[levels(species)=="99"]<- "Multiple species"
table(SpeciesOverall)
is.cerana <- ifelse(SpeciesOverall=="1",1,0)
# Per colony honey production
hp <- HoneyProduction
decider <- year=="09-10" | year=="10-11" & HoneyProduction<=60
    # Note:
    # 产蜜数据仅留09-10,10-11,其它年的要么没有，要么不靠谱
    # 09-10年产蜜数据为“平均每群产蜜量”
    # 人工检查推测，10-11年“产蜜量”低于60的填写的其实是“平均每群产蜜量”，而不是“总产蜜量”
per.col.hp <- ifelse(decider, hp, hp/NOct)
# Threatens
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

dd2 <- data.frame(loss=loss,
                  left=left,
                  province=province,
                  beeKeeper=entryID,
                  year=year,
                  nqc=nqc,
                  hp=per.col.hp,
                  vt=MtOrNot,
                  species=is.cerana,
                  threaten=threatens)

dd3 <- data.frame(loss=loss,
                  left=left,
                  province=province,
                  beeKeeper=entryID,
                  year=year,
                  nqc=nqc,
                  vt=dd$MtOrNot,
                  hp=per.col.hp,
                  threaten=threatens)
dd3 <- na.omit(dd3)
dd4 <- data.frame(loss=loss,
                  left=left,
                  province=province,
                  beeKeeper=entryID,
                  year=year,
                  nqc=nqc,
                  vt=MtOrNot,
                  threaten=threatens)
dd4 <- na.omit(dd4)
length(dd4$year)
detach()
attach(dd2)


### Analysis - modelling
# Null model
#glm.null <- glmer(cbind(loss,left) ~ (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
# One at a time, using dd2
glm.year <- glmer(cbind(loss,left) ~ year     + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
glm.nqc  <- glmer(cbind(loss,left) ~ nqc      + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
glm.hp   <- glmer(cbind(loss,left) ~ hp       + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
glm.vt   <- glmer(cbind(loss,left) ~ vt       + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
glm.thrn <- glmer(cbind(loss,left) ~ threaten + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
glm.spe  <- glmer(cbind(loss,left) ~ species  + (1|province) + (1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)
# Full model using dd3
glm.null <- glmer(cbind(loss,left) ~ (1|province)+(1|beeKeeper), data=dd3,family=binomial("logit"),na.actioin=na.omit)
glm.full <- glmer(cbind(loss,left) ~ year+vt+nqc+hp+(1|province)+(1|beeKeeper), data=dd2,family=binomial("logit"),na.action=na.omit)

# Full minus hp
glm.mhp  <- glmer(cbind(loss,left) ~ year+vt+nqc+   (1|province)+(1|beeKeeper), data=dd3,family=binomial("logit"),na.action=na.omit)
summary(glm.year)
summary(glm.nqc)
summary(glm.hp)
summary(glm.vt)
summary(glm.thrn)
summary(glm.spe)
summary(glm.null)
summary(glm.mhp)
table(dd2$threaten)
# CI for nqc
summary(glm.nqc)
coef <- getME(glm.nqc,"beta")
se   <- c(0.22568,0.05153)
coef.lowerlim <- coef - qt(0.975,df=3974)*se
coef.upperlim <- coef + qt(0.975,df=3974)*se
library(boot)
odds.ratios <- exp(coef)
odds.ratios.lower <- exp(coef.lowerlim)
odds.ratios.upper <- exp(coef.upperlim)
tttt<- data.frame(oddsRatio=odds.ratios,lowerCI=odds.ratios.lower,upperCI=odds.ratios.upper)
tttt
# CI for hp
summary(glm.hp)
coef <- getME(glm.hp,"beta")
se   <- c(0.241718,0.001149)
coef.lowerlim <- coef - qt(0.975,df=5535)*se
coef.upperlim <- coef + qt(0.975,df=5535)*se
library(boot)
odds.ratios <- exp(coef)
odds.ratios.lower <- exp(coef.lowerlim)
odds.ratios.upper <- exp(coef.upperlim)
tttt<- data.frame(oddsRatio=odds.ratios,lowerCI=odds.ratios.lower,upperCI=odds.ratios.upper)
tttt
# CI for vt
summary(glm.vt)
coef <- getME(glm.vt,"beta")
se   <- c(0.2309,0.1046)
coef.lowerlim <- coef - qt(0.975,df=4518)*se
coef.upperlim <- coef + qt(0.975,df=4518)*se
library(boot)
odds.ratios <- exp(coef)
odds.ratios.lower <- exp(coef.lowerlim)
odds.ratios.upper <- exp(coef.upperlim)
tttt<- data.frame(oddsRatio=odds.ratios,lowerCI=odds.ratios.lower,upperCI=odds.ratios.upper)
tttt
# threatens
fixef(glm.thrn)
coef.thrn   <- getME(glm.thrn,"beta")
se.thrn <- c(0.37138,1.28759,0.71684,1.57730,0.18882,0.82746,0.31497,0.24972,0.24900,1.62874,0.30341,0.47454,0.35221,0.27322)
coef.lowerlim <- coef.thrn - qt(0.975,df=2517)*se.thrn
coef.upperlim <- coef.thrn + qt(0.975,df=2517)*se.thrn
library(boot)
odds.ratios <- exp(coef.thrn)
odds.ratios.lower <- exp(coef.lowerlim)
odds.ratios.upper <- exp(coef.upperlim)
fffff <- data.frame(oddsRatio=odds.ratios,lowerCI=odds.ratios.lower,upperCI=odds.ratios.upper)
fffff

# Another glmm to test threatens, using the individual threaten columns (instead of the ThreatenOverall column)
detach(dd2)
attach(dd)
ddt <- data.frame(year=year,
                  province=province,
                  loss=loss,
                  left=left,
                  beeKeeper=entryID,
                  mouse=mouse,
                  bear=bear,
                  ant=ant,
                  poison=poison,
                  mite=mite,
                  bird=beeEater,
                  hornet=hornet,
                  fire=fire,
                  storm=storm,
                  beatles=beatles,
                  human=human,
                  other=other,
                  otherD=otherDisease)
glm.thrn.individual <- glmer(cbind(loss,left) ~ mouse+bear+ant+poison+mite+bird+hornet+fire+storm+beatles+human+other+otherD+(1|province)+(1|beeKeeper), data=ddt,family=binomial("logit"),na.action=na.omit)
summary(glm.thrn.individual)
summary(CCD)
summary(CcdOrNot)

aa <- c(-1.5,-1.4,-1.3,-1.2,-1.1,-1,-0.9,-0.8,-0.7,-0.6,-0.5,-0.4,-0.3,-0.2,-0.1,0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1,1.1,1.2,1.3,1.4,1.5)
plot(aa,exp(aa))

detach()


#-----------------------------
# Modllling - practice
#-----------------------------
nullmodel <- lmer(NOct ~ MtOrNot + (1|province), data=dd2, REML=FALSE)
lmm <- lmer(NOct ~ year + (1|province), data=dd2, REML=FALSE)
glmm <- glmer(cbind(NOct,WintLoss) ~ MtOrNot + NOct + (1|province) + (1|year), data=dd2, family=binomial("logit"))
# 测试语法：
glmm <- glmer(cbind(NOct,WintLoss) ~ year + MtOrNot + (1|province), data=dd2, family=binomial("logit"),na.action=na.omit)
glmm2 <-glmer(cbind(NOct,WintLoss) ~ year + MtOrNot + (1|province) + (1|id), data=dd2, family=binomial("logit"),na.action=na.omit)
# 测试通过！
### End of practice