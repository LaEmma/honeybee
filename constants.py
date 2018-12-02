# -*- coding: utf-8 -*-

class BaseDataImportFields1(object):
    # 13-14， 14-15年标题比较相似
    '''
    换王方式： QCol自然更换  QOp 自己育王 QBreed 购买蜂王
    换王次数： QChange
    ''' 
    PROVINCEID = 'ProvinceID'
    CDS = 'CDS'
    LOSSNOFEED = 'LossNoFeed'
    LOSSFEED = 'LossFeed'
    QPROBLEM = 'QProblem'
    WINTDECREASE = 'WintDecreae'
    WINTMERGE = 'WintMerge'
    WINTSOLD = 'WintSold'
    WINTSPLIT = 'WintSplit'
    RACE = 'Race'
    OTHERRACE = 'OtherRace'
    QCOL = 'QCol'
    QOP = 'QOp'
    QBREED = 'QBreed'
    QCHANGE = 'QChange'
    QNEW = 'Qnew'
    PERCPOLSERV = 'PercPolServ'
    NUMPOLSERV = 'NumPolServ'
    NUMPOLSERVFREE = 'NumPolSerFree'
    PERMOVEHON = 'PerMoveHon'
    RAPE = 'Rape'
    LITCHI = 'Litchi'
    LONGAN = 'Longan'
    LOQUAT = 'Loquat'
    SUNFLOWER = 'Sunflower'
    LOCUST = 'Locust'
    JUJUBE = 'Jujube'
    VITEX = 'Vitex'
    LINDEN = 'Linden'
    OTHERNECTAR = 'OtherNectar'
    DEWHIVE = 'DewHive'
    COMB = 'Comb'
    SUPPHONEY = 'SuppHoney'
    SUPPBSUGAR = 'SuppBSugar'
    SUPPBINVERT = 'SuppBInvert'
    SUPPHFCS = 'SuppHFCS'
    SUPPOTHER = 'SuppOther'

    fields = {
        PROVINCEID: 'ProvinceID',
        CDS: 'CDS',
        LOSSNOFEED: 'LossNoFeed',
        LOSSFEED: 'LossFeed',
        QPROBLEM: 'QProblem',
        WINTDECREASE: 'WintDecrease',
        WINTMERGE: 'WintMerge',
        WINTSOLD: 'WintSold',
        WINTSPLIT: 'WintSplit',
        RACE: 'Race',
        OTHERRACE: 'OtherRace',
        QCOL: 'QCol',
        QOP: 'QOp',
        QBREED: 'QBreed',
        QCHANGE: 'QChange',
        QNEW: 'Qnew',
        PERCPOLSERV: 'PercPolServ',
        NUMPOLSERV: 'NumPolServ',
        NUMPOLSERVFREE: 'NumPolServFree',
        PERMOVEHON: 'PerMoveHon',
        RAPE: 'Rape',
        LITCHI: 'Litchi',
        LONGAN: 'Longan',
        LOQUAT: 'Loquat',
        SUNFLOWER: 'Sunflower',
        LOCUST: 'Locust',
        JUJUBE: 'Jujube',
        VITEX: 'Vitex',
        LINDEN: 'Linden',
        OTHERNECTAR: 'OtherNectar',
        DEWHIVE: 'DewHive',
        COMB: 'Comb',
        SUPPHONEY: 'SuppHoney',
        SUPPBSUGAR: 'SuppBSugar',
        SUPPBINVERT: 'SuppBInvert',
        SUPPHFCS: 'SuppHFCS',
        SUPPOTHER: 'SuppOther',

    }

