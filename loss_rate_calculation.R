#--------------------------------------+
# Function
#--------------------------------------+
mean_and_CI <- function(total,loss) {
    library(boot)
    loss_rate <- sum(loss)/sum(total)
    left <- total - loss
    d <- data.frame(loss,left)
    fit <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=d,na.action=na.omit)
    ## 95% confidence interval:
    intercept.this <- summary(fit)$coefficients[1]
    std_err <- summary(fit)$coefficients[,2]
    df <- summary(fit)$df[2]
    lower.CI <- inv.logit(intercept.this - qt(0.975,df=df)*std_err)
    upper.CI <- inv.logit(intercept.this + qt(0.975,df=df)*std_err)
    out <- c(loss_rate, lower.CI, upper.CI)
    print(out)
}

#--------------------------------------+
# Setting up data for further analysis
#--------------------------------------+
library(ggplot2)
setwd("D:\\OneDrive\\Projects\\survey\\national")
dd <- read.table("all_v8.tab")

table(dd$province, dd$year)
# Filter our province-year combinations with very few entries
keep <- rep(TRUE, nrow(dd))
keep <- ifelse(dd$province=="420000", FALSE, keep)
keep <- ifelse(dd$province=="350000", FALSE, keep)
keep <- ifelse(dd$province=="220000" & dd$year=="11-12", FALSE, keep)
keep <- ifelse(dd$province=="320000" & dd$year=="09-10", FALSE, keep)
keep <- ifelse(dd$province=="340000" & dd$year=="12-13", FALSE, keep)

keep <- ifelse(dd$year=="08-09", FALSE, TRUE)
dd <- dd[keep,]

attach(dd)
summary(NOct)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#  2.0    55.0    83.0   120.1   135.0 17500.0
loss <- WintLoss
left <- NOct - WintLoss
summary(loss)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#  0.0     0.0     2.0    11.2    10.0  3500.0
summary(left)
# Min. 1st Qu.  Median    Mean 3rd Qu.    Max.
#  0.0    50.0    78.0   108.9   120.0 15000.0
dd <- cbind(dd,loss,left)


#----------------------------------------------+
# Overall loss rate
#----------------------------------------------+
# Fitting a quasibinomial intercept-only model
# for estimation of the overall loss rate
glm1 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),na.action=na.omit)
summary(glm1)
# Call:
# glm(formula = cbind(loss, left) ~ 1, family = quasibinomial(link = "logit"),
#     na.action = na.omit)
#
# Deviance Residuals:
#     Min       1Q   Median       3Q      Max
# -44.244   -3.957   -1.902    0.806  128.873
#
# Coefficients:
#             Estimate Std. Error t value Pr(>|t|)
# (Intercept) -2.27473    0.02457  -92.57   <2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# (Dispersion parameter for quasibinomial family taken to be 35.59208)
#
#     Null deviance: 157975  on 5802  degrees of freedom
# Residual deviance: 157975  on 5802  degrees of freedom
# AIC: NA
#
# Number of Fisher Scoring iterations: 5

## calculate the overall lost rate
glm1$fitted.values[1]  # 0.09323737
## OR:
sum(loss)/sum(NOct)    # 0.09323737
## OR:
i <- coef(glm1)
exp(i)/(1+exp(i))      # 0.09323737
# Note: What does this formula come from?
# With a probability p, the logit function gives the "log-odds",
# i.e. logit(p) = log( p/(1-p) )
# From the glm1 model above, we have a intercept value i
# ( i = coef(glm1) = -2.274732 )
# Now we want the original "p" value before it is logit transformed
# i.e. back-transformation: p = exp(i)/(1-exp(i))
# And now we have the value of "p", in this case the overall loss rate
## OR:
library(boot)
inv.logit(coef(glm1)) # 0.09323737

# Calculating a confidence interval for the overall loss rate
se <- 0.02478     # standard error from glm1 above
i  <- coef(glm1)  # intercept from glm1 above
upper.ci <- i+1.96*se
lower.ci <- i-1.96*se
inverse.logit.upper.ci <- exp(upper.ci)/(1+exp(upper.ci))
inverse.logit.lower.ci <- exp(lower.ci)/(1+exp(lower.ci))
inverse.logit.upper.ci  # 0.09738931
inverse.logit.lower.ci  # 0.08924494

