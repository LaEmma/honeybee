# -*- coding: utf-8 -*-
import numpy as np
import scipy.stats 
import re
from file_import import ExcelImporter
from constants import DataImportFields1314, DataImportFields1415, \
    DataImportFields1516, DataImportFields1617, Province, ApiarySize
from utils import is_valid_data


class DataController(object):
    """docstring for DataController"""
    def __init__(self):
        super(DataController, self).__init__()
        self.confidence = 0.95
        self.loss_rate = {}
        self.province_list = set()


    def analysis(self):

        # 1314年数据读入
        # 数据清洗，过滤掉无效数据
        # import pdb; pdb.set_trace()
        filepath = '/Users/liuchao/work3/honey_bee/181029/data/DataExport_13-14_LZG.xlsx'
        raw_data_1314 = self.get_raw_excel_data(DataImportFields1314.fields, filepath)
        data_1314 = self.clean_raw_data_1(raw_data_1314)
        
        # 1415年数据读入
        # 数据清洗，过滤掉无效数据
        filepath = '/Users/liuchao/work3/honey_bee/181029/data/DataExport-COLOSS14-15.xlsx'
        raw_data_1415 = self.get_raw_excel_data(DataImportFields1415.fields, filepath)
        data_1415 = self.clean_raw_data_1(raw_data_1415)

        # 1516年数据读入
        # 数据清洗，过滤掉无效数据
        # import pdb; pdb.set_trace()
        filepath = '/Users/liuchao/work3/honey_bee/181029/data/Data-coloss15-16.xlsx'
        raw_data_1516 = self.get_raw_excel_data(DataImportFields1516.fields, filepath)
        data_1516 = self.clean_raw_data_2(raw_data_1516)

        # 1617年数据读入
        # 数据清洗，过滤掉无效数据
        filepath = '/Users/liuchao/work3/honey_bee/181029/data/Data-coloss 16-17.xlsx'
        raw_data_1617 = self.get_raw_excel_data(DataImportFields1617.fields, filepath)
        data_1617 = self.clean_raw_data_2(raw_data_1617)

        # 分析损失率
        # 按年份损失率
        total_col_init_oct_1314 = [int(item.get('COL_INIT_OCT')) for item in data_1314]
        total_col_loss_1314 = [int(item.get('COL_LOSS')) for item in data_1314]
        loss_rate_1314 = self.cal_total_loss_rate(total_col_init_oct_1314, total_col_loss_1314)
        self.loss_rate['13-14'] = loss_rate_1314

        total_col_init_oct_1415 = [int(item.get('COL_INIT_OCT')) for item in data_1415]
        total_col_loss_1415 = [int(item.get('COL_LOSS')) for item in data_1415]
        loss_rate_1415 = self.cal_total_loss_rate(total_col_init_oct_1415, total_col_loss_1415)
        self.loss_rate['14-15'] = loss_rate_1415

        total_col_init_oct_1516 = [int(item.get('COL_INIT_OCT')) for item in data_1516]
        total_col_loss_1516 = [int(item.get('COL_LOSS')) for item in data_1516]
        loss_rate_1516 = self.cal_total_loss_rate(total_col_init_oct_1516, total_col_loss_1516)
        self.loss_rate['15-16'] = loss_rate_1516

        total_col_init_oct_1617 = [int(item.get('COL_INIT_OCT')) for item in data_1617]
        total_col_loss_1617 = [int(item.get('COL_LOSS')) for item in data_1617]
        loss_rate_1617 = self.cal_total_loss_rate(total_col_init_oct_1617, total_col_loss_1617)
        self.loss_rate['16-17'] = loss_rate_1617
        

        # 总损失率
        total_data = data_1314 + data_1415 + data_1516 + data_1617
        total_col_init_oct = total_col_init_oct_1314 + total_col_init_oct_1415 + \
                            total_col_init_oct_1516 + total_col_init_oct_1617
        total_col_loss = total_col_loss_1314 + total_col_loss_1415 + \
                            total_col_loss_1516 + total_col_loss_1617
        total_loss_rate = self.cal_total_loss_rate(total_col_init_oct, total_col_loss)
        self.loss_rate['total'] = total_loss_rate
        
        # 按省份损失率
        self.loss_rate['province'] = {}
        province_col_init = {}
        province_col_loss = {}
        for item in total_data:
            province = item['Province']
            col_init = int(item.get('COL_INIT_OCT'))
            col_loss = int(item.get('COL_LOSS'))

            if province not in province_col_init.keys():
                province_col_init[province] = [col_init]
                province_col_loss[province] = [col_loss]
            else:
                province_col_init[province].append(col_init)
                province_col_loss[province].append(col_loss)
        # print(province_col_init)
        for province in self.province_list:
            province_loss_rate = self.cal_total_loss_rate(province_col_init[province], province_col_loss[province])
            self.loss_rate['province'][province] = province_loss_rate

        import pdb; pdb.set_trace()
        # 按蜂群大小损失率
        self.loss_rate['apiary'] = {}
        apiary_col_init = {}
        apiary_col_loss = {}
        for item in total_data:
            apiary = item['ApiarySize']
            col_init = int(item.get('COL_INIT_OCT'))
            col_loss = int(item.get('COL_LOSS'))

            if apiary not in apiary_col_init.keys():
                apiary_col_init[apiary] = [col_init]
                apiary_col_loss[apiary] = [col_loss]
            else:
                apiary_col_init[apiary].append(col_init)
                apiary_col_loss[apiary].append(col_loss)
        # print(apiary_col_init)
        for apiary in [ApiarySize.SMALL, ApiarySize.MEDIUM, ApiarySize.LARGE]:
            apiary_loss_rate = self.cal_total_loss_rate(apiary_col_init[apiary], apiary_col_loss[apiary])
            self.loss_rate['apiary'][apiary] = apiary_loss_rate


        '''
        {'14-15': (0.11516167557015994, 0.10275074376876998, 0.1275726073715499), 
        '16-17': (0.09276281408596232, 0.08539412757129532, 0.10013150060062932), 
        'total': (0.10097859910256822, 0.0967598904044299, 0.10519730780070655), 
        '13-14': (0.09469177253805378, 0.08764194209700885, 0.1017416029790987), 
        '15-16': (0.11110466980145861, 0.1026427608405073, 0.11956657876240992),
        'province': {'beijing': (xxx, xxx, xxx)}}
        '''
        print(self.loss_rate)
    def get_raw_excel_data(self, importfields, filepath):
        # 读取excel的数据
        excel_importer = ExcelImporter(importfields)
        file_data = excel_importer.import_file(filepath)
        if not file_data:
            return None
        print("reading %s" % filepath)
        return file_data
    
    def clean_raw_data_1(self, raw_data):
        '''
        清洗1314  1415年数据
        OrderedDict([('VT201', '2'), ('VT103', '2'), ('LossNoFeed', '0'), ('Vitex', '2'), 
        ('PercPolServ', '100'), ('Locust', '2'), ('DewHive', '2'), ('WintDecreae', '0'), 
        ('Rape', '2'), ('NumPolServ', '0'), ('OtherNectar', ''), ('Race', '3'), ('Longan', '1'), 
        ('VT106', '2'), ('VT104', '1'), ('VT012', '2'), ('Jujube', '2'), ('COL_END_APR', '140'), 
        ('Sunflower', '2'), ('SuppBInvert', '2'), ('VT101', '2'), ('VT111', '1'), ('VT202', '2'), 
        ('QCol', '2'), ('QChange', '2'), ('QProblem', '0'), ('SuppOther', ''), 
        ('ProvinceID', '460000'), ('VT_ALL', '1'), ('NumPolSerFree', '100'), ('CDS', '0'), 
        ('LossFeed', '0'), ('VT109', '1'), ('WintSold', '40'), ('Linden', '2'), ('COL_LOSS', '0'), 
        ('Comb', '30'), ('OtherRace', ''), ('VT105', '2'), ('VT107', '2'), ('Litchi', '1'), 
        ('Loquat', '2'), ('VT110', '2'), ('VT203', '2'), ('COL_INIT_APR', '130'), ('WintMerge', '0'), 
        ('VT108', '2'), ('VT112', '1'), ('VT102', '2'), ('QOp', '1'), ('QBreed', '2'), 
        ('SuppHoney', '1'), ('COL_INIT_OCT', '105'), ('WintSplit', '45'), ('SuppHFCS', '2'), 
        ('PerMoveHon', '100'), ('VT011', '2'), ('SuppBSugar', '1'), ('Qnew', '0')])
        '''
        # import pdb; pdb.set_trace()
        data = []
        print("cleaning data 1...")
        rows = sorted([int(key) for key in raw_data.keys()])
        for key in rows:
            row_value = {}
            value = raw_data.get(str(key))
            init_colony_num = value.get("COL_INIT_OCT", 0)
            loss_colony_num = value.get("COL_LOSS", 0)
            # 过滤掉无效数据
            if is_valid_data(init_colony_num, loss_colony_num) != True:
                continue
            # 添加数据处理的过程
            row_value['COL_INIT_OCT'] = init_colony_num
            row_value['COL_LOSS'] = loss_colony_num
            # 省份
            province_code = value.get("ProvinceID", 0)
            province = Province.mapping_province_code(province_code)
            value['Province'] = province
            row_value['Province'] = province
            self.province_list.add(province)
            # 蜂群大小
            apiary_size = ApiarySize.mapping_apiary_size(init_colony_num)
            value['ApiarySize'] = apiary_size
            row_value['ApiarySize'] = apiary_size
            # 蜂群种类： 西蜂。。。


            data.append(value)

        return data


    def clean_raw_data_2(self, raw_data):
        '''
        1516  1617年数据
        读入数据
        [OrderedDict([('Province', '四川'), ('Race', ' 杂交种、卡尼鄂拉蜂'), ('COL_INIT_APR', 380), 
        ('NumPolServFree', 380), ('WinSplit', 0), ('COL_INIT_OCT', 320), ('Supply', '蜂蜜、白糖'), 
        ('PerMoveHon', 380), ('WinDecrease', 0), ('QChange', 2), ('Nectar', '油菜、 洋槐、枣花'), 
        ('COL_END_APR', 310), ('CDS', 0), ('NumPolServ', 0), ('VTXX', '2014.12，2015.6.12'), 
        ('LossFeed', 0), ('VT_ALL', '是'), ('Comb', 30), ('QSource', '自己移虫育王'), ('COL_LOSS', 20), 
        ('LossNoFeed', 0), ('QProblem', 0), ('WintMergeSold', 0)])]
        '''
        data = []
        # import pdb; pdb.set_trace()
        print("cleaning data 2...")
        rows = sorted([int(key) for key in raw_data.keys()])
        for key in rows:
            row_value = {}
            value = raw_data.get(str(key))
            init_colony_num = value.get("COL_INIT_OCT")
            col_loss = value.get("COL_LOSS")
            # 损失群里有可能有数字加文字，只取数字
            col_loss = re.search(r'\d+', str(col_loss))
            if col_loss:
                loss_colony_num = col_loss.group()
            else:
                loss_colony_num = 0
            if is_valid_data(init_colony_num, loss_colony_num) != True:
                continue
            # 添加数据处理的过程
            row_value['COL_INIT_OCT'] = init_colony_num
            row_value['COL_LOSS'] = loss_colony_num
            value['COL_LOSS'] = loss_colony_num
            # 省份
            province_input = value.get("Province", "0")
            province = Province.mapping_province_dict(province_input)
            value['Province'] = province
            row_value['Province'] = province
            self.province_list.add(province)
            # 蜂群大小
            apiary_size = ApiarySize.mapping_apiary_size(init_colony_num)
            value['ApiarySize'] = apiary_size
            row_value['ApiarySize'] = apiary_size
            # 蜂群种类： 西蜂。。。



            data.append(value)

        return data

    def cal_total_loss_rate(self, total_colony_num, total_loss_num):
        loss_rate = 0
        loss_rate = self.mean_confidence_interval(list(map(lambda x,y: x/y, total_loss_num, total_colony_num)))
        return loss_rate

    def mean_confidence_interval(self, data):
        # 计算置信区间
        a = 1.0 * np.array(data)
        n = len(a)
        m, se = np.mean(a), scipy.stats.sem(a)
        h = se * scipy.stats.t.ppf((1 + self.confidence) / 2., n-1)
        return m, m-h, m+h


if __name__ == "__main__":
    # import pdb; pdb.set_trace()
    dc = DataController()
    dc.analysis()