class DataImportFields1314(BaseDataImportFields1):
    # VT011 后面三位数字，第一位表示第几年，后面两位表示月份
    # VT011 表示第一年11月份，即13年11月份
    COL_INIT_OCT = 'COL_INIT_OCT'
    COL_LOSS = 'COL_LOSS'
    COL_INIT_APR = 'COL_INIT_APR'
    COL_END_APR = 'COL_END_APR'
    VT = 'VT',
    VT_ALL = 'VT_ALL'
    VT011 = 'VT011'
    VT012 = 'VT012'
    VT101 = 'VT101'
    VT102 = 'VT102'
    VT103 = 'VT103'
    VT104 = 'VT104'
    VT105 = 'VT105'
    VT106 = 'VT106'
    VT107 = 'VT107'
    VT108 = 'VT108'
    VT109 = 'VT109'
    VT110 = 'VT110'
    VT111 = 'VT111'
    VT112 = 'VT112'
    VT201 = 'VT201'
    VT202 = 'VT202'
    VT203 = 'VT203'
    PROVINCEID = 'ProvinceID'
    CDS = 'CDS'
    LOSSNOFEED = 'LossNoFeed'
    LOSSFEED = 'LossFeed'
    QPROBLEM = 'QProblem'
    WINTDECREASE = 'WintDecreae'
    WINTMERGE = 'WintMerge'
    WINTSOLD = 'WintSold'
    WINTSPLIT = 'WintSplit'
    RACE = 'Race'
    OTHERRACE = 'OtherRace'
    QCOL = 'QCol'
    QOP = 'QOp'
    QBREED = 'QBreed'
    QCHANGE = 'QChange'
    QNEW = 'Qnew'
    PERCPOLSERV = 'PercPolServ'
    NUMPOLSERV = 'NumPolServ'
    NUMPOLSERVFREE = 'NumPolSerFree'
    PERMOVEHON = 'PerMoveHon'
    RAPE = 'Rape'
    LITCHI = 'Litchi'
    LONGAN = 'Longan'
    LOQUAT = 'Loquat'
    SUNFLOWER = 'Sunflower'
    LOCUST = 'Locust'
    JUJUBE = 'Jujube'
    VITEX = 'Vitex'
    LINDEN = 'Linden'
    OTHERNECTAR = 'OtherNectar'
    DEWHIVE = 'DewHive'
    COMB = 'Comb'
    SUPPHONEY = 'SuppHoney'
    SUPPBSUGAR = 'SuppBSugar'
    SUPPBINVERT = 'SuppBInvert'
    SUPPHFCS = 'SuppHFCS'
    SUPPOTHER = 'SuppOther'

    fields = {
        COL_INIT_OCT: 'ColOct13',
        COL_LOSS: 'Loss13-14',
        COL_INIT_APR: 'ColApr13',
        COL_END_APR: 'ColApr14',
        VT: 'VT',
        VT_ALL: 'VT13All',
        VT011: 'VT11-12',
        VT012: 'VT12-12',
        VT101: 'VT01-13',
        VT102: 'VT02-13',
        VT103: 'VT03-13',
        VT104: 'VT04-13',
        VT105: 'VT05-13',
        VT106: 'VT06-13',
        VT107: 'VT07-13',
        VT108: 'VT08-13',
        VT109: 'VT09-13',
        VT110: 'VT10-13',
        VT111: 'VT11-13',
        VT112: 'VT12-13',
        VT201: 'VT01-14',
        VT202: 'VT02-14',
        VT203: 'VT03-14',
        PROVINCEID: 'ProvinceID',
        CDS: 'CDS',
        LOSSNOFEED: 'LossNoFeed',
        LOSSFEED: 'LossFeed',
        QPROBLEM: 'QProblem',
        WINTDECREASE: 'WintDecrease',
        WINTMERGE: 'WintMerge',
        WINTSOLD: 'WintSold',
        WINTSPLIT: 'WintSplit',
        RACE: 'Race',
        OTHERRACE: 'OtherRace',
        QCOL: 'QCol',
        QOP: 'QOp',
        QBREED: 'QBreed',
        QCHANGE: 'QChange',
        QNEW: 'Qnew',
        PERCPOLSERV: 'PercPolServ',
        NUMPOLSERV: 'NumPolServ',
        NUMPOLSERVFREE: 'NumPolServFree',
        PERMOVEHON: 'PerMoveHon',
        RAPE: 'Rape',
        LITCHI: 'Litchi',
        LONGAN: 'Longan',
        LOQUAT: 'Loquat',
        SUNFLOWER: 'Sunflower',
        LOCUST: 'Locust',
        JUJUBE: 'Jujube',
        VITEX: 'Vitex',
        LINDEN: 'Linden',
        OTHERNECTAR: 'OtherNectar',
        DEWHIVE: 'DewHive',
        COMB: 'Comb',
        SUPPHONEY: 'SuppHoney',
        SUPPBSUGAR: 'SuppBSugar',
        SUPPBINVERT: 'SuppBInvert',
        SUPPHFCS: 'SuppHFCS',
        SUPPOTHER: 'SuppOther',

    }