#----------------------------------------------------------+
# Loss rate by year
#----------------------------------------------------------+
dd0809 <- dd[year=="08-09",]
dd0910 <- dd[year=="09-10",]
dd1011 <- dd[year=="10-11",]
dd1112 <- dd[year=="11-12",]
dd1213 <- dd[year=="12-13",]
length(dd0809$year)
length(dd0910$year)
length(dd1011$year)
length(dd1112$year)
length(dd1213$year)
length(dd$year)
sum(dd0809$NOct)
sum(dd0910$NOct)
sum(dd1011$NOct)
sum(dd1112$NOct)
sum(dd1213$NOct)
sum(dd$NOct)
summary(dd0809$NOct)
summary(dd0910$NOct)
summary(dd1011$NOct)
summary(dd1112$NOct)
summary(dd1213$NOct)
summary(dd$NOct)

glm0809 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=dd0809,na.action=na.omit)
glm0910 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=dd0910,na.action=na.omit)
glm1011 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=dd1011,na.action=na.omit)
glm1112 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=dd1112,na.action=na.omit)
glm1213 <- glm(cbind(loss,left)~1, family=quasibinomial(link="logit"),data=dd1213,na.action=na.omit)

overall_loss0809 <- sum(dd0809$loss)/sum(dd0809$NOct)  # [1] 0.1411831
overall_loss0910 <- sum(dd0910$loss)/sum(dd0910$NOct)  # [1] 0.02753464
overall_loss1011 <- sum(dd1011$loss)/sum(dd1011$NOct)  # [1] 0.09691446
overall_loss1112 <- sum(dd1112$loss)/sum(dd1112$NOct)  # [1] 0.1177559
overall_loss1213 <- sum(dd1213$loss)/sum(dd1213$NOct)  # [1] 0.09970994
overall_loss0809
overall_loss0910
overall_loss1011
overall_loss1112
overall_loss1213

## 95% CIs by year:
intercept0809 <- summary(glm0809)$coefficients[1]
std_err0809   <- summary(glm0809)$coefficients[,2]
df0809        <- summary(glm0809)$df[2]
inv.logit(intercept0809 + c(-1,1)*qt(0.975,df=df0809)*std_err0809)  # [1] 0.1217221 0.1631774
intercept0910 <- summary(glm0910)$coefficients[1]
std_err0910   <- summary(glm0910)$coefficients[,2]
df0910        <- summary(glm0910)$df[2]
inv.logit(intercept0910 + c(-1,1)*qt(0.975,df=df0910)*std_err0910)  # [1] 0.02332703 0.03247596
intercept1011 <- summary(glm1011)$coefficients[1]
std_err1011   <- summary(glm1011)$coefficients[,2]
df1011        <- summary(glm1011)$df[2]
inv.logit(intercept1011 + c(-1,1)*qt(0.975,df=df1011)*std_err1011)  # [1] 0.08988432 0.10443136
intercept1112 <- summary(glm1112)$coefficients[1]
std_err1112   <- summary(glm1112)$coefficients[,2]
df1112        <- summary(glm1112)$df[2]
inv.logit(intercept1112 + c(-1,1)*qt(0.975,df=df1112)*std_err1112)  # [1] 0.1073310 0.1290469
intercept1213 <- summary(glm1213)$coefficients[1]
std_err1213   <- summary(glm1213)$coefficients[,2]
df1213        <- summary(glm1213)$df[2]
inv.logit(intercept1213 + c(-1,1)*qt(0.975,df=df1213)*std_err1213)  # [1] 0.09289118 0.10697021

#----------------------------------------------------------+
# Loss rate of A. cerana
#----------------------------------------------------------+
ddca <- data.frame(loss=dd$WintLoss,left=dd$NOct-dd$WintLoss,cerana=cerana)
ddca <- na.omit(ddca)