class DataImportFields1415(BaseDataImportFields1):
    COL_INIT_OCT = 'COL_INIT_OCT'
    COL_LOSS = 'COL_LOSS'
    COL_INIT_APR = 'COL_INIT_APR'
    COL_END_APR = 'COL_END_APR'
    VT = 'VT',
    VT_ALL = 'VT_ALL'
    VT011 = 'VT011'
    VT012 = 'VT012'
    VT101 = 'VT101'
    VT102 = 'VT102'
    VT103 = 'VT103'
    VT104 = 'VT104'
    VT105 = 'VT105'
    VT106 = 'VT106'
    VT107 = 'VT107'
    VT108 = 'VT108'
    VT109 = 'VT109'
    VT110 = 'VT110'
    VT111 = 'VT111'
    VT112 = 'VT112'
    VT201 = 'VT201'
    VT202 = 'VT202'
    VT203 = 'VT203'
    PROVINCEID = 'ProvinceID'
    CDS = 'CDS'
    LOSSNOFEED = 'LossNoFeed'
    LOSSFEED = 'LossFeed'
    QPROBLEM = 'QProblem'
    WINTDECREASE = 'WintDecreae'
    WINTMERGE = 'WintMerge'
    WINTSOLD = 'WintSold'
    WINTSPLIT = 'WintSplit'
    RACE = 'Race'
    OTHERRACE = 'OtherRace'
    QCOL = 'QCol'
    QOP = 'QOp'
    QBREED = 'QBreed'
    QCHANGE = 'QChange'
    QNEW = 'Qnew'
    PERCPOLSERV = 'PercPolServ'
    NUMPOLSERV = 'NumPolServ'
    NUMPOLSERVFREE = 'NumPolSerFree'
    PERMOVEHON = 'PerMoveHon'
    RAPE = 'Rape'
    LITCHI = 'Litchi'
    LONGAN = 'Longan'
    LOQUAT = 'Loquat'
    SUNFLOWER = 'Sunflower'
    LOCUST = 'Locust'
    JUJUBE = 'Jujube'
    VITEX = 'Vitex'
    LINDEN = 'Linden'
    OTHERNECTAR = 'OtherNectar'
    DEWHIVE = 'DewHive'
    COMB = 'Comb'
    SUPPHONEY = 'SuppHoney'
    SUPPBSUGAR = 'SuppBSugar'
    SUPPBINVERT = 'SuppBInvert'
    SUPPHFCS = 'SuppHFCS'
    SUPPOTHER = 'SuppOther'

    fields = {
        COL_INIT_OCT: 'ColOct14',
        COL_LOSS: 'Loss14-15',
        COL_INIT_APR: 'ColApr14',
        COL_END_APR: 'ColApr15',
        VT: 'VT',
        VT_ALL: 'VT14All',
        VT011: 'VT11-13',
        VT012: 'VT12-13',
        VT101: 'VT01-14',
        VT102: 'VT02-14',
        VT103: 'VT03-14',
        VT104: 'VT04-14',
        VT105: 'VT05-14',
        VT106: 'VT06-14',
        VT107: 'VT07-14',
        VT108: 'VT08-14',
        VT109: 'VT09-14',
        VT110: 'VT10-14',
        VT111: 'VT11-14',
        VT112: 'VT12-14',
        VT201: 'VT01-15',
        VT202: 'VT02-15',
        VT203: 'VT03-15',
        PROVINCEID: 'ProvinceID',
        CDS: 'CDS',
        LOSSNOFEED: 'LossNoFeed',
        LOSSFEED: 'LossFeed',
        QPROBLEM: 'QProblem',
        WINTDECREASE: 'WintDecrease',
        WINTMERGE: 'WintMerge',
        WINTSOLD: 'WintSold',
        WINTSPLIT: 'WintSplit',
        RACE: 'Race',
        OTHERRACE: 'OtherRace',
        QCOL: 'QCol',
        QOP: 'QOp',
        QBREED: 'QBreed',
        QCHANGE: 'QChange',
        QNEW: 'Qnew',
        PERCPOLSERV: 'PercPolServ',
        NUMPOLSERV: 'NumPolServ',
        NUMPOLSERVFREE: 'NumPolServFree',
        PERMOVEHON: 'PerMoveHon',
        RAPE: 'Rape',
        LITCHI: 'Litchi',
        LONGAN: 'Longan',
        LOQUAT: 'Loquat',
        SUNFLOWER: 'Sunflower',
        LOCUST: 'Locust',
        JUJUBE: 'Jujube',
        VITEX: 'Vitex',
        LINDEN: 'Linden',
        OTHERNECTAR: 'OtherNectar',
        DEWHIVE: 'DewHive',
        COMB: 'Comb',
        SUPPHONEY: 'SuppHoney',
        SUPPBSUGAR: 'SuppBSugar',
        SUPPBINVERT: 'SuppBInvert',
        SUPPHFCS: 'SuppHFCS',
        SUPPOTHER: 'SuppOther',
    }


class BaseDataImportFields2(object):
    # 15-16， 16-17年标题比较相似
    CDS = "CDS"
    LOSSNOFEED = "LossNoFeed"
    LOSSFEED = "LossFeed"
    QPROBLEM = "Qproblem"
    WINDECREASE = "WinDecrease"
    WINTMERGESOLD = "WintMergeSold"
    WINSPLIT = "WinSplit"
    RACE = "Race"
    QSOURCE = "QSource"
    QCHANGE = "QChange"
    QPROBLEM= "QProblem"
    NUMPOLSERVFREE = "NumPolServFree"
    NUMPOLSERV = "NumPolServ"
    HONEYINTAKE = "HoneyINTake"
    COMB = "Comb"
    SUPPLY = "Supply"

    fields = {
        CDS: 'CDS',
        LOSSNOFEED: "LossNoFeed",
        LOSSFEED: "LossFeed",
        QPROBLEM: "Qproblem",
        WINDECREASE: "WinDecrease",
        WINTMERGESOLD: "WintMerge/Sold",
        WINSPLIT: "WinSplit",
        RACE: "Race",
        QSOURCE: "蜂王的来源",
        QCHANGE: "QChange",
        QPROBLEM: "有多少群是由于蜂王有问题而换王的（蜂王伤残或产卵有问题）",
        NUMPOLSERVFREE: "NumPolServFree",
        NUMPOLSERV: "NumPolServ",
        HONEYINTAKE: "越冬期间有没有,可能将甘露蜜带入蜂巢",
        COMB: "Comb",
        SUPPLY: "SuppHoney/Sugar/Inver/HFCS/other",
    }