ddc <- ddca[ddca$cerana==1,]
glm.c <- glm(cbind(ddc$loss,ddc$left)~1, family=quasibinomial(link="logit"),na.action=na.omit)
summary(glm.c)
glm.c$fitted.values[1]  # 0.1059857
se <- 0.03787     # standard error from glm1 above
i  <- coef(glm.c)  # intercept from glm1 above
upper.ci <- i+1.96*se
lower.ci <- i-1.96*se
inverse.logit.upper.ci <- exp(upper.ci)/(1+exp(upper.ci))
inverse.logit.lower.ci <- exp(lower.ci)/(1+exp(lower.ci))
inverse.logit.upper.ci  # 0.1132272
inverse.logit.lower.ci  # 0.09915554

ddnc <- ddca[ddca$cerana==0,]
glm.nc <- glm(cbind(ddnc$loss,ddnc$left)~1, family=quasibinomial(link="logit"),na.action=na.omit)
summary(glm.nc)
glm.nc$fitted.values[1]  # 0.08912593
se <- 0.03115     # standard error from glm1 above
i  <- coef(glm.nc)  # intercept from glm1 above
upper.ci <- i+1.96*se
lower.ci <- i-1.96*se
inverse.logit.upper.ci <- exp(upper.ci)/(1+exp(upper.ci))
inverse.logit.lower.ci <- exp(lower.ci)/(1+exp(lower.ci))
inverse.logit.upper.ci  # 0.09420836
inverse.logit.lower.ci  # 0.08429217
#----------------------------------------------------------+
# Loss rate by operation size (by year)
#----------------------------------------------------------+
ddt <- data.frame(year=year,total=NOct,loss=WintLoss)

### overall (5 years)
ddts <- ddt[ddt$total<=50,]
ddtm <- ddt[ddt$total>50 & ddt$total<=200,]
ddtl <- ddt[ddt$total>200,]
# Small
length(ddts$total)
sum(ddts$total)
summary(ddts$total)
mean_and_CI(ddts$total,ddts$loss)
# Medium
length(ddtm$total)
sum(ddtm$total)
summary(ddtm$total)
mean_and_CI(ddtm$total,ddtm$loss)
# Large
length(ddtl$total)
sum(ddtl$total)
summary(ddtl$total)
mean_and_CI(ddtl$total,ddtl$loss)

## Year by year for three different opetation sizes:
ff <- function(data,year,threshold.small=50,threshold.large=200){
    dds <- data[data$year==year & data$total<=threshold.small,]
    print("Small operations:")
    print( length(dds$total))
    print(    sum(dds$total))
    print(summary(dds$total))
    mean_and_CI(dds$total,dds$loss)

    ddm <- data[data$year==year & data$total>threshold.small & data$total<=threshold.large,]
    print("Medium operations:")
    print( length(ddm$total))
    print(    sum(ddm$total))
    print(summary(ddm$total))
    mean_and_CI(ddm$total,ddm$loss)

    ddl <- data[data$year==year & data$total> threshold.large,]
    print("Large operations:")
    print( length(ddl$total))
    print(    sum(ddl$total))
    print(summary(ddl$total))
    mean_and_CI(ddl$total,ddl$loss)
}

ff(ddt,"08-09")
ff(ddt,"09-10")
ff(ddt,"10-11")
ff(ddt,"11-12")
ff(ddt,"12-13")


#----------------------------------------------------------+
# Loss rate by province
#----------------------------------------------------------+
# Fitting a quasibinomial GZLM with one explanatory factor (province)
provinceF <- factor(province)
levels(provinceF)[levels(provinceF)=="140000"] <- "Shanxi"
levels(provinceF)[levels(provinceF)=="210000"] <- "Liaoning"
levels(provinceF)[levels(provinceF)=="220000"] <- "Jilin"
levels(provinceF)[levels(provinceF)=="230000"] <- "Heilongjiang"
levels(provinceF)[levels(provinceF)=="320000"] <- "Jiangsu"
levels(provinceF)[levels(provinceF)=="330000"] <- "Zhejiang"
levels(provinceF)[levels(provinceF)=="340000"] <- "Anhui"
#levels(provinceF)[levels(provinceF)=="350000"] <- "Fujian"
levels(provinceF)[levels(provinceF)=="410000"] <- "Henan"
#levels(provinceF)[levels(provinceF)=="420000"] <- "Hubei"
levels(provinceF)[levels(provinceF)=="440000"] <- "Guangdong"
levels(provinceF)[levels(provinceF)=="450000"] <- "Guangxi"
levels(provinceF)[levels(provinceF)=="460000"] <- "Hainan"
levels(provinceF)[levels(provinceF)=="500000"] <- "Chongqing"
levels(provinceF)[levels(provinceF)=="510000"] <- "Sichuan"
levels(provinceF)[levels(provinceF)=="530000"] <- "Yunnan"
levels(provinceF)[levels(provinceF)=="620000"] <- "Gansu"
levels(provinceF)[levels(provinceF)=="650000"] <- "Xinjiang"
table(provinceF)
# Shanxi     Liaoning        Jilin Heilongjiang      Jiangsu     Zhejiang
#    367          440          605          127          315          496
#  Anhui       Fujian        Henan        Hubei    Guangdong      Guangxi
#     78            3          298            6          614          347
# Hainan    Chongqing      Sichuan       Yunnan        Gansu     Xinjiang
#    299          299          235          316          536          422