class DataImportFields1516(BaseDataImportFields2):

    PROVINCE = "Province"
    COL_INIT_OCT = "COL_INIT_OCT"
    COL_LOSS = "COL_LOSS"
    COL_INIT_APR = "COL_INIT_APR"
    COL_END_APR = "COL_END_APR"
    PERMOVEHON = "PerMoveHon"
    NECTAR = "Nectar"
    VT = "VT"
    VT_ALL = "VT_ALL"
    VTXX = "VTXX"
    CDS = "CDS"
    LOSSNOFEED = "LossNoFeed"
    LOSSFEED = "LossFeed"
    QPROBLEM = "Qproblem"
    WINDECREASE = "WinDecrease"
    WINTMERGESOLD = "WintMergeSold"
    WINSPLIT = "WinSplit"
    RACE = "Race"
    QSOURCE = "QSource"
    QCHANGE = "QChange"
    QPROBLEM= "QProblem"
    NUMPOLSERVFREE = "NumPolServFree"
    NUMPOLSERV = "NumPolServ"
    HONEYINTAKE = "HoneyINTake"
    COMB = "Comb"
    SUPPLY = "Supply"

    fields = {
        PROVINCE: "Province",
        COL_INIT_OCT: "ColOct15",
        COL_LOSS: "Loss15-16",
        COL_INIT_APR: "ColApr15",
        COL_END_APR: "ColApr16",
        PERMOVEHON: "PerMoveHon",
        NECTAR: "2015年您的蜂群采集的蜜源有",
        VT: "VT",
        VT_ALL: "VT15All",
        VTXX: "2014年11月-2016年3月间哪个月份治螨",
        CDS: 'CDS',
        LOSSNOFEED: "LossNoFeed",
        LOSSFEED: "LossFeed",
        QPROBLEM: "Qproblem",
        WINDECREASE: "WinDecrease",
        WINTMERGESOLD: "WintMerge/Sold",
        WINSPLIT: "WinSplit",
        RACE: "Race",
        QSOURCE: "蜂王的来源",
        QCHANGE: "QChange",
        QPROBLEM: "有多少群是由于蜂王有问题而换王的（蜂王伤残或产卵有问题）",
        NUMPOLSERVFREE: "NumPolServFree",
        NUMPOLSERV: "NumPolServ",
        HONEYINTAKE: "越冬期间有没有,可能将甘露蜜带入蜂巢",
        COMB: "Comb",
        SUPPLY: "SuppHoney/Sugar/Inver/HFCS/other",
    }

class DataImportFields1617(BaseDataImportFields2):
    '''
    导入excel中用的column name
    ProvinceID  
    ColOct16        蜂群数量
    Loss16-17       损失
    CDS             损失的蜂群中有几群没有在巢内或蜂场发现死蜂
     
    WintDecrease    10.1—次年4.1期间生产群群势减弱的数量
    WintMerge/Sold  10.1—次年4.1期间生产群合并或销售的数量
    WintSplit       10.1—次年4.1期间生产群分群或购买的数量
    ColApr16        4月生产群的数量
    ColApr17        4月生产群的数量
    Race            主要蜂种：杂交种 卡尼鄂拉蜂 欧洲黑蜂 意大利蜂 高加索蜂  新疆黑蜂 东北黑蜂 安纳托利亚蜂  东方蜜蜂/中蜂 
    蜂王的来源   
    QChange         换王的次数
    有多少群是由于蜂王有问题而换王的（蜂王伤残或产卵有问题）    
    NumPolServFree  
    NumPolServ  
    2016年进行转地的蜂群数   PerMoveOn
    2016年您的蜂群采集的蜜源有 
    越冬期间有没有可能将甘露蜜带入蜂巢     
    Comb            新脾比例
    SuppHoney/Sugar/Invert/HFUS 给蜂群饲喂过什么越冬补充饲料：蜂蜜 白糖  转化糖糖浆  果葡糖浆     
    VT16            蜂群是否治过蜂螨
    VT16All         蜂场内所有蜂群是否同时治螨
    VT##-**         2012年11月-2014年3月间哪个月份治螨
    '''
    PROVINCE = "Province"
    COL_INIT_OCT = "COL_INIT_OCT"
    COL_LOSS = "COL_LOSS"
    COL_INIT_APR = "COL_INIT_APR"
    COL_END_APR = "COL_END_APR"
    PERMOVEHON = "PerMoveHon"
    NECTAR = "Nectar"
    VT = "VT"
    VT_ALL = "VT_ALL"
    VTXX = "VTXX"
    CDS = "CDS"
    LOSSNOFEED = "LossNoFeed"
    LOSSFEED = "LossFeed"
    QPROBLEM = "Qproblem"
    WINDECREASE = "WinDecrease"
    WINTMERGESOLD = "WintMergeSold"
    WINSPLIT = "WinSplit"
    RACE = "Race"
    QSOURCE = "QSource"
    QCHANGE = "QChange"
    QPROBLEM= "QProblem"
    NUMPOLSERVFREE = "NumPolServFree"
    NUMPOLSERV = "NumPolServ"
    HONEYINTAKE = "HoneyINTake"
    COMB = "Comb"
    SUPPLY = "Supply"

    fields = {
        PROVINCE: "ProvinceID",
        COL_INIT_OCT: "ColOct16",
        COL_LOSS: "Loss16-17",
        COL_INIT_APR: "ColApr16",
        COL_END_APR: "ColApr17",
        PERMOVEHON: "2016年进行转地的蜂群数",
        NECTAR: "2016年您的蜂群采集的蜜源有",
        VT: "VT",
        VT_ALL: "VT16All",
        VTXX: "VT##-**",
        CDS: 'CDS',
        LOSSNOFEED: "LossNoFeed",
        LOSSFEED: "LossFeed",
        QPROBLEM: "Qproblem",
        WINDECREASE: "WinDecrease",
        WINTMERGESOLD: "WintMerge/Sold",
        WINSPLIT: "WinSplit",
        RACE: "Race",
        QSOURCE: "蜂王的来源",
        QCHANGE: "QChange",
        QPROBLEM: "有多少群是由于蜂王有问题而换王的（蜂王伤残或产卵有问题）",
        NUMPOLSERVFREE: "NumPolServFree",
        NUMPOLSERV: "NumPolServ",
        HONEYINTAKE: "越冬期间有没有,可能将甘露蜜带入蜂巢",
        COMB: "Comb",
        SUPPLY: "SuppHoney/Sugar/Inver/HFCS/other",
    }


class ApiarySize(object):
    # 蜂场规模
    SMALL = "small"
    MEDIUM = "medium"
    LARGE = "large"

    @staticmethod
    def mapping_apiary_size(colony_number):
        # 根据蜂群数量返回蜂场规模
        # 用法： ApiarySize.mapping_apiary_size(colony_number)
        colony_number = int(colony_number)
        if colony_number < 50:
            return ApiarySize.SMALL
        elif colony_number >= 50 and colony_number < 200:
            return ApiarySize.MEDIUM
        else:
            return ApiarySize.LARGE