i=65
sum(NOct[year=="08-09"])
sum(NOct[year=="09-10"])
sum(NOct[year=="10-11"])
sum(NOct[year=="11-12"])
sum(NOct[year=="12-13"])
summary(NOct[province==i*10000])

glm2 <- glm(cbind(loss,left)~provinceF, family=quasibinomial(link="logit"),na.action=na.omit)
summary(glm2)
# Call:
# glm(formula = cbind(loss, left) ~ provinceF, family = quasibinomial(link = "logit"),
#     na.action = na.omit)
#
# Deviance Residuals:
#     Min       1Q   Median       3Q      Max
# -35.982   -3.360   -1.411    1.151  108.710
#
# Coefficients:
#                        Estimate Std. Error t value Pr(>|t|)
# (Intercept)            -2.68729    0.15137 -17.754  < 2e-16 ***
# provinceFLiaoning      -0.09988    0.20233  -0.494  0.62156
# provinceFJilin          0.20416    0.17759   1.150  0.25035
# provinceFHeilongjiang   0.29039    0.23714   1.225  0.22079
# provinceFJiangsu       -0.16792    0.20245  -0.829  0.40690
# provinceFZhejiang      -0.34597    0.17752  -1.949  0.05135 .
# provinceFAnhui          0.15111    0.26644   0.567  0.57064
# provinceFFujian         1.20191    0.80645   1.490  0.13618
# provinceFHenan          1.04064    0.18099   5.750 9.39e-09 ***
# provinceFHubei        -11.69129  173.33992  -0.067  0.94623
# provinceFGuangdong      0.42701    0.16404   2.603  0.00926 **
# provinceFGuangxi        0.74602    0.17537   4.254 2.13e-05 ***
# provinceFHainan         0.77937    0.18730   4.161 3.21e-05 ***
# provinceFChongqing     -0.01764    0.19121  -0.092  0.92649
# provinceFSichuan        0.07214    0.17810   0.405  0.68544
# provinceFYunnan         0.10367    0.18762   0.553  0.58059
# provinceFGansu         -1.05732    0.24023  -4.401 1.10e-05 ***
# provinceFXinjiang       1.20340    0.15709   7.660 2.16e-14 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
#
# (Dispersion parameter for quasibinomial family taken to be 30.69705)
#
#     Null deviance: 157975  on 5802  degrees of freedom
# Residual deviance: 138248  on 5785  degrees of freedom
# AIC: NA
#
# Number of Fisher Scoring iterations: 9
#


# Testing factor significance, and
# obtaining confidence intercals for log odds of loss per region
anova(glm2,test="F")
# Analysis of Deviance Table
# Model: quasibinomial, link: logit
# Response: cbind(loss, left)
# Terms added sequentially (first to last)
#      Df Deviance Resid. Df Resid. Dev      F    Pr(>F)
# NULL                  5802     157975
# p.   17    19727      5785     138248 37.803 < 2.2e-16 ***
# ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

## Odds, probabilities and corresponding CIs acan be calculated for the factor levels. For all the regions, requesting standard errors for calculation of confidence interval:
values <- predict(glm2,data.frame(provinceF=levels(provinceF)),type="link",se.fit=T)
logodds <- values$fit
lowerlim <- values$fit - qt(0.975,df=5785)*values$se.fit
upperlim <- values$fit + qt(0.975,df=5785)*values$se.fit
cbind(lowerlim,logodds,upperlim)
#       lowerlim    logodds     upperlim
# 1    -2.984024  -2.687291  -2.39055783
# 2    -3.050362  -2.787173  -2.52398463
# 3    -2.665199  -2.483133  -2.30106669
# 4    -2.754763  -2.396900  -2.03903696
# 5    -3.118771  -2.855209  -2.59164633
# 6    -3.215063  -3.033258  -2.85145229
# 7    -2.966037  -2.536182  -2.10632658
# 8    -3.038238  -1.485385   0.06746789
# 9    -1.841159  -1.646650  -1.45214171
# 10 -354.189552 -14.378580 325.43239215
# 11   -2.384254  -2.260285  -2.13631577
# 12   -2.114877  -1.941272  -1.76766570
# 13   -2.124168  -1.907918  -1.69166683
# 14   -2.933982  -2.704933  -2.47588369
# 15   -2.799134  -2.615149  -2.43116360
# 16   -2.800958  -2.583618  -2.36627822
# 17   -4.110301  -3.744606  -3.37891223
# 18   -1.566281  -1.483896  -1.40151005

# Obtaining confidence intervals for the odds of loss and the model coefficients
## Approximate 95% CI for the odds of loss per region, given as the lower limit, odds and upper limit respexticely:
odds <- exp(logodds)
cbind(exp(lowerlim),odds,exp(upperlim))
#                          odds
# 1   5.058883e-02 6.806507e-02  9.157858e-02
# 2   4.734177e-02 6.159507e-02  8.013964e-02
# 3   6.958549e-02 8.348127e-02  1.001520e-01
# 4   6.362413e-02 9.099964e-02  1.301540e-01
# 5   4.421147e-02 5.754381e-02  7.489663e-02
# 6   4.015280e-02 4.815849e-02  5.776037e-02
# 7   5.150703e-02 7.916810e-02  1.216841e-01
# 8   4.791923e-02 2.264151e-01  1.069796e+00
# 9   1.586335e-01 1.926943e-01  2.340684e-01
# 10 1.504637e-154 5.694584e-07 2.155223e+141
# 11  9.215769e-02 1.043208e-01  1.180891e-01
# 12  1.206481e-01 1.435213e-01  1.707311e-01
# 13  1.195323e-01 1.483891e-01  1.842122e-01
# 14  5.318482e-02 6.687481e-02  8.408865e-02
# 15  6.086274e-02 7.315690e-02  8.793445e-02
# 16  6.075183e-02 7.550034e-02  9.382929e-02
# 17  1.640284e-02 2.364493e-02  3.408451e-02
# 18  2.088203e-01 2.267526e-01  2.462249e-01

## Approximate 95% CIs for the odds ratios per region, relative to the reference regions, can be obtained from 95% CIs for the coefficients in the model, which we find first:
coeffs <- summary(glm2)$coef[,1]
se.coeffs <- summary(glm2)$coef[,2]
coeffs.lowerlim <- coeffs - qt(0.975,df=5785)*se.coeffs
coeffs.upperlim <- coeffs + qt(0.975,df=5785)*se.coeffs
coeffs.CIs <- cbind(coeffs.lowerlim,coeffs.upperlim)
## CIs for the model coefficients:
coeffs.CIs
#                       coeffs.lowerlim coeffs.upperlim
# (Intercept)                -2.9840245     -2.39055783
# provinceFLiaoning          -0.4965170      0.29675229
# provinceFJilin             -0.1439780      0.55229435
# provinceFHeilongjiang      -0.1744919      0.75527464
# provinceFJiangsu           -0.5648000      0.22896505
# provinceFZhejiang          -0.6939664      0.00203323
# provinceFAnhui             -0.3712183      0.67343699
# provinceFFujian            -0.3790443      2.78285609
# provinceFHenan              0.6858392      1.39544256
# provinceFHubei           -351.5023908    328.11981285
# provinceFGuangdong          0.1054179      0.74859445
# provinceFGuangxi            0.4022324      1.08980681
# provinceFHainan             0.4122019      1.14654527
# provinceFChongqing         -0.3924941      0.35721047
# provinceFSichuan           -0.2770013      0.42128585
# provinceFYunnan            -0.2641412      0.47148722
# provinceFGansu             -1.5282536     -0.58637696
# provinceFXinjiang           0.8954375      1.51135329