class Province(object):
    '''
    http://lhml.calis.edu.cn/calis/lhml/biaozhun/12.htm
    北京市  110000
    天津市 120000
    河北省 130000
    山西省 140000
    内蒙古自治区  150000
    辽宁省 210000
    吉林省 220000    
    黑龙江省    230000
    上海市 310000
    江苏省 320000
    浙江省 330000
    安徽省 340000
    福建省 350000
    江西省 360000
    山东省 370000
    河南省 410000
    湖北省 420000
    湖南省 430000
    广东省 440000
    广西壮族自治区 450000
    海南省 460000
    重庆市 500000
    四川省 510000
    贵州省 520000
    云南省 530000
    西藏自治区   540000
    陕西省 610000
    甘肃省 620000
    青海省 630000
    宁夏回族自治区 640000
    新疆维吾尔自治区    650000
    台湾省 710000
    香港特别行政区 810000
    澳门特别行政区 820000
    '''
    province_code = {
        "110000": "beijing",
        "120000": "tianjin",
        "130000": "hebei",
        "140000": "shanxi",
        "150000": "neimenggu",
        "210000": "liaoning",
        "220000": "jilin",
        "230000": "heilongjiang",
        "310000": "shanghai",
        "320000": "jiangsu",
        "330000": "zhejiang",
        "340000": "anhui",
        "350000": "fujian",
        "360000": "jiangxi",
        "370000": "shandong",
        "410000": "henan",
        "420000": "hubei",
        "430000": "hunan",
        "440000": "guangdong",
        "450000": "guangxi",
        "460000": "hainan",
        "500000": "chongqing",
        "510000": "sichuan",
        "520000": "guizhou",
        "530000": "yunnan",
        "540000": "xizang",
        "610000": "shaanxi",
        "620000": "gansu",
        "630000": "qinghai",
        "640000": "ningxia",
        "650000": "xinjiang",
        "710000": "taiwan",
        "810000": "xianggang",
        "820000": "aomen"
    }

    province_dict = {
        "北京": "beijing",
        "天津": "tianjin",
        "河北": "hebei",
        "山西": "shanxi",
        "内蒙": "neimenggu",
        "辽宁": "liaoning",
        "吉林": "jilin",
        "黑龙": "heilongjiang",
        "上海": "shanghai",
        "江苏": "jiangsu",
        "浙江": "zhejiang",
        "安徽": "anhui",
        "福建": "fujian",
        "江西": "jiangxi",
        "山东": "shandong",
        "河南": "henan",
        "湖北": "hubei",
        "湖南": "hunan",
        "广东": "guangdong",
        "广西": "guangxi",
        "海南": "hainan",
        "重庆": "chongqing",
        "四川": "sichuan",
        "贵州": "guizhou",
        "云南": "yunnan",
        "西藏": "xizang",
        "陕西": "shanxi",
        "甘肃": "gansu",
        "青海": "qinghai",
        "宁夏": "ningxia",
        "新疆": "xinjiang",
        "台湾": "taiwan",
        "香港": "xianggang",
        "澳门": "aomen"
    }
    @staticmethod
    def mapping_province_code(province_code):
        '''
        邮政编码映射省份
        '''
        province =  Province.province_code.get(province_code)
        if not province:
            return "unknown"
        return province
    

    @staticmethod
    def mapping_province_dict(province_input):
        '''
        中文映射省份
        '''
        if len(province_input) > 2:
            province_input = province_input[:2]
        province =  Province.province_dict.get(province_input)
        if not province:
            return "unknown"
        return province


class BeeType(object):
    WESTERN = "western"
    EASTERN = "eastern"

    type_code_dict = {
        "1": "western",
        "2": "western",
        "3": "western",
        "5": "western",
        "10": "western",
        "11": "eastern",
        "14": "western",
        "15": "western",
        "17": "western",
        "18": "western",
    }

    type_string_dict = {
        "中蜂": "eastern",
        "东方蜜蜂": "eastern",
        "杂交种": "western",
        "卡尼鄂拉蜂": "western",
        "东北黑蜂": "western",
        "喀蜂": "western",
        "中华蜂": "eastern",
        "喀意蜂": "western",
        "浆王": "western",
        "蜜、浆王": "western",
        "浆蜂": "western",
        "意蜂": "western",
        "高加索蜂": "western",
        "欧洲黑蜂": "western",
        "新疆黑蜂": "western",
        "安纳托利亚蜂": "western",
        "不知道": "western",
    }

    @staticmethod
    def mapping_bee_type_by_code(code):
        bee_type = BeeType.type_code_dict.get(code)
        if bee_type:
            return bee_type
        return "western"

    @staticmethod
    def mapping_bee_type_by_str(race):
        bee_type = BeeType.type_string_dict.get(race)
        if bee_type:
            return bee_type
        return "western"