# Obtaining confidence intervals for odds ratios
# and probability of loss, per region
odds.ratios <- exp(coeffs)
odds.ratios.CIs <-cbind(exp(coeffs.lowerlim),odds.ratios,exp(coeffs.upperlim))
## The CIs for the odds ratios (excluding the baseline category) are as follows, given as the lower limit, odds ratio and upper limit respectively:
odds.ratios.CIs[-1,]
#                                      odds.ratios
# provinceFLiaoning      6.086469e-01 9.049439e-01  1.345482e+00
# provinceFJilin         8.659068e-01 1.226492e+00  1.737234e+00
# provinceFHeilongjiang  8.398837e-01 1.336951e+00  2.128196e+00
# provinceFJiangsu       5.684738e-01 8.454236e-01  1.257298e+00
# provinceFZhejiang      4.995905e-01 7.075361e-01  1.002035e+00
# provinceFAnhui         6.898933e-01 1.163124e+00  1.960966e+00
# provinceFFujian        6.845153e-01 3.326451e+00  1.616512e+01
# provinceFHenan         1.985437e+00 2.831031e+00  4.036761e+00
# provinceFHubei        2.210300e-153 8.366382e-06 3.166825e+142
# provinceFGuangdong     1.111175e+00 1.532662e+00  2.114027e+00
# provinceFGuangxi       1.495159e+00 2.108590e+00  2.973700e+00
# provinceFHainan        1.510139e+00 2.180106e+00  3.147301e+00
# provinceFChongqing     6.753704e-01 9.825129e-01  1.429337e+00
# provinceFSichuan       7.580535e-01 1.074808e+00  1.523920e+00
# provinceFYunnan        7.678651e-01 1.109238e+00  1.602376e+00
# provinceFGansu         2.169142e-01 3.473872e-01  5.563393e-01
# provinceFXinjiang      2.448407e+00 3.331409e+00  4.532861e+00

## 95% CI and point eztimates fo the probability of loss for each region, given as the lower limit, estimated probability and upper limit respectively:
library(boot)
prob <- inv.logit(logodds)
cbind(inv.logit(lowerlim),prob,inv.logit(upperlim))
#                          prob
# 1   4.815284e-02 6.372745e-02 0.08389555
# 2   4.520183e-02 5.802124e-02 0.07419378
# 3   6.505837e-02 7.704911e-02 0.09103466
# 4   5.981824e-02 8.340941e-02 0.11516483
# 5   4.233958e-02 5.441270e-02 0.06967799
# 6   3.860279e-02 4.594581e-02 0.05460629
# 7   4.898401e-02 7.336031e-02 0.10848343
# 8   4.572798e-02 1.846154e-01 0.51686058
# 9   1.369143e-01 1.615622e-01 0.18967217
# 10 1.504637e-154 5.694581e-07 1.00000000
# 11  8.438130e-02 9.446599e-02 0.10561690
# 12  1.076592e-01 1.255082e-01 0.14583286
# 13  1.067699e-01 1.292150e-01 0.15555676
# 14  5.049904e-02 6.268290e-02 0.07756621
# 15  5.737098e-02 6.816980e-02 0.08082698
# 16  5.727242e-02 7.020020e-02 0.08578056
# 17  1.613813e-02 2.309876e-02 0.03296105
# 18  1.727471e-01 1.848397e-01 0.19757660



for(prov in c("Shanxi", "Liaoning", "Jilin", "Heilongjiang", "Jiangsu", "Zhejiang", "Anhui", "Henan", "Guangdong", "Guangxi", "Hainan", "Chongqing", "Sichuan", "Yunnan", "Gansu", "Xinjiang")) {
    temp <- dd[provinceF == prov,]
    print(prov)
    print(nrow(temp))
    print(sum(temp$NOct))
    print(summary(temp$NOct))
}
table(provinceF, dd$year)
#####################################################
detach()